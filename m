Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047344;
	b=QIoiO55iCSFWIOUPWy9EFiaRHOUuuIfs0EOc2zq5igWXdelmQIU37poht6shT9l0yuHl
	 oMyhQP/IMqizgIJtlyWsNr2o12tQiZwdXi66GumnL3T+D35jimjcw8uPf2AKjB3iZu+11
	 0y+49DG43H2YCnix7nGPrzmlvXQm9eHhwNzGC4Flo9BGDBoSyODNpj6f8wFvWEdRNNK4E
	 dz5YD4TUXgiotRK2bCfwo3e0tIdFEulFuj9lBYWI5W1J22oR9XRpvFWXNeFqxeB6/xGLE
	 bQe1B1NEzyQ6nOnHRnMgaoign5pdF/uZA44n/hoWGHtImSn+YRxQd+793G6gK7vQOCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xbrNxDilp+R8JbU1xyexM1WHK6W8j7UbLxykRCZ05T8=;
	b=tOydqZp20KjZVnw3B813NC5YQRRtenfbu/0/Ql4giIMhhNJnQQbMmklvbi3MtNhR42UT
	 6vyjo6jw7jf+9x/Hrcv0IM7Qk8KWhtNKM2e3BGL3DgC7OEEOB22nKj68XpAnelwlINp3o
	 +GMgi+73HfyxY7RQV7RtNkmdlROYxatT/kIKNaPaLlHdpk+alObB3wb9yws5D4EMGExfp
	 mJLTYU4614Io2U6ZP5ODRIQPpnKCIu4w1XiLZYJ09gzRC/yHXtmatRZzNGlYsE+VjMAvB
	 3Ab2u7GX7g21VPLKslZE2c3Zrx2HOxn8vWqXQp7rtWZKcvUn5Sb2jNcG2loRFiP/nWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+GzPeC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74757606A32A;
	Thu, 19 Nov 2026 00:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+GzPeC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03361F000C5;
	Thu, 19 Nov 2026 00:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047344;
	bh=xbrNxDilp+R8JbU1xyexM1WHK6W8j7UbLxykRCZ05T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+GzPeC3ViYVeVmgXHagATOLAy77m/24noqBT34pmDA813bLkWTQ7nuhbQhk34HoH
	 XcjhDMRCf9dexD2TLar7KdbeJ8Zs6fZGMN/WO/TKgPMvdwhmWVOX86KsBQvqJZqznL
	 chPEL61yuShOLwvX4gVaRgfykgG+SB1aVI0Uvvis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1606/2857] assoc_array: fill the segment cache in one place
Date: Wed, 18 Nov 2026 15:44:00 +0100
Message-ID: <20261118150259.188821917@linuxfoundation.org>
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



