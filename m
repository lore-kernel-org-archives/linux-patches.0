Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C62917BED0;
	Sat, 17 Oct 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257942; cv=none; b=EGZ+erJNB5CBShOb4Az1LbLRglKL1X+GyqAOCIsz4ikDAXBQmS9lWxAgfU67ypVF/LNsrWxtKo5anDGQNx0amEit1HVAzULwMEJbya0iVKMsQ4GFPXX//bI8Iq0rM9ahqnWFcCak/iXDNTmU65656jbD5fuC+SXHomLe3zztwVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257942; c=relaxed/simple;
	bh=f23Q5aNMS+zf02JOUlocIZozUvzYO6yxUyUrnxl94Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAsrzpjV5T22RyxEkc1jKI8FMqm9EwcEqdbb9L3sjsZoxcKXIp+CbnAkWYDfAbhqjKhWxtnhi9vbymNuKuJmbsp556IvIsag7JCchidQZmQMTYguD+57rxA07TW+u2cRncpg0HH9Y7sCUJHFInefvNI4qe2gyGwsePv01PB5MTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7WDl1rP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7WDl1rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F921F000C4;
	Sat, 17 Oct 2026 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257940;
	bh=kSsUfll/XVi0PChrDCggdK2WYNhiPVCCR8pxKUiMGko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7WDl1rPAEX/K2Rr2Al2KpbV7hibEy5numjUlIyvKajOj1gngLHVS3o0e1Hrj4bwC
	 WrLX7xeBdphl9gw+mlnBcKGM65BvcXrCpAWZN6e0goOaXaDp+UFYlS3hHO87YuuQ1S
	 vi/ocn/L49Tq3mFzScndPqiW8+Za/Wd0vD2TLxbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0721/1674] fs/ntfs3: Separete common code for file_read/write iter/splice
Date: Sat, 17 Oct 2026 17:49:53 +0200
Message-ID: <20261017160449.615759596@linuxfoundation.org>
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

[ Upstream commit e4a7d60a891b8493a1284053acdc496febe81e7c ]

The common code for handling encrypted, dedup, and compressed files
has been moved to check_read_restriction() and check_write_restriction().

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 285cec318bf5 ("fs/ntfs3: Keep write operations atomic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 116 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 40 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 18753121159c5..490225b30e600 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -732,10 +732,12 @@ int ntfs3_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	return err;
 }
 
-static ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+/*
+ * check_read_restriction:
+ * common code for ntfs_file_read_iter and ntfs_file_splice_read
+ */
+static int check_read_restriction(struct inode *inode)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
 
 	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
@@ -746,11 +748,6 @@ static ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		return -EOPNOTSUPP;
 	}
 
-	if (is_compressed(ni) && (iocb->ki_flags & IOCB_DIRECT)) {
-		ntfs_inode_warn(inode, "direct i/o + compressed not supported");
-		return -EOPNOTSUPP;
-	}
-
 #ifndef CONFIG_NTFS3_LZX_XPRESS
 	if (ni->ni_flags & NI_FLAG_COMPRESSED_MASK) {
 		ntfs_inode_warn(
@@ -765,37 +762,44 @@ static ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		return -EOPNOTSUPP;
 	}
 
-	return generic_file_read_iter(iocb, iter);
+	return 0;
 }
 
-static ssize_t ntfs_file_splice_read(struct file *in, loff_t *ppos,
-				     struct pipe_inode_info *pipe, size_t len,
-				     unsigned int flags)
+/*
+ * ntfs_file_read_iter - file_operations::read_iter
+ */
+static ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
-	struct inode *inode = file_inode(in);
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
+	ssize_t err;
 
-	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
-		return -EIO;
+	err = check_read_restriction(inode);
+	if (err)
+		return err;
 
-	if (is_encrypted(ni)) {
-		ntfs_inode_warn(inode, "encrypted i/o not supported");
+	if (is_compressed(ni) && (iocb->ki_flags & IOCB_DIRECT)) {
+		ntfs_inode_warn(inode, "direct i/o + compressed not supported");
 		return -EOPNOTSUPP;
 	}
 
-#ifndef CONFIG_NTFS3_LZX_XPRESS
-	if (ni->ni_flags & NI_FLAG_COMPRESSED_MASK) {
-		ntfs_inode_warn(
-			inode,
-			"activate CONFIG_NTFS3_LZX_XPRESS to read external compressed files");
-		return -EOPNOTSUPP;
-	}
-#endif
+	return generic_file_read_iter(iocb, iter);
+}
 
-	if (is_dedup(ni)) {
-		ntfs_inode_warn(inode, "read deduplicated not supported");
-		return -EOPNOTSUPP;
-	}
+/*
+ * ntfs_file_splice_read - file_operations::splice_read
+ */
+static ssize_t ntfs_file_splice_read(struct file *in, loff_t *ppos,
+				     struct pipe_inode_info *pipe, size_t len,
+				     unsigned int flags)
+{
+	struct inode *inode = file_inode(in);
+	ssize_t err;
+
+	err = check_read_restriction(inode);
+	if (err)
+		return err;
 
 	return filemap_splice_read(in, ppos, pipe, len, flags);
 }
@@ -1065,14 +1069,11 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 }
 
 /*
- * ntfs_file_write_iter - file_operations::write_iter
+ * check_write_restriction:
+ * common code for ntfs_file_write_iter and ntfs_file_splice_write
  */
-static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static int check_write_restriction(struct inode *inode)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file_inode(file);
-	ssize_t ret;
-	int err;
 	struct ntfs_inode *ni = ntfs_i(inode);
 
 	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
@@ -1083,13 +1084,31 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return -EOPNOTSUPP;
 	}
 
-	if (is_compressed(ni) && (iocb->ki_flags & IOCB_DIRECT)) {
-		ntfs_inode_warn(inode, "direct i/o + compressed not supported");
+	if (is_dedup(ni)) {
+		ntfs_inode_warn(inode, "write into deduplicated not supported");
 		return -EOPNOTSUPP;
 	}
 
-	if (is_dedup(ni)) {
-		ntfs_inode_warn(inode, "write into deduplicated not supported");
+	return 0;
+}
+
+/*
+ * ntfs_file_write_iter - file_operations::write_iter
+ */
+static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	struct ntfs_inode *ni = ntfs_i(inode);
+	ssize_t ret;
+	int err;
+
+	err = check_write_restriction(inode);
+	if (err)
+		return err;
+
+	if (is_compressed(ni) && (iocb->ki_flags & IOCB_DIRECT)) {
+		ntfs_inode_warn(inode, "direct i/o + compressed not supported");
 		return -EOPNOTSUPP;
 	}
 
@@ -1256,6 +1275,23 @@ int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return ret;
 }
 
+/*
+ * ntfs_file_splice_write - file_operations::splice_write
+ */
+static ssize_t ntfs_file_splice_write(struct pipe_inode_info *pipe,
+				      struct file *file, loff_t *ppos,
+				      size_t len, unsigned int flags)
+{
+	ssize_t err;
+	struct inode *inode = file_inode(file);
+
+	err = check_write_restriction(inode);
+	if (err)
+		return err;
+
+	return iter_file_splice_write(pipe, file, ppos, len, flags);
+}
+
 // clang-format off
 const struct inode_operations ntfs_file_inode_operations = {
 	.getattr	= ntfs_getattr,
@@ -1275,10 +1311,10 @@ const struct file_operations ntfs_file_operations = {
 	.compat_ioctl	= ntfs_compat_ioctl,
 #endif
 	.splice_read	= ntfs_file_splice_read,
+	.splice_write	= ntfs_file_splice_write,
 	.mmap		= ntfs_file_mmap,
 	.open		= ntfs_file_open,
 	.fsync		= ntfs_file_fsync,
-	.splice_write	= iter_file_splice_write,
 	.fallocate	= ntfs_fallocate,
 	.release	= ntfs_file_release,
 };
-- 
2.53.0



