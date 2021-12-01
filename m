Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5B02CAA
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB5A1218B2;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWOTlxFmef0oGs2stQSS0Rsd2cxbVvDDqKeEkd3BcJ4=;
	b=hde6vCSOPLaGFMRjOeN4ZnNwki5UfUXlShRBoCTB+Iuvav84YYD67q0QAGLcMIJxJLGxUX
	2KVZfV/sa4MlH3z9jYbpBtf3E7mLnyR9JzknbOhGJhcW+aDEwV6x/BRsuJgiT5GMw5qkvE
	oGTvXrEvaRy9Q4rsMbPhsOhgUrUoaVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWOTlxFmef0oGs2stQSS0Rsd2cxbVvDDqKeEkd3BcJ4=;
	b=HxoWw1nmC1F+Tep4pS9PdDL4WJPC8w4b6T4xHSwdBMeVtOYe7n+vYK/lLlkvdqvcgZFF+/
	3jN841WomPoN4GCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 935D414050;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id UIZHI7W7p2HPSAAAMHmgww
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
Subject: [PATCH v2 15/33] mm/slub: Convert __free_slab() to use struct slab
Date: Wed,  1 Dec 2021 19:14:52 +0100
Message-Id: <20211201181510.18784-16-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2460; h=from:subject; bh=geJJNEx28YZrRr5Wvloi9v4Zgqxi1u8ijlEq0D6QbzY=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7t/teQXdQhfId8DCGJ7rBvvdQonM8sqbgwhAHYm 4c3x8kiJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7fwAKCRDgIcpz8YmpEKBHB/ 4gbJ4kyIKLr3x+NRnCHh4NvLBA2K9DqB1KHDmZ2OJehAEhMQxCmRDDD9eclrKO0HDT0z01ccb1K2nj M8fVT308mcc2GXkA76VuNYUiDBCjLrwHQFmuyLNOjQwY7b/0d6mC4IgilahAwncqrj49m7lPXA6Azq KIV2JNXXS5AeAGmiomFDDBjXVPEL9tB3R8GiMxEMheaglvBMzdfg+Y+UWS8qZwmck8yzP3389JA9dd J0lPpchJkTla2pOgjVyHnbEsM6KZJIZrv9e9a8SdZj0Aid1ezZ+SOaC4dOJQ8h6AV/Zcy2nMsQSBGT GT6W+QTEF8PFCMDxuF9+2DOr1BjIsH
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

__free_slab() is on the boundary of distinguishing struct slab and struct page
so start with struct slab but convert to folio for working with flags and
folio_page() to call functions that require struct page.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3d82e8e0fc2b..daa5c5b605d6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2005,35 +2005,35 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 }
 
-static void __free_slab(struct kmem_cache *s, struct page *page)
+static void __free_slab(struct kmem_cache *s, struct slab *slab)
 {
-	int order = compound_order(page);
+	struct folio *folio = slab_folio(slab);
+	int order = folio_order(folio);
 	int pages = 1 << order;
 
 	if (kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
 		void *p;
 
-		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page),
-						page->objects)
-			check_object(s, page, p, SLUB_RED_INACTIVE);
+		slab_pad_check(s, folio_page(folio, 0));
+		for_each_object(p, s, slab_address(slab), slab->objects)
+			check_object(s, folio_page(folio, 0), p, SLUB_RED_INACTIVE);
 	}
 
-	__ClearPageSlabPfmemalloc(page);
-	__ClearPageSlab(page);
+	__slab_clear_pfmemalloc(slab);
+	__folio_clear_slab(folio);
 	/* In union with page->mapping where page allocator expects NULL */
-	page->slab_cache = NULL;
+	slab->slab_cache = NULL;
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	unaccount_slab(page_slab(page), order, s);
-	__free_pages(page, order);
+	unaccount_slab(slab, order, s);
+	__free_pages(folio_page(folio, 0), order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
 {
 	struct page *page = container_of(h, struct page, rcu_head);
 
-	__free_slab(page->slab_cache, page);
+	__free_slab(page->slab_cache, page_slab(page));
 }
 
 static void free_slab(struct kmem_cache *s, struct page *page)
@@ -2041,7 +2041,7 @@ static void free_slab(struct kmem_cache *s, struct page *page)
 	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU)) {
 		call_rcu(&page->rcu_head, rcu_free_slab);
 	} else
-		__free_slab(s, page);
+		__free_slab(s, page_slab(page));
 }
 
 static void discard_slab(struct kmem_cache *s, struct page *page)
-- 
2.33.1

