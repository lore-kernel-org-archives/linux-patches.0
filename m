Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054252;
	b=siTW/Fn9+fwrt3SeAbhN37XWY/mUHmp7SRyEbLJHqQhLGWX4VEtHNOJybtInx4m7RnGy
	 Hb3iCOdVGme0mFk5s4On6gpqW28McJBjwJBbjSHCoBEvlGsdVpQlphZ6tpZaZSDTcW3CC
	 2m1Kj4Upz6o2x4h0KyhKptOHVhv2z0A5/tB1VcVCUwA67t49XW0AJMLTTplE9OTItHMGH
	 /G0g3NMZ30JuG/ShjUJmBCVf/jDe+LnfewvtmEfYmpfQJfAKhfH8KhhPsuYa0M9uzhdWP
	 1Md9jE7I0y8wywDVGhfJLHBFcbf10hQ0i75Gjfd5GhrvC10iZznK4X3RedBmFNQKFQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7V+LwLjkUyV9rcWY/n7OGEwvQlma48S/jHtAYnvvUw=;
	b=ErsKrNgLxcc+Aw0Iu7pOxx3KtG2eD6VT0uBJvFImp7P7jiOJHQ4Xvfgp3bkLYc7kDI2e
	 vpuGMHSm7z99B0SmTLRLvXUnV98Gov6YAiCwXe5pFpEhmIfm9f4DJyfG5r22r9ml3i3sK
	 E9pzo/pddARQzCI9EbEE5SfSIaCqhKbVMvvUgLpV63TBS6u6CA72yfKmlLYVu1Cfgo2Ro
	 YweBA+Rycr2m+L+qlbp+qcXszNcwWQOPvGHbuOfcg8V8z90RCwuzpfU2qKbt7NZwM5Da9
	 gizEQxBYi2699UhTIlldON8oLd3mjCFSTb0gCIAAu+alfUqgi6qp9xuyVYFRZoGFsqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W56CmIKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7EA606A32C;
	Thu, 19 Nov 2026 02:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W56CmIKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB3E1F000C4;
	Thu, 19 Nov 2026 02:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054252;
	bh=w7V+LwLjkUyV9rcWY/n7OGEwvQlma48S/jHtAYnvvUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W56CmIKi/rEGpHXRnGv5wN859yjz8+BIpLepHRHTV5km7w/2ZpZrjBI1EKSuIL/Gf
	 PITD77DbG+KaubM1kJIQtZ6NCYeQmCviUNuD3k5lnRbysFwpJHwAxB2Mb7ZMPCpp06
	 Q2rqymFgWmeQ50DHH3eOdN3Cni/9frg3UnF6nnqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1210/2214] assoc_array: keep gcs cleanup out of the live tree on allocation failure
Date: Wed, 18 Nov 2026 15:48:06 +0100
Message-ID: <20261118150100.227991267@linuxfoundation.org>
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

[ Upstream commit 8afff2e4b90978b8203f9e3898995dcf86821b49 ]

assoc_array_gc() builds a copy of the tree.  Where the copy reaches a
shortcut, it allocates the copy of the shortcut with kmalloc_flex(),
fills it with memcpy(), links it into the new tree, and only then
allocates the copy of the node after it.  The memcpy() leaves the new
shortcut's next_node pointing at the old tree's node, so if that second
allocation fails, the cleanup, assoc_array_destroy_subtree() on the new
tree, follows the new shortcut into the old tree, and the BUG_ON() on
the old node's back pointer fires.

Allocate the node first, and the shortcut once the node exists, freeing
the node again if the shortcut cannot be allocated.  A copied shortcut
is then only linked into the new tree when the copy of its node is there
to follow it.  Nothing else changes: with no allocation failing, the
trees gc builds are the same as before.

Found by a userspace test that makes each allocation of each operation
fail in turn.

Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
[ sashal: used kzalloc(sizeof()) instead of kzalloc_obj() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 0a210e12d18e9..4ca7381c60001 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1562,17 +1562,26 @@ int assoc_array_gc(struct assoc_array *array,
 	cursor = array->root;
 
 descend:
-	/* If this point is a shortcut, then we need to duplicate it and
-	 * advance the target cursor.
+	/* The node at this position is duplicated, and so is the shortcut in
+	 * front of it if there is one.  The node is allocated first: the copy
+	 * of the shortcut starts out pointing at the old node, and must not be
+	 * in the new tree if the node cannot be allocated, or the cleanup
+	 * would follow it into the old tree.
 	 */
+	new_n = kzalloc(sizeof(struct assoc_array_node), GFP_KERNEL);
+	if (!new_n)
+		goto enomem;
+
 	if (assoc_array_ptr_is_shortcut(cursor)) {
 		shortcut = assoc_array_ptr_to_shortcut(cursor);
 		keylen = round_up(shortcut->skip_to_level, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 		keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
 		new_s = kmalloc(struct_size(new_s, index_key, keylen),
 				GFP_KERNEL);
-		if (!new_s)
+		if (!new_s) {
+			kfree(new_n);
 			goto enomem;
+		}
 		pr_devel("dup shortcut %p -> %p\n", shortcut, new_s);
 		memcpy(new_s, shortcut, struct_size(new_s, index_key, keylen));
 		new_s->back_pointer = new_parent;
@@ -1582,11 +1591,7 @@ int assoc_array_gc(struct assoc_array *array,
 		cursor = shortcut->next_node;
 	}
 
-	/* Duplicate the node at this position */
 	node = assoc_array_ptr_to_node(cursor);
-	new_n = kzalloc(sizeof(struct assoc_array_node), GFP_KERNEL);
-	if (!new_n)
-		goto enomem;
 	pr_devel("dup node %p -> %p\n", node, new_n);
 	new_n->back_pointer = new_parent;
 	new_n->parent_slot = node->parent_slot;
-- 
2.53.0



