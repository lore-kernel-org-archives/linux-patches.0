Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1359D384232;
	Sat, 12 Sep 2026 10:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210351; cv=none; b=RubPxqZbXSkBzlKhwX3XFjgmtbcKUkaqpGIOQt/Mu2Ol9dffSesyPq1z8IbqSaWFaKPFk4sn8CBH9gdPIBMD3xlYpZ90l81DFcU8iP4PVXZD/ChJc5Sk/My+wW+1MGXOtTPf/MX4EUO5sLXECKXWOF1oy7sr0C7BM117GOVv/EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210351; c=relaxed/simple;
	bh=Z6bnpD5s/BY2YGwRA5ZFsHlZAA+3qiEv5HVhFnwM+4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i32nAvrYOzyjbIwxWhH+Gu8dyCEdYxCGmUISS6DwV/u9a+o/G4ZZMHgqzq3DbC2MjoHk0D7P9HFBrSdGeS7LIbJAgaExRife+RWx8skfPLa/PPpasTJq8sbukT5Ew+suOggUkzoNhQ2CHIUgyqzvDht3d8luASpD+bvsqXX+oq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPI0DShe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPI0DShe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22B51F00893;
	Sat, 12 Sep 2026 10:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210350;
	bh=KbrF0EFNhJVyzszSy6TBXLic8m2oYMYKGeeaeixXikQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPI0DSheWqho6dXVXm1lLTdlygiGkERWvHomFM2LAizX+OR3I+Y51kMEjQ15FZCAV
	 1TaBumqNnNnzjyCz1AD8vl3heOfrqA1pg20RcbKJWgwjXRDu5TGw3ZT+ywMhiP/rvG
	 LoFD3Q6rSVA5PCpw0Nsq/5X0Zx9x8SaOEz2B/26s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Leo Martins <loemra.dev@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1006/1518] btrfs: avoid GFP_ATOMIC allocations in qgroup free paths
Date: Sat, 12 Sep 2026 08:52:55 +0200
Message-ID: <20260912065646.211661684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Martins <loemra.dev@gmail.com>

[ Upstream commit e0a85137a882db789b1bccc1e7db06356ac8c69f ]

When qgroups are enabled, __btrfs_qgroup_release_data() and
qgroup_free_reserved_data() pass an extent_changeset to
btrfs_clear_record_extent_bits() to track how many bytes had their
EXTENT_QGROUP_RESERVED bits cleared. Inside the extent IO tree spinlock,
add_extent_changeset() calls ulist_add() with GFP_ATOMIC to record each
changed range. If this allocation fails, it hits a BUG_ON and panics the
kernel.

However, both of these callers only read changeset.bytes_changed
afterwards — the range_changed ulist is populated and immediately freed
without ever being iterated. The GFP_ATOMIC allocation is entirely
unnecessary for these paths.

Introduce extent_changeset_init_bytes_only() which uses a sentinel value
(EXTENT_CHANGESET_BYTES_ONLY) on the ulist's prealloc field to signal
that only bytes_changed should be tracked. add_extent_changeset() checks
for this sentinel and returns early after updating bytes_changed,
skipping the ulist_add() call entirely. This eliminates the GFP_ATOMIC
allocation and makes the BUG_ON unreachable for these paths.

Callers that need range tracking (qgroup_reserve_data,
qgroup_unreserve_range, btrfs_qgroup_check_reserved_leak) continue to
use extent_changeset_init() and are unaffected.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 9102b179512e ("btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-io-tree.c |  3 +++
 fs/btrfs/extent_io.h      | 23 ++++++++++++++++++++++-
 fs/btrfs/qgroup.c         |  5 +++--
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index d0dd50f7d2795..2a2bce0f1f7c8 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -193,7 +193,10 @@ static int add_extent_changeset(struct extent_state *state, u32 bits,
 		return 0;
 	if (!set && (state->state & bits) == 0)
 		return 0;
+
 	changeset->bytes_changed += state->end - state->start + 1;
+	if (!extent_changeset_tracks_ranges(changeset))
+		return 0;
 
 	return ulist_add(&changeset->range_changed, state->start, state->end, GFP_ATOMIC);
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 73571d5d3d5ad..65d1ed3fcd5bf 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -196,6 +196,25 @@ static inline void extent_changeset_init(struct extent_changeset *changeset)
 	ulist_init(&changeset->range_changed);
 }
 
+/*
+ * Sentinel value for range_changed.prealloc indicating that the changeset
+ * only tracks bytes_changed and does not record individual ranges. This
+ * avoids GFP_ATOMIC allocations inside add_extent_changeset() when the
+ * caller doesn't need to iterate the changed ranges afterwards.
+ */
+#define EXTENT_CHANGESET_BYTES_ONLY	((struct ulist_node *)1)
+
+static inline void extent_changeset_init_bytes_only(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	changeset->range_changed.prealloc = EXTENT_CHANGESET_BYTES_ONLY;
+}
+
+static inline bool extent_changeset_tracks_ranges(const struct extent_changeset *changeset)
+{
+	return changeset->range_changed.prealloc != EXTENT_CHANGESET_BYTES_ONLY;
+}
+
 static inline struct extent_changeset *extent_changeset_alloc(void)
 {
 	struct extent_changeset *ret;
@@ -210,6 +229,7 @@ static inline struct extent_changeset *extent_changeset_alloc(void)
 
 static inline void extent_changeset_prealloc(struct extent_changeset *changeset, gfp_t gfp_mask)
 {
+	ASSERT(extent_changeset_tracks_ranges(changeset));
 	ulist_prealloc(&changeset->range_changed, gfp_mask);
 }
 
@@ -218,7 +238,8 @@ static inline void extent_changeset_release(struct extent_changeset *changeset)
 	if (!changeset)
 		return;
 	changeset->bytes_changed = 0;
-	ulist_release(&changeset->range_changed);
+	if (extent_changeset_tracks_ranges(changeset))
+		ulist_release(&changeset->range_changed);
 }
 
 static inline void extent_changeset_free(struct extent_changeset *changeset)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6fb01fb78a690..80c74166beefe 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4347,7 +4347,7 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 	u64 freed = 0;
 	int ret;
 
-	extent_changeset_init(&changeset);
+	extent_changeset_init_bytes_only(&changeset);
 	len = round_up(start + len, root->fs_info->sectorsize);
 	start = round_down(start, root->fs_info->sectorsize);
 
@@ -4412,7 +4412,7 @@ static int __btrfs_qgroup_release_data(struct btrfs_inode *inode,
 	WARN_ON(!free && reserved);
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len, released);
-	extent_changeset_init(&changeset);
+	extent_changeset_init_bytes_only(&changeset);
 	ret = btrfs_clear_record_extent_bits(&inode->io_tree, start, start + len - 1,
 					     EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
@@ -4667,6 +4667,7 @@ void btrfs_qgroup_check_reserved_leak(struct btrfs_inode *inode)
 
 	WARN_ON(ret < 0);
 	if (WARN_ON(changeset.bytes_changed)) {
+		ASSERT(extent_changeset_tracks_ranges(&changeset));
 		ULIST_ITER_INIT(&iter);
 		while ((unode = ulist_next(&changeset.range_changed, &iter))) {
 			btrfs_warn(inode->root->fs_info,
-- 
2.53.0



