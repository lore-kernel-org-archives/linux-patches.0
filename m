Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCFB145341;
	Tue, 23 Apr 2024 21:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908686; cv=none; b=LQfupon14WFnlGogD+17fLtBylD7mXeJ7nwtVihrBwG1L8aZ0CrUOTtGGBjWG/i6wpnMcOBN7iTxZ+oep+kzjt9SC0NvmASTrXao8NYLBz5b2RSAoG7XpzqOM2sLxBmgctSQOMpr0/dtWB9cGPZMPyHFEpwNlj4iwsQx21MU+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908686; c=relaxed/simple;
	bh=uUEn+fVQ9BO9Lhdoax09BxFTtKFGQMn7dcCR4wmmhcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ba2oQr0Nd7UP6A5JlwpBnhm0/AAWj/gc4bB3gR74dR5VuOEnGVxYuSgg2ST3FZykI60MjVqc9rmA93HHpwn8/AedA6F609KDyuJCb+P5NUfiNIIAE+yyJJGVQcnfH/U31SrDCRNuKDDhRn3bblkzem1YWMTspD92Ksl0HmEqfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGIAEwg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGIAEwg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223A7C116B1;
	Tue, 23 Apr 2024 21:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908686;
	bh=uUEn+fVQ9BO9Lhdoax09BxFTtKFGQMn7dcCR4wmmhcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGIAEwg4vP4p+tdRKCguB6ED8SEgwhRWmYfpmsck8m7PdQEyN55xpLyDcNFnhEWvI
	 f3Gk1+MP8R57gCvweHJchYil8IeZSU04j9lXmQmeFJgZQB9ar90pMfi1GqIMWhAt1f
	 /OdAT+aozgs/77ue3+OgD1AWB4SKOWhT5ycMd/+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.1 032/141] x86/sev: Move early startup code into .head.text section
Date: Tue, 23 Apr 2024 14:38:20 -0700
Message-ID: <20240423213854.349103384@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

[ Commit 428080c9b19bfda37c478cd626dbd3851db1aff9 upstream ]

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
 arch/x86/kernel/sev.c          |   11 ++++++-----
 4 files changed, 24 insertions(+), 23 deletions(-)

--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -118,6 +118,9 @@ static bool fault_in_kernel_space(unsign
 #define __init
 #define __pa(x)	((unsigned long)(x))
 
+#undef __head
+#define __head
+
 #define __BOOT_COMPRESSED
 
 /* Basic instruction decoding support needed */
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -192,15 +192,15 @@ static inline int pvalidate(unsigned lon
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
 u64 snp_get_unsupported_features(u64 status);
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -86,7 +86,8 @@ static bool __init sev_es_check_cpu_feat
 	return true;
 }
 
-static void __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
+static void __head __noreturn
+sev_es_terminate(unsigned int set, unsigned int reason)
 {
 	u64 val = GHCB_MSR_TERM_REQ;
 
@@ -323,13 +324,7 @@ static int sev_cpuid_hv(struct ghcb *ghc
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
@@ -388,7 +383,7 @@ static u32 snp_cpuid_calc_xsave_size(u64
 	return xsave_size;
 }
 
-static bool
+static bool __head
 snp_cpuid_get_validated_func(struct cpuid_leaf *leaf)
 {
 	const struct snp_cpuid_table *cpuid_table = snp_cpuid_get_table();
@@ -525,7 +520,8 @@ static int snp_cpuid_postprocess(struct
  * Returns -EOPNOTSUPP if feature not enabled. Any other non-zero return value
  * should be treated as fatal by caller.
  */
-static int snp_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt, struct cpuid_leaf *leaf)
+static int __head
+snp_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt, struct cpuid_leaf *leaf)
 {
 	const struct snp_cpuid_table *cpuid_table = snp_cpuid_get_table();
 
@@ -567,7 +563,7 @@ static int snp_cpuid(struct ghcb *ghcb,
  * page yet, so it only supports the MSR based communication with the
  * hypervisor and only the CPUID exit-code.
  */
-void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
+void __head do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 {
 	unsigned int subfn = lower_bits(regs->cx, 32);
 	unsigned int fn = lower_bits(regs->ax, 32);
@@ -1013,7 +1009,8 @@ struct cc_setup_data {
  * Search for a Confidential Computing blob passed in as a setup_data entry
  * via the Linux Boot Protocol.
  */
-static struct cc_blob_sev_info *find_cc_blob_setup_data(struct boot_params *bp)
+static __head
+struct cc_blob_sev_info *find_cc_blob_setup_data(struct boot_params *bp)
 {
 	struct cc_setup_data *sd = NULL;
 	struct setup_data *hdr;
@@ -1040,7 +1037,7 @@ static struct cc_blob_sev_info *find_cc_
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
@@ -690,7 +691,7 @@ static void pvalidate_pages(unsigned lon
 	}
 }
 
-static void __init early_set_pages_state(unsigned long paddr, unsigned long npages, enum psc_op op)
+static void __head early_set_pages_state(unsigned long paddr, unsigned long npages, enum psc_op op)
 {
 	unsigned long paddr_end;
 	u64 val;
@@ -728,7 +729,7 @@ e_term:
 	sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PSC);
 }
 
-void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
+void __head early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
 					 unsigned long npages)
 {
 	/*
@@ -2085,7 +2086,7 @@ fail:
  *
  * Scan for the blob in that order.
  */
-static __init struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
+static __head struct cc_blob_sev_info *find_cc_blob(struct boot_params *bp)
 {
 	struct cc_blob_sev_info *cc_info;
 
@@ -2111,7 +2112,7 @@ found_cc_info:
 	return cc_info;
 }
 
-bool __init snp_init(struct boot_params *bp)
+bool __head snp_init(struct boot_params *bp)
 {
 	struct cc_blob_sev_info *cc_info;
 
@@ -2133,7 +2134,7 @@ bool __init snp_init(struct boot_params
 	return true;
 }
 
-void __init __noreturn snp_abort(void)
+void __head __noreturn snp_abort(void)
 {
 	sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 }


