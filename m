Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70C2C80
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E004D1F3A7;
	Tue,  4 Jan 2022 00:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EaIHuUtZEhsi8Bs+c/EJAwmW1r1g85BhTkRWEf/17Ck=;
	b=0QgvnZnPYEjAPkwSf/qwvC0lxyJXlvcnao+Ex1h2pCyuxeCEEO1yWbjFYz5a6I7Me1t+jq
	Vn0/6x5jJfZcFzpZGjTu0DUDuspXCTfeqdpaYu0zSON/x0q9jsFIdDTihZ+2zfbTvV48zX
	VIESda+NMoHzxAzs5rCJbtyWHctFHLI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EaIHuUtZEhsi8Bs+c/EJAwmW1r1g85BhTkRWEf/17Ck=;
	b=6xpO0L1Dm7q+wmg9Nlh7cMobWIEONXWrNd/EH9BC5pVoETy2n6Qb/aJN1qMlrfAO841vlY
	v2d1Oq8bH5DBDjBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B6183139D1;
	Tue,  4 Jan 2022 00:10:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id qBTqK5CQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:56 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <guro@fb.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 21/32] mm/slab: Finish struct page to struct slab conversion
Date: Tue,  4 Jan 2022 01:10:35 +0100
Message-Id: <20220104001046.12263-22-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2718; h=from:subject; bh=nDoqQv1xtNyv1GEvFyl8WkpbVHBlRB5oWQkNHkmZFxA=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05B7knmmnwsQ/0zWjAP4lXrkRHKJlZ+y5/XiUEpI YFpQrmiJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQewAKCRDgIcpz8YmpEMjfB/ wK/IsnqeTsTpLOC1RxFMMoYMtzQLf+CpjgPKLkR0s38RQOchr3nx6CadBLn3Om2rcZ3vCMkYGsfOyL CCtQ8NXFod3C1e7at5nLJKmB+Bcpzz9DfgiF0E/Uco+WiWvTgXz5A8eZ4hm/xpb44gL8iaepE1MdMt B/wr8G2ZqxN+2bZ+Ri2xO39WHzprtzCJJfj1eZ7AnAQKPDQ8FqKLLZ9/Mqqkl2mQr9cgvto/LrtKHi RSnCsVqJcCPzWrKutBX+3oRWVpDUFA8Zc5dgQfWgtR+jhYynmfBbMnQXjbGE9Z9wH67XpkXBdIzXxX 8aV8kN54w2FUpbse7JFqGJ7KrX7N0w
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

Change cache_free_alien() to use slab_nid(virt_to_slab()). Otherwise
just update of comments and some remaining variable names.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slab.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index a8db0395a68a..547ed068a569 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -793,16 +793,16 @@ static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
 
 static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 {
-	int page_node = page_to_nid(virt_to_page(objp));
+	int slab_node = slab_nid(virt_to_slab(objp));
 	int node = numa_mem_id();
 	/*
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(node == page_node))
+	if (likely(node == slab_node))
 		return 0;
 
-	return __cache_free_alien(cachep, objp, node, page_node);
+	return __cache_free_alien(cachep, objp, node, slab_node);
 }
 
 /*
@@ -1612,10 +1612,10 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep,
 /**
  * slab_destroy - destroy and release all objects in a slab
  * @cachep: cache pointer being destroyed
- * @page: page pointer being destroyed
+ * @slab: slab being destroyed
  *
- * Destroy all the objs in a slab page, and release the mem back to the system.
- * Before calling the slab page must have been unlinked from the cache. The
+ * Destroy all the objs in a slab, and release the mem back to the system.
+ * Before calling the slab must have been unlinked from the cache. The
  * kmem_cache_node ->list_lock is not held/needed.
  */
 static void slab_destroy(struct kmem_cache *cachep, struct slab *slab)
@@ -2559,7 +2559,7 @@ static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 	void *freelist;
 	size_t offset;
 	gfp_t local_flags;
-	int page_node;
+	int slab_node;
 	struct kmem_cache_node *n;
 	struct slab *slab;
 
@@ -2585,8 +2585,8 @@ static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 	if (!slab)
 		goto failed;
 
-	page_node = slab_nid(slab);
-	n = get_node(cachep, page_node);
+	slab_node = slab_nid(slab);
+	n = get_node(cachep, slab_node);
 
 	/* Get colour for the slab, and cal the next value. */
 	n->colour_next++;
@@ -2608,7 +2608,7 @@ static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 
 	/* Get slab management. */
 	freelist = alloc_slabmgmt(cachep, slab, offset,
-			local_flags & ~GFP_CONSTRAINT_MASK, page_node);
+			local_flags & ~GFP_CONSTRAINT_MASK, slab_node);
 	if (OFF_SLAB(cachep) && !freelist)
 		goto opps1;
 
-- 
2.34.1

