Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9572717BED0;
	Sat, 17 Oct 2026 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257972; cv=none; b=ipZz4RLOUjAmTdzyj7iT6pU0w6dOtsvDs8BiIdhXPB2gIBaiIgQ+i34oeNp1h9BphRAX158FgFKmMxgiRfA7V5XMzMzKgU1apSVZLoXleuEZf/F0R1s0ybeZAUkkrj0ns30vMEV/mHGQjcOs8hceBL2+Rt7jkHm8glV+2l6yFoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257972; c=relaxed/simple;
	bh=MQ2Hr+QRZfM2unundhuZDhPg1i0UPDjfOr5Xjf79p3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kxu3Q7yRakn3YU8pFvNAm3QTPowOiycKLTX1EZ/zRkCDgtm8EMdHi/hjkwbdWL2OqMt6KUAkdaPAaFbbm3ixhH8fova8B80lz7JOC25t6ucVMSjtDHeYnVeRxIgVLWsuNF+OmwzXGyERe1Lf1NtwpxOlp47C43b/nFOVgFQ+qH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6jib0Dj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6jib0Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E301F000C4;
	Sat, 17 Oct 2026 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257971;
	bh=6T+kgZ2nfb8VaH17tEgLHA2sakwLO8UW8ps3Yrx5O64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6jib0Djntn0DrykFKmKIkkCRGAZP0CpTDgC+xkGBvuU0xWgJxIbb0IDPkm9JLfIi
	 /7ggpNiJbSmvfxkOZZoQNCj9zsCK0Hpg1IuPG0jyyl7/ZTPLPvHsS33601MYW9BGIz
	 8c0wXkiJ0hfagsUi6JqzZXC5IbE7UN+/2PE5e3Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0730/1674] btrfs: stop reserving excessive space for block group item insertions
Date: Sat, 17 Oct 2026 17:50:02 +0200
Message-ID: <20261017160449.843657356@linuxfoundation.org>
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

[ Upstream commit 9ef17228e1096e7e75bdde752ae1f0e9a5bcc8ab ]

Space for block group item insertions, necessary after allocating a new
block group, is reserved in the delayed refs block reserve. Currently we
do this by incrementing the transaction handle's delayed_ref_updates
counter and then calling btrfs_update_delayed_refs_rsv(), which will
increase the size of the delayed refs block reserve by an amount that
corresponds to the same amount we use for delayed refs, given by
btrfs_calc_delayed_ref_bytes().

That is an excessive amount because it corresponds to the amount of space
needed to insert one item in a btree (btrfs_calc_insert_metadata_size())
times 2 when the free space tree feature is enabled. All we need is an
amount as given by btrfs_calc_insert_metadata_size(), since we only need to
insert a block group item in the extent tree (or block group tree if this
feature is enabled). By using btrfs_calc_insert_metadata_size() we will
need to reserve 2 times less space when using the free space tree, putting
less pressure on space reservation.

So use helpers to reserve and release space for block group item
insertions that use btrfs_calc_insert_metadata_size() for calculation of
the space.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7511e29cf135 ("btrfs: harden block_group::bg_list against list_del() races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  5 ++---
 fs/btrfs/delayed-ref.c | 35 +++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-ref.h |  2 ++
 fs/btrfs/transaction.c |  2 +-
 4 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c2c29bb9468f2..4ea1fb222ba90 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2799,7 +2799,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 
 		/* Already aborted the transaction if it failed. */
 next:
-		btrfs_delayed_refs_rsv_release(fs_info, 1, 0);
+		btrfs_dec_delayed_refs_rsv_bg_inserts(fs_info);
 
 		spin_lock(&fs_info->unused_bgs_lock);
 		list_del_init(&block_group->bg_list);
@@ -2912,8 +2912,7 @@ struct btrfs_block_group *btrfs_make_block_group(struct btrfs_trans_handle *tran
 #endif
 
 	list_add_tail(&cache->bg_list, &trans->new_bgs);
-	trans->delayed_ref_updates++;
-	btrfs_update_delayed_refs_rsv(trans);
+	btrfs_inc_delayed_refs_rsv_bg_inserts(fs_info);
 
 	set_avail_alloc_bits(fs_info, type);
 	return cache;
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 39c3e2d9d401a..29e0a22e3d678 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -106,6 +106,41 @@ void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans)
 	trans->delayed_ref_csum_deletions = 0;
 }
 
+/*
+ * Adjust the size of the delayed refs block reserve for 1 block group item
+ * insertion, used after allocating a block group.
+ */
+void btrfs_inc_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
+
+	spin_lock(&delayed_rsv->lock);
+	/*
+	 * Inserting a block group item does not require changing the free space
+	 * tree, only the extent tree or the block group tree, so this is all we
+	 * need.
+	 */
+	delayed_rsv->size += btrfs_calc_insert_metadata_size(fs_info, 1);
+	delayed_rsv->full = false;
+	spin_unlock(&delayed_rsv->lock);
+}
+
+/*
+ * Adjust the size of the delayed refs block reserve to release space for 1
+ * block group item insertion.
+ */
+void btrfs_dec_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
+	const u64 num_bytes = btrfs_calc_insert_metadata_size(fs_info, 1);
+	u64 released;
+
+	released = btrfs_block_rsv_release(fs_info, delayed_rsv, num_bytes, NULL);
+	if (released > 0)
+		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
+					      0, released, 0);
+}
+
 /*
  * Adjust the size of the delayed refs block reserve for 1 block group item
  * update.
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index fb2eebb13184f..5dc4f2dc4f59b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -415,6 +415,8 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq);
 
 void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr_refs, int nr_csums);
 void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
+void btrfs_inc_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info);
+void btrfs_dec_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info);
 void btrfs_inc_delayed_refs_rsv_bg_updates(struct btrfs_fs_info *fs_info);
 void btrfs_dec_delayed_refs_rsv_bg_updates(struct btrfs_fs_info *fs_info);
 int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 615500dd37374..3fbf85cf3ad97 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2112,7 +2112,7 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
        struct btrfs_block_group *block_group, *tmp;
 
        list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
-               btrfs_delayed_refs_rsv_release(fs_info, 1, 0);
+               btrfs_dec_delayed_refs_rsv_bg_inserts(fs_info);
                list_del_init(&block_group->bg_list);
        }
 }
-- 
2.53.0



