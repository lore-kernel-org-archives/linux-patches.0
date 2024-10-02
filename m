Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F0F1D0DEB;
	Wed,  2 Oct 2024 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878400; cv=none; b=pn7yv0q63iAqYy5lwk8F/2xwfqPfN61TodTprwgM6Kj+Fw3Prv/ytiUXEdFwDC8gC/WpIa7oQ9Mf7IXpNs6xqYE1XuIK5zgCSLkArtjDlCxu9F05F4yylap+OoWUJrAfquRLv2GbTesOsfQkXbSFTQjs8/uoUylcIfj0OX/kqrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878400; c=relaxed/simple;
	bh=NyW0tfCRx5ChDGAIZebPIVZks4U7ghdMnarx3ZFrlRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx8dodPH5bZ3OipkAKXyOTq9URNjEa/eJmh05kLCrcxq3gfEVZcYlkmWkD63Np1mpf0vqkIHs0JEfIToAbiUkztTzpJjsY3RbAImgThRBkC6u8gjyJ0UgIq+j/CCpjW64jkDiH3A3rn5tAmu4xFHisclgQCyLBrMPVhCuUQiWr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMaw6tWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMaw6tWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60408C4CEC2;
	Wed,  2 Oct 2024 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878399;
	bh=NyW0tfCRx5ChDGAIZebPIVZks4U7ghdMnarx3ZFrlRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMaw6tWU2Bnr0EVuejCl5YVW+shsetULeb/icOnVpr8OiVnhzFDpQChMpOciZtibJ
	 g+wYXo8UNK1J9cl0TSKEQpbnG7dPVn1CxVAtwjtJm1aA7iqLMjoMfXj5KqGvWHOX0L
	 TOSRvoVwkog23IHTFPfFvV1Cp9C3kHKA7awnMEzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 399/634] f2fs: Create COW inode from parent dentry for atomic write
Date: Wed,  2 Oct 2024 14:58:19 +0200
Message-ID: <20241002125826.854159613@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeongjin Gil <youngjin.gil@samsung.com>

[ Upstream commit 8c1b787938fd86bab27a1492fa887408c75fec2b ]

The i_pino in f2fs_inode_info has the previous parent's i_ino when inode
was renamed, which may cause f2fs_ioc_start_atomic_write to fail.
If file_wrong_pino is true and i_nlink is 1, then to find a valid pino,
we should refer to the dentry from inode.

To resolve this issue, let's get parent inode using parent dentry
directly.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Sunmin Jeong <s_min.jeong@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ad326c0ab5bd7..19da00ab31aeb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2120,7 +2120,6 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	struct mnt_idmap *idmap = file_mnt_idmap(filp);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct inode *pinode;
 	loff_t isize;
 	int ret;
 
@@ -2170,15 +2169,10 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	/* Check if the inode already has a COW inode */
 	if (fi->cow_inode == NULL) {
 		/* Create a COW inode for atomic write */
-		pinode = f2fs_iget(inode->i_sb, fi->i_pino);
-		if (IS_ERR(pinode)) {
-			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-			ret = PTR_ERR(pinode);
-			goto out;
-		}
+		struct dentry *dentry = file_dentry(filp);
+		struct inode *dir = d_inode(dentry->d_parent);
 
-		ret = f2fs_get_tmpfile(idmap, pinode, &fi->cow_inode);
-		iput(pinode);
+		ret = f2fs_get_tmpfile(idmap, dir, &fi->cow_inode);
 		if (ret) {
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 			goto out;
-- 
2.43.0



