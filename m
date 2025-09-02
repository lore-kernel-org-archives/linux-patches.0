Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B2D30AAB4;
	Tue,  2 Sep 2025 13:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819715; cv=none; b=My4+I5hNA7eqkEFDE/efhvtXZKTxAjQbvB4Y7I1ojzFIe+PFFqVPaivd8Vt3W9WHLWUDJH7szIaMmGQY4mPfMOjddA6upmRDGAYsH466UXP79nyoBc+Qmfdfx5YJST1Wo66HlHej+NE9dY95E/vXLpn0Pk77OT0S/6x3rkiy2fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819715; c=relaxed/simple;
	bh=z4Z2zrhZgWTjZBEL0GUq9TD3bx+N0idBBZer8YLG3p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWRq4bYHSUON6OPHws5jAcuWYU58i6ug3tEbBZOUz7YAMq1vS+3K0fl3hnNbq06h8jltaVIRxzqC36pZzA0ZA2HFHZG89WCCU5QaiQNQRNrAiLYifSNSDMIAeab/nYiLqVamxPjGdqyrOFpPfPtffgkTejPZhWBtcB6P2F2GdGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uoQhokn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uoQhokn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A996C4CEED;
	Tue,  2 Sep 2025 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819714;
	bh=z4Z2zrhZgWTjZBEL0GUq9TD3bx+N0idBBZer8YLG3p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uoQhoknbpj4BAE9sLsXpClZNU2JFui2kxH9t3Hj8kGYwX/lRbEoU4a96tHSY1ngr
	 dtWiRli1iSS//HCIRB4zh5cO0OmfAgLeWlAFNAAdAqYOdoAvPUlnIjQ8mEPfFVZdCA
	 kELCrkBCGVfnuNSAEJflzJNyo5lCammGo8rxVvMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.16 117/142] arm64: mm: Fix CFI failure due to kpti_ng_pgd_alloc function signature
Date: Tue,  2 Sep 2025 15:20:19 +0200
Message-ID: <20250902131952.769259668@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit ceca927c86e6f72f72d45487a34368bc9509431d upstream.

Seen during KPTI initialization:

  CFI failure at create_kpti_ng_temp_pgd+0x124/0xce8 (target: kpti_ng_pgd_alloc+0x0/0x14; expected type: 0xd61b88b6)

The call site is alloc_init_pud() at arch/arm64/mm/mmu.c:

  pud_phys = pgtable_alloc(TABLE_PUD);

alloc_init_pud() has the prototype:

  static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
                             phys_addr_t phys, pgprot_t prot,
                             phys_addr_t (*pgtable_alloc)(enum pgtable_type),
                             int flags)

where the pgtable_alloc() prototype is declared.

The target (kpti_ng_pgd_alloc) is used in arch/arm64/kernel/cpufeature.c:

  create_kpti_ng_temp_pgd(kpti_ng_temp_pgd, __pa(alloc), KPTI_NG_TEMP_VA,
                          PAGE_SIZE, PAGE_KERNEL, kpti_ng_pgd_alloc, 0);

which is an alias for __create_pgd_mapping_locked() with prototype:

  extern __alias(__create_pgd_mapping_locked)
  void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys,
                               unsigned long virt,
                               phys_addr_t size, pgprot_t prot,
                               phys_addr_t (*pgtable_alloc)(enum pgtable_type),
                               int flags);

__create_pgd_mapping_locked() passes the function pointer down:

  __create_pgd_mapping_locked() -> alloc_init_p4d() -> alloc_init_pud()

But the target function (kpti_ng_pgd_alloc) has the wrong signature:

  static phys_addr_t __init kpti_ng_pgd_alloc(int shift);

The "int" should be "enum pgtable_type".

To make "enum pgtable_type" available to cpufeature.c, move
enum pgtable_type definition from arch/arm64/mm/mmu.c to
arch/arm64/include/asm/mmu.h.

Adjust kpti_ng_pgd_alloc to use "enum pgtable_type" instead of "int".
The function behavior remains identical (parameter is unused).

Fixes: c64f46ee1377 ("arm64: mm: use enum to identify pgtable level instead of *_SHIFT")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250829190721.it.373-kees@kernel.org
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mmu.h   |    7 +++++++
 arch/arm64/kernel/cpufeature.c |    5 +++--
 arch/arm64/mm/mmu.c            |    7 -------
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -17,6 +17,13 @@
 #include <linux/refcount.h>
 #include <asm/cpufeature.h>
 
+enum pgtable_type {
+	TABLE_PTE,
+	TABLE_PMD,
+	TABLE_PUD,
+	TABLE_P4D,
+};
+
 typedef struct {
 	atomic64_t	id;
 #ifdef CONFIG_COMPAT
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -84,6 +84,7 @@
 #include <asm/hwcap.h>
 #include <asm/insn.h>
 #include <asm/kvm_host.h>
+#include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/mte.h>
 #include <asm/hypervisor.h>
@@ -1941,11 +1942,11 @@ static bool has_pmuv3(const struct arm64
 extern
 void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
 			     phys_addr_t size, pgprot_t prot,
-			     phys_addr_t (*pgtable_alloc)(int), int flags);
+			     phys_addr_t (*pgtable_alloc)(enum pgtable_type), int flags);
 
 static phys_addr_t __initdata kpti_ng_temp_alloc;
 
-static phys_addr_t __init kpti_ng_pgd_alloc(int shift)
+static phys_addr_t __init kpti_ng_pgd_alloc(enum pgtable_type type)
 {
 	kpti_ng_temp_alloc -= PAGE_SIZE;
 	return kpti_ng_temp_alloc;
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -46,13 +46,6 @@
 #define NO_CONT_MAPPINGS	BIT(1)
 #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
 
-enum pgtable_type {
-	TABLE_PTE,
-	TABLE_PMD,
-	TABLE_PUD,
-	TABLE_P4D,
-};
-
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 


