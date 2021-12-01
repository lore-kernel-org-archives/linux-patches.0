Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD1F2CA8
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B7E7D1FDFF;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8mheWxBZ58tQ7Vg4bkiAv6PXYeavaSncFl/VEkySlCU=;
	b=QM/Ob75Qo+r4ufqiaVrGjVZBlKtu8FG/LHy4k9jKNdBTBUQ3Og5tDAmqabw8ijB0uVLSse
	WCY+M5yMtYWy25aikaSXQnIUbqtuAZ1UT3ixbbTwyPj7HrpxRMZRGxM/YxcxcTPt/bg129
	N56oW8kW1rRrERJyO8KoLWcQYDw4Jm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8mheWxBZ58tQ7Vg4bkiAv6PXYeavaSncFl/VEkySlCU=;
	b=TeiB0O/anFb1X8Yn3Cc3SJmGm6xX0+q34N0dLGysTaxDDasNoy90NCIX5PbaiFE5YPVW2E
	f73gm+RouepDZ/CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 99EAD13D9D;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iAgJJbi7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:20 +0000
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
Subject: [PATCH v2 30/33] mm: Remove slab from struct page
Date: Wed,  1 Dec 2021 19:15:07 +0100
Message-Id: <20211201181510.18784-31-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3653; i=vbabka@suse.cz; h=from:subject; bh=VB4Uk0F7SdRBBpNuXzDoUgJibZlI+vi95uC0NtNOkZM=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7ul3Sq1ufulztxv3a1e0TGMZ9tQHW4IQwGbUL4E AxsSWTCJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7pQAKCRDgIcpz8YmpEF4nCA Cx36qSZnmrssdHsYMJWEMk7zQxurm+HfDapzNvWnEx4MMLJEyMHBYAhWUMZeeZI0c6Z6jlzwnfC4zw gH/7m6cB6iA6IuXku//UaqL29oWP7ke1Rbam65Dk+J8/DJqtQgxgHrUv6/o6h2Tgi8bUHK80JhvhLc pReT9Vusjlwul8C40dhdYsa5wJRuvyZJLKdw0M9W78Cx6PMQLdFVS5cPAuWqldhd5LwgUkmoTHwzBC unlwTafIwAmrHSPfnJUi3Sl479wLYcgSridG2LPdKgnj8CASEXc9RIYvNzLa3v5yrv928G4D1MS4gZ dhWygoJXlwLnPMu1P3vt8NS1Kl4POV
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

All members of struct slab can now be removed from struct page.
This shrinks the definition of struct page by 30 LOC, making
it easier to understand.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm_types.h   | 28 ----------------------------
 include/linux/page-flags.h | 37 -------------------------------------
 mm/slab.h                  |  4 ----
 3 files changed, 69 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ae3537c7920..646f3ed4f6df 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -118,31 +118,6 @@ struct page {
 				atomic_long_t pp_frag_count;
 			};
 		};
-		struct {	/* slab, slob and slub */
-			union {
-				struct list_head slab_list;
-				struct {	/* Partial pages */
-					struct page *next;
-#ifdef CONFIG_64BIT
-					int pages;	/* Nr of pages left */
-#else
-					short int pages;
-#endif
-				};
-			};
-			struct kmem_cache *slab_cache; /* not slob */
-			/* Double-word boundary */
-			void *freelist;		/* first free object */
-			union {
-				void *s_mem;	/* slab: first object */
-				unsigned long counters;		/* SLUB */
-				struct {			/* SLUB */
-					unsigned inuse:16;
-					unsigned objects:15;
-					unsigned frozen:1;
-				};
-			};
-		};
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
 
@@ -206,9 +181,6 @@ struct page {
 		 * which are currently stored here.
 		 */
 		unsigned int page_type;
-
-		unsigned int active;		/* SLAB */
-		int units;			/* SLOB */
 	};
 
 	/* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b5f14d581113..1b08e33265fa 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -909,43 +909,6 @@ extern bool is_free_buddy_page(struct page *page);
 
 __PAGEFLAG(Isolated, isolated, PF_ANY);
 
-/*
- * If network-based swap is enabled, sl*b must keep track of whether pages
- * were allocated from pfmemalloc reserves.
- */
-static inline int PageSlabPfmemalloc(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageSlab(page), page);
-	return PageActive(page);
-}
-
-/*
- * A version of PageSlabPfmemalloc() for opportunistic checks where the page
- * might have been freed under us and not be a PageSlab anymore.
- */
-static inline int __PageSlabPfmemalloc(struct page *page)
-{
-	return PageActive(page);
-}
-
-static inline void SetPageSlabPfmemalloc(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageSlab(page), page);
-	SetPageActive(page);
-}
-
-static inline void __ClearPageSlabPfmemalloc(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageSlab(page), page);
-	__ClearPageActive(page);
-}
-
-static inline void ClearPageSlabPfmemalloc(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageSlab(page), page);
-	ClearPageActive(page);
-}
-
 #ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1UL << PG_mlocked)
 #else
diff --git a/mm/slab.h b/mm/slab.h
index 0760f20686a7..2d50c099a222 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -47,11 +47,7 @@ struct slab {
 	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
 SLAB_MATCH(flags, __page_flags);
 SLAB_MATCH(compound_head, slab_list);	/* Ensure bit 0 is clear */
-SLAB_MATCH(slab_list, slab_list);
 SLAB_MATCH(rcu_head, rcu_head);
-SLAB_MATCH(slab_cache, slab_cache);
-SLAB_MATCH(s_mem, s_mem);
-SLAB_MATCH(active, active);
 SLAB_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
 SLAB_MATCH(memcg_data, memcg_data);
-- 
2.33.1

