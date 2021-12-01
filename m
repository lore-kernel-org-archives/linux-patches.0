Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871262CA8
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:26 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E2AF1FDFC;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrEpL2E5pw+Og7b0Zwmd4pFI3CG3AzaQt/eIyU3++g0=;
	b=Q2NTaHa2HtKdUcAnoDdqv1oFFEijnThtYkjnd1iAsu91pw7yyh85FP2t+TEH47MiwMdiZT
	W9gFFxY4t0KxqZe/cpsL378h2PmoeRtIPJ0hmCcosa8uy3kPpfE/ZqDQTnEgnb1oRCH2PY
	GiUZDJyAxr2gGvhXeeVqTxnOXXjbEJI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrEpL2E5pw+Og7b0Zwmd4pFI3CG3AzaQt/eIyU3++g0=;
	b=t+/xXx2b6F9rBukKRwK80Q6RHFoQQFbJY5i7erm67kxsuxCCXGFJ1Gt3vJG6Q8J0UQAhOJ
	lRmvpxy73uST00Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67D7614050;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id QOecGLa7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:18 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 19/33] mm/slab: Convert kmem_getpages() and kmem_freepages() to struct slab
Date: Wed,  1 Dec 2021 19:14:56 +0100
Message-Id: <20211201181510.18784-20-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3974; h=from:subject; bh=d7sd5fzR7CVnLcCqoMu7QSbuxxjM4EDUYeYWq27hNHc=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uJjlYnHM9sMjb5+vROnrg3nJd5A9cCAHl/l4LW UoCcZOGJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7iQAKCRDgIcpz8YmpEIGUB/ 9jDsALRuzvelbryp1VMyoBRJV7GQMAxOs2w/gEAhYFOlLbxJTY1EetA8+JIutBbPu8MELzhobj83Ps wxE66TGZbndpr61yrz4e3TdTQziGYFZqbaIMzJTSi2karul8W9dkTE28kyuNgOdjW4+B/OvBrasBkk TiW5MsthpSUTmvap0ndpuRPWZEXji8R+5ciKjiSqixes1rik6/7/lwTRo0qzXnVBiZISDXkEIJ+h8U Tqo1L6yRvIw/9YLKLpVtCBNa4DAojY/K/cW5N9A80i09sjZISlM0gfINu1G2emYI3IlylS33kFGr5Q RKEJVSyLaFcLooo0r3r8KvBMnG9o0b
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

These functions sit at the boundary to page allocator. Also use folio
internally to avoid extra compound_head() when dealing with page flags.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.c | 52 ++++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 38fcd3f496df..892f7042b3b9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1367,57 +1367,61 @@ slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
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
+	BUG_ON(!folio_test_slab(folio));
+	__slab_clear_pfmemalloc(slab);
+	__folio_clear_slab(folio);
+	page_mapcount_reset(folio_page(folio, 0));
 	/* In union with page->mapping where page allocator expects NULL */
-	page->slab_cache = NULL;
+	slab->slab_cache = NULL;
 
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
@@ -1624,7 +1628,7 @@ static void slab_destroy(struct kmem_cache *cachep, struct page *page)
 	if (unlikely(cachep->flags & SLAB_TYPESAFE_BY_RCU))
 		call_rcu(&page->rcu_head, kmem_rcu_free);
 	else
-		kmem_freepages(cachep, page);
+		kmem_freepages(cachep, page_slab(page));
 
 	/*
 	 * From now on, we don't use freelist
@@ -2578,7 +2582,7 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	 * Get mem for the objs.  Attempt to allocate a physical page from
 	 * 'nodeid'.
 	 */
-	page = kmem_getpages(cachep, local_flags, nodeid);
+	page = slab_page(kmem_getpages(cachep, local_flags, nodeid));
 	if (!page)
 		goto failed;
 
@@ -2620,7 +2624,7 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	return page;
 
 opps1:
-	kmem_freepages(cachep, page);
+	kmem_freepages(cachep, page_slab(page));
 failed:
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
-- 
2.33.1

