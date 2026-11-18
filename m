Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038748;
	b=eAjLyGPI38iZ7i5xgHt379AJNP3lYiRDnOu/4+xWEyLFepEp+vPmeegr+akVaMGalIJU
	 F6ObxCAZRQZyyiZfzYXX5MVvPJhqyq3jCPeg56MtnIJLrzQMs4UcLJ09gYvIgmWOdRFHd
	 954eqf3LZWT4MeGwLB1J27V2/p23E+3IMKzErSKEuMLYAymO3A4ZjQXJe9MY+zRvChn9V
	 VlfTm9TszVj9Ygic/dIsphuLI4oKjOTo+1WBEgLeV0PfBx9JmHdkyHYYTU/s2loNJVXCJ
	 BeNeyxwItEG8qJv+/nEO/zUk97UuFhBAkJ+innsoA/ZCHDDrn5Vpnb5n5Q//nv+6xTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnC3+JVernCwbAcUqcSrQ624FHMTuSyH2GdbQrsWHiE=;
	b=vIESwDVEZZH5sLqtGGdEina6RBHl9JM7L+5v0kUy+NSpze9aTfwYjSG0fRQEw1d6smmr
	 ba4vYmAT7kxt21j+szU7M5QT3WrvdwNgC1mhGXSWRvhYpklHYCLSO7PIn2e9iCZ8CgKHo
	 GJOgh24FyL6Y/97dM5UX78HHmvlz73jkcpqo9oJztBBAOfr9BFjvQ/gTSdMLPk8nWTcLO
	 2NjaI/ozWru7nC3y64//q5jhicWNJzHqWUJjRd6OvDvJ6We5iKosTQeQ4n/34WS0ANZ11
	 DJ9ROi+RVouRqwMP1GoaOzk0dpFFxWA1VVvl+h7ppSivo62rvWHC6FGSqkdqG4NtBVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmB0Wo1J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5FD606A31C;
	Wed, 18 Nov 2026 21:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmB0Wo1J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3B61F000C4;
	Wed, 18 Nov 2026 21:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038748;
	bh=jnC3+JVernCwbAcUqcSrQ624FHMTuSyH2GdbQrsWHiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmB0Wo1J7p2wQnwyzqzHQimvcPJwC3aQoHVOBQixblwNkKPN8VCJuZro5TCrS3Sjl
	 pSBuqRfQaBatEZfQjvVxidQoTjC8wywsMimQOL7u/4uZyx2s+i4gLHc1/thv78V/cA
	 xE4pYt0dDrxqgWli/gqd5KOBwIVtaPyy1VSvTF68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1853/3318] assoc_array: fill the segment cache in one place
Date: Wed, 18 Nov 2026 15:41:15 +0100
Message-ID: <20261118150417.457329068@linuxfoundation.org>
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

[ Upstream commit 1159eaf9acb3de1417fb86b382b5e41b46eb17a4 ]

The loop that records the segment of each leaf in a full node is written
out twice in assoc_array_insert_into_terminal_node(): for the node at
its own level, and again at the far end of a shortcut that replaces it.
Make it assoc_array_fill_segment_cache().

The second copy did not look for metadata pointers, because that path is
only taken for a node holding nothing but leaves, so the function finds
none there.  The new key's segment is still set by each caller, from the
walk the first time and from the key the second.

No functional change.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Stable-dep-of: 48691075b0ad ("assoc_array: don't chain a new shortcut onto an existing one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 56 +++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index a9295e8ca5d4d..600b2d85bccb6 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -515,6 +515,38 @@ static bool assoc_array_insert_in_node(struct assoc_array_edit *edit,
 	return false;
 }
 
+/*
+ * Fill in the edit script's segment cache for a full node: the segment at
+ * this level of each leaf's index key, or 0xff for a metadata pointer.
+ * The new key's segment, in the last entry, is left to the caller.  Returns
+ * true if there are any metadata pointers.
+ */
+static bool assoc_array_fill_segment_cache(struct assoc_array_edit *edit,
+					   const struct assoc_array_ops *ops,
+					   const struct assoc_array_node *node,
+					   int level)
+{
+	struct assoc_array_ptr *ptr;
+	unsigned long base_seg;
+	bool have_meta;
+	int i;
+
+	have_meta = false;
+	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
+		ptr = node->slots[i];
+		if (assoc_array_ptr_is_meta(ptr)) {
+			edit->segment_cache[i] = 0xff;
+			have_meta = true;
+			continue;
+		}
+		base_seg = ops->get_object_key_chunk(
+			assoc_array_ptr_to_leaf(ptr), level);
+		base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
+		edit->segment_cache[i] = base_seg & ASSOC_ARRAY_FAN_MASK;
+	}
+	return have_meta;
+}
+
 /*
  * Handle insertion into a terminal node.
  */
@@ -534,7 +566,6 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 
 	node	= result->terminal_node.node;
 	level	= result->terminal_node.level;
-	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = result->terminal_node.slot;
 
 	pr_devel("-->%s()\n", __func__);
 
@@ -566,19 +597,8 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 
 	/* We need to find out how similar the leaves are. */
 	pr_devel("no spare slots\n");
-	have_meta = false;
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		ptr = node->slots[i];
-		if (assoc_array_ptr_is_meta(ptr)) {
-			edit->segment_cache[i] = 0xff;
-			have_meta = true;
-			continue;
-		}
-		base_seg = ops->get_object_key_chunk(
-			assoc_array_ptr_to_leaf(ptr), level);
-		base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
-		edit->segment_cache[i] = base_seg & ASSOC_ARRAY_FAN_MASK;
-	}
+	have_meta = assoc_array_fill_segment_cache(edit, ops, node, level);
+	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = result->terminal_node.slot;
 
 	if (have_meta) {
 		pr_devel("have meta\n");
@@ -791,13 +811,7 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	/* This now reduces to a node splitting exercise for which we'll need
 	 * to regenerate the disparity table.
 	 */
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		ptr = node->slots[i];
-		base_seg = ops->get_object_key_chunk(assoc_array_ptr_to_leaf(ptr),
-						     level);
-		base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
-		edit->segment_cache[i] = base_seg & ASSOC_ARRAY_FAN_MASK;
-	}
+	assoc_array_fill_segment_cache(edit, ops, node, level);
 
 	base_seg = ops->get_key_chunk(index_key, level);
 	base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
-- 
2.53.0



