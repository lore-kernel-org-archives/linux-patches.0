Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C3C2E2F0D;
	Tue,  8 Jul 2025 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994192; cv=none; b=iUzXeu7UvEReKv3tEfL688VJTR/hJbjQQU2IIjU1qLizIezo5R/PoxRHbYxJ+6syv5s3mR9iA0iuvhcnTcOUIlY7XcJ+8D7MfrxARB3ExGRSAsJAcKG4WhoC6QOjxTYOS5tUUKCwS7kxho9lAOQnE3+D9aBaFQvuDqQLr5v9kZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994192; c=relaxed/simple;
	bh=om+sMYmpQD5C8MqdM2tpHMveV4Buc1wiPanDSic2a0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8NUAgz54XennEAKWNbAik31UUnrMVHYsLUlcRO0g7mzwSi/+S5Dsxl9IA6v1eCFtcrbop169PFMBqncSX1yK13dVeCFnhsP6RUkBl8F34IaEVYuM6uLdaHAp38K1JbTlwd7WqYBKo9tv50IYXq1AygLHh+cUBDOjIHUEO1S3WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3AKOQx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3AKOQx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D889C4CEED;
	Tue,  8 Jul 2025 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994191;
	bh=om+sMYmpQD5C8MqdM2tpHMveV4Buc1wiPanDSic2a0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3AKOQx5gkvcIqz4/OR0yYgFpC+YaPw6OWhW8e4+sRaqJ+aVuuTupA8oSnwvBHVUt
	 /REKjHpewcDcFAGpv2/Wb6JsZkozttvaJ6KzusyJlRv9GEldd0gE4mvgaTwhK7rOyn
	 2DGyq4AMi6y6IZR/KrKbrj4jD5CU3f4oUkeJzEqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.15 156/160] x86/bugs: Rename MDS machinery to something more generic
Date: Tue,  8 Jul 2025 18:23:13 +0200
Message-ID: <20250708162235.623653142@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit f9af88a3d384c8b55beb5dc5483e5da0135fadbd upstream.

It will be used by other x86 mitigations.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst |    4 -
 arch/x86/entry/entry.S                                          |    8 +-
 arch/x86/include/asm/irqflags.h                                 |    4 -
 arch/x86/include/asm/mwait.h                                    |    5 +
 arch/x86/include/asm/nospec-branch.h                            |   29 +++++-----
 arch/x86/kernel/cpu/bugs.c                                      |   12 ++--
 arch/x86/kvm/vmx/vmx.c                                          |    2 
 7 files changed, 32 insertions(+), 32 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
+++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
@@ -157,9 +157,7 @@ This is achieved by using the otherwise
 combination with a microcode update. The microcode clears the affected CPU
 buffers when the VERW instruction is executed.
 
-Kernel reuses the MDS function to invoke the buffer clearing:
-
-	mds_clear_cpu_buffers()
+Kernel does the buffer clearing with x86_clear_cpu_buffers().
 
 On MDS affected CPUs, the kernel already invokes CPU buffer clear on
 kernel/userspace, hypervisor/guest and C-state (idle) transitions. No
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -31,20 +31,20 @@ EXPORT_SYMBOL_GPL(entry_ibpb);
 
 /*
  * Define the VERW operand that is disguised as entry code so that
- * it can be referenced with KPTI enabled. This ensure VERW can be
+ * it can be referenced with KPTI enabled. This ensures VERW can be
  * used late in exit-to-user path after page tables are switched.
  */
 .pushsection .entry.text, "ax"
 
 .align L1_CACHE_BYTES, 0xcc
-SYM_CODE_START_NOALIGN(mds_verw_sel)
+SYM_CODE_START_NOALIGN(x86_verw_sel)
 	UNWIND_HINT_EMPTY
 	ANNOTATE_NOENDBR
 	.word __KERNEL_DS
 .align L1_CACHE_BYTES, 0xcc
-SYM_CODE_END(mds_verw_sel);
+SYM_CODE_END(x86_verw_sel);
 /* For KVM */
-EXPORT_SYMBOL_GPL(mds_verw_sel);
+EXPORT_SYMBOL_GPL(x86_verw_sel);
 
 .popsection
 
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -47,13 +47,13 @@ static __always_inline void native_irq_e
 
 static inline __cpuidle void native_safe_halt(void)
 {
-	mds_idle_clear_cpu_buffers();
+	x86_idle_clear_cpu_buffers();
 	asm volatile("sti; hlt": : :"memory");
 }
 
 static inline __cpuidle void native_halt(void)
 {
-	mds_idle_clear_cpu_buffers();
+	x86_idle_clear_cpu_buffers();
 	asm volatile("hlt": : :"memory");
 }
 
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -43,7 +43,7 @@ static inline void __monitorx(const void
 
 static inline void __mwait(unsigned long eax, unsigned long ecx)
 {
-	mds_idle_clear_cpu_buffers();
+	x86_idle_clear_cpu_buffers();
 
 	/* "mwait %eax, %ecx;" */
 	asm volatile(".byte 0x0f, 0x01, 0xc9;"
@@ -88,7 +88,8 @@ static inline void __mwaitx(unsigned lon
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
-	mds_idle_clear_cpu_buffers();
+	x86_idle_clear_cpu_buffers();
+
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -202,23 +202,23 @@
 .endm
 
 /*
- * Macro to execute VERW instruction that mitigate transient data sampling
- * attacks such as MDS. On affected systems a microcode update overloaded VERW
- * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
- *
+ * Macro to execute VERW insns that mitigate transient data sampling
+ * attacks such as MDS or TSA. On affected systems a microcode update
+ * overloaded VERW insns to also clear the CPU buffers. VERW clobbers
+ * CFLAGS.ZF.
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
 .macro CLEAR_CPU_BUFFERS
 	ALTERNATIVE "jmp .Lskip_verw_\@", "", X86_FEATURE_CLEAR_CPU_BUF
 #ifdef CONFIG_X86_64
-	verw mds_verw_sel(%rip)
+	verw x86_verw_sel(%rip)
 #else
 	/*
 	 * In 32bit mode, the memory operand must be a %cs reference. The data
 	 * segments may not be usable (vm86 mode), and the stack segment may not
 	 * be flat (ESPFIX32).
 	 */
-	verw %cs:mds_verw_sel
+	verw %cs:x86_verw_sel
 #endif
 .Lskip_verw_\@:
 .endm
@@ -429,24 +429,24 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
-DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
+DECLARE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
 DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
 
-extern u16 mds_verw_sel;
+extern u16 x86_verw_sel;
 
 #include <asm/segment.h>
 
 /**
- * mds_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
+ * x86_clear_cpu_buffers - Buffer clearing support for different x86 CPU vulns
  *
  * This uses the otherwise unused and obsolete VERW instruction in
  * combination with microcode which triggers a CPU buffer flush when the
  * instruction is executed.
  */
-static __always_inline void mds_clear_cpu_buffers(void)
+static __always_inline void x86_clear_cpu_buffers(void)
 {
 	static const u16 ds = __KERNEL_DS;
 
@@ -463,14 +463,15 @@ static __always_inline void mds_clear_cp
 }
 
 /**
- * mds_idle_clear_cpu_buffers - Mitigation for MDS vulnerability
+ * x86_idle_clear_cpu_buffers - Buffer clearing support in idle for the MDS
+ * vulnerability
  *
  * Clear CPU buffers if the corresponding static key is enabled
  */
-static inline void mds_idle_clear_cpu_buffers(void)
+static __always_inline void x86_idle_clear_cpu_buffers(void)
 {
-	if (static_branch_likely(&mds_idle_clear))
-		mds_clear_cpu_buffers();
+	if (static_branch_likely(&cpu_buf_idle_clear))
+		x86_clear_cpu_buffers();
 }
 
 #endif /* __ASSEMBLY__ */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -121,9 +121,9 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_i
 /* Control unconditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
-/* Control MDS CPU buffer clear before idling (halt, mwait) */
-DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
-EXPORT_SYMBOL_GPL(mds_idle_clear);
+/* Control CPU buffer clear before idling (halt, mwait) */
+DEFINE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
+EXPORT_SYMBOL_GPL(cpu_buf_idle_clear);
 
 /*
  * Controls whether l1d flush based mitigations are enabled,
@@ -451,7 +451,7 @@ static void __init mmio_select_mitigatio
 	 * is required irrespective of SMT state.
 	 */
 	if (!(x86_arch_cap_msr & ARCH_CAP_FBSDP_NO))
-		static_branch_enable(&mds_idle_clear);
+		static_branch_enable(&cpu_buf_idle_clear);
 
 	/*
 	 * Check if the system has the right microcode.
@@ -2028,10 +2028,10 @@ static void update_mds_branch_idle(void)
 		return;
 
 	if (sched_smt_active()) {
-		static_branch_enable(&mds_idle_clear);
+		static_branch_enable(&cpu_buf_idle_clear);
 	} else if (mmio_mitigation == MMIO_MITIGATION_OFF ||
 		   (x86_arch_cap_msr & ARCH_CAP_FBSDP_NO)) {
-		static_branch_disable(&mds_idle_clear);
+		static_branch_disable(&cpu_buf_idle_clear);
 	}
 }
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6771,7 +6771,7 @@ static noinstr void vmx_vcpu_enter_exit(
 		vmx_l1d_flush(vcpu);
 	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))
-		mds_clear_cpu_buffers();
+		x86_clear_cpu_buffers();
 
 	vmx_disable_fb_clear(vmx);
 


