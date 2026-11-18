Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038765;
	b=Atg+qyQJNJjf6O4tai7HLTv61a6sYzx5q0HZ2EXeVFP3j9quOCpRVNLxZAo31HCZ2gom
	 hTAJ+dFza4sk6oFlAvQ7Waqp0lg+IceezqtSxd99Sfio+xYEcl9WwzU6OVWVPR02UTzN4
	 WLK8Ff0H8AWI1pmPGM/WA7NswoAlI5tJ1uXyQ9t3h1U4VIoy7WcxvXgN+pDnNHS/j/um/
	 svUKIURcrDuzpfGvUef/ytWdqLBFFQiV8aKSORmvHPkwCu4gMB3KUDlsRzeYRr+0YnaY9
	 iM18H1mKx8JV0ipdhb2z4u4TL6XRkoyuDdJRsqmkNg6/cG+nwoN0+YDCiP6IKtzqq6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wOMyojAk77BsHXNvnNX+dj4Cx4rAFaroE8IsE9Simyg=;
	b=cH32KReh0i5kpU46CHr8dntV4/OJYh9rQMHRaUwcCCJmLTH6WG2Xu5CVZU5/cdtRWiOH
	 Z/TUwqPOfg3OfXkG5DkbmVqDFkxAOnj/ZW62gDoEhEAv/c8JoxOZsb+5DjzGzZIRdNvET
	 SplrLkfplX1BDIaVMKRfDx43/mQhYO2dw7MemoKodF+dpWUIQlcR4vKin3CLwrV8LgGdC
	 +jMZ1jq5mWIWKe/mS6jtcUuy8C0NiH34yUsrxLDWR79wDNlxVlHQJL/TWkV4NdljmdN8q
	 otPVhCgYRyU1fQ8T5asSOIeLlGz+w0i7JptnvRoAff30y/XMgNVu4yvthJymyNlt7vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiyr4oRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3789D606A325;
	Wed, 18 Nov 2026 21:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiyr4oRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B281F000C4;
	Wed, 18 Nov 2026 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038765;
	bh=wOMyojAk77BsHXNvnNX+dj4Cx4rAFaroE8IsE9Simyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiyr4oRZcT2ieuqJ4HTQEIZSAkzrSkKR2VvVTfpQkYIlEiTpEN49iZkSJov4R0LTv
	 0oVfrXSejg2802b1SVfItC0SmsF0U5e2pbl3Hw0MayTsTXmu6Zq1Lxe9zyT/uyt4f5
	 Tfq64cbc3qN4/pzk6jqA2Y+vA8j/jYs7OY6dVJyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1858/3318] assoc_array: keep gcs cleanup out of the live tree on allocation failure
Date: Wed, 18 Nov 2026 15:41:20 +0100
Message-ID: <20261118150417.604543129@linuxfoundation.org>
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



