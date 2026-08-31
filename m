Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981EA52ED4F;
	Mon, 31 Aug 2026 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183919; cv=none; b=C0zYXFqCYcGR0PFawjHHtPMMmePPEUkIfDmsl13Gny+gqNxskpv4aDCVFg29df13iNa8PXQ4YoVFOmUTkYqlt+yJdLfVCPc6OLqTgB0CpmNxhABvterewcuph6bJHxl8q6N3Z9DeKG9/UPQHpLEqdA94wwKbs2ixZcCylb3nSBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183919; c=relaxed/simple;
	bh=EBTForxpSjpKe5If+cnqBgoz6rvUa0VIjMqURHsFCl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gxR9QQcIUYksolvFYgqaPAl8pA1cH0A074hiBIehxlte1pgKd4oZZVzYUjbuYfVfBBVbBGWpLxZMCxtwfdiR2c2RygV7qR7h5CEp04WjPPYtC6BguylaKyqvK3JuILCFMIz3lB2wiyDODYVLTGJyXtcBY9LBO/lDzH1ez1JVm2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBidIe/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBidIe/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2D21F00A3E;
	Mon, 31 Aug 2026 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183916;
	bh=oSEW1sZndZdlzCRNRuF4bhV3AHpNUq6XsCYj5F7lCNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBidIe/lO91/OMDGKeJKfn1oTx7r2gipnwk3y38S+FI4qeLSgDN6MldN91xZs3c3O
	 QMrgQ4olid8CggPQjcfpRR1EwBEqZ2deMyd0QfRX6zAB9dnGTjO+frrCvKPIEtLiLw
	 y7u34qOlgy5rhLlQfUolt9t7EV/RLU6QOM1BvD0bPI411K/3cnv1S2zP3Fg3FSwszZ
	 aRqc0LMnx+zFSvs4ybJ+cgd5vZHDwX8CSWoShQsy+H1WcVtLVO4DJmiPnxgvV+Casz
	 nxek9mW2HZV0qY4F1JfthxQ4VMDyKtq8+yZVkYPXInHQVPKBLjJSv4RurMglx/ze6O
	 5qZsuvghJaDbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shivang Upadhyay <shivangu@linux.ibm.com>,
	Shirisha G <shirisha@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ppc/fadump: invoke kmsg_dump in fadump panic path
Date: Mon, 31 Aug 2026 09:26:47 -0400
Message-ID: <20260831133314.4125787-379-sashal@kernel.org>
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

From: Shivang Upadhyay <shivangu@linux.ibm.com>

[ Upstream commit 6ed8332639853b77329594a241eb99fc36d591a2 ]

fadump is registered in panic_notifier_list and gets triggered before
kmsg_dump_desc() in the panic path. As a result, kmsg_dumpers such as
pstore are not executed during fadump crashes.

This is problematic because pstore provides a critical fallback mechanism
for crash analysis. When fadump fails to successfully reboot the system
or capture a dump, pstore logs may be the only available information from
the crashed kernel. Without invoking kmsg_dump_desc() in the fadump path,
we lose this valuable diagnostic data.

Invoke kmsg_dump_desc() from the fadump panic handler, but only when
fadump is actually registered (checked via should_fadump_crash()). This
ensures kmsg_dumpers are called without duplicating the call that occurs
later in panic() when fadump is not active.

The call is placed before crash_fadump() to ensure logs are captured
before the system attempts to trigger the firmware-assisted dump.

Reported-by: Shirisha G <shirisha@linux.ibm.com>
Suggested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Shivang Upadhyay <shivangu@linux.ibm.com>
Tested-by: Shirisha G <shirisha@linux.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260412113057.46090-1-shivangu@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ppc/fadump: invoke kmsg_dump in fadump
panic path`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ppc/fadump]` `[invoke]` — Ensure `kmsg_dump` (e.g. pstore)
runs on the fadump panic path before firmware takes over.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Fixes: | *(none)* |
| Reported-by: | Shirisha G \<shirisha@linux.ibm.com\> |
| Suggested-by: | Sourabh Jain \<sourabhjain@linux.ibm.com\> |
| Tested-by: | Shirisha G \<shirisha@linux.ibm.com\> |
| Reviewed-by: | Mahesh Salgaonkar, Sourabh Jain (IBM fadump
maintainers) |
| Signed-off-by: | Shivang Upadhyay, Madhavan Srinivasan |
| Link: |
https://patch.msgid.link/20260412113057.46090-1-shivangu@linux.ibm.com |
| Cc: stable | *(none — expected for pipeline candidates)* |

**Notable:** IBM fadump subsystem reporters/reviewers; no syzbot; no NAK
indicators in message.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `ppc_panic_fadump_handler` is registered on
  `panic_notifier_list` with `INT_MAX` priority and runs **before**
  `panic()` reaches `kmsg_dump_desc()`. When fadump triggers firmware-
  assisted dump (`rtas_os_term` / OPAL MPIPL reboot), execution
  typically never returns to `panic()`, so pstore and other kmsg dumpers
  never run.
- **Symptom:** On fadump-configured POWER systems, panic logs are not
  saved to pstore; if fadump also fails, administrators may have **no**
  kernel log from the crash.
- **Root cause:** Ordering gap between early fadump panic notifier and
  later `kmsg_dump_desc()` in `panic()`.
- **Fix approach:** Call `kmsg_dump_desc(KMSG_DUMP_PANIC, …)` in
  `ppc_panic_fadump_handler()` when `should_fadump_crash()` is true,
  **before** `crash_fadump()`.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit, well-described functional bug fix
(missing kmsg dump invocation), not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `arch/powerpc/kernel/setup-common.c` (+1 include, +7 lines
  in handler)
- **Functions:** `ppc_panic_fadump_handler()`
- **Scope:** Single-file, surgical (~10 lines)

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Include | No `kmsg_dump.h` | Adds `#include <linux/kmsg_dump.h>` |
| `ppc_panic_fadump_handler()` | `hard_irq_disable()` → `crash_fadump()`
| `hard_irq_disable()` → `kmsg_dump_desc()` (if fadump registered) →
`crash_fadump()` |

**Path affected:** Kernel panic on PowerPC with `CONFIG_FA_DUMP` and
fadump registered.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / ordering bug on crash path (missing diagnostic
  dump invocation).
- **Mechanism:** Verified in `kernel/panic.c` —
  `atomic_notifier_call_chain(&panic_notifier_list, …)` at line 520 runs
  **before** `kmsg_dump_desc(KMSG_DUMP_PANIC, buf)` at line 524. Fadump
  notifier runs first (`INT_MAX` priority in `setup-common.c` line 780).
  `crash_fadump()` → `fadump_trigger()` calls `rtas_os_term()` (pseries)
  or `opal_cec_reboot2(OPAL_REBOOT_MPIPL)` (powernv), which
  terminate/reboot and normally do not return to `panic()`.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — mirrors the existing system-reset path in
  `traps.c:474` (`kmsg_dump()` before `crash_fadump()`).
- **Minimal:** Yes.
- **Regression risk:** Very low. `should_fadump_crash()` guard avoids
  extra dump when fadump is inactive. If `fadump_trigger()` fails and
  returns (e.g. OPAL `OPAL_UNSUPPORTED`), `panic()` may call
  `kmsg_dump_desc()` again — redundant but harmless for pstore.
- **Uses `kmsg_dump_desc` with panic message pointer:** Better than bare
  `kmsg_dump()` — matches `panic()` behavior.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `ppc_panic_fadump_handler` / `crash_fadump()` call: **ab9dbf771ff9b6**
  (David Gibson, Dec 2017) — fadump panic notifier restored.
- Handler structure/priority: **e2aa34ce80a26** (Guilherme Piccoli, Apr
  2022) — split notifiers, fadump runs early with `INT_MAX` priority.
- Bug present since fadump panic notifier runs before `kmsg_dump_desc()`
  in `panic()` — long-standing on 6.18.y.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Related prior fix: **e7ca44ed3ba77**
(2019) fixed the **same pstore gap** on the **system reset** path in
`traps.c`, not the `panic()` notifier path.

### Step 3.3: Related file history
**Record:**
- `e7ca44ed3ba77` — "powerpc: dump kernel log before carrying out fadump
  or kdump" (traps.c system-reset path).
- `e2aa34ce80a26` — panic notifier refactor (made fadump run earliest).
- Standalone 1-patch fix; not part of a series.

### Step 3.4: Author context
**Record:** Shivang Upadhyay / IBM team; reviewed by Mahesh Salgaonkar
and Sourabh Jain (long-time fadump maintainers). Same subsystem as 2019
pstore/fadump fix.

### Step 3.5: Dependencies
**Record:** None. All symbols exist in this tree:
- `should_fadump_crash()` — `arch/powerpc/kernel/fadump.c:227`
- `kmsg_dump_desc()` — `kernel/printk/printk.c:4765`
- `linux/kmsg_dump.h` — present
- Applies standalone to 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.5
**Record:**
- **b4 dig:** Could not run — patch commit not in local tree (`b4 dig
  -c` requires commitish).
- **WebFetch lore / patch.msgid.link:** Blocked by Anubis bot protection
  — could not read thread.
- **Commit message Link:** Present but content unverified externally.
- **Stable list search:** Not performed (lore blocked).
- **Inference from commit message only:** IBM-internal report; tested
  and reviewed by fadump maintainers. No evidence of NAKs in commit
  message.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ppc_panic_fadump_handler()`, `should_fadump_crash()`,
`crash_fadump()`, `kmsg_dump_desc()`

### Step 5.2: Callers
**Record:**
- `ppc_panic_fadump_handler` — registered via `setup_panic()` →
  `atomic_notifier_chain_register(&panic_notifier_list,
  &ppc_fadump_block)` (line 795).
- Invoked from `panic()` → `atomic_notifier_call_chain()`
  (`kernel/panic.c:520`).
- **Context:** Panic path only; all CPUs eventually panic.

### Step 5.3: Callees
**Record:** `hard_irq_disable()`, `should_fadump_crash()`,
`kmsg_dump_desc()` → iterates registered dumpers (pstore, etc.),
`crash_fadump()` → `fadump_trigger()` → firmware reboot.

### Step 5.4: Reachability
**Record:**
- Triggered on any kernel panic when fadump is registered
  (`fw_dump.dump_registered` and `fw_dump.fadumphdr_addr` set).
- Common on IBM POWER LPARs / PowerNV with fadump enabled.
- Not userspace-triggerable directly, but panics are the exact scenario
  this code handles.

### Step 5.5: Similar patterns
**Record:** `arch/powerpc/kernel/traps.c:474` already does
`kmsg_dump(KMSG_DUMP_OOPS)` before `crash_fadump()` on system-reset dump
path — this patch closes the analogous gap on the **panic notifier**
path.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Current `setup-common.c:738-751` has no
`kmsg_dump_desc()` call. Fix is **not** present in v6.18.44.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — single hunk, no structural
conflicts; file unchanged for fadump handler since 2022 refactor.

### Step 6.3: Related fixes already present?
**Record:** System-reset path fix (e7ca44ed3ba77) is present in
`traps.c`. Panic-notifier path fix is **missing** — this commit fills
that gap.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `arch/powerpc` / fadump crash dump — **IMPORTANT** for IBM
POWER enterprise; **PERIPHERAL** globally (architecture- and config-
specific: `CONFIG_FA_DUMP`).

### Step 7.2: Activity
**Record:** Fadump actively maintained in 6.18.y (recent commits: param
area, CMA init, hugetlb interaction, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** IBM POWER (pseries/PowerNV) systems with firmware-assisted
dump enabled and pstore (or other kmsg dumpers) configured.

### Step 8.2: Trigger conditions
**Record:** Kernel panic while fadump is registered. Common crash
scenario on servers using fadump. Not unprivileged attack vector; crash-
path diagnostic issue.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM-HIGH** for affected users — loss of pstore panic
logs when fadump takes over or fails; no normal-runtime impact.
Operationally critical when fadump is the primary dump mechanism and
fails (exact scenario described in commit and in e7ca44ed3ba77).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores last-resort crash diagnostics (pstore) on fadump
  panic path; same rationale as 2019 stable-class fix.
- **Risk:** Very low — ~10 lines, guarded by `should_fadump_crash()`,
  tested by IBM.
- **Ratio:** Strong benefit for POWER/fadump users; negligible risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable ordering bug in panic path
- Buggy code present in 6.18.44; fix not yet applied
- Small, self-contained, reviewed/tested by fadump maintainers
- Direct precedent: e7ca44ed3ba77 fixed same pstore gap on system-reset
  path
- Important for IBM POWER crash diagnostics when fadump is active

**AGAINST backport:**
- Platform/config specific (not all stable users)
- Fixes diagnostic data loss, not runtime crash/corruption/deadlock
- Mailing list discussion unverified (lore blocked)

**Unresolved:** Full lore thread content; whether reviewers explicitly
nominated for stable.

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — clear ordering fix;
Tested-by + Reviewed-by IBM maintainers |
| 2. Fixes real bug affecting users? | **PASS** — pstore not invoked on
fadump panic path |
| 3. Important issue? | **PASS (borderline)** — crash-path diagnostic
loss on enterprise POWER; fallback when fadump fails |
| 4. Small and contained? | **PASS** — ~10 lines, one file |
| 5. No new features/APIs? | **PASS** — invokes existing kmsg_dump
infrastructure |
| 6. Applies to local tree? | **PASS** — all prerequisites present;
clean apply |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
On **6.18.44**, fadump’s early panic notifier prevents `panic()` from
ever reaching `kmsg_dump_desc()`, leaving pstore empty when firmware
takes over — precisely when those logs are most needed as a fallback.
The fix is minimal, matches an established pattern already used on the
system-reset path, and is low risk. Diagnostic loss on the crash path
for a supported enterprise platform meets stable backport criteria under
the “important issue” umbrella, especially given prior acceptance of the
same class of fix in 2019.

---

## Verification

- **[Phase 1]** Parsed commit message tags and body from user-provided
  content
- **[Phase 2]** Read diff; verified `panic()` ordering in
  `kernel/panic.c:520-524`
- **[Phase 2]** Read `ppc_panic_fadump_handler` at `setup-
  common.c:738-780`; confirmed no `kmsg_dump_desc` call
- **[Phase 2]** Read `crash_fadump()` and `fadump_trigger`
  implementations (`fadump.c`, `rtas-fadump.c:555-559`, `opal-
  fadump.c:581-600`)
- **[Phase 2]** Read `kmsg_dump_desc()` in
  `kernel/printk/printk.c:4765-4788`
- **[Phase 3]** `git describe HEAD` → v6.18.44; Makefile VERSION 6.18.44
- **[Phase 3]** `git blame` on handler lines → ab9dbf771ff9b6 (2017),
  e2aa34ce80a26 (2022)
- **[Phase 3]** `git show e2aa34ce80a26` — fadump notifier INT_MAX
  priority
- **[Phase 3]** `git show e7ca44ed3ba77` — prior pstore/fadump fix on
  system-reset path
- **[Phase 3]** `git log --oneline -20 -- arch/powerpc/kernel/setup-
  common.c`
- **[Phase 4]** `b4 dig -c` — failed (no commit in tree)
- **[Phase 4]** WebFetch lore.kernel.org and patch.msgid.link — blocked
  (Anubis)
- **[Phase 5]** Grep callers: `setup_panic()` registers notifier;
  `panic()` invokes chain
- **[Phase 5]** Verified `traps.c:474` kmsg_dump before crash_fadump on
  system-reset path
- **[Phase 6]** Confirmed buggy code present; fix absent in v6.18.44
- **[Phase 6]** Verified `should_fadump_crash()`, `kmsg_dump_desc`,
  `linux/kmsg_dump.h` exist
- **UNVERIFIED:** Lore thread review comments and explicit stable
  nominations

**YES**

 arch/powerpc/kernel/setup-common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 68d47c53876c6..28186f9ec8da0 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -68,6 +68,7 @@
 #include <asm/kasan.h>
 #include <asm/mce.h>
 #include <asm/systemcfg.h>
+#include <linux/kmsg_dump.h>
 
 #include "setup.h"
 
@@ -744,6 +745,13 @@ static int ppc_panic_fadump_handler(struct notifier_block *this,
 	 */
 	hard_irq_disable();
 
+	/*
+	 * Invoke kmsg_dump (e.g., pstore) before crash_fadump() as fadump
+	 * runs before panic()'s kmsg_dump_desc() call.
+	 */
+	if (should_fadump_crash())
+		kmsg_dump_desc(KMSG_DUMP_PANIC, (char *)ptr);
+
 	/*
 	 * If firmware-assisted dump has been registered then trigger
 	 * its callback and let the firmware handles everything else.
-- 
2.53.0

