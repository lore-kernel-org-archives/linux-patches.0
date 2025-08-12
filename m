Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F2A2DCF46;
	Tue, 12 Aug 2025 19:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026841; cv=none; b=iJaMmRLv2l+5uiLsiV70bB4kDLy+7Hjoze0qjnyGhvrjVZxhhZCGbVMrR9gKfDahKGuYsOpS2XEInYvIzDHVlCU1nhL/d8PLhNBi2br4XoSpfhuvi66Ag607XK0VT8FAJQS5D+/qX9BkzHoSRRtJlW1/xVXMwZAvAsnVtxsz+dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026841; c=relaxed/simple;
	bh=nAN51TMs8tHKrRPpKz5466ugYHAvvRXvc2iyeS3SQxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGYfX92Ic+NwUsml2KWQ7KXXQCI3/q0GKOSpq8Y0ZFBl8c2LkTnofvXX9QRQ1zYXZvsMhCuZweGEJ6rWKwnxLr/WOszrETfv6K/ZqZ4xA09rRloLeipmLZuOzWBLEsYxxdU83hAupiMa9xYA3GFPZzu/uOUkOPL9OIjtNJXUlZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyRiRIeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyRiRIeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF5EC4CEF0;
	Tue, 12 Aug 2025 19:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026841;
	bh=nAN51TMs8tHKrRPpKz5466ugYHAvvRXvc2iyeS3SQxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyRiRIeJv2AVCk1F863w+FLpEYC1Tm4ZNNasCuETtv+WmCcbI5ULUlWbIdofpeZCH
	 tRTkEq1+qeUb04S+eIcmyIEGMetRjOD7SVD09imeXHFS9z6Qzk2mgDB02e2NF/0RAA
	 JjUCRxkmQDd5mxWTHO10QdP99PVVuZiODIMgweAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.15 456/480] x86/sev: Evict cache lines during SNP memory validation
Date: Tue, 12 Aug 2025 19:51:04 +0200
Message-ID: <20250812174416.200124953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

Commit 7b306dfa326f70114312b320d083b21fa9481e1e upstream.

An SNP cache coherency vulnerability requires a cache line eviction
mitigation when validating memory after a page state change to private.
The specific mitigation is to touch the first and last byte of each 4K
page that is being validated. There is no need to perform the mitigation
when performing a page state change to shared and rescinding validation.

CPUID bit Fn8000001F_EBX[31] defines the COHERENCY_SFW_NO CPUID bit that,
when set, indicates that the software mitigation for this vulnerability is
not needed.

Implement the mitigation and invoke it when validating memory (making it
private) and the COHERENCY_SFW_NO bit is not set, indicating the SNP guest
is vulnerable.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/cpuflags.c           |   13 ++++++++++
 arch/x86/coco/sev/shared.c         |   46 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h |    1 
 arch/x86/kernel/cpu/scattered.c    |    1 
 4 files changed, 61 insertions(+)

--- a/arch/x86/boot/cpuflags.c
+++ b/arch/x86/boot/cpuflags.c
@@ -106,5 +106,18 @@ void get_cpuflags(void)
 			cpuid(0x80000001, &ignored, &ignored, &cpu.flags[6],
 			      &cpu.flags[1]);
 		}
+
+		if (max_amd_level >= 0x8000001f) {
+			u32 ebx;
+
+			/*
+			 * The X86_FEATURE_COHERENCY_SFW_NO feature bit is in
+			 * the virtualization flags entry (word 8) and set by
+			 * scattered.c, so the bit needs to be explicitly set.
+			 */
+			cpuid(0x8000001f, &ignored, &ebx, &ignored, &ignored);
+			if (ebx & BIT(31))
+				set_bit(X86_FEATURE_COHERENCY_SFW_NO, cpu.flags);
+		}
 	}
 }
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1254,6 +1254,24 @@ static void svsm_pval_terminate(struct s
 	__pval_terminate(pfn, action, page_size, ret, svsm_ret);
 }
 
+static inline void sev_evict_cache(void *va, int npages)
+{
+	volatile u8 val __always_unused;
+	u8 *bytes = va;
+	int page_idx;
+
+	/*
+	 * For SEV guests, a read from the first/last cache-lines of a 4K page
+	 * using the guest key is sufficient to cause a flush of all cache-lines
+	 * associated with that 4K page without incurring all the overhead of a
+	 * full CLFLUSH sequence.
+	 */
+	for (page_idx = 0; page_idx < npages; page_idx++) {
+		val = bytes[page_idx * PAGE_SIZE];
+		val = bytes[page_idx * PAGE_SIZE + PAGE_SIZE - 1];
+	}
+}
+
 static void __head svsm_pval_4k_page(unsigned long paddr, bool validate)
 {
 	struct svsm_pvalidate_call *pc;
@@ -1307,6 +1325,13 @@ static void __head pvalidate_4k_page(uns
 		if (ret)
 			sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PVALIDATE);
 	}
+
+	/*
+	 * If validating memory (making it private) and affected by the
+	 * cache-coherency vulnerability, perform the cache eviction mitigation.
+	 */
+	if (validate && !has_cpuflag(X86_FEATURE_COHERENCY_SFW_NO))
+		sev_evict_cache((void *)vaddr, 1);
 }
 
 static void pval_pages(struct snp_psc_desc *desc)
@@ -1491,10 +1516,31 @@ static void svsm_pval_pages(struct snp_p
 
 static void pvalidate_pages(struct snp_psc_desc *desc)
 {
+	struct psc_entry *e;
+	unsigned int i;
+
 	if (snp_vmpl)
 		svsm_pval_pages(desc);
 	else
 		pval_pages(desc);
+
+	/*
+	 * If not affected by the cache-coherency vulnerability there is no need
+	 * to perform the cache eviction mitigation.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_COHERENCY_SFW_NO))
+		return;
+
+	for (i = 0; i <= desc->hdr.end_entry; i++) {
+		e = &desc->entries[i];
+
+		/*
+		 * If validating memory (making it private) perform the cache
+		 * eviction mitigation.
+		 */
+		if (e->operation == SNP_PAGE_STATE_PRIVATE)
+			sev_evict_cache(pfn_to_kaddr(e->gfn), e->pagesize ? 512 : 1);
+	}
 }
 
 static int vmgexit_psc(struct ghcb *ghcb, struct snp_psc_desc *desc)
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -218,6 +218,7 @@
 #define X86_FEATURE_FLEXPRIORITY	( 8*32+ 1) /* "flexpriority" Intel FlexPriority */
 #define X86_FEATURE_EPT			( 8*32+ 2) /* "ept" Intel Extended Page Table */
 #define X86_FEATURE_VPID		( 8*32+ 3) /* "vpid" Intel Virtual Processor ID */
+#define X86_FEATURE_COHERENCY_SFW_NO	( 8*32+ 4) /* SNP cache coherency software work around not needed */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* "vmmcall" Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* Xen paravirtual guest */
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -47,6 +47,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },


