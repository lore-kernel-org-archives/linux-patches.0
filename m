Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC64247A64;
	Mon,  1 Apr 2024 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991254; cv=none; b=R0T5zOd6ObWtNK+hNzwsLtc8Bb+pIxHULuWOoOFoKJBwqIxzjpzCxpJWxs8+rbomSbKWyrKFtg6YrSzem2apSdl33PLcZ/49LfF214hhVj14XoGYA5U9E1wccNrJuGr5httjg8V9le9fWBdWpihgaIy2dXZC/7mXKAlh115NLmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991254; c=relaxed/simple;
	bh=qrD1bxIptSI8MOLpF0yaa0hs7IR5nOuFST0trEE4ihA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bel88N9EuT4GN/dMg2wIoHZYS2mZvaLUTv4P1uF4olqGP8bZi5hI+evDBBna56aahIWJDva5cZ+n3ldytXXU0qSMMTxbPm37TEcGD79WNKtdgqcNHeydwfohdRPEPyl44InDISifiWGDX37Bk87YqZscP0q6s8JHfzY8Tni/q10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk5yEaev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk5yEaev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95EAC433F1;
	Mon,  1 Apr 2024 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991254;
	bh=qrD1bxIptSI8MOLpF0yaa0hs7IR5nOuFST0trEE4ihA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wk5yEaevV+RlaJYXViutm9GshSsnY3qX54rPFFDWRJHQbT9Eqnc0u2MtmJPE+rCNg
	 OmligDUAD4wp2QZ6eVQYv3s42oR02KIPSpvbbssgkyRfY7lIoBryfYgd8KWoZRYZL/
	 uOpyJRoDC6X+vMAupzzUI9vLlvje0pABvLnKZWgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Loughlin <kevinloughlin@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.1 208/272] x86/sev: Fix position dependent variable references in startup code
Date: Mon,  1 Apr 2024 17:46:38 +0200
Message-ID: <20240401152537.406421520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 1c811d403afd73f04bde82b83b24c754011bd0e8 upstream.

The early startup code executes from a 1:1 mapping of memory, which
differs from the mapping that the code was linked and/or relocated to
run at. The latter mapping is not active yet at this point, and so
symbol references that rely on it will fault.

Given that the core kernel is built without -fPIC, symbol references are
typically emitted as absolute, and so any such references occuring in
the early startup code will therefore crash the kernel.

While an attempt was made to work around this for the early SEV/SME
startup code, by forcing RIP-relative addressing for certain global
SEV/SME variables via inline assembly (see snp_cpuid_get_table() for
example), RIP-relative addressing must be pervasively enforced for
SEV/SME global variables when accessed prior to page table fixups.

__startup_64() already handles this issue for select non-SEV/SME global
variables using fixup_pointer(), which adjusts the pointer relative to a
`physaddr` argument. To avoid having to pass around this `physaddr`
argument across all functions needing to apply pointer fixups, introduce
a macro RIP_RELATIVE_REF() which generates a RIP-relative reference to
a given global variable. It is used where necessary to force
RIP-relative accesses to global variables.

For backporting purposes, this patch makes no attempt at cleaning up
other occurrences of this pattern, involving either inline asm or
fixup_pointer(). Those will be addressed later.

  [ bp: Call it "rip_rel_ref" everywhere like other code shortens
    "rIP-relative reference" and make the asm wrapper __always_inline. ]

Co-developed-by: Kevin Loughlin <kevinloughlin@google.com>
Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/all/20240130220845.1978329-1-kevinloughlin@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/core.c               |    7 +------
 arch/x86/include/asm/asm.h         |   14 ++++++++++++++
 arch/x86/include/asm/coco.h        |    8 +++++++-
 arch/x86/include/asm/mem_encrypt.h |   15 +++++++++------
 arch/x86/kernel/sev-shared.c       |   12 ++++++------
 arch/x86/kernel/sev.c              |    4 ++--
 arch/x86/mm/mem_encrypt_identity.c |   27 ++++++++++++---------------
 7 files changed, 51 insertions(+), 36 deletions(-)

--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -14,7 +14,7 @@
 #include <asm/processor.h>
 
 enum cc_vendor cc_vendor __ro_after_init = CC_VENDOR_NONE;
-static u64 cc_mask __ro_after_init;
+u64 cc_mask __ro_after_init;
 
 static bool intel_cc_platform_has(enum cc_attr attr)
 {
@@ -128,8 +128,3 @@ u64 cc_mkdec(u64 val)
 	}
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
-
-__init void cc_set_mask(u64 mask)
-{
-	cc_mask = mask;
-}
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -113,6 +113,20 @@
 
 #endif
 
+#ifndef __ASSEMBLY__
+#ifndef __pic__
+static __always_inline __pure void *rip_rel_ptr(void *p)
+{
+	asm("leaq %c1(%%rip), %0" : "=r"(p) : "i"(p));
+
+	return p;
+}
+#define RIP_REL_REF(var)	(*(typeof(&(var)))rip_rel_ptr(&(var)))
+#else
+#define RIP_REL_REF(var)	(var)
+#endif
+#endif
+
 /*
  * Macros to generate condition code outputs from inline assembly,
  * The output operand must be type "bool".
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_COCO_H
 #define _ASM_X86_COCO_H
 
+#include <asm/asm.h>
 #include <asm/types.h>
 
 enum cc_vendor {
@@ -12,9 +13,14 @@ enum cc_vendor {
 };
 
 extern enum cc_vendor cc_vendor;
+extern u64 cc_mask;
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
-void cc_set_mask(u64 mask);
+static inline void cc_set_mask(u64 mask)
+{
+	RIP_REL_REF(cc_mask) = mask;
+}
+
 u64 cc_mkenc(u64 val);
 u64 cc_mkdec(u64 val);
 #else
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -15,7 +15,8 @@
 #include <linux/init.h>
 #include <linux/cc_platform.h>
 
-#include <asm/bootparam.h>
+#include <asm/asm.h>
+struct boot_params;
 
 #ifdef CONFIG_X86_MEM_ENCRYPT
 void __init mem_encrypt_init(void);
@@ -57,6 +58,11 @@ void __init mem_encrypt_free_decrypted_m
 
 void __init sev_es_init_vc_handling(void);
 
+static inline u64 sme_get_me_mask(void)
+{
+	return RIP_REL_REF(sme_me_mask);
+}
+
 #define __bss_decrypted __section(".bss..decrypted")
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
@@ -88,6 +94,8 @@ early_set_mem_enc_dec_hypercall(unsigned
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
+static inline u64 sme_get_me_mask(void) { return 0; }
+
 #define __bss_decrypted
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
@@ -105,11 +113,6 @@ void add_encrypt_protection_map(void);
 
 extern char __start_bss_decrypted[], __end_bss_decrypted[], __start_bss_decrypted_unused[];
 
-static inline u64 sme_get_me_mask(void)
-{
-	return sme_me_mask;
-}
-
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __X86_MEM_ENCRYPT_H__ */
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -553,9 +553,9 @@ static int snp_cpuid(struct ghcb *ghcb,
 		leaf->eax = leaf->ebx = leaf->ecx = leaf->edx = 0;
 
 		/* Skip post-processing for out-of-range zero leafs. */
-		if (!(leaf->fn <= cpuid_std_range_max ||
-		      (leaf->fn >= 0x40000000 && leaf->fn <= cpuid_hyp_range_max) ||
-		      (leaf->fn >= 0x80000000 && leaf->fn <= cpuid_ext_range_max)))
+		if (!(leaf->fn <= RIP_REL_REF(cpuid_std_range_max) ||
+		      (leaf->fn >= 0x40000000 && leaf->fn <= RIP_REL_REF(cpuid_hyp_range_max)) ||
+		      (leaf->fn >= 0x80000000 && leaf->fn <= RIP_REL_REF(cpuid_ext_range_max))))
 			return 0;
 	}
 
@@ -1060,10 +1060,10 @@ static void __init setup_cpuid_table(con
 		const struct snp_cpuid_fn *fn = &cpuid_table->fn[i];
 
 		if (fn->eax_in == 0x0)
-			cpuid_std_range_max = fn->eax;
+			RIP_REL_REF(cpuid_std_range_max) = fn->eax;
 		else if (fn->eax_in == 0x40000000)
-			cpuid_hyp_range_max = fn->eax;
+			RIP_REL_REF(cpuid_hyp_range_max) = fn->eax;
 		else if (fn->eax_in == 0x80000000)
-			cpuid_ext_range_max = fn->eax;
+			RIP_REL_REF(cpuid_ext_range_max) = fn->eax;
 	}
 }
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -736,7 +736,7 @@ void __init early_snp_set_memory_private
 	 * This eliminates worries about jump tables or checking boot_cpu_data
 	 * in the cc_platform_has() function.
 	 */
-	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
+	if (!(RIP_REL_REF(sev_status) & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	 /*
@@ -758,7 +758,7 @@ void __init early_snp_set_memory_shared(
 	 * This eliminates worries about jump tables or checking boot_cpu_data
 	 * in the cc_platform_has() function.
 	 */
-	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
+	if (!(RIP_REL_REF(sev_status) & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	/* Invalidate the memory pages before they are marked shared in the RMP table. */
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -304,7 +304,8 @@ void __init sme_encrypt_kernel(struct bo
 	 * instrumentation or checking boot_cpu_data in the cc_platform_has()
 	 * function.
 	 */
-	if (!sme_get_me_mask() || sev_status & MSR_AMD64_SEV_ENABLED)
+	if (!sme_get_me_mask() ||
+	    RIP_REL_REF(sev_status) & MSR_AMD64_SEV_ENABLED)
 		return;
 
 	/*
@@ -541,11 +542,11 @@ void __init sme_enable(struct boot_param
 	me_mask = 1UL << (ebx & 0x3f);
 
 	/* Check the SEV MSR whether SEV or SME is enabled */
-	sev_status   = __rdmsr(MSR_AMD64_SEV);
-	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
+	RIP_REL_REF(sev_status) = msr = __rdmsr(MSR_AMD64_SEV);
+	feature_mask = (msr & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
 
 	/* The SEV-SNP CC blob should never be present unless SEV-SNP is enabled. */
-	if (snp && !(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
+	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
 		snp_abort();
 
 	/* Check if memory encryption is enabled */
@@ -571,7 +572,6 @@ void __init sme_enable(struct boot_param
 			return;
 	} else {
 		/* SEV state cannot be controlled by a command line option */
-		sme_me_mask = me_mask;
 		goto out;
 	}
 
@@ -590,16 +590,13 @@ void __init sme_enable(struct boot_param
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
 
-	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0)
-		goto out;
-
-	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
-		sme_me_mask = me_mask;
+	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0 ||
+	    strncmp(buffer, cmdline_on, sizeof(buffer)))
+		return;
 
 out:
-	if (sme_me_mask) {
-		physical_mask &= ~sme_me_mask;
-		cc_vendor = CC_VENDOR_AMD;
-		cc_set_mask(sme_me_mask);
-	}
+	RIP_REL_REF(sme_me_mask) = me_mask;
+	physical_mask &= ~me_mask;
+	cc_vendor = CC_VENDOR_AMD;
+	cc_set_mask(me_mask);
 }


