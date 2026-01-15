Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D015D25228D;
	Thu, 15 Jan 2026 16:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496074; cv=none; b=RZCrrTY9I8RcabDbrCoRKElBcfJErM5SHKWKQy+JLigT9qtLdeSD7K9lfc8xYAwgLfJxBxzO8wZIgJYOQxPrxFoFw+GvDg3PzJvt51RLtnkGi4WlpHAx9b2pSlk4k6LqMlb2a/UiE1TUvQc3Ah/pWth2YSSklJ6RYNSqbWRGu6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496074; c=relaxed/simple;
	bh=EJYfuMv2V93SgM8SRO+GZjKGxZoHIUTuiBn5XrIdDQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3HOgBWf6o0JwkvMKt+Gk0MjwWckJ6bMqNTRfzewzKAh3d6+oAN4EGqWx3X43k/7qt0kNtxxhin/4gb76MnzIba4/xN/2Hyv7g1IQnlaMFSwTPFm1UDQZc/5CB9ZnDSZBpiuVjOBDVJWR6FqRKObNy9BFpcLb9s/M57cxDZm9l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wT+hrthA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wT+hrthA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5D5C116D0;
	Thu, 15 Jan 2026 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496074;
	bh=EJYfuMv2V93SgM8SRO+GZjKGxZoHIUTuiBn5XrIdDQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wT+hrthAF8OulMXO63Qp9Hee1lOyhB3y0I8yZA0XRcvA+5h5SFRrXGB+nXJuUcs8Z
	 8K86boEP5cLmMCSgIotOBcrvx07WyHasT1Tx4FN6girhpjorIn6pqfrx/pAdE0dVj+
	 KCBVE2AUcQHGp7jU/3C7TW0jWXOXDQJgUZKFXA+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Filipe Manana <fdmanana@suse.com>,
	Leo Martins <loemra.dev@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/181] btrfs: fix use-after-free warning in btrfs_get_or_create_delayed_node()
Date: Thu, 15 Jan 2026 17:46:44 +0100
Message-ID: <20260115164204.744515531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Leo Martins <loemra.dev@gmail.com>

[ Upstream commit 83f59076a1ae6f5c6845d6f7ed3a1a373d883684 ]

Previously, btrfs_get_or_create_delayed_node() set the delayed_node's
refcount before acquiring the root->delayed_nodes lock.
Commit e8513c012de7 ("btrfs: implement ref_tracker for delayed_nodes")
moved refcount_set inside the critical section, which means there is
no longer a memory barrier between setting the refcount and setting
btrfs_inode->delayed_node.

Without that barrier, the stores to node->refs and
btrfs_inode->delayed_node may become visible out of order. Another
thread can then read btrfs_inode->delayed_node and attempt to
increment a refcount that hasn't been set yet, leading to a
refcounting bug and a use-after-free warning.

The fix is to move refcount_set back to where it was to take
advantage of the implicit memory barrier provided by lock
acquisition.

Because the allocations now happen outside of the lock's critical
section, they can use GFP_NOFS instead of GFP_ATOMIC.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202511262228.6dda231e-lkp@intel.com
Fixes: e8513c012de7 ("btrfs: implement ref_tracker for delayed_nodes")
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3df7b9d7fbe8d..59b489d7e4b58 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -152,37 +152,39 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 		return ERR_PTR(-ENOMEM);
 	btrfs_init_delayed_node(node, root, ino);
 
+	/* Cached in the inode and can be accessed. */
+	refcount_set(&node->refs, 2);
+	btrfs_delayed_node_ref_tracker_alloc(node, tracker, GFP_NOFS);
+	btrfs_delayed_node_ref_tracker_alloc(node, &node->inode_cache_tracker, GFP_NOFS);
+
 	/* Allocate and reserve the slot, from now it can return a NULL from xa_load(). */
 	ret = xa_reserve(&root->delayed_nodes, ino, GFP_NOFS);
-	if (ret == -ENOMEM) {
-		btrfs_delayed_node_ref_tracker_dir_exit(node);
-		kmem_cache_free(delayed_node_cache, node);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (ret == -ENOMEM)
+		goto cleanup;
+
 	xa_lock(&root->delayed_nodes);
 	ptr = xa_load(&root->delayed_nodes, ino);
 	if (ptr) {
 		/* Somebody inserted it, go back and read it. */
 		xa_unlock(&root->delayed_nodes);
-		btrfs_delayed_node_ref_tracker_dir_exit(node);
-		kmem_cache_free(delayed_node_cache, node);
-		node = NULL;
-		goto again;
+		goto cleanup;
 	}
 	ptr = __xa_store(&root->delayed_nodes, ino, node, GFP_ATOMIC);
 	ASSERT(xa_err(ptr) != -EINVAL);
 	ASSERT(xa_err(ptr) != -ENOMEM);
 	ASSERT(ptr == NULL);
-
-	/* Cached in the inode and can be accessed. */
-	refcount_set(&node->refs, 2);
-	btrfs_delayed_node_ref_tracker_alloc(node, tracker, GFP_ATOMIC);
-	btrfs_delayed_node_ref_tracker_alloc(node, &node->inode_cache_tracker, GFP_ATOMIC);
-
 	btrfs_inode->delayed_node = node;
 	xa_unlock(&root->delayed_nodes);
 
 	return node;
+cleanup:
+	btrfs_delayed_node_ref_tracker_free(node, tracker);
+	btrfs_delayed_node_ref_tracker_free(node, &node->inode_cache_tracker);
+	btrfs_delayed_node_ref_tracker_dir_exit(node);
+	kmem_cache_free(delayed_node_cache, node);
+	if (ret)
+		return ERR_PTR(ret);
+	goto again;
 }
 
 /*
-- 
2.51.0



