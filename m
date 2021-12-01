Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE562C9D
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9114D218B1;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8J4CQGaEGCd8Yz7JY+TYmVJrL6nLrY8zj7hNJ3qkc+k=;
	b=DyCA22WIO3DjK2/+ZHlsGdJ6cctTV260qxySkBHW5f72SCGWZkGjPOcl7COgJytygZsHDN
	EIY9nNoVwvPdhQC5k5W87iHm64wCU3HBYxvR9cY7F3pXPxU9p6psRIdOClkv7kmZ8LuJns
	wNvhjn/ABXz28dfWf5mTyj6wnxXSSkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8J4CQGaEGCd8Yz7JY+TYmVJrL6nLrY8zj7hNJ3qkc+k=;
	b=P3k8IbJV8Ng+yKrs7+6CsK/aLDzucZTALEud/K+qanhCbOnfUMBlYNRYrRFeOJSZVC89v0
	qG78jasfVzKrQACw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67B4213D9D;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id WCO8GLW7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:17 +0000
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
Subject: [PATCH v2 14/33] mm/slub: Convert alloc_slab_page() to return a struct slab
Date: Wed,  1 Dec 2021 19:14:51 +0100
Message-Id: <20211201181510.18784-15-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2855; h=from:subject; bh=6DHLS3aE0sjZlDxj0h0hg7NtElnxcVlaxyhYFZV4jZo=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7t9b8DfRVlr73BupNOc5li3qPhliOQr4WzJI7sr mw04wHqJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7fQAKCRDgIcpz8YmpEL9gB/ 9sXX6ELAT7+mVJB44POyU6W4ZKDMS9gvuFe0aMIkClVfNXTTIA6TDX8nzuSchQJjuTdn9nTET0P2Ec qBZHGQG++AskupUTknih3j4/wA2SltHoJaI7i3Yl+wKhAbNoxtltW05l1o5MJqlnl7B/l6T+nZV+mC nCIy8+T9+hsx8FCIG2vJJq7LkKxXKq7JSvRz3zxcecRZCk2DGGT+rjx7MNZ426AAYXCRdtcA00e8Xu lDgdxW8EwRlgMC0B/cPiOLZwpsQEO+QdVjLx9cxyRSmB/h5Q9RVbZS6hTd2Y/WYkRtxeXlrUa7EqCY SwxhW5gQzzfZ4nMTOgiUNA92iWfncL
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

Preparatory, callers convert back to struct page for now.

Also move setting page flags to alloc_slab_page() where we still operate on a
struct page. This means the page->slab_cache pointer is now set later than the
PageSlab flag, which could theoretically confuse some pfn walker assuming
PageSlab means there would be a valid cache pointer. But as the code had no
barriers and used __set_bit() anyway, it could have happened already, so there
shouldn't be such a walker.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a4f7dafe0610..3d82e8e0fc2b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1788,18 +1788,27 @@ static void *setup_object(struct kmem_cache *s, struct page *page,
 /*
  * Slab allocation and freeing
  */
-static inline struct page *alloc_slab_page(struct kmem_cache *s,
+static inline struct slab *alloc_slab_page(struct kmem_cache *s,
 		gfp_t flags, int node, struct kmem_cache_order_objects oo)
 {
-	struct page *page;
+	struct folio *folio;
+	struct slab *slab;
 	unsigned int order = oo_order(oo);
 
 	if (node == NUMA_NO_NODE)
-		page = alloc_pages(flags, order);
+		folio = (struct folio *)alloc_pages(flags, order);
 	else
-		page = __alloc_pages_node(node, flags, order);
+		folio = (struct folio *)__alloc_pages_node(node, flags, order);
 
-	return page;
+	if (!folio)
+		return NULL;
+
+	slab = folio_slab(folio);
+	__folio_set_slab(folio);
+	if (page_is_pfmemalloc(folio_page(folio, 0)))
+		slab_set_pfmemalloc(slab);
+
+	return slab;
 }
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
@@ -1932,7 +1941,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~(__GFP_RECLAIM|__GFP_NOFAIL);
 
-	page = alloc_slab_page(s, alloc_gfp, node, oo);
+	page = slab_page(alloc_slab_page(s, alloc_gfp, node, oo));
 	if (unlikely(!page)) {
 		oo = s->min;
 		alloc_gfp = flags;
@@ -1940,7 +1949,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 		 * Allocation may have failed due to fragmentation.
 		 * Try a lower order alloc if possible
 		 */
-		page = alloc_slab_page(s, alloc_gfp, node, oo);
+		page = slab_page(alloc_slab_page(s, alloc_gfp, node, oo));
 		if (unlikely(!page))
 			goto out;
 		stat(s, ORDER_FALLBACK);
@@ -1951,9 +1960,6 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	account_slab(page_slab(page), oo_order(oo), s, flags);
 
 	page->slab_cache = s;
-	__SetPageSlab(page);
-	if (page_is_pfmemalloc(page))
-		SetPageSlabPfmemalloc(page);
 
 	kasan_poison_slab(page);
 
-- 
2.33.1

