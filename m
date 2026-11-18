Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040953;
	b=3i1R11lteHexZj9ssrDh/GLHJ5bnjGeFzGaGHZZvq6JYpUycnf0tr8Afo3B8Vzllc4L7
	 FuTKYjsjaMeLHUdh/FcaWhWqOp9+dChgeM5u8OHanZVdtv32KEfO9n6hl3CCT6E74AG3U
	 xjjGaWvaRt/M1ZPLAwqccryVnPqBNnSDvy0ez4q+TbHjrcTWRliG9Kn1poLPqHMI77PpL
	 o1ey0TOo/s2DvwD5v9Y4Gj9UaDlYzv4OY7YIKRBBmI9Q3JU6AHxlLe6IjMoNzj0IjUfPv
	 zXiQDcNB4rJ73FJd2cJItNpnbjxQbrhSUCPwwQ/+GNFwDZQWbYVI6HkQucjGsqNfbug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G02aMgNo8Na5iAbEmbWZQP1Rhcm86CKQe/ZYczQiEko=;
	b=evsC4OUVm6/M7aYAg1o2RphH4b7glaxZI2GepJQr12zt81Ug2MNjYahLZQD33fh1fOF2
	 q34bc7ScF3R4UQmDQTEcqr/jI2TZ3/e7DDaG6oK5joQ3pjTg347/8sCTcloTCT43zluRD
	 Melrp1u1OI7NcOdKYxXibGbh3IlQhiloSEpui/5yU7cpdEVcuFi0/bUGrHMjrgSGra8Hi
	 9y6WXJR4h0mRNoB9m0kToumYpaw+n0mZLlPLbT6LZVnKY3kbId/h350kI6HI6GDW0pxXo
	 tlWH9zjL0qDdvAR31p25IPqXTYFLf5J1eJEjYgzd9fZWW9o/9+h+GCQsk3hKpEMcI3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqoCxuEA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D4B606A325;
	Wed, 18 Nov 2026 22:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqoCxuEA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6F31F000C4;
	Wed, 18 Nov 2026 22:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040953;
	bh=G02aMgNo8Na5iAbEmbWZQP1Rhcm86CKQe/ZYczQiEko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqoCxuEAIU8FT8lBG1GOjQYkAKIGGN64kFWIzQlv6RxRIcesOHHCHZS4CPWD0pS8o
	 VYYqF7gdp+kZ47Le8ymd4zmd8Dz41Oy/5khwC4a4xWgiDcKgaGZHsfwM/viw7Hp9E+
	 Fuw3PFKe3bjnhf/ghShgTDmB4d+DRORTtGWvnqlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2641/3318] nilfs2: fix link count underflow when removing corrupted directory
Date: Wed, 18 Nov 2026 15:54:23 +0100
Message-ID: <20261118150440.302241583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 43f01fe556fe1..1a84f8587f422 100644
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



