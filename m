Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDBD4F55C6;
	Tue, 13 Oct 2026 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893313; cv=none; b=Gia02aIC210NhF+3OA7qG6WZubmi9aC6wSkjgh2fgRNlC8PLigl4eLeXgjHk2DY+cnzYfVtRp6rBN+WfFOyia0/YYYFrnJvEfVMR/bDXyNogQUJ6sfrY3Eoqrt+6nSwi29Y/6JJs498VFnNXZ2ithd8oHqiWz/yIG8+UA59OGZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893313; c=relaxed/simple;
	bh=CLT4jPDDkGLpzvAlIEWVf7Cf2AIH/nKuSLkCnvqzJCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/b46blWnMXGdOEq1jIgcBsYFj9otK93h+s15blbVmlpDWtqDyUtdd/+NGwOz/tM+QlTecPGlgAlFRDghgXenkM1YRBchmlW6/pDmG+mWy+4SmupVepT/dh11zzfTTIaEflIUjy+peOWwf124jv6dTUvVoR99YkcRi4eyPzomt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVpLhswI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVpLhswI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B20D1F000FF;
	Tue, 13 Oct 2026 12:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893312;
	bh=kUzySmpR83N+Vtn+a5JJhpRCdDYTNlNuL1xT6V48a7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVpLhswIN07keihWRlZxD/7RoVI97oxR+jpTeIMNT6lpZDOQhCOb35LDR7LIdE+MA
	 vi4l+CZUuov/Jy57h6uLZ6da1WgRVbQKsUAWyFlqkQ4Nv2VYP2UZXSVT992SBtvvUj
	 OWTd5hZVE7aRolEKc1aSKeUFO0jqB2v/MwwbEpeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/621] btrfs: remove reserved argument from btrfs_pin_extent()
Date: Tue, 13 Oct 2026 13:32:59 +0200
Message-ID: <20261013112925.228772038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 8dcb8e4b110d86aaae2c485622423b6f63a65408 ]

All callers pass a value of 1 (true) to it, so remove it.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: c7d1d4ff5674 ("btrfs: don't BUG() on unexpected delayed ref type in run_one_delayed_ref()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 15 +++++++--------
 fs/btrfs/extent-tree.h |  3 +--
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7c199d59a5465..cbd57c46d3244 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1764,7 +1764,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (TRANS_ABORTED(trans)) {
 		if (insert_reserved) {
-			btrfs_pin_extent(trans, node->bytenr, node->num_bytes, 1);
+			btrfs_pin_extent(trans, node->bytenr, node->num_bytes);
 			free_head_ref_squota_rsv(trans->fs_info, href);
 		}
 		return 0;
@@ -1783,7 +1783,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 	else
 		BUG();
 	if (ret && insert_reserved)
-		btrfs_pin_extent(trans, node->bytenr, node->num_bytes, 1);
+		btrfs_pin_extent(trans, node->bytenr, node->num_bytes);
 	if (ret < 0)
 		btrfs_err(trans->fs_info,
 "failed to run delayed ref for logical %llu num_bytes %llu type %u action %u ref_mod %d: %d",
@@ -1890,7 +1890,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 	spin_unlock(&delayed_refs->lock);
 
 	if (head->must_insert_reserved) {
-		btrfs_pin_extent(trans, head->bytenr, head->num_bytes, 1);
+		btrfs_pin_extent(trans, head->bytenr, head->num_bytes);
 		if (head->is_data) {
 			struct btrfs_root *csum_root;
 
@@ -2607,15 +2607,14 @@ static int pin_down_extent(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_pin_extent(struct btrfs_trans_handle *trans,
-		     u64 bytenr, u64 num_bytes, int reserved)
+int btrfs_pin_extent(struct btrfs_trans_handle *trans, u64 bytenr, u64 num_bytes)
 {
 	struct btrfs_block_group *cache;
 
 	cache = btrfs_lookup_block_group(trans->fs_info, bytenr);
 	BUG_ON(!cache); /* Logic error */
 
-	pin_down_extent(trans, cache, bytenr, num_bytes, reserved);
+	pin_down_extent(trans, cache, bytenr, num_bytes, 1);
 
 	btrfs_put_block_group(cache);
 	return 0;
@@ -3524,7 +3523,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_ref *ref)
 	 * tree, just update pinning info and exit early.
 	 */
 	if (ref->ref_root == BTRFS_TREE_LOG_OBJECTID) {
-		btrfs_pin_extent(trans, ref->bytenr, ref->num_bytes, 1);
+		btrfs_pin_extent(trans, ref->bytenr, ref->num_bytes);
 		ret = 0;
 	} else if (ref->type == BTRFS_REF_METADATA) {
 		ret = btrfs_add_delayed_tree_ref(trans, ref, NULL);
@@ -5007,7 +5006,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	ret = alloc_reserved_file_extent(trans, 0, root_objectid, 0, owner,
 					 offset, ins, 1, root_objectid);
 	if (ret)
-		btrfs_pin_extent(trans, ins->objectid, ins->offset, 1);
+		btrfs_pin_extent(trans, ins->objectid, ins->offset);
 	ret = btrfs_record_squota_delta(fs_info, &delta);
 	btrfs_put_block_group(block_group);
 	return ret;
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index e970ac42a871a..e573509c5a71d 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -110,8 +110,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 offset, int metadata, u64 *refs, u64 *flags,
 			     u64 *owner_root);
-int btrfs_pin_extent(struct btrfs_trans_handle *trans, u64 bytenr, u64 num,
-		     int reserved);
+int btrfs_pin_extent(struct btrfs_trans_handle *trans, u64 bytenr, u64 num);
 int btrfs_pin_extent_for_log_replay(struct btrfs_trans_handle *trans,
 				    const struct extent_buffer *eb);
 int btrfs_exclude_logged_extents(struct extent_buffer *eb);
-- 
2.53.0



