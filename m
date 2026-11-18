Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018851;
	b=Q+DhM4Qy8oUL7Z+na2o2eg0W8UxBMLftrlotIK+9Bg4STIwrmFDY730RVCktYsfrQ7+U
	 kn4xMkAKz/4dcf7U9359T7NelSD1MZNiE/ifwaMIlzSE32g1NTfyBmf85j7L914iVT8yK
	 9v2jg6XkRkzcygwqTE103JxNFaqG9QalFo8q8T+gszGu3rOPczjpGAqUnvr5k9qDqSNNd
	 dygAMHiIp6yFB5FkImVS2S/0YPezBu2DaB2IBErsJDMuU1zloGNCasifMpB++wJgrNT80
	 fM6HfFXju2Sw4A7DzR+AiOjo8vJiwocgCxtYdEE1+I/C3Ei9DN/N/ivrYZnvR+URjfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r/ti0EudLSujIbhMUi6Tody4uluzcd2pu6aa6RKPUPw=;
	b=1cJbm0uGx0X7rrMQWeOosbU9duNd+0ppoH6CxrLfBbWr1SZLLlAm2Gegd6QKsKk5I7FC
	 qAcwjpmkEAjyROV5a4sSxAsrWU3VUvGc93P286F6NUWQllqVmKJjOwTIocLAQ3D02hZoQ
	 XYUPpxZOT+8k+8XuwlDUhaHM0pnRzr+wfoHReP12/YHSrcWk1JvHpmKE2oNxcrtdrfZmL
	 X74HVg7wVE0yTvCV8asSVo8HiYIqvNu34tF+oNlQBzorA1YfqjZE4TDgQXp44/TO0bvnh
	 jAvnWouY+uPLS3DCtBZjHbaqySR9Sy3o38M/RfpSZzbdODI3/uTtuj/iS2SUNQDZxJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1DeM6F9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ABE606A31C;
	Wed, 18 Nov 2026 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1DeM6F9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC281F000C5;
	Wed, 18 Nov 2026 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018851;
	bh=r/ti0EudLSujIbhMUi6Tody4uluzcd2pu6aa6RKPUPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1DeM6F9GpzDb1Nuo/xy8Y+oIUfRpFYzFDO+a0+ntyYh27C5szGafS7UZAyioQ+MY
	 6y/TpyMXSPsAn+PtqBoUDbLdx0AmN2UnJT2kgvfc3bBqG7tRSStsb8XjNxO77BFLg6
	 nqf3Ne88k2fanXmLvb75jbySqlJOadrm3JvSjYH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1386/2651] nilfs2: fix link count underflow when removing corrupted directory
Date: Wed, 18 Nov 2026 15:43:46 +0100
Message-ID: <20261118150337.910346872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e037e0c6e31a3..d326bb1acb118 100644
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



