Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7884A3921FB;
	Sat, 17 Oct 2026 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257969; cv=none; b=REIKAnBGPhQLrsLNJFs3BsQvi514F5pIQcfZfjOf7H21t8fs1Ic5vhj/qXG4S47UIB4T6kkOr3+dPiAFkm5jBEzCd4iiy0UA4CqEy7v2S4Tim9Q0ZDunfIcs7928TQJdkZbwntznVapEfMNUMpFbhrfV5N4oXInm1tLzEv7t6LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257969; c=relaxed/simple;
	bh=qAAt7BVtGYKLOxK3UJA322IJ7bSYjOIt4CTtocRhOFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLlEujD7E27YgQy1aZLwJ0k/a/FaqKtp60t6CliskJpp8SSXPRnzVUvSDuglKbxDKzp60cFpiG7dn/9xAK79jAOsKFiDI8YwZsoOExCcGm8IxioViptjIYSk1h+QDkt/WtvHwH+lCHFaH1qjR1nFjQtJeMQPYFp0BsBHIGMzwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+xqO/2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+xqO/2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7371F000C4;
	Sat, 17 Oct 2026 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257968;
	bh=rD9pTVx7KlmMANUuiIIFbySXvTXAbe12DGFWdUjyqHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+xqO/2hLRmT+r+eQf/Teatb2ab/BEUd5SNA1z+Zoy+5iqA7Aj+AreoHacBCHaM9o
	 nPSRlVgJEPEo9Gtvq0eYRkaYMSC6mwL2At54OVYj9pQsmxgAWEeX5886Yp6CXytqfs
	 mDyXWGzdgpDdwOiluULEPcqth5SSSp4tgHfs063Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0729/1674] btrfs: stop reserving excessive space for block group item updates
Date: Sat, 17 Oct 2026 17:50:01 +0200
Message-ID: <20261017160449.819960963@linuxfoundation.org>
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

[ Upstream commit f66e0209bd914465c277c259472aa974cad94e3f ]

Space for block group item updates, necessary after allocating or
deallocating an extent from a block group, is reserved in the delayed
refs block reserve. Currently we do this by incrementing the transaction
handle's delayed_ref_updates counter and then calling
btrfs_update_delayed_refs_rsv(), which will increase the size of the
delayed refs block reserve by an amount that corresponds to the same
amount we use for delayed refs, given by btrfs_calc_delayed_ref_bytes().

That is an excessive amount because it corresponds to the amount of space
needed to insert one item in a btree (btrfs_calc_insert_metadata_size())
times 2 when the free space tree feature is enabled. All we need is an
amount as given by btrfs_calc_metadata_size(), since we only need to
update an existing block group item in the extent tree (or block group
tree if this feature is enabled). By using btrfs_calc_metadata_size() we
will need to reserve 4 times less space when using the free space tree
and 2 times less space when not using it, putting less pressure on space
reservation.

So use helpers to reserve and release space for block group item updates
that use btrfs_calc_metadata_size() for calculation of the space.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7511e29cf135 ("btrfs: harden block_group::bg_list against list_del() races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 12 +++++++-----
 fs/btrfs/delayed-ref.c | 35 +++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-ref.h |  2 ++
 fs/btrfs/disk-io.c     |  2 +-
 4 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 4c817980fcdf5..c2c29bb9468f2 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1308,7 +1308,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	/* Once for the lookup reference */
 	btrfs_put_block_group(block_group);
 	if (remove_rsv)
-		btrfs_delayed_refs_rsv_release(fs_info, 1, 0);
+		btrfs_dec_delayed_refs_rsv_bg_updates(fs_info);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -3465,7 +3465,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 		if (should_put)
 			btrfs_put_block_group(cache);
 		if (drop_reserve)
-			btrfs_delayed_refs_rsv_release(fs_info, 1, 0);
+			btrfs_dec_delayed_refs_rsv_bg_updates(fs_info);
 		/*
 		 * Avoid blocking other tasks for too long. It might even save
 		 * us from writing caches for block groups that are going to be
@@ -3612,7 +3612,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 		/* If its not on the io list, we need to put the block group */
 		if (should_put)
 			btrfs_put_block_group(cache);
-		btrfs_delayed_refs_rsv_release(fs_info, 1, 0);
+		btrfs_dec_delayed_refs_rsv_bg_updates(fs_info);
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
@@ -3641,6 +3641,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group *cache;
 	u64 old_val;
 	bool reclaim = false;
+	bool bg_already_dirty = true;
 	int factor;
 
 	/* Block accounting for super block */
@@ -3709,7 +3710,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	spin_lock(&trans->transaction->dirty_bgs_lock);
 	if (list_empty(&cache->dirty_list)) {
 		list_add_tail(&cache->dirty_list, &trans->transaction->dirty_bgs);
-		trans->delayed_ref_updates++;
+		bg_already_dirty = false;
 		btrfs_get_block_group(cache);
 	}
 	spin_unlock(&trans->transaction->dirty_bgs_lock);
@@ -3729,7 +3730,8 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	btrfs_put_block_group(cache);
 
 	/* Modified block groups are accounted for in the delayed_refs_rsv. */
-	btrfs_update_delayed_refs_rsv(trans);
+	if (!bg_already_dirty)
+		btrfs_inc_delayed_refs_rsv_bg_updates(info);
 
 	return 0;
 }
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index d3b884c9753fa..39c3e2d9d401a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -106,6 +106,41 @@ void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans)
 	trans->delayed_ref_csum_deletions = 0;
 }
 
+/*
+ * Adjust the size of the delayed refs block reserve for 1 block group item
+ * update.
+ */
+void btrfs_inc_delayed_refs_rsv_bg_updates(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
+
+	spin_lock(&delayed_rsv->lock);
+	/*
+	 * Updating a block group item does not result in new nodes/leaves and
+	 * does not require changing the free space tree, only the extent tree
+	 * or the block group tree, so this is all we need.
+	 */
+	delayed_rsv->size += btrfs_calc_metadata_size(fs_info, 1);
+	delayed_rsv->full = false;
+	spin_unlock(&delayed_rsv->lock);
+}
+
+/*
+ * Adjust the size of the delayed refs block reserve to release space for 1
+ * block group item update.
+ */
+void btrfs_dec_delayed_refs_rsv_bg_updates(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
+	const u64 num_bytes = btrfs_calc_metadata_size(fs_info, 1);
+	u64 released;
+
+	released = btrfs_block_rsv_release(fs_info, delayed_rsv, num_bytes, NULL);
+	if (released > 0)
+		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
+					      0, released, 0);
+}
+
 /*
  * Transfer bytes to our delayed refs rsv.
  *
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index b4359daf3f2a3..fb2eebb13184f 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -415,6 +415,8 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq);
 
 void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr_refs, int nr_csums);
 void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
+void btrfs_inc_delayed_refs_rsv_bg_updates(struct btrfs_fs_info *fs_info);
+void btrfs_dec_delayed_refs_rsv_bg_updates(struct btrfs_fs_info *fs_info);
 int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
 				  enum btrfs_reserve_flush_enum flush);
 void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cd3883e670f07..adf649ec60beb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4859,7 +4859,7 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 
 		spin_unlock(&cur_trans->dirty_bgs_lock);
 		btrfs_put_block_group(cache);
-		btrfs_delayed_refs_rsv_release(fs_info, 1, 0);
+		btrfs_dec_delayed_refs_rsv_bg_updates(fs_info);
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
-- 
2.53.0



