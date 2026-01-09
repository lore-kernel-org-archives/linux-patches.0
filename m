Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD2B35CB7D;
	Fri,  9 Jan 2026 12:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962978; cv=none; b=BUY9hkBXqJOPtb/p2bW0xssKCUtpQvYBDw7QTMxkY8H8ffwYMPIwO+WFnNjx81hXE1pzyE3JRyvQlYYT3o/2n+5YEWss86KCM84FwUTq1clGOStYsUInAm/k/CQGv7TlGzRYWGy2QDLi+NfG1Fi+mPzdVtX8Y7CafpoJAZmDgRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962978; c=relaxed/simple;
	bh=gNvGylt4biPfz9cIPSNV850TeJxD1gJvlLCYHzW1XBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFhmZKQ7msp8YWS+3IA1d9/ukqBmKxCqxj/vbhW7RObC9rTPxKSwaBDYk9e3l7jBjErMEDfAxpOL5jkpcHMI2NkdSD2gdghP1oOsANqWJxMOhx6DTYVsG73IFzr1KwoSKGRD6VjtOOmcOr047D4us/I7E6tfaipffnzOpl3MNzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wushZw0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wushZw0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B82C4CEF1;
	Fri,  9 Jan 2026 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962978;
	bh=gNvGylt4biPfz9cIPSNV850TeJxD1gJvlLCYHzW1XBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wushZw0i/Ev3oK7nAqzHpzOJWyXdMsxpSvBwzc2QamQzWDN1G/HoNcLB2cSJhX3v8
	 xQiZYuZT1MPHVuAYC6AQVyT141TA3i/e+tXemcAoNUbwYQnDOosh4hm19BpYs6hWgG
	 CsBGaEOzx7ZvLX/s6Mo0Kw+KVNlNsARxjIG+Xlqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 553/634] f2fs: keep POSIX_FADV_NOREUSE ranges
Date: Fri,  9 Jan 2026 12:43:51 +0100
Message-ID: <20260109112138.402960262@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit ef0c333cad8d1940f132a7ce15f15920216a3bd5 ]

This patch records POSIX_FADV_NOREUSE ranges for users to reclaim the caches
instantly off from LRU.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 10b591e7fb7c ("f2fs: fix to avoid updating compression context during writeback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/debug.c |    3 ++
 fs/f2fs/f2fs.h  |   12 ++++++++++-
 fs/f2fs/file.c  |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/f2fs/inode.c |   14 +++++++++++++
 fs/f2fs/super.c |    1 
 5 files changed, 84 insertions(+), 6 deletions(-)

--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -97,6 +97,7 @@ static void update_general_status(struct
 	si->ndirty_imeta = get_pages(sbi, F2FS_DIRTY_IMETA);
 	si->ndirty_dirs = sbi->ndirty_inode[DIR_INODE];
 	si->ndirty_files = sbi->ndirty_inode[FILE_INODE];
+	si->ndonate_files = sbi->donate_files;
 	si->nquota_files = sbi->nquota_files;
 	si->ndirty_all = sbi->ndirty_inode[DIRTY_META];
 	si->aw_cnt = atomic_read(&sbi->atomic_files);
@@ -402,6 +403,8 @@ static int stat_show(struct seq_file *s,
 			   si->compr_inode, si->compr_blocks);
 		seq_printf(s, "  - Swapfile Inode: %u\n",
 			   si->swapfile_inode);
+		seq_printf(s, "  - Donate Inode: %u\n",
+			   si->ndonate_files);
 		seq_printf(s, "  - Orphan/Append/Update Inode: %u, %u, %u\n",
 			   si->orphans, si->append, si->update);
 		seq_printf(s, "\nMain area: %d segs, %d secs %d zones\n",
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -820,6 +820,11 @@ struct f2fs_inode_info {
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
@@ -1236,6 +1241,7 @@ enum inode_type {
 	DIR_INODE,			/* for dirty dir inode */
 	FILE_INODE,			/* for dirty regular/symlink inode */
 	DIRTY_META,			/* for all dirtied inode metadata */
+	DONATE_INODE,			/* for all inode to donate pages */
 	NR_INODE_TYPE,
 };
 
@@ -1650,6 +1656,9 @@ struct f2fs_sb_info {
 	/* for extent tree cache */
 	struct extent_tree_info extent_tree[NR_EXTENT_CACHES];
 
+	/* control donate caches */
+	unsigned int donate_files;
+
 	/* basic filesystem units */
 	unsigned int log_sectors_per_block;	/* log2 sectors per block */
 	unsigned int log_blocksize;		/* log2 block size */
@@ -3854,7 +3863,8 @@ struct f2fs_stat_info {
 	unsigned long long hit_largest;
 	int ndirty_node, ndirty_dent, ndirty_meta, ndirty_imeta;
 	int ndirty_data, ndirty_qdata;
-	unsigned int ndirty_dirs, ndirty_files, nquota_files, ndirty_all;
+	unsigned int ndirty_dirs, ndirty_files, ndirty_all;
+	unsigned int nquota_files, ndonate_files;
 	int nats, dirty_nats, sits, dirty_sits;
 	int free_nids, avail_nids, alloc_nids;
 	int total_count, utilization;
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2367,6 +2367,52 @@ out:
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
@@ -4901,12 +4947,16 @@ static int f2fs_file_fadvise(struct file
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
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -743,6 +743,19 @@ int f2fs_write_inode(struct inode *inode
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
@@ -775,6 +788,7 @@ void f2fs_evict_inode(struct inode *inod
 
 	f2fs_bug_on(sbi, get_dirty_pages(inode));
 	f2fs_remove_dirty_inode(inode);
+	f2fs_remove_donate_inode(inode);
 
 	f2fs_destroy_extent_tree(inode);
 
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1429,6 +1429,7 @@ static struct inode *f2fs_alloc_inode(st
 	spin_lock_init(&fi->i_size_lock);
 	INIT_LIST_HEAD(&fi->dirty_list);
 	INIT_LIST_HEAD(&fi->gdirty_list);
+	INIT_LIST_HEAD(&fi->gdonate_list);
 	init_f2fs_rwsem(&fi->i_gc_rwsem[READ]);
 	init_f2fs_rwsem(&fi->i_gc_rwsem[WRITE]);
 	init_f2fs_rwsem(&fi->i_xattr_sem);


