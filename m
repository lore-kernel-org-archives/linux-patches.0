Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A8047DF86;
	Mon, 31 Aug 2026 13:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183458; cv=none; b=HnPtJ49THqVWc32flmgXKszAHQKOezJVpPT5JNEqLiTr8uSQqvaNiie5+8BXJz5KxN+9Bb55kXoMWlQ11XViSK2DOK6BP20GW0SYVxJ5cYzIZN0mFAhnEv3MpdnZ8CCpfPKm5JkEXnPKrKJ7MtjGNB/YiRi+YQFuv/7NMN7nGLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183458; c=relaxed/simple;
	bh=+hBV3VC8oghTFATaE06fBctpbwHYg/11NE4p8sUtRwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LhrM2RUfGgsze2WBDEiK8kgRNb9Etc1hG46qaCkolIBT5QjFDVv9Ct8jjVIBuqauYaSf5wH6XH4Z+1jdHEGLR959qHRdxy7A6mbh4HaZlhz3YT48rUGW5gWfPtIRZRPQ2nl1uxy/A/RhUFAm6oOOHjvQjIZ+jL7+7UZoe5SowBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPCkp9kJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPCkp9kJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425731F000E9;
	Mon, 31 Aug 2026 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183456;
	bh=hp0zo/g+UZnqTLyekrqgz6rWmUrXHOudIzqku7WJKes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPCkp9kJ4jh0YSbsWckfQ9iarRPGisC5SS8JjKZPDVgEAPs/IANTa/lROLfHnS1xp
	 MSZm+irJzp+tb5cjND0oDq0+4UWNq2cGodD1YW/K9V/Qh548bYcuuhvqb2t+eplvQf
	 7Tb8+DeXRWZpruM+OB3EpTfx7Iv88ecEspgLFqfNQhz84y/iux2O2oncAeQZ8skZDj
	 X9+4cJhq+3ic0aNHdNckt97fP7+HL1t5nZ0Atnmm+b1v1G0UpKmdnZi7jP8xQSlLcY
	 7g2+WgppuC4QfPQjQQCwlyWVAU1P6PbhZpomGro4fN9DWKYKgUQisuhgmzDPt/M4YX
	 gbnbae7RWMO6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	mhiramat@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] tracing: Disable KCOV instrumentation for trace_irqsoff.o
Date: Mon, 31 Aug 2026 09:22:15 -0400
Message-ID: <20260831133314.4125787-107-sashal@kernel.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 01046072880b654dbadf71be2f645aad4a7b5d87 ]

When KCOV runs its boot selftest with whole-kernel instrumentation
enabled, it sets current->kcov_mode to KCOV_MODE_TRACE_PC without
installing a coverage area. Any instrumented code accepted as task-context
coverage in that window dereferences current->kcov_area and crashes.

On ARMv5 Versatile PB with CONFIG_KCOV_SELFTEST=y,
CONFIG_KCOV_INSTRUMENT_ALL=y and CONFIG_IRQSOFF_TRACER=y, boot hits a
NULL pointer fault during the selftest:

  kcov: running self test
  Internal error: Oops: 5 [#1] ARM
  PC is at __sanitizer_cov_trace_pc+0x4c/0x90
  Kernel panic - not syncing: Fatal exception

A diagnostic run showed the unwanted coverage comes from the IRQs-off
tracer callbacks reached from ARM IRQ entry before hardirq context is
visible to KCOV:

  __sanitizer_cov_trace_pc from tracer_hardirqs_off+0x18/0x1cc
  tracer_hardirqs_off from trace_hardirqs_off+0x34/0x54
  trace_hardirqs_off from __irq_svc+0x58/0xb0
  __irq_svc from kcov_init+0x7c/0xdc

and similarly through tracer_hardirqs_on().

trace_preemptirq.o is already excluded because this tracing path can run
from early interrupt code and produce coverage unrelated to syscall
inputs. Exclude trace_irqsoff.o as well, instead of requiring users to
turn off CONFIG_KCOV_INSTRUMENT_ALL=y, which is the default whole-kernel
KCOV mode.

With the exclusion in place, the same ARMv5 Versatile PB QEMU test boots
through the KCOV selftest and reaches userspace.

Tested on ARMv5 Versatile PB QEMU with CONFIG_KCOV_SELFTEST=y,
CONFIG_KCOV_INSTRUMENT_ALL=y and CONFIG_IRQSOFF_TRACER=y.

Link: https://patch.msgid.link/20260525170428.67211-1-kmehltretter@gmail.com
Assisted-by: Codex:gpt-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[tracing] [disable] Disable KCOV instrumentation for
trace_irqsoff.o` — tracing subsystem; disables KCOV instrumentation on
one object file to prevent a boot crash.

### Step 1.2: Tags
**Record:**
- **Link:**
  https://patch.msgid.link/20260525170428.67211-1-kmehltretter@gmail.com
- **Assisted-by:** Codex:gpt-5
- **Signed-off-by:** Karl Mehltretter `<kmehltretter@gmail.com>`
- **Signed-off-by:** Steven Rostedt `<rostedt@goodmis.org>` (tracing
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer sign-off; tested configuration described in body;
  no syzbot report

### Step 1.3: Body analysis
**Record:**
- **Bug:** With `CONFIG_KCOV_SELFTEST=y`,
  `CONFIG_KCOV_INSTRUMENT_ALL=y`, and `CONFIG_IRQSOFF_TRACER=y`, KCOV
  boot selftest sets `current->kcov_mode = KCOV_MODE_TRACE_PC` without
  installing a coverage area. Instrumented IRQ-off tracer code reached
  from ARM IRQ entry can call `__sanitizer_cov_trace_pc()`, which
  dereferences NULL `current->kcov_area`.
- **Symptom:** NULL pointer fault / kernel panic during boot on ARMv5
  Versatile PB QEMU: `PC is at __sanitizer_cov_trace_pc`, panic during
  `kcov: running self test`.
- **Root cause:** `trace_irqsoff.o` is still KCOV-instrumented while
  `trace_preemptirq.o` was already excluded; `tracer_hardirqs_off()` /
  `tracer_hardirqs_on()` live in `trace_irqsoff.c` and run from IRQ
  entry before hardirq context is visible to KCOV’s `in_task()`
  filtering.
- **Stack trace (from message):** `__sanitizer_cov_trace_pc` ←
  `tracer_hardirqs_off` ← `trace_hardirqs_off` ← `__irq_svc` ←
  `kcov_init`.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although framed as instrumentation exclusion, this is a
real boot crash fix for a valid Kconfig combination, completing the same
class of fix already applied to `trace_preemptirq.o` in commit
`bb5eb8f3b3297` (2022).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `kernel/trace/Makefile` only (+3/-2 lines net)
- **Change:** Add `KCOV_INSTRUMENT_trace_irqsoff.o := n`; broaden
  comment from “this file” to “these files”
- **Scope:** Single-file, surgical Makefile change

### Step 2.2: Code flow
**Record:**
- **Before:** Only `trace_preemptirq.o` excluded from KCOV;
  `trace_irqsoff.o` remains instrumented when
  `CONFIG_KCOV_INSTRUMENT_ALL=y`.
- **After:** Both `trace_preemptirq.o` and `trace_irqsoff.o` excluded.
- **Affected path:** IRQ entry/exit →
  `trace_hardirqs_off()`/`trace_hardirqs_on()` (uninstrumented wrapper
  in `trace_preemptirq.c`) →
  `tracer_hardirqs_off()`/`tracer_hardirqs_on()` (instrumented
  implementation in `trace_irqsoff.c`) → `__sanitizer_cov_trace_pc()`.

### Step 2.3: Bug mechanism
**Record:** **Category:** NULL pointer dereference / boot crash in debug
instrumentation path.
- `kcov_init()` selftest sets `kcov_mode` without `kcov_area` (verified
  in `kernel/kcov.c:1097-1098`).
- `check_kcov_mode()` allows tracing when `in_task()` is true
  (`kernel/kcov.c:183-184`); during early ARM IRQ handling,
  `preempt_count` may not yet reflect hardirq context
  (`include/linux/preempt.h:130`).
- Instrumented `tracer_hardirqs_*()` in `trace_irqsoff.o` calls
  `__sanitizer_cov_trace_pc()` which dereferences `t->kcov_area` at line
  220 without NULL guard.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors existing
`KCOV_INSTRUMENT_trace_preemptirq.o := n` pattern from `bb5eb8f3b3297`.
Minimal, no API changes. Regression risk very low — only disables KCOV
on code that should never contribute syscall-relevant coverage anyway.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Lines 34-36 in `kernel/trace/Makefile` introduced by
`bb5eb8f3b3297` (Congyu Liu, 2022-05-23) — preemptirq exclusion only.
`trace_irqsoff.c` has existed since `81d68a96a3984` (2008). The gap
(preemptirq excluded, irqsoff not) has been present since the 2022 fix.

### Step 3.2: Fixes: tag
**Record:** Not applicable — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent `trace_irqsoff.c` changes are unrelated tracer fixes
(e.g. `c834a97962c70`). No prerequisite series; standalone one-line
Makefile fix. The candidate commit is not yet in this tree (fix absent
from current `kernel/trace/Makefile`).

### Step 3.4: Author context
**Record:** Steven Rostedt signed off (tracing maintainer). Prior
related fix `bb5eb8f3b3297` was Acked-by Dmitry Vyukov (KCOV author).
Karl Mehltretter appears to be reporting/fixing a gap in the 2022
exclusion.

### Step 3.5: Dependencies
**Record:** No dependencies. Uses standard `KCOV_INSTRUMENT_<stem>.o`
mechanism in `scripts/Makefile.lib:84-90`. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** UNVERIFIED — `b4 shazam` could not find the message-id;
lore.kernel.org returns 403/bot protection via WebFetch and curl. Link
from commit message could not be fetched.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 dig -w (could not locate thread). Steven
Rostedt SOB confirms maintainer acceptance.

### Step 4.3: Bug report
**Record:** Reproduced by author on ARMv5 Versatile PB QEMU with
documented Kconfig. No syzbot/bugzilla link. Severity: boot panic during
KCOV selftest.

### Step 4.4: Related patches
**Record:** Direct predecessor: `bb5eb8f3b3297 tracing: Disable kcov on
trace_preemptirq.c` — same rationale, incomplete because tracer
implementation lives in separate `trace_irqsoff.o`.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search lore stable archive due to
access restrictions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `tracer_hardirqs_off()`, `tracer_hardirqs_on()` in
`trace_irqsoff.c`; `trace_hardirqs_off()`, `trace_hardirqs_on()` in
`trace_preemptirq.c`; `__sanitizer_cov_trace_pc()`, `check_kcov_mode()`,
`selftest()`, `kcov_init()` in `kcov.c`.

### Step 5.2: Callers
**Record:** `trace_hardirqs_off`/`on` called from ARM entry code
(`arch/arm/kernel/entry-header.S:208,215,217` via `svc_exit`;
`arch/arm/kernel/entry-armv.S:210`). Exported symbols used broadly
across architectures for IRQ flag tracing. `kcov_init` is
`device_initcall` — runs during boot with interrupts enabled.

### Step 5.3: Callees
**Record:** `tracer_hardirqs_off()` → `start_critical_timing()`; KCOV-
instrumented code in `trace_irqsoff.o` inserts calls to
`__sanitizer_cov_trace_pc()`.

### Step 5.4: Reachability
**Record:** Triggered during boot when KCOV selftest runs
(`device_initcall`) and a timer interrupt fires during the 300ms wait
loop. Reachable with `CONFIG_KCOV=y`, `CONFIG_KCOV_SELFTEST=y`,
`CONFIG_KCOV_INSTRUMENT_ALL=y` (default **y** per
`lib/Kconfig.debug:2149`), and `CONFIG_IRQSOFF_TRACER=y` or
`CONFIG_PREEMPT_TRACER=y` (both build `trace_irqsoff.o`).

### Step 5.5: Similar patterns
**Record:** Extensive KCOV exclusions across tree (mm/, lib/, kernel/,
arch/*/entry/, `kernel/trace/Makefile` for preemptirq). This fix fills
an obvious gap in the same file/pattern.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **Linux 6.18.44** (`git describe
HEAD` → `v6.18.44`). `kernel/trace/Makefile` has only:
```34:36:kernel/trace/Makefile
# Functions in this file could be invoked from early interrupt
# code and produce random code coverage.
KCOV_INSTRUMENT_trace_preemptirq.o := n
```
`trace_irqsoff.o` is built (lines 62-63) but not excluded. All
KCOV/selftest infrastructure present (`lib/Kconfig.debug`,
`kernel/kcov.c`).

### Step 6.2: Backport complications
**Record:** Clean apply expected — exact context matches the proposed
diff. No conflicting changes in this area.

### Step 6.3: Related fixes already present?
**Record:** Partial fix `bb5eb8f3b3297` is present (preemptirq only).
This specific irqsoff exclusion is **not** present. No duplicate fix
found.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** **tracing + KCOV** — IMPORTANT for kernel developers,
fuzzers (syzkaller per `KCOV_INSTRUMENT_ALL` help text), and CI systems
using KCOV selftest. Not universal production path, but KCOV is
security-relevant infrastructure.

### Step 7.2: Subsystem activity
**Record:** tracing subsystem actively maintained in 6.18.y (recent
irqsoff tracer fixes in 2025).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Config-specific — users/distributions building with KCOV
enabled, especially `KCOV_SELFTEST` (Kconfig says “Recommended to be
enabled”) and whole-kernel instrumentation (`KCOV_INSTRUMENT_ALL`,
default y). Affects fuzzing/CI/boot-validation workflows, not typical
end-user kernels without KCOV.

### Step 8.2: Trigger conditions
**Record:** Boot-time, with KCOV selftest + instrument-all +
irqsoff/preempt tracer enabled; timer interrupt during selftest wait
loop. Not userspace-triggerable on production kernels without KCOV, but
reliably reproducible in the described test config.

### Step 8.3: Failure mode severity
**Record:** NULL pointer dereference → kernel oops → **panic during
boot**. Severity: **CRITICAL** for affected configurations (system does
not reach userspace).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents deterministic boot panic for valid, documented
  Kconfig used in fuzzing/CI; completes incomplete 2022 fix.
- **Risk:** Very low — one Makefile line, established exclusion
  mechanism, no behavior change except suppressing inappropriate KCOV
  callbacks.
- **Ratio:** Favorable for backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real boot crash (NULL deref in `__sanitizer_cov_trace_pc`)
- Small, surgical, obviously correct fix following existing pattern
- Bug exists in 6.18.44 tree; fix not yet applied
- `KCOV_INSTRUMENT_ALL` defaults to y; `KCOV_SELFTEST` recommended in
  Kconfig
- Maintainer (Rostedt) signed off
- Completes gap left by `bb5eb8f3b3297`

**AGAINST backport:**
- Only affects KCOV debug/fuzzing configurations, not typical production
  kernels
- No syzbot/CVE report
- Mailing list review details unverified

**Unresolved:** Full lore thread content; whether reviewers explicitly
nominated for stable.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — author tested on ARMv5 QEMU;
   mechanism verified in code; mirrors prior accepted fix.
2. Fixes a real bug? **PASS** — boot panic with documented Kconfig.
3. Important issue? **PASS** — boot crash (CRITICAL for affected
   config); KCOV is fuzzing/security infrastructure.
4. Small and contained? **PASS** — 1 line + comment, single Makefile.
5. No new features/APIs? **PASS** — build-time instrumentation exclusion
   only.
6. Can apply to local tree? **PASS** — code present, clean apply
   expected.

### Step 9.3: Exception categories
**Record:** Build/instrumentation fix for valid kernel configuration —
analogous to existing KCOV exclusion pattern (similar to build-fix
category for instrumented builds).

### Step 9.4: Decision rationale

For **Linux 6.18.44**, this commit should be backported. The tree has
the incomplete 2022 preemptirq KCOV exclusion but not the irqsoff one,
leaving `tracer_hardirqs_*()` instrumented. Combined with KCOV selftest
(which deliberately enables tracing without a coverage area), this
causes a deterministic boot panic on interrupt during `kcov_init()`. The
fix is minimal, follows an established in-tree pattern, is signed by the
tracing maintainer, and has very low regression risk while preventing a
hard boot failure for KCOV/fuzzing configurations that stable trees are
expected to support.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified boot panic bug and
  maintainer SOB
- [Phase 2] Diff: 1 Makefile line added; verified call chain preemptirq
  wrapper → irqsoff tracer → `__sanitizer_cov_trace_pc`
- [Phase 3] `git describe HEAD`: v6.18.44 / 6.18.44
- [Phase 3] `git blame kernel/trace/Makefile:34-36`: `bb5eb8f3b3297`
  (2022-05-23)
- [Phase 3] `git show bb5eb8f3b3297`: prior preemptirq-only exclusion
  confirmed
- [Phase 3] `trace_irqsoff.c` exists since 2008 (`81d68a96a3984`)
- [Phase 3] Fix commit not in tree; `KCOV_INSTRUMENT_trace_irqsoff.o`
  absent
- [Phase 4] UNVERIFIED: lore/b4 thread inaccessible (403/bot protection,
  message-id not found)
- [Phase 5] Read `kernel/kcov.c:174-220,1080-1132`: selftest sets mode
  without area; `check_kcov_mode` + NULL `kcov_area` deref confirmed
- [Phase 5] Read `kernel/trace/trace_irqsoff.c:643-647`,
  `trace_preemptirq.c:102-109`: tracer in irqsoff.o, wrapper in
  preemptirq.o
- [Phase 5] Read `arch/arm/kernel/entry-header.S:202-218`:
  `trace_hardirqs_off/on` called from `svc_exit` during IRQ handling
- [Phase 5] Read `include/linux/preempt.h:130`: `in_task()` based on
  preempt_count hardirq bits
- [Phase 5] Read `scripts/Makefile.lib:84-90`:
  `KCOV_INSTRUMENT_<stem>.o` mechanism confirmed
- [Phase 6] Current `kernel/trace/Makefile` missing irqsoff exclusion;
  `trace_irqsoff.o` built at lines 62-63
- [Phase 6] `lib/Kconfig.debug:2146-2172`: `KCOV_INSTRUMENT_ALL` default
  y; `KCOV_SELFTEST` recommended
- [Phase 8] Failure mode: boot panic, severity CRITICAL for affected
  Kconfig

**YES**

 kernel/trace/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index dcb4e02afc5f4..36b3ed5251f46 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -31,9 +31,10 @@ ifdef CONFIG_GCOV_PROFILE_FTRACE
 GCOV_PROFILE := y
 endif
 
-# Functions in this file could be invoked from early interrupt
-# code and produce random code coverage.
+# Functions in these files can run from IRQ entry before hardirq context
+# is visible to KCOV, and produce coverage unrelated to syscall inputs.
 KCOV_INSTRUMENT_trace_preemptirq.o := n
+KCOV_INSTRUMENT_trace_irqsoff.o := n
 
 CFLAGS_bpf_trace.o := -I$(src)
 
-- 
2.53.0

