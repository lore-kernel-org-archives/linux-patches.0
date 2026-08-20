Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184A247ECC6;
	Thu, 20 Aug 2026 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247194; cv=none; b=Uba0MwVhI3YwxZB5FPye+dMjvYvGAwbn4Qv0LyoGwkCVkMjTVEskyrJlHePTicv0ia0LMqGptrimeY7J5ljjw+4HlgwyxJilf3cJWV1F8FJfhOM/sz7uww1bqvPjYfflEk6eFvh7MI7pPZxuRAxFUuZ2A6Jx4yWIv8I+WmZoJPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247194; c=relaxed/simple;
	bh=7wtWZ5WAPciKAQJxQWs0BBKHvjODap7gXKpvDewB32o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJqZZRDcuT7b4iSQiBPpakf/VVgUC/tLxF5c30pBIU75TtaSCGqdHiCuVI6QGTI/bgeS8Qw0kPkbxgeXz+KaFf5wA5zDAkNYMYuqfE9ss90HEyBeS3+sIqOuSYsmvmoCQY2gWpnimWgNtpoHTpgiMAMxcrvDWlnSioWDj3QBJdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0W49pKO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0W49pKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B941F000E9;
	Thu, 20 Aug 2026 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247193;
	bh=R+ePNi7QffV4y3m5Z+oRAT0L/rcmcSr3LXkOfQLDTsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0W49pKOSVkBVwdrOIJPIAzJHxoVHUd+DVFbspD6mrOPgNVEM/Zm5MfZebvTuG6bX
	 yJjcCNizIcIP6iwlSkBApRKBF2dPztEchlmOji9ofMUp303ymhqHP8P/UsoQJ8Zjx9
	 Dp14qpDGQYH9qTTPMhzLlLtb2KJ0SVkVq01VU6dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/220] btrfs: add space_info argument to btrfs_chunk_alloc()
Date: Thu, 20 Aug 2026 16:55:34 +0200
Message-ID: <20260820145227.799554003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 098a442d5b6d440602604dc1a88706a2a91bce4e ]

Take a btrfs_space_info argument in btrfs_chunk_alloc(). New block group
will belong to that space_info.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bc4d7209611 ("btrfs: zoned: fix missing chunk metadata reservation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   27 +++++++++++++++++----------
 fs/btrfs/block-group.h |    3 ++-
 fs/btrfs/extent-tree.c |    6 ++++--
 fs/btrfs/space-info.c  |    2 +-
 fs/btrfs/transaction.c |    5 +++--
 5 files changed, 27 insertions(+), 16 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3003,6 +3003,7 @@ int btrfs_inc_block_group_ro(struct btrf
 			     bool do_chunk_alloc)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
+	struct btrfs_space_info *space_info = cache->space_info;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = btrfs_block_group_root(fs_info);
 	u64 alloc_flags;
@@ -3055,7 +3056,7 @@ int btrfs_inc_block_group_ro(struct btrf
 		 */
 		alloc_flags = btrfs_get_alloc_profile(fs_info, cache->flags);
 		if (alloc_flags != cache->flags) {
-			ret = btrfs_chunk_alloc(trans, alloc_flags,
+			ret = btrfs_chunk_alloc(trans, space_info, alloc_flags,
 						CHUNK_ALLOC_FORCE);
 			/*
 			 * ENOSPC is allowed here, we may have enough space
@@ -3083,15 +3084,15 @@ int btrfs_inc_block_group_ro(struct btrf
 	    (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM))
 		goto unlock_out;
 
-	alloc_flags = btrfs_get_alloc_profile(fs_info, cache->space_info->flags);
-	ret = btrfs_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
+	alloc_flags = btrfs_get_alloc_profile(fs_info, space_info->flags);
+	ret = btrfs_chunk_alloc(trans, space_info, alloc_flags, CHUNK_ALLOC_FORCE);
 	if (ret < 0)
 		goto out;
 	/*
 	 * We have allocated a new chunk. We also need to activate that chunk to
 	 * grant metadata tickets for zoned filesystem.
 	 */
-	ret = btrfs_zoned_activate_one_bg(fs_info, cache->space_info, true);
+	ret = btrfs_zoned_activate_one_bg(fs_info, space_info, true);
 	if (ret < 0)
 		goto out;
 
@@ -3941,8 +3942,15 @@ static int should_alloc_chunk(const stru
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type)
 {
 	u64 alloc_flags = btrfs_get_alloc_profile(trans->fs_info, type);
+	struct btrfs_space_info *space_info;
+
+	space_info = btrfs_find_space_info(trans->fs_info, type);
+	if (!space_info) {
+		DEBUG_WARN();
+		return -EINVAL;
+	}
 
-	return btrfs_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
+	return btrfs_chunk_alloc(trans, space_info, alloc_flags, CHUNK_ALLOC_FORCE);
 }
 
 static struct btrfs_block_group *do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
@@ -4138,6 +4146,8 @@ out:
  *
  * This function, btrfs_chunk_alloc(), belongs to phase 1.
  *
+ * @space_info: specify which space_info the new chunk should belong to.
+ *
  * If @force is CHUNK_ALLOC_FORCE:
  *    - return 1 if it successfully allocates a chunk,
  *    - return errors including -ENOSPC otherwise.
@@ -4146,11 +4156,11 @@ out:
  *    - return 1 if it successfully allocates a chunk,
  *    - return errors including -ENOSPC otherwise.
  */
-int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
+int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
+		      struct btrfs_space_info *space_info, u64 flags,
 		      enum btrfs_chunk_alloc_enum force)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_space_info *space_info;
 	struct btrfs_block_group *ret_bg;
 	bool wait_for_alloc = false;
 	bool should_alloc = false;
@@ -4189,9 +4199,6 @@ int btrfs_chunk_alloc(struct btrfs_trans
 	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		return -ENOSPC;
 
-	space_info = btrfs_find_space_info(fs_info, flags);
-	ASSERT(space_info);
-
 	do {
 		spin_lock(&space_info->lock);
 		if (force < space_info->force_alloc)
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -342,7 +342,8 @@ int btrfs_add_reserved_bytes(struct btrf
 			     bool force_wrong_size_class);
 void btrfs_free_reserved_bytes(struct btrfs_block_group *cache,
 			       u64 num_bytes, int delalloc);
-int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
+int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
+		      struct btrfs_space_info *space_info, u64 flags,
 		      enum btrfs_chunk_alloc_enum force);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type);
 void check_system_chunk(struct btrfs_trans_handle *trans, const u64 type);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4147,6 +4147,7 @@ static int can_allocate_chunk(struct btr
 static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 					struct btrfs_key *ins,
 					struct find_free_extent_ctl *ffe_ctl,
+					struct btrfs_space_info *space_info,
 					bool full_search)
 {
 	struct btrfs_root *root = fs_info->chunk_root;
@@ -4201,7 +4202,7 @@ static int find_free_extent_update_loop(
 				return ret;
 			}
 
-			ret = btrfs_chunk_alloc(trans, ffe_ctl->flags,
+			ret = btrfs_chunk_alloc(trans, space_info, ffe_ctl->flags,
 						CHUNK_ALLOC_FORCE_FOR_EXTENT);
 
 			/* Do not bail out on ENOSPC since we can do more. */
@@ -4601,7 +4602,8 @@ loop:
 	}
 	up_read(&space_info->groups_sem);
 
-	ret = find_free_extent_update_loop(fs_info, ins, ffe_ctl, full_search);
+	ret = find_free_extent_update_loop(fs_info, ins, ffe_ctl, space_info,
+					   full_search);
 	if (ret > 0)
 		goto search;
 
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -850,7 +850,7 @@ static void flush_space(struct btrfs_fs_
 			ret = PTR_ERR(trans);
 			break;
 		}
-		ret = btrfs_chunk_alloc(trans,
+		ret = btrfs_chunk_alloc(trans, space_info,
 				btrfs_get_alloc_profile(fs_info, space_info->flags),
 				(state == ALLOC_CHUNK) ? CHUNK_ALLOC_NO_FORCE :
 					CHUNK_ALLOC_FORCE);
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -764,9 +764,10 @@ got_it:
 	 * value here.
 	 */
 	if (do_chunk_alloc && num_bytes) {
-		u64 flags = h->block_rsv->space_info->flags;
+		struct btrfs_space_info *space_info = h->block_rsv->space_info;
+		u64 flags = space_info->flags;
 
-		btrfs_chunk_alloc(h, btrfs_get_alloc_profile(fs_info, flags),
+		btrfs_chunk_alloc(h, space_info, btrfs_get_alloc_profile(fs_info, flags),
 				  CHUNK_ALLOC_NO_FORCE);
 	}
 


