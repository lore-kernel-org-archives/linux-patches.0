Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054365;
	b=VaUUCd25fnTmh98sXUKbkfQxFfaiIkxcOWESbQ1+lHAL7/C6dKYowoheaTsT3iDnbZEN
	 OKOv3Sc2i//8Xm8gx09ExAsL9uJ3ui4e6y8fX9otQb53/sNVfgDFeMwxWALZIG8AFhwto
	 jCHYgmAqD0VNFEeaudqkq+A7U9ptWTBaiLvgwitaV1ubWYsXTzzgnv7u7tGFZQ5exPT2V
	 ceA2Fvb4OYiRwcMZ/xo9ICE6KG6v/wzm20TDsq/gYTKQf/wZCdPe8UGTFPl+2QQulqQxx
	 JnmbmLXUPoQBZT++wLppRcKE4DRLQ8rjZ4iwdnD2QcWBOUUuWMAvWcgNoEJn3S2F9IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DumSSOy/8lUB1J9s2U2JIKUNPJG1GRkK+J3ITjNXrYM=;
	b=1ACga0Jm+5XS42zewhuwCvGQMzVCBINXPWTl60edc+n8qiYsi/89BTxUBsbFpnogNxM4
	 K+t1CvqyRtADjiBYAdjY3CGf0Ltdkx96sJFLHpKukLWuNRe1USJMv8kYLtnOb3j5XgCFf
	 0ITRNJbqnoZ2YJ/slwPwFTQop1lWulbyJlbNOL7z8hYD3U6DcND02wsRhxXp8n+DPIF2O
	 PeaG2M/jfGsoS9vXUww8fDBPyElhwYN29N4qKWgtSS6JmNkYj3kUYpA5WB5tY5OyTEVDB
	 EGXKlrFJjaGdeR4Me0ttyCtpay2po6WPH17oOYJoCRL7yuDPMPQjvzIspjARtqEMVeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCZzAptx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0978606A31C;
	Thu, 19 Nov 2026 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCZzAptx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F7D1F000C4;
	Thu, 19 Nov 2026 02:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054365;
	bh=DumSSOy/8lUB1J9s2U2JIKUNPJG1GRkK+J3ITjNXrYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCZzAptxHZnj2QhimaUA+M1u225hfb2dAxnxdufEfwuPAuj85aRG6M2HJ0hmlDRfK
	 ZwGyaY7FZJVSYFMfY/80Un+Y+NQJkJA80RPRukeV8L1/+qAUdNEqo/bKXb4yLhoKpP
	 ulcJylv5e/9Se5XvdtsLZvXR5AxzXU5Too+wBfyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1207/2214] assoc_array: move shortcut creation into a function of its own
Date: Wed, 18 Nov 2026 15:48:03 +0100
Message-ID: <20261118150100.123900479@linuxfoundation.org>
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

[ Upstream commit fdc6124c55dd0c5aa8e3ec30e6425b4d423ada24 ]

Move the code after the all_leaves_cluster_together label into
assoc_array_insert_shortcut(), which returns the new shortcut, or NULL
when it cannot allocate one.  The caller installs it and jumps to
do_split_node as before.

No functional change.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
[ sashal: used kzalloc(struct_size()) instead of kzalloc_flex() ]
Stable-dep-of: 48691075b0ad ("assoc_array: don't chain a new shortcut onto an existing one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 146 ++++++++++++++++++++++++++--------------------
 1 file changed, 82 insertions(+), 64 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index dba1c72ed49d9..e3924ed4d3e9f 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -647,6 +647,84 @@ static void assoc_array_split_node(struct assoc_array_edit *edit,
 	}
 }
 
+/*
+ * All the leaves, new and old, want to cluster together in this node in the
+ * same slot, so we have to replace this node with a shortcut to skip over
+ * the identical parts of the key, leading to new_n0.  The caller then splits
+ * the leaves between new_n0 and new_n1 at the shortcut's far end, for which
+ * this fills in the segment cache.
+ */
+static struct assoc_array_shortcut *
+assoc_array_insert_shortcut(struct assoc_array_edit *edit,
+			    const struct assoc_array_ops *ops,
+			    const void *index_key,
+			    struct assoc_array_node *node, int level,
+			    struct assoc_array_node *new_n0)
+{
+	struct assoc_array_shortcut *new_s0;
+	unsigned long base_seg, blank;
+	size_t keylen;
+	int diff, i;
+
+	/* Firstly we need to work out where the leaves start diverging as a
+	 * bit position into their keys so that we know how big the shortcut
+	 * needs to be.
+	 *
+	 * We only need to make a single pass of N of the N+1 leaves because if
+	 * any keys differ between themselves at bit X then at least one of
+	 * them must also differ with the base key at bit X or before.
+	 */
+	pr_devel("all leaves cluster together\n");
+	diff = INT_MAX;
+	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
+		int x = ops->diff_objects(assoc_array_ptr_to_leaf(node->slots[i]),
+					  index_key);
+		if (x < diff) {
+			BUG_ON(x < 0);
+			diff = x;
+		}
+	}
+	BUG_ON(diff == INT_MAX);
+	BUG_ON(diff < level + ASSOC_ARRAY_LEVEL_STEP);
+
+	keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
+	keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
+
+	new_s0 = kzalloc(struct_size(new_s0, index_key, keylen), GFP_KERNEL);
+	if (!new_s0)
+		return NULL;
+	edit->new_meta[2] = assoc_array_shortcut_to_ptr(new_s0);
+
+	new_s0->back_pointer = node->back_pointer;
+	new_s0->parent_slot = node->parent_slot;
+	new_s0->next_node = assoc_array_node_to_ptr(new_n0);
+	new_n0->back_pointer = assoc_array_shortcut_to_ptr(new_s0);
+	new_n0->parent_slot = 0;
+
+	new_s0->skip_to_level = level = diff & ~ASSOC_ARRAY_LEVEL_STEP_MASK;
+	pr_devel("skip_to_level = %d [diff %d]\n", level, diff);
+	BUG_ON(level <= 0);
+
+	for (i = 0; i < keylen; i++)
+		new_s0->index_key[i] =
+			ops->get_key_chunk(index_key, i * ASSOC_ARRAY_KEY_CHUNK_SIZE);
+
+	if (level & ASSOC_ARRAY_KEY_CHUNK_MASK) {
+		blank = ULONG_MAX << (level & ASSOC_ARRAY_KEY_CHUNK_MASK);
+		pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, level, blank);
+		new_s0->index_key[keylen - 1] &= ~blank;
+	}
+
+	/* This now reduces to a node splitting exercise for which we'll need
+	 * to regenerate the disparity table.
+	 */
+	assoc_array_fill_segment_cache(edit, ops, node, level);
+	base_seg = ops->get_key_chunk(index_key, level);
+	base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
+	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = base_seg & ASSOC_ARRAY_FAN_MASK;
+	return new_s0;
+}
+
 /*
  * Handle insertion into a terminal node.
  */
@@ -658,10 +736,9 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	struct assoc_array_shortcut *new_s0;
 	struct assoc_array_node *node, *new_n0, *new_n1;
 	struct assoc_array_ptr *ptr;
-	unsigned long dissimilarity, base_seg, blank;
-	size_t keylen;
+	unsigned long dissimilarity, base_seg;
 	bool have_meta;
-	int level, diff;
+	int level;
 	int i;
 
 	node	= result->terminal_node.node;
@@ -766,70 +843,11 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	return true;
 
 all_leaves_cluster_together:
-	/* All the leaves, new and old, want to cluster together in this node
-	 * in the same slot, so we have to replace this node with a shortcut to
-	 * skip over the identical parts of the key and then place a pair of
-	 * nodes, one inside the other, at the end of the shortcut and
-	 * distribute the keys between them.
-	 *
-	 * Firstly we need to work out where the leaves start diverging as a
-	 * bit position into their keys so that we know how big the shortcut
-	 * needs to be.
-	 *
-	 * We only need to make a single pass of N of the N+1 leaves because if
-	 * any keys differ between themselves at bit X then at least one of
-	 * them must also differ with the base key at bit X or before.
-	 */
-	pr_devel("all leaves cluster together\n");
-	diff = INT_MAX;
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		int x = ops->diff_objects(assoc_array_ptr_to_leaf(node->slots[i]),
-					  index_key);
-		if (x < diff) {
-			BUG_ON(x < 0);
-			diff = x;
-		}
-	}
-	BUG_ON(diff == INT_MAX);
-	BUG_ON(diff < level + ASSOC_ARRAY_LEVEL_STEP);
-
-	keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
-	keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
-
-	new_s0 = kzalloc(struct_size(new_s0, index_key, keylen), GFP_KERNEL);
+	new_s0 = assoc_array_insert_shortcut(edit, ops, index_key,
+					     node, level, new_n0);
 	if (!new_s0)
 		return false;
-	edit->new_meta[2] = assoc_array_shortcut_to_ptr(new_s0);
-
 	edit->set[0].to = assoc_array_shortcut_to_ptr(new_s0);
-	new_s0->back_pointer = node->back_pointer;
-	new_s0->parent_slot = node->parent_slot;
-	new_s0->next_node = assoc_array_node_to_ptr(new_n0);
-	new_n0->back_pointer = assoc_array_shortcut_to_ptr(new_s0);
-	new_n0->parent_slot = 0;
-
-	new_s0->skip_to_level = level = diff & ~ASSOC_ARRAY_LEVEL_STEP_MASK;
-	pr_devel("skip_to_level = %d [diff %d]\n", level, diff);
-	BUG_ON(level <= 0);
-
-	for (i = 0; i < keylen; i++)
-		new_s0->index_key[i] =
-			ops->get_key_chunk(index_key, i * ASSOC_ARRAY_KEY_CHUNK_SIZE);
-
-	if (level & ASSOC_ARRAY_KEY_CHUNK_MASK) {
-		blank = ULONG_MAX << (level & ASSOC_ARRAY_KEY_CHUNK_MASK);
-		pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, level, blank);
-		new_s0->index_key[keylen - 1] &= ~blank;
-	}
-
-	/* This now reduces to a node splitting exercise for which we'll need
-	 * to regenerate the disparity table.
-	 */
-	assoc_array_fill_segment_cache(edit, ops, node, level);
-
-	base_seg = ops->get_key_chunk(index_key, level);
-	base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
-	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = base_seg & ASSOC_ARRAY_FAN_MASK;
 	goto do_split_node;
 }
 
-- 
2.53.0



