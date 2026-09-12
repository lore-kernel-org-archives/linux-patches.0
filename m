Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609E1378D70;
	Sat, 12 Sep 2026 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219609; cv=none; b=JWO2v0bFlcLhVWgN2hiCec5qJrT0GjxL7bLZY0RuSgUPAsl7tf0jjBZ2aZVu7PpD7Ej8hgG/0RWTxJBT25437Z9tSXCVbHYjVc5uohNrtoDU45q54A4sL+KXoiOQ0QFG97mVjlOxDGcDV/yzWa+9A4fdzYiTLoykI72wEvNw7ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219609; c=relaxed/simple;
	bh=K4MvyMIKlRYeROCNJktRa5PXAf8FqLs/pUR96vtlcXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfrgOXtxsIiOBN4i/TFy01DmsTC9lCG+hkmnUeK3BHITmNB/tlhWtybYidd334YwcON8OgbdRCPFZe7F0ikPJ+bxabSSFDB5nms4tfzXQlSmEHxh3yrQ9YZqwhebItK6txCZXWBMLspQ4c6BDZj0Qf/hil7CQJd0j8xRFsDcNRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMHJMDo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMHJMDo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2471F00893;
	Sat, 12 Sep 2026 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219608;
	bh=ztueiZewScT0P9+DYpc/XdnlQ2J9nt2Tnep8NnzJRtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMHJMDo/JXnxCEh16LI9DiIn4CU/5ESPhmS4xJnSVWeRr6iusK2atDTBIkANSDJnC
	 JuOpDgGwLdiuZTOuIO+6wBKX6FqGYLNrTBYCABEN72JmTRGQHxo3+RhPg4Pk/Fwoe2
	 V3eqRh3sFDy+E2kFZU+EcxZswItiAZNzjYHrW030=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0001/1424] Revert "arm64: mm: Dont remap pgtables for allocate vs populate"
Date: Sat, 12 Sep 2026 08:40:33 +0200
Message-ID: <20260912065607.318772104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

This reverts commit 54322d95309d9aa4cb77b34ee4b6c8b541f3e21f.

The 6.6.y backport removes the clearing performed by
early_pgtable_alloc(). Its replacement clears allocations made by the
generic page-table walkers, but 6.6's create_idmap() still allocates an
extra root level directly when a sub-48-bit VA kernel is loaded
sufficiently high in physical memory.

memblock_phys_alloc_range() does not zero the returned memory. The direct
caller can therefore publish an uncleared root page. A stale entry can
trip the bad-descriptor BUG_ON or be followed as a page-table descriptor,
preventing the kernel from booting.

Mainline is not affected because commit e6128a8e523c ("arm64: mm: Use
48-bit virtual addressing for the permanent ID map") removed the dynamic
extra level before commit 0e9df1c905d8 ("arm64: mm: Don't remap pgtables
for allocate vs populate") moved page-table initialization out of the
allocator.

Revert the optimization in 6.6.y to restore allocation-time clearing for
all callers.

Fixes: 54322d95309d ("arm64: mm: Don't remap pgtables for allocate vs populate")
Link: https://lore.kernel.org/r/2026083151-mascot-unshaken-5f46@gregkh
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 58 ++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e075792d72257..c49cf99161881 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -106,12 +106,28 @@ EXPORT_SYMBOL(phys_mem_access_prot);
 static phys_addr_t __init early_pgtable_alloc(int shift)
 {
 	phys_addr_t phys;
+	void *ptr;
 
 	phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
 					 MEMBLOCK_ALLOC_NOLEAKTRACE);
 	if (!phys)
 		panic("Failed to allocate page table page\n");
 
+	/*
+	 * The FIX_{PGD,PUD,PMD} slots may be in active use, but the FIX_PTE
+	 * slot will be free, so we can (ab)use the FIX_PTE slot to initialise
+	 * any level of table.
+	 */
+	ptr = pte_set_fixmap(phys);
+
+	memset(ptr, 0, PAGE_SIZE);
+
+	/*
+	 * Implicit barriers also ensure the zeroed page is visible to the page
+	 * table walker
+	 */
+	pte_clear_fixmap();
+
 	return phys;
 }
 
@@ -153,14 +169,6 @@ bool pgattr_change_is_safe(u64 old, u64 new)
 	return ((old ^ new) & ~mask) == 0;
 }
 
-static void init_clear_pgtable(void *table)
-{
-	clear_page(table);
-
-	/* Ensure the zeroing is observed by page table walks. */
-	dsb(ishst);
-}
-
 static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot)
 {
@@ -203,15 +211,12 @@ static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			pmdval |= PMD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pte_phys = pgtable_alloc(PAGE_SHIFT);
-		ptep = pte_set_fixmap(pte_phys);
-		init_clear_pgtable(ptep);
-		ptep += pte_index(addr);
 		__pmd_populate(pmdp, pte_phys, pmdval);
-	} else {
-		BUG_ON(pmd_bad(pmd));
-		ptep = pte_set_fixmap_offset(pmdp, addr);
+		pmd = READ_ONCE(*pmdp);
 	}
+	BUG_ON(pmd_bad(pmd));
 
+	ptep = pte_set_fixmap_offset(pmdp, addr);
 	do {
 		pgprot_t __prot = prot;
 
@@ -290,15 +295,12 @@ static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 			pudval |= PUD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pmd_phys = pgtable_alloc(PMD_SHIFT);
-		pmdp = pmd_set_fixmap(pmd_phys);
-		init_clear_pgtable(pmdp);
-		pmdp += pmd_index(addr);
 		__pud_populate(pudp, pmd_phys, pudval);
-	} else {
-		BUG_ON(pud_bad(pud));
-		pmdp = pmd_set_fixmap_offset(pudp, addr);
+		pud = READ_ONCE(*pudp);
 	}
+	BUG_ON(pud_bad(pud));
 
+	pmdp = pmd_set_fixmap_offset(pudp, addr);
 	do {
 		pgprot_t __prot = prot;
 
@@ -336,15 +338,12 @@ static void alloc_init_pud(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			p4dval |= P4D_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pud_phys = pgtable_alloc(PUD_SHIFT);
-		pudp = pud_set_fixmap(pud_phys);
-		init_clear_pgtable(pudp);
-		pudp += pud_index(addr);
 		__p4d_populate(p4dp, pud_phys, p4dval);
-	} else {
-		BUG_ON(p4d_bad(p4d));
-		pudp = pud_set_fixmap_offset(p4dp, addr);
+		p4d = READ_ONCE(*p4dp);
 	}
+	BUG_ON(p4d_bad(p4d));
 
+	pudp = pud_set_fixmap_offset(p4dp, addr);
 	do {
 		pud_t old_pud = READ_ONCE(*pudp);
 
@@ -426,10 +425,11 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
 
 static phys_addr_t __pgd_pgtable_alloc(int shift)
 {
-	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
-	void *ptr = (void *)__get_free_page(GFP_PGTABLE_KERNEL & ~__GFP_ZERO);
-
+	void *ptr = (void *)__get_free_page(GFP_PGTABLE_KERNEL);
 	BUG_ON(!ptr);
+
+	/* Ensure the zeroed page is visible to the page table walker */
+	dsb(ishst);
 	return __pa(ptr);
 }
 
-- 
2.53.0



