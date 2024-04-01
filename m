Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B4B8F5C;
	Mon,  1 Apr 2024 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987807; cv=none; b=SQcRmb4XebgbQFN8E63c+6iGs/5XCjT9E/xAwKSNrXBXRv+cCi9KCMbAc5pm6QEGw93YmKZYSeUYhg7QWNCDAkJpYHhyyJg6TbdO8Y5zH7dI4vxxnf8FLsfAab6/v9M/cP3bQ4PvXYX8F/Q6rZmu3JkzaoGC8Hlyli9uVEJ8kdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987807; c=relaxed/simple;
	bh=RHQf6tUnN6e22hVvJgZ2rGg1aKDJLSZlTGkhzEhJ6oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2byk6G2IFbwuESXUUemkSN08/57pgwTL07Do/LUy0G86bGBySUJNGYajoZo+BP/JdT+nMgQxcfpgrQpqs17lS0yB5F3rMfkVdFwHtPO0WRJeFvwlqYK/F9ejty0tX2MmqT7JsQXAvb1vaZTjpeeyMz5CmgXEN7UPbsAluKa7RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYuNOD4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYuNOD4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772B4C433C7;
	Mon,  1 Apr 2024 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987807;
	bh=RHQf6tUnN6e22hVvJgZ2rGg1aKDJLSZlTGkhzEhJ6oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYuNOD4bs2QFeYCU4xxNmBQaBJp3zQ1M4o6gW8GQOCyCiCuva/0XYPDAJPstC9gMd
	 UeJJDtRgg7rEC6qX+Hazix/h4ZO0tX1YDU+NgPq2qWrsRRoum5PHIR9rZslg9Pvnnj
	 0CVOj6uW4wlrdZLSO/3dxMTeVPbNht7lja1ndiNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Loughlin <kevinloughlin@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.8 398/399] x86/sev: Skip ROM range scans and validation for SEV-SNP guests
Date: Mon,  1 Apr 2024 17:46:04 +0200
Message-ID: <20240401152601.061847818@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Kevin Loughlin <kevinloughlin@google.com>

commit 0f4a1e80989aca185d955fcd791d7750082044a2 upstream.

SEV-SNP requires encrypted memory to be validated before access.
Because the ROM memory range is not part of the e820 table, it is not
pre-validated by the BIOS. Therefore, if a SEV-SNP guest kernel wishes
to access this range, the guest must first validate the range.

The current SEV-SNP code does indeed scan the ROM range during early
boot and thus attempts to validate the ROM range in probe_roms().
However, this behavior is neither sufficient nor necessary for the
following reasons:

* With regards to sufficiency, if EFI_CONFIG_TABLES are not enabled and
  CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK is set, the kernel will
  attempt to access the memory at SMBIOS_ENTRY_POINT_SCAN_START (which
  falls in the ROM range) prior to validation.

  For example, Project Oak Stage 0 provides a minimal guest firmware
  that currently meets these configuration conditions, meaning guests
  booting atop Oak Stage 0 firmware encounter a problematic call chain
  during dmi_setup() -> dmi_scan_machine() that results in a crash
  during boot if SEV-SNP is enabled.

* With regards to necessity, SEV-SNP guests generally read garbage
  (which changes across boots) from the ROM range, meaning these scans
  are unnecessary. The guest reads garbage because the legacy ROM range
  is unencrypted data but is accessed via an encrypted PMD during early
  boot (where the PMD is marked as encrypted due to potentially mapping
  actually-encrypted data in other PMD-contained ranges).

In one exceptional case, EISA probing treats the ROM range as
unencrypted data, which is inconsistent with other probing.

Continuing to allow SEV-SNP guests to use garbage and to inconsistently
classify ROM range encryption status can trigger undesirable behavior.
For instance, if garbage bytes appear to be a valid signature, memory
may be unnecessarily reserved for the ROM range. Future code or other
use cases may result in more problematic (arbitrary) behavior that
should be avoided.

While one solution would be to overhaul the early PMD mapping to always
treat the ROM region of the PMD as unencrypted, SEV-SNP guests do not
currently rely on data from the ROM region during early boot (and even
if they did, they would be mostly relying on garbage data anyways).

As a simpler solution, skip the ROM range scans (and the otherwise-
necessary range validation) during SEV-SNP guest early boot. The
potential SEV-SNP guest crash due to lack of ROM range validation is
thus avoided by simply not accessing the ROM range.

In most cases, skip the scans by overriding problematic x86_init
functions during sme_early_init() to SNP-safe variants, which can be
likened to x86_init overrides done for other platforms (ex: Xen); such
overrides also avoid the spread of cc_platform_has() checks throughout
the tree.

In the exceptional EISA case, still use cc_platform_has() for the
simplest change, given (1) checks for guest type (ex: Xen domain status)
are already performed here, and (2) these checks occur in a subsys
initcall instead of an x86_init function.

  [ bp: Massage commit message, remove "we"s. ]

Fixes: 9704c07bf9f7 ("x86/kernel: Validate ROM memory before accessing when SEV-SNP is active")
Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20240313121546.2964854-1-kevinloughlin@google.com
Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/sev.h      |    4 ++--
 arch/x86/include/asm/x86_init.h |    3 ++-
 arch/x86/kernel/eisa.c          |    3 ++-
 arch/x86/kernel/probe_roms.c    |   10 ----------
 arch/x86/kernel/setup.c         |    3 +--
 arch/x86/kernel/sev.c           |   27 ++++++++++++---------------
 arch/x86/kernel/x86_init.c      |    2 ++
 arch/x86/mm/mem_encrypt_amd.c   |   18 ++++++++++++++++++
 8 files changed, 39 insertions(+), 31 deletions(-)

--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -203,12 +203,12 @@ void __init early_snp_set_memory_private
 					 unsigned long npages);
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
 					unsigned long npages);
-void __init snp_prep_memory(unsigned long paddr, unsigned int sz, enum psc_op op);
 void snp_set_memory_shared(unsigned long vaddr, unsigned long npages);
 void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
+void snp_dmi_setup(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
@@ -227,12 +227,12 @@ static inline void __init
 early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr, unsigned long npages) { }
 static inline void __init
 early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned long npages) { }
-static inline void __init snp_prep_memory(unsigned long paddr, unsigned int sz, enum psc_op op) { }
 static inline void snp_set_memory_shared(unsigned long vaddr, unsigned long npages) { }
 static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npages) { }
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
+static inline void snp_dmi_setup(void) { }
 static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
 {
 	return -ENOTTY;
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -30,12 +30,13 @@ struct x86_init_mpparse {
  * @reserve_resources:		reserve the standard resources for the
  *				platform
  * @memory_setup:		platform specific memory setup
- *
+ * @dmi_setup:			platform specific DMI setup
  */
 struct x86_init_resources {
 	void (*probe_roms)(void);
 	void (*reserve_resources)(void);
 	char *(*memory_setup)(void);
+	void (*dmi_setup)(void);
 };
 
 /**
--- a/arch/x86/kernel/eisa.c
+++ b/arch/x86/kernel/eisa.c
@@ -2,6 +2,7 @@
 /*
  * EISA specific code
  */
+#include <linux/cc_platform.h>
 #include <linux/ioport.h>
 #include <linux/eisa.h>
 #include <linux/io.h>
@@ -12,7 +13,7 @@ static __init int eisa_bus_probe(void)
 {
 	void __iomem *p;
 
-	if (xen_pv_domain() && !xen_initial_domain())
+	if ((xen_pv_domain() && !xen_initial_domain()) || cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return 0;
 
 	p = ioremap(0x0FFFD9, 4);
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -203,16 +203,6 @@ void __init probe_roms(void)
 	unsigned char c;
 	int i;
 
-	/*
-	 * The ROM memory range is not part of the e820 table and is therefore not
-	 * pre-validated by BIOS. The kernel page table maps the ROM region as encrypted
-	 * memory, and SNP requires encrypted memory to be validated before access.
-	 * Do that here.
-	 */
-	snp_prep_memory(video_rom_resource.start,
-			((system_rom_resource.end + 1) - video_rom_resource.start),
-			SNP_PAGE_STATE_PRIVATE);
-
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
 	for (start = video_rom_resource.start; start < upper; start += 2048) {
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -9,7 +9,6 @@
 #include <linux/console.h>
 #include <linux/crash_dump.h>
 #include <linux/dma-map-ops.h>
-#include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/ima.h>
 #include <linux/init_ohci1394_dma.h>
@@ -902,7 +901,7 @@ void __init setup_arch(char **cmdline_p)
 		efi_init();
 
 	reserve_ibft_region();
-	dmi_setup();
+	x86_init.resources.dmi_setup();
 
 	/*
 	 * VMware detection requires dmi to be available, so this
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/psp-sev.h>
+#include <linux/dmi.h>
 #include <uapi/linux/sev-guest.h>
 
 #include <asm/cpu_entry_area.h>
@@ -774,21 +775,6 @@ void __init early_snp_set_memory_shared(
 	early_set_pages_state(vaddr, paddr, npages, SNP_PAGE_STATE_SHARED);
 }
 
-void __init snp_prep_memory(unsigned long paddr, unsigned int sz, enum psc_op op)
-{
-	unsigned long vaddr, npages;
-
-	vaddr = (unsigned long)__va(paddr);
-	npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
-
-	if (op == SNP_PAGE_STATE_PRIVATE)
-		early_snp_set_memory_private(vaddr, paddr, npages);
-	else if (op == SNP_PAGE_STATE_SHARED)
-		early_snp_set_memory_shared(vaddr, paddr, npages);
-	else
-		WARN(1, "invalid memory op %d\n", op);
-}
-
 static unsigned long __set_pages_state(struct snp_psc_desc *data, unsigned long vaddr,
 				       unsigned long vaddr_end, int op)
 {
@@ -2112,6 +2098,17 @@ void __init __noreturn snp_abort(void)
 	sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 }
 
+/*
+ * SEV-SNP guests should only execute dmi_setup() if EFI_CONFIG_TABLES are
+ * enabled, as the alternative (fallback) logic for DMI probing in the legacy
+ * ROM region can cause a crash since this region is not pre-validated.
+ */
+void __init snp_dmi_setup(void)
+{
+	if (efi_enabled(EFI_CONFIG_TABLES))
+		dmi_setup();
+}
+
 static void dump_cpuid_table(void)
 {
 	const struct snp_cpuid_table *cpuid_table = snp_cpuid_get_table();
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -3,6 +3,7 @@
  *
  *  For licencing details see kernel-base/COPYING
  */
+#include <linux/dmi.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/export.h>
@@ -66,6 +67,7 @@ struct x86_init_ops x86_init __initdata
 		.probe_roms		= probe_roms,
 		.reserve_resources	= reserve_standard_io_resources,
 		.memory_setup		= e820__memory_setup_default,
+		.dmi_setup		= dmi_setup,
 	},
 
 	.mpparse = {
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -492,6 +492,24 @@ void __init sme_early_init(void)
 	 */
 	if (sev_status & MSR_AMD64_SEV_ENABLED)
 		ia32_disable();
+
+	/*
+	 * Override init functions that scan the ROM region in SEV-SNP guests,
+	 * as this memory is not pre-validated and would thus cause a crash.
+	 */
+	if (sev_status & MSR_AMD64_SEV_SNP_ENABLED) {
+		x86_init.mpparse.find_smp_config = x86_init_noop;
+		x86_init.pci.init_irq = x86_init_noop;
+		x86_init.resources.probe_roms = x86_init_noop;
+
+		/*
+		 * DMI setup behavior for SEV-SNP guests depends on
+		 * efi_enabled(EFI_CONFIG_TABLES), which hasn't been
+		 * parsed yet. snp_dmi_setup() will run after that
+		 * parsing has happened.
+		 */
+		x86_init.resources.dmi_setup = snp_dmi_setup;
+	}
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)


