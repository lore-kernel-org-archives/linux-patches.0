Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589962ED174;
	Tue, 17 Jun 2025 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175114; cv=none; b=XBFWqY9C7oSk+Vvs9kEcijaN1mGrORRO8NdCyOF/fBF7NfAxN+ATeVS2+S9/QKEiuujQQUJKrYYHyCPXWTaz8s/6EfHeuBVLXoMn2tGHWxJ/99w6+YzXuNva3ZhzYCASiSLXN1skF0HMwi7nhmPpT5J/4EgZcFF6nlHLvG/ZYFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175114; c=relaxed/simple;
	bh=hk1Zo6wB1Trukd0OGPB8Fim4By/xbOS+znj8Taqz7QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2jqvpYcju8PtI4SVJM86AsmCe4IwwrTaeAbGbVKn/NEHaU+fu/xZw5/Os7FUEkM/8Ap4GC+H2j4PLuowZ3UgD9MFbOGSz7sUcqjTR2lc8xnccV7qk+RzXYrQUfYPqzJR6zx1cdQfFJxO5ed9Mol6hMknVPBqQ2CbP5ESAlUof8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRbrGUfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRbrGUfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC86C4CEE3;
	Tue, 17 Jun 2025 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175114;
	bh=hk1Zo6wB1Trukd0OGPB8Fim4By/xbOS+znj8Taqz7QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRbrGUfvkEE4BWzHexD9sl8o+BcjKfs1AZWXv8DT49l8RRDuH6OEGWJXNsS/U2IPx
	 WboK6Zx1sekyNLhPuOaEV3U52IRMpKspAqhXY1gscdI7q6E3V3cNadFfuvYTRZL8pg
	 jKN2rNpG4b2zpI4Aa7UkFV9u97ZNODekB4YBA8yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/512] arm64/fpsimd: Do not discard modified SVE state
Date: Tue, 17 Jun 2025 17:20:59 +0200
Message-ID: <20250617152423.346292966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 398edaa12f9cf2be7902f306fc023c20e3ebd3e4 ]

Historically SVE state was discarded deterministically early in the
syscall entry path, before ptrace is notified of syscall entry. This
permitted ptrace to modify SVE state before and after the "real" syscall
logic was executed, with the modified state being retained.

This behaviour was changed by commit:

  8c845e2731041f0f ("arm64/sve: Leave SVE enabled on syscall if we don't context switch")

That commit was intended to speed up workloads that used SVE by
opportunistically leaving SVE enabled when returning from a syscall.
The syscall entry logic was modified to truncate the SVE state without
disabling userspace access to SVE, and fpsimd_save_user_state() was
modified to discard userspace SVE state whenever
in_syscall(current_pt_regs()) is true, i.e. when
current_pt_regs()->syscallno != NO_SYSCALL.

Leaving SVE enabled opportunistically resulted in a couple of changes to
userspace visible behaviour which weren't described at the time, but are
logical consequences of opportunistically leaving SVE enabled:

* Signal handlers can observe the type of saved state in the signal's
  sve_context record. When the kernel only tracks FPSIMD state, the 'vq'
  field is 0 and there is no space allocated for register contents. When
  the kernel tracks SVE state, the 'vq' field is non-zero and the
  register contents are saved into the record.

  As a result of the above commit, 'vq' (and the presence of SVE
  register state) is non-deterministically zero or non-zero for a period
  of time after a syscall. The effective register state is still
  deterministic.

  Hopefully no-one relies on this being deterministic. In general,
  handlers for asynchronous events cannot expect a deterministic state.

* Similarly to signal handlers, ptrace requests can observe the type of
  saved state in the NT_ARM_SVE and NT_ARM_SSVE regsets, as this is
  exposed in the header flags. As a result of the above commit, this is
  now in a non-deterministic state after a syscall. The effective
  register state is still deterministic.

  Hopefully no-one relies on this being deterministic. In general,
  debuggers would have to handle this changing at arbitrary points
  during program flow.

Discarding the SVE state within fpsimd_save_user_state() resulted in
other changes to userspace visible behaviour which are not desirable:

* A ptrace tracer can modify (or create) a tracee's SVE state at syscall
  entry or syscall exit. As a result of the above commit, the tracee's
  SVE state can be discarded non-deterministically after modification,
  rather than being retained as it previously was.

  Note that for co-operative tracer/tracee pairs, the tracer may
  (re)initialise the tracee's state arbitrarily after the tracee sends
  itself an initial SIGSTOP via a syscall, so this affects realistic
  design patterns.

* The current_pt_regs()->syscallno field can be modified via ptrace, and
  can be altered even when the tracee is not really in a syscall,
  causing non-deterministic discarding to occur in situations where this
  was not previously possible.

Further, using current_pt_regs()->syscallno in this way is unsound:

* There are data races between readers and writers of the
  current_pt_regs()->syscallno field.

  The current_pt_regs()->syscallno field is written in interruptible
  task context using plain C accesses, and is read in irq/softirq
  context using plain C accesses. These accesses are subject to data
  races, with the usual concerns with tearing, etc.

* Writes to current_pt_regs()->syscallno are subject to compiler
  reordering.

  As current_pt_regs()->syscallno is written with plain C accesses,
  the compiler is free to move those writes arbitrarily relative to
  anything which doesn't access the same memory location.

  In theory this could break signal return, where prior to restoring the
  SVE state, restore_sigframe() calls forget_syscall(). If the write
  were hoisted after restore of some SVE state, that state could be
  discarded unexpectedly.

  In practice that reordering cannot happen in the absence of LTO (as
  cross compilation-unit function calls happen prevent this reordering),
  and that reordering appears to be unlikely in the presence of LTO.

Additionally, since commit:

  f130ac0ae4412dbe ("arm64: syscall: unmask DAIF earlier for SVCs")

... DAIF is unmasked before el0_svc_common() sets regs->syscallno to the
real syscall number. Consequently state may be saved in SVE format prior
to this point.

Considering all of the above, current_pt_regs()->syscallno should not be
used to infer whether the SVE state can be discarded. Luckily we can
instead use cpu_fp_state::to_save to track when it is safe to discard
the SVE state:

* At syscall entry, after the live SVE register state is truncated, set
  cpu_fp_state::to_save to FP_STATE_FPSIMD to indicate that only the
  FPSIMD portion is live and needs to be saved.

* At syscall exit, once the task's state is guaranteed to be live, set
  cpu_fp_state::to_save to FP_STATE_CURRENT to indicate that TIF_SVE
  must be considered to determine which state needs to be saved.

* Whenever state is modified, it must be saved+flushed prior to
  manipulation. The state will be truncated if necessary when it is
  saved, and reloading the state will set fp_state::to_save to
  FP_STATE_CURRENT, preventing subsequent discarding.

This permits SVE state to be discarded *only* when it is known to have
been truncated (and the non-FPSIMD portions must be zero), and ensures
that SVE state is retained after it is explicitly modified.

For backporting, note that this fix depends on the following commits:

* b2482807fbd4 ("arm64/sme: Optimise SME exit on syscall entry")
* f130ac0ae441 ("arm64: syscall: unmask DAIF earlier for SVCs")
* 929fa99b1215 ("arm64/fpsimd: signal: Always save+flush state early")

Fixes: 8c845e273104 ("arm64/sve: Leave SVE enabled on syscall if we don't context switch")
Fixes: f130ac0ae441 ("arm64: syscall: unmask DAIF earlier for SVCs")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250508132644.1395904-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h  |  3 +++
 arch/arm64/kernel/entry-common.c | 46 ++++++++++++++++++++++++--------
 arch/arm64/kernel/fpsimd.c       | 15 ++++++-----
 3 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index f2a84efc36185..c8dcb67b81a72 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -6,6 +6,7 @@
 #define __ASM_FP_H
 
 #include <asm/errno.h>
+#include <asm/percpu.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/sigcontext.h>
@@ -94,6 +95,8 @@ struct cpu_fp_state {
 	enum fp_type to_save;
 };
 
+DECLARE_PER_CPU(struct cpu_fp_state, fpsimd_last_state);
+
 extern void fpsimd_bind_state_to_cpu(struct cpu_fp_state *fp_state);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 3fcd9d080bf2a..d23315ef7b679 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -393,20 +393,16 @@ static bool cortex_a76_erratum_1463225_debug_handler(struct pt_regs *regs)
  * As per the ABI exit SME streaming mode and clear the SVE state not
  * shared with FPSIMD on syscall entry.
  */
-static inline void fp_user_discard(void)
+static inline void fpsimd_syscall_enter(void)
 {
-	/*
-	 * If SME is active then exit streaming mode.  If ZA is active
-	 * then flush the SVE registers but leave userspace access to
-	 * both SVE and SME enabled, otherwise disable SME for the
-	 * task and fall through to disabling SVE too.  This means
-	 * that after a syscall we never have any streaming mode
-	 * register state to track, if this changes the KVM code will
-	 * need updating.
-	 */
+	/* Ensure PSTATE.SM is clear, but leave PSTATE.ZA as-is. */
 	if (system_supports_sme())
 		sme_smstop_sm();
 
+	/*
+	 * The CPU is not in streaming mode. If non-streaming SVE is not
+	 * supported, there is no SVE state that needs to be discarded.
+	 */
 	if (!system_supports_sve())
 		return;
 
@@ -416,6 +412,33 @@ static inline void fp_user_discard(void)
 		sve_vq_minus_one = sve_vq_from_vl(task_get_sve_vl(current)) - 1;
 		sve_flush_live(true, sve_vq_minus_one);
 	}
+
+	/*
+	 * Any live non-FPSIMD SVE state has been zeroed. Allow
+	 * fpsimd_save_user_state() to lazily discard SVE state until either
+	 * the live state is unbound or fpsimd_syscall_exit() is called.
+	 */
+	__this_cpu_write(fpsimd_last_state.to_save, FP_STATE_FPSIMD);
+}
+
+static __always_inline void fpsimd_syscall_exit(void)
+{
+	if (!system_supports_sve())
+		return;
+
+	/*
+	 * The current task's user FPSIMD/SVE/SME state is now bound to this
+	 * CPU. The fpsimd_last_state.to_save value is either:
+	 *
+	 * - FP_STATE_FPSIMD, if the state has not been reloaded on this CPU
+	 *   since fpsimd_syscall_enter().
+	 *
+	 * - FP_STATE_CURRENT, if the state has been reloaded on this CPU at
+	 *   any point.
+	 *
+	 * Reset this to FP_STATE_CURRENT to stop lazy discarding.
+	 */
+	__this_cpu_write(fpsimd_last_state.to_save, FP_STATE_CURRENT);
 }
 
 UNHANDLED(el1t, 64, sync)
@@ -707,10 +730,11 @@ static void noinstr el0_svc(struct pt_regs *regs)
 {
 	enter_from_user_mode(regs);
 	cortex_a76_erratum_1463225_svc_handler();
-	fp_user_discard();
+	fpsimd_syscall_enter();
 	local_daif_restore(DAIF_PROCCTX);
 	do_el0_svc(regs);
 	exit_to_user_mode(regs);
+	fpsimd_syscall_exit();
 }
 
 static void noinstr el0_fpac(struct pt_regs *regs, unsigned long esr)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index c5285ee55bfb0..8854bce5cfe20 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -119,7 +119,7 @@
  *   whatever is in the FPSIMD registers is not saved to memory, but discarded.
  */
 
-static DEFINE_PER_CPU(struct cpu_fp_state, fpsimd_last_state);
+DEFINE_PER_CPU(struct cpu_fp_state, fpsimd_last_state);
 
 __ro_after_init struct vl_info vl_info[ARM64_VEC_MAX] = {
 #ifdef CONFIG_ARM64_SVE
@@ -453,12 +453,15 @@ static void fpsimd_save_user_state(void)
 		*(last->fpmr) = read_sysreg_s(SYS_FPMR);
 
 	/*
-	 * If a task is in a syscall the ABI allows us to only
-	 * preserve the state shared with FPSIMD so don't bother
-	 * saving the full SVE state in that case.
+	 * Save SVE state if it is live.
+	 *
+	 * The syscall ABI discards live SVE state at syscall entry. When
+	 * entering a syscall, fpsimd_syscall_enter() sets to_save to
+	 * FP_STATE_FPSIMD to allow the SVE state to be lazily discarded until
+	 * either new SVE state is loaded+bound or fpsimd_syscall_exit() is
+	 * called prior to a return to userspace.
 	 */
-	if ((last->to_save == FP_STATE_CURRENT && test_thread_flag(TIF_SVE) &&
-	     !in_syscall(current_pt_regs())) ||
+	if ((last->to_save == FP_STATE_CURRENT && test_thread_flag(TIF_SVE)) ||
 	    last->to_save == FP_STATE_SVE) {
 		save_sve_regs = true;
 		save_ffr = true;
-- 
2.39.5



