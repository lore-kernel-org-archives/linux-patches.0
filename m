Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F343B19CF;
	Sat, 17 Oct 2026 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255257; cv=none; b=a1dydWvmNqEzuFakTW2+Az1JBoxETepgTa2alCojWf7XUJxeO8ejFaoXq+9ZYD0w3/uvCBnsVGd+PwQBL0xcp5A8Otsi+4oM+a4sVFyOIQh6FJ0kqny8u39D0mLumIrkr4OyclXPhGPjrlprPIGlZPu25F7MguOv7+EKidkjgqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255257; c=relaxed/simple;
	bh=kR1yjzO1Wq5BzJCAPQFhctIfhSRnC/KmD9iyK28RnPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxU56qQuM5FyOTTypUWedKlb+Ntb4/mLXtKUg97SZ/YvJkVloQ+Qorv3f6htpVgUSHFMx1TZ8fJoH3Aj/K8a7DPqCHsbEbhqTutCVPcPXeyX/TY4aYi3YxG5hUvt7Yq+KDp6FnrEC1ecWQh9GTuv2Chbi7jqCe/fhLnrxpS+RSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/X62hzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/X62hzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592EF1F000C4;
	Sat, 17 Oct 2026 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255255;
	bh=dN1oBcuGAqw3QZKgEoUAvH55RQ7I9cla0JYCZUcQVxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/X62hzGlBd07skMgaO4xU15tWy0QERuZVynAotMP6KkcXsPZb3FJHBCVcW8hPUUf
	 ZC3T22vjkxqtZsjehHhD0fO1GDeUJRPeHocWbQVayXsVtUQQrU8RWuYZIIgR19Aqmb
	 qKwsVVqvY6dZO+EFF1HU29AMKdETmI+zglqS6mrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Baoquan He <bhe@redhat.com>,
	Christoph Lameter <cl@gentwo.org>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	WANG Xuerui <kernel@xen0n.name>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 717/869] mm/hugetlb: refactor code around vmemmap_walk
Date: Sat, 17 Oct 2026 17:59:18 +0200
Message-ID: <20261017160055.343210649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau <kas@kernel.org>

[ Upstream commit c0b495b91a47b6c5ee54cf00e620dbadeb884253 ]

To prepare for removing fake head pages, the vmemmap_walk code is being
reworked.

The reuse_page and reuse_addr variables are being eliminated.  There will
no longer be an expectation regarding the reuse address in relation to the
operated range.  Instead, the caller will provide head and tail vmemmap
pages.

Currently, vmemmap_head and vmemmap_tail are set to the same page, but
this will change in the future.

The only functional change is that __hugetlb_vmemmap_optimize_folio() will
abandon optimization if memory allocation fails.

Link: https://lkml.kernel.org/r/20260227194302.274384-11-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb_vmemmap.c | 224 +++++++++++++++++--------------------------
 1 file changed, 89 insertions(+), 135 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 95496e9358430..1394c13c1516f 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -24,8 +24,8 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @reuse_page:		the page which is reused for the tail vmemmap pages.
- * @reuse_addr:		the virtual address of the @reuse_page page.
+ * @vmemmap_head:	the page to be installed as first in the vmemmap range
+ * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
  *			or is mapped from.
  * @flags:		used to modify behavior in vmemmap page table walking
@@ -34,11 +34,13 @@
 struct vmemmap_remap_walk {
 	void			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
+
 	unsigned long		nr_walked;
-	struct page		*reuse_page;
-	unsigned long		reuse_addr;
+	struct page		*vmemmap_head;
+	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
+
 /* Skip the TLB flush when we split the PMD */
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
@@ -140,14 +142,7 @@ static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
 {
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-	/*
-	 * The reuse_page is found 'first' in page table walking before
-	 * starting remapping.
-	 */
-	if (!vmemmap_walk->reuse_page)
-		vmemmap_walk->reuse_page = pte_page(ptep_get(pte));
-	else
-		vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
 	vmemmap_walk->nr_walked++;
 
 	return 0;
@@ -207,18 +202,12 @@ static void free_vmemmap_page_list(struct list_head *list)
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
-	/*
-	 * Remap the tail pages as read-only to catch illegal write operation
-	 * to the tail pages.
-	 */
-	pgprot_t pgprot = PAGE_KERNEL_RO;
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(addr == walk->reuse_addr)) {
-		pgprot = PAGE_KERNEL;
-		list_del(&walk->reuse_page->lru);
+	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+		list_del(&walk->vmemmap_head->lru);
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
@@ -226,53 +215,50 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		 * write.
 		 */
 		smp_wmb();
+
+		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
+	} else {
+		/*
+		 * Remap the tail pages as read-only to catch illegal write
+		 * operation to the tail pages.
+		 */
+		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
 	}
 
-	entry = mk_pte(walk->reuse_page, pgprot);
 	list_add(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
 
-/*
- * How many struct page structs need to be reset. When we reuse the head
- * struct page, the special metadata (e.g. page->flags or page->mapping)
- * cannot copy to the tail struct page structs. The invalid value will be
- * checked in the free_tail_page_prepare(). In order to avoid the message
- * of "corrupted mapping in tail page". We need to reset at least 4 (one
- * head struct page struct and three tail struct page structs) struct page
- * structs.
- */
-#define NR_RESET_STRUCT_PAGE		4
-
-static inline void reset_struct_pages(struct page *start)
-{
-	struct page *from = start + NR_RESET_STRUCT_PAGE;
-
-	BUILD_BUG_ON(NR_RESET_STRUCT_PAGE * 2 > PAGE_SIZE / sizeof(struct page));
-	memcpy(start, from, sizeof(*from) * NR_RESET_STRUCT_PAGE);
-}
-
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
-	pgprot_t pgprot = PAGE_KERNEL;
 	struct page *page;
-	void *to;
-
-	BUG_ON(pte_page(ptep_get(pte)) != walk->reuse_page);
+	struct page *from, *to;
 
 	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
 	list_del(&page->lru);
+
+	/*
+	 * Initialize tail pages in the newly allocated vmemmap page.
+	 *
+	 * There is folio-scope metadata that is encoded in the first few
+	 * tail pages.
+	 *
+	 * Use the value last tail page in the page with the head page
+	 * to initialize the rest of tail pages.
+	 */
+	from = compound_head((struct page *)addr) +
+		PAGE_SIZE / sizeof(struct page) - 1;
 	to = page_to_virt(page);
-	copy_page(to, (void *)walk->reuse_addr);
-	reset_struct_pages(to);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++)
+		*to = *from;
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
 	 * before the set_pte_at() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
 }
 
 /**
@@ -282,33 +268,28 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
  *             to remap.
  * @end:       end address of the vmemmap virtual address range that we want to
  *             remap.
- * @reuse:     reuse address.
- *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end,
-			       unsigned long reuse)
+static int vmemmap_remap_split(unsigned long start, unsigned long end)
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
 		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
 	};
 
-	/* See the comment in the vmemmap_remap_free(). */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
-	return vmemmap_remap_range(reuse, end, &walk);
+	return vmemmap_remap_range(start, end, &walk);
 }
 
 /**
  * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to the page which @reuse is mapped to, then free vmemmap
- *			which the range are mapped to.
+ *			to use @vmemmap_head/tail, then free vmemmap which
+ *			the range are mapped to.
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @reuse:	reuse address.
+ * @vmemmap_head: the page to be installed as first in the vmemmap range
+ * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
  *		responsibility to free pages.
  * @flags:	modifications to vmemmap_remap_walk flags
@@ -316,69 +297,38 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      unsigned long reuse,
+			      struct page *vmemmap_head,
+			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
-		.reuse_addr	= reuse,
+		.vmemmap_head	= vmemmap_head,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
-	int nid = page_to_nid((struct page *)reuse);
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
 
-	/*
-	 * Allocate a new head vmemmap page to avoid breaking a contiguous
-	 * block of struct page memory when freeing it back to page allocator
-	 * in free_vmemmap_page_list(). This will allow the likely contiguous
-	 * struct page backing memory to be kept contiguous and allowing for
-	 * more allocations of hugepages. Fallback to the currently
-	 * mapped head page in case should it fail to allocate.
-	 */
-	walk.reuse_page = alloc_pages_node(nid, gfp_mask, 0);
-	if (walk.reuse_page) {
-		copy_page(page_to_virt(walk.reuse_page),
-			  (void *)walk.reuse_addr);
-		list_add(&walk.reuse_page->lru, vmemmap_pages);
-		memmap_pages_add(1);
-	}
+	ret = vmemmap_remap_range(start, end, &walk);
+	if (!ret || !walk.nr_walked)
+		return ret;
+
+	end = start + walk.nr_walked * PAGE_SIZE;
 
 	/*
-	 * In order to make remapping routine most efficient for the huge pages,
-	 * the routine of vmemmap page table walking has the following rules
-	 * (see more details from the vmemmap_pte_range()):
-	 *
-	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
-	 *   should be continuous.
-	 * - The @reuse address is part of the range [@reuse, @end) that we are
-	 *   walking which is passed to vmemmap_remap_range().
-	 * - The @reuse address is the first in the complete range.
-	 *
-	 * So we need to make sure that @start and @reuse meet the above rules.
+	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
+	 * call which failed.  These are pages which were removed from
+	 * the vmemmap. They will be restored in the following call.
 	 */
-	BUG_ON(start - reuse != PAGE_SIZE);
+	walk = (struct vmemmap_remap_walk) {
+		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_pages	= vmemmap_pages,
+		.flags		= 0,
+	};
 
-	ret = vmemmap_remap_range(reuse, end, &walk);
-	if (ret && walk.nr_walked) {
-		end = reuse + walk.nr_walked * PAGE_SIZE;
-		/*
-		 * vmemmap_pages contains pages from the previous
-		 * vmemmap_remap_range call which failed.  These
-		 * are pages which were removed from the vmemmap.
-		 * They will be restored in the following call.
-		 */
-		walk = (struct vmemmap_remap_walk) {
-			.remap_pte	= vmemmap_restore_pte,
-			.reuse_addr	= reuse,
-			.vmemmap_pages	= vmemmap_pages,
-			.flags		= 0,
-		};
-
-		vmemmap_remap_range(reuse, end, &walk);
-	}
+	vmemmap_remap_range(start, end, &walk);
 
 	return ret;
 }
@@ -415,29 +365,24 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @reuse:	reuse address.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long reuse, unsigned long flags)
+			       unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
-		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
-	/* See the comment in the vmemmap_remap_free(). */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
 	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
 		return -ENOMEM;
 
-	return vmemmap_remap_range(reuse, end, &walk);
+	return vmemmap_remap_range(start, end, &walk);
 }
 
 DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
@@ -450,8 +395,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -462,18 +406,18 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
 		synchronize_rcu();
 
+	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
+
 	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
-	 * the range is mapped to the page which @vmemmap_reuse is mapped to.
+	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
+	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
 	if (!ret) {
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
@@ -561,9 +505,9 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
-	int ret = 0;
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
+	struct page *vmemmap_head, *vmemmap_tail;
+	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -588,18 +532,30 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
+	nid = folio_nid(folio);
+	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
+	if (!vmemmap_head) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	copy_page(page_to_virt(vmemmap_head), folio);
+	list_add(&vmemmap_head->lru, vmemmap_pages);
+	memmap_pages_add(1);
+
+	vmemmap_tail	= vmemmap_head;
+	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
-	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end)
-	 * to the page which @vmemmap_reuse is mapped to.  Add pages previously
-	 * mapping the range to vmemmap_pages list so that they can be freed by
-	 * the caller.
+	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
+	 * Add pages previously mapping the range to vmemmap_pages list so that
+	 * they can be freed by the caller.
 	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
+	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
+				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
+out:
 	if (ret) {
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 		folio_clear_hugetlb_vmemmap_optimized(folio);
@@ -628,21 +584,19 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 
 static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
 {
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
 
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
+	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
 	 * @vmemmap_end]
 	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end, vmemmap_reuse);
+	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
 }
 
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
-- 
2.53.0



