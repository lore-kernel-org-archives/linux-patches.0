Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025683;
	b=gDvDpiCqppTk32evn+5omwqsVuecEy6NhY4Q8GBBEU5VcY4D+ufRPM7etH6fFVp5IsZL
	 30VvGFytigcsTkCjvfNo7sd1bHJnPRCl0y9Q7OxjYM3PU//5Y2paufwIXk5CvpPKHG6GJ
	 vxyptdZIfHhQHpfAwYyzt0+Bx0SUGzTPRGwVHGPK0hJy6wRicSHYxgOdsXK7P+Nk04OJJ
	 ja8p+neLpn/aMt9p/vdIBb9O/DuPg1rn382Z8CQ/zIiefls2tU0gjQgmJXlb6mwl/vJBU
	 T+zq6722ODtMvfBVZwx7Mct120IX9H0gIbzBYbYuQ0MBzfBaZk5MbO5guaGwajguaag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DO4Ego+/mXUHdEV88MeA1g7ZGAY+2DaGb3/r4iHd66Q=;
	b=KsRUJKBxeD0hb4hcSAwYwJsRlVlVReACwcljnmQavMifETXVJ6eu4yh5r/ti/TyJjbPB
	 BowMoSDpfq4Qm9Y7EnNsDih1/Nmi7qMr9gEZFJvX70UQfiI6HqjszJ3HjN3nMg68oT2gL
	 VOJnitq+mhbwaOhXhiN5p0GRwo3jQJ/jdLnOKhCM9eSLI1ps20z2OQPFeW8D1u5frrd85
	 Cgmfsrh5vaLuDB0DYjdZA+EPBCjbT32yFUS8G+ao8D1nd82xjTdzxwRbXxJByrB6BWcxM
	 JnOdvbShwOOy+w1QH8Kc+IZDSKu4JHptGBv8lTbElZeMF9FWbQ/9do+ycjb7oIeYESw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frTH0MxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEC8606A325;
	Wed, 18 Nov 2026 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frTH0MxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A4B1F000C4;
	Wed, 18 Nov 2026 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025683;
	bh=DO4Ego+/mXUHdEV88MeA1g7ZGAY+2DaGb3/r4iHd66Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frTH0MxYE919lIWyOgmadCddJCS6hmxiNUcaVsS80EhzsXAMP79fNvzmkX4jtlkrG
	 mNQdFz6TNMcMTwk3Uz85nQEEXNsbroOclqPDd+71QRGVZEsDlH6WAnvYXgLu96Kw0g
	 x3rsphbRii1/y1EISobigMGI1VJTticItyhuZzII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1167/2151] nilfs2: fix link count underflow when removing corrupted directory
Date: Wed, 18 Nov 2026 15:48:22 +0100
Message-ID: <20261118150204.659374826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 814f5a53b4724798795b15690ff3d1c1d9ac1eb6 ]

When removing an empty directory with a corrupted link count (e.g.,
i_nlink is 1 due to filesystem corruption), nilfs_rmdir() calls
drop_nlink() via nilfs_do_unlink() and then calls drop_nlink() again
on the directory inode.  This second call causes an underflow of
i_nlink, triggering a kernel WARNING in drop_nlink().

Fix this issue by using clear_nlink() instead of drop_nlink() to
finalize the link count reset for the target directory in nilfs_rmdir().
Additionally, log a warning message when i_nlink is not 2 before
removing an empty directory to notify about the link count inconsistency.

Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c388db0347b7fc88fa7a
Fixes: d25006523d0b ("nilfs2: pathname operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/namei.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 4132be9810a05..bdaee1340c7f0 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -341,10 +341,16 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	err = -ENOTEMPTY;
 	if (nilfs_empty_dir(inode)) {
+		if (unlikely(inode->i_nlink != 2))
+			nilfs_warn(dir->i_sb,
+				"inconsistent empty directory link count %u (ino=%llu)",
+				inode->i_nlink,
+				(unsigned long long)inode->i_ino);
+
 		err = nilfs_do_unlink(dir, dentry);
 		if (!err) {
 			inode->i_size = 0;
-			drop_nlink(inode);
+			clear_nlink(inode);
 			nilfs_mark_inode_dirty(inode);
 			drop_nlink(dir);
 			nilfs_mark_inode_dirty(dir);
-- 
2.53.0



