Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62917DDCB;
	Mon,  4 Mar 2024 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588180; cv=none; b=BUF+hwWaN10lcwLHpRB+wHQKKvBaqX7/Yoo18Eumhst3cuMsx7jpwiDVXM3cPO6bH/UJ9D9MEAV0xw/CdNkGImwQk/suq0f80u+HicvD0xmSKuyTyuNr/MjdOc2g33FgrRf0PA/3qmJ4DW6u0SXG8gqtjNA2HHhqG/5mHJoaMRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588180; c=relaxed/simple;
	bh=vC5F7h0XqUHnCFnwV/D+g62/cYkVf6KMWde1MQUMfs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjzWt8Mm44OGc74L7uaKiPkkw+6HTDjLo0CMIekIN0jrRgRkf+GmmsuWOj+e68TUs2OLQKHGbh2Vg1bB6qsssDtHR7CVxLeJA5S050EHVtVCnSK9Lr+1YP4F+lG+Tla63FapQZeyefo938hM8CqKSNJ/6xEEr8opYkMEs5CC1ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN1IKopq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN1IKopq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79DBC433F1;
	Mon,  4 Mar 2024 21:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588180;
	bh=vC5F7h0XqUHnCFnwV/D+g62/cYkVf6KMWde1MQUMfs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN1IKopqc7zYvOVOGuuGcaBJukjBfOGCnkjKWCeU2PF014vQ50JiY0F6BSnar/uVV
	 kBf2EH3HlgqvEEz19PwS0g79UbNFG1lNvA0ySfi2Q9Zxv9r2e5mTtsbZqrFQzzzaVi
	 sGmRPgknzlEKA/RvS2qEv8OAKZrUoSTKHD1nHUVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/143] btrfs: fix deadlock with fiemap and extent locking
Date: Mon,  4 Mar 2024 21:22:01 +0000
Message-ID: <20240304211549.931535666@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b0ad381fa7690244802aed119b478b4bdafc31dd ]

While working on the patchset to remove extent locking I got a lockdep
splat with fiemap and pagefaulting with my new extent lock replacement
lock.

This deadlock exists with our normal code, we just don't have lockdep
annotations with the extent locking so we've never noticed it.

Since we're copying the fiemap extent to user space on every iteration
we have the chance of pagefaulting.  Because we hold the extent lock for
the entire range we could mkwrite into a range in the file that we have
mmap'ed.  This would deadlock with the following stack trace

[<0>] lock_extent+0x28d/0x2f0
[<0>] btrfs_page_mkwrite+0x273/0x8a0
[<0>] do_page_mkwrite+0x50/0xb0
[<0>] do_fault+0xc1/0x7b0
[<0>] __handle_mm_fault+0x2fa/0x460
[<0>] handle_mm_fault+0xa4/0x330
[<0>] do_user_addr_fault+0x1f4/0x800
[<0>] exc_page_fault+0x7c/0x1e0
[<0>] asm_exc_page_fault+0x26/0x30
[<0>] rep_movs_alternative+0x33/0x70
[<0>] _copy_to_user+0x49/0x70
[<0>] fiemap_fill_next_extent+0xc8/0x120
[<0>] emit_fiemap_extent+0x4d/0xa0
[<0>] extent_fiemap+0x7f8/0xad0
[<0>] btrfs_fiemap+0x49/0x80
[<0>] __x64_sys_ioctl+0x3e1/0xb50
[<0>] do_syscall_64+0x94/0x1a0
[<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

I wrote an fstest to reproduce this deadlock without my replacement lock
and verified that the deadlock exists with our existing locking.

To fix this simply don't take the extent lock for the entire duration of
the fiemap.  This is safe in general because we keep track of where we
are when we're searching the tree, so if an ordered extent updates in
the middle of our fiemap call we'll still emit the correct extents
because we know what offset we were on before.

The only place we maintain the lock is searching delalloc.  Since the
delalloc stuff can change during writeback we want to lock the extent
range so we have a consistent view of delalloc at the time we're
checking to see if we need to set the delalloc flag.

With this patch applied we no longer deadlock with my testcase.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 62 ++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 03c10e0ba0e27..70c6c7a0d4014 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2646,16 +2646,34 @@ static int fiemap_process_hole(struct btrfs_inode *inode,
 	 * it beyond i_size.
 	 */
 	while (cur_offset < end && cur_offset < i_size) {
+		struct extent_state *cached_state = NULL;
 		u64 delalloc_start;
 		u64 delalloc_end;
 		u64 prealloc_start;
+		u64 lockstart;
+		u64 lockend;
 		u64 prealloc_len = 0;
 		bool delalloc;
 
+		lockstart = round_down(cur_offset, inode->root->fs_info->sectorsize);
+		lockend = round_up(end, inode->root->fs_info->sectorsize);
+
+		/*
+		 * We are only locking for the delalloc range because that's the
+		 * only thing that can change here.  With fiemap we have a lock
+		 * on the inode, so no buffered or direct writes can happen.
+		 *
+		 * However mmaps and normal page writeback will cause this to
+		 * change arbitrarily.  We have to lock the extent lock here to
+		 * make sure that nobody messes with the tree while we're doing
+		 * btrfs_find_delalloc_in_range.
+		 */
+		lock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 		delalloc = btrfs_find_delalloc_in_range(inode, cur_offset, end,
 							delalloc_cached_state,
 							&delalloc_start,
 							&delalloc_end);
+		unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 		if (!delalloc)
 			break;
 
@@ -2823,15 +2841,15 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		  u64 start, u64 len)
 {
 	const u64 ino = btrfs_ino(inode);
-	struct extent_state *cached_state = NULL;
 	struct extent_state *delalloc_cached_state = NULL;
 	struct btrfs_path *path;
 	struct fiemap_cache cache = { 0 };
 	struct btrfs_backref_share_check_ctx *backref_ctx;
 	u64 last_extent_end;
 	u64 prev_extent_end;
-	u64 lockstart;
-	u64 lockend;
+	u64 range_start;
+	u64 range_end;
+	const u64 sectorsize = inode->root->fs_info->sectorsize;
 	bool stopped = false;
 	int ret;
 
@@ -2842,12 +2860,11 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		goto out;
 	}
 
-	lockstart = round_down(start, inode->root->fs_info->sectorsize);
-	lockend = round_up(start + len, inode->root->fs_info->sectorsize);
-	prev_extent_end = lockstart;
+	range_start = round_down(start, sectorsize);
+	range_end = round_up(start + len, sectorsize);
+	prev_extent_end = range_start;
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
-	lock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 
 	ret = fiemap_find_last_extent_offset(inode, path, &last_extent_end);
 	if (ret < 0)
@@ -2855,7 +2872,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 	btrfs_release_path(path);
 
 	path->reada = READA_FORWARD;
-	ret = fiemap_search_slot(inode, path, lockstart);
+	ret = fiemap_search_slot(inode, path, range_start);
 	if (ret < 0) {
 		goto out_unlock;
 	} else if (ret > 0) {
@@ -2867,7 +2884,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		goto check_eof_delalloc;
 	}
 
-	while (prev_extent_end < lockend) {
+	while (prev_extent_end < range_end) {
 		struct extent_buffer *leaf = path->nodes[0];
 		struct btrfs_file_extent_item *ei;
 		struct btrfs_key key;
@@ -2890,19 +2907,19 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		 * The first iteration can leave us at an extent item that ends
 		 * before our range's start. Move to the next item.
 		 */
-		if (extent_end <= lockstart)
+		if (extent_end <= range_start)
 			goto next_item;
 
 		backref_ctx->curr_leaf_bytenr = leaf->start;
 
 		/* We have in implicit hole (NO_HOLES feature enabled). */
 		if (prev_extent_end < key.offset) {
-			const u64 range_end = min(key.offset, lockend) - 1;
+			const u64 hole_end = min(key.offset, range_end) - 1;
 
 			ret = fiemap_process_hole(inode, fieinfo, &cache,
 						  &delalloc_cached_state,
 						  backref_ctx, 0, 0, 0,
-						  prev_extent_end, range_end);
+						  prev_extent_end, hole_end);
 			if (ret < 0) {
 				goto out_unlock;
 			} else if (ret > 0) {
@@ -2912,7 +2929,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 			}
 
 			/* We've reached the end of the fiemap range, stop. */
-			if (key.offset >= lockend) {
+			if (key.offset >= range_end) {
 				stopped = true;
 				break;
 			}
@@ -3006,29 +3023,41 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 	btrfs_free_path(path);
 	path = NULL;
 
-	if (!stopped && prev_extent_end < lockend) {
+	if (!stopped && prev_extent_end < range_end) {
 		ret = fiemap_process_hole(inode, fieinfo, &cache,
 					  &delalloc_cached_state, backref_ctx,
-					  0, 0, 0, prev_extent_end, lockend - 1);
+					  0, 0, 0, prev_extent_end, range_end - 1);
 		if (ret < 0)
 			goto out_unlock;
-		prev_extent_end = lockend;
+		prev_extent_end = range_end;
 	}
 
 	if (cache.cached && cache.offset + cache.len >= last_extent_end) {
 		const u64 i_size = i_size_read(&inode->vfs_inode);
 
 		if (prev_extent_end < i_size) {
+			struct extent_state *cached_state = NULL;
 			u64 delalloc_start;
 			u64 delalloc_end;
+			u64 lockstart;
+			u64 lockend;
 			bool delalloc;
 
+			lockstart = round_down(prev_extent_end, sectorsize);
+			lockend = round_up(i_size, sectorsize);
+
+			/*
+			 * See the comment in fiemap_process_hole as to why
+			 * we're doing the locking here.
+			 */
+			lock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 			delalloc = btrfs_find_delalloc_in_range(inode,
 								prev_extent_end,
 								i_size - 1,
 								&delalloc_cached_state,
 								&delalloc_start,
 								&delalloc_end);
+			unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 			if (!delalloc)
 				cache.flags |= FIEMAP_EXTENT_LAST;
 		} else {
@@ -3039,7 +3068,6 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 	ret = emit_last_fiemap_cache(fieinfo, &cache);
 
 out_unlock:
-	unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 out:
 	free_extent_state(delalloc_cached_state);
-- 
2.43.0



