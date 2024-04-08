Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C8A7C6C8;
	Mon,  8 Apr 2024 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584156; cv=none; b=r3fOr9eTFi+m31wQbzivIHmSIqJB06GIIWONPOrDa+NrOphSI4kc3TRW2+uXOoCO5njiOWus5z2WWhqq/Je5Rp/HTCwzTtkfTO/yze7YG6GoBMUEO05qLvz8vrUeuCFvHr5PN3GYlw4eO8GBpodazEtcn7Ue5czye+wYM2Y+XAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584156; c=relaxed/simple;
	bh=5+hH6tKnkCvPz4pZhqnYCW3bGWVWvwFb3nv4wis0s68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeqbKPIx3URTWD29ctRhPPA3QslmtxXotofU+DyefC5uAXIkqMaHiIORAjmLGQY6GVj5O2kOPw9IDNo5iQJ2CtdWaCGOxNQojVLTV0NkZ2jUdma5MPZBqtE2vLkjMUFmSovmlYDUEgcHdnxWlkpFNaxAx44qbiHTm/fVZgAoKCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZ+JwSrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZ+JwSrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB36C433C7;
	Mon,  8 Apr 2024 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584156;
	bh=5+hH6tKnkCvPz4pZhqnYCW3bGWVWvwFb3nv4wis0s68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZ+JwSrmQKvRIGAoay5sPHodt6SKYhorpfj3Cq0sE1dbjj07LENkwyykQAhWiM7aQ
	 WJnYEs2YLfZa3d2DP8ClcGk0Bb6hDxwmAdMNgvRonw4b2vnlIZiOKGUmRp9baQgSGq
	 KZEnW8uHmaf2s8FAtOonDLD0bN5c63woDtMoWZOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.8 270/273] x86/boot: Move mem_encrypt= parsing to the decompressor
Date: Mon,  8 Apr 2024 14:59:05 +0200
Message-ID: <20240408125317.887274393@linuxfoundation.org>
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

commit cd0d9d92c8bb46e77de62efd7df13069ddd61e7d upstream.

The early SME/SEV code parses the command line very early, in order to
decide whether or not memory encryption should be enabled, which needs
to occur even before the initial page tables are created.

This is problematic for a number of reasons:
- this early code runs from the 1:1 mapping provided by the decompressor
  or firmware, which uses a different translation than the one assumed by
  the linker, and so the code needs to be built in a special way;
- parsing external input while the entire kernel image is still mapped
  writable is a bad idea in general, and really does not belong in
  security minded code;
- the current code ignores the built-in command line entirely (although
  this appears to be the case for the entire decompressor)

Given that the decompressor/EFI stub is an intrinsic part of the x86
bootable kernel image, move the command line parsing there and out of
the core kernel. This removes the need to build lib/cmdline.o in a
special way, or to use RIP-relative LEA instructions in inline asm
blocks.

This involves a new xloadflag in the setup header to indicate
that mem_encrypt=on appeared on the kernel command line.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240227151907.387873-17-ardb+git@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/misc.c         |   15 +++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h   |    1 +
 arch/x86/lib/Makefile                   |   13 -------------
 arch/x86/mm/mem_encrypt_identity.c      |   32 +++-----------------------------
 drivers/firmware/efi/libstub/x86-stub.c |    3 +++
 5 files changed, 22 insertions(+), 42 deletions(-)

--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -358,6 +358,19 @@ unsigned long decompress_kernel(unsigned
 }
 
 /*
+ * Set the memory encryption xloadflag based on the mem_encrypt= command line
+ * parameter, if provided.
+ */
+static void parse_mem_encrypt(struct setup_header *hdr)
+{
+	int on = cmdline_find_option_bool("mem_encrypt=on");
+	int off = cmdline_find_option_bool("mem_encrypt=off");
+
+	if (on > off)
+		hdr->xloadflags |= XLF_MEM_ENCRYPTION;
+}
+
+/*
  * The compressed kernel image (ZO), has been moved so that its position
  * is against the end of the buffer used to hold the uncompressed kernel
  * image (VO) and the execution environment (.bss, .brk), which makes sure
@@ -387,6 +400,8 @@ asmlinkage __visible void *extract_kerne
 	/* Clear flags intended for solely in-kernel use. */
 	boot_params_ptr->hdr.loadflags &= ~KASLR_FLAG;
 
+	parse_mem_encrypt(&boot_params_ptr->hdr);
+
 	sanitize_boot_params(boot_params_ptr);
 
 	if (boot_params_ptr->screen_info.orig_video_mode == 7) {
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -38,6 +38,7 @@
 #define XLF_EFI_KEXEC			(1<<4)
 #define XLF_5LEVEL			(1<<5)
 #define XLF_5LEVEL_ENABLED		(1<<6)
+#define XLF_MEM_ENCRYPTION		(1<<7)
 
 #ifndef __ASSEMBLY__
 
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,19 +14,6 @@ ifdef CONFIG_KCSAN
 CFLAGS_REMOVE_delay.o = $(CC_FLAGS_FTRACE)
 endif
 
-# Early boot use of cmdline; don't instrument it
-ifdef CONFIG_AMD_MEM_ENCRYPT
-KCOV_INSTRUMENT_cmdline.o := n
-KASAN_SANITIZE_cmdline.o  := n
-KCSAN_SANITIZE_cmdline.o  := n
-
-ifdef CONFIG_FUNCTION_TRACER
-CFLAGS_REMOVE_cmdline.o = -pg
-endif
-
-CFLAGS_cmdline.o := -fno-stack-protector -fno-jump-tables
-endif
-
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -43,7 +43,6 @@
 
 #include <asm/setup.h>
 #include <asm/sections.h>
-#include <asm/cmdline.h>
 #include <asm/coco.h>
 #include <asm/sev.h>
 
@@ -95,9 +94,6 @@ struct sme_populate_pgd_data {
  */
 static char sme_workarea[2 * PMD_SIZE] __section(".init.scratch");
 
-static char sme_cmdline_arg[] __initdata = "mem_encrypt";
-static char sme_cmdline_on[]  __initdata = "on";
-
 static void __init sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 {
 	unsigned long pgd_start, pgd_end, pgd_size;
@@ -504,11 +500,9 @@ void __init sme_encrypt_kernel(struct bo
 
 void __init sme_enable(struct boot_params *bp)
 {
-	const char *cmdline_ptr, *cmdline_arg, *cmdline_on;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned long feature_mask;
 	unsigned long me_mask;
-	char buffer[16];
 	bool snp;
 	u64 msr;
 
@@ -551,6 +545,9 @@ void __init sme_enable(struct boot_param
 
 	/* Check if memory encryption is enabled */
 	if (feature_mask == AMD_SME_BIT) {
+		if (!(bp->hdr.xloadflags & XLF_MEM_ENCRYPTION))
+			return;
+
 		/*
 		 * No SME if Hypervisor bit is set. This check is here to
 		 * prevent a guest from trying to enable SME. For running as a
@@ -570,31 +567,8 @@ void __init sme_enable(struct boot_param
 		msr = __rdmsr(MSR_AMD64_SYSCFG);
 		if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 			return;
-	} else {
-		/* SEV state cannot be controlled by a command line option */
-		goto out;
 	}
 
-	/*
-	 * Fixups have not been applied to phys_base yet and we're running
-	 * identity mapped, so we must obtain the address to the SME command
-	 * line argument data using rip-relative addressing.
-	 */
-	asm ("lea sme_cmdline_arg(%%rip), %0"
-	     : "=r" (cmdline_arg)
-	     : "p" (sme_cmdline_arg));
-	asm ("lea sme_cmdline_on(%%rip), %0"
-	     : "=r" (cmdline_on)
-	     : "p" (sme_cmdline_on));
-
-	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
-				     ((u64)bp->ext_cmd_line_ptr << 32));
-
-	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0 ||
-	    strncmp(buffer, cmdline_on, sizeof(buffer)))
-		return;
-
-out:
 	RIP_REL_REF(sme_me_mask) = me_mask;
 	physical_mask &= ~me_mask;
 	cc_vendor = CC_VENDOR_AMD;
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -890,6 +890,9 @@ void __noreturn efi_stub_entry(efi_handl
 		}
 	}
 
+	if (efi_mem_encrypt > 0)
+		hdr->xloadflags |= XLF_MEM_ENCRYPTION;
+
 	status = efi_decompress_kernel(&kernel_entry);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to decompress kernel\n");


