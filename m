Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ABF3446D2;
	Tue, 16 Dec 2025 12:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887573; cv=none; b=RkN1r7KG7lY1QBLyI/vjtTYx7wK7b9pwZ8XY3v2HTBfR670sqrm+Gtj1KsXV1nlkTbcEM67nCOp0Oiz+eP7+5fAhvSl3Uqmz2nm30Aapl+NZXoO9YwC+K0nOo6B98uVNiQjgYzvx2/wBPD1642yJsftCZFnyZslGzvqfmlHWj+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887573; c=relaxed/simple;
	bh=xC4GDqx1D9ust1KYb94loYrjGF8bqtkdB0WHcsw/7p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD90UiKvcEEx+bhZaxBKdGqAb7fho/MtpR9U2DFzkPdxfu5CvIm/fp4KhbNBSg+T7WwIEDUqjzgMH+Dw4FmtsDmRR2jB4m29y+sFeQ/0UeEwYfe9hXJSUWmRK8JnVUZuBlNa5aKJHu82aP7+8AVYubMZcNy2q9vvxaBoNhKLjfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImXrakAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImXrakAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CFAC4CEF1;
	Tue, 16 Dec 2025 12:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887572;
	bh=xC4GDqx1D9ust1KYb94loYrjGF8bqtkdB0WHcsw/7p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImXrakAWxnJ65+DECFSn4MSA9I8MIvKavjIwoYdowRMgWo9gL46ViCWlLdfTXoTKX
	 rFGn/E/YkRnSw+vQSNEljT5sK839xvCgmF6qUgQlY9sfloZlEeMS/5hDlRrdJtXX4/
	 BbzXGkee2wvMPCCIIi0aKCyLuGt+KpkjXW7AKHJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/614] arm64/mm: Allow __create_pgd_mapping() to propagate pgtable_alloc() errors
Date: Tue, 16 Dec 2025 12:10:37 +0100
Message-ID: <20251216111411.158468347@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>

[ Upstream commit bfc184cb1ba7226b21ab26f0b220581895c5ac9e ]

arch_add_memory() is used to hotplug memory into a system but as a part
of its implementation it calls __create_pgd_mapping(), which uses
pgtable_alloc() in order to build intermediate page tables. As this path
was initally only used during early boot pgtable_alloc() is designed to
BUG_ON() on failure. However, in the event that memory hotplug is
attempted when the system's memory is extremely tight and the allocation
were to fail, it would lead to panicking the system, which is not
desirable. Hence update __create_pgd_mapping and all it's callers to be
non void and propagate -ENOMEM on allocation failure to allow system to
fail gracefully.

But during early boot if there is an allocation failure, we want the
system to panic, hence create a wrapper around __create_pgd_mapping()
called early_create_pgd_mapping() which is designed to panic, if ret
is non zero value. All the init calls are updated to use this wrapper
rather than the modified __create_pgd_mapping() to restore
functionality.

Fixes: 4ab215061554 ("arm64: Add memory hotplug support")
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 214 ++++++++++++++++++++++++++++----------------
 1 file changed, 136 insertions(+), 78 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2ba01dc8ef822..aeb6fb25a951a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -49,6 +49,8 @@
 #define NO_CONT_MAPPINGS	BIT(1)
 #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
 
+#define INVALID_PHYS_ADDR	(-1ULL)
+
 DEFINE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
 
 u64 kimage_voffset __ro_after_init;
@@ -194,11 +196,11 @@ static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
 }
 
-static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
-				unsigned long end, phys_addr_t phys,
-				pgprot_t prot,
-				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
-				int flags)
+static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
+			       unsigned long end, phys_addr_t phys,
+			       pgprot_t prot,
+			       phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+			       int flags)
 {
 	unsigned long next;
 	pmd_t pmd = READ_ONCE(*pmdp);
@@ -213,6 +215,8 @@ static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			pmdval |= PMD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pte_phys = pgtable_alloc(TABLE_PTE);
+		if (pte_phys == INVALID_PHYS_ADDR)
+			return -ENOMEM;
 		ptep = pte_set_fixmap(pte_phys);
 		init_clear_pgtable(ptep);
 		ptep += pte_index(addr);
@@ -244,11 +248,13 @@ static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 	 * walker.
 	 */
 	pte_clear_fixmap();
+
+	return 0;
 }
 
-static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
-		     phys_addr_t phys, pgprot_t prot,
-		     phys_addr_t (*pgtable_alloc)(enum pgtable_type), int flags)
+static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
+		    phys_addr_t phys, pgprot_t prot,
+		    phys_addr_t (*pgtable_alloc)(enum pgtable_type), int flags)
 {
 	unsigned long next;
 
@@ -269,22 +275,29 @@ static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
 						      READ_ONCE(pmd_val(*pmdp))));
 		} else {
-			alloc_init_cont_pte(pmdp, addr, next, phys, prot,
-					    pgtable_alloc, flags);
+			int ret;
+
+			ret = alloc_init_cont_pte(pmdp, addr, next, phys, prot,
+						  pgtable_alloc, flags);
+			if (ret)
+				return ret;
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
 			       pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
 		}
 		phys += next - addr;
 	} while (pmdp++, addr = next, addr != end);
+
+	return 0;
 }
 
-static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
-				unsigned long end, phys_addr_t phys,
-				pgprot_t prot,
-				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
-				int flags)
+static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
+			       unsigned long end, phys_addr_t phys,
+			       pgprot_t prot,
+			       phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+			       int flags)
 {
+	int ret;
 	unsigned long next;
 	pud_t pud = READ_ONCE(*pudp);
 	pmd_t *pmdp;
@@ -301,6 +314,8 @@ static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 			pudval |= PUD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pmd_phys = pgtable_alloc(TABLE_PMD);
+		if (pmd_phys == INVALID_PHYS_ADDR)
+			return -ENOMEM;
 		pmdp = pmd_set_fixmap(pmd_phys);
 		init_clear_pgtable(pmdp);
 		pmdp += pmd_index(addr);
@@ -320,20 +335,26 @@ static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 		    (flags & NO_CONT_MAPPINGS) == 0)
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
-		init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
+		ret = init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
+		if (ret)
+			goto out;
 
 		pmdp += pmd_index(next) - pmd_index(addr);
 		phys += next - addr;
 	} while (addr = next, addr != end);
 
+out:
 	pmd_clear_fixmap();
+
+	return ret;
 }
 
-static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
-			   phys_addr_t phys, pgprot_t prot,
-			   phys_addr_t (*pgtable_alloc)(enum pgtable_type),
-			   int flags)
+static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
+			  phys_addr_t phys, pgprot_t prot,
+			  phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+			  int flags)
 {
+	int ret = 0;
 	unsigned long next;
 	p4d_t p4d = READ_ONCE(*p4dp);
 	pud_t *pudp;
@@ -346,6 +367,8 @@ static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			p4dval |= P4D_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pud_phys = pgtable_alloc(TABLE_PUD);
+		if (pud_phys == INVALID_PHYS_ADDR)
+			return -ENOMEM;
 		pudp = pud_set_fixmap(pud_phys);
 		init_clear_pgtable(pudp);
 		pudp += pud_index(addr);
@@ -375,8 +398,10 @@ static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
 						      READ_ONCE(pud_val(*pudp))));
 		} else {
-			alloc_init_cont_pmd(pudp, addr, next, phys, prot,
-					    pgtable_alloc, flags);
+			ret = alloc_init_cont_pmd(pudp, addr, next, phys, prot,
+						  pgtable_alloc, flags);
+			if (ret)
+				goto out;
 
 			BUG_ON(pud_val(old_pud) != 0 &&
 			       pud_val(old_pud) != READ_ONCE(pud_val(*pudp)));
@@ -384,14 +409,18 @@ static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		phys += next - addr;
 	} while (pudp++, addr = next, addr != end);
 
+out:
 	pud_clear_fixmap();
+
+	return ret;
 }
 
-static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
-			   phys_addr_t phys, pgprot_t prot,
-			   phys_addr_t (*pgtable_alloc)(enum pgtable_type),
-			   int flags)
+static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
+			  phys_addr_t phys, pgprot_t prot,
+			  phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+			  int flags)
 {
+	int ret;
 	unsigned long next;
 	pgd_t pgd = READ_ONCE(*pgdp);
 	p4d_t *p4dp;
@@ -404,6 +433,8 @@ static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			pgdval |= PGD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		p4d_phys = pgtable_alloc(TABLE_P4D);
+		if (p4d_phys == INVALID_PHYS_ADDR)
+			return -ENOMEM;
 		p4dp = p4d_set_fixmap(p4d_phys);
 		init_clear_pgtable(p4dp);
 		p4dp += p4d_index(addr);
@@ -418,8 +449,10 @@ static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 
 		next = p4d_addr_end(addr, end);
 
-		alloc_init_pud(p4dp, addr, next, phys, prot,
-			       pgtable_alloc, flags);
+		ret = alloc_init_pud(p4dp, addr, next, phys, prot,
+				     pgtable_alloc, flags);
+		if (ret)
+			goto out;
 
 		BUG_ON(p4d_val(old_p4d) != 0 &&
 		       p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
@@ -427,15 +460,19 @@ static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 		phys += next - addr;
 	} while (p4dp++, addr = next, addr != end);
 
+out:
 	p4d_clear_fixmap();
+
+	return ret;
 }
 
-static void __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
-					unsigned long virt, phys_addr_t size,
-					pgprot_t prot,
-					phys_addr_t (*pgtable_alloc)(enum pgtable_type),
-					int flags)
+static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
+				       unsigned long virt, phys_addr_t size,
+				       pgprot_t prot,
+				       phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+				       int flags)
 {
+	int ret;
 	unsigned long addr, end, next;
 	pgd_t *pgdp = pgd_offset_pgd(pgdir, virt);
 
@@ -444,7 +481,7 @@ static void __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 	 * within a page, we cannot map the region as the caller expects.
 	 */
 	if (WARN_ON((phys ^ virt) & ~PAGE_MASK))
-		return;
+		return -EINVAL;
 
 	phys &= PAGE_MASK;
 	addr = virt & PAGE_MASK;
@@ -452,25 +489,45 @@ static void __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_p4d(pgdp, addr, next, phys, prot, pgtable_alloc,
-			       flags);
+		ret = alloc_init_p4d(pgdp, addr, next, phys, prot, pgtable_alloc,
+				     flags);
+		if (ret)
+			return ret;
 		phys += next - addr;
 	} while (pgdp++, addr = next, addr != end);
+
+	return 0;
 }
 
-static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
-				 unsigned long virt, phys_addr_t size,
-				 pgprot_t prot,
-				 phys_addr_t (*pgtable_alloc)(enum pgtable_type),
-				 int flags)
+static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
+				unsigned long virt, phys_addr_t size,
+				pgprot_t prot,
+				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+				int flags)
 {
+	int ret;
+
 	mutex_lock(&fixmap_lock);
-	__create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
-				    pgtable_alloc, flags);
+	ret = __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
+					  pgtable_alloc, flags);
 	mutex_unlock(&fixmap_lock);
+
+	return ret;
 }
 
-#define INVALID_PHYS_ADDR	(-1ULL)
+static void early_create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
+				     unsigned long virt, phys_addr_t size,
+				     pgprot_t prot,
+				     phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+				     int flags)
+{
+	int ret;
+
+	ret = __create_pgd_mapping(pgdir, phys, virt, size, prot, pgtable_alloc,
+				   flags);
+	if (ret)
+		panic("Failed to create page tables\n");
+}
 
 static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
 				       enum pgtable_type pgtable_type)
@@ -511,21 +568,13 @@ try_pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type, gfp_t gfp)
 static phys_addr_t __maybe_unused
 pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
 {
-	phys_addr_t pa;
-
-	pa = __pgd_pgtable_alloc(&init_mm, GFP_PGTABLE_KERNEL, pgtable_type);
-	BUG_ON(pa == INVALID_PHYS_ADDR);
-	return pa;
+	return __pgd_pgtable_alloc(&init_mm, GFP_PGTABLE_KERNEL, pgtable_type);
 }
 
 static phys_addr_t
 pgd_pgtable_alloc_special_mm(enum pgtable_type pgtable_type)
 {
-	phys_addr_t pa;
-
-	pa = __pgd_pgtable_alloc(NULL, GFP_PGTABLE_KERNEL, pgtable_type);
-	BUG_ON(pa == INVALID_PHYS_ADDR);
-	return pa;
+	return  __pgd_pgtable_alloc(NULL, GFP_PGTABLE_KERNEL, pgtable_type);
 }
 
 static void split_contpte(pte_t *ptep)
@@ -935,8 +984,8 @@ void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-			     NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
+				 NO_CONT_MAPPINGS);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
@@ -950,8 +999,8 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 	if (page_mappings_only)
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
-	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-			     pgd_pgtable_alloc_special_mm, flags);
+	early_create_pgd_mapping(mm->pgd, phys, virt, size, prot,
+				 pgd_pgtable_alloc_special_mm, flags);
 }
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
@@ -963,8 +1012,8 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-			     NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
+				 NO_CONT_MAPPINGS);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -973,8 +1022,8 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
 				  phys_addr_t end, pgprot_t prot, int flags)
 {
-	__create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
-			     prot, early_pgtable_alloc, flags);
+	early_create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
+				 prot, early_pgtable_alloc, flags);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -1207,6 +1256,8 @@ static int __init __kpti_install_ng_mappings(void *__unused)
 	remap_fn = (void *)__pa_symbol(idmap_kpti_install_ng_mappings);
 
 	if (!cpu) {
+		int ret;
+
 		alloc = __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
 		kpti_ng_temp_pgd = (pgd_t *)(alloc + (levels - 1) * PAGE_SIZE);
 		kpti_ng_temp_alloc = kpti_ng_temp_pgd_pa = __pa(kpti_ng_temp_pgd);
@@ -1227,9 +1278,11 @@ static int __init __kpti_install_ng_mappings(void *__unused)
 		// covers the PTE[] page itself, the remaining entries are free
 		// to be used as a ad-hoc fixmap.
 		//
-		__create_pgd_mapping_locked(kpti_ng_temp_pgd, __pa(alloc),
-					    KPTI_NG_TEMP_VA, PAGE_SIZE, PAGE_KERNEL,
-					    kpti_ng_pgd_alloc, 0);
+		ret = __create_pgd_mapping_locked(kpti_ng_temp_pgd, __pa(alloc),
+						  KPTI_NG_TEMP_VA, PAGE_SIZE, PAGE_KERNEL,
+						  kpti_ng_pgd_alloc, 0);
+		if (ret)
+			panic("Failed to create page tables\n");
 	}
 
 	cpu_install_idmap();
@@ -1282,9 +1335,9 @@ static int __init map_entry_trampoline(void)
 
 	/* Map only the text into the trampoline page table */
 	memset(tramp_pg_dir, 0, PGD_SIZE);
-	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
-			     entry_tramp_text_size(), prot,
-			     pgd_pgtable_alloc_init_mm, NO_BLOCK_MAPPINGS);
+	early_create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
+				 entry_tramp_text_size(), prot,
+				 pgd_pgtable_alloc_init_mm, NO_BLOCK_MAPPINGS);
 
 	/* Map both the text and data into the kernel page table */
 	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
@@ -1926,23 +1979,28 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	if (force_pte_mapping())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
-	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
-			     size, params->pgprot, pgd_pgtable_alloc_init_mm,
-			     flags);
+	ret = __create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
+				   size, params->pgprot, pgd_pgtable_alloc_init_mm,
+				   flags);
+	if (ret)
+		goto err;
 
 	memblock_clear_nomap(start, size);
 
 	ret = __add_pages(nid, start >> PAGE_SHIFT, size >> PAGE_SHIFT,
 			   params);
 	if (ret)
-		__remove_pgd_mapping(swapper_pg_dir,
-				     __phys_to_virt(start), size);
-	else {
-		/* Address of hotplugged memory can be smaller */
-		max_pfn = max(max_pfn, PFN_UP(start + size));
-		max_low_pfn = max_pfn;
-	}
+		goto err;
+
+	/* Address of hotplugged memory can be smaller */
+	max_pfn = max(max_pfn, PFN_UP(start + size));
+	max_low_pfn = max_pfn;
+
+	return 0;
 
+err:
+	__remove_pgd_mapping(swapper_pg_dir,
+			     __phys_to_virt(start), size);
 	return ret;
 }
 
-- 
2.51.0



