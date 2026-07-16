Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D92400997;
	Thu, 16 Jul 2026 14:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211991; cv=none; b=PV4tInw5dD5XnSVkreAYqPa7AyOFkKbxNdIwRD0WAwts1EVtIfTFjHWF/4O4K3FcSy8f+T1q3L8/wPvc1ZbaRGZomzeMgAdPVuaFQFaN0w7uTR/+R9m0wiLWMsTSUi46QgVn5PqlAYWUXRMH6lsY2O9ak4D9RxB3CIjMnSy9fss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211991; c=relaxed/simple;
	bh=S8+6jRjq8e1zsWWy/qmzkM3+ySP689hg1VhBUrN+KKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU+quIWCTaRQ0Y17bDAJdwA6JIDdIUZHmb4nGVBAYqAhMwKzAZIAu2cXjG7ogV423JzrcwtYhAh0gdX9MMMxxMqh1L5+dJUVykwrRkguh3Q0vxSJ+NjTA/oXbxqWMpkR6rNNuG2P8wGeCC1+L9XLSorD+5gdKerTtOsE1kiJRPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKGaTe6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKGaTe6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257941F000E9;
	Thu, 16 Jul 2026 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211989;
	bh=bvQYUeuInP78IRTWmKCb8GCg+GfagiZjYxlF40l7dqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKGaTe6XAzfqQlPz09ShWsOomVarH7aDKWlz8NTnkukZsCcb5cn7uQaw2bPPNHdhq
	 r1KGy7Amh8+J/FPcnPM+AnxDjhF0ENZDG+U0UA9ZQk7G+E3+D44xDfM45TNeOXQ1YO
	 cxvHQeKcBm5xn6TmLlLeo9s8nldTsl3yikrSqe/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/349] fs/ntfs3: fsync files by syncing parent inodes
Date: Thu, 16 Jul 2026 15:31:32 +0200
Message-ID: <20260716133036.918393344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit dcd9d6a47199565d83d61a11bbf91fa2ade4d676 ]

Some xfstests expect fsync() on a file or directory to also persist
directory metadata up the parent chain. Using generic_file_fsync() is not
sufficient for ntfs, because parent directories are not explicitly
written out.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c     |  2 +-
 fs/ntfs3/file.c    | 30 ++++++++++++++++++++++++---
 fs/ntfs3/frecord.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ntfs3/ntfs_fs.h |  2 ++
 4 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 522ebc14b1fbd0..652b257e8b0782 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -625,7 +625,7 @@ const struct file_operations ntfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= ntfs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= ntfs_file_fsync,
 	.open		= ntfs_file_open,
 	.unlocked_ioctl = ntfs_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index b7d87fd57063c5..13f7d8acecf901 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1399,13 +1399,37 @@ static ssize_t ntfs_file_splice_write(struct pipe_inode_info *pipe,
 /*
  * ntfs_file_fsync - file_operations::fsync
  */
-static int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file_inode(file);
-	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
+	struct super_block *sb = inode->i_sb;
+	struct ntfs_sb_info *sbi = sb->s_fs_info;
+	int err, ret;
+
+	if (unlikely(ntfs3_forced_shutdown(sb)))
 		return -EIO;
 
-	return generic_file_fsync(file, start, end, datasync);
+	ret = file_write_and_wait_range(file, start, end);
+	if (ret)
+		return ret;
+
+	ret = write_inode_now(inode, !datasync);
+
+	if (!ret) {
+		ret = ni_write_parents(ntfs_i(inode), !datasync);
+	}
+
+	if (!ret) {
+		ntfs_set_state(sbi, NTFS_DIRTY_CLEAR);
+		ntfs_update_mftmirr(sbi, false);
+	}
+
+	err = sync_blockdev(sb->s_bdev);
+	if (unlikely(err && !ret))
+		ret = err;
+	if (!ret)
+		ret = blkdev_issue_flush(sb->s_bdev);
+	return ret;
 }
 
 // clang-format off
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index bb1feb80d5cb79..b6528d1e4e51fa 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3144,6 +3144,57 @@ bool ni_is_dirty(struct inode *inode)
 	return false;
 }
 
+/*
+ * ni_write_parents
+ *
+ * Helper function for ntfs_file_fsync.
+ */
+int ni_write_parents(struct ntfs_inode *ni, int sync)
+{
+	int err = 0;
+	struct ATTRIB *attr = NULL;
+	struct ATTR_LIST_ENTRY *le = NULL;
+	struct ntfs_sb_info *sbi = ni->mi.sbi;
+	struct super_block *sb = sbi->sb;
+
+	while ((attr = ni_find_attr(ni, attr, &le, ATTR_NAME, NULL, 0, NULL,
+				    NULL))) {
+		struct inode *dir;
+		struct ATTR_FILE_NAME *fname;
+
+		fname = resident_data_ex(attr, SIZEOF_ATTRIBUTE_FILENAME);
+		if (!fname)
+			continue;
+
+		/* Check simple case when parent inode equals current inode. */
+		if (ino_get(&fname->home) == ni->vfs_inode.i_ino) {
+			if (MFT_REC_ROOT != ni->vfs_inode.i_ino) {
+				ntfs_set_state(sbi, NTFS_DIRTY_ERROR);
+				err = -EINVAL;
+			}
+			continue;
+		}
+
+		dir = ntfs_iget5(sb, &fname->home, NULL);
+		if (IS_ERR(dir)) {
+			ntfs_inode_warn(
+				&ni->vfs_inode,
+				"failed to open parent directory r=%lx to write",
+				(long)ino_get(&fname->home));
+			continue;
+		}
+
+		if (!is_bad_inode(dir)) {
+			int err2 = write_inode_now(dir, sync);
+			if (!err)
+				err = err2;
+		}
+		iput(dir);
+	}
+
+	return err;
+}
+
 /*
  * ni_update_parent
  *
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index e860529e1ff996..7375ea351f0ea7 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -507,6 +507,7 @@ int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 int ntfs_file_open(struct inode *inode, struct file *file);
 int ntfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len);
+int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 long ntfs_ioctl(struct file *filp, u32 cmd, unsigned long arg);
 long ntfs_compat_ioctl(struct file *filp, u32 cmd, unsigned long arg);
 extern const struct inode_operations ntfs_special_inode_operations;
@@ -588,6 +589,7 @@ int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
 
 bool ni_is_dirty(struct inode *inode);
 int ni_set_compress(struct inode *inode, bool compr);
+int ni_write_parents(struct ntfs_inode *ni, int sync);
 
 /* Globals from fslog.c */
 bool check_index_header(const struct INDEX_HDR *hdr, size_t bytes);
-- 
2.53.0



