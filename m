Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ABD2DA76C;
	Tue, 21 Jul 2026 20:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665102; cv=none; b=VPepbx4Shwpob9xSAoRevELvk1NKpHp7t9n5wkiiAjKroPNq6PusPngnSu1+YKxmjNWSux+Gbt6U4JfSOwXA/CH4SJ9gFxGr/AHs/gwuzrzeo2S1fM3JFPOtzSxEx8+Lwv1L8f3JN4+J7sQTPfzUDGSf8HemXkfxNJwEC6Ifwbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665102; c=relaxed/simple;
	bh=Fy7w1a4rbwqS393cLQW5uS/yYom3SsJY9JDjVjKUUb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd8Es3aTzFu0P3M3cAiPhoo/nW7CZgj4jPSktS0aOhAGX/2KH2TpBw0Qoq27J7oiBKOWfNePd+Wx7hazNN87+t9QeuhN1nDoOOUwHmRBS99hyBgrJdxxqTQIu599s6mXaysEyIFAJEnXHL8HD/S1TYv4yjxMG3iXlUjnKsznf+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQYGuPgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQYGuPgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC761F000E9;
	Tue, 21 Jul 2026 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665100;
	bh=HrqfyTyuVma/hBzcCCzdsiUR6R+Z9kC4c+Z9t8WRicc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQYGuPgOSWx9OqDomlilHqCZ6GrdFI+e+HwelLtAoYLNvwkgSUebKG+DVNv+y2M5f
	 mzcVc0FKDkPnRBeag5kluU3TKInRB6Ayyj1mOAeHhuuDCf9jFAqK5kBhRKGID5A90g
	 Dpx/Q1zSzNYa9I/C6ZRBi518rgXH5/gQ7OoL8s+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0175/1266] fs/ntfs3: fsync files by syncing parent inodes
Date: Tue, 21 Jul 2026 17:10:12 +0200
Message-ID: <20260721152445.722475918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
 fs/ntfs3/file.c    | 38 +++++++++++++++++++++++++++++++++-
 fs/ntfs3/frecord.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ntfs3/ntfs_fs.h |  2 ++
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 894fd44164b48a..4bf851273e3324 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -623,7 +623,7 @@ const struct file_operations ntfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= ntfs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= ntfs_file_fsync,
 	.open		= ntfs_file_open,
 };
 // clang-format on
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 212737a816d7af..89e35825c5c49d 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1224,6 +1224,42 @@ int ntfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	return err;
 }
 
+/*
+ * ntfs_file_fsync - file_operations::fsync
+ */
+int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	struct ntfs_sb_info *sbi = sb->s_fs_info;
+	int err, ret;
+
+	if (unlikely(ntfs3_forced_shutdown(sb)))
+		return -EIO;
+
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
+}
+
 // clang-format off
 const struct inode_operations ntfs_file_inode_operations = {
 	.getattr	= ntfs_getattr,
@@ -1245,7 +1281,7 @@ const struct file_operations ntfs_file_operations = {
 	.splice_read	= ntfs_file_splice_read,
 	.mmap		= ntfs_file_mmap,
 	.open		= ntfs_file_open,
-	.fsync		= generic_file_fsync,
+	.fsync		= ntfs_file_fsync,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ntfs_fallocate,
 	.release	= ntfs_file_release,
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 06b1d82b599759..c265710d25b425 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3145,6 +3145,57 @@ bool ni_is_dirty(struct inode *inode)
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
index 31f57ee9a1a9b4..e534095078e89f 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -503,6 +503,7 @@ int ntfs3_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 int ntfs_file_open(struct inode *inode, struct file *file);
 int ntfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len);
+int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 extern const struct inode_operations ntfs_special_inode_operations;
 extern const struct inode_operations ntfs_file_inode_operations;
 extern const struct file_operations ntfs_file_operations;
@@ -580,6 +581,7 @@ int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
 	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de);
 
 bool ni_is_dirty(struct inode *inode);
+int ni_write_parents(struct ntfs_inode *ni, int sync);
 
 /* Globals from fslog.c */
 bool check_index_header(const struct INDEX_HDR *hdr, size_t bytes);
-- 
2.53.0



