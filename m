Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8118E2CA6
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B03FC212B8;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Xzcwca5Qko38x4/RC4onXsBWT7WTlR5xrLzzVEBokI=;
	b=P8Qx2hQNSI8QI98geokwyeK/7tGkqHJuR1RdlQmWGaYHYJhIrlZZ95QrL4pyl34XvzgZfI
	VQaebkvXlMz0iqZxsVvKESYUwqV20S+O0mjLpFtvErMByPcdEkjovNl8eRH/2gwkihUvcY
	S6KPRHInrwu9fC5IBskWgSKEDY5h6EI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Xzcwca5Qko38x4/RC4onXsBWT7WTlR5xrLzzVEBokI=;
	b=X8RrKyULqZIBbzFqTFwFP9wPQn1KM9WZpRIT1BlqncGSCEdDERgPJU4dCiAXlCY0vima32
	BrxgVarEn+bhTgCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 851CF139EE;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id QNDeH42Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:53 +0000
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
Subject: [PATCH v4 05/32] mm: Convert [un]account_slab_page() to struct slab
Date: Tue,  4 Jan 2022 01:10:19 +0100
Message-Id: <20220104001046.12263-6-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3500; i=vbabka@suse.cz; h=from:subject; bh=5Y1VNHTclE7XtFwVBdEpSkOle5/ktRmPmagbWskYnA8=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BtSIs7tgvIQ3uholcT7unqbFuBRjDxt6fbG6Yj GFMgU5iJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQbQAKCRDgIcpz8YmpEFyoB/ 9woQwr2pelkE5RwuR8pj7fsFaFgZGctXlzIgwYNuj5QHK2xpKWtKRDtYgXn9hvrAjX2fQYvsWRuARc YDPz1sc4kHHm/tDbRysq8Wj9Ajjg8qOXmj4LMNrp0ZhNv0ZjFqdYKFvUUST65qQ4grvNFXGJ2Gr2u/ CJXvltZkYvgc/O8hsvAUlrtSw1v9JRrHlXCmi1jLy3NPTyHCMt57ebHY1W/pmQeOH1HHL02ZTGaYNy pOgKr2yd/Za9jBrS0NuAdehTL5WkxQSkpjEaN0UOcpCbZjHWh0qkcFhZBUnHbYG7lRSr/dMwOj0WQh PP75sq55xJfFiv9oASdCO/fShhtJpO
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Convert the parameter of these functions to struct slab instead of
struct page and drop _page from the names. For now their callers just
convert page to slab.

[ vbabka@suse.cz: replace existing functions instead of calling them ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 mm/slab.c |  4 ++--
 mm/slab.h | 17 ++++++++---------
 mm/slub.c |  4 ++--
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 381875e23277..7f147805d0ab 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1380,7 +1380,7 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 		return NULL;
 	}
 
-	account_slab_page(page, cachep->gfporder, cachep, flags);
+	account_slab(page_slab(page), cachep->gfporder, cachep, flags);
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
@@ -1405,7 +1405,7 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
-	unaccount_slab_page(page, order, cachep);
+	unaccount_slab(page_slab(page), order, cachep);
 	__free_pages(page, order);
 }
 
diff --git a/mm/slab.h b/mm/slab.h
index 0e67a8cb7f80..dd3f72fddff6 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -583,24 +583,23 @@ static inline struct kmem_cache *virt_to_cache(const void *obj)
 	return page->slab_cache;
 }
 
-static __always_inline void account_slab_page(struct page *page, int order,
-					      struct kmem_cache *s,
-					      gfp_t gfp)
+static __always_inline void account_slab(struct slab *slab, int order,
+					 struct kmem_cache *s, gfp_t gfp)
 {
 	if (memcg_kmem_enabled() && (s->flags & SLAB_ACCOUNT))
-		memcg_alloc_page_obj_cgroups(page, s, gfp, true);
+		memcg_alloc_page_obj_cgroups(slab_page(slab), s, gfp, true);
 
-	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
+	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
 }
 
-static __always_inline void unaccount_slab_page(struct page *page, int order,
-						struct kmem_cache *s)
+static __always_inline void unaccount_slab(struct slab *slab, int order,
+					   struct kmem_cache *s)
 {
 	if (memcg_kmem_enabled())
-		memcg_free_page_obj_cgroups(page);
+		memcg_free_page_obj_cgroups(slab_page(slab));
 
-	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
+	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
 			    -(PAGE_SIZE << order));
 }
 
diff --git a/mm/slub.c b/mm/slub.c
index a211d96011ba..c94fb4b4d655 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1943,7 +1943,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 	page->objects = oo_objects(oo);
 
-	account_slab_page(page, oo_order(oo), s, flags);
+	account_slab(page_slab(page), oo_order(oo), s, flags);
 
 	page->slab_cache = s;
 	__SetPageSlab(page);
@@ -2014,7 +2014,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	page->slab_cache = NULL;
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	unaccount_slab_page(page, order, s);
+	unaccount_slab(page_slab(page), order, s);
 	__free_pages(page, order);
 }
 
-- 
2.34.1

