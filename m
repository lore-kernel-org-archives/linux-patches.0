Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF1D1C8621;
	Tue, 12 Aug 2025 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021897; cv=none; b=e2j7TCu+Yt0AWgpXmTJ3ReEAy3JOQJyIPDzFbe2ZunvPkExyFAbVepiF11uiLDRHJQQujlMlBNlNWvDu7jJ5QzwcH0Ai3nmjoIo9hMJe9/FgRScQMKKaC/Xg3TLcLO1/qFxH0puTlrHqaDyOo3e06MOWzp7LSqYH4G2ING1kuxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021897; c=relaxed/simple;
	bh=bY977zTxp+Nd82NXKHA17zsDKLVGtREsc1hoFNEog/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCcmhM4v1dmOLefsa8WURWlx3M87dIF0BvIMk8jubYP8ZtUhp+B2lLu0b15uumPLZ4nHwcpc4VDEeHiEZUykYSlss/tAxQajtudb14h3NLtMxwGhN+ZFk/ZVK1IuEHM+FU+6/cw5lsT7Wu42knxeC8OJD0PUgvuA/j2B2+dMlIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPsnvY/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPsnvY/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2901C4CEF0;
	Tue, 12 Aug 2025 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021897;
	bh=bY977zTxp+Nd82NXKHA17zsDKLVGtREsc1hoFNEog/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPsnvY/rm2UapLhw0udXtoQkwYohut3c/Li0W7SWNzNExWnbpdJblrg/UW8ugemEa
	 F5GOeRWg7OKy8uZ96hhIPfDH03PEg9lDUlrWev/m1TxpCcfhvtgyuIyTx5/0HwDOa8
	 bbBl01QwJ7gE4GuvYbi137VIZFtyl2upqsoTfTsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 256/262] x86/sev: Evict cache lines during SNP memory validation
Date: Tue, 12 Aug 2025 19:30:44 +0200
Message-ID: <20250812173004.042539199@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/boot/compressed/sev.c     |    7 +++++++
 arch/x86/boot/cpuflags.c           |   13 +++++++++++++
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/scattered.c    |    1 +
 arch/x86/kernel/sev-shared.c       |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/sev.c              |   11 ++++++++++-
 6 files changed, 68 insertions(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -165,6 +165,13 @@ static void __page_state_change(unsigned
 	 */
 	if (op == SNP_PAGE_STATE_PRIVATE && pvalidate(paddr, RMP_PG_SIZE_4K, 1))
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PVALIDATE);
+
+	/*
+	 * If validating memory (making it private) and affected by the
+	 * cache-coherency vulnerability, perform the cache eviction mitigation.
+	 */
+	if (op == SNP_PAGE_STATE_PRIVATE && !has_cpuflag(X86_FEATURE_COHERENCY_SFW_NO))
+		sev_evict_cache((void *)paddr, 1);
 }
 
 void snp_set_page_private(unsigned long paddr)
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
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -228,6 +228,7 @@
 #define X86_FEATURE_FLEXPRIORITY	( 8*32+ 1) /* Intel FlexPriority */
 #define X86_FEATURE_EPT			( 8*32+ 2) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID		( 8*32+ 3) /* Intel Virtual Processor ID */
+#define X86_FEATURE_COHERENCY_SFW_NO	( 8*32+ 4) /* "" SNP cache coherency software work around not needed */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -46,6 +46,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_COHERENCY_SFW_NO,	CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,		CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,		CPUID_EBX,  3, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,	CPUID_ECX,  1, 0x80000021, 0 },
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -1068,6 +1068,24 @@ static void __head setup_cpuid_table(con
 	}
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
 static void pvalidate_pages(struct snp_psc_desc *desc)
 {
 	struct psc_entry *e;
@@ -1100,6 +1118,24 @@ static void pvalidate_pages(struct snp_p
 			sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PVALIDATE);
 		}
 	}
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
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -688,12 +688,14 @@ static void __head
 early_set_pages_state(unsigned long vaddr, unsigned long paddr,
 		      unsigned long npages, enum psc_op op)
 {
-	unsigned long paddr_end;
+	unsigned long vaddr_begin, paddr_end;
 	u64 val;
 	int ret;
 
 	vaddr = vaddr & PAGE_MASK;
 
+	vaddr_begin = vaddr;
+
 	paddr = paddr & PAGE_MASK;
 	paddr_end = paddr + (npages << PAGE_SHIFT);
 
@@ -736,6 +738,13 @@ early_set_pages_state(unsigned long vadd
 		paddr += PAGE_SIZE;
 	}
 
+	/*
+	 * If validating memory (making it private) and affected by the
+	 * cache-coherency vulnerability, perform the cache eviction mitigation.
+	 */
+	if (op == SNP_PAGE_STATE_PRIVATE && !cpu_feature_enabled(X86_FEATURE_COHERENCY_SFW_NO))
+		sev_evict_cache((void *)vaddr_begin, npages);
+
 	return;
 
 e_term:


