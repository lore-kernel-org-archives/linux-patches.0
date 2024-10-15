Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961C619B3FF;
	Tue, 15 Oct 2024 11:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992956; cv=none; b=hszVFeJ71UiEXl54tEUP0nsPL3GThXy2mQSJs4MjlGVg1NAVOxPLPQkgIpAZVEqm1PCn/5xWC1XRFtn4jmuT7kPnapmtmPB40NaPDozFr0cRfpE3hgjlFnOZJoIh8imEnlBYWn+7ryFb8EQKuXTpvyX3jSiDtmHeQTL2z8r6DCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992956; c=relaxed/simple;
	bh=jzB0hamXS8ZH13asQkz4sUibRrlzYWGTHoySoKwWQbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naw8oKLc7N5sUhFa6cCSsu3JzlDErp68FX5bImf8Pg/9ybzIC7d3LvkXD/YJ8+CxqAauuRyEf12DJd1KAZrw1vugI/Sr6qWEqTT4PpduYs1Y/kkIy9T7juaebIHF9kMNr4brlAtXj4bYZyYmlRDXKf3cqCI7FgUnsQ8pa+ZKc0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogm5Mljg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogm5Mljg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD66C4CEC6;
	Tue, 15 Oct 2024 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992956;
	bh=jzB0hamXS8ZH13asQkz4sUibRrlzYWGTHoySoKwWQbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogm5MljgV2Tk7uHPe8GfQM8/v55If5CdbV2Qml2+0SDR92zMLhGGO5qjauu2oYSnD
	 /2tFqHyhycko7jgCb6FHHdCoaEZXET5+fi6MKkD4PTKkMHDoKeMOoyyiRyk+6ve9RV
	 uiqXJLtNkbFK+BeENlI25TSb+ruQgUPDB68/X7/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/691] f2fs: introduce F2FS_IPU_HONOR_OPU_WRITE ipu policy
Date: Tue, 15 Oct 2024 13:23:36 +0200
Message-ID: <20241015112450.984501486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1018a5463a063715365784704c4e8cdf2eec4b04 ]

Once F2FS_IPU_FORCE policy is enabled in some cases:
a) f2fs forces to use F2FS_IPU_FORCE in a small-sized volume
b) user sets F2FS_IPU_FORCE policy via sysfs

Then we may fail to defragment file due to IPU policy check, it doesn't
make sense, let's introduce a new IPU policy to allow OPU during file
defragmentation.

In small-sized volume, let's enable F2FS_IPU_HONOR_OPU_WRITE policy
by default.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 884ee6dc85b9 ("f2fs: get rid of online repaire on corrupted directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |  3 ++-
 fs/f2fs/data.c                          | 18 +++++++++++++-----
 fs/f2fs/f2fs.h                          |  3 ++-
 fs/f2fs/file.c                          | 18 +++++++++++-------
 fs/f2fs/segment.h                       |  5 ++++-
 fs/f2fs/super.c                         |  3 ++-
 6 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 48d41b6696270..89dec1f3ea6d9 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -55,8 +55,9 @@ Description:	Controls the in-place-update policy.
 		0x04  F2FS_IPU_UTIL
 		0x08  F2FS_IPU_SSR_UTIL
 		0x10  F2FS_IPU_FSYNC
-		0x20  F2FS_IPU_ASYNC,
+		0x20  F2FS_IPU_ASYNC
 		0x40  F2FS_IPU_NOCACHE
+		0x80  F2FS_IPU_HONOR_OPU_WRITE
 		====  =================
 
 		Refer segment.h for details.
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index fa86eaf1d6393..3f8dae229d422 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2567,6 +2567,9 @@ static inline bool check_inplace_update_policy(struct inode *inode,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	unsigned int policy = SM_I(sbi)->ipu_policy;
 
+	if (policy & (0x1 << F2FS_IPU_HONOR_OPU_WRITE) &&
+			is_inode_flag_set(inode, FI_OPU_WRITE))
+		return false;
 	if (policy & (0x1 << F2FS_IPU_FORCE))
 		return true;
 	if (policy & (0x1 << F2FS_IPU_SSR) && f2fs_need_SSR(sbi))
@@ -2637,6 +2640,9 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
 		return true;
 
+	if (is_inode_flag_set(inode, FI_OPU_WRITE))
+		return true;
+
 	if (fio) {
 		if (page_private_gcing(fio->page))
 			return true;
@@ -3263,8 +3269,8 @@ static int __f2fs_write_data_pages(struct address_space *mapping,
 			f2fs_available_free_memory(sbi, DIRTY_DENTS))
 		goto skip_write;
 
-	/* skip writing during file defragment */
-	if (is_inode_flag_set(inode, FI_DO_DEFRAG))
+	/* skip writing in file defragment preparing stage */
+	if (is_inode_flag_set(inode, FI_SKIP_WRITES))
 		goto skip_write;
 
 	trace_f2fs_writepages(mapping->host, wbc, DATA);
@@ -3998,6 +4004,7 @@ static int f2fs_migrate_blocks(struct inode *inode, block_t start_blk,
 	filemap_invalidate_lock(inode->i_mapping);
 
 	set_inode_flag(inode, FI_ALIGNED_WRITE);
+	set_inode_flag(inode, FI_OPU_WRITE);
 
 	for (; secidx < end_sec; secidx++) {
 		down_write(&sbi->pin_sem);
@@ -4006,7 +4013,7 @@ static int f2fs_migrate_blocks(struct inode *inode, block_t start_blk,
 		f2fs_allocate_new_section(sbi, CURSEG_COLD_DATA_PINNED, false);
 		f2fs_unlock_op(sbi);
 
-		set_inode_flag(inode, FI_DO_DEFRAG);
+		set_inode_flag(inode, FI_SKIP_WRITES);
 
 		for (blkofs = 0; blkofs < blk_per_sec; blkofs++) {
 			struct page *page;
@@ -4023,7 +4030,7 @@ static int f2fs_migrate_blocks(struct inode *inode, block_t start_blk,
 			f2fs_put_page(page, 1);
 		}
 
-		clear_inode_flag(inode, FI_DO_DEFRAG);
+		clear_inode_flag(inode, FI_SKIP_WRITES);
 
 		ret = filemap_fdatawrite(inode->i_mapping);
 
@@ -4034,7 +4041,8 @@ static int f2fs_migrate_blocks(struct inode *inode, block_t start_blk,
 	}
 
 done:
-	clear_inode_flag(inode, FI_DO_DEFRAG);
+	clear_inode_flag(inode, FI_SKIP_WRITES);
+	clear_inode_flag(inode, FI_OPU_WRITE);
 	clear_inode_flag(inode, FI_ALIGNED_WRITE);
 
 	filemap_invalidate_unlock(inode->i_mapping);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cd3439ea6d727..f2c55a5afe67b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -715,7 +715,8 @@ enum {
 	FI_DROP_CACHE,		/* drop dirty page cache */
 	FI_DATA_EXIST,		/* indicate data exists */
 	FI_INLINE_DOTS,		/* indicate inline dot dentries */
-	FI_DO_DEFRAG,		/* indicate defragment is running */
+	FI_SKIP_WRITES,		/* should skip data page writeback */
+	FI_OPU_WRITE,		/* used for opu per file */
 	FI_DIRTY_FILE,		/* indicate regular/symlink has dirty pages */
 	FI_NO_PREALLOC,		/* indicate skipped preallocated blocks */
 	FI_HOT_DATA,		/* indicate file is hot */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0427994c9b50a..ee20d79bd93e4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2579,10 +2579,6 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	bool fragmented = false;
 	int err;
 
-	/* if in-place-update policy is enabled, don't waste time here */
-	if (f2fs_should_update_inplace(inode, NULL))
-		return -EINVAL;
-
 	pg_start = range->start >> PAGE_SHIFT;
 	pg_end = (range->start + range->len) >> PAGE_SHIFT;
 
@@ -2590,6 +2586,13 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 
 	inode_lock(inode);
 
+	/* if in-place-update policy is enabled, don't waste time here */
+	set_inode_flag(inode, FI_OPU_WRITE);
+	if (f2fs_should_update_inplace(inode, NULL)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* writeback all dirty pages in the range */
 	err = filemap_write_and_wait_range(inode->i_mapping, range->start,
 						range->start + range->len - 1);
@@ -2671,7 +2674,7 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 			goto check;
 		}
 
-		set_inode_flag(inode, FI_DO_DEFRAG);
+		set_inode_flag(inode, FI_SKIP_WRITES);
 
 		idx = map.m_lblk;
 		while (idx < map.m_lblk + map.m_len && cnt < blk_per_seg) {
@@ -2699,15 +2702,16 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 		if (map.m_lblk < pg_end && cnt < blk_per_seg)
 			goto do_map;
 
-		clear_inode_flag(inode, FI_DO_DEFRAG);
+		clear_inode_flag(inode, FI_SKIP_WRITES);
 
 		err = filemap_fdatawrite(inode->i_mapping);
 		if (err)
 			goto out;
 	}
 clear_out:
-	clear_inode_flag(inode, FI_DO_DEFRAG);
+	clear_inode_flag(inode, FI_SKIP_WRITES);
 out:
+	clear_inode_flag(inode, FI_OPU_WRITE);
 	inode_unlock(inode);
 	if (!err)
 		range->len = (u64)total << PAGE_SHIFT;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 04f448ddf49ea..2c1165e8f1283 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -665,7 +665,9 @@ static inline int utilization(struct f2fs_sb_info *sbi)
  *                     pages over min_fsync_blocks. (=default option)
  * F2FS_IPU_ASYNC - do IPU given by asynchronous write requests.
  * F2FS_IPU_NOCACHE - disable IPU bio cache.
- * F2FS_IPUT_DISABLE - disable IPU. (=default option in LFS mode)
+ * F2FS_IPU_HONOR_OPU_WRITE - use OPU write prior to IPU write if inode has
+ *                            FI_OPU_WRITE flag.
+ * F2FS_IPU_DISABLE - disable IPU. (=default option in LFS mode)
  */
 #define DEF_MIN_IPU_UTIL	70
 #define DEF_MIN_FSYNC_BLOCKS	8
@@ -681,6 +683,7 @@ enum {
 	F2FS_IPU_FSYNC,
 	F2FS_IPU_ASYNC,
 	F2FS_IPU_NOCACHE,
+	F2FS_IPU_HONOR_OPU_WRITE,
 };
 
 static inline unsigned int curseg_segno(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 706d7adda3b22..17615eb833e0c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3971,7 +3971,8 @@ static void f2fs_tuning_parameters(struct f2fs_sb_info *sbi)
 		F2FS_OPTION(sbi).alloc_mode = ALLOC_MODE_REUSE;
 		if (f2fs_block_unit_discard(sbi))
 			sm_i->dcc_info->discard_granularity = 1;
-		sm_i->ipu_policy = 1 << F2FS_IPU_FORCE;
+		sm_i->ipu_policy = 1 << F2FS_IPU_FORCE |
+					1 << F2FS_IPU_HONOR_OPU_WRITE;
 	}
 
 	sbi->readdir_ra = 1;
-- 
2.43.0



