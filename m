Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A4F341AD0;
	Tue, 16 Dec 2025 11:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884767; cv=none; b=DJlZS5hw8MfjFBM/jK/p2pVB3ffW8a/oyiQPrStti2J/qkJzNfRK2EomNFxJ8TpvB6UuKIYJvuYSsz6TR+4aH3S6rWyUl0bwloons3XglbtABQj4q+gMxvO4Oy5nY3Nrv5tDXDPEgbtHS3TuVMORNaKsDLva0PyWkk5V8vYqpPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884767; c=relaxed/simple;
	bh=EzejfToWfPVB6Abv3mSW5jYl0Yn5gqWWXdoOzZxIY/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=id/54y401RXOXx0g5j08MBmjdseRhDPHVwrlVcHgGW+z+NKvQpRSKqH9D3LLauk28iAclPTBOd9GB7VKpJI5QA+iTv+1YEpWfDsxVNQkigH4DvCyPn+yvMGz1gGYMVQfLFVmgbdCrV3ymyHFRzIfidV5pngv5TBJpYi4ciJRb34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvfAi3O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvfAi3O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE12C16AAE;
	Tue, 16 Dec 2025 11:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884766;
	bh=EzejfToWfPVB6Abv3mSW5jYl0Yn5gqWWXdoOzZxIY/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvfAi3O40XoQLmfs/fnof3bQkDGiK5CvOW6EjEhPhgeCKPogP0bAcW2F12lewgODM
	 mw/qmM6hRX7j+s3FFedLuf/T3UYbOCLYuKVqjU2zo26daE11XjYkBYfAe6bHVSdIG3
	 9ralCFo/f04951MTNDpPZjVB9OpgNt+cAD7GsaPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/354] f2fs: keep POSIX_FADV_NOREUSE ranges
Date: Tue, 16 Dec 2025 12:14:20 +0100
Message-ID: <20251216111331.527027725@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit ef0c333cad8d1940f132a7ce15f15920216a3bd5 ]

This patch records POSIX_FADV_NOREUSE ranges for users to reclaim the caches
instantly off from LRU.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: e462fc48ceb8 ("f2fs: maintain one time GC mode is enabled during whole zoned GC cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/debug.c |  3 +++
 fs/f2fs/f2fs.h  | 12 +++++++++-
 fs/f2fs/file.c  | 60 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/f2fs/inode.c | 14 ++++++++++++
 fs/f2fs/super.c |  1 +
 5 files changed, 84 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 546b8ba912613..a3f807c3b72cb 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -100,6 +100,7 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->ndirty_imeta = get_pages(sbi, F2FS_DIRTY_IMETA);
 	si->ndirty_dirs = sbi->ndirty_inode[DIR_INODE];
 	si->ndirty_files = sbi->ndirty_inode[FILE_INODE];
+	si->ndonate_files = sbi->donate_files;
 	si->nquota_files = sbi->nquota_files;
 	si->ndirty_all = sbi->ndirty_inode[DIRTY_META];
 	si->aw_cnt = atomic_read(&sbi->atomic_files);
@@ -435,6 +436,8 @@ static int stat_show(struct seq_file *s, void *v)
 			   si->compr_inode, si->compr_blocks);
 		seq_printf(s, "  - Swapfile Inode: %u\n",
 			   si->swapfile_inode);
+		seq_printf(s, "  - Donate Inode: %u\n",
+			   si->ndonate_files);
 		seq_printf(s, "  - Orphan/Append/Update Inode: %u, %u, %u\n",
 			   si->orphans, si->append, si->update);
 		seq_printf(s, "\nMain area: %d segs, %d secs %d zones\n",
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 0d3ef487f72ac..7ced2e2c65746 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -849,6 +849,11 @@ struct f2fs_inode_info {
 #endif
 	struct list_head dirty_list;	/* dirty list for dirs and files */
 	struct list_head gdirty_list;	/* linked in global dirty list */
+
+	/* linked in global inode list for cache donation */
+	struct list_head gdonate_list;
+	pgoff_t donate_start, donate_end; /* inclusive */
+
 	struct task_struct *atomic_write_task;	/* store atomic write task */
 	struct extent_tree *extent_tree[NR_EXTENT_CACHES];
 					/* cached extent_tree entry */
@@ -1274,6 +1279,7 @@ enum inode_type {
 	DIR_INODE,			/* for dirty dir inode */
 	FILE_INODE,			/* for dirty regular/symlink inode */
 	DIRTY_META,			/* for all dirtied inode metadata */
+	DONATE_INODE,			/* for all inode to donate pages */
 	NR_INODE_TYPE,
 };
 
@@ -1629,6 +1635,9 @@ struct f2fs_sb_info {
 	unsigned int warm_data_age_threshold;
 	unsigned int last_age_weight;
 
+	/* control donate caches */
+	unsigned int donate_files;
+
 	/* basic filesystem units */
 	unsigned int log_sectors_per_block;	/* log2 sectors per block */
 	unsigned int log_blocksize;		/* log2 block size */
@@ -3997,7 +4006,8 @@ struct f2fs_stat_info {
 	unsigned long long allocated_data_blocks;
 	int ndirty_node, ndirty_dent, ndirty_meta, ndirty_imeta;
 	int ndirty_data, ndirty_qdata;
-	unsigned int ndirty_dirs, ndirty_files, nquota_files, ndirty_all;
+	unsigned int ndirty_dirs, ndirty_files, ndirty_all;
+	unsigned int nquota_files, ndonate_files;
 	int nats, dirty_nats, sits, dirty_sits;
 	int free_nids, avail_nids, alloc_nids;
 	int total_count, utilization;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6317dd523ecd1..b8d24c1c48bd4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2452,6 +2452,52 @@ static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
 	return ret;
 }
 
+static void f2fs_keep_noreuse_range(struct inode *inode,
+				loff_t offset, loff_t len)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	u64 max_bytes = F2FS_BLK_TO_BYTES(max_file_blocks(inode));
+	u64 start, end;
+
+	if (!S_ISREG(inode->i_mode))
+		return;
+
+	if (offset >= max_bytes || len > max_bytes ||
+	    (offset + len) > max_bytes)
+		return;
+
+	start = offset >> PAGE_SHIFT;
+	end = DIV_ROUND_UP(offset + len, PAGE_SIZE);
+
+	inode_lock(inode);
+	if (f2fs_is_atomic_file(inode)) {
+		inode_unlock(inode);
+		return;
+	}
+
+	spin_lock(&sbi->inode_lock[DONATE_INODE]);
+	/* let's remove the range, if len = 0 */
+	if (!len) {
+		if (!list_empty(&F2FS_I(inode)->gdonate_list)) {
+			list_del_init(&F2FS_I(inode)->gdonate_list);
+			sbi->donate_files--;
+		}
+	} else {
+		if (list_empty(&F2FS_I(inode)->gdonate_list)) {
+			list_add_tail(&F2FS_I(inode)->gdonate_list,
+					&sbi->inode_list[DONATE_INODE]);
+			sbi->donate_files++;
+		} else {
+			list_move_tail(&F2FS_I(inode)->gdonate_list,
+					&sbi->inode_list[DONATE_INODE]);
+		}
+		F2FS_I(inode)->donate_start = start;
+		F2FS_I(inode)->donate_end = end - 1;
+	}
+	spin_unlock(&sbi->inode_lock[DONATE_INODE]);
+	inode_unlock(inode);
+}
+
 static int f2fs_ioc_fitrim(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -5144,12 +5190,16 @@ static int f2fs_file_fadvise(struct file *filp, loff_t offset, loff_t len,
 	}
 
 	err = generic_fadvise(filp, offset, len, advice);
-	if (!err && advice == POSIX_FADV_DONTNEED &&
-		test_opt(F2FS_I_SB(inode), COMPRESS_CACHE) &&
-		f2fs_compressed_file(inode))
-		f2fs_invalidate_compress_pages(F2FS_I_SB(inode), inode->i_ino);
+	if (err)
+		return err;
 
-	return err;
+	if (advice == POSIX_FADV_DONTNEED &&
+	    (test_opt(F2FS_I_SB(inode), COMPRESS_CACHE) &&
+	     f2fs_compressed_file(inode)))
+		f2fs_invalidate_compress_pages(F2FS_I_SB(inode), inode->i_ino);
+	else if (advice == POSIX_FADV_NOREUSE)
+		f2fs_keep_noreuse_range(inode, offset, len);
+	return 0;
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 41ead6c772e48..c77184dbc71cd 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -807,6 +807,19 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return 0;
 }
 
+static void f2fs_remove_donate_inode(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+
+	if (list_empty(&F2FS_I(inode)->gdonate_list))
+		return;
+
+	spin_lock(&sbi->inode_lock[DONATE_INODE]);
+	list_del_init(&F2FS_I(inode)->gdonate_list);
+	sbi->donate_files--;
+	spin_unlock(&sbi->inode_lock[DONATE_INODE]);
+}
+
 /*
  * Called at the last iput() if i_nlink is zero
  */
@@ -841,6 +854,7 @@ void f2fs_evict_inode(struct inode *inode)
 
 	f2fs_bug_on(sbi, get_dirty_pages(inode));
 	f2fs_remove_dirty_inode(inode);
+	f2fs_remove_donate_inode(inode);
 
 	f2fs_destroy_extent_tree(inode);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 875aef2fc5205..3be4e8bcbd138 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1429,6 +1429,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	spin_lock_init(&fi->i_size_lock);
 	INIT_LIST_HEAD(&fi->dirty_list);
 	INIT_LIST_HEAD(&fi->gdirty_list);
+	INIT_LIST_HEAD(&fi->gdonate_list);
 	init_f2fs_rwsem(&fi->i_gc_rwsem[READ]);
 	init_f2fs_rwsem(&fi->i_gc_rwsem[WRITE]);
 	init_f2fs_rwsem(&fi->i_xattr_sem);
-- 
2.51.0



