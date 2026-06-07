Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E8D285CAE;
	Sun,  7 Jun 2026 10:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827114; cv=none; b=FoyhXu0b2AtQCQUxvQWKLIGncBgUCjRy52lV0P49Ix2bYidJIjuUJiaum4bmXJT214xMMf7/4ztR7F4NmR0fmOxJ2fRYhBhHuf3tuHe0NVpDLnICmKNCnuqk/xsroftFD/9G0NZapLOxoQoHpekh8iu0V5nFQWBrhOSpuOkB5sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827114; c=relaxed/simple;
	bh=1owdu1h61NXLODrrbs8zb0mY+XrxQPNrjWwRM7zv96k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3arT6gJJaJz8srUMY0s4IRxjGTywXIBc+foeuPSxjSfbiV/7r0UNwhI8hMi7TSWdsb7xZAzT07/WUjlMZmNEogNeD5Gn+IK0nX0CttMEZwURNdbW+omQaGBysaz9z3GPvVqpB8TdGM8BIv8jUN7zu8EYbvfdmCVdKxJwS+PzYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQQR+pPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQQR+pPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7AF1F00893;
	Sun,  7 Jun 2026 10:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827112;
	bh=m6kLgBGPjv75PB+8odh7YIy+W44cP8xcVKxBelT/mOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQQR+pPnGT1pMnq3iCyEYFrBSEDB4257+bKRXgFWF6jLNP+l8lqQtLrvZiW4HvS0m
	 h85ys+pPWnmY+IdO3ll7cBdZEgu0zxK8w3SueK2ML7qYUoTc7newUI9sv16XWkaIrz
	 nC/AxsK+C37gWy/dalKPJTtkasGO75+E9p2ceZD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/307] arm64: debug: remove debug exception registration infrastructure
Date: Sun,  7 Jun 2026 11:57:00 +0200
Message-ID: <20260607095728.481215878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

[ Upstream commit a8b8cce9d96d65dfe3d89abf02033151f8b7d670 ]

Now that debug exceptions are handled individually and without the need
for dynamic registration, remove the unused registration infrastructure.

This removes the external caller for `debug_exception_enter()` and
`debug_exception_exit()`.
Make them static again and remove them from the header.

Remove `early_brk64()` as it has been made redundant by
(arm64: debug: split brk64 exception entry) and is not used anymore.
Note : in `early_brk64()` `bug_brk_handler()` is called unconditionally
as a fall-through, but now `call_break_hook()` only calls it if the
immediate matches.
This does not change the behaviour in early boot, as if
`bug_brk_handler()` was called on a non-BUG immediate it would return
DBG_HOOK_ERROR anyway, which `call_break_hook()` will do if no immediate
matches.

Remove `trap_init()`, as it would be empty and a weak definition already
exists in `init/main.c`.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Reviewed-by: Will Deacon <will@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250707114109.35672-14-ada.coupriediaz@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/debug-monitors.h |  2 -
 arch/arm64/include/asm/exception.h      |  6 ---
 arch/arm64/include/asm/system_misc.h    |  4 --
 arch/arm64/kernel/debug-monitors.c      |  3 --
 arch/arm64/kernel/entry-common.c        |  4 +-
 arch/arm64/kernel/traps.c               | 27 -------------
 arch/arm64/mm/fault.c                   | 53 -------------------------
 7 files changed, 2 insertions(+), 97 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 24c7981abeb0b9..4f3901884c5d85 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -93,7 +93,5 @@ static inline bool try_step_suspended_breakpoints(struct pt_regs *regs)
 
 bool try_handle_aarch32_break(struct pt_regs *regs);
 
-void debug_traps_init(void);
-
 #endif	/* __ASSEMBLY */
 #endif	/* __ASM_DEBUG_MONITORS_H */
diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index 9b05c6f487ccf1..50c5329ff2edae 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -57,8 +57,6 @@ void do_el0_undef(struct pt_regs *regs, unsigned long esr);
 void do_el1_undef(struct pt_regs *regs, unsigned long esr);
 void do_el0_bti(struct pt_regs *regs);
 void do_el1_bti(struct pt_regs *regs, unsigned long esr);
-void do_debug_exception(unsigned long addr_if_watchpoint, unsigned long esr,
-			struct pt_regs *regs);
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 void do_breakpoint(unsigned long esr, struct pt_regs *regs);
 void do_watchpoint(unsigned long addr, unsigned long esr,
@@ -91,8 +89,4 @@ void do_serror(struct pt_regs *regs, unsigned long esr);
 void do_signal(struct pt_regs *regs);
 
 void __noreturn panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far);
-
-void debug_exception_enter(struct pt_regs *regs);
-void debug_exception_exit(struct pt_regs *regs);
-
 #endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index c343442567625d..344b1c1a4bbb69 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -25,10 +25,6 @@ void arm64_notify_die(const char *str, struct pt_regs *regs,
 		      int signo, int sicode, unsigned long far,
 		      unsigned long err);
 
-void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned long,
-					     struct pt_regs *),
-			   int sig, int code, const char *name);
-
 struct mm_struct;
 extern void __show_regs(struct pt_regs *);
 
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index ed03270fa34375..16390fd4ba5edd 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -316,9 +316,6 @@ bool try_handle_aarch32_break(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(try_handle_aarch32_break);
 
-void __init debug_traps_init(void)
-{}
-
 /* Re-enable single step for syscall restarting. */
 void user_rewind_single_step(struct task_struct *task)
 {
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 9a1ea5a6e6b72a..b98d6d1a1dfd63 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -448,7 +448,7 @@ static __always_inline void fpsimd_syscall_exit(void)
  * accidentally schedule in exception context and it will force a warning
  * if we somehow manage to schedule by accident.
  */
-void debug_exception_enter(struct pt_regs *regs)
+static void debug_exception_enter(struct pt_regs *regs)
 {
 	preempt_disable();
 
@@ -457,7 +457,7 @@ void debug_exception_enter(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(debug_exception_enter);
 
-void debug_exception_exit(struct pt_regs *regs)
+static void debug_exception_exit(struct pt_regs *regs)
 {
 	preempt_enable_no_resched();
 }
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 013159bc0882ee..e6e815ef03c777 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1091,30 +1091,3 @@ int ubsan_brk_handler(struct pt_regs *regs, unsigned long esr)
 	return DBG_HOOK_HANDLED;
 }
 #endif
-
-/*
- * Initial handler for AArch64 BRK exceptions
- * This handler only used until debug_traps_init().
- */
-int __init early_brk64(unsigned long addr, unsigned long esr,
-		struct pt_regs *regs)
-{
-#ifdef CONFIG_CFI_CLANG
-	if (esr_is_cfi_brk(esr))
-		return cfi_brk_handler(regs, esr) != DBG_HOOK_HANDLED;
-#endif
-#ifdef CONFIG_KASAN_SW_TAGS
-	if ((esr_brk_comment(esr) & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
-		return kasan_brk_handler(regs, esr) != DBG_HOOK_HANDLED;
-#endif
-#ifdef CONFIG_UBSAN_TRAP
-	if (esr_is_ubsan_brk(esr))
-		return ubsan_brk_handler(regs, esr) != DBG_HOOK_HANDLED;
-#endif
-	return bug_brk_handler(regs, esr) != DBG_HOOK_HANDLED;
-}
-
-void __init trap_init(void)
-{
-	debug_traps_init();
-}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 7c87d2b3b06eaa..9ee5a2d2b32151 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -53,18 +53,12 @@ struct fault_info {
 };
 
 static const struct fault_info fault_info[];
-static struct fault_info debug_fault_info[];
 
 static inline const struct fault_info *esr_to_fault_info(unsigned long esr)
 {
 	return fault_info + (esr & ESR_ELx_FSC);
 }
 
-static inline const struct fault_info *esr_to_debug_fault_info(unsigned long esr)
-{
-	return debug_fault_info + DBG_ESR_EVT(esr);
-}
-
 static void data_abort_decode(unsigned long esr)
 {
 	unsigned long iss2 = ESR_ELx_ISS2(esr);
@@ -911,53 +905,6 @@ void do_sp_pc_abort(unsigned long addr, unsigned long esr, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_sp_pc_abort);
 
-/*
- * __refdata because early_brk64 is __init, but the reference to it is
- * clobbered at arch_initcall time.
- * See traps.c and debug-monitors.c:debug_traps_init().
- */
-static struct fault_info __refdata debug_fault_info[] = {
-	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware breakpoint"	},
-	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware single-step"	},
-	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware watchpoint"	},
-	{ do_bad,	SIGKILL,	SI_KERNEL,	"unknown 3"		},
-	{ do_bad,	SIGTRAP,	TRAP_BRKPT,	"aarch32 BKPT"		},
-	{ do_bad,	SIGKILL,	SI_KERNEL,	"aarch32 vector catch"	},
-	{ early_brk64,	SIGTRAP,	TRAP_BRKPT,	"aarch64 BRK"		},
-	{ do_bad,	SIGKILL,	SI_KERNEL,	"unknown 7"		},
-};
-
-void __init hook_debug_fault_code(int nr,
-				  int (*fn)(unsigned long, unsigned long, struct pt_regs *),
-				  int sig, int code, const char *name)
-{
-	BUG_ON(nr < 0 || nr >= ARRAY_SIZE(debug_fault_info));
-
-	debug_fault_info[nr].fn		= fn;
-	debug_fault_info[nr].sig	= sig;
-	debug_fault_info[nr].code	= code;
-	debug_fault_info[nr].name	= name;
-}
-
-void do_debug_exception(unsigned long addr_if_watchpoint, unsigned long esr,
-			struct pt_regs *regs)
-{
-	const struct fault_info *inf = esr_to_debug_fault_info(esr);
-	unsigned long pc = instruction_pointer(regs);
-
-	debug_exception_enter(regs);
-
-	if (user_mode(regs) && !is_ttbr0_addr(pc))
-		arm64_apply_bp_hardening();
-
-	if (inf->fn(addr_if_watchpoint, esr, regs)) {
-		arm64_notify_die(inf->name, regs, inf->sig, inf->code, pc, esr);
-	}
-
-	debug_exception_exit(regs);
-}
-NOKPROBE_SYMBOL(do_debug_exception);
-
 /*
  * Used during anonymous page fault handling.
  */
-- 
2.53.0



