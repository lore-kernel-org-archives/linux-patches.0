Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7683B2FE9;
	Mon, 23 Mar 2026 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278737; cv=none; b=lQonYXku8K5oG5BqR9V58ZBB9uP3ES4udUUexhq2hJR2G16242KHtdusPy8CQ2UVZSbsrkqiCOMg5TKLGw0SDG17sql0E8Y3W7tsO5sZrMPwjKU1C3z6Tt0iTG02cXjoeZ4Nw3QZ1O2oF49RHPedOExRlWdgUJ/BBb7VKkA1vM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278737; c=relaxed/simple;
	bh=5W3KklrOrA6hA8A7mtdchKrpSaHsniPaSYRS1duiz7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXQ+ICaHui7Xg91FUCiGfLp09lPbdLd7eqllqbVRu4N5Ur6JxeBkclC2mm9chyLf7k6G5ncCVyplfj8Af7guJSvG8mYsyRQSZX8r7JyKzB9kbKdcwk3viWkqqLYWAM+kKlv3JCG0vjP8W6fcHa7skeFH+6TVqkVQKhC8GlJ3Inc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWcwAWtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWcwAWtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842D5C4CEF7;
	Mon, 23 Mar 2026 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278736;
	bh=5W3KklrOrA6hA8A7mtdchKrpSaHsniPaSYRS1duiz7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWcwAWtHtn4jGi3e4q5iXZ3Z376cSdIpAWCUfweR7dpstQfsTKgpxGs9DE7/lvBby
	 H0GAaYluct1mLYFFMK6LaQeaw3s6h1hcjqfj5Ve4m2XiBjwHm2YwseJogq9vp0mkjd
	 ORqdV2ox9Cu0AGbIr4+/c6X3RAWdHVkYEgq+dd0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Eric Chanudet <echanude@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 402/567] arm64: mm: Dont remap pgtables per-cont(pte|pmd) block
Date: Mon, 23 Mar 2026 14:45:22 +0100
Message-ID: <20260323134543.812649374@linuxfoundation.org>
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

[ Upstream commit 5c63db59c5f89925add57642be4f789d0d671ccd ]

A large part of the kernel boot time is creating the kernel linear map
page tables. When rodata=full, all memory is mapped by pte. And when
there is lots of physical ram, there are lots of pte tables to populate.
The primary cost associated with this is mapping and unmapping the pte
table memory in the fixmap; at unmap time, the TLB entry must be
invalidated and this is expensive.

Previously, each pmd and pte table was fixmapped/fixunmapped for each
cont(pte|pmd) block of mappings (16 entries with 4K granule). This means
we ended up issuing 32 TLBIs per (pmd|pte) table during the population
phase.

Let's fix that, and fixmap/fixunmap each page once per population, for a
saving of 31 TLBIs per (pmd|pte) table. This gives a significant boot
speedup.

Execution time of map_mem(), which creates the kernel linear map page
tables, was measured on different machines with different RAM configs:

               | Apple M2 VM | Ampere Altra| Ampere Altra| Ampere Altra
               | VM, 16G     | VM, 64G     | VM, 256G    | Metal, 512G
---------------|-------------|-------------|-------------|-------------
               |   ms    (%) |   ms    (%) |   ms    (%) |    ms    (%)
---------------|-------------|-------------|-------------|-------------
before         |  168   (0%) | 2198   (0%) | 8644   (0%) | 17447   (0%)
after          |   78 (-53%) |  435 (-80%) | 1723 (-80%) |  3779 (-78%)

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Tested-by: Eric Chanudet <echanude@redhat.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240412131908.433043-2-ryan.roberts@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Ryan: Trivial backport ]
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -169,12 +169,9 @@ bool pgattr_change_is_safe(u64 old, u64
 	return ((old ^ new) & ~mask) == 0;
 }
 
-static void init_pte(pmd_t *pmdp, unsigned long addr, unsigned long end,
+static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot)
 {
-	pte_t *ptep;
-
-	ptep = pte_set_fixmap_offset(pmdp, addr);
 	do {
 		pte_t old_pte = READ_ONCE(*ptep);
 
@@ -189,8 +186,6 @@ static void init_pte(pmd_t *pmdp, unsign
 
 		phys += PAGE_SIZE;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
-
-	pte_clear_fixmap();
 }
 
 static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
@@ -201,6 +196,7 @@ static void alloc_init_cont_pte(pmd_t *p
 {
 	unsigned long next;
 	pmd_t pmd = READ_ONCE(*pmdp);
+	pte_t *ptep;
 
 	BUG_ON(pmd_sect(pmd));
 	if (pmd_none(pmd)) {
@@ -216,6 +212,7 @@ static void alloc_init_cont_pte(pmd_t *p
 	}
 	BUG_ON(pmd_bad(pmd));
 
+	ptep = pte_set_fixmap_offset(pmdp, addr);
 	do {
 		pgprot_t __prot = prot;
 
@@ -226,20 +223,21 @@ static void alloc_init_cont_pte(pmd_t *p
 		    (flags & NO_CONT_MAPPINGS) == 0)
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
-		init_pte(pmdp, addr, next, phys, __prot);
+		init_pte(ptep, addr, next, phys, __prot);
 
+		ptep += pte_index(next) - pte_index(addr);
 		phys += next - addr;
 	} while (addr = next, addr != end);
+
+	pte_clear_fixmap();
 }
 
-static void init_pmd(pud_t *pudp, unsigned long addr, unsigned long end,
+static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot,
 		     phys_addr_t (*pgtable_alloc)(int), int flags)
 {
 	unsigned long next;
-	pmd_t *pmdp;
 
-	pmdp = pmd_set_fixmap_offset(pudp, addr);
 	do {
 		pmd_t old_pmd = READ_ONCE(*pmdp);
 
@@ -265,8 +263,6 @@ static void init_pmd(pud_t *pudp, unsign
 		}
 		phys += next - addr;
 	} while (pmdp++, addr = next, addr != end);
-
-	pmd_clear_fixmap();
 }
 
 static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
@@ -276,6 +272,7 @@ static void alloc_init_cont_pmd(pud_t *p
 {
 	unsigned long next;
 	pud_t pud = READ_ONCE(*pudp);
+	pmd_t *pmdp;
 
 	/*
 	 * Check for initial section mappings in the pgd/pud.
@@ -294,6 +291,7 @@ static void alloc_init_cont_pmd(pud_t *p
 	}
 	BUG_ON(pud_bad(pud));
 
+	pmdp = pmd_set_fixmap_offset(pudp, addr);
 	do {
 		pgprot_t __prot = prot;
 
@@ -304,10 +302,13 @@ static void alloc_init_cont_pmd(pud_t *p
 		    (flags & NO_CONT_MAPPINGS) == 0)
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
-		init_pmd(pudp, addr, next, phys, __prot, pgtable_alloc, flags);
+		init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
 
+		pmdp += pmd_index(next) - pmd_index(addr);
 		phys += next - addr;
 	} while (addr = next, addr != end);
+
+	pmd_clear_fixmap();
 }
 
 static void alloc_init_pud(pgd_t *pgdp, unsigned long addr, unsigned long end,


