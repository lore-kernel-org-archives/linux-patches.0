Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F4341A551;
	Mon, 31 Aug 2026 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183239; cv=none; b=iv5JMqAZYQmCaROXtbSHnPJ98dTGH/YIzZio1DC9AA+BHvphEyVNtRRc0QR74f3JQ4IbIkH/KXCwVzMNtffQmg6Bh6qbvOChLNaakciusDEF1Fv910oD+uzGIEI4r74C8byWg5WMWi0JKFRdCkSzwOqHuzpD2UjmHejewRgkeXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183239; c=relaxed/simple;
	bh=jW+N1yboSweju19E3TsMZhNzXAFzMtAZ8tirvVgB8kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KeFIQT3XNcLmZNEE/rRI+EoP96zpTihKNc6XxnH1AsC4DfDJQrzf7rdSgaR2jsDQotd4YzMUYPcALqDdHsF1LjyYESgQUiOMmzO5AqHIIqcF1EuHea9OmcTfQk1hlP6iBbHeEe1gftiXG49Nv1hqPoQZshFD/5n+S7E/y6VqMGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNg5++zb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNg5++zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A4F1F00A3E;
	Mon, 31 Aug 2026 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183237;
	bh=AvV6yLbMcV1B8b94+oJs4b8s8FAEbmCg1eKUL+PjPVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNg5++zbB3BfVTWnJEtXW5tOkPcBTqtXZnIf07R9IvYG7j/kl9XYuqi1lraVvGbeY
	 A+Og8SmdJqvlat/1S6/vCbojmdd0JjW3nZ6vl9X6ds70Qb6Z0KaTmEGhMihX418YYS
	 wt8NHPgf2UwiBKbsn70mv+0GQyjqJcVXnX+vfe4lVTetL8QZvFEk4pRFhy0Or+UKd5
	 6gN/LQmNTdlpxeMYe3ys9rXxT8S4pFeYQ6kd5i3HIDQGvJgqiUkTNv/rY4nq3S2/uz
	 dCRbtibE2a6phXrnTHipPjERyP1c7fBR3SJ2WdSccS75ayiUM486/FRk0McqQ739Xn
	 kwHbjsuXG5YPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pu Hu <hupu@transsion.com>,
	Hongyan Xia <hongyan.xia@transsion.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] arm64: kprobes: Only handle faults originating from XOL slot
Date: Mon, 31 Aug 2026 09:20:55 -0400
Message-ID: <20260831133314.4125787-27-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pu Hu <hupu@transsion.com>

[ Upstream commit 879a6754d3d11e30af24b7dc486f561510d62641 ]

kprobe_fault_handler() currently treats any page fault taken while in
KPROBE_HIT_SS or KPROBE_REENTER state as a kprobe single-step fault. This
assumption does not hold: perf or tracing code may run from the debug
exception path during the single-step window and take its own page fault.

When the fault is handled as a kprobe fault, the PC is rewritten to the
probe address, corrupting the exception recovery context for the real
fault. A typical reproducer is running perf with preemptirq tracepoints
and dwarf callchains while a kprobe is installed on a frequently
executed function.

Fix this in two layers:

1. At function entry, bail out immediately for simulated kprobes
   (ainsn.xol_insn == NULL), since they have no XOL slot and any fault
   taken during their execution cannot be a single-step fault.

2. For kprobes with an XOL slot, only handle the fault when the
   faulting PC matches the XOL instruction address. Faults from any
   other PC are left to the normal page fault handler.

This follows the same principle as the x86 fix in commit 6381c24cd6d5
("kprobes/x86: Fix page-fault handling logic").

Signed-off-by: Pu Hu <hupu@transsion.com>
Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `arm64: kprobes: Only handle faults
originating from XOL slot`

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[arm64: kprobes]` `[Only handle]` — restricts kprobe page-
fault handling to faults that actually originate from the XOL (execute-
out-of-line) single-step slot.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Masami Hiramatsu (Google) `<mhiramat@kernel.org>` —
  kprobes subsystem maintainer
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected)
- **Signed-off-by:** Pu Hu, Hongyan Xia (authors); Will Deacon (arm64
  maintainer)
- **Notable:** Strong maintainer review signal; references x86 precedent
  commit `6381c24cd6d5`

### Step 1.3: Analyze commit body text
**Record:**
- **Bug:** `kprobe_fault_handler()` treats *any* page fault during
  `KPROBE_HIT_SS` or `KPROBE_REENTER` as a kprobe single-step fault.
- **Symptom:** PC is rewritten to the probe address, corrupting
  exception recovery for the real fault → kernel crash/BUG.
- **Reproducer:** perf with preemptirq tracepoints and DWARF callchains
  while a kprobe is on a frequently executed function.
- **Root cause:** perf/tracing code can run from the debug-exception
  path during the single-step window and take its own page fault; that
  fault is not from the XOL instruction.
- **Version info:** Not specified; fix mirrors a 2014 x86 fix that arm64
  never received.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit correctness/crash fix,
though the mechanism (verify faulting PC before rewriting it) is the
same pattern used on x86 since 2014.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `arch/arm64/kernel/probes/kprobes.c` only (+22 lines, 0
  removals)
- **Function modified:** `kprobe_fault_handler()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change per hunk
**Record:**
- **Hunk 1 (early return):** Before → any fault during simulated kprobe
  (`xol_insn == NULL`) could enter the switch and corrupt state. After →
  immediate `return 0`, leaving the fault to the normal handler
  (including `fixup_exception`).
- **Hunk 2 (PC check):** Before → any fault in
  `KPROBE_HIT_SS`/`KPROBE_REENTER` rewrote PC to `cur->addr`. After →
  only rewrites PC when `instruction_pointer(regs) ==
  cur->ainsn.xol_insn`; otherwise `break` and fall through to `return
  0`.

### Step 2.3: Bug mechanism
**Record:** **Logic/correctness fix** — incorrect fault attribution
corrupts register context (PC) for unrelated page faults during kprobe
single-stepping. Same class of bug fixed on x86 in `6381c24cd6d5`.

### Step 2.4: Fix quality assessment
**Record:** Fix is obviously correct and minimal. It mirrors the proven
x86 pattern (`regs->ip == cur->ainsn.insn`). Regression risk is very
low: legitimate XOL single-step faults still match `xol_insn` and follow
the existing path. The `kprobe_ss_brk_handler()` already uses a similar
XOL-address check at line 361–362.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** Current `kprobe_fault_handler()` body is present in this
tree at lines 280–308. Repository is shallow (`git rev-parse --is-
shallow-repository` → `true`), limiting deep history. File header dates
arm64 kprobes to 2013; the overly broad fault handling predates this
6.18.y branch and was never corrected on arm64 (unlike x86).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag. Referenced x86 commit `6381c24cd6d5`
("kprobes/x86: Fix page-fault handling logic", April 2014) is present in
this tree and documents the same failure mode (perf/NMI page fault
during single-step → PC corruption → kernel BUG).

### Step 3.3: File history for related changes
**Record:** Shallow history shows only one commit touching
`arch/arm64/kernel/probes/kprobes.c` in this checkout. No related fix
already present. This commit is patch 1 of a 3-patch RFC series; patches
2–3 address separate reentry/irqflag issues and are **not**
prerequisites for this fix.

### Step 3.4: Author's other commits
**Record:** No commits from Pu Hu found in this shallow tree. Author
appears to be a Transsion contributor; patch was reviewed by the kprobes
maintainer.

### Step 3.5: Dependent/prerequisite commits
**Record:** None. Self-contained. `xol_insn`, `instruction_pointer()`,
and `kprobe_fault_handler()` all exist in this tree. `git apply --check`
confirms clean apply.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** Patch submitted as RFC v2/v3 series in July 2026. Lore URL
(via openwall mirror): https://lists.openwall.net/linux-
kernel/2026/07/10/387. Final committed version matches v3 content. `b4
dig -c` could not be used (commit not in local tree).

### Step 4.2: Reviewers
**Record:** CC'd to `mhiramat@kernel.org`, `will@kernel.org`,
`catalin.marinas@arm.com`, `linux-arm-kernel@`, `linux-trace-kernel@`.
Masami Hiramatsu replied "This looks good to me" with `Reviewed-by`
(https://lists.openwall.net/linux-kernel/2026/07/10/222).

### Step 4.3: Bug report details
**Record:** No formal bugzilla/syzbot report. Reproducer described in
commit message and series cover letter: perf + preemptirq tracepoints +
DWARF callchains + active kprobe on hot function. Series cover letter
states crashes occur in the kprobe debug exception path.

### Step 4.4: Related patches/series
**Record:** Part of "arm64: kprobes: Fix single-step fault and reentry
handling" (3 patches). Only patch 1 (this commit) is required for the
fault-handler bug. Patches 2–3 are independent improvements.

### Step 4.5: Stable mailing list history
**Record:** Could not search lore stable list (bot protection). No
evidence found of prior stable rejection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** `kprobe_fault_handler()` only.

### Step 5.2: Trace callers
**Record:** Call chain:
1. `do_page_fault()` in `arch/arm64/mm/fault.c:565` →
   `kprobe_page_fault(regs, esr)`
2. `kprobe_page_fault()` in `include/linux/kprobes.h:576-591` — checks
   `CONFIG_KPROBES`, non-user mode, non-preemptible, `kprobe_running()`
   → calls `kprobe_fault_handler()`
3. x86 equivalent called from `arch/x86/mm/fault.c`

Called from the kernel page-fault path during any kernel-mode
data/instruction abort while a kprobe is active.

### Step 5.3: Key callees
**Record:** `kprobe_running()`, `get_kprobe_ctlblk()`,
`instruction_pointer()` / `instruction_pointer_set()`,
`restore_previous_kprobe()`, `kprobes_restore_local_irqflag()`,
`reset_current_kprobe()`.

### Step 5.4: Call chain / reachability
**Record:** Reachable whenever `CONFIG_KPROBES` is enabled and
perf/tracing + kprobes are used concurrently on arm64 — a realistic
production/debug scenario on Graviton, Ampere, and other arm64 servers.
Root-capable users can install kprobes; perf is widely used.

### Step 5.5: Similar patterns
**Record:** x86 `kprobe_fault_handler()` at
`arch/x86/kernel/kprobes/core.c:1039` already gates on `regs->ip ==
(unsigned long)cur->ainsn.insn`. `kprobe_ss_brk_handler()` on arm64
already checks XOL address at lines 361–362. This fix brings fault
handling in line with both.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **YES.** `arch/arm64/kernel/probes/kprobes.c:280-308` has
the buggy unconditional PC rewrite. The fix is **not** yet applied in
this 6.18.44 tree.

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicting recent churn in this file.

### Step 6.3: Related fixes already present?
**Record:** None found. x86 has had the equivalent fix since 2014; arm64
still lacks it.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `arch/arm64/kernel/probes/` +
`arch/arm64/mm/fault.c`. Affects arm64 kernel debugging/tracing
infrastructure, not every user, but crashes are severe when triggered.

### Step 7.2: Subsystem activity
**Record:** arm64 kprobes code is mature (2013 origin). This is a long-
standing correctness gap, not a regression from a recent mainline
commit.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Config-specific** (`CONFIG_KPROBES`) on **arm64** systems
running kprobes concurrently with perf/tracing (especially preemptirq
tracepoints + DWARF callchains).

### Step 8.2: Trigger conditions
**Record:** Kprobe on frequently executed function + perf tracing that
page-faults during the kprobe single-step window. Not every boot, but
reproducible with the described workload. Requires privileges to use
kprobes/perf, but this is standard on developer and observability-
focused production systems.

### Step 8.3: Failure mode severity
**Record:** **CRITICAL** — PC corruption in the fault handler leads to
mis-handled page faults and kernel BUG/panic (same severity class as the
documented x86 case: NULL pointer dereference after IP corruption).

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** HIGH for arm64 kprobes+perf users — prevents real crashes
- **Risk:** VERY LOW — 22-line, maintainer-reviewed, mirrors 10+ year
  proven x86 logic
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backporting:**
- Fixes a real, reproducible kernel crash
- Corrupts exception context (PC rewrite) — severe failure mode
- Small (22 lines), single file, applies cleanly to 6.18.44
- Reviewed by kprobes maintainer (Hiramatsu), signed off by arm64
  maintainer (Deacon)
- Follows proven x86 fix from 2014
- Buggy code confirmed present in this tree
- Standalone — no dependencies on other series patches

**AGAINST backporting:**
- Only affects `CONFIG_KPROBES` on arm64 (narrower audience than core
  MM/net)
- No syzbot/CVE report (but clear reproducer and maintainer review)

**Unresolved:** Exact commit that introduced arm64
`kprobe_fault_handler()` (shallow repo). Bug has likely existed since
arm64 kprobes inception regardless.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors x86; maintainer
   reviewed; logical correctness verifiable from code
2. Fixes a real bug affecting users? **PASS** — documented perf+kprobes
   reproducer
3. Important issue? **PASS** — kernel crash/BUG (CRITICAL)
4. Small and contained? **PASS** — 22 lines, 1 file
5. No new features or APIs? **PASS** — pure bug fix
6. Can apply to local tree? **PASS** — verified clean apply; buggy code
   present

### Step 9.3: Exception categories
**Record:** None apply (not device ID, quirk, DT, build, or docs).
Standard bug-fix backport.

### Step 9.4: Decision rationale

For **Linux 6.18.44**, this commit should be backported. The arm64
kprobe fault handler has a longstanding correctness bug that x86 fixed
in 2014: it mishandles page faults from perf/tracing code that runs
during the kprobe single-step window, corrupting the faulting PC and
causing kernel crashes. The fix is minimal, maintainer-reviewed, matches
an established cross-architecture pattern, and applies cleanly to this
tree where the buggy code is still present.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; confirmed Reviewed-by
  Hiramatsu, SOB Deacon
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Read diff: +22 lines in `kprobe_fault_handler()`, two
  guard layers
- **[Phase 2]** Read current tree code at
  `arch/arm64/kernel/probes/kprobes.c:280-308` — buggy version present
- **[Phase 2]** Compared to x86 fix at
  `arch/x86/kernel/kprobes/core.c:1039` — same IP-check pattern
- **[Phase 3]** `git blame -L 280,308` — function present in tree
- **[Phase 3]** `git rev-parse --is-shallow-repository` → `true`
  (limited history)
- **[Phase 3]** `git show 6381c24cd6d5` — x86 precedent with crash
  description confirmed
- **[Phase 3]** `git apply --check` — patch applies cleanly
- **[Phase 4]** Fetched lore/openwall: RFC v3 submission at
  lists.openwall.net/linux-kernel/2026/07/10/387
- **[Phase 4]** Fetched review reply: Hiramatsu "This looks good to me"
  at lists.openwall.net/linux-kernel/2026/07/10/222
- **[Phase 4]** Series cover letter (web search): 3-patch series; patch
  1 is standalone for fault handling
- **[Phase 4]** lore.kernel.org/stable search blocked by bot protection
  — UNVERIFIED for stable-list discussion
- **[Phase 5]** `grep kprobe_page_fault` — caller at
  `arch/arm64/mm/fault.c:565`
- **[Phase 5]** Read `kprobe_page_fault()` in
  `include/linux/kprobes.h:576-591` — requires `kprobe_running()`
- **[Phase 5]** Read `kprobe_ss_brk_handler()` XOL check at lines
  361-362 — consistent pattern
- **[Phase 6]** `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`; `make
  kernelversion` → `6.18.44`
- **[Phase 6]** Confirmed fix NOT in tree; buggy code at lines 280-308
- **[Phase 6]** `git apply --check` on provided diff — PASS
- **[Phase 7]** Read `arch/Kconfig:117-128` — KPROBES depends on
  HAVE_KPROBES
- **[Phase 8]** Failure mode: PC corruption → kernel BUG; severity
  CRITICAL

**YES**

 arch/arm64/kernel/probes/kprobes.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 7133da1653964..4e0efad5caf24 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -303,9 +303,31 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
+	/*
+	 * Simulated kprobes execute in the debug trap context and have no
+	 * XOL slot. Any page fault taken while a simulated kprobe is in
+	 * progress cannot have been caused by kprobe single-stepping and
+	 * must be left alone for the normal page fault handler, including
+	 * fixup_exception.
+	 */
+	if (cur && !cur->ainsn.xol_insn)
+		return 0;
+
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SS:
 	case KPROBE_REENTER:
+		/*
+		 * A page fault taken while in KPROBE_HIT_SS or
+		 * KPROBE_REENTER state is only attributable to kprobe
+		 * single-stepping if the faulting PC points to the
+		 * current kprobe's XOL instruction. If the fault occurred
+		 * elsewhere (e.g. in perf or tracing code invoked from the
+		 * debug exception path), leave it for the normal page fault
+		 * handler to process.
+		 */
+		if (instruction_pointer(regs) != (unsigned long)cur->ainsn.xol_insn)
+			break;
+
 		/*
 		 * We are here because the instruction being single
 		 * stepped caused a page fault. We reset the current
-- 
2.53.0

