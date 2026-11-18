Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047347;
	b=P8PbFL+9/6TY9Pz7R6Z0wlFZ0ktd+nL/KrfuWX4drRptoBr0ZLPaf+ya5begU9YJ5Oz7
	 JydC4X9IRJuq/od8OuAjcRdIXGJVyTBSP8v6gZHmyhb7w5hTm/yBv9Bs1mgaTyowvWuP+
	 9T6YLRgwI/j3t1KZtEN1GQMgIeugJQkpwfLPJ1QsQDA9USYby8lTod8s41tzoALq/g/qI
	 AdYy71Ch8R8ytyrPhwrjIjdY6kYKhfTYWrGOXxYM5BuGxUjrML43sLb7tPPTjdhz7HojC
	 XVpvToBhD5oRRETR+MorS6TLesm3AMLSDZjzi2+C7aKYDSsJaN/XqaPRwhktmXBCerQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U/BG4rR4IH9sy5Z6aZautPtB/5aA93FthBqpMpJ3Jto=;
	b=4tHZFGq15LiTIlDlM3HhUo5NDGp+Fv69dQBBiy2QZEa3+8s5isXkKi1z11XdyKxTO40H
	 y594oek9ee32fmo9XpcnJmBPKxHSihiCXVL4B0EDD8grsKZLgMt/rweAhm/xvugLYkjwF
	 Ro6W47W8giaAPiM+b6E34qkCBGNTJ3hquaaaqIg82k+wdp0EM0aX2ionJ/JH2wNe5yvXA
	 9MKTvqA1OF/1YWbbco5mywrps5j7Ge+sTk3rtaoIHZLX+kkw4VSWDOG38yNKjUeguuc4c
	 pm4i5nFnsjGxTYgH7BZrFTM/MJOYIaivZJNVC8HCTxP3+ViGAfFJe5WO7b4ag48Xkog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aF+L/ZMs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B2E606A32F;
	Thu, 19 Nov 2026 00:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aF+L/ZMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8809A1F000C5;
	Thu, 19 Nov 2026 00:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047347;
	bh=U/BG4rR4IH9sy5Z6aZautPtB/5aA93FthBqpMpJ3Jto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aF+L/ZMs5zQl2Xt2ykKxs9DdKDlUbNRTM63a0+MbDGbP5PidQ0ejpmrQSbL+MvBOQ
	 2kgSwVbIlXxhICk+tvT4lq0ki9hbOAc8hiMTw9S5PhxJ1ccSLgZUdJ5yrggRZi1Jna
	 f5+7jwe7rsYRrN5gjQ6H3vo2+ZHafs0hpp+KXc9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1607/2857] assoc_array: move node splitting into a function of its own
Date: Wed, 18 Nov 2026 15:44:01 +0100
Message-ID: <20261118150259.225853460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



