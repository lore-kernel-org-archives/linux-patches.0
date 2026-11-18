Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054344;
	b=moiIOLxXGRjYu049+RlUEGFaRW+BufTng+dCXtqA/N7ekIVJh+tuKDSmMwuheqSONbah
	 +EUecny3jvLLF2IEDvQzqP7B/fu7/Iuo0CfIA5TW3/blVkAmn2rObGVu2uVI8rFijF9X5
	 +IfG9LdVWaRDNNgslTFCjD7Yys8r1LgcDh5ChhoRfoX6wiQ7f/4ucl6YKMQVtj76NfT4e
	 IqkBNaWPU3+6MaNJG5RLIg3BmDcwnA09nBx/Avx93e7o70wGI5FWqY9xL4y3apH4sAnm4
	 iUIsXq7l09EgFZc+J57fSyk61nBH4a42T8Vu0DKh838ZQbOhmqNFomYa2mTj/kcFOtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EyoEZ2Q7bpP5zxtpOmv+Unk/+mXriWh8lT93uzgEz2o=;
	b=qmplKf/q7wetrqKIFQEMgnoA3kFGzTDEfDgXTOW1wNtGbhEF9gjtgSIJNDrJFWzsFSEU
	 FajWZxPPYVrzkenmS/ttKM8fN67IjNwe2RieaQ2/QMcL0E/jyTfePNbeuKlb5EtRldmu0
	 paQ1w86g6bioDoQYgEVQKk1msAAxFbeFOlHP33RYt/qQG+yP7nzlMlz7q+fZC1a3fZg0U
	 J86hDJv2Fh7SVVgySO4vMOuvCo96uTMtAqJzvwVWWkvKyK5Chf43w3Jhc61S/lPmSmXFs
	 k3PtJbjFi1QgftPHLmuUJgRU+5Qp9pllfyOhxs99ahhyejxYmGj84rZ+ojcLlCF1SUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QuhGx8yd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C44606A31C;
	Thu, 19 Nov 2026 02:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QuhGx8yd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590551F000C6;
	Thu, 19 Nov 2026 02:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054343;
	bh=EyoEZ2Q7bpP5zxtpOmv+Unk/+mXriWh8lT93uzgEz2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QuhGx8ydPSWIngtFGmVNMLiwZeJPq8RrLhlH18DfF48W14LE1cMrdF5D2iOp1PWJ2
	 j1+hFMlFLvoWTMy1JpLcHDdZLiGqgcn0E/n2MiZ3kpticNhjFCglGQx+ZYIlISTtqA
	 rdHVXsG3n70XTG7QMqeGzRTLbI5uG7lUh/F8PZ/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1204/2214] assoc_array: move in-place insertion into a function of its own
Date: Wed, 18 Nov 2026 15:48:00 +0100
Message-ID: <20261118150100.017919745@linuxfoundation.org>
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



