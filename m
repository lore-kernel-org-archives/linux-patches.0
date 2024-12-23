Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF697E0FF;
	Mon, 23 Dec 2024 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969665; cv=none; b=as3gjJvHAsdRTUf+h0lI0IAA26jYNoDTwmGJg/W/ANndrhYU9fiXQ8NqcBydr18xPlKsZW10JsY9uNCMJE1v2d4y9GXlxlVLsdVkD+EYynexacn8o9Pea4LJmNeEsoPzws/aQwwcX03HWhipa05M0DOT46z3RZD50qETxmuDX0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969665; c=relaxed/simple;
	bh=E07WLNtmTKf35m1UqYIaIyPRP+IJoYwcUMECeB2FVnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezHb1i1OJfrK1yCmM7AxPPIZxfyHCL9HckU9kVJeGC2xEzlFoo5IFmx54XQLaF9oED8W2l/HrJbyGGAuUjQOANKf4skNcB0Y16rV+gnHL1MLl8rWb362JOICnCDWEqkSKH8PTG2szuM7DGJ4XT38+Ux4a0scHvhehJKqAM57cqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF9CS0ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF9CS0ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D8CC4CED4;
	Mon, 23 Dec 2024 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969665;
	bh=E07WLNtmTKf35m1UqYIaIyPRP+IJoYwcUMECeB2FVnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF9CS0ON9PSZrdej9GZKtYuEfDTbmNFBF7tCpnkCrDP1e8zCo2yda2/lI6UTpBZ56
	 CHrqMZ8dnPs9y8w/GCrnb3WA4fUxJF8jPfbxoPN8xI7CuZYl9AB91VO6Kc7CWn78gr
	 xQRYoqinrPnuUj+HN3+RVr/+VHsk/I85AQ3vTxwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/160] erofs: use `struct erofs_device_info` for the primary device
Date: Mon, 23 Dec 2024 16:57:11 +0100
Message-ID: <20241223155409.433469522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 7b00af2c5414dc01e0718deef7ead81102867636 ]

Instead of just listing each one directly in `struct erofs_sb_info`
except that we still use `sb->s_bdev` for the primary block device.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241216125310.930933-2-hsiangkao@linux.alibaba.com
Stable-dep-of: 6422cde1b0d5 ("erofs: use buffered I/O for file-backed mounts by default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c     | 12 ++++--------
 fs/erofs/fscache.c  |  6 +++---
 fs/erofs/internal.h |  8 ++------
 fs/erofs/super.c    | 27 +++++++++++++--------------
 4 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index fa51437e1d99..365c988262b1 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -63,10 +63,10 @@ void erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb)
 
 	buf->file = NULL;
 	if (erofs_is_fileio_mode(sbi)) {
-		buf->file = sbi->fdev;		/* some fs like FUSE needs it */
+		buf->file = sbi->dif0.file;	/* some fs like FUSE needs it */
 		buf->mapping = buf->file->f_mapping;
 	} else if (erofs_is_fscache_mode(sb))
-		buf->mapping = sbi->s_fscache->inode->i_mapping;
+		buf->mapping = sbi->dif0.fscache->inode->i_mapping;
 	else
 		buf->mapping = sb->s_bdev->bd_mapping;
 }
@@ -208,12 +208,8 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 	erofs_off_t startoff, length;
 	int id;
 
-	map->m_bdev = sb->s_bdev;
-	map->m_daxdev = EROFS_SB(sb)->dax_dev;
-	map->m_dax_part_off = EROFS_SB(sb)->dax_part_off;
-	map->m_fscache = EROFS_SB(sb)->s_fscache;
-	map->m_fp = EROFS_SB(sb)->fdev;
-
+	erofs_fill_from_devinfo(map, &EROFS_SB(sb)->dif0);
+	map->m_bdev = sb->s_bdev;	/* use s_bdev for the primary device */
 	if (map->m_deviceid) {
 		down_read(&devs->rwsem);
 		dif = idr_find(&devs->tree, map->m_deviceid - 1);
diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index fda16eedafb5..ce7e38c82719 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -657,7 +657,7 @@ int erofs_fscache_register_fs(struct super_block *sb)
 	if (IS_ERR(fscache))
 		return PTR_ERR(fscache);
 
-	sbi->s_fscache = fscache;
+	sbi->dif0.fscache = fscache;
 	return 0;
 }
 
@@ -665,14 +665,14 @@ void erofs_fscache_unregister_fs(struct super_block *sb)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
-	erofs_fscache_unregister_cookie(sbi->s_fscache);
+	erofs_fscache_unregister_cookie(sbi->dif0.fscache);
 
 	if (sbi->domain)
 		erofs_fscache_domain_put(sbi->domain);
 	else
 		fscache_relinquish_volume(sbi->volume, NULL, false);
 
-	sbi->s_fscache = NULL;
+	sbi->dif0.fscache = NULL;
 	sbi->volume = NULL;
 	sbi->domain = NULL;
 }
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 9b03c8f323a7..d70aa2410472 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -113,6 +113,7 @@ struct erofs_xattr_prefix_item {
 };
 
 struct erofs_sb_info {
+	struct erofs_device_info dif0;
 	struct erofs_mount_opts opt;	/* options */
 #ifdef CONFIG_EROFS_FS_ZIP
 	/* list for all registered superblocks, mainly for shrinker */
@@ -130,13 +131,9 @@ struct erofs_sb_info {
 
 	struct erofs_sb_lz4_info lz4;
 #endif	/* CONFIG_EROFS_FS_ZIP */
-	struct file *fdev;
 	struct inode *packed_inode;
 	struct erofs_dev_context *devs;
-	struct dax_device *dax_dev;
-	u64 dax_part_off;
 	u64 total_blocks;
-	u32 primarydevice_blocks;
 
 	u32 meta_blkaddr;
 #ifdef CONFIG_EROFS_FS_XATTR
@@ -172,7 +169,6 @@ struct erofs_sb_info {
 
 	/* fscache support */
 	struct fscache_volume *volume;
-	struct erofs_fscache *s_fscache;
 	struct erofs_domain *domain;
 	char *fsid;
 	char *domain_id;
@@ -193,7 +189,7 @@ struct erofs_sb_info {
 
 static inline bool erofs_is_fileio_mode(struct erofs_sb_info *sbi)
 {
-	return IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && sbi->fdev;
+	return IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && sbi->dif0.file;
 }
 
 static inline bool erofs_is_fscache_mode(struct super_block *sb)
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index c40821346d50..60f7bd43a5a4 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -218,7 +218,7 @@ static int erofs_scan_devices(struct super_block *sb,
 	struct erofs_device_info *dif;
 	int id, err = 0;
 
-	sbi->total_blocks = sbi->primarydevice_blocks;
+	sbi->total_blocks = sbi->dif0.blocks;
 	if (!erofs_sb_has_device_table(sbi))
 		ondisk_extradevs = 0;
 	else
@@ -322,7 +322,7 @@ static int erofs_read_superblock(struct super_block *sb)
 			  sbi->sb_size);
 		goto out;
 	}
-	sbi->primarydevice_blocks = le32_to_cpu(dsb->blocks);
+	sbi->dif0.blocks = le32_to_cpu(dsb->blocks);
 	sbi->meta_blkaddr = le32_to_cpu(dsb->meta_blkaddr);
 #ifdef CONFIG_EROFS_FS_XATTR
 	sbi->xattr_blkaddr = le32_to_cpu(dsb->xattr_blkaddr);
@@ -617,9 +617,8 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 			return -EINVAL;
 		}
 
-		sbi->dax_dev = fs_dax_get_by_bdev(sb->s_bdev,
-						  &sbi->dax_part_off,
-						  NULL, NULL);
+		sbi->dif0.dax_dev = fs_dax_get_by_bdev(sb->s_bdev,
+				&sbi->dif0.dax_part_off, NULL, NULL);
 	}
 
 	err = erofs_read_superblock(sb);
@@ -642,7 +641,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	if (test_opt(&sbi->opt, DAX_ALWAYS)) {
-		if (!sbi->dax_dev) {
+		if (!sbi->dif0.dax_dev) {
 			errorfc(fc, "DAX unsupported by block device. Turning off DAX.");
 			clear_opt(&sbi->opt, DAX_ALWAYS);
 		} else if (sbi->blkszbits != PAGE_SHIFT) {
@@ -722,14 +721,13 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 
 		if (!fc->source)
 			return invalf(fc, "No source specified");
-
 		file = filp_open(fc->source, O_RDONLY | O_LARGEFILE, 0);
 		if (IS_ERR(file))
 			return PTR_ERR(file);
-		sbi->fdev = file;
+		sbi->dif0.file = file;
 
-		if (S_ISREG(file_inode(sbi->fdev)->i_mode) &&
-		    sbi->fdev->f_mapping->a_ops->read_folio)
+		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode) &&
+		    sbi->dif0.file->f_mapping->a_ops->read_folio)
 			return get_tree_nodev(fc, erofs_fc_fill_super);
 	}
 #endif
@@ -786,8 +784,8 @@ static void erofs_sb_free(struct erofs_sb_info *sbi)
 	erofs_free_dev_context(sbi->devs);
 	kfree(sbi->fsid);
 	kfree(sbi->domain_id);
-	if (sbi->fdev)
-		fput(sbi->fdev);
+	if (sbi->dif0.file)
+		fput(sbi->dif0.file);
 	kfree(sbi);
 }
 
@@ -832,11 +830,12 @@ static void erofs_kill_sb(struct super_block *sb)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
-	if ((IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && sbi->fsid) || sbi->fdev)
+	if ((IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && sbi->fsid) ||
+	    sbi->dif0.file)
 		kill_anon_super(sb);
 	else
 		kill_block_super(sb);
-	fs_put_dax(sbi->dax_dev, NULL);
+	fs_put_dax(sbi->dif0.dax_dev, NULL);
 	erofs_fscache_unregister_fs(sb);
 	erofs_sb_free(sbi);
 	sb->s_fs_info = NULL;
-- 
2.39.5



