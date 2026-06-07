Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3E028688C;
	Sun,  7 Jun 2026 10:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827069; cv=none; b=XO7mlW9zDkM6UP+233DSmKJUfWQfjpw+8sGdMaNSi0H0diwfe/UB9W8wVfxJfHAAOPbLcVMRV1DrmTijED0Pp8RsdW1+/xo2Rw5AM2RGw4hfCMLia0mUxtTPPefCXB6STv6Qm4CtCTsEPlvksf1E6c8YZyOY9AfSR+7YWBtHtJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827069; c=relaxed/simple;
	bh=UoYFbNfnvHs7sqwbN8TI71vdK6EJ7Jtye8QRBoASRyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl+IeifKGLHTbQzAtXjtW1X25mOTv7C//m14XWeWtrewy+ofEVopZtXHZBEEWVWb0gEerGdoUX24+A5l/CtqFGXs4DMzsthj0ks644vKpdXHYBIYKs4OpW0Ps4ubo6rfWlVH3fsTAcF6EFPH5ghYCNtLnFlS7Y0dg1rlqr7RP8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3CbsEdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3CbsEdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34251F00893;
	Sun,  7 Jun 2026 10:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827065;
	bh=ZzJpeaPVQtota33DGOqEBTTxLGn2BEOm9UmWoFG3/FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3CbsEdiCB3O+oEmO1MxYeDFFhWQ7mRUt/pwnRjaNBQwG1vX1s0o4gvAEbzoZZGPg
	 uDdfN4cYJgJWb8bTm0Iy+rtfaIjwhvfUvPNZg/Gofu2OVP4B2Vsjjvdg8LFxogJtK6
	 6337yZWJmkMsL2zY8McngueqmDq84WVq67lCik58=
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
Subject: [PATCH 6.12 019/307] arm64: debug: split single stepping exception entry
Date: Sun,  7 Jun 2026 11:56:56 +0200
Message-ID: <20260607095728.332972945@linuxfoundation.org>
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

[ Upstream commit 0ac7584c08ceff13fc1e3082a0104548688d6b00 ]

Currently all debug exceptions share common entry code and are routed
to `do_debug_exception()`, which calls dynamically-registered
handlers for each specific debug exception. This is unfortunate as
different debug exceptions have different entry handling requirements,
and it would be better to handle these distinct requirements earlier.

The single stepping exception has the most constraints : it can be
exploited to train branch predictors and it needs special handling at EL1
for the Cortex-A76 erratum #1463225. We need to conserve all those
mitigations.
However, it does not write an address at FAR_EL1, as only hardware
watchpoints do so.

The single-step handler does its own signaling if it needs to and only
returns 0, so we can call it directly from `entry-common.c`.

Split the single stepping exception entry, adjust the function signature,
keep the security mitigation and erratum handling.
Further, as the EL0 and EL1 code paths are cleanly separated, we can split
`do_softstep()` into `do_el0_softstep()` and `do_el1_softstep()` and
call them directly from the relevant entry paths.
We can also remove `NOKPROBE_SYMBOL` for the EL0 path, as it cannot
lead to a kprobe recursion.

Move the call to `arm64_apply_bp_hardening()` to `entry-common.c` so that
we can do it as early as possible, and only for the exceptions coming
from EL0, where it is needed.
This is safe to do as it is `noinstr`, as are all the functions it
may call. `el0_ia()` and `el0_pc()` already call it this way.

When taking a soft-step exception from EL0, most of the single stepping
handling is safely preemptible : the only possible handler is
`uprobe_single_step_handler()`. It only operates on task-local data and
properly checks its validity, then raises a Thread Information Flag,
processed before returning to userspace in `do_notify_resume()`, which
is already preemptible.
However, the soft-step handler first calls `reinstall_suspended_bps()`
to check if there is any hardware breakpoint or watchpoint pending
or already stepped through.
This cannot be preempted as it manipulates the hardware breakpoint and
watchpoint registers.

Move the call to `try_step_suspended_breakpoints()` to `entry-common.c`
and adjust the relevant comments.
We can now safely unmask interrupts before handling the step itself,
fixing a PREEMPT_RT issue where the handler could call a sleeping function
with preemption disabled.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Closes: https://lore.kernel.org/linux-arm-kernel/Z6YW_Kx4S2tmj2BP@uudg.org/
Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Reviewed-by: Will Deacon <will@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250707114109.35672-10-ada.coupriediaz@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/exception.h |  2 +
 arch/arm64/kernel/debug-monitors.c | 73 +++++++++++-------------------
 arch/arm64/kernel/entry-common.c   | 43 ++++++++++++++++++
 arch/arm64/kernel/hw_breakpoint.c  |  2 +-
 4 files changed, 73 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index 94f46e96515160..6d40efc28be401 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -64,6 +64,8 @@ void do_breakpoint(unsigned long esr, struct pt_regs *regs);
 #else
 static inline void do_breakpoint(unsigned long esr, struct pt_regs *regs) {}
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
+void do_el0_softstep(unsigned long esr, struct pt_regs *regs);
+void do_el1_softstep(unsigned long esr, struct pt_regs *regs);
 void do_fpsimd_acc(unsigned long esr, struct pt_regs *regs);
 void do_sve_acc(unsigned long esr, struct pt_regs *regs);
 void do_sme_acc(unsigned long esr, struct pt_regs *regs);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index b95a135ef10a99..10d2bc51a32f7c 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -21,6 +21,7 @@
 #include <asm/cputype.h>
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
+#include <asm/exception.h>
 #include <asm/kgdb.h>
 #include <asm/kprobes.h>
 #include <asm/system_misc.h>
@@ -159,21 +160,6 @@ NOKPROBE_SYMBOL(clear_user_regs_spsr_ss);
 #define set_regs_spsr_ss(r)	set_user_regs_spsr_ss(&(r)->user_regs)
 #define clear_regs_spsr_ss(r)	clear_user_regs_spsr_ss(&(r)->user_regs)
 
-/*
- * Call single step handlers
- * There is no Syndrome info to check for determining the handler.
- * However, there is only one possible handler for user and kernel modes, so
- * check and call the appropriate one.
- */
-static int call_step_hook(struct pt_regs *regs, unsigned long esr)
-{
-	if (user_mode(regs))
-		return uprobe_single_step_handler(regs, esr);
-
-	return kgdb_single_step_handler(regs, esr);
-}
-NOKPROBE_SYMBOL(call_step_hook);
-
 static void send_user_sigtrap(int si_code)
 {
 	struct pt_regs *regs = current_pt_regs();
@@ -188,41 +174,38 @@ static void send_user_sigtrap(int si_code)
 			      "User debug trap");
 }
 
-static int single_step_handler(unsigned long unused, unsigned long esr,
-			       struct pt_regs *regs)
+/*
+ * We have already unmasked interrupts and enabled preemption
+ * when calling do_el0_softstep() from entry-common.c.
+ */
+void do_el0_softstep(unsigned long esr, struct pt_regs *regs)
 {
+	if (uprobe_single_step_handler(regs, esr) == DBG_HOOK_HANDLED)
+		return;
+
+	send_user_sigtrap(TRAP_TRACE);
 	/*
-	 * If we are stepping a pending breakpoint, call the hw_breakpoint
-	 * handler first.
+	 * ptrace will disable single step unless explicitly
+	 * asked to re-enable it. For other clients, it makes
+	 * sense to leave it enabled (i.e. rewind the controls
+	 * to the active-not-pending state).
 	 */
-	if (try_step_suspended_breakpoints(regs))
-		return 0;
-
-	if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
-		return 0;
+	user_rewind_single_step(current);
+}
 
-	if (user_mode(regs)) {
-		send_user_sigtrap(TRAP_TRACE);
-
-		/*
-		 * ptrace will disable single step unless explicitly
-		 * asked to re-enable it. For other clients, it makes
-		 * sense to leave it enabled (i.e. rewind the controls
-		 * to the active-not-pending state).
-		 */
-		user_rewind_single_step(current);
-	} else {
-		pr_warn("Unexpected kernel single-step exception at EL1\n");
-		/*
-		 * Re-enable stepping since we know that we will be
-		 * returning to regs.
-		 */
-		set_regs_spsr_ss(regs);
-	}
+void do_el1_softstep(unsigned long esr, struct pt_regs *regs)
+{
+	if (kgdb_single_step_handler(regs, esr) == DBG_HOOK_HANDLED)
+		return;
 
-	return 0;
+	pr_warn("Unexpected kernel single-step exception at EL1\n");
+	/*
+	 * Re-enable stepping since we know that we will be
+	 * returning to regs.
+	 */
+	set_regs_spsr_ss(regs);
 }
-NOKPROBE_SYMBOL(single_step_handler);
+NOKPROBE_SYMBOL(do_el1_softstep);
 
 static int call_break_hook(struct pt_regs *regs, unsigned long esr)
 {
@@ -329,8 +312,6 @@ NOKPROBE_SYMBOL(try_handle_aarch32_break);
 
 void __init debug_traps_init(void)
 {
-	hook_debug_fault_code(DBG_ESR_EVT_HWSS, single_step_handler, SIGTRAP,
-			      TRAP_TRACE, "single-step handler");
 	hook_debug_fault_code(DBG_ESR_EVT_BRK, brk_handler, SIGTRAP,
 			      TRAP_BRKPT, "BRK handler");
 }
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index af0d7575dcfd92..c22cc4d0052d54 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -517,6 +517,24 @@ static void noinstr el1_breakpt(struct pt_regs *regs, unsigned long esr)
 	arm64_exit_el1_dbg(regs);
 }
 
+static void noinstr el1_softstp(struct pt_regs *regs, unsigned long esr)
+{
+	arm64_enter_el1_dbg(regs);
+	if (!cortex_a76_erratum_1463225_debug_handler(regs)) {
+		debug_exception_enter(regs);
+		/*
+		 * After handling a breakpoint, we suspend the breakpoint
+		 * and use single-step to move to the next instruction.
+		 * If we are stepping a suspended breakpoint there's nothing more to do:
+		 * the single-step is complete.
+		 */
+		if (!try_step_suspended_breakpoints(regs))
+			do_el1_softstep(esr, regs);
+		debug_exception_exit(regs);
+	}
+	arm64_exit_el1_dbg(regs);
+}
+
 static void noinstr el1_dbg(struct pt_regs *regs, unsigned long esr)
 {
 	unsigned long far = read_sysreg(far_el1);
@@ -563,6 +581,8 @@ asmlinkage void noinstr el1h_64_sync_handler(struct pt_regs *regs)
 		el1_breakpt(regs, esr);
 		break;
 	case ESR_ELx_EC_SOFTSTP_CUR:
+		el1_softstp(regs, esr);
+		break;
 	case ESR_ELx_EC_WATCHPT_CUR:
 	case ESR_ELx_EC_BRK64:
 		el1_dbg(regs, esr);
@@ -761,6 +781,25 @@ static void noinstr el0_breakpt(struct pt_regs *regs, unsigned long esr)
 	exit_to_user_mode(regs);
 }
 
+static void noinstr el0_softstp(struct pt_regs *regs, unsigned long esr)
+{
+	if (!is_ttbr0_addr(regs->pc))
+		arm64_apply_bp_hardening();
+
+	enter_from_user_mode(regs);
+	/*
+	 * After handling a breakpoint, we suspend the breakpoint
+	 * and use single-step to move to the next instruction.
+	 * If we are stepping a suspended breakpoint there's nothing more to do:
+	 * the single-step is complete.
+	 */
+	if (!try_step_suspended_breakpoints(regs)) {
+		local_daif_restore(DAIF_PROCCTX);
+		do_el0_softstep(esr, regs);
+	}
+	exit_to_user_mode(regs);
+}
+
 static void noinstr el0_dbg(struct pt_regs *regs, unsigned long esr)
 {
 	/* Only watchpoints write FAR_EL1, otherwise its UNKNOWN */
@@ -840,6 +879,8 @@ asmlinkage void noinstr el0t_64_sync_handler(struct pt_regs *regs)
 		el0_breakpt(regs, esr);
 		break;
 	case ESR_ELx_EC_SOFTSTP_LOW:
+		el0_softstp(regs, esr);
+		break;
 	case ESR_ELx_EC_WATCHPT_LOW:
 	case ESR_ELx_EC_BRK64:
 		el0_dbg(regs, esr);
@@ -962,6 +1003,8 @@ asmlinkage void noinstr el0t_32_sync_handler(struct pt_regs *regs)
 		el0_breakpt(regs, esr);
 		break;
 	case ESR_ELx_EC_SOFTSTP_LOW:
+		el0_softstp(regs, esr);
+		break;
 	case ESR_ELx_EC_WATCHPT_LOW:
 	case ESR_ELx_EC_BKPT32:
 		el0_dbg(regs, esr);
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 309ae24d454805..8a80e13347c88f 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -854,7 +854,7 @@ bool try_step_suspended_breakpoints(struct pt_regs *regs)
 	bool handled_exception = false;
 
 	/*
-	 * Called from single-step exception handler.
+	 * Called from single-step exception entry.
 	 * Return true if we stepped a breakpoint and can resume execution,
 	 * false if we need to handle a single-step.
 	 */
-- 
2.53.0



