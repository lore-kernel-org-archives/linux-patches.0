Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC617BED0;
	Sat, 17 Oct 2026 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257966; cv=none; b=nv6PGK7qtxZir0siSUnoOEYgxrET/6EarKmFYxqSDSs584A1N52IPlTZQred4xpqJUDDnExNm7whKzdd7y7XRbhO4ZLjkM0TQyN3Q2yHYes+Z7r6kX1qWhoQFly0NhbVbOdUphgRuoz8xOTTEfrR/w1tuEpI4IDj7HGzRghNCOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257966; c=relaxed/simple;
	bh=PqCXzTN0IoBlnntz6/Vdj+zDJL2ogcwnoEabUoR7KOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S07KfnOZokmsCimtAcLCpgiEhtibz3CBIbk1VA1QmRjpz8ohgzv/l4aLVQTo5SyOY8OYJnGRjKEuNM9Had9G5nsV6hT04ITIHpn7j01mKnLfK4ciyry86Zbzw5/vgJ8FEpxptqVxUjX/KA+DXl05rlJsq9SzuzjIxLZpM8EXjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1wvTd76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1wvTd76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42FC1F000C4;
	Sat, 17 Oct 2026 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257965;
	bh=fpU47j3WxdlMSzMMGY5FjcpRpb47TuymPhdqQX3ghGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1wvTd76EenaIj8QLOM7LzDP8zh7atloI+uTGxZv15HSzAsWvNeLQi1xtJgHTfFjb
	 cQFI8SR6L+bvgqaux9nrJjye2bgO1lUHV/Ypa7KadDoYzYVi4Yx87XdXmepwEfNK+4
	 rYH5CN/nv4u1kNZBSV2tELyZdLxwE3Pt2pfhr9Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0728/1674] btrfs: remove pointless loop from btrfs_update_block_group()
Date: Sat, 17 Oct 2026 17:50:00 +0200
Message-ID: <20261017160449.795609855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 4d20c1def946f1faa57334c4b99d3cb0ccd18944 ]

When an extent is allocated or freed, we call btrfs_update_block_group()
to update its block group and space info. An extent always belongs to a
single block group, it can never span multiple block groups, so the loop
we have at btrfs_update_block_group() is pointless, as it always has a
single iteration. The loop was added in the very early days, 2007, when
the block group code was added in commit 9078a3e1e4e4 ("Btrfs: start of
block group code"), but even back then it seemed pointless.

So remove the loop and assert the block group containing the start offset
of the extent also contains the whole extent.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7511e29cf135 ("btrfs: harden block_group::bg_list against list_del() races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 147 +++++++++++++++++++----------------------
 1 file changed, 67 insertions(+), 80 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 7a992f363af07..4c817980fcdf5 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3637,12 +3637,11 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     u64 bytenr, u64 num_bytes, bool alloc)
 {
 	struct btrfs_fs_info *info = trans->fs_info;
-	struct btrfs_block_group *cache = NULL;
-	u64 total = num_bytes;
+	struct btrfs_space_info *space_info;
+	struct btrfs_block_group *cache;
 	u64 old_val;
-	u64 byte_in_group;
+	bool reclaim = false;
 	int factor;
-	int ret = 0;
 
 	/* Block accounting for super block */
 	spin_lock(&info->delalloc_root_lock);
@@ -3654,97 +3653,85 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	btrfs_set_super_bytes_used(info->super_copy, old_val);
 	spin_unlock(&info->delalloc_root_lock);
 
-	while (total) {
-		struct btrfs_space_info *space_info;
-		bool reclaim = false;
-
-		cache = btrfs_lookup_block_group(info, bytenr);
-		if (!cache) {
-			ret = -ENOENT;
-			break;
-		}
-		space_info = cache->space_info;
-		factor = btrfs_bg_type_to_factor(cache->flags);
+	cache = btrfs_lookup_block_group(info, bytenr);
+	if (!cache)
+		return -ENOENT;
 
-		/*
-		 * If this block group has free space cache written out, we
-		 * need to make sure to load it if we are removing space.  This
-		 * is because we need the unpinning stage to actually add the
-		 * space back to the block group, otherwise we will leak space.
-		 */
-		if (!alloc && !btrfs_block_group_done(cache))
-			btrfs_cache_block_group(cache, true);
+	/* An extent can not span multiple block groups. */
+	ASSERT(bytenr + num_bytes <= cache->start + cache->length);
 
-		byte_in_group = bytenr - cache->start;
-		WARN_ON(byte_in_group > cache->length);
+	space_info = cache->space_info;
+	factor = btrfs_bg_type_to_factor(cache->flags);
 
-		spin_lock(&space_info->lock);
-		spin_lock(&cache->lock);
+	/*
+	 * If this block group has free space cache written out, we need to make
+	 * sure to load it if we are removing space.  This is because we need
+	 * the unpinning stage to actually add the space back to the block group,
+	 * otherwise we will leak space.
+	 */
+	if (!alloc && !btrfs_block_group_done(cache))
+		btrfs_cache_block_group(cache, true);
 
-		if (btrfs_test_opt(info, SPACE_CACHE) &&
-		    cache->disk_cache_state < BTRFS_DC_CLEAR)
-			cache->disk_cache_state = BTRFS_DC_CLEAR;
+	spin_lock(&space_info->lock);
+	spin_lock(&cache->lock);
 
-		old_val = cache->used;
-		num_bytes = min(total, cache->length - byte_in_group);
-		if (alloc) {
-			old_val += num_bytes;
-			cache->used = old_val;
-			cache->reserved -= num_bytes;
-			space_info->bytes_reserved -= num_bytes;
-			space_info->bytes_used += num_bytes;
-			space_info->disk_used += num_bytes * factor;
-			spin_unlock(&cache->lock);
-			spin_unlock(&space_info->lock);
-		} else {
-			old_val -= num_bytes;
-			cache->used = old_val;
-			cache->pinned += num_bytes;
-			btrfs_space_info_update_bytes_pinned(info, space_info,
-							     num_bytes);
-			space_info->bytes_used -= num_bytes;
-			space_info->disk_used -= num_bytes * factor;
+	if (btrfs_test_opt(info, SPACE_CACHE) &&
+	    cache->disk_cache_state < BTRFS_DC_CLEAR)
+		cache->disk_cache_state = BTRFS_DC_CLEAR;
 
-			reclaim = should_reclaim_block_group(cache, num_bytes);
+	old_val = cache->used;
+	if (alloc) {
+		old_val += num_bytes;
+		cache->used = old_val;
+		cache->reserved -= num_bytes;
+		space_info->bytes_reserved -= num_bytes;
+		space_info->bytes_used += num_bytes;
+		space_info->disk_used += num_bytes * factor;
+		spin_unlock(&cache->lock);
+		spin_unlock(&space_info->lock);
+	} else {
+		old_val -= num_bytes;
+		cache->used = old_val;
+		cache->pinned += num_bytes;
+		btrfs_space_info_update_bytes_pinned(info, space_info, num_bytes);
+		space_info->bytes_used -= num_bytes;
+		space_info->disk_used -= num_bytes * factor;
 
-			spin_unlock(&cache->lock);
-			spin_unlock(&space_info->lock);
+		reclaim = should_reclaim_block_group(cache, num_bytes);
 
-			set_extent_bit(&trans->transaction->pinned_extents,
-				       bytenr, bytenr + num_bytes - 1,
-				       EXTENT_DIRTY, NULL);
-		}
+		spin_unlock(&cache->lock);
+		spin_unlock(&space_info->lock);
 
-		spin_lock(&trans->transaction->dirty_bgs_lock);
-		if (list_empty(&cache->dirty_list)) {
-			list_add_tail(&cache->dirty_list,
-				      &trans->transaction->dirty_bgs);
-			trans->delayed_ref_updates++;
-			btrfs_get_block_group(cache);
-		}
-		spin_unlock(&trans->transaction->dirty_bgs_lock);
+		set_extent_bit(&trans->transaction->pinned_extents, bytenr,
+			       bytenr + num_bytes - 1, EXTENT_DIRTY, NULL);
+	}
 
-		/*
-		 * No longer have used bytes in this block group, queue it for
-		 * deletion. We do this after adding the block group to the
-		 * dirty list to avoid races between cleaner kthread and space
-		 * cache writeout.
-		 */
-		if (!alloc && old_val == 0) {
-			if (!btrfs_test_opt(info, DISCARD_ASYNC))
-				btrfs_mark_bg_unused(cache);
-		} else if (!alloc && reclaim) {
-			btrfs_mark_bg_to_reclaim(cache);
-		}
+	spin_lock(&trans->transaction->dirty_bgs_lock);
+	if (list_empty(&cache->dirty_list)) {
+		list_add_tail(&cache->dirty_list, &trans->transaction->dirty_bgs);
+		trans->delayed_ref_updates++;
+		btrfs_get_block_group(cache);
+	}
+	spin_unlock(&trans->transaction->dirty_bgs_lock);
 
-		btrfs_put_block_group(cache);
-		total -= num_bytes;
-		bytenr += num_bytes;
+	/*
+	 * No longer have used bytes in this block group, queue it for deletion.
+	 * We do this after adding the block group to the dirty list to avoid
+	 * races between cleaner kthread and space cache writeout.
+	 */
+	if (!alloc && old_val == 0) {
+		if (!btrfs_test_opt(info, DISCARD_ASYNC))
+			btrfs_mark_bg_unused(cache);
+	} else if (!alloc && reclaim) {
+		btrfs_mark_bg_to_reclaim(cache);
 	}
 
+	btrfs_put_block_group(cache);
+
 	/* Modified block groups are accounted for in the delayed_refs_rsv. */
 	btrfs_update_delayed_refs_rsv(trans);
-	return ret;
+
+	return 0;
 }
 
 /*
-- 
2.53.0



