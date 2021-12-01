Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0952CA2
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 192162171F;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3dn7x4vAO7A1NDlfRW2lr8zvnjRIzRGSYuX8+ae7iAw=;
	b=0RjmnZeJwhmoZCijBqgn7s55f1ORRMuTNF7tH9pmfvdQBcWS7cs+VdCo4y7H1QVEqJPKxW
	jTJvR30UwJAs9cOHBlzlPQmVmpxmxmKuSSf7AzfYjAH9KKXsPu3abvS35RceTBDaFb7lV3
	tpZIus1KWB+2/ESM5uIZx/P8YWJEHK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3dn7x4vAO7A1NDlfRW2lr8zvnjRIzRGSYuX8+ae7iAw=;
	b=+iIhENglwph2PLRFkViBe7s8myIKJm9sTTP/rJPN2mqhmg5fWCk0D4w35w+hrmWYb+C4L0
	QTItZwLnwxytdoCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E44FE14050;
	Wed,  1 Dec 2021 18:15:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id WKQrN7O7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:15 +0000
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
Subject: [PATCH v2 05/33] mm: Add account_slab() and unaccount_slab()
Date: Wed,  1 Dec 2021 19:14:42 +0100
Message-Id: <20211201181510.18784-6-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3391; i=vbabka@suse.cz; h=from:subject; bh=PBR+3dbetbQkpEh/4DBavtsNZubPZd2KOiUPTRmMTnw=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7tofxgN90NPg9aRllNVe7iImBbARlWku9YYX0pv Am0IZMiJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7aAAKCRDgIcpz8YmpELrFB/ 4slbsUOsTLbCVOummpScvgifsVJhFxG52kDmIwrLbIdF0aK4SJBygpWj/EVTqnR0tSx/OAkKuvgVLU TyKLBDwj3qKLQfEnpD8YMLzKykFBJOW5+z0h1JcDM2yvjZyYV0IX4/+lsMdGqySDbuyrOEigHdWaJ3 KdGPGMTzJxf/9GWJnRmhs8CqkXyfYJemC1IHSv37Q5Vfbhu1k6kDzt/9ozF0kdypzP3S7aQgcZrstk kdJMAK4jD9gf4zebLGETQPrvPKH/CKXHOhQ6HxJEhFnS/Y7Th3BKluDg3ulsey1ex0QK/HQE7jWiqN k7KejnQqjiGeRKa28Dr5N0aGelglh4
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

These functions take struct slab instead of struct page and replace
(un)account_slab_page(). For now their callers just convert page to slab.

[ vbabka@suse.cz: replace existing functions instead of calling them ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
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
index 4776bcc8c9e4..8b172de26c67 100644
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
2.33.1

