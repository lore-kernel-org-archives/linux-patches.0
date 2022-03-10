Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727C85A39
	for <patches@lists.linux.dev>; Thu, 10 Mar 2022 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646945346; x=1678481346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KRMDn0WMJL9ra8G8+QzHxQoTSxBFdSyU1WmgdWNLOTU=;
  b=GaSWFKpZPDmJ4wTmbUSRUjbWALxSgpFSYiwxjidj4FHUEHQOPJMk1xJ1
   t1qv1QVBqiFJpqNhl+7Dzy68s1hoI0vQj8pcjc+1M6k17bVvaEPimbEoZ
   6anpFDJQd8WA97m3PIDYnPliQwmtKgAkbJv77RpoyIp8QSTMqU/dE4H0o
   vGchptneJr1j4uzmMXqcfqedoX1aypfZ2fWd9hIsAzxPlU2QS4ZcSdgfg
   zn1swTt5G+uD6pxuvwHr4a0QlX20kL5tFVtY3CgSu7Z8jMnVetqvv1H2v
   1YnP8mpuF1UnMCnJfde+h/3T7MBa053YvPbEEv6xhfrprqL+1TROzvUm1
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="280117472"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="280117472"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 12:49:03 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="554843297"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 12:49:03 -0800
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 2/2] x86/split-lock: Remove unused TIF_SLD bit
Date: Thu, 10 Mar 2022 12:48:54 -0800
Message-Id: <20220310204854.31752-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310204854.31752-1-tony.luck@intel.com>
References: <20220217012721.9694-1-tony.luck@intel.com>
 <20220310204854.31752-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes to the "warn" mode of split lock handling mean that
TIF_SLD is never set.

Remove the bit, and the functions that use it.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpu.h         |  2 --
 arch/x86/include/asm/thread_info.h |  4 +---
 arch/x86/kernel/cpu/intel.c        | 12 ------------
 arch/x86/kernel/process.c          |  3 ---
 4 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 33d41e350c79..e346f5c103b7 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -42,14 +42,12 @@ unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
 #ifdef CONFIG_CPU_SUP_INTEL
 extern void __init sld_setup(struct cpuinfo_x86 *c);
-extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 extern bool handle_guest_split_lock(unsigned long ip);
 extern void handle_bus_lock(struct pt_regs *regs);
 u8 get_this_hybrid_cpu_type(void);
 #else
 static inline void __init sld_setup(struct cpuinfo_x86 *c) {}
-static inline void switch_to_sld(unsigned long tifn) {}
 static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
 {
 	return false;
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index ebec69c35e95..f0cb881c1d69 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -92,7 +92,6 @@ struct thread_info {
 #define TIF_NOCPUID		15	/* CPUID is not accessible in userland */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_NOTIFY_SIGNAL	17	/* signal notifications exist */
-#define TIF_SLD			18	/* Restore split lock detection on context switch */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	21	/* idle is polling for TIF_NEED_RESCHED */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -116,7 +115,6 @@ struct thread_info {
 #define _TIF_NOCPUID		(1 << TIF_NOCPUID)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
-#define _TIF_SLD		(1 << TIF_SLD)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_SPEC_FORCE_UPDATE	(1 << TIF_SPEC_FORCE_UPDATE)
@@ -128,7 +126,7 @@ struct thread_info {
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW_BASE					\
 	(_TIF_NOCPUID | _TIF_NOTSC | _TIF_BLOCKSTEP |		\
-	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE | _TIF_SLD)
+	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE)
 
 /*
  * Avoid calls to __switch_to_xtra() on UP as STIBP is not evaluated.
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2536784511e3..7cba84616c20 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1241,18 +1241,6 @@ void handle_bus_lock(struct pt_regs *regs)
 	}
 }
 
-/*
- * This function is called only when switching between tasks with
- * different split-lock detection modes. It sets the MSR for the
- * mode of the new task. This is right most of the time, but since
- * the MSR is shared by hyperthreads on a physical core there can
- * be glitches when the two threads need different modes.
- */
-void switch_to_sld(unsigned long tifn)
-{
-	sld_update_msr(!(tifn & _TIF_SLD));
-}
-
 /*
  * Bits in the IA32_CORE_CAPABILITIES are not architectural, so they should
  * only be trusted if it is confirmed that a CPU model implements a
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 81d8ef036637..47db777da92a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -686,9 +686,6 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p)
 		/* Enforce MSR update to ensure consistent state */
 		__speculation_ctrl_update(~tifn, tifn);
 	}
-
-	if ((tifp ^ tifn) & _TIF_SLD)
-		switch_to_sld(tifn);
 }
 
 /*
-- 
2.35.1

