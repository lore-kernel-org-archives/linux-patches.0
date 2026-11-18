Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054362;
	b=4CIq3LTFlpYBnYpfNH8BvyqqRNv4NAV1DJJqczMe6Rsdza7zAJeAS9RtdSe5gjRtxys9
	 bpgckM5gLbHRybhTTVqG6wzto+eTSNWlCrQINhMPzqHGyK9KcfEemM1JrQ9DDn3k2b6XS
	 PdszZ2KvJcb9sjMzxdj8k3P78XqRsrCkwh6u3scPtCQ9JPxsYd7+36mqP5J5x6acvgZXX
	 dcvtW8MGjLuf/092mNO5TPi0g0swcoGVQRlfci8bQ9uFiULPG4h8VLnaFI2BUKMqvF+rl
	 I9RT+8TJh4T8rjUm8qc5CU2QpjjbhgVyavFUW+A8jwydR1ppoA2BDrNp1roMS7GFF3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mwZBHTJjzop/UNTw7yHpm6i0SordeftjWCECXmoglWU=;
	b=UXHSuOnsfSq5S+JvGJmkv8/unQpbx3HKMNejXg4PWjt7bp6zAxrIu0NRf4yLrS++25F0
	 M7Mw6fVUHETU356udl5K9yBqOpfuIrwcVrfqHrRRuiPGjXGyx89kHa7c35n24bN7hbzQm
	 VNC58durVZ607Kh5T6nqXYp/uiUgl6EeVrg0Etedn+52xQg8Q/xaLPuoNatysqL9NB7Wc
	 abOVlIpQ9+DAbRAW9I8OY6ja0geGoMo1o4L+R5NL2Av5T07/rHaOQ5MGgpQDQyAe+rZDb
	 zFJu0VjRZ9edlJ3ZI/ucg3dTw3HjUKzbB1kuAUkx6fBmdE2msASHpwjoiw1lT2TCJXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXk0x8xM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABD7606A31C;
	Thu, 19 Nov 2026 02:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXk0x8xM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1181F000C4;
	Thu, 19 Nov 2026 02:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054362;
	bh=mwZBHTJjzop/UNTw7yHpm6i0SordeftjWCECXmoglWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXk0x8xMqGdSGxzw9g7M02dej3grvo31dhoAEMVeQ9DVrQQora413hdsLtD7YPfQ9
	 GjlyAMegZcoUw/EJWlCzbJtFRNdW3Kcm05kbBK+Q9caIuU8WmhdZjqrFez73AptKoW
	 erBWgNjoiuUMrfUvMwim9/u6O9BH+Yqq29Q7wE3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1206/2214] assoc_array: move node splitting into a function of its own
Date: Wed, 18 Nov 2026 15:48:02 +0100
Message-ID: <20261118150100.091898454@linuxfoundation.org>
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

[ Upstream commit 3c99a07bc82b051771ce0eb69274aceb9abf1eb7 ]

Move the code after the do_split_node label into
assoc_array_split_node(), which both the split path and the shortcut
path still reach through that label.

It sets new_n1's back pointer itself, which both paths did before
jumping there, and it no longer sets new_n1's parent slot to -1 first:
it always sets the real one.

No functional change.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Stable-dep-of: 48691075b0ad ("assoc_array: don't chain a new shortcut onto an existing one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 194 +++++++++++++++++++++++++---------------------
 1 file changed, 104 insertions(+), 90 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 600b2d85bccb6..dba1c72ed49d9 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -547,6 +547,106 @@ static bool assoc_array_fill_segment_cache(struct assoc_array_edit *edit,
 	return have_meta;
 }
 
+/*
+ * Split a full node into new_n0, which takes its place, and new_n1, below
+ * new_n0 in the slot of a segment that at least two of the leaves share,
+ * the new one included.  The caller has filled in the segment cache and
+ * set new_n0's back pointer and parent slot.
+ */
+static void assoc_array_split_node(struct assoc_array_edit *edit,
+				   struct assoc_array_node *node,
+				   struct assoc_array_node *new_n0,
+				   struct assoc_array_node *new_n1)
+{
+	struct assoc_array_shortcut *shortcut;
+	struct assoc_array_node *side;
+	struct assoc_array_ptr *ptr;
+	int slot, next_slot, free_slot, i, j;
+
+	pr_devel("split node\n");
+
+	new_n1->back_pointer = assoc_array_node_to_ptr(new_n0);
+	new_n0->nr_leaves_on_branch = node->nr_leaves_on_branch;
+	new_n1->nr_leaves_on_branch = 0;
+
+	/* Begin by finding two matching leaves.  There have to be at least two
+	 * that match - even if there are meta pointers - because any leaf that
+	 * would match a slot with a meta pointer in it must be somewhere
+	 * behind that meta pointer and cannot be here.  Further, given N
+	 * remaining leaf slots, we now have N+1 leaves to go in them.
+	 */
+	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
+		slot = edit->segment_cache[i];
+		if (slot != 0xff)
+			for (j = i + 1; j < ASSOC_ARRAY_FAN_OUT + 1; j++)
+				if (edit->segment_cache[j] == slot)
+					goto found_slot_for_multiple_occupancy;
+	}
+found_slot_for_multiple_occupancy:
+	pr_devel("same slot: %x %x [%02x]\n", i, j, slot);
+	BUG_ON(i >= ASSOC_ARRAY_FAN_OUT);
+	BUG_ON(j >= ASSOC_ARRAY_FAN_OUT + 1);
+	BUG_ON(slot >= ASSOC_ARRAY_FAN_OUT);
+
+	new_n1->parent_slot = slot;
+
+	/* Metadata pointers cannot change slot */
+	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++)
+		if (assoc_array_ptr_is_meta(node->slots[i]))
+			new_n0->slots[i] = node->slots[i];
+		else
+			new_n0->slots[i] = NULL;
+	BUG_ON(new_n0->slots[slot] != NULL);
+	new_n0->slots[slot] = assoc_array_node_to_ptr(new_n1);
+
+	/* Filter the leaf pointers between the new nodes */
+	free_slot = -1;
+	next_slot = 0;
+	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
+		if (assoc_array_ptr_is_meta(node->slots[i]))
+			continue;
+		if (edit->segment_cache[i] == slot) {
+			new_n1->slots[next_slot++] = node->slots[i];
+			new_n1->nr_leaves_on_branch++;
+		} else {
+			do {
+				free_slot++;
+			} while (new_n0->slots[free_slot] != NULL);
+			new_n0->slots[free_slot] = node->slots[i];
+		}
+	}
+
+	pr_devel("filtered: f=%x n=%x\n", free_slot, next_slot);
+
+	if (edit->segment_cache[ASSOC_ARRAY_FAN_OUT] != slot) {
+		do {
+			free_slot++;
+		} while (new_n0->slots[free_slot] != NULL);
+		edit->leaf_p = &new_n0->slots[free_slot];
+		edit->adjust_count_on = new_n0;
+	} else {
+		edit->leaf_p = &new_n1->slots[next_slot++];
+		edit->adjust_count_on = new_n1;
+	}
+
+	BUG_ON(next_slot <= 1);
+
+	edit->set_backpointers_to = assoc_array_node_to_ptr(new_n0);
+	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
+		if (edit->segment_cache[i] == 0xff) {
+			ptr = node->slots[i];
+			BUG_ON(assoc_array_ptr_is_leaf(ptr));
+			if (assoc_array_ptr_is_node(ptr)) {
+				side = assoc_array_ptr_to_node(ptr);
+				edit->set_backpointers[i] = &side->back_pointer;
+			} else {
+				shortcut = assoc_array_ptr_to_shortcut(ptr);
+				edit->set_backpointers[i] = &shortcut->back_pointer;
+			}
+		}
+	}
+}
+
 /*
  * Handle insertion into a terminal node.
  */
@@ -555,14 +655,14 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 						  const void *index_key,
 						  struct assoc_array_walk_result *result)
 {
-	struct assoc_array_shortcut *shortcut, *new_s0;
-	struct assoc_array_node *node, *new_n0, *new_n1, *side;
+	struct assoc_array_shortcut *new_s0;
+	struct assoc_array_node *node, *new_n0, *new_n1;
 	struct assoc_array_ptr *ptr;
 	unsigned long dissimilarity, base_seg, blank;
 	size_t keylen;
 	bool have_meta;
 	int level, diff;
-	int slot, next_slot, free_slot, i, j;
+	int i;
 
 	node	= result->terminal_node.node;
 	level	= result->terminal_node.level;
@@ -632,8 +732,6 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	}
 
 split_node:
-	pr_devel("split node\n");
-
 	/* We need to split the current node.  The node must contain anything
 	 * from a single leaf (in the one leaf case, this leaf will cluster
 	 * with the new leaf) and the rest meta-pointers, to all leaves, some
@@ -652,91 +750,9 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	edit->set[0].to = assoc_array_node_to_ptr(new_n0);
 	new_n0->back_pointer = node->back_pointer;
 	new_n0->parent_slot = node->parent_slot;
-	new_n1->back_pointer = assoc_array_node_to_ptr(new_n0);
-	new_n1->parent_slot = -1; /* Need to calculate this */
 
 do_split_node:
-	pr_devel("do_split_node\n");
-
-	new_n0->nr_leaves_on_branch = node->nr_leaves_on_branch;
-	new_n1->nr_leaves_on_branch = 0;
-
-	/* Begin by finding two matching leaves.  There have to be at least two
-	 * that match - even if there are meta pointers - because any leaf that
-	 * would match a slot with a meta pointer in it must be somewhere
-	 * behind that meta pointer and cannot be here.  Further, given N
-	 * remaining leaf slots, we now have N+1 leaves to go in them.
-	 */
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		slot = edit->segment_cache[i];
-		if (slot != 0xff)
-			for (j = i + 1; j < ASSOC_ARRAY_FAN_OUT + 1; j++)
-				if (edit->segment_cache[j] == slot)
-					goto found_slot_for_multiple_occupancy;
-	}
-found_slot_for_multiple_occupancy:
-	pr_devel("same slot: %x %x [%02x]\n", i, j, slot);
-	BUG_ON(i >= ASSOC_ARRAY_FAN_OUT);
-	BUG_ON(j >= ASSOC_ARRAY_FAN_OUT + 1);
-	BUG_ON(slot >= ASSOC_ARRAY_FAN_OUT);
-
-	new_n1->parent_slot = slot;
-
-	/* Metadata pointers cannot change slot */
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++)
-		if (assoc_array_ptr_is_meta(node->slots[i]))
-			new_n0->slots[i] = node->slots[i];
-		else
-			new_n0->slots[i] = NULL;
-	BUG_ON(new_n0->slots[slot] != NULL);
-	new_n0->slots[slot] = assoc_array_node_to_ptr(new_n1);
-
-	/* Filter the leaf pointers between the new nodes */
-	free_slot = -1;
-	next_slot = 0;
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		if (assoc_array_ptr_is_meta(node->slots[i]))
-			continue;
-		if (edit->segment_cache[i] == slot) {
-			new_n1->slots[next_slot++] = node->slots[i];
-			new_n1->nr_leaves_on_branch++;
-		} else {
-			do {
-				free_slot++;
-			} while (new_n0->slots[free_slot] != NULL);
-			new_n0->slots[free_slot] = node->slots[i];
-		}
-	}
-
-	pr_devel("filtered: f=%x n=%x\n", free_slot, next_slot);
-
-	if (edit->segment_cache[ASSOC_ARRAY_FAN_OUT] != slot) {
-		do {
-			free_slot++;
-		} while (new_n0->slots[free_slot] != NULL);
-		edit->leaf_p = &new_n0->slots[free_slot];
-		edit->adjust_count_on = new_n0;
-	} else {
-		edit->leaf_p = &new_n1->slots[next_slot++];
-		edit->adjust_count_on = new_n1;
-	}
-
-	BUG_ON(next_slot <= 1);
-
-	edit->set_backpointers_to = assoc_array_node_to_ptr(new_n0);
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		if (edit->segment_cache[i] == 0xff) {
-			ptr = node->slots[i];
-			BUG_ON(assoc_array_ptr_is_leaf(ptr));
-			if (assoc_array_ptr_is_node(ptr)) {
-				side = assoc_array_ptr_to_node(ptr);
-				edit->set_backpointers[i] = &side->back_pointer;
-			} else {
-				shortcut = assoc_array_ptr_to_shortcut(ptr);
-				edit->set_backpointers[i] = &shortcut->back_pointer;
-			}
-		}
-	}
+	assoc_array_split_node(edit, node, new_n0, new_n1);
 
 	ptr = node->back_pointer;
 	if (!ptr)
@@ -791,8 +807,6 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	new_s0->next_node = assoc_array_node_to_ptr(new_n0);
 	new_n0->back_pointer = assoc_array_shortcut_to_ptr(new_s0);
 	new_n0->parent_slot = 0;
-	new_n1->back_pointer = assoc_array_node_to_ptr(new_n0);
-	new_n1->parent_slot = -1; /* Need to calculate this */
 
 	new_s0->skip_to_level = level = diff & ~ASSOC_ARRAY_LEVEL_STEP_MASK;
 	pr_devel("skip_to_level = %d [diff %d]\n", level, diff);
-- 
2.53.0



