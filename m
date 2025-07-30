Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8430157E6B;
	Wed, 30 Jul 2025 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868827; cv=none; b=chvnJMgCWHBkzzLqfiLH8ChJ/r0+niSawvcjO3wsPC2IVrdsoJIkObXmL9uhD0cdUQ2ltKgwyXZvaL1JMB6md6L51XkVK5LIg6dX86L6c+eSK82COgvZC8z6koYSbFplk/KwMTLxYw5YOT54TAgZ5v4k+OSrkxZOZIsnEiCh+Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868827; c=relaxed/simple;
	bh=rqSqAL87/3vVTCD8y6ukwvYheNNmeZ1YWvdppSgfrEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kM32/01QxSWPmeScMEv16me6Mpg3Zc0vaVAa9YyZ15MRiCLYRNlWtxSeT8iTOrPZ6VXcRc7o+9w6w+edLC14ReMHKFCokffeJerkFTU7v5NgKIa/tjysntja1f6XiC7dou7RfhJ+qWbo39y0WlHktjLbzOHpp9dfDImhb7tWQMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkQSb1kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkQSb1kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4773DC4CEF5;
	Wed, 30 Jul 2025 09:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868827;
	bh=rqSqAL87/3vVTCD8y6ukwvYheNNmeZ1YWvdppSgfrEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkQSb1kkQvnkZybfYaxSifB44M1D1SdjwkLriqsBbuXz3L9aMvHNY2rxOQV5Mds4E
	 1TOuK0Ib5lDjjFgTWyrw3OvuOSNBpMh8dOQ3Mw+TLnDrtYaYKDmvMFsy3mRrZX8QXB
	 0RHpzKIQW092RU82SHM7n050+LBK1aYGtvY/l4L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/117] ext4: refactor ext4_punch_hole()
Date: Wed, 30 Jul 2025 11:35:55 +0200
Message-ID: <20250730093237.124453207@linuxfoundation.org>
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

[ Upstream commit 982bf37da09d078570650b691d9084f43805a5de ]

The current implementation of ext4_punch_hole() contains complex
position calculations and stale error tags. To improve the code's
clarity and maintainability, it is essential to clean up the code and
improve its readability, this can be achieved by: a) simplifying and
renaming variables; b) eliminating unnecessary position calculations;
c) writing back all data in data=journal mode, and drop page cache from
the original offset to the end, rather than using aligned blocks,
d) renaming the stale error tags.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-5-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 29ec9bed2395 ("ext4: fix incorrect punch max_end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    2 
 fs/ext4/inode.c |  119 ++++++++++++++++++++++++--------------------------------
 2 files changed, 55 insertions(+), 66 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -368,6 +368,8 @@ struct ext4_io_submit {
 #define EXT4_MAX_BLOCKS(size, offset, blkbits) \
 	((EXT4_BLOCK_ALIGN(size + offset, blkbits) >> blkbits) - (offset >> \
 								  blkbits))
+#define EXT4_B_TO_LBLK(inode, offset) \
+	(round_up((offset), i_blocksize(inode)) >> (inode)->i_blkbits)
 
 /* Translate a block number to a cluster number */
 #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3991,13 +3991,13 @@ int ext4_punch_hole(struct file *file, l
 {
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
-	ext4_lblk_t first_block, stop_block;
+	ext4_lblk_t start_lblk, end_lblk;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t first_block_offset, last_block_offset, max_length;
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	loff_t max_end = EXT4_SB(sb)->s_bitmap_maxbytes - sb->s_blocksize;
+	loff_t end = offset + length;
 	handle_t *handle;
 	unsigned int credits;
-	int ret = 0, ret2 = 0;
+	int ret = 0;
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
@@ -4005,36 +4005,27 @@ int ext4_punch_hole(struct file *file, l
 
 	/* No need to punch hole beyond i_size */
 	if (offset >= inode->i_size)
-		goto out_mutex;
+		goto out;
 
 	/*
-	 * If the hole extends beyond i_size, set the hole
-	 * to end after the page that contains i_size
+	 * If the hole extends beyond i_size, set the hole to end after
+	 * the page that contains i_size, and also make sure that the hole
+	 * within one block before last range.
 	 */
-	if (offset + length > inode->i_size) {
-		length = inode->i_size +
-		   PAGE_SIZE - (inode->i_size & (PAGE_SIZE - 1)) -
-		   offset;
-	}
+	if (end > inode->i_size)
+		end = round_up(inode->i_size, PAGE_SIZE);
+	if (end > max_end)
+		end = max_end;
+	length = end - offset;
 
 	/*
-	 * For punch hole the length + offset needs to be within one block
-	 * before last range. Adjust the length if it goes beyond that limit.
+	 * Attach jinode to inode for jbd2 if we do any zeroing of partial
+	 * block.
 	 */
-	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
-	if (offset + length > max_length)
-		length = max_length - offset;
-
-	if (offset & (sb->s_blocksize - 1) ||
-	    (offset + length) & (sb->s_blocksize - 1)) {
-		/*
-		 * Attach jinode to inode for jbd2 if we do any zeroing of
-		 * partial block
-		 */
+	if (!IS_ALIGNED(offset | end, sb->s_blocksize)) {
 		ret = ext4_inode_attach_jinode(inode);
 		if (ret < 0)
-			goto out_mutex;
-
+			goto out;
 	}
 
 	/* Wait all existing dio workers, newcomers will block on i_rwsem */
@@ -4042,7 +4033,7 @@ int ext4_punch_hole(struct file *file, l
 
 	ret = file_modified(file);
 	if (ret)
-		goto out_mutex;
+		goto out;
 
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
@@ -4052,22 +4043,16 @@ int ext4_punch_hole(struct file *file, l
 
 	ret = ext4_break_layouts(inode);
 	if (ret)
-		goto out_dio;
+		goto out_invalidate_lock;
 
-	first_block_offset = round_up(offset, sb->s_blocksize);
-	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
+	ret = ext4_update_disksize_before_punch(inode, offset, length);
+	if (ret)
+		goto out_invalidate_lock;
 
 	/* Now release the pages and zero block aligned part of pages*/
-	if (last_block_offset > first_block_offset) {
-		ret = ext4_update_disksize_before_punch(inode, offset, length);
-		if (ret)
-			goto out_dio;
-
-		ret = ext4_truncate_page_cache_block_range(inode,
-				first_block_offset, last_block_offset + 1);
-		if (ret)
-			goto out_dio;
-	}
+	ret = ext4_truncate_page_cache_block_range(inode, offset, end);
+	if (ret)
+		goto out_invalidate_lock;
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		credits = ext4_writepage_trans_blocks(inode);
@@ -4077,52 +4062,54 @@ int ext4_punch_hole(struct file *file, l
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		ext4_std_error(sb, ret);
-		goto out_dio;
+		goto out_invalidate_lock;
 	}
 
-	ret = ext4_zero_partial_blocks(handle, inode, offset,
-				       length);
+	ret = ext4_zero_partial_blocks(handle, inode, offset, length);
 	if (ret)
-		goto out_stop;
-
-	first_block = (offset + sb->s_blocksize - 1) >>
-		EXT4_BLOCK_SIZE_BITS(sb);
-	stop_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
+		goto out_handle;
 
 	/* If there are blocks to remove, do it */
-	if (stop_block > first_block) {
-		ext4_lblk_t hole_len = stop_block - first_block;
+	start_lblk = EXT4_B_TO_LBLK(inode, offset);
+	end_lblk = end >> inode->i_blkbits;
+
+	if (end_lblk > start_lblk) {
+		ext4_lblk_t hole_len = end_lblk - start_lblk;
 
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
 
-		ext4_es_remove_extent(inode, first_block, hole_len);
+		ext4_es_remove_extent(inode, start_lblk, hole_len);
 
 		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-			ret = ext4_ext_remove_space(inode, first_block,
-						    stop_block - 1);
+			ret = ext4_ext_remove_space(inode, start_lblk,
+						    end_lblk - 1);
 		else
-			ret = ext4_ind_remove_space(handle, inode, first_block,
-						    stop_block);
+			ret = ext4_ind_remove_space(handle, inode, start_lblk,
+						    end_lblk);
+		if (ret) {
+			up_write(&EXT4_I(inode)->i_data_sem);
+			goto out_handle;
+		}
 
-		ext4_es_insert_extent(inode, first_block, hole_len, ~0,
+		ext4_es_insert_extent(inode, start_lblk, hole_len, ~0,
 				      EXTENT_STATUS_HOLE, 0);
 		up_write(&EXT4_I(inode)->i_data_sem);
 	}
-	ext4_fc_track_range(handle, inode, first_block, stop_block);
+	ext4_fc_track_range(handle, inode, start_lblk, end_lblk);
+
+	ret = ext4_mark_inode_dirty(handle, inode);
+	if (unlikely(ret))
+		goto out_handle;
+
+	ext4_update_inode_fsync_trans(handle, inode, 1);
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
-
-	ret2 = ext4_mark_inode_dirty(handle, inode);
-	if (unlikely(ret2))
-		ret = ret2;
-	if (ret >= 0)
-		ext4_update_inode_fsync_trans(handle, inode, 1);
-out_stop:
+out_handle:
 	ext4_journal_stop(handle);
-out_dio:
+out_invalidate_lock:
 	filemap_invalidate_unlock(mapping);
-out_mutex:
+out:
 	inode_unlock(inode);
 	return ret;
 }


