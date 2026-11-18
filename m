Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059933;
	b=zp+vszTgjKhEz8nKzSMeCqijShqJZybcEcMZ568a0kWU4EHUIKShsGDfNMzcvULbkhkH
	 lGP66uEoaR6Bb8mvb7HcBFesWVVJLOA0cjwT3YghxFqU96wOmEj5t9KxnMvu8Sm9m+1xT
	 7uGWwt09CkGQ/K2ab+yq2Ha5QznfGSUJm+eVIZDiq9lYojSIFw09Z68XQoawvqV108KPt
	 oVS7TDUXbiatWV2nIaJ/YIqWVme2sti4ZUgQPJpIkeF546ybWk8GZkteiPo/vfo7Mw+rf
	 xkXypiNYQLELD/sIldvB1Is/6mFcniiW/Vfa9iqL3utqb+ApWgmGrbQrktwtGx9Uecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3CZWnzUp+1jm82QRHUpuXYIERNsffgBfFbn9LR7/+5E=;
	b=2n2q9DUvU48L5N2CA+cf+Y4zd0xIdamp2inRxa0v29JdotFMlo5qKTUGlTW05PvTKHnK
	 fBgu9FVOyvH5C/NdZgyDmqxUXefRVXr4MYRwzHoCRt6+10lN9rSuxLmKRoe6McMBv1GFz
	 DtQ1JTWQpLXQrBehaYyHqN+N44TS4kgoVALZt+Ii7yJJO3zSlfjNJTFxdtlyUlBo/yOzG
	 EhmDoApiF/VAB6JSXgCXVx2335CX7LywqJlW+NWp1PM+IZR7LmzW74gO3V3L0766jgLXu
	 wccKNCpSUqkIoy0GOAPw5Muks5hva/heMZdW/uFRWnyno8BVaA2PdnJlwJe+cZo9mFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDXY+F7A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E108606A326;
	Thu, 19 Nov 2026 03:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDXY+F7A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725591F000C4;
	Thu, 19 Nov 2026 03:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059933;
	bh=3CZWnzUp+1jm82QRHUpuXYIERNsffgBfFbn9LR7/+5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDXY+F7A4JjRwH55ydI7DuDck54Pjs8DjLVvTAhhRREdJgDJzXWt9tDFyyxwWMU4j
	 tP6kfyloFIHjzCNTv8RD+Dszpostt8ElQt3tQE6mkv2/EIZNlGJjlLGpcilcjY4QXo
	 NDJF09V5JvC9WXfEOhivQZEcflU9MIWiSgosz7pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1016/1848] assoc_array: keep gcs cleanup out of the live tree on allocation failure
Date: Wed, 18 Nov 2026 15:50:54 +0100
Message-ID: <20261118145959.457484282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f5bcab8c2e17d..cab6111a0ef43 100644
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



