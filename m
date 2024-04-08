Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B0C7C6C9;
	Mon,  8 Apr 2024 13:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584162; cv=none; b=H3uDOVqCA11T//jGmH9eeUnKV2SORaXpB2wRmE5dg6WuSE2n2JXYVr5bplIq2L/5+NRT9VOS1vVRXn1BvqSo3yttwA7QGYo/Bqdt/P/IZS2g3axoWTUhkYPqUh4HEKGxx4Zj1zina+3Z62V9dGRlm/V3gWM0V/WvBYRUUVqPWLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584162; c=relaxed/simple;
	bh=Y5hxG/r0fdHL3pu8YvUSx4D5C1qRxpwU3oJhZYgSamg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5lSTDPaEEuaNGsIzpozoagmYrDHw60YZS1DvHJZpz0xJ7jFvwZDT37AH/6YOHHxgSnTsYFTU7+bBXBddZIneCATmSnk1DzW+kVrvhlQXDCBR285r+WHX+f5TMYpaM87bINUNPsIWgHQyE3+2a4qJxyQIgYH2T/Jl6rBWbbyvXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thSMPd5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thSMPd5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2381AC433C7;
	Mon,  8 Apr 2024 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584162;
	bh=Y5hxG/r0fdHL3pu8YvUSx4D5C1qRxpwU3oJhZYgSamg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thSMPd5EJX7SMiRQ+5WqvMLVZ4RfYNGzlN8x9wom1LlWU2OdWnWqdxxGD9nvbUVss
	 X6cTLIyEH68kOIRp4/qhOINEu0e/htZGaQ/N+djYNc9MttsiKK4jR9Mw1WRMJKkD+6
	 WpW+i9WyRLRiXICxUEz/zaoiAw0FpblMgKnW6Qrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption handling into .head.text
Date: Mon,  8 Apr 2024 14:59:06 +0200
Message-ID: <20240408125317.917032769@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 48204aba801f1b512b3abed10b8e1a63e03f3dd1 upstream.

The .head.text section is the initial primary entrypoint of the core
kernel, and is entered with the CPU executing from a 1:1 mapping of
memory. Such code must never access global variables using absolute
references, as these are based on the kernel virtual mapping which is
not active yet at this point.

Given that the SME startup code is also called from this early execution
context, move it into .head.text as well. This will allow more thorough
build time checks in the future to ensure that early startup code only
uses RIP-relative references to global variables.

Also replace some occurrences of __pa_symbol() [which relies on the
compiler generating an absolute reference, which is not guaranteed] and
an open coded RIP-relative access with RIP_REL_REF().

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240227151907.387873-18-ardb+git@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/mem_encrypt.h |    8 +++----
 arch/x86/mm/mem_encrypt_identity.c |   42 ++++++++++++++-----------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -47,8 +47,8 @@ void __init sme_unmap_bootdata(char *rea
 
 void __init sme_early_init(void);
 
-void __init sme_encrypt_kernel(struct boot_params *bp);
-void __init sme_enable(struct boot_params *bp);
+void sme_encrypt_kernel(struct boot_params *bp);
+void sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
@@ -81,8 +81,8 @@ static inline void __init sme_unmap_boot
 
 static inline void __init sme_early_init(void) { }
 
-static inline void __init sme_encrypt_kernel(struct boot_params *bp) { }
-static inline void __init sme_enable(struct boot_params *bp) { }
+static inline void sme_encrypt_kernel(struct boot_params *bp) { }
+static inline void sme_enable(struct boot_params *bp) { }
 
 static inline void sev_es_init_vc_handling(void) { }
 
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -41,6 +41,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/cc_platform.h>
 
+#include <asm/init.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/coco.h>
@@ -94,7 +95,7 @@ struct sme_populate_pgd_data {
  */
 static char sme_workarea[2 * PMD_SIZE] __section(".init.scratch");
 
-static void __init sme_clear_pgd(struct sme_populate_pgd_data *ppd)
+static void __head sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 {
 	unsigned long pgd_start, pgd_end, pgd_size;
 	pgd_t *pgd_p;
@@ -109,7 +110,7 @@ static void __init sme_clear_pgd(struct
 	memset(pgd_p, 0, pgd_size);
 }
 
-static pud_t __init *sme_prepare_pgd(struct sme_populate_pgd_data *ppd)
+static pud_t __head *sme_prepare_pgd(struct sme_populate_pgd_data *ppd)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -146,7 +147,7 @@ static pud_t __init *sme_prepare_pgd(str
 	return pud;
 }
 
-static void __init sme_populate_pgd_large(struct sme_populate_pgd_data *ppd)
+static void __head sme_populate_pgd_large(struct sme_populate_pgd_data *ppd)
 {
 	pud_t *pud;
 	pmd_t *pmd;
@@ -162,7 +163,7 @@ static void __init sme_populate_pgd_larg
 	set_pmd(pmd, __pmd(ppd->paddr | ppd->pmd_flags));
 }
 
-static void __init sme_populate_pgd(struct sme_populate_pgd_data *ppd)
+static void __head sme_populate_pgd(struct sme_populate_pgd_data *ppd)
 {
 	pud_t *pud;
 	pmd_t *pmd;
@@ -188,7 +189,7 @@ static void __init sme_populate_pgd(stru
 		set_pte(pte, __pte(ppd->paddr | ppd->pte_flags));
 }
 
-static void __init __sme_map_range_pmd(struct sme_populate_pgd_data *ppd)
+static void __head __sme_map_range_pmd(struct sme_populate_pgd_data *ppd)
 {
 	while (ppd->vaddr < ppd->vaddr_end) {
 		sme_populate_pgd_large(ppd);
@@ -198,7 +199,7 @@ static void __init __sme_map_range_pmd(s
 	}
 }
 
-static void __init __sme_map_range_pte(struct sme_populate_pgd_data *ppd)
+static void __head __sme_map_range_pte(struct sme_populate_pgd_data *ppd)
 {
 	while (ppd->vaddr < ppd->vaddr_end) {
 		sme_populate_pgd(ppd);
@@ -208,7 +209,7 @@ static void __init __sme_map_range_pte(s
 	}
 }
 
-static void __init __sme_map_range(struct sme_populate_pgd_data *ppd,
+static void __head __sme_map_range(struct sme_populate_pgd_data *ppd,
 				   pmdval_t pmd_flags, pteval_t pte_flags)
 {
 	unsigned long vaddr_end;
@@ -232,22 +233,22 @@ static void __init __sme_map_range(struc
 	__sme_map_range_pte(ppd);
 }
 
-static void __init sme_map_range_encrypted(struct sme_populate_pgd_data *ppd)
+static void __head sme_map_range_encrypted(struct sme_populate_pgd_data *ppd)
 {
 	__sme_map_range(ppd, PMD_FLAGS_ENC, PTE_FLAGS_ENC);
 }
 
-static void __init sme_map_range_decrypted(struct sme_populate_pgd_data *ppd)
+static void __head sme_map_range_decrypted(struct sme_populate_pgd_data *ppd)
 {
 	__sme_map_range(ppd, PMD_FLAGS_DEC, PTE_FLAGS_DEC);
 }
 
-static void __init sme_map_range_decrypted_wp(struct sme_populate_pgd_data *ppd)
+static void __head sme_map_range_decrypted_wp(struct sme_populate_pgd_data *ppd)
 {
 	__sme_map_range(ppd, PMD_FLAGS_DEC_WP, PTE_FLAGS_DEC_WP);
 }
 
-static unsigned long __init sme_pgtable_calc(unsigned long len)
+static unsigned long __head sme_pgtable_calc(unsigned long len)
 {
 	unsigned long entries = 0, tables = 0;
 
@@ -284,7 +285,7 @@ static unsigned long __init sme_pgtable_
 	return entries + tables;
 }
 
-void __init sme_encrypt_kernel(struct boot_params *bp)
+void __head sme_encrypt_kernel(struct boot_params *bp)
 {
 	unsigned long workarea_start, workarea_end, workarea_len;
 	unsigned long execute_start, execute_end, execute_len;
@@ -319,9 +320,8 @@ void __init sme_encrypt_kernel(struct bo
 	 *     memory from being cached.
 	 */
 
-	/* Physical addresses gives us the identity mapped virtual addresses */
-	kernel_start = __pa_symbol(_text);
-	kernel_end = ALIGN(__pa_symbol(_end), PMD_SIZE);
+	kernel_start = (unsigned long)RIP_REL_REF(_text);
+	kernel_end = ALIGN((unsigned long)RIP_REL_REF(_end), PMD_SIZE);
 	kernel_len = kernel_end - kernel_start;
 
 	initrd_start = 0;
@@ -339,14 +339,6 @@ void __init sme_encrypt_kernel(struct bo
 #endif
 
 	/*
-	 * We're running identity mapped, so we must obtain the address to the
-	 * SME encryption workarea using rip-relative addressing.
-	 */
-	asm ("lea sme_workarea(%%rip), %0"
-	     : "=r" (workarea_start)
-	     : "p" (sme_workarea));
-
-	/*
 	 * Calculate required number of workarea bytes needed:
 	 *   executable encryption area size:
 	 *     stack page (PAGE_SIZE)
@@ -355,7 +347,7 @@ void __init sme_encrypt_kernel(struct bo
 	 *   pagetable structures for the encryption of the kernel
 	 *   pagetable structures for workarea (in case not currently mapped)
 	 */
-	execute_start = workarea_start;
+	execute_start = workarea_start = (unsigned long)RIP_REL_REF(sme_workarea);
 	execute_end = execute_start + (PAGE_SIZE * 2) + PMD_SIZE;
 	execute_len = execute_end - execute_start;
 
@@ -498,7 +490,7 @@ void __init sme_encrypt_kernel(struct bo
 	native_write_cr3(__native_read_cr3());
 }
 
-void __init sme_enable(struct boot_params *bp)
+void __head sme_enable(struct boot_params *bp)
 {
 	unsigned int eax, ebx, ecx, edx;
 	unsigned long feature_mask;


