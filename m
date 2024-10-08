Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0751C9B99;
	Tue,  8 Oct 2024 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392719; cv=none; b=ckIdHCa8e38IIOmTvZb+gKR5EE7zUZJ+eDqOKGVuoSV7cRhBAn5dIWTY9XGfz23oQ2fjCKBKNN8AMZwA0tHTKQjA/9ip95geInL2AvjiaVBSDPQKcbWmyGVDb/UuPnbDYyQk4zteufnKSCSEJpzhYBqiBFqSYlI6oB4JewLLrrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392719; c=relaxed/simple;
	bh=rFYjWPZFfl0qxF+tM6STMxmHqFRZJXudeRzcMOBtkZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZGW4twZbEAyCr5pWImLt17EuWJJgZWooqcik0DM0Mzhjgu2FwJzvIqdYN7Hfz7N67d6fQe8uawYa+/eyuZjt6SdyLbGH0nBcTNi59eR8vF5jXHuASlMpvOGr/psfGgkJf/wklgAtEfCFi2CZbbli4/oQkw0tVuiDIY37UD1RMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILfYIOSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILfYIOSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BB9C4CEC7;
	Tue,  8 Oct 2024 13:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392718;
	bh=rFYjWPZFfl0qxF+tM6STMxmHqFRZJXudeRzcMOBtkZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILfYIOSLNU13a1PCQFGVq9jpMlnElC/1NWQIm6erjopoXH66hByKnC3LO1ti1k6Yb
	 6hP3+lHogPbfuk/OxZWexjRNPD9UaOAF0Ie0GoM7zG+vug6OP6eR8zQohmuBkdm6iF
	 KC96lfyOn6T3HooPDFEI35ijXUCc03xL9ScuCDeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 498/558] btrfs: drop the backref cache during relocation if we commit
Date: Tue,  8 Oct 2024 14:08:48 +0200
Message-ID: <20241008115721.828356367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit db7e68b522c01eb666cfe1f31637775f18997811 upstream.

Since the inception of relocation we have maintained the backref cache
across transaction commits, updating the backref cache with the new
bytenr whenever we COWed blocks that were in the cache, and then
updating their bytenr once we detected a transaction id change.

This works as long as we're only ever modifying blocks, not changing the
structure of the tree.

However relocation does in fact change the structure of the tree.  For
example, if we are relocating a data extent, we will look up all the
leaves that point to this data extent.  We will then call
do_relocation() on each of these leaves, which will COW down to the leaf
and then update the file extent location.

But, a key feature of do_relocation() is the pending list.  This is all
the pending nodes that we modified when we updated the file extent item.
We will then process all of these blocks via finish_pending_nodes, which
calls do_relocation() on all of the nodes that led up to that leaf.

The purpose of this is to make sure we don't break sharing unless we
absolutely have to.  Consider the case that we have 3 snapshots that all
point to this leaf through the same nodes, the initial COW would have
created a whole new path.  If we did this for all 3 snapshots we would
end up with 3x the number of nodes we had originally.  To avoid this we
will cycle through each of the snapshots that point to each of these
nodes and update their pointers to point at the new nodes.

Once we update the pointer to the new node we will drop the node we
removed the link for and all of its children via btrfs_drop_subtree().
This is essentially just btrfs_drop_snapshot(), but for an arbitrary
point in the snapshot.

The problem with this is that we will never reflect this in the backref
cache.  If we do this btrfs_drop_snapshot() for a node that is in the
backref tree, we will leave the node in the backref tree.  This becomes
a problem when we change the transid, as now the backref cache has
entire subtrees that no longer exist, but exist as if they still are
pointed to by the same roots.

In the best case scenario you end up with "adding refs to an existing
tree ref" errors from insert_inline_extent_backref(), where we attempt
to link in nodes on roots that are no longer valid.

Worst case you will double free some random block and re-use it when
there's still references to the block.

This is extremely subtle, and the consequences are quite bad.  There
isn't a way to make sure our backref cache is consistent between
transid's.

In order to fix this we need to simply evict the entire backref cache
anytime we cross transid's.  This reduces performance in that we have to
rebuild this backref cache every time we change transid's, but fixes the
bug.

This has existed since relocation was added, and is a pretty critical
bug.  There's a lot more cleanup that can be done now that this
functionality is going away, but this patch is as small as possible in
order to fix the problem and make it easy for us to backport it to all
the kernels it needs to be backported to.

Followup series will dismantle more of this code and simplify relocation
drastically to remove this functionality.

We have a reproducer that reproduced the corruption within a few minutes
of running.  With this patch it survives several iterations/hours of
running the reproducer.

Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
CC: stable@vger.kernel.org
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.c    |   12 +++++---
 fs/btrfs/relocation.c |   75 ++------------------------------------------------
 2 files changed, 11 insertions(+), 76 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3179,10 +3179,14 @@ void btrfs_backref_release_cache(struct
 		btrfs_backref_cleanup_node(cache, node);
 	}
 
-	cache->last_trans = 0;
-
-	for (i = 0; i < BTRFS_MAX_LEVEL; i++)
-		ASSERT(list_empty(&cache->pending[i]));
+	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
+		while (!list_empty(&cache->pending[i])) {
+			node = list_first_entry(&cache->pending[i],
+						struct btrfs_backref_node,
+						list);
+			btrfs_backref_cleanup_node(cache, node);
+		}
+	}
 	ASSERT(list_empty(&cache->pending_edge));
 	ASSERT(list_empty(&cache->useless_node));
 	ASSERT(list_empty(&cache->changed));
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -232,70 +232,6 @@ static struct btrfs_backref_node *walk_d
 	return NULL;
 }
 
-static void update_backref_node(struct btrfs_backref_cache *cache,
-				struct btrfs_backref_node *node, u64 bytenr)
-{
-	struct rb_node *rb_node;
-	rb_erase(&node->rb_node, &cache->rb_root);
-	node->bytenr = bytenr;
-	rb_node = rb_simple_insert(&cache->rb_root, node->bytenr, &node->rb_node);
-	if (rb_node)
-		btrfs_backref_panic(cache->fs_info, bytenr, -EEXIST);
-}
-
-/*
- * update backref cache after a transaction commit
- */
-static int update_backref_cache(struct btrfs_trans_handle *trans,
-				struct btrfs_backref_cache *cache)
-{
-	struct btrfs_backref_node *node;
-	int level = 0;
-
-	if (cache->last_trans == 0) {
-		cache->last_trans = trans->transid;
-		return 0;
-	}
-
-	if (cache->last_trans == trans->transid)
-		return 0;
-
-	/*
-	 * detached nodes are used to avoid unnecessary backref
-	 * lookup. transaction commit changes the extent tree.
-	 * so the detached nodes are no longer useful.
-	 */
-	while (!list_empty(&cache->detached)) {
-		node = list_entry(cache->detached.next,
-				  struct btrfs_backref_node, list);
-		btrfs_backref_cleanup_node(cache, node);
-	}
-
-	while (!list_empty(&cache->changed)) {
-		node = list_entry(cache->changed.next,
-				  struct btrfs_backref_node, list);
-		list_del_init(&node->list);
-		BUG_ON(node->pending);
-		update_backref_node(cache, node, node->new_bytenr);
-	}
-
-	/*
-	 * some nodes can be left in the pending list if there were
-	 * errors during processing the pending nodes.
-	 */
-	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
-		list_for_each_entry(node, &cache->pending[level], list) {
-			BUG_ON(!node->pending);
-			if (node->bytenr == node->new_bytenr)
-				continue;
-			update_backref_node(cache, node, node->new_bytenr);
-		}
-	}
-
-	cache->last_trans = 0;
-	return 1;
-}
-
 static bool reloc_root_is_dead(const struct btrfs_root *root)
 {
 	/*
@@ -551,9 +487,6 @@ static int clone_backref_node(struct btr
 	struct btrfs_backref_edge *new_edge;
 	struct rb_node *rb_node;
 
-	if (cache->last_trans > 0)
-		update_backref_cache(trans, cache);
-
 	rb_node = rb_simple_search(&cache->rb_root, src->commit_root->start);
 	if (rb_node) {
 		node = rb_entry(rb_node, struct btrfs_backref_node, rb_node);
@@ -3698,11 +3631,9 @@ static noinline_for_stack int relocate_b
 			break;
 		}
 restart:
-		if (update_backref_cache(trans, &rc->backref_cache)) {
-			btrfs_end_transaction(trans);
-			trans = NULL;
-			continue;
-		}
+		if (rc->backref_cache.last_trans != trans->transid)
+			btrfs_backref_release_cache(&rc->backref_cache);
+		rc->backref_cache.last_trans = trans->transid;
 
 		ret = find_next_extent(rc, path, &key);
 		if (ret < 0)


