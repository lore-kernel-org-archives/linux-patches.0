Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306912CA4
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 700811F390;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8cX+MqFzs23iA6f2WW/NvfY66bLNhZidgQT19nDQPA4=;
	b=047EmuH9UoTQ9bDliMls1xbcDcoezBU6k+2VRJxJqdYb7x24zXqUsoyhUA2oqePgTP1KJb
	67qiwS1iT6u2KDBjKmJCdiXMgaWCB/4ttdJslaxBDHA9Nwrd/IuHSzqdw+reBuFZxjfxlU
	6b8MCSOiHLez4NO24QOZhgMvDhIFFgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8cX+MqFzs23iA6f2WW/NvfY66bLNhZidgQT19nDQPA4=;
	b=FsLnaZ0ydaPnxYnGMLIYQItwnzNOE5Dty+OtbKxT/u9JiXikLM5759uL0mvxdrRvCWc492
	UQ6+TLGEBl6CxNCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47752139D1;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id COCsEI+Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:55 +0000
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
Subject: [PATCH v4 14/32] mm/slub: Convert alloc_slab_page() to return a struct slab
Date: Tue,  4 Jan 2022 01:10:28 +0100
Message-Id: <20220104001046.12263-15-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2996; h=from:subject; bh=har/molbV+DD0v0Sg+BhljUqPbdMVpB3+k1Ub0YAYVo=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05B1yrj/ishk905thkDvYrdHdTeY9Yq3MWIQQTmE qXzrroGJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQdQAKCRDgIcpz8YmpEGndCA Cnx7TRle43sVKSbJtgS3EJC+LobtCmRhkR16+eCuAqprswuXsk1Wus1NyHPzgtPhfp0KYfsbi5Q51v c43Ydo0Pr/xgjlBUe4archFYrqgM0A4SplMsdRoXVZPAhz5ETuXkbYpHkhZQPit7IsQyDbTK3iJ0pj fqfP1p+Tp4XsxAwck3l9XVJ/RNTQoLLdh6y/oAMsJnI+ueufJKp6WYxeN5aqvE7vX3+m9E12iMClcH B5jZvBmgS9Ubf8p92aDRcQ01/d/BFlDF76aIw/inSrCO3Ii3peBMZWEQSwvGok2l43SdJM5+YBLqk5 mhfBy5cTBYdBMyUkxWpdL5iJ3tppP3
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

Preparatory, callers convert back to struct page for now.

Also move setting page flags to alloc_slab_page() where we still operate
on a struct page. This means the page->slab_cache pointer is now set
later than the PageSlab flag, which could theoretically confuse some pfn
walker assuming PageSlab means there would be a valid cache pointer. But
as the code had no barriers and used __set_bit() anyway, it could have
happened already, so there shouldn't be such a walker.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slub.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d3e9e322b4e2..65cbdeae7edb 100644
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
2.34.1

