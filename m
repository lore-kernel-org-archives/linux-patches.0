Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBA8319601;
	Thu, 16 Jul 2026 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210869; cv=none; b=R8mpn0l9qrQ9nAqO3r3uLwvECTzrN+2hbPPhpg5thTN2nbAETfu7YVsBXlqhnR/PWei1SuYXE/4xylzR0LuD74xNYeGmkpTpDFaVT29uq6QTwqo8qtfS53D/hioGp2AG0TlzQo5hfQ54IGMUc2d6Zo2l7PGdk2A+NHPgm/B8Wtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210869; c=relaxed/simple;
	bh=8rI7ivR3QuRGS3ov09B7H4WLidTUeUr+GAc6FtMl08k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/+CTfEDSVg1Hzn/dfCVabI34c4oTiGRSKgZIpfmp1B1JobnseVTFjRUobZgEfXmDMI2pecUvsFmOVprxlhQ+M+08lmCB+8F+5QwtDUVru3dI1Oa8DJ162kT+bKQK9RLrBraxk2SDHKFUw4Sgp12JApOsovuWihFiRT/f/4OjiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qn64Gehv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qn64Gehv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4161F000E9;
	Thu, 16 Jul 2026 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210867;
	bh=cPNrY9Oap8GT3FQ/FDiSsTM2cc6s48ium5rfCEALcHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qn64GehvHCvRSOIB7HE47nknfWqfoc4xfo5+/h+WfyuxlNTfUPeAcqlVRopg6Rk6y
	 wo6a3ETcG3yWAFg61nFbqQ50ZTPGUp+4djC6wV73hlg+gw97bE7eww2gclKTMEawy/
	 9j47p5hVIOy9BMyhoh5KiT5vbq9nd9fneT+zd3Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/480] fs/ntfs3: fsync files by syncing parent inodes
Date: Thu, 16 Jul 2026 15:29:18 +0200
Message-ID: <20260716133049.295508872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 460df046482c73..d41d02372c747b 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -624,7 +624,7 @@ const struct file_operations ntfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= ntfs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= ntfs_file_fsync,
 	.open		= ntfs_file_open,
 	.unlocked_ioctl = ntfs_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 5042eb321eb891..6a19bb04220809 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1378,13 +1378,37 @@ static ssize_t ntfs_file_splice_write(struct pipe_inode_info *pipe,
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
+		blkdev_issue_flush(sb->s_bdev);
+	return ret;
 }
 
 // clang-format off
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 480f2ed518a783..e904c5da919222 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3090,6 +3090,57 @@ bool ni_is_dirty(struct inode *inode)
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
index a4466e9641f65d..7fb08bff025491 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -510,6 +510,7 @@ int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 int ntfs_file_open(struct inode *inode, struct file *file);
 int ntfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len);
+int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 long ntfs_ioctl(struct file *filp, u32 cmd, unsigned long arg);
 long ntfs_compat_ioctl(struct file *filp, u32 cmd, unsigned long arg);
 extern const struct inode_operations ntfs_special_inode_operations;
@@ -587,6 +588,7 @@ int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
 	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de);
 
 bool ni_is_dirty(struct inode *inode);
+int ni_write_parents(struct ntfs_inode *ni, int sync);
 
 /* Globals from fslog.c */
 bool check_index_header(const struct INDEX_HDR *hdr, size_t bytes);
-- 
2.53.0



