Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFB727604E;
	Tue, 12 Aug 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025322; cv=none; b=JMpHvqqmrK7QN93IpTeg5vA60VSlrf+amiTdIE5Tozp79e2eVlKn7BaxDvUyz1lOD+RMgXhwYKZ0atP4s+KLvjiGoZEi7PQc5Npxs+EbTVQDnwTZgmpRoEqYqwHLKZH/8RvVzEyiSqVMNhcBMGEGqQ8riIG4UAH7EtCi3Rmiu0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025322; c=relaxed/simple;
	bh=BjwtQKQduU/lAffmZCM3qHJW/xOs8eRkVSfFtAbWFKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfyLmSIeyBJCThJ29pwUFIMoCVi2gKiBiy7a+8JRNWhbYVfj+CHAo3z/lUAaAVpd81B2b+karrrGTKO7xMfUfsPxl79hpXW5qugoZpZ3X6ysyxx1XIKSWURSNh2Jy/rEg3DrP+hRzaQn3lrqPHMkztplsiazn9lh5iKIzY8M8RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8WrLPOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8WrLPOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC722C4CEF0;
	Tue, 12 Aug 2025 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025321;
	bh=BjwtQKQduU/lAffmZCM3qHJW/xOs8eRkVSfFtAbWFKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8WrLPORLUiUgLrd3Touuu9b9jzXdK0NhiaLQfCFHG8F9QCmqx8KW0wTH+6XcdjH8
	 iJLJK7vUTgiwwmWFOAf3UBrOBqiNmIvkXrJARrIuyqjwCihQlBhzB1dCNxkq1L28+S
	 +geaZgJBMzOMzo9smLywmPgwYl0VeO0v1EwgbfCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.16 596/627] x86/sev: Evict cache lines during SNP memory validation
Date: Tue, 12 Aug 2025 19:34:51 +0200
Message-ID: <20250812173454.543237460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
 arch/x86/boot/cpuflags.c           |   13 +++++++++++++
 arch/x86/boot/startup/sev-shared.c |    7 +++++++
 arch/x86/coco/sev/core.c           |   21 +++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/sev.h         |   19 +++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c    |    1 +
 6 files changed, 62 insertions(+)

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
--- a/arch/x86/boot/startup/sev-shared.c
+++ b/arch/x86/boot/startup/sev-shared.c
@@ -810,6 +810,13 @@ static void __head pvalidate_4k_page(uns
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
 
 /*
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -358,10 +358,31 @@ static void svsm_pval_pages(struct snp_p
 
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
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -621,6 +621,24 @@ int rmp_make_shared(u64 pfn, enum pg_lev
 void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
+
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
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_rmptable_init(void) { return -ENOSYS; }
@@ -636,6 +654,7 @@ static inline int rmp_make_shared(u64 pf
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
+static inline void sev_evict_cache(void *va, int npages) {}
 #endif
 
 #endif
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -48,6 +48,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },


