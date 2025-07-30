Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508E9266591;
	Wed, 30 Jul 2025 09:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868832; cv=none; b=bSCNeMErhQU97o005R+njRclNdssAShCYDjmqRr8WUbvFGuQv7D8GhmQgSUA/a8e7bytL6QvFblGUE7CXLPPoLAwnP96IFy5+hbpOGzK/k/LPDwycFyVOromkT/feXkKrmOMXq/rNvJUZPnwdAGWi9dC6ugkO1w6aOFNJ57lXDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868832; c=relaxed/simple;
	bh=gM32Bw6zNuMMbjl/Gt9ft35QSiPs7elFsrPyvv7YGLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epssp1IymRaPAH/sG/LT5pQ7N1qSCT0br5hWXqdX2wVWYqVE8ss+IRErtz2WcctqhygMfLmRW/0jarWd5GyHBxHa5a+2ufMJ2eus3u2VNC+EzCaae7dr0FxIoXakL5kl8YlVB5X6AF8AbE6vY1SGqW2ZtoNFNyD6E3WJIYcNOnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckkmU/OG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckkmU/OG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD81C4CEF5;
	Wed, 30 Jul 2025 09:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868830;
	bh=gM32Bw6zNuMMbjl/Gt9ft35QSiPs7elFsrPyvv7YGLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckkmU/OGuCAHBSkUAMtZmY9sj9G8FpQefTvjzbosILbI7xMp2UWeXsSRqM87Gwn7n
	 BhHb1jL/Do8DMHkBg8sQyow6pqQqLklG5Av4itHJheTpcwa2uZJkb8CglVUiLW9/po
	 Qn9tgLwq/1byEXjSy9IocR9hkY1Dml0m8NWqplUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/117] ext4: refactor ext4_zero_range()
Date: Wed, 30 Jul 2025 11:35:56 +0200
Message-ID: <20250730093237.162685514@linuxfoundation.org>
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

[ Upstream commit 53471e0bedad5891b860d02233819dc0e28189e2 ]

The current implementation of ext4_zero_range() contains complex
position calculations and stale error tags. To improve the code's
clarity and maintainability, it is essential to clean up the code and
improve its readability, this can be achieved by: a) simplifying and
renaming variables, making the style the same as ext4_punch_hole(); b)
eliminating unnecessary position calculations, writing back all data in
data=journal mode, and drop page cache from the original offset to the
end, rather than using aligned blocks; c) renaming the stale out_mutex
tags.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-6-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 29ec9bed2395 ("ext4: fix incorrect punch max_end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |  144 +++++++++++++++++++++---------------------------------
 1 file changed, 58 insertions(+), 86 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4571,40 +4571,15 @@ static long ext4_zero_range(struct file
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = file->f_mapping;
 	handle_t *handle = NULL;
-	unsigned int max_blocks;
 	loff_t new_size = 0;
-	int ret = 0;
-	int flags;
-	int credits;
-	int partial_begin, partial_end;
-	loff_t start, end;
-	ext4_lblk_t lblk;
+	loff_t end = offset + len;
+	ext4_lblk_t start_lblk, end_lblk;
+	unsigned int blocksize = i_blocksize(inode);
 	unsigned int blkbits = inode->i_blkbits;
+	int ret, flags, credits;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
 
-	/*
-	 * Round up offset. This is not fallocate, we need to zero out
-	 * blocks, so convert interior block aligned part of the range to
-	 * unwritten and possibly manually zero out unaligned parts of the
-	 * range. Here, start and partial_begin are inclusive, end and
-	 * partial_end are exclusive.
-	 */
-	start = round_up(offset, 1 << blkbits);
-	end = round_down((offset + len), 1 << blkbits);
-
-	if (start < offset || end > offset + len)
-		return -EINVAL;
-	partial_begin = offset & ((1 << blkbits) - 1);
-	partial_end = (offset + len) & ((1 << blkbits) - 1);
-
-	lblk = start >> blkbits;
-	max_blocks = (end >> blkbits);
-	if (max_blocks < lblk)
-		max_blocks = 0;
-	else
-		max_blocks -= lblk;
-
 	inode_lock(inode);
 
 	/*
@@ -4612,77 +4587,70 @@ static long ext4_zero_range(struct file
 	 */
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 		ret = -EOPNOTSUPP;
-		goto out_mutex;
+		goto out;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-	    (offset + len > inode->i_size ||
-	     offset + len > EXT4_I(inode)->i_disksize)) {
-		new_size = offset + len;
+	    (end > inode->i_size || end > EXT4_I(inode)->i_disksize)) {
+		new_size = end;
 		ret = inode_newsize_ok(inode, new_size);
 		if (ret)
-			goto out_mutex;
+			goto out;
 	}
 
-	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
-
 	/* Wait all existing dio workers, newcomers will block on i_rwsem */
 	inode_dio_wait(inode);
 
 	ret = file_modified(file);
 	if (ret)
-		goto out_mutex;
+		goto out;
 
+	/*
+	 * Prevent page faults from reinstantiating pages we have released
+	 * from page cache.
+	 */
+	filemap_invalidate_lock(mapping);
+
+	ret = ext4_break_layouts(inode);
+	if (ret)
+		goto out_invalidate_lock;
+
+	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
 	/* Preallocate the range including the unaligned edges */
-	if (partial_begin || partial_end) {
-		ret = ext4_alloc_file_blocks(file,
-				round_down(offset, 1 << blkbits) >> blkbits,
-				(round_up((offset + len), 1 << blkbits) -
-				 round_down(offset, 1 << blkbits)) >> blkbits,
-				new_size, flags);
-		if (ret)
-			goto out_mutex;
+	if (!IS_ALIGNED(offset | end, blocksize)) {
+		ext4_lblk_t alloc_lblk = offset >> blkbits;
+		ext4_lblk_t len_lblk = EXT4_MAX_BLOCKS(len, offset, blkbits);
 
+		ret = ext4_alloc_file_blocks(file, alloc_lblk, len_lblk,
+					     new_size, flags);
+		if (ret)
+			goto out_invalidate_lock;
 	}
 
+	ret = ext4_update_disksize_before_punch(inode, offset, len);
+	if (ret)
+		goto out_invalidate_lock;
+
+	/* Now release the pages and zero block aligned part of pages */
+	ret = ext4_truncate_page_cache_block_range(inode, offset, end);
+	if (ret)
+		goto out_invalidate_lock;
+
 	/* Zero range excluding the unaligned edges */
-	if (max_blocks > 0) {
-		flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
-			  EXT4_EX_NOCACHE);
-
-		/*
-		 * Prevent page faults from reinstantiating pages we have
-		 * released from page cache.
-		 */
-		filemap_invalidate_lock(mapping);
-
-		ret = ext4_break_layouts(inode);
-		if (ret) {
-			filemap_invalidate_unlock(mapping);
-			goto out_mutex;
-		}
-
-		ret = ext4_update_disksize_before_punch(inode, offset, len);
-		if (ret) {
-			filemap_invalidate_unlock(mapping);
-			goto out_mutex;
-		}
-
-		/* Now release the pages and zero block aligned part of pages */
-		ret = ext4_truncate_page_cache_block_range(inode, start, end);
-		if (ret) {
-			filemap_invalidate_unlock(mapping);
-			goto out_mutex;
-		}
-
-		ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size,
-					     flags);
-		filemap_invalidate_unlock(mapping);
+	start_lblk = EXT4_B_TO_LBLK(inode, offset);
+	end_lblk = end >> blkbits;
+	if (end_lblk > start_lblk) {
+		ext4_lblk_t zero_blks = end_lblk - start_lblk;
+
+		flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN | EXT4_EX_NOCACHE);
+		ret = ext4_alloc_file_blocks(file, start_lblk, zero_blks,
+					     new_size, flags);
 		if (ret)
-			goto out_mutex;
+			goto out_invalidate_lock;
 	}
-	if (!partial_begin && !partial_end)
-		goto out_mutex;
+	/* Finish zeroing out if it doesn't contain partial block */
+	if (IS_ALIGNED(offset | end, blocksize))
+		goto out_invalidate_lock;
 
 	/*
 	 * In worst case we have to writeout two nonadjacent unwritten
@@ -4695,25 +4663,29 @@ static long ext4_zero_range(struct file
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		ext4_std_error(inode->i_sb, ret);
-		goto out_mutex;
+		goto out_invalidate_lock;
 	}
 
+	/* Zero out partial block at the edges of the range */
+	ret = ext4_zero_partial_blocks(handle, inode, offset, len);
+	if (ret)
+		goto out_handle;
+
 	if (new_size)
 		ext4_update_inode_size(inode, new_size);
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (unlikely(ret))
 		goto out_handle;
-	/* Zero out partial block at the edges of the range */
-	ret = ext4_zero_partial_blocks(handle, inode, offset, len);
-	if (ret >= 0)
-		ext4_update_inode_fsync_trans(handle, inode, 1);
 
+	ext4_update_inode_fsync_trans(handle, inode, 1);
 	if (file->f_flags & O_SYNC)
 		ext4_handle_sync(handle);
 
 out_handle:
 	ext4_journal_stop(handle);
-out_mutex:
+out_invalidate_lock:
+	filemap_invalidate_unlock(mapping);
+out:
 	inode_unlock(inode);
 	return ret;
 }


