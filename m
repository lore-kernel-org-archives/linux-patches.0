Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77C117BED0;
	Sat, 17 Oct 2026 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257938; cv=none; b=Z11VpxTD9gKrZhIEm8O4gdqQOroHuK1z7OF/avLGUZo0L+rKu2pSIgxj/mSwuhX4n3RzIq8iy+beAodh8C1A2HYYviG65KLB2sppX+Ud0Ra2uTq98BN4OcoF31WJZO5T/KBQXj45r9221QK7ct9z7OfH+dGFdMQGjnzRWKSPcqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257938; c=relaxed/simple;
	bh=daVlqO3idxh92rSHe6L3m6YDvS/cnR34W8OyF7E16W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiMaZkmPC2lip01YN+zr5GG4TqeBOcrq3b/Qk00QDeb9ZEIB0erd5fAxEWs2wahVAZnUGRQJqCrBjkl4CZgulX7VjCOzu/CoHhXQ6tx+/+F7A42GOyCJpwqKoDMoyKnavv/nEBd++HLREus+kqkDu2HpIbPLsMkthNCaltaMcYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmMAeF/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmMAeF/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480DF1F000C4;
	Sat, 17 Oct 2026 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257937;
	bh=0gT7d0cI30L9fXuNh1C4Doh3dbJsDlEguVJrPQca09Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmMAeF/uP6qzXzk5w0LNSBa7jaf0ICMGl+i2uYsL2FYU8PogwsFI1t6puEsaO914v
	 ZwSN+wJS2+DJpVGbpEfFREYuZ9EYypgfsIU8MPUN9aXucVFhMDVzKUllAfzeEGuri1
	 SM2JlfRiiVx66/oyoJqU4zOdTq2ZpPdMUaAlGmi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0720/1674] fs/ntfs3: Use function file_inode to get inode from file
Date: Sat, 17 Oct 2026 17:49:52 +0200
Message-ID: <20261017160449.589502161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit b9906f8162478c778c5212720efb19633a458ade ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 285cec318bf5 ("fs/ntfs3: Keep write operations atomic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 3eee810c69e2f..18753121159c5 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -253,8 +253,7 @@ static int ntfs_zero_range(struct inode *inode, u64 vbo, u64 vbo_to)
  */
 static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
+	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
 	u64 from = ((u64)vma->vm_pgoff << PAGE_SHIFT);
 	bool rw = vma->vm_flags & VM_WRITE;
@@ -430,7 +429,7 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
  */
 static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 {
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
@@ -736,7 +735,7 @@ int ntfs3_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 static ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
 
 	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
@@ -773,7 +772,7 @@ static ssize_t ntfs_file_splice_read(struct file *in, loff_t *ppos,
 				     struct pipe_inode_info *pipe, size_t len,
 				     unsigned int flags)
 {
-	struct inode *inode = in->f_mapping->host;
+	struct inode *inode = file_inode(in);
 	struct ntfs_inode *ni = ntfs_i(inode);
 
 	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
@@ -1071,8 +1070,7 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
+	struct inode *inode = file_inode(file);
 	ssize_t ret;
 	int err;
 	struct ntfs_inode *ni = ntfs_i(inode);
-- 
2.53.0



