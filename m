Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A9D7BAFE;
	Mon,  8 Apr 2024 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583940; cv=none; b=qNdLOXkVW5z1cGtdgg+3Gflkbc5igYXMFxvAvbXDfhiBsbGzWxVczTehf2CKc9QRcMQcxW/UV0iQJru5EdKzI9zP6T5SP26qFSB7n6s0aJqdwTJF8YoCNAL+S5FTJMdPAtd+SPilP5WQGXGTEJ7uwiURG7OhfIv2coVQe1Eeg6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583940; c=relaxed/simple;
	bh=7HzzpD06cj+DDyH3CQYL/UVYEXpuI+/k3yNoDT2UAa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoHSEO17WNtOo7zB0XZiQPi4/yu+jPlP2NbD5RoxTxFNFElZBR2qc/HE1d4Y+Hl5X/+OeMHWMLAKqLkGz4S1I0Y1OqaziK4rtiNObWuxsea0ZYQXy94QUERrRuS6zhzLV/LhtlWOweZeIknSY6NBtus6GT9FcCOBzE7/BBDdAvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaB+3La6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaB+3La6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6383C433C7;
	Mon,  8 Apr 2024 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583940;
	bh=7HzzpD06cj+DDyH3CQYL/UVYEXpuI+/k3yNoDT2UAa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FaB+3La6+akpyuncXak5KP+INzZ7vXWPA7lS7eV2+uNOKUxUBl0QgfDcLaJCJr2FR
	 CMA0zspvSZWe9LE31AIDy4iYv6PzsKLfV+B7QdW+y4Mj36btbvxSYcFBP5YtQnLYlm
	 ckTMKvD5wfT67Qhk1bARs75QBY0KDKc269RqsE4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.6 251/252] x86/sev: Move early startup code into .head.text section
Date: Mon,  8 Apr 2024 14:59:10 +0200
Message-ID: <20240408125314.445897302@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 428080c9b19bfda37c478cd626dbd3851db1aff9 upstream.

In preparation for implementing rigorous build time checks to enforce
that only code that can support it will be called from the early 1:1
mapping of memory, move SEV init code that is called in this manner to
the .head.text section.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240227151907.387873-19-ardb+git@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/sev.c |    3 +++
 arch/x86/include/asm/sev.h     |   10 +++++-----
 arch/x86/kernel/sev-shared.c   |   23 ++++++++++-------------
 arch/x86/kernel/sev.c          |   14 ++++++++------
 4 files changed, 26 insertions(+), 24 deletions(-)

--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -116,6 +116,9 @@ static bool fault_in_kernel_space(unsign
 #undef __init
 #define __init
 
+#undef __head
+#define __head
+
 #define __BOOT_COMPRESSED
 
 /* Basic instruction decoding support needed */
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -199,15 +199,15 @@ static inline int pvalidate(unsigned lon
 struct snp_guest_request_ioctl;
 
 void setup_ghcb(void);
-void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
-					 unsigned long npages);
-void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
-					unsigned long npages);
+void early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
+				  unsigned long npages);
+void early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
+				 unsigned long npages);
 void snp_set_memory_shared(unsigned long vaddr, unsigned long npages);
 void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
-void __init __noreturn snp_abort(void);
+void __noreturn snp_abort(void);
 void snp_dmi_setup(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -89,7 +89,8 @@ static bool __init sev_es_check_cpu_feat
 	return true;
 }
 
-static void __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
+static void __head __noreturn
+sev_es_terminate(unsigned int set, unsigned int reason)
 {
 	u64 val = GHCB_MSR_TERM_REQ;
 
@@ -326,13 +327,7 @@ static int sev_cpuid_hv(struct ghcb *ghc
  */
 static const struct snp_cpuid_table *snp_cpuid_get_table(void)
 {
-	void *ptr;
-
-	asm ("lea cpuid_table_copy(%%rip), %0"
-	     : "=r" (ptr)
-	     : "p" (&cpuid_table_copy));
-
-	return ptr;
+	return &RIP_REL_REF(cpuid_table_copy);
 }
 
 /*
@@ -391,7 +386,7 @@ static u32 snp_cpuid_calc_xsave_size(u64
 	return xsave_size;
 }
 
-static bool
+static bool __head
 snp_cpuid_get_validated_func(struct cpuid_leaf *leaf)
 {
 	const struct snp_cpuid_table *cpuid_table = snp_cpuid_get_table();
@@ -528,7 +523,8 @@ static int snp_cpuid_postprocess(struct
  * Returns -EOPNOTSUPP if feature not enabled. Any other non-zero return value
  * should be treated as fatal by caller.
  */
-static int snp_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt, struct cpuid_leaf *leaf)
+static int __head
+snp_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt, struct cpuid_leaf *leaf)
 {
 	const struct snp_cpuid_table *cpuid_table = snp_cpuid_get_table();
 
@@ -570,7 +566,7 @@ static int snp_cpuid(struct ghcb *ghcb,
  * page yet, so it only supports the MSR based communication with the
  * hypervisor and only the CPUID exit-code.
  */
-void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
+void __head do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 {
 	unsigned int subfn = lower_bits(regs->cx, 32);
 	unsigned int fn = lower_bits(regs->ax, 32);
@@ -1016,7 +1012,8 @@ struct cc_setup_data {
  * Search for a Confidential Computing blob passed in as a setup_data entry
  * via the Linux Boot Protocol.
  */
-static struct cc_blob_sev_info *find_cc_blob_setup_data(struct boot_params *bp)
+static __head
+struct cc_blob_sev_info *find_cc_blob_setup_data(struct boot_params *bp)
 {
 	struct cc_setup_data *sd = NULL;
 	struct setup_data *hdr;
@@ -1043,7 +1040,7 @@ static struct cc_blob_sev_info *find_cc_
  * mapping needs to be updated in sync with all the changes to virtual memory
  * layout and related mapping facilities throughout the boot process.
  */
-static void __init setup_cpuid_table(const struct cc_blob_sev_info *cc_info)
+static void __head setup_cpuid_table(const struct cc_blob_sev_info *cc_info)
 {
 	const struct snp_cpuid_table *cpuid_table_fw, *cpuid_table;
 	int i;
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -26,6 +26,7 @@
 #include <linux/dmi.h>
 #include <uapi/linux/sev-guest.h>
 
+#include <asm/init.h>
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
 #include <asm/sev.h>
@@ -683,8 +684,9 @@ static u64 __init get_jump_table_addr(vo
 	return ret;
 }
 
-static void early_set_pages_state(unsigned long vaddr, unsigned long paddr,
-				  unsigned long npages, enum psc_op op)
+static void __head
+early_set_pages_state(unsigned long vaddr, unsigned long paddr,
+		      unsigned long npages, enum psc_op op)
 {
 	unsigned long paddr_end;
 	u64 val;
@@ -740,7 +742,7 @@ e_term:
 	sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PSC);
 }
 
-void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
+void __head early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
 					 unsigned long npages)
 {
 	/*
@@ -2045,7 +2047,7 @@ fail:
  *
  * Scan for the blob in that order.
  */
-static __init struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
+static __head struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
 {
 	struct cc_blob_sev_info *cc_info;
 
@@ -2071,7 +2073,7 @@ found_cc_info:
 	return cc_info;
 }
 
-bool __init snp_init(struct boot_params *bp)
+bool __head snp_init(struct boot_params *bp)
 {
 	struct cc_blob_sev_info *cc_info;
 
@@ -2093,7 +2095,7 @@ bool __init snp_init(struct boot_params
 	return true;
 }
 
-void __init __noreturn snp_abort(void)
+void __head __noreturn snp_abort(void)
 {
 	sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 }


