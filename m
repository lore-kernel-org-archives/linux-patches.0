Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197B1311967;
	Sat, 12 Sep 2026 14:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222240; cv=none; b=WDPkO/9xqIiKJZu4jpFv9ssuYdmhGPnl+xhC0Ejc8suFLwzAXU/uVFfQXghY1XGEz9P7WUBJggC9DJLKF9k7cG9blbNIDPlipLqaR87kdofXZu+W4jIKonQ55zBnTB382KO3I9D6WL/GKmi22PghOj5h4utL/ocCUW1PBZANS/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222240; c=relaxed/simple;
	bh=Ho9ytiTOSK0VNFkwdVnoPG3Z8ksNxp6EmPGsuzt/B/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0MD9/R0cjvgwu1kusZO6Wrzr37qwmw2E+Q415LTRy9zB6nVXnWyGQP/cRh/gkH4eYwKdAwUHvcqeQyu3oENow3+Ci6OqB5EtN+Wx5HsHE+uEYRbJ2sh2Y8hWLtL2vojav00p9TspbNqaCJLCBPyInxUZUqChUZvTo7TOcOdY4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mr4fPGcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mr4fPGcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0781F000FF;
	Sat, 12 Sep 2026 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222239;
	bh=u8JJYVMM1l1wd69L1+RKB+qMPW2NUTnhkyh3e4DPYt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mr4fPGcbfNRum7ITHJf44qqbVA1IPRYFlQmoDGCvQpOIdq7x1mVm+TVXxPXZMfC8o
	 P2v4dJWz9zwAnRc4gNnR75x315T64SIMR39+hkUTTRDFGXnf0EYJhZZWwA3R2nHSM5
	 p1H27zRmLvaifP3ewuYXSaXaM5JUIvuPR+ooIRZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Daniel Vogelbacher <daniel@chaospixel.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0547/1424] ceph: fix oops due to invalid pointer for kfree() in parse_longname()
Date: Sat, 12 Sep 2026 08:49:39 +0200
Message-ID: <20260912065619.552318972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vogelbacher <daniel@chaospixel.com>

[ Upstream commit bc8dedae022ce3058659c3addef3ec4b41d15e00 ]

This fixes a kernel oops when reading ceph snapshot directories (.snap),
for example by simply running `ls /mnt/my_ceph/.snap`.

The variable str is guarded by __free(kfree), but advanced by one for
skipping the initial '_' in snapshot names. Thus, kfree() is called
with an invalid pointer.  This patch removes the need for advancing the
pointer so kfree() is called with correct memory pointer.

Steps to reproduce:

1. Create snapshots on a cephfs volume (I've 63 snaps in my testcase)

2. Add cephfs mount to fstab
$ echo "samba-fileserver@.files=/volumes/datapool/stuff/3461082b-ecc9-4e82-8549-3fd2590d3fb6      /mnt/test/stuff   ceph     acl,noatime,_netdev    0       0" >> /etc/fstab

3. Reboot the system
$ systemctl reboot

4. Check if it's really mounted
$ mount | grep stuff

5. List snapshots (expected 63 snapshots on my system)
$ ls /mnt/test/stuff/.snap

Now ls hangs forever and the kernel log shows the oops.

Cc: stable@vger.kernel.org
Fixes: 101841c38346 ("[ceph] parse_longname(): strrchr() expects NUL-terminated string")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220807
Suggested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Daniel Vogelbacher <daniel@chaospixel.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index f98f120d0fd7d..42b066729d97c 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -216,12 +216,13 @@ static struct inode *parse_longname(const struct inode *parent,
 	struct ceph_vino vino = { .snap = CEPH_NOSNAP };
 	char *name_end, *inode_number;
 	int ret = -EIO;
-	/* NUL-terminate */
-	char *str __free(kfree) = kmemdup_nul(name, *name_len, GFP_KERNEL);
+	/* Snapshot name must start with an underscore */
+	if (*name_len <= 0 || name[0] != '_')
+		return ERR_PTR(-EIO);
+	/* Skip initial '_' and NUL-terminate */
+	char *str __free(kfree) = kmemdup_nul(name + 1, *name_len - 1, GFP_KERNEL);
 	if (!str)
 		return ERR_PTR(-ENOMEM);
-	/* Skip initial '_' */
-	str++;
 	name_end = strrchr(str, '_');
 	if (!name_end) {
 		doutc(cl, "failed to parse long snapshot name: %s\n", str);
-- 
2.53.0



