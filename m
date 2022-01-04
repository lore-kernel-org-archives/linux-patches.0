Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774FF2CA6
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7908A1F394;
	Tue,  4 Jan 2022 00:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Or3oWyMsoQHXAU91slBIEyPKfUAJV9YMUH29NyrSe/0=;
	b=ga1UsrwH8YZEddR104LQ68acqkH5QeyBef3rDZU1q4pvfb+IbFGy8wPqI16fDwoa8TKLZz
	x6ddgbYLh26P14y49TlwhtoY6Bjxbo/46pOld1ldReeNneOUd0AVfbLFidjJjW6wng3D41
	SRxQGygkQqqhzCYA4P+/t0M9rbeyS5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Or3oWyMsoQHXAU91slBIEyPKfUAJV9YMUH29NyrSe/0=;
	b=yAz+lBW6Oythpzf2FKEFd9e9UytnQVhwwZpEL6h0QUFXz6cbqHj3/o4JNlcQMom20pU4co
	KnPu/uFcbPULOODg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 49ABA139D1;
	Tue,  4 Jan 2022 00:10:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id GPhqEZCQ02FEQwAAMHmgww
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
Subject: [PATCH v4 19/32] mm/slab: Convert kmem_getpages() and kmem_freepages() to struct slab
Date: Tue,  4 Jan 2022 01:10:33 +0100
Message-Id: <20220104001046.12263-20-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4114; h=from:subject; bh=M1DcBddcFE+RPtyMkX/laUjjxWfdFhW9Ss4bxn3Kgxs=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05B5fzsYLAm7vrWggMeqfx0bbw6wWmCwEJXceJQ8 axE3kYaJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQeQAKCRDgIcpz8YmpEIL3B/ 9ykGJd4bO0SSrqyyHDq7Aj6gjZKYuY7bSgwK0dWVXH48qjeiNxYmjXLWq2BY12hJ7dDEWmAyj5ZGA6 Ov8+GG1VV5q/cbCWbltQRUQRXjOHS5RdBxjHf0MNupPQM1jMsYRxjQxSaOQS1CnzOCZrBHhlvWIec4 tix6LFzXHEcMx8CgbJHZyFG3M0E/tJLsjElKEd72T1IJrW6XipEk6q+Xu9qU5z0Gl9jfYX9xH93WNJ hsdU/fcvLSgVL6bYLzQCatMSUxXHSwGdM92ICLjMW+JWN/xyJowsVP2w+NMzstMlT2/0xk5NK41waN 0Va3UAQhUGC2eiZQPuq+JwyvpMOf2D
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

These functions sit at the boundary to page allocator. Also use folio
internally to avoid extra compound_head() when dealing with page flags.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slab.c | 53 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 38fcd3f496df..dc9eb4a8f869 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1367,57 +1367,60 @@ slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
  * did not request dmaable memory, we might get it, but that
  * would be relatively rare and ignorable.
  */
-static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
+static struct slab *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 								int nodeid)
 {
-	struct page *page;
+	struct folio *folio;
+	struct slab *slab;
 
 	flags |= cachep->allocflags;
 
-	page = __alloc_pages_node(nodeid, flags, cachep->gfporder);
-	if (!page) {
+	folio = (struct folio *) __alloc_pages_node(nodeid, flags, cachep->gfporder);
+	if (!folio) {
 		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
 	}
 
-	account_slab(page_slab(page), cachep->gfporder, cachep, flags);
-	__SetPageSlab(page);
+	slab = folio_slab(folio);
+
+	account_slab(slab, cachep->gfporder, cachep, flags);
+	__folio_set_slab(folio);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
-	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
-		SetPageSlabPfmemalloc(page);
+	if (sk_memalloc_socks() && page_is_pfmemalloc(folio_page(folio, 0)))
+		slab_set_pfmemalloc(slab);
 
-	return page;
+	return slab;
 }
 
 /*
  * Interface to system's page release.
  */
-static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
+static void kmem_freepages(struct kmem_cache *cachep, struct slab *slab)
 {
 	int order = cachep->gfporder;
+	struct folio *folio = slab_folio(slab);
 
-	BUG_ON(!PageSlab(page));
-	__ClearPageSlabPfmemalloc(page);
-	__ClearPageSlab(page);
-	page_mapcount_reset(page);
-	/* In union with page->mapping where page allocator expects NULL */
-	page->slab_cache = NULL;
+	BUG_ON(!folio_test_slab(folio));
+	__slab_clear_pfmemalloc(slab);
+	__folio_clear_slab(folio);
+	page_mapcount_reset(folio_page(folio, 0));
+	folio->mapping = NULL;
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
-	unaccount_slab(page_slab(page), order, cachep);
-	__free_pages(page, order);
+	unaccount_slab(slab, order, cachep);
+	__free_pages(folio_page(folio, 0), order);
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
 {
 	struct kmem_cache *cachep;
-	struct page *page;
+	struct slab *slab;
 
-	page = container_of(head, struct page, rcu_head);
-	cachep = page->slab_cache;
+	slab = container_of(head, struct slab, rcu_head);
+	cachep = slab->slab_cache;
 
-	kmem_freepages(cachep, page);
+	kmem_freepages(cachep, slab);
 }
 
 #if DEBUG
@@ -1624,7 +1627,7 @@ static void slab_destroy(struct kmem_cache *cachep, struct page *page)
 	if (unlikely(cachep->flags & SLAB_TYPESAFE_BY_RCU))
 		call_rcu(&page->rcu_head, kmem_rcu_free);
 	else
-		kmem_freepages(cachep, page);
+		kmem_freepages(cachep, page_slab(page));
 
 	/*
 	 * From now on, we don't use freelist
@@ -2578,7 +2581,7 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	 * Get mem for the objs.  Attempt to allocate a physical page from
 	 * 'nodeid'.
 	 */
-	page = kmem_getpages(cachep, local_flags, nodeid);
+	page = slab_page(kmem_getpages(cachep, local_flags, nodeid));
 	if (!page)
 		goto failed;
 
@@ -2620,7 +2623,7 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	return page;
 
 opps1:
-	kmem_freepages(cachep, page);
+	kmem_freepages(cachep, page_slab(page));
 failed:
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
-- 
2.34.1

