Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C26621505;
	Mon, 19 Oct 2026 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418697; cv=none; b=aDSTOOw+nWM5AUCdvgtnSRAX6xmmYZ+y+4d54gfxqSu6zfvBWnaeA4oIE8PxuvFesOnB59ZQCLLb++suBcOkjlZdDOHf4o790j2VnR+a6LeXqU2jTcafyoW+K7fxIj5ttEXc0xWoKHfGhOksSeN3m1qEl+oa5lsd60lt7lrTO9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418697; c=relaxed/simple;
	bh=5nt6FBBMSB37irf5lU9t8ENVFzTcZrh2wv8AYc4GH4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PEGZR7dj4463gw7jB+hcqWt5Uwg20VwPGatjqpYLOuPuHvO7LYF+OOEndmsiNt9LuNmdrNkEC95N8r0T+Tb2iDYGM5R4hOKdxd3hYppEcytYgGm481Sj8HBempjGszMJUzAxOC48qpB6lbBagEXhkjumD0idwL4HJFW7lJk0GLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjgIxXQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjgIxXQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AA41F000C8;
	Mon, 19 Oct 2026 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418694;
	bh=dgp4N+Duj5/rxOrnO9VHrwkdldukdQcwu8ChtCI4m18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjgIxXQFtswTQGzTIW7eCLAWJzy+PEO0k83lRuvFU7Id3u2okuF06PLK3nBfp1VIQ
	 H+ilnvXnBY4Cnou5xNb72bItTGvX9aLqTSE2c26fvzFak0HRtirkC0hNwZyja45Qpo
	 tGJIdpX1CPv0FLhKjvD8xtkXcdTp9m+AaHOZpZcSD+g+TC/y6IYr9jb81ffqcRHUmA
	 l2oaWWgr2GkgEgLmVres7QWB/SsZwK0JEy4Dl9zQRFbmsiMwg8sQcucCzqIYcmM/ra
	 67v0+i3W8WVmolPNtZsGjiXO4QvQg/wxc26wSy5wCAlyOq8fxrZfIR2MOe+U5cmVoj
	 6WCtcSOWxWmHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Petr Mladek <pmladek@suse.com>,
	kernel test robot <lkp@intel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] nbcon/reboot: Switch NBCON consoles into the emergency mode in emergency_restart()
Date: Mon, 19 Oct 2026 09:52:01 -0400
Message-ID: <20261019135441.1420968-430-sashal@kernel.org>
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

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit d8e5fc3002294a28af53e97f6c83a35956e738f3 ]

When the system is going down a normal way, the NBCON kthreads are
flushed and stopped properly via a syscore shutdown callback, see
printk_kthreads_shutdown().

One missing piece is emergency_restart() where the kthreads are not
stopped. It might be called from several non-panic code paths,
e.g. sysrq-o, kdb_reboot(), or some watchdogs.

Fix it by explicitly entering the emergency (atomic) mode and trying
to flush the consoles there.

Note that printk_trigger_flush() must be used instead of pr_flush()
because the later is not safe in an atomic context.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202608061008.48a1e76e-lkp@intel.com/
Suggested-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20261013154141.94016-1-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57**. This is a real NBCON flush gap on
`emergency_restart()`, the APIs already exist here, and the change is a
small best-effort flush before reboot.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[nbcon/reboot] [Switch] Switch NBCON consoles into emergency
(atomic) mode in `emergency_restart()`** so pending printk output is
flushed instead of being left in kthreads that never get stopped.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Reported-by:** kernel test robot `<lkp@intel.com>`
- **Closes:**
  `https://lore.kernel.org/all/202608061008.48a1e76e-lkp@intel.com/`
- **Suggested-by:** John Ogness `<john.ogness@linutronix.de>`
- **Reviewed-by:** John Ogness `<john.ogness@linutronix.de>`
- **Link:**
  `https://patch.msgid.link/20261013154141.94016-1-pmladek@suse.com`
- **Signed-off-by:** Petr Mladek `<pmladek@suse.com>` (printk
  maintainer)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`

Notable: LKP report plus review by the NBCON designer. Not syzbot/KASAN;
this is a console-flush failure, not a memory-safety crash.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** Normal reboot stops NBCON printer kthreads via
  `printk_kthreads_shutdown()` (syscore shutdown). `emergency_restart()`
  skips that path.
- **Symptom:** Last kernel messages may never appear on NBCON consoles
  before the machine resets (LKP: “kernel reboot-without-warning”).
- **Failure mode:** Lost diagnostic output on sysrq reboot, kdb reboot,
  watchdogs, and other non-panic emergency restart paths. The commit
  says “sysrq-o”; the actual sysrq reboot op in this tree is **sysrq-b**
  (`drivers/tty/sysrq.c`). That is a message inaccuracy, not a code
  issue.
- **Root cause:** With kthreads still running, flush stays in offload
  mode (`nbcon_offload`) instead of atomic mode (`nbcon_atomic`).
- **Fix:** Enter NBCON emergency mode, then `printk_trigger_flush()`.
  `pr_flush()` is not used because it is not atomic-safe;
  `emergency_restart()` is documented as IRQ-safe.
- **Version note:** Committed to printk `for-7.3-hotfix`. The same
  kthread/emergency infrastructure is already in 6.18.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. Explicit bug fix for missed console
flush on emergency restart.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `kernel/reboot.c` (**+9**, 0 removed in the functional hunk;
  plus `#include <linux/console.h>`)
- Function: `emergency_restart()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before (v6.18.57):** `kmsg_dump(KMSG_DUMP_EMERG)` → `system_state =
  SYSTEM_RESTART` → `machine_emergency_restart()`. No console flush;
  kthreads are left running and then the CPU resets.
- **After:** same dump/state, then `nbcon_cpu_emergency_enter()` +
  `printk_trigger_flush()`, then `machine_emergency_restart()`.
- Path affected: emergency restart only (sysrq-b, kdb, watchdogs,
  hangcheck, ocfs2 quorum, amdgpu RAS, hw-protection fallback). Not the
  orderly `kernel_restart()`/`kernel_power_off()` paths that already
  call `syscore_shutdown()`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** logic / correctness (console flush), with a hardware-
  observability effect
- **Mechanism:** `printk_get_console_flush_type()` uses
  `nbcon_get_default_prio()`. Normal prio with `printk_kthreads_running`
  sets `nbcon_offload` (wake kthreads). Emergency prio sets
  `nbcon_atomic` (flush via `write_atomic()` in the caller).
- `nbcon_cpu_emergency_enter()` raises per-CPU emergency nesting (and
  `preempt_disable`). `printk_trigger_flush()` then calls
  `nbcon_atomic_flush_pending()`.
- No matching `nbcon_cpu_emergency_exit()`:
  `machine_emergency_restart()` is not expected to return. The RFC had
  an unreachable exit after it; v2 correctly dropped it.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: same emergency-enter pattern as `oops_enter()` /
  `__warn()`.
- Minimal: two calls and one include.
- Regression risk: low. Best-effort atomic flush immediately before
  reboot. Nested enter from `panic()` → `emergency_restart()` is safe
  (nesting counter). If `machine_emergency_restart()` ever returned,
  preemption would stay disabled; that is already a “reboot failed” dead
  end (`kdb_reboot()` already spins). John Ogness noted it is still
  best-effort if another CPU owns the console.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `emergency_restart()` itself: `15d94b82565eb` (Robin Holt, 2013).
- The actual bug is the later NBCON kthread model, not that 2013
  function.
- Introducers present in this tree:
  - `ecb5e1aa82c86` (2024-08-21) `printk: nbcon: Implement emergency
    sections`
  - `76f258bf3f2aa` (2024-09-04) `printk: nbcon: Introduce printer
    kthreads`
  - `13189fa73afae` (2024-09-04) `printk: nbcon: Rely on kthreads for
    normal operation`
- All three are ancestors of `v6.18.57`.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Not applicable. The missing piece is
`emergency_restart()` vs `printk_kthreads_shutdown()`, which exists in
this tree at `kernel/printk/printk.c`.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent `kernel/reboot.c` history is reboot/hw-protection work, plus
  `6ea9a1781c70a` “Flush console log from kernel_power_off()” (already
  in 6.18.57, uses `pr_flush()` on the orderly power-off path after
  `syscore_shutdown()`).
- Standalone v2. v1 also patched `nbcon_get_default_prio()` and orderly
  reboot/halt; John Ogness rejected that as too broad. v2 only touches
  `emergency_restart()`. No extra series patches required.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Petr Mladek is the printk maintainer. Related history is
NBCON/panic/printk merge work. Suggested and reviewed by John Ogness
(NBCON designer). Strong maintainer signal.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needs `nbcon_cpu_emergency_enter()` (`include/linux/console.h`, stub
  if `!CONFIG_PRINTK`) — present in v6.18.57.
- Needs `printk_trigger_flush()` (`include/linux/printk.h`) — present in
  v6.18.57.
- `printk_trigger_flush` is already visible in `reboot.c` via
  `linux/suspend.h` → `linux/printk.h`. The new include is for
  `nbcon_cpu_emergency_enter()`.
- Can apply standalone. Confirmed: `git merge-base --is-ancestor
  b140889fb6c82 v6.18.57` is false (not in the 6.18.57 baseline); the
  function/APIs the patch uses are in that baseline.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Lore/v2:
  `https://patch.msgid.link/20261013154141.94016-1-pmladek@suse.com`
- **v1:**
  `https://lore.kernel.org/r/20261008150852.8286-1-pmladek@suse.com`
  (“Flush nbcon consoles synchronously on reboot”) — broader
  `system_state > SYSTEM_RUNNING` → `NBCON_PRIO_EMERGENCY` plus extra
  flushes on orderly restart/halt.
- John Ogness on v1: too general; orderly reboot already handled by
  syscore; only `emergency_restart()` needs emergency enter + flush. v2
  is that narrower patch.
- No NAKs on v2. John Ogness `Reviewed-by`. Petr committed it to
  `printk/linux.git` branch **for-7.3-hotfix**.
- No reviewer `Cc: stable` in the thread.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): Petr Mladek, John Ogness, Sergey Senozhatsky,
Steven Rostedt, Pavel Tikhomirov, Oleg Nesterov, Christian Brauner,
Sebastian Andrzej Siewior, LKP, linux-serial, linux-kernel. Subsystem
maintainers were on To/Cc. John Ogness reviewed.

Step 4.3: SEARCH FOR THE BUG REPORT
Record (from `/tmp/lkp.mbox`):
- LKP: `BUG:kernel_reboot-without-warning_in_test_stage` after
  `d353934702` “serial: 8250: Switch to nbcon console, take 2” (linux-
  next, **not** in 6.18.57).
- John Ogness: kernel buffer not flushed before sysrq-triggered
  emergency restart; printk no longer blocks on UART TX once 8250 is
  NBCON.
- That 8250 conversion is **not** in this 6.18 tree (`git merge-base
  --is-ancestor d353934702… v6.18.57` failed; 8250 still legacy here).
- The same flush hole still applies to **NBCON consoles that 6.18 does
  have**.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: v1 was replaced by this v2. No remaining series members needed.
Orderly reboot/power-off already use `syscore_shutdown()` →
`printk_kthreads_shutdown()`.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore `stable/?q=nbcon+emergency_restart` returned **no
results**. No prior stable NAK or nomination found.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `emergency_restart()` only. Callees added:
`nbcon_cpu_emergency_enter()`, `printk_trigger_flush()`.

Step 5.2: TRACE CALLERS
Record (this tree):
- `drivers/tty/sysrq.c` — sysrq-b reboot (userspace-reachable with
  sysrq)
- `kernel/debug/kdb/kdb_main.c` — `kdb_reboot()`
- `kernel/panic.c` — panic reboot (`panic_timeout != 0`)
- `kernel/reboot.c` — hardware-protection fallback
- Watchdogs: softdog, at91sam9, bd96801, eurotech, keembay, rzn1,
  sama5d4, wdt, wdt_pci
- `drivers/char/hangcheck-timer.c`
- `fs/ocfs2/cluster/quorum.c`, `fs/ocfs2/stack_user.c`
- `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c` (RAS emergency restart)
- `drivers/scsi/smartpqi/smartpqi_init.c`

IRQ-safe by contract. Common production paths: sysrq, watchdogs, panic
reboot.

Step 5.3: TRACE CALLEES
Record:
- `nbcon_cpu_emergency_enter()`: `preempt_disable()` + per-CPU nesting++
- `printk_trigger_flush()`: `printk_get_console_flush_type()` then
  atomic/offload/legacy flush
- After emergency enter: `NBCON_PRIO_EMERGENCY` →
  `nbcon_atomic_flush_pending()`
- `machine_emergency_restart()`: architecture reset, does not return in
  the success case

Step 5.4: FOLLOW THE CALL CHAIN
Record: Yes, userspace-reachable (sysrq-b, watchdog devices, kdb). Panic
path already flushes more aggressively (`console_flush_on_panic`,
`nbcon_atomic_flush_unsafe`) before calling `emergency_restart()`; this
mainly helps **non-panic** emergency restarts.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same enter/flush pattern in `oops_enter()`, `__warn()`, RCU
stall, lockdep. `printk_kthreads_shutdown()` is the orderly equivalent
(stop kthreads + `nbcon_atomic_flush_pending()`). This is the missing
emergency-restart counterpart, not a new design.

semcode MCP was not available; callers/callees were traced with `git
grep` and direct reads.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** Local tree: `git describe HEAD` →
`v6.18.57-155-gcdf239ca885b2`, `make kernelversion` → **6.18.57**.
- `v6.18.57:kernel/reboot.c` `emergency_restart()` has no emergency
  enter/flush.
- NBCON kthreads + emergency sections are in 6.18.57.
- NBCON consoles in 6.18.57: **amba-pl011, imx, sifive, tegra-utc,
  drm_log**, each with `write_atomic`. 8250 is still legacy here, so the
  LKP 8250 case is not this tree; ARM/i.MX/RISC-V/Tegra serial consoles
  still hit the hole.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** v6.18.57 `emergency_restart()` matches the pre-
patch function. Need `#include <linux/console.h>` (not present in
v6.18.57 `reboot.c`). Context around includes differs slightly from
mainline (`rcupdate.h`, `sched/signal.h`, `__rcu cad_pid`) but the hunk
is local to `emergency_restart()` and applies cleanly.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Orderly path already has `printk_kthreads_shutdown` and
`kernel_power_off()`’s `pr_flush()`. No earlier equivalent for
`emergency_restart()`. The candidate SHA on HEAD is pipeline
application, not evidence the 6.18.57 baseline already had the fix
(`merge-base --is-ancestor` vs `v6.18.57` failed).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **printk / reboot (kernel/reboot.c + NBCON).** Criticality:
**IMPORTANT** (core reboot path; impact is console visibility, not
mm/vfs data integrity).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: NBCON/printk is actively developed, but the kthread model has
been in this series since 6.12-era commits (2024). This is a leftover
hole, not a brand-new 7.3-only subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Users of **NBCON consoles** on emergency restart. In **this 6.18
tree**: ARM PL011 (very common), i.MX UART, SiFive, Tegra UTC, DRM log.
Not typical PC 8250 serial (still legacy). Config: `CONFIG_PRINTK` plus
those drivers.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Any `emergency_restart()`: sysrq-b, watchdog timeout, kdb
reboot, hangcheck, ocfs2 quorum, amdgpu RAS, hw-protection fallback,
panic reboot. Common on broken/hung systems. Sysrq can be triggered from
userspace if enabled. Timing: always on those paths when NBCON kthreads
are running.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Lost last console messages, then reset. System still reboots.
**Severity: MEDIUM** (diagnostics / “reboot without warning”), not
panic/UAF/corruption. High operational value on watchdog/sysrq because
those last lines are why the box reset.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** Medium-high for 6.18 NBCON UART users (PL011/i.MX etc.);
  lower than 7.3 where 8250 is NBCON, but the hole is real here.
- **Risk:** Very low (9 lines, reboot-only, best-effort flush, does not
  return).
- **Ratio:** Favorable. Maintainers treated it as a 7.3 hotfix; same
  mechanics apply to 6.18 NBCON consoles.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real bug in this tree: `emergency_restart()` never stops NBCON
  kthreads or forces atomic flush; `printk_kthreads_shutdown()` is only
  on syscore shutdown.
- User-visible: last messages dropped on sysrq-b / watchdog / kdb /
  similar. LKP reproduced “reboot-without-warning”; John Ogness
  confirmed the mechanism.
- APIs and NBCON kthreads exist in 6.18.57; PL011/i.MX/etc. already use
  `CON_NBCON` + `write_atomic`.
- Small, obviously correct, printk-maintainer authored, NBCON designer
  reviewed (v2 after rejecting a broader v1).
- Very low regression risk.

**AGAINST backporting:**
- Not a crash, UAF, deadlock, or data-corruption fix. Severity is
  diagnostic.
- The LKP 8250-nbcon trigger is **not** in 6.18; PC 8250 users here are
  unaffected.
- Flush remains best-effort if another CPU holds the console.
- No `Cc: stable` (not a negative by itself).

**UNRESOLVED:** None that block the decision. WebFetch to lore returned
403; threads were retrieved with `b4`/`curl`. No stable-list discussion
found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — reviewed by Ogness; LKP-
   motivated; v2 is the reduced form after review.
2. Fixes a real bug that affects users? **PASS** — lost last console
   output on emergency restart for NBCON consoles present in 6.18.
3. Important issue? **PASS** (medium-high operational: last logs on
   watchdog/sysrq/kdb; not a crash).
4. Small and contained? **PASS** — ~9 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean apply to 6.18.57;
   prerequisites present.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID, DT, quirk, build, or docs-only change).
It is a normal small bugfix.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18.57 tree. The bug is here, the fix
is surgical, and missing last-line console output on emergency restart
is exactly when those messages matter. 8250 not being NBCON only reduces
the affected population; it does not remove the bug for PL011/i.MX and
the other NBCON consoles already in 6.18.

Verification:
- [Phase 1] Parsed tags: Reported-by LKP, Suggested/Reviewed-by John
  Ogness, Link msgid 20261013154141.94016-1; no Fixes/Cc:stable
- [Phase 1] Body: emergency_restart skips printk_kthreads_shutdown; use
  emergency mode + printk_trigger_flush
- [Phase 2] Diff: +include linux/console.h;
  +nbcon_cpu_emergency_enter(); +printk_trigger_flush() in
  emergency_restart()
- [Phase 2] printk_get_console_flush_type: NORMAL+kthreads →
  nbcon_offload; EMERGENCY → nbcon_atomic
- [Phase 3] git describe/make kernelversion: v6.18.57; Makefile 6.18.57
- [Phase 3] git merge-base --is-ancestor b140889fb6c82 v6.18.57 → not in
  6.18.57 baseline
- [Phase 3] git show v6.18.57:kernel/reboot.c: emergency_restart has no
  flush
- [Phase 3] git merge-base --is-ancestor of ecb5e1aa82c86,
  76f258bf3f2aa, 13189fa73afae vs v6.18.57 → all present
- [Phase 3] blame: emergency_restart from 15d94b82565eb (2013); NBCON
  kthread offload from 13189fa73afae (2024)
- [Phase 4] b4 dig -c d8e5fc300229: v2 at
  patch.msgid.link/20261013154141.94016-1-pmladek@suse.com
- [Phase 4] b4 dig -a: only v2 matched this patch-id; v1 msgid
  20261008150852.8286-1 was broader and replaced
- [Phase 4] b4 dig -w: printk maintainers CC’d; John Ogness reviewed
- [Phase 4] LKP mbox: reboot-without-warning after 8250 nbcon switch;
  Ogness: buffer not flushed before sysrq emergency restart
- [Phase 4] v2 committed to printk for-7.3-hotfix; no NAKs
- [Phase 4] lore stable search: no results
- [Phase 5] callers: sysrq-b, kdb_reboot, panic, watchdogs, hangcheck,
  ocfs2, amdgpu RAS, smartpqi, hw-protection
- [Phase 5] sysrq reboot in this tree is sysrq-b, not sysrq-o
- [Phase 6] v6.18.57 CON_NBCON drivers: pl011, imx, sifive, tegra-utc,
  drm_log; 8250 not NBCON (d353934702 not ancestor)
- [Phase 6] v6.18.57 has nbcon_cpu_emergency_enter and
  printk_trigger_flush declarations
- [Phase 8] Failure mode: lost last console lines on emergency restart;
  severity MEDIUM; reboot still happens
- UNVERIFIED: WebFetch lore 403 (worked around with b4/curl)
- UNVERIFIED: semcode MCP not available (used git grep / file reads)

The patch is small, obviously correct, and closes a real console-flush
hole that 6.18 NBCON serial consoles already have.

**YES**

 kernel/reboot.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 61924a0560c42..665a25684c70a 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt)	"reboot: " fmt
 
 #include <linux/atomic.h>
+#include <linux/console.h>
 #include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
@@ -94,6 +95,14 @@ void emergency_restart(void)
 {
 	kmsg_dump(KMSG_DUMP_EMERG);
 	system_state = SYSTEM_RESTART;
+
+	/*
+	 * NBCON kthreads won't be flushed and stopped properly in
+	 * the emergency restart. Move them to the atomic mode.
+	 */
+	nbcon_cpu_emergency_enter();
+	printk_trigger_flush();
+
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
-- 
2.53.0

