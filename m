Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E781CF5FB;
	Wed,  2 Oct 2024 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880539; cv=none; b=T7jUYQEgnj0diEOo8GryWVga809LcngnJxbSWpU+PWPijbMB1yVBmlAXZh711hDMfEY4g3Wycfh9KwZbn7pKoqrQI5E8lETneo80ESLdXyMn/6RK53nhGLeA2kIl5MDqgFGdrS6sa+Aj0L1UiuxHQOn3IvCgnsNhYQPvVU3I0ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880539; c=relaxed/simple;
	bh=v7VgmKYfQC12GswE4Le3tXZ1r37Kk9OLq1Pw/GC+Huo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Edsng+d7h4GgZbLeS2OccXIheRaTJFCYaKrOAfyrdSidGZkSEak9woK2LA58Wrt3tGzLwnmUtKov4lLvKd6x/2nM0/0cik27uRv1O+jaL/V7I/97Kw73itrXBAXsd0nYZIbvA77LZFcgRN/VFnOctQ3l194WZLyN1aIjbYVXzIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLKzJ3/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLKzJ3/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8732BC4CEC2;
	Wed,  2 Oct 2024 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880538;
	bh=v7VgmKYfQC12GswE4Le3tXZ1r37Kk9OLq1Pw/GC+Huo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLKzJ3/D88+CO2ERHfc6Vsc0fQykrb+TYrhdkQ+ESMApEQAZ5zCdz9Yd0QcMteamd
	 nqz/aW9wi3Ec+nD02sdo3WSMqjd2gybahib3P33/Yp3NXwq/lMEXdQctR1azmrhGlI
	 CQLw/QEUK/3ycTx2SWIi8nSONSipn69mE49tuKCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Xin Li <xin3.li@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shan Kang <shan.kang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 493/538] x86/idtentry: Incorporate definitions/declarations of the FRED entries
Date: Wed,  2 Oct 2024 15:02:12 +0200
Message-ID: <20241002125811.900169258@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Xin Li <xin3.li@intel.com>

[ Upstream commit 90f357208200a941e90e75757123326684d715d0 ]

FRED and IDT can share most of the definitions and declarations so
that in the majority of cases the actual handler implementation is the
same.

The differences are the exceptions where FRED stores exception related
information on the stack and the sysvec implementations as FRED can
handle irqentry/exit() in the dispatcher instead of having it in each
handler.

Also add stub defines for vectors which are not used due to Kconfig
decisions to spare the ifdeffery in the actual FRED dispatch code.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Shan Kang <shan.kang@intel.com>
Link: https://lore.kernel.org/r/20231205105030.8698-23-xin3.li@intel.com
Stable-dep-of: 477d81a1c47a ("x86/entry: Remove unwanted instrumentation in common_interrupt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/idtentry.h | 71 +++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 13639e57e1f8a..e2585f61082cd 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -13,15 +13,18 @@
 
 #include <asm/irq_stack.h>
 
+typedef void (*idtentry_t)(struct pt_regs *regs);
+
 /**
  * DECLARE_IDTENTRY - Declare functions for simple IDT entry points
  *		      No error code pushed by hardware
  * @vector:	Vector number (ignored for C)
  * @func:	Function name of the entry point
  *
- * Declares three functions:
+ * Declares four functions:
  * - The ASM entry point: asm_##func
  * - The XEN PV trap entry point: xen_##func (maybe unused)
+ * - The C handler called from the FRED event dispatcher (maybe unused)
  * - The C handler called from the ASM entry point
  *
  * Note: This is the C variant of DECLARE_IDTENTRY(). As the name says it
@@ -31,6 +34,7 @@
 #define DECLARE_IDTENTRY(vector, func)					\
 	asmlinkage void asm_##func(void);				\
 	asmlinkage void xen_asm_##func(void);				\
+	void fred_##func(struct pt_regs *regs);				\
 	__visible void func(struct pt_regs *regs)
 
 /**
@@ -137,6 +141,17 @@ static __always_inline void __##func(struct pt_regs *regs,		\
 #define DEFINE_IDTENTRY_RAW(func)					\
 __visible noinstr void func(struct pt_regs *regs)
 
+/**
+ * DEFINE_FREDENTRY_RAW - Emit code for raw FRED entry points
+ * @func:	Function name of the entry point
+ *
+ * @func is called from the FRED event dispatcher with interrupts disabled.
+ *
+ * See @DEFINE_IDTENTRY_RAW for further details.
+ */
+#define DEFINE_FREDENTRY_RAW(func)					\
+noinstr void fred_##func(struct pt_regs *regs)
+
 /**
  * DECLARE_IDTENTRY_RAW_ERRORCODE - Declare functions for raw IDT entry points
  *				    Error code pushed by hardware
@@ -233,17 +248,27 @@ static noinline void __##func(struct pt_regs *regs, u32 vector)
 #define DEFINE_IDTENTRY_SYSVEC(func)					\
 static void __##func(struct pt_regs *regs);				\
 									\
+static __always_inline void instr_##func(struct pt_regs *regs)		\
+{									\
+	kvm_set_cpu_l1tf_flush_l1d();					\
+	run_sysvec_on_irqstack_cond(__##func, regs);			\
+}									\
+									\
 __visible noinstr void func(struct pt_regs *regs)			\
 {									\
 	irqentry_state_t state = irqentry_enter(regs);			\
 									\
 	instrumentation_begin();					\
-	kvm_set_cpu_l1tf_flush_l1d();					\
-	run_sysvec_on_irqstack_cond(__##func, regs);			\
+	instr_##func (regs);						\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+void fred_##func(struct pt_regs *regs)					\
+{									\
+	instr_##func (regs);						\
+}									\
+									\
 static noinline void __##func(struct pt_regs *regs)
 
 /**
@@ -260,19 +285,29 @@ static noinline void __##func(struct pt_regs *regs)
 #define DEFINE_IDTENTRY_SYSVEC_SIMPLE(func)				\
 static __always_inline void __##func(struct pt_regs *regs);		\
 									\
-__visible noinstr void func(struct pt_regs *regs)			\
+static __always_inline void instr_##func(struct pt_regs *regs)		\
 {									\
-	irqentry_state_t state = irqentry_enter(regs);			\
-									\
-	instrumentation_begin();					\
 	__irq_enter_raw();						\
 	kvm_set_cpu_l1tf_flush_l1d();					\
 	__##func (regs);						\
 	__irq_exit_raw();						\
+}									\
+									\
+__visible noinstr void func(struct pt_regs *regs)			\
+{									\
+	irqentry_state_t state = irqentry_enter(regs);			\
+									\
+	instrumentation_begin();					\
+	instr_##func (regs);						\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+void fred_##func(struct pt_regs *regs)					\
+{									\
+	instr_##func (regs);						\
+}									\
+									\
 static __always_inline void __##func(struct pt_regs *regs)
 
 /**
@@ -410,15 +445,18 @@ __visible noinstr void func(struct pt_regs *regs,			\
 /* C-Code mapping */
 #define DECLARE_IDTENTRY_NMI		DECLARE_IDTENTRY_RAW
 #define DEFINE_IDTENTRY_NMI		DEFINE_IDTENTRY_RAW
+#define DEFINE_FREDENTRY_NMI		DEFINE_FREDENTRY_RAW
 
 #ifdef CONFIG_X86_64
 #define DECLARE_IDTENTRY_MCE		DECLARE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_MCE		DEFINE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_MCE_USER	DEFINE_IDTENTRY_NOIST
+#define DEFINE_FREDENTRY_MCE		DEFINE_FREDENTRY_RAW
 
 #define DECLARE_IDTENTRY_DEBUG		DECLARE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_DEBUG		DEFINE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_DEBUG_USER	DEFINE_IDTENTRY_NOIST
+#define DEFINE_FREDENTRY_DEBUG		DEFINE_FREDENTRY_RAW
 #endif
 
 #else /* !__ASSEMBLY__ */
@@ -655,23 +693,36 @@ DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
+#else
+# define fred_sysvec_reschedule_ipi			NULL
+# define fred_sysvec_reboot				NULL
+# define fred_sysvec_call_function_single		NULL
+# define fred_sysvec_call_function			NULL
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
 # ifdef CONFIG_X86_MCE_THRESHOLD
 DECLARE_IDTENTRY_SYSVEC(THRESHOLD_APIC_VECTOR,		sysvec_threshold);
+# else
+# define fred_sysvec_threshold				NULL
 # endif
 
 # ifdef CONFIG_X86_MCE_AMD
 DECLARE_IDTENTRY_SYSVEC(DEFERRED_ERROR_VECTOR,		sysvec_deferred_error);
+# else
+# define fred_sysvec_deferred_error			NULL
 # endif
 
 # ifdef CONFIG_X86_THERMAL_VECTOR
 DECLARE_IDTENTRY_SYSVEC(THERMAL_APIC_VECTOR,		sysvec_thermal);
+# else
+# define fred_sysvec_thermal				NULL
 # endif
 
 # ifdef CONFIG_IRQ_WORK
 DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
+# else
+# define fred_sysvec_irq_work				NULL
 # endif
 #endif
 
@@ -679,12 +730,16 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
+#else
+# define fred_sysvec_kvm_posted_intr_ipi		NULL
+# define fred_sysvec_kvm_posted_intr_wakeup_ipi		NULL
+# define fred_sysvec_kvm_posted_intr_nested_ipi		NULL
 #endif
 
 #if IS_ENABLED(CONFIG_HYPERV)
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_hyperv_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERV_REENLIGHTENMENT_VECTOR,	sysvec_hyperv_reenlightenment);
-DECLARE_IDTENTRY_SYSVEC(HYPERV_STIMER0_VECTOR,	sysvec_hyperv_stimer0);
+DECLARE_IDTENTRY_SYSVEC(HYPERV_STIMER0_VECTOR,		sysvec_hyperv_stimer0);
 #endif
 
 #if IS_ENABLED(CONFIG_ACRN_GUEST)
-- 
2.43.0



