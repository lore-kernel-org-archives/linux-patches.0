Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CF936124;
	Wed, 30 Jul 2025 09:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868839; cv=none; b=q6WN/SEYRUWvgCWIMKtRVBMZSfWhHYf6t9kqypOArLouHl3h6HHO8XWibnYvRakRfDohu+mOnTYlBIb+AsP6OP8RAqnExEnt0GdJkwOF+tHhi8tg1lvW8gvPQ7dPtMaQVvakluqnaefNV91eLfm2PdllRwk+cvfxH2UfJamoE70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868839; c=relaxed/simple;
	bh=n2eH8sMt47EQzN5OesIh2oenvG3r8RkZjau/I3kT9P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYvibzmsdYYsetvtOXf2ctaxhcuoP+2qyLDuXGXIXrazFKvaczInal2nsrxinius2V6WjvwBpaSxYCWvkcU//fWfTbf4Y6GtOVHwjwxRK/nsM6iqYOjZA11nRchNteQWyVdm9OJ2EU7LwNoPIOqZmiE369IIwhLsAVETYH0wwHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnAnGT2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnAnGT2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECB7C4CEF5;
	Wed, 30 Jul 2025 09:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868837;
	bh=n2eH8sMt47EQzN5OesIh2oenvG3r8RkZjau/I3kT9P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnAnGT2oS74YgsJpiW9GZIHENyaQ7WG2GqwGDEtOyOAuHJNz6O5ptLJlFizy6LO4+
	 ytMvr9Rh6jfu6hBaxPuQkASkSPYKFKVe9jEVRdUnd+PUJtpJ1raDKhhX2D0k31aIpB
	 o2Qe6eoA8XZtQGDMQ0EPDbXKwEbTdquseXOlQ0XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/117] ext4: refactor ext4_insert_range()
Date: Wed, 30 Jul 2025 11:35:58 +0200
Message-ID: <20250730093237.240663460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 49425504376c335c68f7be54ae7c32312afd9475 ]

Simplify ext4_insert_range() and align its code style with that of
ext4_collapse_range(). Refactor it by: a) renaming variables, b)
removing redundant input parameter checks and moving the remaining
checks under i_rwsem in preparation for future refactoring, and c)
renaming the three stale error tags.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-8-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 29ec9bed2395 ("ext4: fix incorrect punch max_end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |  101 +++++++++++++++++++++++++-----------------------------
 1 file changed, 48 insertions(+), 53 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5421,45 +5421,37 @@ static int ext4_insert_range(struct file
 	handle_t *handle;
 	struct ext4_ext_path *path;
 	struct ext4_extent *extent;
-	ext4_lblk_t offset_lblk, len_lblk, ee_start_lblk = 0;
+	ext4_lblk_t start_lblk, len_lblk, ee_start_lblk = 0;
 	unsigned int credits, ee_len;
-	int ret = 0, depth, split_flag = 0;
-	loff_t ioffset;
-
-	/*
-	 * We need to test this early because xfstests assumes that an
-	 * insert range of (0, 1) will return EOPNOTSUPP if the file
-	 * system does not support insert range.
-	 */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		return -EOPNOTSUPP;
-
-	/* Insert range works only on fs cluster size aligned regions. */
-	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb)))
-		return -EINVAL;
+	int ret, depth, split_flag = 0;
+	loff_t start;
 
 	trace_ext4_insert_range(inode, offset, len);
 
-	offset_lblk = offset >> EXT4_BLOCK_SIZE_BITS(sb);
-	len_lblk = len >> EXT4_BLOCK_SIZE_BITS(sb);
-
 	inode_lock(inode);
+
 	/* Currently just for extent based files */
 	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		ret = -EOPNOTSUPP;
-		goto out_mutex;
+		goto out;
 	}
 
-	/* Check whether the maximum file size would be exceeded */
-	if (len > inode->i_sb->s_maxbytes - inode->i_size) {
-		ret = -EFBIG;
-		goto out_mutex;
+	/* Insert range works only on fs cluster size aligned regions. */
+	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb))) {
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* Offset must be less than i_size */
 	if (offset >= inode->i_size) {
 		ret = -EINVAL;
-		goto out_mutex;
+		goto out;
+	}
+
+	/* Check whether the maximum file size would be exceeded */
+	if (len > inode->i_sb->s_maxbytes - inode->i_size) {
+		ret = -EFBIG;
+		goto out;
 	}
 
 	/* Wait for existing dio to complete */
@@ -5467,7 +5459,7 @@ static int ext4_insert_range(struct file
 
 	ret = file_modified(file);
 	if (ret)
-		goto out_mutex;
+		goto out;
 
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
@@ -5477,25 +5469,24 @@ static int ext4_insert_range(struct file
 
 	ret = ext4_break_layouts(inode);
 	if (ret)
-		goto out_mmap;
+		goto out_invalidate_lock;
 
 	/*
-	 * Need to round down to align start offset to page size boundary
-	 * for page size > block size.
+	 * Write out all dirty pages. Need to round down to align start offset
+	 * to page size boundary for page size > block size.
 	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-			LLONG_MAX);
+	start = round_down(offset, PAGE_SIZE);
+	ret = filemap_write_and_wait_range(mapping, start, LLONG_MAX);
 	if (ret)
-		goto out_mmap;
-	truncate_pagecache(inode, ioffset);
+		goto out_invalidate_lock;
+
+	truncate_pagecache(inode, start);
 
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-		goto out_mmap;
+		goto out_invalidate_lock;
 	}
 	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
@@ -5504,16 +5495,19 @@ static int ext4_insert_range(struct file
 	EXT4_I(inode)->i_disksize += len;
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (ret)
-		goto out_stop;
+		goto out_handle;
+
+	start_lblk = offset >> inode->i_blkbits;
+	len_lblk = len >> inode->i_blkbits;
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode);
 
-	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
+	path = ext4_find_extent(inode, start_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
 		ret = PTR_ERR(path);
-		goto out_stop;
+		goto out_handle;
 	}
 
 	depth = ext_depth(inode);
@@ -5523,16 +5517,16 @@ static int ext4_insert_range(struct file
 		ee_len = ext4_ext_get_actual_len(extent);
 
 		/*
-		 * If offset_lblk is not the starting block of extent, split
-		 * the extent @offset_lblk
+		 * If start_lblk is not the starting block of extent, split
+		 * the extent @start_lblk
 		 */
-		if ((offset_lblk > ee_start_lblk) &&
-				(offset_lblk < (ee_start_lblk + ee_len))) {
+		if ((start_lblk > ee_start_lblk) &&
+				(start_lblk < (ee_start_lblk + ee_len))) {
 			if (ext4_ext_is_unwritten(extent))
 				split_flag = EXT4_EXT_MARK_UNWRIT1 |
 					EXT4_EXT_MARK_UNWRIT2;
 			path = ext4_split_extent_at(handle, inode, path,
-					offset_lblk, split_flag,
+					start_lblk, split_flag,
 					EXT4_EX_NOCACHE |
 					EXT4_GET_BLOCKS_PRE_IO |
 					EXT4_GET_BLOCKS_METADATA_NOFAIL);
@@ -5541,31 +5535,32 @@ static int ext4_insert_range(struct file
 		if (IS_ERR(path)) {
 			up_write(&EXT4_I(inode)->i_data_sem);
 			ret = PTR_ERR(path);
-			goto out_stop;
+			goto out_handle;
 		}
 	}
 
 	ext4_free_ext_path(path);
-	ext4_es_remove_extent(inode, offset_lblk, EXT_MAX_BLOCKS - offset_lblk);
+	ext4_es_remove_extent(inode, start_lblk, EXT_MAX_BLOCKS - start_lblk);
 
 	/*
-	 * if offset_lblk lies in a hole which is at start of file, use
+	 * if start_lblk lies in a hole which is at start of file, use
 	 * ee_start_lblk to shift extents
 	 */
 	ret = ext4_ext_shift_extents(inode, handle,
-		max(ee_start_lblk, offset_lblk), len_lblk, SHIFT_RIGHT);
-
+		max(ee_start_lblk, start_lblk), len_lblk, SHIFT_RIGHT);
 	up_write(&EXT4_I(inode)->i_data_sem);
+	if (ret)
+		goto out_handle;
+
+	ext4_update_inode_fsync_trans(handle, inode, 1);
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
-	if (ret >= 0)
-		ext4_update_inode_fsync_trans(handle, inode, 1);
 
-out_stop:
+out_handle:
 	ext4_journal_stop(handle);
-out_mmap:
+out_invalidate_lock:
 	filemap_invalidate_unlock(mapping);
-out_mutex:
+out:
 	inode_unlock(inode);
 	return ret;
 }


