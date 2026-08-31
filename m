Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D7476065;
	Mon, 31 Aug 2026 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183333; cv=none; b=Re7UQQ5OY/MhSQ9VX21YXIhXXjBIMsSNwcnE+VSHSUlcYm4jtRK8QFj/78L3Yba4O/SoyxnogchNmDQEKk8FZgct7Jct/bhtOibGBSg1YWtJ7HweS5qOh5jxIQ0fz7jBGQWkVP7tP4Dd7IeXVyY89WAHZKHiIupoqO5HroB5JVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183333; c=relaxed/simple;
	bh=IbsbHs4PoraK6qygwABB/IBsa6zZvIB48vtV78KbKGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YuIcEkTk1aLXNev1Ymso/2JK9Spfn9b81d244gP80w2gxF+7XQRsG1OraR+bhqB9QSdfjUJKAZHjpReV1/LCZ7RRD6C6jFx8AGUQqzaIF2PDeRKjswdlzSahijgQzsLcKxBznGX0yi+QHLmctozKJ44LopYxvqnC0zGn2xZatlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RIwN6HvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RIwN6HvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC811F000E9;
	Mon, 31 Aug 2026 13:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183331;
	bh=WdKFc/NctypBRjJC/QVzxU7l+hJdw/r7CHLMgeNoVcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIwN6HvL5CgvsfwYn0+BQgZD76wrSpnzmxw8Hm78vykPKCH8nbvwqWV4CSauJXVTX
	 WabGOfz55xcwC/Wx6wf+NPt1dBwpA7LHz1PsY0Ch8QWHLvUKBpFFpMhNpKJKCoIj5n
	 avVGCZE1z78qpY6yhGr6CLrkRL0ye5t2papxYBGgmRWfbd8osc/B26mGnTqZN9Iqv0
	 0N7okhDjbPpkV2aGI+uQYL5zEFHeKRC8dj+L9/uHg8cqic62RvuQyX2qbLBS8+W+6X
	 jJa5VgrMqkATjU4BAskkxAjo6HpIE8FWMOOVbZ1XFchsGN7XMd7hjteSzJDe+vDXeL
	 BMkFiumRe5/pw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] arm64: kprobes: Allow reentering kprobes while single-stepping
Date: Mon, 31 Aug 2026 09:21:52 -0400
Message-ID: <20260831133314.4125787-84-sashal@kernel.org>
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

[ Upstream commit 23f851ac0078a908bf3422d6467ebc1db5828c46 ]

A kprobe can be hit while another kprobe is in KPROBE_HIT_SS state. This
can happen when tracing or perf code runs from the debug exception path
while the first kprobe is preparing or executing its out-of-line
single-step instruction.

Currently arm64 treats a kprobe hit in KPROBE_HIT_SS as unrecoverable,
the same as a hit in KPROBE_REENTER. This is too strict. A hit in
KPROBE_HIT_SS is still a one-level reentry and can be handled by saving
the current kprobe state and setting up single-step for the new probe,
just like reentry from KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE.

The truly unrecoverable case is hitting another kprobe while already in
KPROBE_REENTER, because the reentry save area has already been consumed.

Move KPROBE_HIT_SS to the recoverable reentry cases and leave
KPROBE_REENTER as the unrecoverable nested reentry case.

This change also requires saving saved_irqflag in struct prev_kprobe.
When a nested kprobe calls kprobes_save_local_irqflag(), it overwrites
kcb->saved_irqflag with the currently masked DAIF value, losing the
outer kprobe's original DAIF state. Without this fix, when the outer
kprobe's single-step finishes, kprobes_restore_local_irqflag() applies
the wrong DAIF mask and leaves interrupts permanently disabled.

Extend struct prev_kprobe with a saved_irqflag field and save/restore it
alongside kp and status. This ensures the outer kprobe's original
interrupt state is preserved across reentry.

This mirrors the x86 fix in commit 6a5022a56ac3
("kprobes/x86: Allow to handle reentered kprobe on single-stepping").

Signed-off-by: Pu Hu <hupu@transsion.com>
Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: arm64 kprobes reentry during single-step

**Local tree:** `v6.18.44` (Makefile: 6.18.44)
**Verdict target:** Should this commit be backported to **this** 6.18.y
tree?

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[arm64: kprobes]` `[Allow]` — Allow reentering kprobes
while single-stepping. Subsystem: arm64 kprobes. Action: correctness fix
for nested kprobe handling.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none (reproducer described in related series cover
  letter, not in this commit)
- **Tested-by:** — none
- **Reviewed-by:** Masami Hiramatsu (Google) `<mhiramat@kernel.org>` —
  kprobes maintainer
- **Signed-off-by:** Pu Hu, Hongyan Xia, Will Deacon `<will@kernel.org>`
  — arm64 maintainer
- **Cc: stable:** — none (expected for manual review)
- **Link:** — none
- Notable: mirrors x86 fix `6a5022a56ac3`; no syzbot report

### Step 1.3: Body analysis
**Record:**
- **Bug:** A kprobe can fire while another is in `KPROBE_HIT_SS`
  (preparing/executing XOL single-step). arm64 treats this like
  `KPROBE_REENTER` and calls `BUG()`.
- **Secondary bug:** On nested reentry, `kprobes_save_local_irqflag()`
  overwrites `kcb->saved_irqflag`, so the outer probe restores the wrong
  DAIF mask and can leave interrupts permanently disabled.
- **Symptom:** Kernel `BUG()` crash; or silent IRQ masking / system
  hang.
- **Trigger context:** Tracing/perf code in the debug-exception path
  while a kprobe is single-stepping.
- **Root cause:** `KPROBE_HIT_SS` incorrectly classified as
  unrecoverable; `saved_irqflag` not preserved in `prev_kprobe` across
  one-level reentry.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit bug fix, not disguised cleanup. Two
distinct failure modes: crash (`BUG()`) and IRQ-state corruption.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `arch/arm64/include/asm/kprobes.h` | +6 lines: `saved_irqflag` in
`struct prev_kprobe` |
| `arch/arm64/kernel/probes/kprobes.c` | +23/-1 lines |

**Functions modified:** `save_previous_kprobe()`,
`restore_previous_kprobe()`, `reenter_kprobe()`
**Scope:** Single-subsystem, 2-file surgical fix (~29 lines net).

### Step 2.2: Code flow per hunk

**Hunk 1 — `struct prev_kprobe`:**
- Before: only `kp` and `status` saved on reentry.
- After: also saves outer probe's DAIF state.
- Path: nested kprobe reentry.

**Hunk 2 — `save_previous_kprobe()` / `restore_previous_kprobe()`:**
- Before: nested reentry could clobber `kcb->saved_irqflag`.
- After: outer `saved_irqflag` preserved and restored when unwinding
  reentry.
- Path: `setup_singlestep(..., reenter=1)` → `post_kprobe_handler()`
  restore path.

**Hunk 3 — `reenter_kprobe()`:**
- Before: `KPROBE_HIT_SS` → `pr_warn` + `dump_kprobe` + `BUG()`.
- After: `KPROBE_HIT_SS` handled like `KPROBE_HIT_ACTIVE` /
  `KPROBE_HIT_SSDONE` (recoverable one-level reentry).
- `KPROBE_REENTER` remains the only unrecoverable nested case.

### Step 2.3: Bug mechanism
**Record:**
- **Category (a):** IRQ-flag resource/state leak on error/nested path.
- **Category (g):** Logic correctness — wrong classification of
  recoverable reentry.
- **Specific mechanism:** One-level reentry from `KPROBE_HIT_SS` is safe
  (save area unused); only true double-reentry (`KPROBE_REENTER`) is
  fatal. Without `saved_irqflag` preservation, nested
  `kprobes_save_local_irqflag()` destroys outer DAIF state.

### Step 2.4: Fix quality
**Record:** Fix is minimal and mirrors the proven x86 pattern
(`arch/x86/kernel/kprobes/core.c` already treats `KPROBE_HIT_SS` as
recoverable and saves flags in `prev_kprobe`). Low regression risk: only
changes nested-kprobe path; `KPROBE_REENTER` still `BUG()`s. Reviewed by
kprobes and arm64 maintainers.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on `reenter_kprobe()` only attributes to merge
commit `5d324e5159d9e` (history is flattened in this checkout).
Copyright in `kprobes.h` dates to 2013; arm64 kprobes and
`KPROBE_HIT_SS` unrecoverable handling have been present for many
releases. Bug is long-standing, not a recent-mainline-only regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Referenced x86 fix `6a5022a56ac3` is
already reflected in this tree's x86 kprobes code (lines 943–947 of
`arch/x86/kernel/kprobes/core.c`).

### Step 3.3: Related file history
**Record:** `git log -- arch/arm64/kernel/probes/kprobes.c` shows only
the merge commit in this checkout's history view. Related RFC series
(`[RFC v2/v3 0/3] arm64: kprobes: Fix single-step fault and reentry
handling`) has 3 patches; **this commit combines patches 2+3**. Patch 1
("Only handle faults originating from XOL slot") is a separate fix and
is **not** in this tree.

### Step 3.4: Author context
**Record:** Pu Hu / Hongyan Xia (Transsion). Will Deacon (arm64
maintainer) merged. Masami Hiramatsu (kprobes maintainer) reviewed.
Author not found in local `git log --author` (commit not yet in this
tree).

### Step 3.5: Dependencies
**Record:** Self-contained for the reentry + IRQ-flag bugs. Patch 1 from
the same series addresses `kprobe_fault_handler()` fault-PC filtering —
related reproducer scenario but **not a structural prerequisite** for
this diff. No `noinstr` kprobes rework exists in this tree (later RFC to
drop this case is future work, not present here).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Found via openwall.org (lore.kernel.org blocked by bot
protection):
- Series cover: https://lists.openwall.net/linux-kernel/2026/07/09/1808
- RFC v3 patch matching this diff: https://lists.openwall.net/linux-
  kernel/2026/07/10/390
- Reproducer documented: `simpleperf record` with `preemptirq`
  tracepoints + dwarf callgraphs while kprobe active on hot kernel
  function.
- Before full 3-patch series: crash reproduced frequently; after all 3
  patches: no longer reproduced.
- `b4 dig -c <sha>`: **not run** — upstream commit SHA not available in
  this checkout.

### Step 4.2: Reviewers
**Record:** CC list included `mhiramat@kernel.org`, `will@kernel.org`,
`catalin.marinas@arm.com`, `linux-trace-kernel@`, `linux-arm-kernel@`.
Appropriate maintainers were included.

### Step 4.3: Bug report
**Record:** No formal bugzilla/syzbot link. Real-world reproducer from
Transsion team using simpleperf on arm64. Severity from reporter:
frequent crashes during perf + kprobes workloads.

### Step 4.4: Related patches
**Record:** Same series includes:
1. `arm64: kprobes: Only handle faults originating from XOL slot` —
   separate fault-handler fix, not in this tree
2. This commit (reentry + saved_irqflag)
Later RFC (Jiazi Li, Jul 2026) proposes dropping `KPROBE_HIT_SS` reentry
handling after making debug paths `noinstr` — **not applicable to this
6.18.44 tree**, which has no such rework.

### Step 4.5: Stable list
**Record:** No stable-list discussion found. UNVERIFIED for lore stable
archive (bot blocked).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `reenter_kprobe()`, `save_previous_kprobe()`,
`restore_previous_kprobe()`, `setup_singlestep()`,
`kprobe_brk_handler()`.

### Step 5.2: Callers
**Record:**
- `reenter_kprobe()` ← `kprobe_brk_handler()` when `kprobe_running()` is
  non-NULL
- `kprobe_brk_handler()` ← `call_el1_break_hook()` in `debug-monitors.c`
- `call_el1_break_hook()` ← `do_el1_brk64()` ← `entry-common.c` (kernel
  BRK exception path)

Reachable from kernel debug exceptions during active kprobes — common in
perf/ftrace workloads.

### Step 5.3: Callees
**Record:** `setup_singlestep()` → `kprobes_save_local_irqflag()` (masks
DAIF, saves to `kcb->saved_irqflag`); `kprobes_restore_local_irqflag()`
on completion via `kprobe_ss_brk_handler()`.

### Step 5.4: Reachability
**Record:**
```
BRK exception → do_el1_brk64() → kprobe_brk_handler()
  → [kprobe already running] → reenter_kprobe()
```
Triggered when perf/trace instrumentation in the debug-exception window
hits another kprobe while the first is in `KPROBE_HIT_SS`. Not directly
a syscall path, but reachable from normal perf tracing on arm64 servers
and Android devices.

### Step 5.5: Similar patterns
**Record:** x86 `reenter_kprobe()` in `arch/x86/kernel/kprobes/core.c`
already includes `KPROBE_HIT_SS` in recoverable cases and saves
`old_flags`/`saved_flags` in `prev_kprobe`. arm64 was missing the
equivalent fix.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at `v6.18.44` has:
- `KPROBE_HIT_SS` in unrecoverable branch with `BUG()` (lines 246–250 of
  `kprobes.c`)
- `struct prev_kprobe` without `saved_irqflag` (lines 26–29 of
  `kprobes.h`)
- Fix is **not** already applied.

### Step 6.2: Backport complications
**Record:** `git apply --check` on the provided diff: **applies
cleanly**. No `noinstr` refactor or structural divergence in these
files. Expected difficulty: **clean apply**.

### Step 6.3: Related fixes already present?
**Record:** x86 equivalent fix is present. arm64 companion patch 1 (XOL
fault filtering) is **not** present. No duplicate arm64 fix found via
`git log --grep`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** `arch/arm64` / kprobes — **PERIPHERAL** (requires
`CONFIG_KPROBES`), but **IMPORTANT** for tracing, perf, BPF/kprobe users
on arm64 (servers, mobile, embedded).

### Step 7.2: Activity
**Record:** Active development area; this is a correctness gap vs. x86,
not churn-induced breakage.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** arm64 systems with `CONFIG_KPROBES` running
perf/ftrace/kprobes concurrently — developers, CI systems, Android
simpleperf users, server observability stacks.

### Step 8.2: Trigger conditions
**Record:** Kprobe active on frequently executed function + perf/trace
events (e.g., `preemptirq:preempt_disable/enable`) in debug-exception
path. Reproducible per series cover letter. Requires root/capability for
kprobes/perf, but this is a normal admin/debug workflow, not an obscure
corner.

### Step 8.3: Failure mode severity
**Record:**
| Failure | Severity |
|---------|----------|
| `BUG()` in `reenter_kprobe()` | **CRITICAL** — kernel crash |
| Wrong DAIF restore → IRQs permanently masked | **CRITICAL** — soft
lockup / hung system |

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for kprobes+perf users — prevents crash and IRQ
  corruption
- **Risk:** LOW — ~29 lines, mirrors proven x86 fix, only affects
  nested-kprobe path
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real, reproducible `BUG()` crash
- Fixes IRQ permanently-disabled bug (serious stability issue)
- Small, surgical, maintainer-reviewed
- Mirrors x86 fix already in this tree
- Buggy code confirmed present in v6.18.44
- Applies cleanly

**AGAINST backport:**
- Only affects `CONFIG_KPROBES` (not all kernels)
- Full simpleperf reproducer series also has patch 1 (fault handler) —
  companion fix, not a blocker for this commit's correctness
- Future `noinstr` rework may obsolete this path in later mainline —
  irrelevant to this tree today

**Unresolved:** Upstream commit SHA unavailable for `b4 dig`; stable-
list nomination not verified.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors x86; maintainer-
reviewed; reproducer in series |
| 2. Fixes real user-affecting bug? | **PASS** — crash + IRQ corruption
with documented reproducer |
| 3. Important issue? | **PASS** — CRITICAL severity |
| 4. Small and contained? | **PASS** — 2 files, ~29 lines |
| 5. No new features/APIs? | **PASS** — internal struct extension for
bug fix |
| 6. Applies to local tree? | **PASS** — clean apply verified |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug-fix backport.

### Step 9.4: Decision rationale

For **linux 6.18.44**, the buggy `KPROBE_HIT_SS` handling and missing
`saved_irqflag` preservation are both present. The fix is small, well-
reviewed, proven on x86, and prevents kernel crashes and interrupt-state
corruption in a realistic perf+kprobes workload. The companion patch 1
from the same RFC series may also warrant backport separately, but does
not invalidate this fix.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 1]** Confirmed Reviewed-by Masami Hiramatsu, Signed-off-by
  Will Deacon
- **[Phase 2]** Read current `arch/arm64/kernel/probes/kprobes.c` lines
  173–371 and `arch/arm64/include/asm/kprobes.h`
- **[Phase 2]** Confirmed `KPROBE_HIT_SS` triggers `BUG()` at lines
  246–250 (buggy)
- **[Phase 2]** Confirmed `struct prev_kprobe` lacks `saved_irqflag`
  (buggy)
- **[Phase 3]** `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`
- **[Phase 3]** `git blame` on `reenter_kprobe()` — only merge commit
  visible
- **[Phase 3]** x86 equivalent: `arch/x86/kernel/kprobes/core.c:943-947`
  has `KPROBE_HIT_SS` recoverable; `prev_kprobe` saves flags at lines
  820-823
- **[Phase 4]** Fetched series cover at lists.openwall.net/linux-
  kernel/2026/07/09/1808 — reproducer and 3-patch context
- **[Phase 4]** Fetched RFC v3 patch at lists.openwall.net/linux-
  kernel/2026/07/10/390 — diff matches analyzed commit
- **[Phase 4]** UNVERIFIED: `b4 dig` (no commit SHA in tree)
- **[Phase 4]** UNVERIFIED: lore stable archive (bot blocked)
- **[Phase 5]** Traced call chain: `entry-common.c` → `do_el1_brk64` →
  `kprobe_brk_handler` → `reenter_kprobe`
- **[Phase 5]** `grep` confirmed no `noinstr` kprobes in arm64 tree
- **[Phase 6]** `git apply --check` on provided diff → **clean apply**
- **[Phase 6]** Confirmed fix not present; buggy code at HEAD
- **[Phase 6]** Patch 1 from series not in tree (`kprobe_fault_handler`
  unchanged)
- **[Phase 8]** Failure modes verified by reading `reenter_kprobe()`,
  `setup_singlestep()`, `kprobes_save/restore_local_irqflag()`

---

**YES**

 arch/arm64/include/asm/kprobes.h   |  6 ++++++
 arch/arm64/kernel/probes/kprobes.c | 23 ++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
index f2782560647be..35ce2c94040ef 100644
--- a/arch/arm64/include/asm/kprobes.h
+++ b/arch/arm64/include/asm/kprobes.h
@@ -26,6 +26,12 @@
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned int status;
+
+	/*
+	 * The original DAIF state of the outer kprobe, saved here before
+	 * a nested kprobe overwrites kcb->saved_irqflag during reentry.
+	 */
+	unsigned long saved_irqflag;
 };
 
 /* per-cpu kprobe control block */
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 43a0361a8bf04..7133da1653964 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -174,12 +174,27 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
+
+	/*
+	 * Save the outer kprobe's original DAIF flags before the nested
+	 * kprobe calls kprobes_save_local_irqflag() and overwrites
+	 * kcb->saved_irqflag. Without this, the outer kprobe will restore
+	 * the wrong DAIF state and leave interrupts permanently masked.
+	 */
+	kcb->prev_kprobe.saved_irqflag = kcb->saved_irqflag;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+
+	/*
+	 * Restore the outer kprobe's saved_irqflag so that when its
+	 * single-step completes, kprobes_restore_local_irqflag() uses
+	 * the correct original DAIF value.
+	 */
+	kcb->saved_irqflag = kcb->prev_kprobe.saved_irqflag;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
@@ -240,10 +255,16 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SS:
+		/*
+		 * A probe can be hit while another kprobe is preparing or
+		 * executing its XOL single-step instruction. This is still a
+		 * recoverable one-level reentry, so handle it in the same way as
+		 * reentry from KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE.
+		 */
 		kprobes_inc_nmissed_count(p);
 		setup_singlestep(p, regs, kcb, 1);
 		break;
-	case KPROBE_HIT_SS:
 	case KPROBE_REENTER:
 		pr_warn("Failed to recover from reentered kprobes.\n");
 		dump_kprobe(p);
-- 
2.53.0

