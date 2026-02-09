Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3542BEC45;
	Mon,  9 Feb 2026 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647739; cv=none; b=RW9TxeJE4JHiqaAlnDHEc7yA1G79EeKV4fnNvB5PrNoEelMDWvFbRiX3ScppL/LLTQy6hU4z46IrXSJ0+2xhGwGUYakJEP8h39WkY0dpRerDevg51dK4/3i2h4XrMxE2JAH8efAwexWf/Bn6YZjVKuUuQbXWX84DAyiVDqJOTp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647739; c=relaxed/simple;
	bh=BDiMgXNRNlkWtM1ye9S2LpXCKoGoNXnYwyUG7yRX3Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6fsAorOD4PUHJhU+RVmXTHQ98ulCToOogWMXYg0IuiaaTG1EchW8A+qN8jlHiM7BpG48WpqcEvD2p/x5gp1bH81wpyIlODl1vtgNSFltD3pWRLWv7BEB0varbiviOZ9vixVqIVFIuWYe1kb8rNtiRd9Py5yTuRBADC6CmXhOtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5pvu48z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5pvu48z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C302C16AAE;
	Mon,  9 Feb 2026 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647739;
	bh=BDiMgXNRNlkWtM1ye9S2LpXCKoGoNXnYwyUG7yRX3Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5pvu48zBuznpH8uEqzw8JRj/1yZlayZCmYMJ14pm1EOydpm94ENWc104juLfbolr
	 ChYYIQx5D87fSkAI/nZH80aN3drAlmQKYjp6XR5Wl65CM/R2TCtfQ1Kvwz0yS/IaZ4
	 cxvbQDc4j9/gLZK+n8fcSWSAp5+APYnXZPvh2/5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Daniel Vogelbacher <daniel@chaospixel.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 015/113] ceph: fix oops due to invalid pointer for kfree() in parse_longname()
Date: Mon,  9 Feb 2026 15:22:44 +0100
Message-ID: <20260209142310.758340647@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vogelbacher <daniel@chaospixel.com>

commit bc8dedae022ce3058659c3addef3ec4b41d15e00 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/crypto.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -217,12 +217,13 @@ static struct inode *parse_longname(cons
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


