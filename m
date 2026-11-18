Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038745;
	b=JsuYwYZbS73qYzLpvx9/Qat3aiqN1bHEe7AGABgQZZ120RNlZA5q38OO33/5Rgkyw4uu
	 BJILmjeti20Yd66btnPt/1e1K5+xlbThoQe949WTh3TsQISqrvSGvsE329ybUpRA7vVD4
	 E9/VEEDgJJmgfS46E97LDWL9ZjMxqdwc5jsB9yyTkZnNiMezjH3Oy+IUB8LAAF+WGO57/
	 Tbv/eq3dnX5ns5WuOASqI90Vgax1eAIIhqs0/B4VypbdcZgJEJqi1Acr71j2bCcXvKHJu
	 S4nHzgvXk/+OUTuAQwvP6K1N4CgbfaPIfiXfFSIYwTiNJexLtFxwtcUZShzXgTPtG4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YDI1EMNoFvJpXpYOiENTo3pQkcfXQtzRzBMqLV0CupY=;
	b=sELr/Fqgeym6ULktTNuGXi/WfiVcitrQN5MW5h1U1nB+6wLhtyrmyWmrqN3A7aGOW03H
	 k2l13WvfWuvyjhiYUH1UmqIfBlL4POndvAhfmeqGKjBldTDwpGlxUf+nDjnXdYaegGQcH
	 JItSpC4+A9Q9I6NEIf/2/59sUGO1UHmXtnbXVF6ECdYSFX06psjudYjBoCSrX8yaeEjsq
	 9ZY1v4eNv266BBR4mOdBXGw8chJF4DF8qQ3b8s8m+PsR8nvqTHCFHHHZ2u5x2/1sJ0flU
	 WMwZYnZeLbJY/J5Ke/+P4e3zN5kbJISDeGN+AsPI/6WfOF+oNdsZa476PIeWcLtxqVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WPoqvx/7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C93606A320;
	Wed, 18 Nov 2026 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPoqvx/7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ABC1F000C4;
	Wed, 18 Nov 2026 21:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038745;
	bh=YDI1EMNoFvJpXpYOiENTo3pQkcfXQtzRzBMqLV0CupY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPoqvx/7q1qtBglqA3d1+ZM6md0chelWf0vJt64CvqZ4rxJbMakFYG5TBQ0Y16BlG
	 tniXF+ZTVahnAAYg6mnfOvxX0oRWmlKXRLiVg1Fn+waMAuvHpiY5djyb2OhtYvyOqo
	 CuIhJE1JfpDCU0wKxFlzkKwtLmLKABzEtdtgFJrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1852/3318] assoc_array: move in-place insertion into a function of its own
Date: Wed, 18 Nov 2026 15:41:14 +0100
Message-ID: <20261118150417.427074843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit a624a7ce7d85b514d949b6c7a049f43ac96f3257 ]

assoc_array_insert_into_terminal_node() is over 300 lines and does four
jobs, joined by gotos: putting the new leaf in place of a matching one
or in a free slot, working out the segment of each leaf, splitting the
node, and replacing the node with a shortcut.  The last two share the
function's tail, which installs the replacement where the node was.

Move the jobs into functions of their own, one per commit, starting with
the two cases that need no new node: assoc_array_insert_in_node().

No functional change.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Stable-dep-of: 48691075b0ad ("assoc_array: don't chain a new shortcut onto an existing one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 68 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index e7c9a2f513114..a9295e8ca5d4d 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -470,33 +470,17 @@ static bool assoc_array_insert_in_empty_tree(struct assoc_array_edit *edit)
 }
 
 /*
- * Handle insertion into a terminal node.
+ * Insert into a terminal node without changing its shape, if that can be
+ * done: in place of a leaf with the same index key, or in a free slot.
  */
-static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
-						  const struct assoc_array_ops *ops,
-						  const void *index_key,
-						  struct assoc_array_walk_result *result)
+static bool assoc_array_insert_in_node(struct assoc_array_edit *edit,
+				       const struct assoc_array_ops *ops,
+				       const void *index_key,
+				       struct assoc_array_node *node)
 {
-	struct assoc_array_shortcut *shortcut, *new_s0;
-	struct assoc_array_node *node, *new_n0, *new_n1, *side;
 	struct assoc_array_ptr *ptr;
-	unsigned long dissimilarity, base_seg, blank;
-	size_t keylen;
-	bool have_meta;
-	int level, diff;
-	int slot, next_slot, free_slot, i, j;
-
-	node	= result->terminal_node.node;
-	level	= result->terminal_node.level;
-	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = result->terminal_node.slot;
-
-	pr_devel("-->%s()\n", __func__);
+	int free_slot, i;
 
-	/* We arrived at a node which doesn't have an onward node or shortcut
-	 * pointer that we have to follow.  This means that (a) the leaf we
-	 * want must go here (either by insertion or replacement) or (b) we
-	 * need to split this node and insert in one of the fragments.
-	 */
 	free_slot = -1;
 
 	/* Firstly, we have to check the leaves in this node to see if there's
@@ -514,7 +498,6 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 			pr_devel("replace in slot %d\n", i);
 			edit->leaf_p = &node->slots[i];
 			edit->dead_leaf = node->slots[i];
-			pr_devel("<--%s() = ok [replace]\n", __func__);
 			return true;
 		}
 	}
@@ -526,7 +509,42 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 		pr_devel("insert in free slot %d\n", free_slot);
 		edit->leaf_p = &node->slots[free_slot];
 		edit->adjust_count_on = node;
-		pr_devel("<--%s() = ok [insert]\n", __func__);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Handle insertion into a terminal node.
+ */
+static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
+						  const struct assoc_array_ops *ops,
+						  const void *index_key,
+						  struct assoc_array_walk_result *result)
+{
+	struct assoc_array_shortcut *shortcut, *new_s0;
+	struct assoc_array_node *node, *new_n0, *new_n1, *side;
+	struct assoc_array_ptr *ptr;
+	unsigned long dissimilarity, base_seg, blank;
+	size_t keylen;
+	bool have_meta;
+	int level, diff;
+	int slot, next_slot, free_slot, i, j;
+
+	node	= result->terminal_node.node;
+	level	= result->terminal_node.level;
+	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = result->terminal_node.slot;
+
+	pr_devel("-->%s()\n", __func__);
+
+	/* We arrived at a node which doesn't have an onward node or shortcut
+	 * pointer that we have to follow.  This means that (a) the leaf we
+	 * want must go here (either by insertion or replacement) or (b) we
+	 * need to split this node and insert in one of the fragments.
+	 */
+	if (assoc_array_insert_in_node(edit, ops, index_key, node)) {
+		pr_devel("<--%s() = ok [in node]\n", __func__);
 		return true;
 	}
 
-- 
2.53.0



