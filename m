Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B531C173C;
	Mon, 12 May 2025 17:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072089; cv=none; b=OTq/e4aHgpZC1DoP08hoVhSq2WYDIXAmd39tpzL+VnaLUMcDQSyPShJ8jLkjkx2+/RgAl2olvGxYiahRiJv9xKYuIIicomFasOIsJLDlM6GZLkt4UMclIhp6VobIIHan2Km0tpj8Ou6xNcrQf+jbfVWs9MMKRyTNfOHUAea9+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072089; c=relaxed/simple;
	bh=7a9GSFACxSr+4zBtjyAicL+o9vSYtyZD6OYgtjNhbAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMV3amYEyktaFmSSbBnF36JbeBBsKMdgGrSfKaLSnQBLGkrFPPVQ7flPJ6E36CMmTGmR3x3fn27zI52VBtIW9Y1KbUjeAWnw0MMftg27FJpY1NY507gOuygsTjBHQ7S9habCJx36LCBDiqBiz3jC7TBiu8ruy2rfJ7jZUHD1ayw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF9n0pQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF9n0pQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C482C4CEE7;
	Mon, 12 May 2025 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072087;
	bh=7a9GSFACxSr+4zBtjyAicL+o9vSYtyZD6OYgtjNhbAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF9n0pQJzpYMrA2Mo6mqMnXmqrFcuTibm3EDb7GDJCTecGe5JZg7RkfrIWUeksJB3
	 OY6UnC3AAV5Ls3iMANZoDIjuVPWmrH7bn7BFbPMaRBUfQA732+RffZO8Bpo8Qtojbs
	 OcgtSkln0tfaIKjK1scYN6c+uoCEgYerrIxKqHS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.14 128/197] x86/microcode: Consolidate the loader enablement checking
Date: Mon, 12 May 2025 19:39:38 +0200
Message-ID: <20250512172049.605210923@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 5214a9f6c0f56644acb9d2cbb58facf1856d322b upstream.

Consolidate the whole logic which determines whether the microcode loader
should be enabled or not into a single function and call it everywhere.

Well, almost everywhere - not in mk_early_pgtbl_32() because there the kernel
is running without paging enabled and checking dis_ucode_ldr et al would
require physical addresses and uglification of the code.

But since this is 32-bit, the easier thing to do is to simply map the initrd
unconditionally especially since that mapping is getting removed later anyway
by zap_early_initrd_mapping() and avoid the uglification.

In doing so, address the issue of old 486er machines without CPUID
support, not booting current kernels.

  [ mingo: Fix no previous prototype for ‘microcode_loader_disabled’ [-Wmissing-prototypes] ]

Fixes: 4c585af7180c1 ("x86/boot/32: Temporarily map initrd for microcode loading")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/CANpbe9Wm3z8fy9HbgS8cuhoj0TREYEEkBipDuhgkWFvqX0UoVQ@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/microcode.h         |    2 +
 arch/x86/kernel/cpu/microcode/amd.c      |    6 ++-
 arch/x86/kernel/cpu/microcode/core.c     |   58 ++++++++++++++++++-------------
 arch/x86/kernel/cpu/microcode/intel.c    |    2 -
 arch/x86/kernel/cpu/microcode/internal.h |    1 
 arch/x86/kernel/head32.c                 |    4 --
 6 files changed, 41 insertions(+), 32 deletions(-)

--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -17,10 +17,12 @@ struct ucode_cpu_info {
 void load_ucode_bsp(void);
 void load_ucode_ap(void);
 void microcode_bsp_resume(void);
+bool __init microcode_loader_disabled(void);
 #else
 static inline void load_ucode_bsp(void)	{ }
 static inline void load_ucode_ap(void) { }
 static inline void microcode_bsp_resume(void) { }
+static inline bool __init microcode_loader_disabled(void) { return false; }
 #endif
 
 extern unsigned long initrd_start_early;
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -1098,15 +1098,17 @@ static enum ucode_state load_microcode_a
 
 static int __init save_microcode_in_initrd(void)
 {
-	unsigned int cpuid_1_eax = native_cpuid_eax(1);
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	struct cont_desc desc = { 0 };
+	unsigned int cpuid_1_eax;
 	enum ucode_state ret;
 	struct cpio_data cp;
 
-	if (dis_ucode_ldr || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
+	if (microcode_loader_disabled() || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
 		return 0;
 
+	cpuid_1_eax = native_cpuid_eax(1);
+
 	if (!find_blobs_in_containers(&cp))
 		return -EINVAL;
 
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -41,8 +41,8 @@
 
 #include "internal.h"
 
-static struct microcode_ops	*microcode_ops;
-bool dis_ucode_ldr = true;
+static struct microcode_ops *microcode_ops;
+static bool dis_ucode_ldr = false;
 
 bool force_minrev = IS_ENABLED(CONFIG_MICROCODE_LATE_FORCE_MINREV);
 module_param(force_minrev, bool, S_IRUSR | S_IWUSR);
@@ -84,6 +84,9 @@ static bool amd_check_current_patch_leve
 	u32 lvl, dummy, i;
 	u32 *levels;
 
+	if (x86_cpuid_vendor() != X86_VENDOR_AMD)
+		return false;
+
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, lvl, dummy);
 
 	levels = final_levels;
@@ -95,27 +98,29 @@ static bool amd_check_current_patch_leve
 	return false;
 }
 
-static bool __init check_loader_disabled_bsp(void)
+bool __init microcode_loader_disabled(void)
 {
-	static const char *__dis_opt_str = "dis_ucode_ldr";
-	const char *cmdline = boot_command_line;
-	const char *option  = __dis_opt_str;
+	if (dis_ucode_ldr)
+		return true;
 
 	/*
-	 * CPUID(1).ECX[31]: reserved for hypervisor use. This is still not
-	 * completely accurate as xen pv guests don't see that CPUID bit set but
-	 * that's good enough as they don't land on the BSP path anyway.
+	 * Disable when:
+	 *
+	 * 1) The CPU does not support CPUID.
+	 *
+	 * 2) Bit 31 in CPUID[1]:ECX is clear
+	 *    The bit is reserved for hypervisor use. This is still not
+	 *    completely accurate as XEN PV guests don't see that CPUID bit
+	 *    set, but that's good enough as they don't land on the BSP
+	 *    path anyway.
+	 *
+	 * 3) Certain AMD patch levels are not allowed to be
+	 *    overwritten.
 	 */
-	if (native_cpuid_ecx(1) & BIT(31))
-		return true;
-
-	if (x86_cpuid_vendor() == X86_VENDOR_AMD) {
-		if (amd_check_current_patch_level())
-			return true;
-	}
-
-	if (cmdline_find_option_bool(cmdline, option) <= 0)
-		dis_ucode_ldr = false;
+	if (!have_cpuid_p() ||
+	    native_cpuid_ecx(1) & BIT(31) ||
+	    amd_check_current_patch_level())
+		dis_ucode_ldr = true;
 
 	return dis_ucode_ldr;
 }
@@ -125,7 +130,10 @@ void __init load_ucode_bsp(void)
 	unsigned int cpuid_1_eax;
 	bool intel = true;
 
-	if (!have_cpuid_p())
+	if (cmdline_find_option_bool(boot_command_line, "dis_ucode_ldr") > 0)
+		dis_ucode_ldr = true;
+
+	if (microcode_loader_disabled())
 		return;
 
 	cpuid_1_eax = native_cpuid_eax(1);
@@ -146,9 +154,6 @@ void __init load_ucode_bsp(void)
 		return;
 	}
 
-	if (check_loader_disabled_bsp())
-		return;
-
 	if (intel)
 		load_ucode_intel_bsp(&early_data);
 	else
@@ -159,6 +164,11 @@ void load_ucode_ap(void)
 {
 	unsigned int cpuid_1_eax;
 
+	/*
+	 * Can't use microcode_loader_disabled() here - .init section
+	 * hell. It doesn't have to either - the BSP variant must've
+	 * parsed cmdline already anyway.
+	 */
 	if (dis_ucode_ldr)
 		return;
 
@@ -810,7 +820,7 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	int error;
 
-	if (dis_ucode_ldr)
+	if (microcode_loader_disabled())
 		return -EINVAL;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -389,7 +389,7 @@ static int __init save_builtin_microcode
 	if (xchg(&ucode_patch_va, NULL) != UCODE_BSP_LOADED)
 		return 0;
 
-	if (dis_ucode_ldr || boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+	if (microcode_loader_disabled() || boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return 0;
 
 	uci.mc = get_microcode_blob(&uci, true);
--- a/arch/x86/kernel/cpu/microcode/internal.h
+++ b/arch/x86/kernel/cpu/microcode/internal.h
@@ -94,7 +94,6 @@ static inline unsigned int x86_cpuid_fam
 	return x86_family(eax);
 }
 
-extern bool dis_ucode_ldr;
 extern bool force_minrev;
 
 #ifdef CONFIG_CPU_SUP_AMD
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -145,10 +145,6 @@ void __init __no_stack_protector mk_earl
 	*ptr = (unsigned long)ptep + PAGE_OFFSET;
 
 #ifdef CONFIG_MICROCODE_INITRD32
-	/* Running on a hypervisor? */
-	if (native_cpuid_ecx(1) & BIT(31))
-		return;
-
 	params = (struct boot_params *)__pa_nodebug(&boot_params);
 	if (!params->hdr.ramdisk_size || !params->hdr.ramdisk_image)
 		return;


