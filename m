Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054368;
	b=mZKISzQQ3Syhc4TurhURwfYeM4NRWQ5sEzsVdSvYBtkgHqRhzxg4snEHDkRWxe6B8jHj
	 YU61s+xyRihysu11CXLntzw9VahmvM012yuf5JTW26lsKrjBY1DaOw0oinmYSvHJRUq32
	 kFR4yt0TK/qvq3Pkg8WFNr9W2V9i1wxiq9u8mqOcfTYyloEEUkZDxiMkPfEwCo3Xr0Ob5
	 6HDrX6kXptl3Ny3s+1ycyonvw/3bUse6ZBdlbiVACxZbtsZiqh4s0c5TbwwawH5YDiaPJ
	 9ZN6h5Cp4HZAfOXgJSYA9kVdbpkbnII7uGUsfOH5o+9kMktkpQ53OnGJrPnlwbbxlCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7DA1GP2qWN5ZQuWngPELKhgnKghyV7Bszmr2cAI8CKI=;
	b=V5y7d9Un6tAS6Ak0IPqoOY6k0M6gtjKCnSqGXMVxNtLJyEIOXLUKc6Ke6pizY90YkuE9
	 LD7vb8XT0Zbe2IHIqBVZILFSpgYRYJ80A7R4GimgeY7YhL2woDKnAVfxczaiz25LOQ+//
	 rS01ncSh0/aybX4hbVKXdgL4qn3E7EyHqb6YUGGVtSHbEqzOODBDNzC4UE03WVeOCDpDT
	 u1DSSaAHem+8xmL5BjRqK49h9e4pGybMnfhmMY4z5z4VGCI/wJSU5VHZSGRzeISrLneRo
	 YVFsGP0tN3FCwi5VWmtPNcOsvZ3jbIWuPLTzvmxSXDWi9cL1blMBELNAE3J7cwQ4Jjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4l84age;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7595D606A333;
	Thu, 19 Nov 2026 02:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4l84age
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CD51F000C4;
	Thu, 19 Nov 2026 02:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054368;
	bh=7DA1GP2qWN5ZQuWngPELKhgnKghyV7Bszmr2cAI8CKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4l84ageGQD8R5XcX35xdvdF1Ba0XJ77bCY1HvHLr/LBaIlaO3NB+gEW71U1MzGgT
	 ocawX17TVHNtm5Z5AOtNTynGB7gdQeQrdhcNkAKencGK6dNRWTT2AdkEzMOw2mTaeN
	 d63/Uyv3TueK6vsoHk/UABHVlCBvJLiD5DGlBUPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1208/2214] assoc_array: choose between splitting a node and a shortcut without gotos
Date: Wed, 18 Nov 2026 15:48:04 +0100
Message-ID: <20261118150100.156026066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit c47aee71e14dd28d39fce95af83166d7a28a5f2b ]

With its jobs in functions, assoc_array_insert_into_terminal_node()
comes down to one decision: replace the node with a shortcut when every
leaf in it and the new key share one segment, or split it otherwise.
Write that as an if and an else, in place of the labels split_node,
do_split_node and all_leaves_cluster_together.

Each branch now works out where its replacement goes from that
replacement's own back pointer and parent slot, with
assoc_array_parent_link(), rather than both using the node's.  The two
are the same today.

None of the new functions is recursive, and gcc inlines all of them into
assoc_array_insert(), whose stack frame is 240 bytes after this series
against 224 before it, on an x86-64 defconfig.

No functional change.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Stable-dep-of: 48691075b0ad ("assoc_array: don't chain a new shortcut onto an existing one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 127 ++++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 66 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index e3924ed4d3e9f..ddab703561875 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -469,6 +469,21 @@ static bool assoc_array_insert_in_empty_tree(struct assoc_array_edit *edit)
 	return true;
 }
 
+/*
+ * The pointer that leads to a node or shortcut with the given back pointer
+ * and parent slot: the root, a slot in a node, or a shortcut's next node.
+ */
+static struct assoc_array_ptr **assoc_array_parent_link(struct assoc_array *array,
+							struct assoc_array_ptr *back_pointer,
+							int parent_slot)
+{
+	if (!back_pointer)
+		return &array->root;
+	if (assoc_array_ptr_is_node(back_pointer))
+		return &assoc_array_ptr_to_node(back_pointer)->slots[parent_slot];
+	return &assoc_array_ptr_to_shortcut(back_pointer)->next_node;
+}
+
 /*
  * Insert into a terminal node without changing its shape, if that can be
  * done: in place of a leaf with the same index key, or in a free slot.
@@ -547,6 +562,20 @@ static bool assoc_array_fill_segment_cache(struct assoc_array_edit *edit,
 	return have_meta;
 }
 
+/*
+ * Whether the leaves of a full node and the new key all share one segment,
+ * so that splitting the node cannot make room.
+ */
+static bool assoc_array_all_one_segment(const struct assoc_array_edit *edit)
+{
+	int i;
+
+	for (i = 1; i < ASSOC_ARRAY_FAN_OUT + 1; i++)
+		if (edit->segment_cache[i] != edit->segment_cache[0])
+			return false;
+	return true;
+}
+
 /*
  * Split a full node into new_n0, which takes its place, and new_n1, below
  * new_n0 in the slot of a segment that at least two of the leaves share,
@@ -735,11 +764,8 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 {
 	struct assoc_array_shortcut *new_s0;
 	struct assoc_array_node *node, *new_n0, *new_n1;
-	struct assoc_array_ptr *ptr;
-	unsigned long dissimilarity, base_seg;
 	bool have_meta;
 	int level;
-	int i;
 
 	node	= result->terminal_node.node;
 	level	= result->terminal_node.level;
@@ -777,78 +803,47 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	have_meta = assoc_array_fill_segment_cache(edit, ops, node, level);
 	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = result->terminal_node.slot;
 
-	if (have_meta) {
-		pr_devel("have meta\n");
-		goto split_node;
-	}
-
-	/* The node contains only leaves */
-	dissimilarity = 0;
-	base_seg = edit->segment_cache[0];
-	for (i = 1; i < ASSOC_ARRAY_FAN_OUT; i++)
-		dissimilarity |= edit->segment_cache[i] ^ base_seg;
-
-	pr_devel("only leaves; dissimilarity=%lx\n", dissimilarity);
-
-	if ((dissimilarity & ASSOC_ARRAY_FAN_MASK) == 0) {
-		/* The old leaves all cluster in the same slot.  We will need
-		 * to insert a shortcut if the new node wants to cluster with them.
+	if (!have_meta && assoc_array_all_one_segment(edit)) {
+		/* The node only contains leaves and all the leaves cluster in
+		 * the same slot, so we need to insert a shortcut to skip the
+		 * common portion of the key and split the node at the
+		 * shortcut's far end.
 		 */
-		if ((edit->segment_cache[ASSOC_ARRAY_FAN_OUT] ^ base_seg) == 0)
-			goto all_leaves_cluster_together;
-
-		/* Otherwise all the old leaves cluster in the same slot, but
-		 * the new leaf wants to go into a different slot - so we
-		 * create a new node (n0) to hold the new leaf and a pointer to
-		 * a new node (n1) holding all the old leaves.
+		new_s0 = assoc_array_insert_shortcut(edit, ops, index_key,
+						     node, level, new_n0);
+		if (!new_s0)
+			return false;
+		edit->set[0].ptr = assoc_array_parent_link(edit->array,
+							   new_s0->back_pointer,
+							   new_s0->parent_slot);
+		edit->set[0].to = assoc_array_shortcut_to_ptr(new_s0);
+	} else {
+		/* We need to split the current node.  The node must contain
+		 * anything from a single leaf (in the one leaf case, this leaf
+		 * will cluster with the new leaf) and the rest meta-pointers,
+		 * to all leaves, some of which may cluster.
+		 *
+		 * We need to expel at least two leaves out of a set consisting
+		 * of the leaves in the node and the new leaf.  The current meta
+		 * pointers can just be copied as they shouldn't cluster with
+		 * any of the leaves.  If all the old leaves cluster in one slot
+		 * and the new leaf does not, they all go and the new leaf stays.
 		 *
-		 * This can be done by falling through to the node splitting
-		 * path.
+		 * We need a new node (n0) to replace the current one and a new
+		 * node to take the expelled nodes (n1).
 		 */
-		pr_devel("present leaves cluster but not new leaf\n");
+		new_n0->back_pointer = node->back_pointer;
+		new_n0->parent_slot = node->parent_slot;
+		edit->set[0].ptr = assoc_array_parent_link(edit->array,
+							   new_n0->back_pointer,
+							   new_n0->parent_slot);
+		edit->set[0].to = assoc_array_node_to_ptr(new_n0);
 	}
 
-split_node:
-	/* We need to split the current node.  The node must contain anything
-	 * from a single leaf (in the one leaf case, this leaf will cluster
-	 * with the new leaf) and the rest meta-pointers, to all leaves, some
-	 * of which may cluster.
-	 *
-	 * It won't contain the case in which all the current leaves plus the
-	 * new leaves want to cluster in the same slot.
-	 *
-	 * We need to expel at least two leaves out of a set consisting of the
-	 * leaves in the node and the new leaf.  The current meta pointers can
-	 * just be copied as they shouldn't cluster with any of the leaves.
-	 *
-	 * We need a new node (n0) to replace the current one and a new node to
-	 * take the expelled nodes (n1).
-	 */
-	edit->set[0].to = assoc_array_node_to_ptr(new_n0);
-	new_n0->back_pointer = node->back_pointer;
-	new_n0->parent_slot = node->parent_slot;
-
-do_split_node:
 	assoc_array_split_node(edit, node, new_n0, new_n1);
-
-	ptr = node->back_pointer;
-	if (!ptr)
-		edit->set[0].ptr = &edit->array->root;
-	else if (assoc_array_ptr_is_node(ptr))
-		edit->set[0].ptr = &assoc_array_ptr_to_node(ptr)->slots[node->parent_slot];
-	else
-		edit->set[0].ptr = &assoc_array_ptr_to_shortcut(ptr)->next_node;
 	edit->excised_meta[0] = assoc_array_node_to_ptr(node);
 	pr_devel("<--%s() = ok [split node]\n", __func__);
 	return true;
-
-all_leaves_cluster_together:
-	new_s0 = assoc_array_insert_shortcut(edit, ops, index_key,
-					     node, level, new_n0);
-	if (!new_s0)
-		return false;
-	edit->set[0].to = assoc_array_shortcut_to_ptr(new_s0);
-	goto do_split_node;
 }
 
 /*
-- 
2.53.0



