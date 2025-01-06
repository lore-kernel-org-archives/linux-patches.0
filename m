Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE642040;
	Mon,  6 Jan 2025 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178519; cv=none; b=KF+6QacsvCmUcHk8oNOHiK5y7u/RPf+SgP6G1Laq4gcgGPBgVyaNn88mAFzmK9Y5FuuoXtWDPce767Eo1+tABoteBF5WL3JKdR5WTh1UaS8jg7cwm2WAf62tI5j3C8rmwjc92d6gaGA4vvMt8FOeU2BQUYnthG9SwUcHx2pcPfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178519; c=relaxed/simple;
	bh=5VLFm6F8j4JojQa1uUjp6KK4oYg9U3CuNy6v2KlEEmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uD5/9qtT7Has+wQqk7B1hsV7g8DAcUTQP6oEqD1fkolBT41cOkJEasjes7VWCEKfpd9d5uZIDnqgUpQO4Ro3fe9neaPK5CYxYQn7YcEZmFxQKULuBdh3+FmmyTXh+UGWeyBa0tyGtzlYHVvLRmkPYm3ECWm1i0eiUkJ0MhPmJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7N6Pb3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7N6Pb3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1E1C4CED2;
	Mon,  6 Jan 2025 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178519;
	bh=5VLFm6F8j4JojQa1uUjp6KK4oYg9U3CuNy6v2KlEEmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7N6Pb3yuUVAyL+yjhVGlTc13BF3hTFqf0EhVAwHRyRJB51IsRxEXUT5UqMlevSv6
	 TBV2HEewFal1a3M38wwuCEJEPkpUJy8JMAfKW1cAKwKF1YIlgdnAh6wOGLZ5Bt0a8k
	 4PNDXk7mnIZBdyABaLkXZIUNZDiga7KaDMqZ+E2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/138] btrfs: locking: remove the recursion handling code
Date: Mon,  6 Jan 2025 16:17:33 +0100
Message-ID: <20250106151138.117477287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4048daedb910f83f080c6bb03c78af794aebdff5 ]

Now that we're no longer using recursion, rip out all of the supporting
code.  Follow up patches will clean up the callers of these functions.

The extent_buffer::lock_owner is still retained as it allows safety
checks in btrfs_init_new_buffer for the case that the free space cache
is corrupted and we try to allocate a block that we are currently using
and have locked in the path.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 97e86631bccd ("btrfs: don't set lock_owner when locking extent buffer for reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/locking.c | 68 +++-------------------------------------------
 1 file changed, 4 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 5260660b655a..1e36a66fcefa 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -25,43 +25,18 @@
  * - reader/reader sharing
  * - try-lock semantics for readers and writers
  *
- * Additionally we need one level nesting recursion, see below. The rwsem
- * implementation does opportunistic spinning which reduces number of times the
- * locking task needs to sleep.
- *
- *
- * Lock recursion
- * --------------
- *
- * A write operation on a tree might indirectly start a look up on the same
- * tree.  This can happen when btrfs_cow_block locks the tree and needs to
- * lookup free extents.
- *
- * btrfs_cow_block
- *   ..
- *   alloc_tree_block_no_bg_flush
- *     btrfs_alloc_tree_block
- *       btrfs_reserve_extent
- *         ..
- *         load_free_space_cache
- *           ..
- *           btrfs_lookup_file_extent
- *             btrfs_search_slot
- *
+ * The rwsem implementation does opportunistic spinning which reduces number of
+ * times the locking task needs to sleep.
  */
 
 /*
  * __btrfs_tree_read_lock - lock extent buffer for read
  * @eb:		the eb to be locked
  * @nest:	the nesting level to be used for lockdep
- * @recurse:	if this lock is able to be recursed
+ * @recurse:	unused
  *
  * This takes the read lock on the extent buffer, using the specified nesting
  * level for lockdep purposes.
- *
- * If you specify recurse = true, then we will allow this to be taken if we
- * currently own the lock already.  This should only be used in specific
- * usecases, and the subsequent unlock will not change the state of the lock.
  */
 void __btrfs_tree_read_lock(struct extent_buffer *eb, enum btrfs_lock_nesting nest,
 			    bool recurse)
@@ -71,31 +46,7 @@ void __btrfs_tree_read_lock(struct extent_buffer *eb, enum btrfs_lock_nesting ne
 	if (trace_btrfs_tree_read_lock_enabled())
 		start_ns = ktime_get_ns();
 
-	if (unlikely(recurse)) {
-		/* First see if we can grab the lock outright */
-		if (down_read_trylock(&eb->lock))
-			goto out;
-
-		/*
-		 * Ok still doesn't necessarily mean we are already holding the
-		 * lock, check the owner.
-		 */
-		if (eb->lock_owner != current->pid) {
-			down_read_nested(&eb->lock, nest);
-			goto out;
-		}
-
-		/*
-		 * Ok we have actually recursed, but we should only be recursing
-		 * once, so blow up if we're already recursed, otherwise set
-		 * ->lock_recursed and carry on.
-		 */
-		BUG_ON(eb->lock_recursed);
-		eb->lock_recursed = true;
-		goto out;
-	}
 	down_read_nested(&eb->lock, nest);
-out:
 	eb->lock_owner = current->pid;
 	trace_btrfs_tree_read_lock(eb, start_ns);
 }
@@ -136,22 +87,11 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 }
 
 /*
- * Release read lock.  If the read lock was recursed then the lock stays in the
- * original state that it was before it was recursively locked.
+ * Release read lock.
  */
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
 	trace_btrfs_tree_read_unlock(eb);
-	/*
-	 * if we're nested, we have the write lock.  No new locking
-	 * is needed as long as we are the lock owner.
-	 * The write unlock will do a barrier for us, and the lock_recursed
-	 * field only matters to the lock owner.
-	 */
-	if (eb->lock_recursed && current->pid == eb->lock_owner) {
-		eb->lock_recursed = false;
-		return;
-	}
 	eb->lock_owner = 0;
 	up_read(&eb->lock);
 }
-- 
2.39.5



