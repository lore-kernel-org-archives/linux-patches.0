Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35494242D70;
	Mon, 23 Mar 2026 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278743; cv=none; b=tYJQtfttR5Hr0Rh6KLv3hMUdn36x8ncUGN5rTgFGVEUKDmXMIc1fQxlzPKHcaOQZ9PreDT5eC7uWZhkylagx+h4Kv6ksj55Qnax0c38GKqVZwiluOAV8WTHdFhcQBWDaOi7AEt0ptwSACL60V86AEC32UxQOexBpxATo82yykuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278743; c=relaxed/simple;
	bh=erVJntiwZLNctjGOVQ8ljM1F6bTFjCti0Ig1cLHQBEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoK3UeCyTLRrmgEQQSQCayKO+c5K+tIoo78Cs1eb/JIcBfe0c1bh/78/qPmoZoGvWIUksih/FogRsMKYhY6TJUBsZv7YFJK3dOudBKOWEbMgPHSk2HCwAJzWHx5bLz26QI86sbmfHOkVptdH6Wm+mYSr4jlMEZb0OIbDhzbzg6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0I5Ubxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0I5Ubxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22C7C4CEF7;
	Mon, 23 Mar 2026 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278743;
	bh=erVJntiwZLNctjGOVQ8ljM1F6bTFjCti0Ig1cLHQBEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0I5UbxwlH4LyO/gmdLwbLJLHoq4r0yUWby5F8HDOHwJwpswzIzRi8SsusphehYi1
	 1CTdCSQZ8fNXjAi7fiF0xKA8zAYOEFX5HQzgwmF7aeEc0w4iY9fsI03glDwQo/mWhY
	 2fP7+vyN7yOyX9DR8vMnljqSM967LRClDCNyP50g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Eric Chanudet <echanude@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 404/567] arm64: mm: Dont remap pgtables for allocate vs populate
Date: Mon, 23 Mar 2026 14:45:24 +0100
Message-ID: <20260323134543.866808148@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 0e9df1c905d8293d333ace86c13d147382f5caf9 ]

During linear map pgtable creation, each pgtable is fixmapped /
fixunmapped twice; once during allocation to zero the memory, and a
again during population to write the entries. This means each table has
2 TLB invalidations issued against it. Let's fix this so that each table
is only fixmapped/fixunmapped once, halving the number of TLBIs, and
improving performance.

Achieve this by separating allocation and initialization (zeroing) of
the page. The allocated page is now fixmapped directly by the walker and
initialized, before being populated and finally fixunmapped.

This approach keeps the change small, but has the side effect that late
allocations (using __get_free_page()) must also go through the generic
memory clearing routine. So let's tell __get_free_page() not to zero the
memory to avoid duplication.

Additionally this approach means that fixmap/fixunmap is still used for
late pgtable modifications. That's not technically needed since the
memory is all mapped in the linear map by that point. That's left as a
possible future optimization if found to be needed.

Execution time of map_mem(), which creates the kernel linear map page
tables, was measured on different machines with different RAM configs:

               | Apple M2 VM | Ampere Altra| Ampere Altra| Ampere Altra
               | VM, 16G     | VM, 64G     | VM, 256G    | Metal, 512G
---------------|-------------|-------------|-------------|-------------
               |   ms    (%) |   ms    (%) |   ms    (%) |    ms    (%)
---------------|-------------|-------------|-------------|-------------
before         |   11   (0%) |  161   (0%) |  656   (0%) |  1654   (0%)
after          |   10 (-11%) |  104 (-35%) |  438 (-33%) |  1223 (-26%)

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Tested-by: Eric Chanudet <echanude@redhat.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240412131908.433043-4-ryan.roberts@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Ryan: Trivial backport ]
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |   58 ++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -106,28 +106,12 @@ EXPORT_SYMBOL(phys_mem_access_prot);
 static phys_addr_t __init early_pgtable_alloc(int shift)
 {
 	phys_addr_t phys;
-	void *ptr;
 
 	phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
 					 MEMBLOCK_ALLOC_NOLEAKTRACE);
 	if (!phys)
 		panic("Failed to allocate page table page\n");
 
-	/*
-	 * The FIX_{PGD,PUD,PMD} slots may be in active use, but the FIX_PTE
-	 * slot will be free, so we can (ab)use the FIX_PTE slot to initialise
-	 * any level of table.
-	 */
-	ptr = pte_set_fixmap(phys);
-
-	memset(ptr, 0, PAGE_SIZE);
-
-	/*
-	 * Implicit barriers also ensure the zeroed page is visible to the page
-	 * table walker
-	 */
-	pte_clear_fixmap();
-
 	return phys;
 }
 
@@ -169,6 +153,14 @@ bool pgattr_change_is_safe(u64 old, u64
 	return ((old ^ new) & ~mask) == 0;
 }
 
+static void init_clear_pgtable(void *table)
+{
+	clear_page(table);
+
+	/* Ensure the zeroing is observed by page table walks. */
+	dsb(ishst);
+}
+
 static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot)
 {
@@ -211,12 +203,15 @@ static void alloc_init_cont_pte(pmd_t *p
 			pmdval |= PMD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pte_phys = pgtable_alloc(PAGE_SHIFT);
+		ptep = pte_set_fixmap(pte_phys);
+		init_clear_pgtable(ptep);
+		ptep += pte_index(addr);
 		__pmd_populate(pmdp, pte_phys, pmdval);
-		pmd = READ_ONCE(*pmdp);
+	} else {
+		BUG_ON(pmd_bad(pmd));
+		ptep = pte_set_fixmap_offset(pmdp, addr);
 	}
-	BUG_ON(pmd_bad(pmd));
 
-	ptep = pte_set_fixmap_offset(pmdp, addr);
 	do {
 		pgprot_t __prot = prot;
 
@@ -295,12 +290,15 @@ static void alloc_init_cont_pmd(pud_t *p
 			pudval |= PUD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pmd_phys = pgtable_alloc(PMD_SHIFT);
+		pmdp = pmd_set_fixmap(pmd_phys);
+		init_clear_pgtable(pmdp);
+		pmdp += pmd_index(addr);
 		__pud_populate(pudp, pmd_phys, pudval);
-		pud = READ_ONCE(*pudp);
+	} else {
+		BUG_ON(pud_bad(pud));
+		pmdp = pmd_set_fixmap_offset(pudp, addr);
 	}
-	BUG_ON(pud_bad(pud));
 
-	pmdp = pmd_set_fixmap_offset(pudp, addr);
 	do {
 		pgprot_t __prot = prot;
 
@@ -338,12 +336,15 @@ static void alloc_init_pud(pgd_t *pgdp,
 			p4dval |= P4D_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pud_phys = pgtable_alloc(PUD_SHIFT);
+		pudp = pud_set_fixmap(pud_phys);
+		init_clear_pgtable(pudp);
+		pudp += pud_index(addr);
 		__p4d_populate(p4dp, pud_phys, p4dval);
-		p4d = READ_ONCE(*p4dp);
+	} else {
+		BUG_ON(p4d_bad(p4d));
+		pudp = pud_set_fixmap_offset(p4dp, addr);
 	}
-	BUG_ON(p4d_bad(p4d));
 
-	pudp = pud_set_fixmap_offset(p4dp, addr);
 	do {
 		pud_t old_pud = READ_ONCE(*pudp);
 
@@ -425,11 +426,10 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdi
 
 static phys_addr_t __pgd_pgtable_alloc(int shift)
 {
-	void *ptr = (void *)__get_free_page(GFP_PGTABLE_KERNEL);
-	BUG_ON(!ptr);
+	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
+	void *ptr = (void *)__get_free_page(GFP_PGTABLE_KERNEL & ~__GFP_ZERO);
 
-	/* Ensure the zeroed page is visible to the page table walker */
-	dsb(ishst);
+	BUG_ON(!ptr);
 	return __pa(ptr);
 }
 


