Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ABD2CAB
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 99C741FDFE;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=az6sFyj1e45fY/bBnrxdX3b+BRZdTiwGv8NbVsxpP3M=;
	b=NT1RFzzi3OGQN/xRn0p4koCTY7K6jnXwbq1+Uc7vwbX19emcIwv5R0oZDtufKUraLtV90F
	phRnBD/ZJVxwZxjqrRzROurPKLVxZlWCeTKkIEnXuoax//Djnb5k7RUz1OAzd98tPdusIU
	wG0kLw2SqXP5BHFWNkk4BiC5wYkbGmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=az6sFyj1e45fY/bBnrxdX3b+BRZdTiwGv8NbVsxpP3M=;
	b=TmWYVL7cPGiRxn4R6wiUa9HXSbsHfD+BZkwuwYfUrcXqEJjj+JyjfO4xHBnDvqVdQD+v+U
	ZkeQiNecKIV0DjDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 670CF14050;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 0OeYGLi7p2HPSAAAMHmgww
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
	Vlastimil Babka <vbabka@suse.cz>,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	iommu@lists.linux-foundation.org
Subject: [PATCH v2 29/33] iommu: Use put_pages_list
Date: Wed,  1 Dec 2021 19:15:06 +0100
Message-Id: <20211201181510.18784-30-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14154; i=vbabka@suse.cz; h=from:subject; bh=pLlXe7dSmOifDup/aySOAuI6iuF91lovDBJ0efL+weE=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uia2Tt+TMTC5mrb9JgIVqtq/cL3fYBFo3kKe1Y uiqNi0mJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7ogAKCRDgIcpz8YmpEPXkB/ 9F2yl0GALIVvuaFp6Z0dtmri3q4tvGZmEkIeK6BTqTOQ4WBPy7aC74I7uivwwoT0XjZ2w0OlBoBqCm HhChnbR9XArXMewbtlI0uSACjXw3emI5pLN3ceFkfrQ1HcJXiZag5ZJaGbmeU8FtSLd+wKmrcuuHOJ AAX+8M1s9J1CB+8QTN8v80469J3u0wu8wno2pcRoJmhOIOjNfQGIZ8jbnBH3g3Km8hGSAiaRHxmgPp w8JNjl9htRlhaReT4yqdtYsUh7YOjg+8bQ0IZKwtIUb9eBb8hL3I9BLurTlg/JPaY3rfq5AvoWpGwx ig364SAdNAoDWYqRnFmbvqEYkvC4hW
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

page->freelist is for the use of slab.  We already have the ability
to free a list of pages in the core mm, but it requires the use of a
list_head and for the pages to be chained together through page->lru.
Switch the iommu code over to using put_pages_list().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: <iommu@lists.linux-foundation.org>
---
 drivers/iommu/amd/io_pgtable.c | 59 +++++++++-------------
 drivers/iommu/dma-iommu.c      | 11 +----
 drivers/iommu/intel/iommu.c    | 89 ++++++++++++----------------------
 include/linux/iommu.h          |  3 +-
 4 files changed, 57 insertions(+), 105 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 182c93a43efd..08ea6a02cda9 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -74,27 +74,15 @@ static u64 *first_pte_l7(u64 *pte, unsigned long *page_size,
  *
  ****************************************************************************/
 
-static void free_page_list(struct page *freelist)
-{
-	while (freelist != NULL) {
-		unsigned long p = (unsigned long)page_address(freelist);
-
-		freelist = freelist->freelist;
-		free_page(p);
-	}
-}
-
-static struct page *free_pt_page(unsigned long pt, struct page *freelist)
+static void free_pt_page(unsigned long pt, struct list_head *list)
 {
 	struct page *p = virt_to_page((void *)pt);
 
-	p->freelist = freelist;
-
-	return p;
+	list_add(&p->lru, list);
 }
 
 #define DEFINE_FREE_PT_FN(LVL, FN)						\
-static struct page *free_pt_##LVL (unsigned long __pt, struct page *freelist)	\
+static void free_pt_##LVL (unsigned long __pt, struct list_head *list)		\
 {										\
 	unsigned long p;							\
 	u64 *pt;								\
@@ -113,10 +101,10 @@ static struct page *free_pt_##LVL (unsigned long __pt, struct page *freelist)	\
 			continue;						\
 										\
 		p = (unsigned long)IOMMU_PTE_PAGE(pt[i]);			\
-		freelist = FN(p, freelist);					\
+		FN(p, list);							\
 	}									\
 										\
-	return free_pt_page((unsigned long)pt, freelist);			\
+	free_pt_page((unsigned long)pt, list);					\
 }
 
 DEFINE_FREE_PT_FN(l2, free_pt_page)
@@ -125,36 +113,33 @@ DEFINE_FREE_PT_FN(l4, free_pt_l3)
 DEFINE_FREE_PT_FN(l5, free_pt_l4)
 DEFINE_FREE_PT_FN(l6, free_pt_l5)
 
-static struct page *free_sub_pt(unsigned long root, int mode,
-				struct page *freelist)
+static void free_sub_pt(unsigned long root, int mode, struct list_head *list)
 {
 	switch (mode) {
 	case PAGE_MODE_NONE:
 	case PAGE_MODE_7_LEVEL:
 		break;
 	case PAGE_MODE_1_LEVEL:
-		freelist = free_pt_page(root, freelist);
+		free_pt_page(root, list);
 		break;
 	case PAGE_MODE_2_LEVEL:
-		freelist = free_pt_l2(root, freelist);
+		free_pt_l2(root, list);
 		break;
 	case PAGE_MODE_3_LEVEL:
-		freelist = free_pt_l3(root, freelist);
+		free_pt_l3(root, list);
 		break;
 	case PAGE_MODE_4_LEVEL:
-		freelist = free_pt_l4(root, freelist);
+		free_pt_l4(root, list);
 		break;
 	case PAGE_MODE_5_LEVEL:
-		freelist = free_pt_l5(root, freelist);
+		free_pt_l5(root, list);
 		break;
 	case PAGE_MODE_6_LEVEL:
-		freelist = free_pt_l6(root, freelist);
+		free_pt_l6(root, list);
 		break;
 	default:
 		BUG();
 	}
-
-	return freelist;
 }
 
 void amd_iommu_domain_set_pgtable(struct protection_domain *domain,
@@ -362,7 +347,7 @@ static u64 *fetch_pte(struct amd_io_pgtable *pgtable,
 	return pte;
 }
 
-static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
+static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *list)
 {
 	unsigned long pt;
 	int mode;
@@ -373,12 +358,12 @@ static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
 	}
 
 	if (!IOMMU_PTE_PRESENT(pteval))
-		return freelist;
+		return;
 
 	pt   = (unsigned long)IOMMU_PTE_PAGE(pteval);
 	mode = IOMMU_PTE_MODE(pteval);
 
-	return free_sub_pt(pt, mode, freelist);
+	free_sub_pt(pt, mode, list);
 }
 
 /*
@@ -392,7 +377,7 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
 			  phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
-	struct page *freelist = NULL;
+	LIST_HEAD(freelist);
 	bool updated = false;
 	u64 __pte, *pte;
 	int ret, i, count;
@@ -412,9 +397,9 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
 		goto out;
 
 	for (i = 0; i < count; ++i)
-		freelist = free_clear_pte(&pte[i], pte[i], freelist);
+		free_clear_pte(&pte[i], pte[i], &freelist);
 
-	if (freelist != NULL)
+	if (!list_empty(&freelist))
 		updated = true;
 
 	if (count > 1) {
@@ -449,7 +434,7 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
 	}
 
 	/* Everything flushed out, free pages now */
-	free_page_list(freelist);
+	put_pages_list(&freelist);
 
 	return ret;
 }
@@ -511,7 +496,7 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
 	struct protection_domain *dom;
-	struct page *freelist = NULL;
+	LIST_HEAD(freelist);
 	unsigned long root;
 
 	if (pgtable->mode == PAGE_MODE_NONE)
@@ -530,9 +515,9 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	root = (unsigned long)pgtable->root;
-	freelist = free_sub_pt(root, pgtable->mode, freelist);
+	free_sub_pt(root, pgtable->mode, &freelist);
 
-	free_page_list(freelist);
+	put_pages_list(&freelist);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index b42e38a0dbe2..e61881c2c258 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -66,14 +66,7 @@ early_param("iommu.forcedac", iommu_dma_forcedac_setup);
 
 static void iommu_dma_entry_dtor(unsigned long data)
 {
-	struct page *freelist = (struct page *)data;
-
-	while (freelist) {
-		unsigned long p = (unsigned long)page_address(freelist);
-
-		freelist = freelist->freelist;
-		free_page(p);
-	}
+	put_pages_list((struct list_head *)data);
 }
 
 static inline size_t cookie_msi_granule(struct iommu_dma_cookie *cookie)
@@ -479,7 +472,7 @@ static void iommu_dma_free_iova(struct iommu_dma_cookie *cookie,
 	else if (gather && gather->queued)
 		queue_iova(iovad, iova_pfn(iovad, iova),
 				size >> iova_shift(iovad),
-				(unsigned long)gather->freelist);
+				(unsigned long)&gather->freelist);
 	else
 		free_iova_fast(iovad, iova_pfn(iovad, iova),
 				size >> iova_shift(iovad));
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b6a8f3282411..cd2ec6779cac 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1303,35 +1303,30 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
    know the hardware page-walk will no longer touch them.
    The 'pte' argument is the *parent* PTE, pointing to the page that is to
    be freed. */
-static struct page *dma_pte_list_pagetables(struct dmar_domain *domain,
-					    int level, struct dma_pte *pte,
-					    struct page *freelist)
+static void dma_pte_list_pagetables(struct dmar_domain *domain,
+				    int level, struct dma_pte *pte,
+				    struct list_head *list)
 {
 	struct page *pg;
 
 	pg = pfn_to_page(dma_pte_addr(pte) >> PAGE_SHIFT);
-	pg->freelist = freelist;
-	freelist = pg;
+	list_add(&pg->lru, list);
 
 	if (level == 1)
-		return freelist;
+		return;
 
 	pte = page_address(pg);
 	do {
 		if (dma_pte_present(pte) && !dma_pte_superpage(pte))
-			freelist = dma_pte_list_pagetables(domain, level - 1,
-							   pte, freelist);
+			dma_pte_list_pagetables(domain, level - 1, pte, list);
 		pte++;
 	} while (!first_pte_in_page(pte));
-
-	return freelist;
 }
 
-static struct page *dma_pte_clear_level(struct dmar_domain *domain, int level,
-					struct dma_pte *pte, unsigned long pfn,
-					unsigned long start_pfn,
-					unsigned long last_pfn,
-					struct page *freelist)
+static void dma_pte_clear_level(struct dmar_domain *domain, int level,
+				struct dma_pte *pte, unsigned long pfn,
+				unsigned long start_pfn, unsigned long last_pfn,
+				struct list_head *list)
 {
 	struct dma_pte *first_pte = NULL, *last_pte = NULL;
 
@@ -1350,7 +1345,7 @@ static struct page *dma_pte_clear_level(struct dmar_domain *domain, int level,
 			/* These suborbinate page tables are going away entirely. Don't
 			   bother to clear them; we're just going to *free* them. */
 			if (level > 1 && !dma_pte_superpage(pte))
-				freelist = dma_pte_list_pagetables(domain, level - 1, pte, freelist);
+				dma_pte_list_pagetables(domain, level - 1, pte, list);
 
 			dma_clear_pte(pte);
 			if (!first_pte)
@@ -1358,10 +1353,10 @@ static struct page *dma_pte_clear_level(struct dmar_domain *domain, int level,
 			last_pte = pte;
 		} else if (level > 1) {
 			/* Recurse down into a level that isn't *entirely* obsolete */
-			freelist = dma_pte_clear_level(domain, level - 1,
-						       phys_to_virt(dma_pte_addr(pte)),
-						       level_pfn, start_pfn, last_pfn,
-						       freelist);
+			dma_pte_clear_level(domain, level - 1,
+					    phys_to_virt(dma_pte_addr(pte)),
+					    level_pfn, start_pfn, last_pfn,
+					    list);
 		}
 next:
 		pfn = level_pfn + level_size(level);
@@ -1370,47 +1365,28 @@ static struct page *dma_pte_clear_level(struct dmar_domain *domain, int level,
 	if (first_pte)
 		domain_flush_cache(domain, first_pte,
 				   (void *)++last_pte - (void *)first_pte);
-
-	return freelist;
 }
 
 /* We can't just free the pages because the IOMMU may still be walking
    the page tables, and may have cached the intermediate levels. The
    pages can only be freed after the IOTLB flush has been done. */
-static struct page *domain_unmap(struct dmar_domain *domain,
-				 unsigned long start_pfn,
-				 unsigned long last_pfn,
-				 struct page *freelist)
+static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
+			 unsigned long last_pfn, struct list_head *list)
 {
 	BUG_ON(!domain_pfn_supported(domain, start_pfn));
 	BUG_ON(!domain_pfn_supported(domain, last_pfn));
 	BUG_ON(start_pfn > last_pfn);
 
 	/* we don't need lock here; nobody else touches the iova range */
-	freelist = dma_pte_clear_level(domain, agaw_to_level(domain->agaw),
-				       domain->pgd, 0, start_pfn, last_pfn,
-				       freelist);
+	dma_pte_clear_level(domain, agaw_to_level(domain->agaw),
+			    domain->pgd, 0, start_pfn, last_pfn, list);
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
 		struct page *pgd_page = virt_to_page(domain->pgd);
-		pgd_page->freelist = freelist;
-		freelist = pgd_page;
-
+		list_add(&pgd_page->lru, list);
 		domain->pgd = NULL;
 	}
-
-	return freelist;
-}
-
-static void dma_free_pagelist(struct page *freelist)
-{
-	struct page *pg;
-
-	while ((pg = freelist)) {
-		freelist = pg->freelist;
-		free_pgtable_page(page_address(pg));
-	}
 }
 
 /* iommu handling */
@@ -2095,11 +2071,10 @@ static void domain_exit(struct dmar_domain *domain)
 	domain_remove_dev_info(domain);
 
 	if (domain->pgd) {
-		struct page *freelist;
+		LIST_HEAD(pages);
 
-		freelist = domain_unmap(domain, 0,
-					DOMAIN_MAX_PFN(domain->gaw), NULL);
-		dma_free_pagelist(freelist);
+		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &pages);
+		put_pages_list(&pages);
 	}
 
 	free_domain_mem(domain);
@@ -4192,19 +4167,17 @@ static int intel_iommu_memory_notifier(struct notifier_block *nb,
 		{
 			struct dmar_drhd_unit *drhd;
 			struct intel_iommu *iommu;
-			struct page *freelist;
+			LIST_HEAD(pages);
 
-			freelist = domain_unmap(si_domain,
-						start_vpfn, last_vpfn,
-						NULL);
+			domain_unmap(si_domain, start_vpfn, last_vpfn, &pages);
 
 			rcu_read_lock();
 			for_each_active_iommu(iommu, drhd)
 				iommu_flush_iotlb_psi(iommu, si_domain,
 					start_vpfn, mhp->nr_pages,
-					!freelist, 0);
+					list_empty(&pages), 0);
 			rcu_read_unlock();
-			dma_free_pagelist(freelist);
+			put_pages_list(&pages);
 		}
 		break;
 	}
@@ -5211,8 +5184,7 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	start_pfn = iova >> VTD_PAGE_SHIFT;
 	last_pfn = (iova + size - 1) >> VTD_PAGE_SHIFT;
 
-	gather->freelist = domain_unmap(dmar_domain, start_pfn,
-					last_pfn, gather->freelist);
+	domain_unmap(dmar_domain, start_pfn, last_pfn, &gather->freelist);
 
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
@@ -5248,9 +5220,10 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 
 	for_each_domain_iommu(iommu_id, dmar_domain)
 		iommu_flush_iotlb_psi(g_iommus[iommu_id], dmar_domain,
-				      start_pfn, nrpages, !gather->freelist, 0);
+				      start_pfn, nrpages,
+				      list_empty(&gather->freelist), 0);
 
-	dma_free_pagelist(gather->freelist);
+	put_pages_list(&gather->freelist);
 }
 
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2f3435e7d17..de0c57a567c8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -186,7 +186,7 @@ struct iommu_iotlb_gather {
 	unsigned long		start;
 	unsigned long		end;
 	size_t			pgsize;
-	struct page		*freelist;
+	struct list_head	freelist;
 	bool			queued;
 };
 
@@ -399,6 +399,7 @@ static inline void iommu_iotlb_gather_init(struct iommu_iotlb_gather *gather)
 {
 	*gather = (struct iommu_iotlb_gather) {
 		.start	= ULONG_MAX,
+		.freelist = LIST_HEAD_INIT(gather->freelist),
 	};
 }
 
-- 
2.33.1

