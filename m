Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAB85CFA37;
	Mon, 19 Oct 2026 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418484; cv=none; b=kLYAjqo5784R8ubfc/m6BSFN40u214WmTO+tGpJBei9/13La6tp5ZMIctQwNPPYqi3Z2swfuEaWSVKazXvWtmmJBXR+tJPFPbs6hpA3m436oqqtXoG2KDXGmNazAOvDtQZhEZBVphUkyNyGUN7j5Vy13bkIaluzeODFv4etBwtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418484; c=relaxed/simple;
	bh=HToFgVlhuGaEadTfI7X7GKcr0QHuQ8RmEuqX3C3o0wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CWcCDwHl4CZ5KbdyU8FJmUsMo7Zdbd/WN8aNjbsMhPLLwG1jXX4+1o2fD8hJOLaUsZUrbqeVmYYivC4cus1m3F7Y3WFdj3CCjoQJpDTOrRAMQJRYOrtT5V2PyaSQImnD+FuJOz3Qzs6Qs5qumjioEj6fzz2RZ3B7+WL9aMDoVPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OIEf7OWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OIEf7OWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2991F000C7;
	Mon, 19 Oct 2026 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418481;
	bh=gBlviaq2Bd1jxA4rhzos6vfoZby6wGFF0L4p6Ivg+2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIEf7OWBonhlFXBGqPTKSHJJN7/2RtkRSruw26RcyUNvIFj8eG1829evIbJ2RETxi
	 eKlRsBclVAEWb31SoglLyvWUxMApgjXpZu8PY9C4l4uLOoyqPDQa0uvfCRYG8dd7Dr
	 qMTe8ksrYEaUGMCEnxuDeOY7ntf5adHgReJESW4oL8/wh8Ser+U6goqYzhItfY4RIW
	 3KF+eEwGD4NgaWvqGuO26pu7TV0s2j9OTEkJVNWvdmf/0nvyEr/UCqQ91khOK9ia5F
	 b+JxEbFto6KQLkjQ7nPi7jZ0njM88Bg/Kvelmy8E6YT62+qFkq5uvvj8hHR0t5lWTX
	 cBTPNpuhIQ2Jg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rui Qi <qirui.001@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] riscv: kprobes: Prevent probes in breakpoint handlers
Date: Mon, 19 Oct 2026 09:49:30 -0400
Message-ID: <20261019135441.1420968-279-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit e7d8ea6c6d1bc685a8943ffad2d3679be92d164f ]

The ftrace selftest multiple_kprobes.tc registers kprobe events on
the first 256 text symbols from /proc/kallsyms. If handle_break() is
selected as a probe target on RISC-V, the breakpoint exception path
can trap again before it reaches the kprobe breakpoint handler. That
recursively enters do_trap_break() and can make the system
unresponsive.

Mark handle_break() and its local probe dispatch helpers as nokprobe
symbols so they are added to the kprobe blacklist, matching other
low-level breakpoint exception paths.

Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/20260806043807.2583001-1-qirui.001@bytedance.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a 3-line RISC-V kprobe blacklist restore that prevents recursive
breakpoint traps from hanging the machine. The local tree is
**6.12.111** (`pending-6.12`); the buggy `handle_break()` path is
present and the patch applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [riscv: kprobes] [Prevent] [Stop kprobes on RISC-V breakpoint
exception handlers so a probe on that path cannot recurse]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Rui Qi \<qirui.001@bytedance.com\> (author)
- Reviewed-by: Nam Cao \<namcao@linutronix.de\>
- Link: https://patch.msgid.link/20260806043807.2583001-1-
  qirui.001@bytedance.com
- Signed-off-by: Paul Walmsley \<pjw@kernel.org\> (RISC-V maintainer)
- No Fixes: tag (expected)
- No Reported-by / Tested-by / Cc: stable
- No syzbot

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `multiple_kprobes.tc` plants kprobes on the first 256
  `/proc/kallsyms` text symbols. If `handle_break()` is one of them, the
  breakpoint exception path hits another ebreak before
  `kprobe_breakpoint_handler()` runs.
- Symptom: recursive `do_trap_break()` → system unresponsive (hang).
- Root cause: those C helpers are not on the kprobe blacklist.
- Fix: `NOKPROBE_SYMBOL()` on `handle_break()`,
  `probe_breakpoint_handler()`, and `probe_single_step_handler()`.
- Version info: none in the message. The hang is RISC-V + kprobes, not a
  new-kernel-only issue.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. The subject says “Prevent” and the body describes a
hang. This is an explicit bug fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `arch/riscv/kernel/traps.c` only (+3 / −0)
- Functions: `probe_single_step_handler`, `probe_breakpoint_handler`,
  `handle_break`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: all three are normal `.text` symbols. `handle_break()` is
  global, so it is always in kallsyms. A kprobe on it patches ebreak at
  the function entry.
- Path: ebreak → `do_trap_break()` (noinstr) → `handle_break()` → ebreak
  again → nested `do_trap_break()` → hang/stack blow-up.
  `kprobe_breakpoint_handler()` is never reached because the trap
  happens at the start of `handle_break()`.
- After: the three symbols go in `_kprobe_blacklist`.
  `register_kprobe()` rejects them via `within_kprobe_blacklist()`
  (`kernel/kprobes.c`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [Logic / kprobe blacklist gap] [Breakpoint exception helpers
were probeable; probing them recurses into the same handler.] Category
is closest to a hang/deadlock-class failure, not UAF.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: `NOKPROBE_SYMBOL()` is the standard way to
  blacklist. x86 does the same with `NOKPROBE_SYMBOL(do_int3)`. RISC-V
  already uses `__kprobes` on `kprobe_breakpoint_handler()` itself.
- Minimal: three annotation lines, no control-flow change.
- Regression risk: very low. Blacklisting only refuses probes on those
  symbols; normal breakpoint/BUG/kgdb handling is unchanged.
- `linux/kprobes.h` is already included in `traps.c`. With
  `CONFIG_KPROBES=n`, `NOKPROBE_SYMBOL` is a no-op.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `handle_break()` created by `f0bddf50586da` (“riscv: entry: Convert to
  generic entry”, in v6.4-rc1). That commit **removed**
  `NOKPROBE_SYMBOL(do_trap_break)` when splitting `do_trap_break()` into
  a noinstr wrapper plus a C `handle_break()`.
- Wrappers `probe_*_handler()` added by `9f564b92cf6d0` (“riscv: Only
  consider swbp/ss handlers for correct privileged mode”, in v6.6-rc6).
- Both are ancestors of this 6.12 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. The dropped blacklist is from `f0bddf50586da`.
Earlier, `2349a3b26e29b` (“riscv: add do_page_fault and do_trap_break
into the kprobes blacklist”, 2021) added
`NOKPROBE_SYMBOL(do_trap_break)` with **Cc: stable** and Fixes:
`c22b0bcb1dd02` (“riscv: Add kprobes supported”). This patch restores
that protection after the generic-entry split.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `traps.c` churn (irq enable in exception handling,
misaligned traps) does not retarget these three functions. Not part of a
multi-patch series (standalone v1→v2 style-only). No extra prerequisite
beyond code already in 6.12.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Rui Qi is not the RISC-V maintainer. One other RISC-V commit in
this tree (`8b76013038478`, stacktrace). Reviewer Nam Cao has
substantial RISC-V kprobes work. Maintainer Paul Walmsley queued the
patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `NOKPROBE_SYMBOL`. Standalone. `git apply
--check` of the three-line hunk on this tree succeeded (exit 0).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c <msgid>` failed: commit is not in this checkout (`Cannot
  find a commit matching …`).
- lore.kernel.org fetches returned HTTP 403.
- Recovered from LKML/patchew/openwall:
  - v1: 2026-08-04, msgid
    `20260804064343.1865283-1-qirui.001@bytedance.com`
  - v2: 2026-08-06, msgid
    `20260806043807.2583001-1-qirui.001@bytedance.com` (applied version)
- v2 changelog: drop blank line before `NOKPROBE_SYMBOL()`; add Nam Cao
  Reviewed-by. No technical redesign.
- Paul Walmsley: “Thanks, queued for v7.3.” No NAK.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: v1 CC included Paul Walmsley, Palmer Dabbelt, Alexandre Ghiti,
Thomas Gleixner, Nam Cao, linux-riscv, linux-kernel. Nam Cao Reviewed-by
on v2. RISC-V maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. Concrete trigger is in-tree:
`tools/testing/selftests/ftrace/test.d/kprobe/multiple_kprobes.tc`
(first 256 kallsyms text symbols). Author describes a hang; that matches
the code path.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single patch, not 2/N. No follow-up required from the v2
discussion.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. No evidence this was
rejected for stable. The 2021 predecessor (`2349a3b26e29b`) was
explicitly Cc: stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `probe_single_step_handler`, `probe_breakpoint_handler`,
`handle_break`. Callers of `handle_break()` are only the two branches of
`do_trap_break()`.

**Step 5.2: TRACE CALLERS**
Record:
- Exception vector in `arch/riscv/kernel/entry.S` (`RISCV_PTR
  do_trap_break`)
- `do_trap_break()` (noinstr / `__trap_section`) already blacklisted via
  `__noinstr_text_*` in `populate_kprobe_blacklist()`
- `do_trap_break()` → `handle_break()` (not noinstr, not blacklisted
  today)
- `handle_break()` → probe helpers → `kprobe_*_handler()` (`__kprobes`,
  already blacklisted) or SIGTRAP/BUG/kgdb

Context: breakpoint exception, including kernel ebreak from kprobes.

**Step 5.3: TRACE CALLEES**
Record: `user_mode()`, `uprobe_*` / `kprobe_*` handlers,
`force_sig_fault`, `notify_die`, `report_bug`, `handle_cfi_failure`,
`die()`. No allocations or new locks in the patch (annotations only).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from userspace tracing when `CONFIG_KPROBES` is on:
write to `kprobe_events` or equivalent (typically CAP_SYS_ADMIN /
CAP_PERFMON). Also reachable from the ftrace kprobe selftest. Not a
default-defconfig path (`CONFIG_KPROBES` is optional, RISC-V defconfig
does not set it), but distro/debug kernels enable it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same pattern on x86 (`NOKPROBE_SYMBOL(do_int3)`), s390, powerpc,
loongarch kprobe handlers. RISC-V `kprobe_breakpoint_handler` already
uses `__kprobes`. The missing piece is the C trampoline
`handle_break()`, which is what generic-entry introduced.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `arch/riscv/kernel/traps.c` lines 269–305 define the three
functions with no `NOKPROBE_SYMBOL`. `HAVE_KPROBES` is selected for
RISC-V when `!XIP_KERNEL`. Bug introduced when
`NOKPROBE_SYMBOL(do_trap_break)` was dropped in v6.4 (`f0bddf50586da`);
wrappers present since v6.6. Present throughout 6.12.y.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Local `do_trap_break()` has extra
`local_irq_enable/disable` from `32b14e757404c`, below the insertion
points, so it does not conflict. `git apply --check` succeeded.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No `NOKPROBE_SYMBOL` in `traps.c` now. `do_trap_break` is still
noinstr-blacklisted, which is not enough because it calls out to
`handle_break()`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [arch/riscv kprobes/traps] [IMPORTANT for RISC-V tracing;
PERIPHERAL relative to all architectures]. Not core mm/scheduler, but a
hang in the arch breakpoint path.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: RISC-V traps/kprobes are mature in 6.12 (kprobes since 5.13).
This is a long-standing hole, not a brand-new feature bug.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: RISC-V kernels with `CONFIG_KPROBES` (and not XIP). Tracing
users, ftrace kprobe selftests, distro kernels that enable kprobes. Not
every 6.12 user.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Plant a kprobe on `handle_break` (or the static helpers if they
have kallsyms entries), then any kernel/user breakpoint that enters
`handle_break()`. The selftest can do that if `handle_break` is among
the first 256 text symbols (address-order, so platform-dependent).
Explicit `perf probe` / `kprobe_events` on that symbol is a reliable
trigger. Needs tracing privilege, not an unprivileged local DoS on
typical configs.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: [Recursive breakpoint exception → hang / unresponsive system]
[CRITICAL for those who hit it]. Not data corruption. Not an
unprivileged security bug on typical kprobe policy.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: HIGH for RISC-V kprobe users (prevents hang; restores
  blacklist that stable already shipped once).
- Risk: VERY LOW (3 annotation lines, no runtime logic change).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hang: recursive ebreak in the breakpoint path.
- In-tree selftest is a plausible trigger; any probe on `handle_break`
  is a hard trigger.
- Restores protection that `2349a3b26e29b` put on `do_trap_break` (Cc:
  stable) and that `f0bddf50586da` dropped.
- Matches other architectures’ nokprobe on low-level BP handlers.
- 3 lines, obviously correct, reviewed by Nam Cao, queued by Paul
  Walmsley.
- Buggy code is in this 6.12 tree; patch applies cleanly.

AGAINST:
- Not on by default in RISC-V defconfig (`CONFIG_KPROBES` optional).
- Needs privileged tracing to trigger.
- No Fixes:/Cc: stable on this commit (not a negative per the review
  rules).
- Arch-specific, so only RISC-V 6.12 users benefit.

UNRESOLVED:
- Exact Nam Cao review email body (lore 403). v2 only changed whitespace
  and added Reviewed-by.
- Whether `handle_break` is in the first 256 kallsyms on a typical 6.12
  RISC-V vmlinux (unverified; hang if probed is verified from code
  regardless).
- `b4 dig` could not run against a SHA not in this checkout.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard `NOKPROBE_SYMBOL`;
   maintainer queued; reviewer Ack.
2. Fixes a real bug that affects users? **PASS** — hang when kprobes
   lands on `handle_break`.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   system hang / unresponsive.
4. Small and contained? **PASS** — +3 lines, one file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean on
   6.12.111.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
hang fix.

**Step 9.4: MAKE YOUR DECISION**
This belongs on 6.12.y. It restores a kprobe blacklist that this tree
lost in the generic-entry split, with essentially no behavioral change
except refusing probes that can wedge the machine.

Detailed explanation:
The problem is that RISC-V kprobes implement software breakpoints with
ebreak. `do_trap_break()` is noinstr (already blacklisted), but it
immediately calls `handle_break()`, which is ordinary C text. If a
kprobe is installed on `handle_break()`, the first instruction is
ebreak, so the exception path traps again before
`kprobe_breakpoint_handler()` can run. That recurses until the system
stops responding. Marking the three symbols `NOKPROBE_SYMBOL` puts them
on the same blacklist `register_kprobe()` already consults. Stable users
who enable kprobes (tracing, selftests, distro debug kernels) are the
ones who hit this; the cost of the backport is three annotations.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Nam Cao; Link msgid
  20260806043807.2583001-1; Paul Walmsley SOB; no Fixes/syzbot
- [Phase 2] Diff: +3 `NOKPROBE_SYMBOL` lines in
  `arch/riscv/kernel/traps.c`; no control-flow change
- [Phase 2] Confirmed `traps.c` already `#include <linux/kprobes.h>`
- [Phase 2] Confirmed `register_kprobe()` rejects
  `within_kprobe_blacklist()` addresses (`kernel/kprobes.c` ~1593)
- [Phase 2] Confirmed `NOKPROBE_SYMBOL` writes `_kprobe_blacklist`
  (`include/asm-generic/kprobes.h`)
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  p-6.12-3-gc504cf0baa3d8, 6.12.111
- [Phase 3] blame: `handle_break` from `f0bddf50586da` (v6.4-rc1);
  wrappers from `9f564b92cf6d0` (v6.6-rc6)
- [Phase 3] `git show f0bddf50586da`: removed
  `NOKPROBE_SYMBOL(do_trap_break)` while splitting the function
- [Phase 3] `2349a3b26e29b` originally blacklisted `do_trap_break` with
  Cc: stable
- [Phase 3] `git merge-base --is-ancestor` both introducing commits are
  in HEAD
- [Phase 4] b4 dig: no matching commit in this tree (UNVERIFIED via b4)
- [Phase 4] v1/v2 recovered from lkml.iu.edu / openwall / patchew; v2 is
  style-only + Reviewed-by
- [Phase 4] Paul Walmsley: queued for v7.3 (patchew)
- [Phase 4] lore.kernel.org and stable@ search: HTTP 403 (UNVERIFIED via
  lore)
- [Phase 4] Nam Cao review body: UNVERIFIED (openwall msg id collision);
  Reviewed-by on v2 is verified
- [Phase 5] Callers: `entry.S` → `do_trap_break` → `handle_break`;
  `do_trap_break` is `__trap_section`/`noinstr`
- [Phase 5] `kprobe_breakpoint_handler` already `__kprobes` in
  `arch/riscv/kernel/probes/kprobes.c`
- [Phase 5] Selftest `multiple_kprobes.tc` confirmed to take first 256
  kallsyms text symbols
- [Phase 5] x86 comparison: `NOKPROBE_SYMBOL(do_int3)` in
  `arch/x86/kernel/traps.c:826`
- [Phase 6] Current `traps.c` has no `NOKPROBE_SYMBOL`; buggy helpers
  present at lines 269–305
- [Phase 6] `git apply --check` of the three-line hunk: exit 0
- [Phase 7] `arch/riscv/Kconfig`: `select HAVE_KPROBES if !XIP_KERNEL`
- [Phase 8] RISC-V defconfig does not set `CONFIG_KPROBES` (trigger is
  config-specific)
- UNVERIFIED: whether `handle_break` is in the first 256 kallsyms on a
  typical 6.12 RISC-V build (does not change the hang if that symbol is
  probed)

**YES**

 arch/riscv/kernel/traps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 47afea4ff1a8d..e7e45cbb08999 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -272,6 +272,7 @@ static bool probe_single_step_handler(struct pt_regs *regs)
 
 	return user ? uprobe_single_step_handler(regs) : kprobe_single_step_handler(regs);
 }
+NOKPROBE_SYMBOL(probe_single_step_handler);
 
 static bool probe_breakpoint_handler(struct pt_regs *regs)
 {
@@ -279,6 +280,7 @@ static bool probe_breakpoint_handler(struct pt_regs *regs)
 
 	return user ? uprobe_breakpoint_handler(regs) : kprobe_breakpoint_handler(regs);
 }
+NOKPROBE_SYMBOL(probe_breakpoint_handler);
 
 void handle_break(struct pt_regs *regs)
 {
@@ -303,6 +305,7 @@ void handle_break(struct pt_regs *regs)
 	else
 		die(regs, "Kernel BUG");
 }
+NOKPROBE_SYMBOL(handle_break);
 
 asmlinkage __visible __trap_section void do_trap_break(struct pt_regs *regs)
 {
-- 
2.53.0

