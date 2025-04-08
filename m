Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D487C27C865;
	Tue,  8 Apr 2025 12:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117066; cv=none; b=mvQUWHWuqVuDjPRNj7mtCl3CDEsDPFctxBwOxDzZungXx9ChwqTcd3VoUWQ6omjjM7VWF14BA7roFIQ7rWk5HPLSHKbV+N3Jq8Qon5TA3SoD0SIgzaugQSH9u3hzKeG269Ma7jSHhauGpXALvo3DjnOdczVgcthBuIzMXEJ5ucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117066; c=relaxed/simple;
	bh=ry4uMFKk6Eb/x9GyW01UiENsXsmR3XkY9g39OhBFPxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3y5FX8ik7iPWgzjgQK2Aj8YB/mg4BWQnh0pzmdA4X3jdKMMj1VmZS+kNg/4bYttl5I0nbCIVlWmyUMgb4wCRroMgKw7iEapj1sf4e8iv06Tsc86W9qPmH6W+oOP0z5BxbEJ0dItIn+1m3zaa2N8OU13z/l7LdL7val9SsdO25s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0c63NnJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0c63NnJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4CEC4CEE5;
	Tue,  8 Apr 2025 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117066;
	bh=ry4uMFKk6Eb/x9GyW01UiENsXsmR3XkY9g39OhBFPxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0c63NnJ4p9thX8DScDsHrmiN9gPkix7v8GdT7mEaGvVOKr94PzVTXwmptU80v2x68
	 GvXjMkJwzUpd/sVXV4slgE3sDq/62heI9bMX710s7sz1YGuG3QIkaYZiMQPQCo78/6
	 /vVSbXptc0GoPypiAQMfWLVDJcygpA18/PZ4mqtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Annapurve <vannapurve@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ryan Afranji <afranji@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 6.12 372/423] x86/tdx: Fix arch_safe_halt() execution for TDX VMs
Date: Tue,  8 Apr 2025 12:51:38 +0200
Message-ID: <20250408104854.535203190@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Vishal Annapurve <vannapurve@google.com>

commit 9f98a4f4e7216dbe366010b4cdcab6b220f229c4 upstream.

Direct HLT instruction execution causes #VEs for TDX VMs which is routed
to hypervisor via TDCALL. If HLT is executed in STI-shadow, resulting #VE
handler will enable interrupts before TDCALL is routed to hypervisor
leading to missed wakeup events, as current TDX spec doesn't expose
interruptibility state information to allow #VE handler to selectively
enable interrupts.

Commit bfe6ed0c6727 ("x86/tdx: Add HLT support for TDX guests")
prevented the idle routines from executing HLT instruction in STI-shadow.
But it missed the paravirt routine which can be reached via this path
as an example:

	kvm_wait()       =>
        safe_halt()      =>
        raw_safe_halt()  =>
        arch_safe_halt() =>
        irq.safe_halt()  =>
        pv_native_safe_halt()

To reliably handle arch_safe_halt() for TDX VMs, introduce explicit
dependency on CONFIG_PARAVIRT and override paravirt halt()/safe_halt()
routines with TDX-safe versions that execute direct TDCALL and needed
interrupt flag updates. Executing direct TDCALL brings in additional
benefit of avoiding HLT related #VEs altogether.

As tested by Ryan Afranji:

  "Tested with the specjbb2015 benchmark. It has heavy lock contention which leads
   to many halt calls. TDX VMs suffered a poor score before this patchset.

   Verified the major performance improvement with this patchset applied."

Fixes: bfe6ed0c6727 ("x86/tdx: Add HLT support for TDX guests")
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Ryan Afranji <afranji@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250228014416.3925664-3-vannapurve@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig           |    1 +
 arch/x86/coco/tdx/tdx.c    |   26 +++++++++++++++++++++++++-
 arch/x86/include/asm/tdx.h |    4 ++--
 arch/x86/kernel/process.c  |    2 +-
 4 files changed, 29 insertions(+), 4 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -894,6 +894,7 @@ config INTEL_TDX_GUEST
 	depends on X86_64 && CPU_SUP_INTEL
 	depends on X86_X2APIC
 	depends on EFI_STUB
+	depends on PARAVIRT
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select X86_MCE
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -14,6 +14,7 @@
 #include <asm/ia32.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
+#include <asm/paravirt_types.h>
 #include <asm/pgtable.h>
 #include <asm/set_memory.h>
 #include <asm/traps.h>
@@ -359,7 +360,7 @@ static int handle_halt(struct ve_info *v
 	return ve_instr_len(ve);
 }
 
-void __cpuidle tdx_safe_halt(void)
+void __cpuidle tdx_halt(void)
 {
 	const bool irq_disabled = false;
 
@@ -370,6 +371,16 @@ void __cpuidle tdx_safe_halt(void)
 		WARN_ONCE(1, "HLT instruction emulation failed\n");
 }
 
+static void __cpuidle tdx_safe_halt(void)
+{
+	tdx_halt();
+	/*
+	 * "__cpuidle" section doesn't support instrumentation, so stick
+	 * with raw_* variant that avoids tracing hooks.
+	 */
+	raw_local_irq_enable();
+}
+
 static int read_msr(struct pt_regs *regs, struct ve_info *ve)
 {
 	struct tdx_module_args args = {
@@ -1057,6 +1068,19 @@ void __init tdx_early_init(void)
 	x86_platform.guest.enc_kexec_finish	     = tdx_kexec_finish;
 
 	/*
+	 * Avoid "sti;hlt" execution in TDX guests as HLT induces a #VE that
+	 * will enable interrupts before HLT TDCALL invocation if executed
+	 * in STI-shadow, possibly resulting in missed wakeup events.
+	 *
+	 * Modify all possible HLT execution paths to use TDX specific routines
+	 * that directly execute TDCALL and toggle the interrupt state as
+	 * needed after TDCALL completion. This also reduces HLT related #VEs
+	 * in addition to having a reliable halt logic execution.
+	 */
+	pv_ops.irq.safe_halt = tdx_safe_halt;
+	pv_ops.irq.halt = tdx_halt;
+
+	/*
 	 * TDX intercepts the RDMSR to read the X2APIC ID in the parallel
 	 * bringup low level code. That raises #VE which cannot be handled
 	 * there.
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -58,7 +58,7 @@ void tdx_get_ve_info(struct ve_info *ve)
 
 bool tdx_handle_virt_exception(struct pt_regs *regs, struct ve_info *ve);
 
-void tdx_safe_halt(void);
+void tdx_halt(void);
 
 bool tdx_early_handle_ve(struct pt_regs *regs);
 
@@ -69,7 +69,7 @@ u64 tdx_hcall_get_quote(u8 *buf, size_t
 #else
 
 static inline void tdx_early_init(void) { };
-static inline void tdx_safe_halt(void) { };
+static inline void tdx_halt(void) { };
 
 static inline bool tdx_early_handle_ve(struct pt_regs *regs) { return false; }
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -938,7 +938,7 @@ void __init select_idle_routine(void)
 		static_call_update(x86_idle, mwait_idle);
 	} else if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
 		pr_info("using TDX aware idle routine\n");
-		static_call_update(x86_idle, tdx_safe_halt);
+		static_call_update(x86_idle, tdx_halt);
 	} else {
 		static_call_update(x86_idle, default_idle);
 	}


