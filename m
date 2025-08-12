Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72422F291B;
	Tue, 12 Aug 2025 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023113; cv=none; b=DB8cdE5nNT0tIHzZOWs1mu2yFbCjMc7zKWrXX3RBB6u06VUTUxyqakBoyxn8uJTuIgcCoyoGmcrKklfxRjrSAo2u53tNhpNW10SHUm+9IWvMHb6oUBOJBR0YG7wmgYsxwCMWUwZxtuyEnS097AauGt4jouMwCEyI1GEMAJcV3LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023113; c=relaxed/simple;
	bh=797tPlI4Wd2ByILiV+YqOW+5YhaJghNwTuQ5ErRadcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJx9KrlvBJo10jqmzASbqJUWl/v03dASv623UUqh8nKqiW6A/I2P+O8MxcvJwmT01K3yRRIsGmtqaZqRDQFP813U8mMinm1+TaRwDh7SXwAPqgvYhgIUbs5blnnq22A/HFdx/OHYDc00rLsPKEUlQSp5hiyxhGbMTefbqk0gZG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfYS63N9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfYS63N9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BD8C4CEF0;
	Tue, 12 Aug 2025 18:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023113;
	bh=797tPlI4Wd2ByILiV+YqOW+5YhaJghNwTuQ5ErRadcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfYS63N92EpmnpuAMYmVc2yoKSm9nBgDM+v4XWAT/aIh3tmiukiuO3rTZw+y+WO19
	 hQ41OIhgN/KqiURla0Uu3UTQ/6FXWbgQM6XV6Ru9DiNC/6WFR7HWpuTdW2Sd6KLvEI
	 qtIUBeTIYrdW5cfkgVfQfRlA41yD+YoMxC+/8SjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 352/369] x86/sev: Evict cache lines during SNP memory validation
Date: Tue, 12 Aug 2025 19:30:49 +0200
Message-ID: <20250812173029.937256349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -115,5 +115,18 @@ void get_cpuflags(void)
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
@@ -1243,6 +1243,24 @@ static void svsm_pval_terminate(struct s
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
 static void svsm_pval_4k_page(unsigned long paddr, bool validate)
 {
 	struct svsm_pvalidate_call *pc;
@@ -1295,6 +1313,13 @@ static void pvalidate_4k_page(unsigned l
 		if (ret)
 			__pval_terminate(PHYS_PFN(paddr), validate, RMP_PG_SIZE_4K, ret, 0);
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
@@ -1479,10 +1504,31 @@ static void svsm_pval_pages(struct snp_p
 
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
@@ -227,6 +227,7 @@
 #define X86_FEATURE_FLEXPRIORITY	( 8*32+ 1) /* "flexpriority" Intel FlexPriority */
 #define X86_FEATURE_EPT			( 8*32+ 2) /* "ept" Intel Extended Page Table */
 #define X86_FEATURE_VPID		( 8*32+ 3) /* "vpid" Intel Virtual Processor ID */
+#define X86_FEATURE_COHERENCY_SFW_NO	( 8*32+ 4) /* SNP cache coherency software work around not needed */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* "vmmcall" Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* Xen paravirtual guest */
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -47,6 +47,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_FAST_CPPC, 	CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_COHERENCY_SFW_NO,	CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,		CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,		CPUID_EBX,  3, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,	CPUID_ECX,  1, 0x80000021, 0 },


