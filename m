Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0023D0916;
	Mon, 30 Mar 2026 12:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874334; cv=none; b=L9P4gsefnRMVSWkQUEdGgsFgES09C8ceRSLyMcDlO3YUNruFc5lR4mgUwFotyCKEW5vFvrzkeYnoOJtCRcgPxxkqWMUJcci93VkhBHRMxUITikHRXsbjoUd/GMP+xz/25ER21zSSkHiIWd2HcocV9/YVFtw5vWrH1srmuPg6UXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874334; c=relaxed/simple;
	bh=nmLuCXKilewrWUUcq5NfX5N6ZNgzQC+XTkSE2IeJSuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=myubQQcKqlkh4tqzdDJfkmWtjvSMO0RIXeiVk+nQ0XXyiXfgtNfUS/40Sie8cDlthX363IXG8T1HgZ/lFpcL5TFtpevxxUkVHE+m5RLLbzDv5C5BPoxuLfTlMlAZRfeAT1l0a3dlZb2C9RZaXfEQ5/1uKp+za7sWyeAL5JguKdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmJgg+4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmJgg+4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2376AC2BCB2;
	Mon, 30 Mar 2026 12:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874332;
	bh=nmLuCXKilewrWUUcq5NfX5N6ZNgzQC+XTkSE2IeJSuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmJgg+4W4PSwB91QCv8wVqAISP+VYLY/5GUhGPTJZfJ4NdZArNeHQiWPX01l3btug
	 +s2uOT6i5DLGCyuwsxaByPNaRG+POKeWIJuI1Hy9nVScSY/2frTax9TKYVZqZHJL3Z
	 OibmsWdIZ9+J9YJGRfoGhu9QLByMk3dMJGoBKYo41ClCW+H0eKv8NdvZveaF4NrpsF
	 l3h0MGh4yOqILqQhjVwptCKF61swoUrlXKf/iZ6RXvIFtMeUQiLRZx7rNKaZD9KG9C
	 ADOajIR/o9TLmmBVcjTQCK6vEnj0QS/0ENewsKjqmCmFtTRYGbd2HQTbhVcwhqANWQ
	 HPR7JUaz88GoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jiangshanlai@gmail.com,
	josh@joshtriplett.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] srcu: Use irq_work to start GP in tiny SRCU
Date: Mon, 30 Mar 2026 08:38:19 -0400
Message-ID: <20260330123842.756154-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit a6fc88b22bc8d12ad52e8412c667ec0f5bf055af ]

Tiny SRCU's srcu_gp_start_if_needed() directly calls schedule_work(),
which acquires the workqueue pool->lock.

This causes a lockdep splat when call_srcu() is called with a scheduler
lock held, due to:

  call_srcu() [holding pi_lock]
    srcu_gp_start_if_needed()
      schedule_work() -> pool->lock

  workqueue_init() / create_worker() [holding pool->lock]
    wake_up_process() -> try_to_wake_up() -> pi_lock

Also add irq_work_sync() to cleanup_srcu_struct() to prevent a
use-after-free if a queued irq_work fires after cleanup begins.

Tested with rcutorture SRCU-T and no lockdep warnings.

[ Thanks to Boqun for similar fix in patch "rcu: Use an intermediate irq_work
to start process_srcu()" ]

Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the full assessment.

===============================================================
## PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

### Step 1.1: PARSE THE SUBJECT LINE
Record: [srcu] [Use] [irq_work to defer schedule_work() in Tiny SRCU
grace-period start to avoid lockdep splat from pi_lock vs pool->lock
ordering]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by:** Joel Fernandes <joelagnelf@nvidia.com> (author)
- **Reviewed-by:** Paul E. McKenney <paulmck@kernel.org> (RCU co-
  maintainer, original Tiny SRCU author)
- **Signed-off-by:** Boqun Feng <boqun@kernel.org> (RCU
  maintainer/committer)
- No `Fixes:` tag (expected — this is why we're reviewing)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:` tag
- No `Link:` tag

Record: Strong maintainer endorsement — reviewed by Paul McKenney (RCU
authority), committed by Boqun Feng (RCU maintainer). Queued into
`fixes.v7.0-rc4` branch (verified via mail-archive). No syzbot or
external bug reporter.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes two bugs:

**Bug 1 (lockdep/lock ordering):** `srcu_gp_start_if_needed()` calls
`schedule_work()`, which acquires workqueue `pool->lock`. When
`call_srcu()` is invoked while holding the scheduler `pi_lock`, this
creates a lock ordering inversion:
- Path A: `call_srcu()` [holding `pi_lock`] → `schedule_work()` →
  `pool->lock`
- Path B: `workqueue_init()`/`create_worker()` [holding `pool->lock`] →
  `wake_up_process()` → `try_to_wake_up()` → `pi_lock`

**Bug 2 (UAF prevention):** With the new irq_work mechanism,
`irq_work_sync()` must be added to `cleanup_srcu_struct()` to prevent a
use-after-free if a queued irq_work fires after cleanup begins.

Testing: rcutorture SRCU-T with no lockdep warnings.

Record: [Lock ordering inversion between pi_lock and workqueue
pool->lock] [Lockdep splat, potential deadlock] [No specific version
information] [Root cause: schedule_work() acquires pool->lock from
call_srcu() context that may hold pi_lock]

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: [Not hidden — explicitly describes a lockdep-detected lock
ordering bug and a UAF risk in cleanup. The UAF aspect is specific to
the new irq_work mechanism being introduced by the same commit.]

===============================================================
## PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

### Step 2.1: INVENTORY THE CHANGES
- `include/linux/srcutiny.h`: +4 lines (add `irq_work_types.h` include,
  `struct irq_work srcu_irq_work` field, function declaration, static
  initializer entry)
- `kernel/rcu/srcutiny.c`: +18/-1 lines (add `irq_work.h` include,
  `init_irq_work()` in init, `irq_work_sync()` in cleanup, new
  `srcu_tiny_irq_work()` function, change `schedule_work()` to
  `irq_work_queue()`)
- Total: ~22 lines added, 1 line changed
- Functions modified: `init_srcu_struct_fields()`,
  `cleanup_srcu_struct()`, `srcu_gp_start_if_needed()`
- New function: `srcu_tiny_irq_work()`

Record: [2 files, +22/-1, single-subsystem, well-contained surgical fix]

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
- **Before:** `srcu_gp_start_if_needed()` directly calls
  `schedule_work(&ssp->srcu_work)` when `srcu_init_done`. This acquires
  `pool->lock` synchronously in whatever context the caller is running.
- **After:** `irq_work_queue(&ssp->srcu_irq_work)` is called instead.
  The irq_work handler `srcu_tiny_irq_work()` later calls
  `schedule_work()`, breaking the direct lock nesting from the
  `call_srcu()` call site.
- **Cleanup:** `irq_work_sync()` is added before `flush_work()` in
  `cleanup_srcu_struct()` to ensure no deferred irq_work runs after the
  struct begins teardown.
- **Init:** `init_irq_work()` is added in `init_srcu_struct_fields()`.

Record: [Normal GP-start path changed from synchronous schedule_work()
to deferred irq_work hop. Cleanup path gets irq_work synchronization.
Init path gets irq_work initialization.]

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **(b) Synchronization / Lock ordering** (lockdep-detected
circular dependency between `pi_lock` and `pool->lock`), plus **(d)
Memory safety** — UAF prevention in the cleanup path for the newly
introduced irq_work.

Record: [Lock ordering inversion (potential deadlock) detected by
lockdep. The UAF prevention is specific to the irq_work mechanism
introduced by this same commit, not a pre-existing UAF in old code.]

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct:** Yes. irq_work is specifically designed for
  deferring work from contexts where direct scheduling is unsafe. This
  is the same pattern used in Tree RCU (referenced by the commit
  message).
- **Minimal/surgical:** Yes. ~22 lines, two files, all within the Tiny
  SRCU subsystem.
- **Regression risk:** Very low. The `irq_work` mechanism is mature. The
  functional behavior is identical (same `schedule_work()` happens, just
  deferred slightly). The `irq_work_sync()` + `flush_work()` ordering in
  cleanup is a standard pattern used elsewhere in the kernel.
- **Red flags:** None. `EXPORT_SYMBOL_GPL(srcu_tiny_irq_work)` is
  slightly unusual for a callback but harmless (needed for module
  builds).

Record: [Fix is obviously correct, minimal, low regression risk.
Standard irq_work deferral pattern, well-established in RCU subsystem]

===============================================================
## PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

### Step 3.1: BLAME THE CHANGED LINES
The direct `schedule_work(&ssp->srcu_work)` call in
`srcu_gp_start_if_needed()` was introduced by commit `1a893c711a600`
("srcu: Provide internal interface to start a Tiny SRCU grace period")
by Paul E. McKenney, dated 2020-11-13. This first appeared in release
`v5.12` (verified via `git tag --contains`, earliest non-next tag would
be p-5.15).

However, the original `call_srcu()` function called `schedule_work()`
even before that refactor — the lock ordering issue has existed since
Tiny SRCU was created.

Record: [Buggy schedule_work() path introduced in 1a893c711a600 (v5.12
era). Present in all stable trees from v5.15 onward.]

### Step 3.2: FOLLOW THE FIXES: TAG
N/A — no `Fixes:` tag present (expected).

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Recent srcutiny.c history shows:
- `e6a43aeb71852` - Remove preempt_disable/enable() in
  srcu_gp_start_if_needed() (recent)
- `da2ac5623716c` - Make Tiny SRCU able to operate in preemptible
  kernels (v6.15+, PREEMPT_LAZY)
- `65b4a59557f6f` - Make Tiny SRCU explicitly disable preemption (v6.12)

The PREEMPT_LAZY change (`da2ac5623716c`, first in v6.15) is
significant: it allows Tiny SRCU to run on preemptible kernels, making
the lock ordering issue more practically relevant than on the
traditional non-preemptible UP configs.

No duplicate irq_work fix for Tiny SRCU was found in the tree. This is
standalone.

Record: [Related to PREEMPT_LAZY enablement. Standalone fix. No
prerequisites beyond existing code.]

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Joel Fernandes is a well-known RCU contributor at NVIDIA with multiple
RCU commits. The fix is reviewed by Paul McKenney (original Tiny SRCU
author) and committed by Boqun Feng (RCU maintainer).

Record: [Joel Fernandes is a regular RCU contributor. Fix has strong
maintainer endorsement.]

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Key backport consideration: The `#include <linux/irq_work_types.h>` in
the header requires this file to exist. Verified that `irq_work_types.h`
was introduced in commit `c809f081fe400` ("irqwork: Move data struct to
a types header") and first appeared in **v6.19** only. It does NOT exist
in v6.18, v6.15, v6.12, v6.6, v6.1, or v5.15. For older stable trees,
the include would need to be changed to `<linux/irq_work.h>` — a trivial
mechanical adaptation.

The `__SRCU_STRUCT_INIT` macro has different argument counts across
versions:
- v5.15: 2 args `(name, __ignored)`
- v6.6: 3 args `(name, __ignored, ___ignored)`
- current: 4 args `(name, __ignored, ___ignored, ____ignored)`

This means the static initializer addition `.srcu_irq_work = { .func =
srcu_tiny_irq_work }` would need to go into the appropriate macro
variant for each stable tree. This is a minor mechanical conflict.

Record: [Standalone logically. Backport needs: 1) `irq_work_types.h` →
`irq_work.h` for trees < v6.19, 2) minor `__SRCU_STRUCT_INIT` macro
adaptation. These are mechanical, not logical, changes.]

===============================================================
## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

### Step 4.1: SEARCH LORE.KERNEL.ORG FOR THE PATCH DISCUSSION
Lore was blocked (Anubis anti-bot), but the discussion was found on
mail-archive.com at:
https://www.mail-archive.com/linux-
kernel@vger.kernel.org/msg2619639.html

Key findings from the discussion:
- The patch was dated March 23, 2026
- Boqun Feng queued it into `fixes.v7.0-rc4` branch (the RCU **fixes**
  branch, not features)
- Paul McKenney's `Reviewed-by` was provided in an off-list discussion
- No NAKs, no concerns raised
- No explicit stable nomination by reviewers in the visible thread

Record: [Lore discussion found on mail-archive mirror. Queued into fixes
branch by RCU maintainer. No objections. No explicit Cc: stable
discussion visible.]

### Step 4.2: SEARCH FOR THE BUG REPORT
No external bug report. Found during development/testing. The lockdep
splat is reproducible with rcutorture SRCU-T.

Record: [Found during testing, reproducible with rcutorture]

### Step 4.3: CHECK FOR RELATED PATCHES AND SERIES
The commit message references Boqun Feng's similar fix "rcu: Use an
intermediate irq_work to start process_srcu()" which applies the same
pattern to Tree SRCU. This confirms the pattern is well-established.

Record: [Companion to Boqun's Tree SRCU irq_work fix. Same pattern.]

### Step 4.4: CHECK STABLE MAILING LIST HISTORY
No stable-specific discussion found.

Record: [No stable-specific discussion found]

===============================================================
## PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Modified: `init_srcu_struct_fields()`, `cleanup_srcu_struct()`,
`srcu_gp_start_if_needed()`
New: `srcu_tiny_irq_work()`

### Step 5.2: TRACE CALLERS
`srcu_gp_start_if_needed()` is called from:
1. `call_srcu()` — widely used across the kernel
2. `start_poll_synchronize_srcu()` — used by rcutorture and others

`call_srcu()` callers (verified via grep, 14+ call sites in .c files):
- `virt/kvm/kvm_main.c`
- `mm/mmu_notifier.c`
- `block/blk-mq.c`, `block/blk-mq-tag.c`
- `kernel/events/uprobes.c`
- `fs/tracefs/event_inode.c`
- `fs/dlm/midcomms.c`, `fs/dlm/lowcomms.c`
- `drivers/gpio/gpiolib.c`
- Plus the RCU subsystem itself

**Important caveat:** On TINY_SRCU kernels, only the Tiny SRCU
`call_srcu()` is linked. TINY_SRCU requires `TINY_RCU`, which requires
`!SMP` (UP systems). On older stable trees (v6.12 and before), it
additionally requires `!PREEMPTION`. On v6.15+, PREEMPT_LAZY allows Tiny
SRCU to operate on preemptible (but still UP) kernels.

Record: [Wide caller surface for call_srcu() in general. On TINY_SRCU,
limited to UP kernels. On v6.15+ with PREEMPT_LAZY, the lock ordering
issue becomes more practically relevant.]

### Step 5.3: TRACE CALLEES
`srcu_gp_start_if_needed()` → `schedule_work()` (before) or
`irq_work_queue()` (after)
`srcu_tiny_irq_work()` → `schedule_work()`
`cleanup_srcu_struct()` → `irq_work_sync()` (new) → `flush_work()`
(existing)

Record: [Standard irq_work deferral pattern]

### Step 5.4: FOLLOW THE CALL CHAIN
`call_srcu()` is a generic kernel API. On TINY_SRCU builds, any code
path that invokes `call_srcu()` while holding scheduler locks (like
`pi_lock`) can trigger the lockdep splat. The kernel's scheduler code
does hold `pi_lock` during task wakeups, and subsystems like KVM and
uprobes that use `call_srcu()` can be reached from those contexts.

Record: [Reachable from multiple kernel subsystems. The specific
`pi_lock` → `pool->lock` ordering is mechanically real — verified that
`schedule_work()` → `__queue_work()` takes `pool->lock`, and
`create_worker()` holds `pool->lock` while calling `wake_up_process()`
which takes `pi_lock`.]

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
Multiple irq_work-related fixes exist in the RCU subsystem (`git log
--grep=irq_work -- kernel/rcu/`), confirming this is an established
pattern. Examples:
- `b41642c87716b` "rcu: Fix rcu_read_unlock() deadloop due to IRQ work"
- `f596e2ce1c0f2` "rcu: Use IRQ_WORK_INIT_HARD() to avoid
  rcu_read_unlock() hangs"
- The referenced Boqun patch for Tree SRCU

Record: [Well-established pattern in RCU subsystem]

===============================================================
## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS
===============================================================

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Verified directly. All stable trees from v5.15 onward contain the direct
`schedule_work()` call in `srcu_gp_start_if_needed()`:
- **v5.15:** YES — `schedule_work()` at line 168 (with `unsigned short`
  idx types)
- **v6.1:** YES — `schedule_work()` at line 168 (with `unsigned long`
  idx types)
- **v6.6:** YES — `schedule_work()` at line 168
- **v6.12:** YES (would also have `preempt_disable()` from
  `65b4a59557f6f`)
- **v6.15+:** YES (with PREEMPT_LAZY changes)

**Practical impact across versions:**
- **v5.15, v6.1, v6.6:** `TINY_RCU` requires `!PREEMPTION && !SMP`. On
  UP non-preemptible kernels, the lock ordering issue is still
  detectable by lockdep (lockdep tracks lock classes regardless of
  whether locks spin), but a real deadlock hang is less likely since
  spinlocks effectively become preemption disablers on UP.
- **v6.12:** Same as above (`!PREEMPT_RCU && !SMP`, no PREEMPT_LAZY)
- **v6.15+:** PREEMPT_LAZY enables Tiny SRCU on preemptible UP kernels.
  The lock ordering inversion becomes more practically concerning
  because preemption is real.

Record: [Buggy code present in all stable trees v5.15+. Real practical
impact increases on v6.15+ with PREEMPT_LAZY. On older trees, lockdep
still detects the issue.]

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Backport complications identified:
1. `irq_work_types.h` does not exist before v6.19 — must use
   `irq_work.h` instead
2. `__SRCU_STRUCT_INIT` macro has different argument counts: 2 in v5.15,
   3 in v6.6, 4 in current
3. `srcu_gp_start_if_needed()` has `preempt_disable()/enable()` in v6.12
   but not in v6.6 (minor context change)
4. v5.15 uses `unsigned short` for `srcu_idx`/`srcu_idx_max` vs
   `unsigned long` in v6.1+

All of these are minor context/mechanical differences. The core logic
change (replacing `schedule_work()` with `irq_work_queue()`) is
identical.

Record: [Expected backport difficulty: minor conflicts. Needs mechanical
adaptation for include file and macro arguments. Core fix logic applies
cleanly.]

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No duplicate fix for this specific Tiny SRCU issue found in any stable
tree or branch.

Record: [No related fix already in stable]

===============================================================
## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- **Subsystem:** `kernel/rcu` — SRCU (Sleepable Read-Copy Update), Tiny
  variant
- **Criticality:** CORE — RCU/SRCU is fundamental synchronization
  infrastructure used across the entire kernel. However, the Tiny
  variant specifically targets UP/embedded systems.
- **User base:** Embedded/IoT systems, UP configurations, systems that
  use `CONFIG_TINY_RCU`

Record: [CORE subsystem (RCU). Tiny SRCU variant targets embedded/UP
systems.]

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Actively maintained by Paul McKenney and Boqun Feng. Regular ongoing
development, especially around PREEMPT_LAZY support.

Record: [Active development, strong maintainer oversight]

===============================================================
## PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

### Step 8.1: DETERMINE WHO IS AFFECTED
Systems running with `CONFIG_TINY_SRCU`, which requires
`CONFIG_TINY_RCU`:
- **v6.6 and older:** `!PREEMPTION && !SMP` — UP non-preemptible kernels
  (embedded/IoT)
- **v6.15+:** `!PREEMPT_RCU && !SMP` with PREEMPT_LAZY possible — UP
  kernels that may be preemptible

Record: [Affected: embedded/UP systems using TINY_SRCU. Narrower than
general SMP deployments, but these are real production configurations.]

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- `call_srcu()` invoked while a scheduler lock (`pi_lock`) is held
- This is a realistic scenario in workloads that exercise both scheduler
  and SRCU paths
- On PREEMPT_LAZY kernels (v6.15+), the lock ordering is more
  practically dangerous
- On older trees, lockdep detects the ordering even if an actual hang is
  less likely on UP

Record: [Trigger: call_srcu() while holding scheduler locks.
Reproducible with rcutorture SRCU-T. Realistic in production on
PREEMPT_LAZY.]

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- **Lockdep splat:** WARNING level — but lockdep splats in core
  synchronization primitives are taken seriously because they indicate a
  real lock ordering design flaw that can hide other real bugs
- **Potential deadlock on PREEMPT_LAZY:** On v6.15+ UP preemptible
  kernels, the lock ordering inversion represents a genuine deadlock
  risk under the right timing conditions — MEDIUM-HIGH
- **Note on the UAF:** The `irq_work_sync()` in cleanup prevents a UAF
  that would exist only with the new irq_work mechanism. This is not a
  pre-existing UAF in old stable trees — it's safety plumbing for the
  new code introduced by this same commit.

Record: [Lockdep splat (WARNING) on all affected trees + potential real
deadlock risk on PREEMPT_LAZY (v6.15+). Severity: MEDIUM-HIGH overall]

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**BENEFIT:**
- Fixes lockdep-detected lock ordering inversion in a core
  synchronization primitive
- On v6.15+: prevents potential real deadlock
- Queued into `fixes` branch (not features) by RCU maintainer —
  maintainers consider this a fix
- Eliminates lockdep noise that can mask real bugs

**RISK:**
- Very low. ~22 lines, well-understood irq_work deferral pattern
- Reviewed by Paul McKenney, tested with rcutorture
- Only adds one extra asynchronous hop to the GP start path
  (functionally equivalent)
- Needs minor mechanical adaptation for older trees (include file, macro
  args)

Record: [Benefit: fixes real lockdep ordering bug in core
infrastructure, prevents potential deadlock on newer stables. Risk: very
low — small, well-reviewed, well-tested.]

===============================================================
## PHASE 9: FINAL SYNTHESIS
===============================================================

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a lockdep-detected lock ordering inversion between `pi_lock` and
  workqueue `pool->lock`
- The lock chain is mechanically verified: `schedule_work()` →
  `__queue_work()` → `pool->lock`, and `create_worker()` →
  `wake_up_process()` → `pi_lock`
- Small, surgical fix (~22 lines, 2 files, single subsystem)
- Reviewed by Paul McKenney (RCU co-creator), committed by Boqun Feng
  (RCU maintainer)
- Queued into `fixes.v7.0-rc4` branch (not features) — maintainers
  consider this a bug fix
- Tested with rcutorture SRCU-T, no lockdep warnings
- Well-understood irq_work deferral pattern already used in Tree RCU
- Buggy `schedule_work()` pattern exists in all stable trees since v5.12
- On v6.15+ with PREEMPT_LAZY, the lock ordering represents a more
  practical deadlock risk
- Lockdep splats in core RCU infrastructure can mask other real bugs

**AGAINST backporting:**
- On older stable trees (v5.15 through v6.12), the lock ordering is
  detectable by lockdep but a real deadlock hang is less likely on UP
  non-preemptible kernels
- Needs minor mechanical backport adaptation (`irq_work_types.h` →
  `irq_work.h`, macro argument counts)
- No external user reports of actual deadlocks
- The UAF prevention in the commit is for the *new* irq_work mechanism,
  not a pre-existing bug
- `CONFIG_TINY_SRCU` is a narrower configuration than general SMP
  deployments

**UNRESOLVED:**
- Could not independently fetch lore.kernel.org (Anubis) — used mail-
  archive mirror instead
- Whether lockdep on UP no-op spinlocks still reports this ordering
  (likely yes, since lockdep tracks lock classes regardless)
- No verified concrete in-tree path that hits Tiny `call_srcu()` while
  specifically holding `pi_lock` (though the ordering conflict is
  mechanically real)

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — standard irq_work deferral
   pattern, reviewed by Paul McKenney, tested with rcutorture
2. **Fixes a real bug that affects users?** YES — lockdep-detected lock
   ordering inversion. Lockdep warnings in core RCU are treated as
   serious issues by maintainers. More practically dangerous on v6.15+.
3. **Important issue?** YES for v6.15+ (potential deadlock). MEDIUM for
   older trees (lockdep warning in core infrastructure).
4. **Small and contained?** YES — ~22 lines, 2 files, single subsystem
5. **No new features or APIs?** Correct — internal mechanism change only
6. **Can apply to stable trees?** YES with minor mechanical adaptation

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category. This is a standard synchronization/lock-
ordering bug fix.

### Step 9.4: MAKE YOUR DECISION
This commit fixes a real lockdep-detected lock ordering inversion in the
Tiny SRCU implementation — a core kernel synchronization primitive. The
fix is small (~22 lines), well-contained (2 files, single subsystem),
reviewed by the RCU maintainers (Paul McKenney, Boqun Feng), tested with
rcutorture, and uses a well-established irq_work deferral pattern.

The fact that this was queued into the RCU `fixes` branch (not features)
by the maintainers demonstrates they consider it a bug fix, not an
enhancement. Lockdep warnings in core RCU infrastructure are taken
seriously because they indicate real design flaws that can cause
problems under the right conditions and that mask other real bugs.

The practical impact varies across stable trees: on v6.15+ with
PREEMPT_LAZY, the risk is higher (potential real deadlock); on older
trees, it's a lockdep warning that nonetheless indicates a genuine lock
ordering problem. The regression risk is very low given the maturity of
the irq_work mechanism and the surgical nature of the change.

The minor backport adaptations needed (include file, macro arguments)
are mechanical and well within the normal scope of stable backport
adjustments.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Paul E. McKenney, Signed-off-by
  Boqun Feng (RCU maintainers). No Fixes:, no Reported-by:, no Cc:
  stable.
- [Phase 2] Diff analysis: +22/-1 lines across 2 files. Core change:
  `schedule_work()` → `irq_work_queue()` in `srcu_gp_start_if_needed()`,
  plus `irq_work_sync()` in cleanup, `init_irq_work()` in init, new
  `srcu_tiny_irq_work()` handler.
- [Phase 3] git blame: buggy `schedule_work()` introduced in
  `1a893c711a600` by Paul McKenney (2020-11-13). First in release tags
  starting around v5.12.
- [Phase 3] git show `1a893c711a600`: confirmed it created
  `srcu_gp_start_if_needed()` with direct `schedule_work()`.
- [Phase 3] git tag --contains `da2ac5623716c`: PREEMPT_LAZY Tiny SRCU
  enablement first in v6.15.
- [Phase 3] git show v5.15/v6.1/v6.6 srcutiny.c: all contain direct
  `schedule_work()` in `srcu_gp_start_if_needed()`.
- [Phase 3] `irq_work_types.h` (commit `c809f081fe400`) first in v6.19
  only — not in v6.18, v6.15, v6.12, v6.6, v6.1, v5.15. Verified via
  `git show v6.18:include/linux/irq_work_types.h` (exit 128) and `git
  tag --contains`.
- [Phase 3] v5.15 `__SRCU_STRUCT_INIT` has 2 args, v6.6 has 3 args,
  current has 4 args — verified via git show of respective headers.
- [Phase 4] mail-archive.com: found patch discussion at
  https://www.mail-archive.com/linux-
  kernel@vger.kernel.org/msg2619639.html — Boqun queued into
  `fixes.v7.0-rc4`, Paul's Reviewed-by provided off-list. No NAKs.
- [Phase 5] Traced callers: `call_srcu()` used by KVM, mm, block, fs,
  GPIO, uprobes — 14+ call sites in .c files.
- [Phase 5] Verified lock chain: `schedule_work()` → `__queue_work()` →
  `pool->lock` (48 instances of `raw_spin_lock.*pool->lock` in
  workqueue.c). `create_worker()` → `wake_up_process()` → `pi_lock`.
- [Phase 5] Verified irq_work APIs (`init_irq_work`, `irq_work_queue`,
  `irq_work_sync`) exist in v5.15+ via `git show
  v5.15:include/linux/irq_work.h`.
- [Phase 6] Verified Kconfig: v6.6 `TINY_RCU` requires `!PREEMPTION &&
  !SMP`; current requires `!PREEMPT_RCU && !SMP`.
- [Phase 6] No duplicate fix found in any stable tree for this Tiny SRCU
  issue.
- [Phase 7] RCU is CORE subsystem, actively maintained.
- [Phase 8] Severity: lockdep warning on all affected trees; potential
  real deadlock on v6.15+ (PREEMPT_LAZY).
- UNVERIFIED: Could not fetch lore.kernel.org directly (Anubis anti-
  bot); used mail-archive mirror.
- UNVERIFIED: Whether lockdep still reports the ordering on UP
  configurations where spinlocks are effectively no-ops (likely yes,
  lockdep tracks classes regardless).
- UNVERIFIED: Specific in-tree call path where Tiny SRCU `call_srcu()`
  is invoked while holding `pi_lock` (the ordering conflict is
  mechanically real but no specific trigger path was traced end-to-end).

**YES**

 include/linux/srcutiny.h |  4 ++++
 kernel/rcu/srcutiny.c    | 19 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index e0698024667a7..313a0e17f22fe 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_SRCU_TINY_H
 #define _LINUX_SRCU_TINY_H
 
+#include <linux/irq_work_types.h>
 #include <linux/swait.h>
 
 struct srcu_struct {
@@ -24,18 +25,21 @@ struct srcu_struct {
 	struct rcu_head *srcu_cb_head;	/* Pending callbacks: Head. */
 	struct rcu_head **srcu_cb_tail;	/* Pending callbacks: Tail. */
 	struct work_struct srcu_work;	/* For driving grace periods. */
+	struct irq_work srcu_irq_work;	/* Defer schedule_work() to irq work. */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 };
 
 void srcu_drive_gp(struct work_struct *wp);
+void srcu_tiny_irq_work(struct irq_work *irq_work);
 
 #define __SRCU_STRUCT_INIT(name, __ignored, ___ignored, ____ignored)	\
 {									\
 	.srcu_wq = __SWAIT_QUEUE_HEAD_INITIALIZER(name.srcu_wq),	\
 	.srcu_cb_tail = &name.srcu_cb_head,				\
 	.srcu_work = __WORK_INITIALIZER(name.srcu_work, srcu_drive_gp),	\
+	.srcu_irq_work = { .func = srcu_tiny_irq_work },		\
 	__SRCU_DEP_MAP_INIT(name)					\
 }
 
diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index 3450c3751ef7a..a2e2d516e51b9 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/irq_work.h>
 #include <linux/mutex.h>
 #include <linux/preempt.h>
 #include <linux/rcupdate_wait.h>
@@ -41,6 +42,7 @@ static int init_srcu_struct_fields(struct srcu_struct *ssp)
 	ssp->srcu_idx_max = 0;
 	INIT_WORK(&ssp->srcu_work, srcu_drive_gp);
 	INIT_LIST_HEAD(&ssp->srcu_work.entry);
+	init_irq_work(&ssp->srcu_irq_work, srcu_tiny_irq_work);
 	return 0;
 }
 
@@ -84,6 +86,7 @@ EXPORT_SYMBOL_GPL(init_srcu_struct);
 void cleanup_srcu_struct(struct srcu_struct *ssp)
 {
 	WARN_ON(ssp->srcu_lock_nesting[0] || ssp->srcu_lock_nesting[1]);
+	irq_work_sync(&ssp->srcu_irq_work);
 	flush_work(&ssp->srcu_work);
 	WARN_ON(ssp->srcu_gp_running);
 	WARN_ON(ssp->srcu_gp_waiting);
@@ -177,6 +180,20 @@ void srcu_drive_gp(struct work_struct *wp)
 }
 EXPORT_SYMBOL_GPL(srcu_drive_gp);
 
+/*
+ * Use an irq_work to defer schedule_work() to avoid acquiring the workqueue
+ * pool->lock while the caller might hold scheduler locks, causing lockdep
+ * splats due to workqueue_init() doing a wakeup.
+ */
+void srcu_tiny_irq_work(struct irq_work *irq_work)
+{
+	struct srcu_struct *ssp;
+
+	ssp = container_of(irq_work, struct srcu_struct, srcu_irq_work);
+	schedule_work(&ssp->srcu_work);
+}
+EXPORT_SYMBOL_GPL(srcu_tiny_irq_work);
+
 static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 {
 	unsigned long cookie;
@@ -189,7 +206,7 @@ static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 	WRITE_ONCE(ssp->srcu_idx_max, cookie);
 	if (!READ_ONCE(ssp->srcu_gp_running)) {
 		if (likely(srcu_init_done))
-			schedule_work(&ssp->srcu_work);
+			irq_work_queue(&ssp->srcu_irq_work);
 		else if (list_empty(&ssp->srcu_work.entry))
 			list_add(&ssp->srcu_work.entry, &srcu_boot_list);
 	}
-- 
2.53.0

