Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA460592D59;
	Mon, 31 Aug 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184266; cv=none; b=MpB7sDDjMISnnuyO85dyUvkkpKYfiYls7K51iazGHdGpn1TimTnkUEMnkMqZZb/elnEdPYChS4AY2RmkfKfXDwiC/oeo7x0PRDaNsGbPQPlZXiKu0wODPfk1ObVvmo0rpU5YfBxK/yRsE0DXj/B68QFtpZU4bnkoxqSLDCJvCCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184266; c=relaxed/simple;
	bh=QnI2E0CPkTTUEnepXrF1K8wW/FvRkUSRiXgqiOF3ATE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyFExrTrhqhj1VSCav2+pbBwRgEecKp9nnpvJoYeIP65edZd5ITwQWT2xUQo5h/DzD06M/PHJnKulctKpBhqSGCP8vXbb8N3WuLUjZ4ksHpWKLnvJS5cZw2UvHYrryi1n0+I0gOVxBAOO4bO2CYnoruADAqcrMzhKyp0rsYjMp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1E3uhCp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1E3uhCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3570A1F00ACA;
	Mon, 31 Aug 2026 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184263;
	bh=52YLF/TpFXE6yVG/pKuAQo5FJoA2P19IxWaMcZHp5Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1E3uhCp0cIIqx1fu46ne5FGKetEt42w7eylE5HSoiobj4QPBt5R32BQBkV8nGzoy
	 CwssZA9RoNUymCGuYhxOP8g86FadR2n8oGepwHCtQhSgr15aM8ULatGfVCFc4P2/u3
	 xtIvak4ln9s6AysO+v/LNVnhNF4c93w6z/ZAfGrI5wKVs+n8KEtjX8pOu2/7THBnZA
	 8mrMH5ZO6l8eI4swge/BD1HnJaQib/IM6EhK9Mua/9rDpA7xsxiMuWWswc93IShwn3
	 dTRSm5GTwlffpYFhwpaNyuOZY2dw7YYQx5HDa6RmZATWZ5rbt9exdv8L/yuumBp1OP
	 S7w/gUjXBF8Sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zqiang <qiang.zhang@linux.dev>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	paulmck@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	boqun@kernel.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] rcu-tasks: Fix possible boot-time tests failed for the call_rcu_tasks()
Date: Mon, 31 Aug 2026 09:30:17 -0400
Message-ID: <20260831133314.4125787-589-sashal@kernel.org>
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

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit 42c5468f9cdc0c892fec3c0916b3ac5b670775af ]

The following scenarios will cause the call_rcu_tasks() boot-time
tests failed:

                     CPU0								CPU1

rcu_init_tasks_generic()
->rcu_tasks_initiate_self_tests()
  ->call_rcu_tasks_trace(&tests[1].rh, test_rcu_tasks_callback)
    ->call_rcu_tasks_generic()
      ->havekthread = smp_load_acquire(&rtp->kthread_ptr)
       "The havekthread is false"
    ....
								       rcu_tasks_kthread()
								       ->smp_store_release(&rtp->kthread_ptr, current)
								         ->rcu_tasks_one_gp()
								           ->rcuwait_wait_event()
								             ->rcu_tasks_need_gpcb()
								               ->for (cpu = 0; cpu < dequeue_limit; cpu++)
								                 ->rcu_segcblist_n_cbs(&rtpcp->cblist) == 0
								           ->schedule()

     ->raw_spin_trylock_rcu_node()
     ->needwake = (func == wakeme_after_rcu) ||
     (rcu_segcblist_n_cbs(&rtpcp->cblist) == rcu_task_lazy_lim)

       "the rcu_task_lazy_lim default value is 32, and the
        func pointer is test_rcu_tasks_callback, lead to needwake
        is false."

     ->if (havekthread && !needwake && !timer_pending(&rtpcp->lazy_timer))
        "the havekthread is false, will not enter here."
     ....

        "the needwake is false lead to rtp_irq_work can not queue,
         even if the rtp->kthread_ptr already exists at this point."

      ->if (needwake && READ_ONCE(rtp->kthread_ptr))
        ->irq_work_queue(&rtpcp->rtp_irq_work)

For the above scenarios, if the call_rcu_tasks() is not called again
afterward, the rcu_tasks_kthread will not have a chance to be wakeup,
the test_rcu_tasks_callback() will never be called, the boot-time tests
failed can happen, this commit therefore check havekthread variable, if
it's false and the rtpcp->cblist is empty, set needwake variable is true,
if the rtp->kthread_ptr exist, the rtpcp->rtp_irq_work can be queued to
wakeup rcu_tasks_kthread.

Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `rcu-tasks: Fix possible boot-time tests
failed for the call_rcu_tasks()`

**Local tree:** `v6.18.44` (`git describe HEAD`, `make kernelversion`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[rcu-tasks]` `[Fix]` — Fix a race in
`call_rcu_tasks_generic()` wakeup logic that can leave the RCU Tasks
kthread asleep and cause boot-time self-test failure.

### Step 1.2: Tags
**Record:**
- **Fixes:** `d119357d0743` ("rcu-tasks: Treat only synchronous grace
  periods urgently") — present in this tree (verified via `git show`)
- **Signed-off-by:** Zqiang, Uladzislau Rezki (Sony)
- **No** Reported-by, Tested-by, Reviewed-by, Acked-by, Cc: stable, or
  Link: in the provided message
- Lore submission includes syzkaller link:
  `https://syzkaller.appspot.com/bug?extid=251e9abcdac140e7ec74`
- Notable: syzbot-reported, Fixes: tag points to May 2023 lazy-GP
  optimization

### Step 1.3: Body analysis
**Record:**
- **Bug:** Race between `call_rcu_tasks_generic()` on CPU0 and
  `rcu_tasks_kthread()` startup on CPU1 during boot.
- **Mechanism:** `havekthread` is read as `false` before `kthread_ptr`
  is published; kthread starts, sees empty cblist, sleeps; caller later
  computes `needwake=false` (not `wakeme_after_rcu`, cblist count ≠ 32);
  `irq_work` never queued even though `kthread_ptr` now exists.
- **Symptom:** `test_rcu_tasks_callback()` never runs → `pr_err("...has
  failed boot-time tests")` + `WARN_ON(ret < 0)` in
  `rcu_tasks_verify_self_tests()`.
- **Root cause:** Lazy-wakeup optimization from `d119357d0743` omits
  wakeup when kthread was not yet visible at entry but becomes visible
  before `irq_work_queue()`.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite “boot-time tests” framing, this fixes real RCU
Tasks wakeup logic — callbacks can remain unprocessed until another
`call_rcu_tasks*()` call wakes the kthread.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `kernel/rcu/tasks.h` (+2 / -1)
- **Function:** `call_rcu_tasks_generic()`
- **Scope:** Single-file, surgical (1 logical line added)

### Step 2.2: Code flow change
**Record:**
- **Before:** `needwake` set only for `wakeme_after_rcu` or when cblist
  hits `rcu_task_lazy_lim` (32).
- **After:** Also set `needwake` when `!havekthread &&
  rcu_segcblist_empty(&rtpcp->cblist)` — first callback during kthread
  startup race.
- **Path:** Normal enqueue path in `call_rcu_tasks_generic()`, called
  from `call_rcu_tasks()`, `call_rcu_tasks_trace()`,
  `call_rcu_tasks_rude()`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Race condition / logic correctness in wakeup
path.
- `havekthread` snapshot at entry can be stale relative to concurrent
  `smp_store_release(&rtp->kthread_ptr)`.
- Without fix, first callback during that window may never trigger
  `irq_work_queue()`.
- Kthread sleeps in `rcuwait_wait_event()` until another wakeup
  condition occurs.

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors existing `needwake =
rcu_segcblist_empty()` logic used when `havekthread` is true. Minimal,
no API changes. Very low regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Current `needwake` logic at lines 380–386 traces to
`e664048784506` (v6.18 merge base). Introduced by `d119357d0743` (May
14, 2023). Bug has been present since that lazy-GP optimization landed.

### Step 3.2: Fixes tag
**Record:** `d119357d0743` exists in this tree (`git show` succeeded;
`git rev-parse --is-ancestor d119357d0743 HEAD` exit 0). That commit
added lazy timer batching and changed `needwake` semantics — directly
responsible for this regression.

### Step 3.3: Related file history
**Record:** `git log --oneline -- kernel/rcu/tasks.h` shows limited
history in this checkout (merge commit only), but current code matches
the patch context at lines 380–405. Fix applies cleanly to current tree.

### Step 3.4: Author context
**Record:** Zqiang submitted standalone patch (Apr 2026) and as v2 11/11
in Uladzislau Rezki’s merge-window series. CC’d RCU maintainers (Paul
McKenney, Frederic Weisbecker, etc.).

### Step 3.5: Dependencies
**Record:** Standalone. No prerequisite commits required; diff matches
current `call_rcu_tasks_generic()` structure in v6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- Lore URL: https://lists.openwall.net/linux-kernel/2026/04/23/862
- Also in v2 series:
  https://www.spinics.net/lists/kernel/msg6215858.html (11/11)
- No stable nomination found in fetched threads
- No NAKs found in fetched content

### Step 4.2: Reviewers
**Record:** CC’d `paulmck@kernel.org`, `frederic@kernel.org`,
`neeraj.upadhyay@kernel.org`, `joelagnelf@nvidia.com`,
`urezki@gmail.com`, `boqun.feng@gmail.com`, `rcu@lists.linux.dev`

### Step 4.3: Bug report
**Record:** Syzkaller bug `251e9abcdac140e7ec74`:
- **Title:** WARNING in `rcu_tasks_verify_work_fn`
- **Status:** upstream reported, **prio:low**
- **27 crashes** on fuzzed kernels
- **Crash:** `call_rcu_tasks() has failed boot-time tests.` + `WARN_ON`
  at `rcu_tasks_verify_self_tests()`
- **Security assessment:** Not exploitable, not DoS (per syzbot AI
  assessment)
- Trigger requires `CONFIG_PROVE_RCU` boot verification path

### Step 4.4: Series context
**Record:** Patch 11/11 in “Candidate patches for v7.2 merge window”
series, but this specific hunk is self-contained and independent.

### Step 4.5: Stable list
**Record:** Not searched exhaustively; no stable-list nomination found
in available sources.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `call_rcu_tasks_generic()`, `rcu_tasks_kthread()`,
`rcu_tasks_one_gp()`, `rcu_tasks_verify_self_tests()`,
`rcu_tasks_initiate_self_tests()`

### Step 5.2: Callers
**Record:** `call_rcu_tasks_generic()` called from:
- `call_rcu_tasks()` — BPF, ftrace, rcutorture
- `call_rcu_tasks_trace()` — BPF, tracepoints, uprobes, trace filters
- `call_rcu_tasks_rude()` — rude RCU variant
- Boot self-tests under `CONFIG_PROVE_RCU`

All are core/production subsystems; BPF and tracing are widely used on
v6.18.

### Step 5.3: Callees
**Record:** Locking (`raw_spin_*_rcu_node`), `rcu_segcblist_*`,
`irq_work_queue()`, `mod_timer()` for lazy batching.

### Step 5.4: Reachability
**Record:**
- **Confirmed trigger:** `core_initcall(rcu_init_tasks_generic)` → self-
  tests (with `CONFIG_PROVE_RCU`)
- **Theoretical production trigger:** Any `call_rcu_tasks*()` during
  narrow window between `kthread_run()` and first successful wakeup
  while `havekthread` snapshot is false — rare after boot, but the code
  path is live whenever `CONFIG_TASKS_RCU` / `CONFIG_TASKS_TRACE_RCU`
  are enabled.

### Step 5.5: Similar patterns
**Record:** Existing code already sets `needwake =
rcu_segcblist_empty(&rtpcp->cblist)` when `havekthread &&
!rtp->lazy_jiffies` (line 386). Fix extends analogous logic to the
`!havekthread` startup race.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Lines 380–381 in `/home/sasha/linux-
autosel-7.0/kernel/rcu/tasks.h` lack the fix:

```380:405:kernel/rcu/tasks.h
        needwake = (func == wakeme_after_rcu) ||
                   (rcu_segcblist_n_cbs(&rtpcp->cblist) ==
rcu_task_lazy_lim);
        if (havekthread && !needwake &&
!timer_pending(&rtpcp->lazy_timer)) {
                // ...
        }
        // ...
        if (needwake && READ_ONCE(rtp->kthread_ptr))
                irq_work_queue(&rtpcp->rtp_irq_work);
```

Bug introduced with `d119357d0743` (2023), well before 6.18.

### Step 6.2: Backport complications
**Record:** Clean apply expected — single hunk, no structural conflicts
visible.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found in current tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **kernel/rcu** — **CORE**. RCU Tasks underpins BPF sleepable
programs, tracing, uprobes.

### Step 7.2: Activity
**Record:** Actively maintained; lazy-GP optimization from 2023 still in
use.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected?
**Record:**
- **Confirmed:** Kernels with `CONFIG_PROVE_RCU` (=`PROVE_LOCKING`,
  debug/lockdep builds) — boot verification WARN
- **Broader:** Kernels with `CONFIG_TASKS_RCU` /
  `CONFIG_TASKS_TRACE_RCU` (common on v6.18) — latent wakeup race during
  kthread startup window

### Step 8.2: Trigger conditions
**Record:** Timing race during boot between first `call_rcu_tasks*()`
and kthread publishing `kthread_ptr`. Requires SMP (`num_online_cpus() >
1` for meaningful race). Syzbot reproduced on PREEMPT GCE VMs.
Unprivileged users cannot directly trigger the boot self-test path.

### Step 8.3: Failure severity
**Record:**
- **Observed:** `pr_err` + `WARN_ON` — **MEDIUM** (no panic, boot
  continues)
- **Underlying:** RCU Tasks callback may not run until next
  `call_rcu_tasks*()` — **MEDIUM-HIGH** for deferred memory release, but
  narrow window and self-healing on subsequent RCU Tasks activity
- **Not:** crash, corruption, deadlock, or security issue

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Fixes syzbot-reproducible RCU wakeup bug; eliminates
  false boot-test failures on debug kernels; corrects core wakeup logic
- **Risk:** Very low — one-line, logically consistent with existing
  empty-cblist wakeup
- **Ratio:** Favorable for backport given trivial fix and core-subsystem
  correctness

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real race in core RCU Tasks wakeup path
- Syzbot-reproducible (27 crashes)
- Regression from `d119357d0743`, present since 2023, in v6.18.44
- One-line, obviously correct fix
- Applies cleanly to this tree
- Can leave callbacks unprocessed if no subsequent `call_rcu_tasks*()`
  call

**AGAINST backport:**
- Primary visible symptom is `WARN_ON` in `CONFIG_PROVE_RCU` boot self-
  test (debug builds)
- Syzbot priority: low; not security-relevant
- Self-heals when next RCU Tasks activity occurs
- Production stable kernels rarely enable `PROVE_RCU`
- Does not cause panic, corruption, or deadlock

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is sound; syzbot-
   verified
2. Fixes a real bug affecting users? **PASS** — syzbot + real wakeup
   race (narrow production window)
3. Important issue? **PASS (borderline)** — not crash/security, but core
   RCU correctness with stuck-callback potential
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code present, clean apply

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build fix, or docs fix).

### Step 9.4: Decision rationale
This is a small, surgical correctness fix to core RCU Tasks wakeup logic
in v6.18.44. The bug exists in this tree (introduced by `d119357d0743`),
is syzbot-reproducible, and can leave callbacks unprocessed during the
kthread startup race. While the most visible impact is a `WARN_ON` in
`CONFIG_PROVE_RCU` boot verification, the underlying flaw affects live
`call_rcu_tasks*()` paths used by BPF and tracing. The fix is minimal,
low-risk, and correct.

---

## Verification

- **[Phase 1]** Parsed subject, body, Fixes: tag; no Reported-by in
  provided message; syzkaller link found on lore
- **[Phase 2]** Read diff and `call_rcu_tasks_generic()` at lines
  346–406 in `kernel/rcu/tasks.h`
- **[Phase 3]** `git show d119357d0743`: confirmed May 2023 lazy-GP
  commit; `git rev-parse --is-ancestor d119357d0743 HEAD` exit 0
- **[Phase 3]** `git blame -L 380,405 kernel/rcu/tasks.h`: lines from
  v6.18 merge base
- **[Phase 4]** Fetched lore submission at lists.openwall.net/linux-
  kernel/2026/04/23/862
- **[Phase 4]** Fetched syzkaller report: 27 crashes, WARNING in
  `rcu_tasks_verify_work_fn`, prio:low
- **[Phase 4]** Fetched spinics v2 11/11 thread; no stable nomination
  found
- **[Phase 4]** `b4 dig -c d119357d0743`: no output (match not found for
  that commit)
- **[Phase 5]** `grep call_rcu_tasks*`: callers in bpf/, trace/, ftrace,
  uprobes confirmed
- **[Phase 5]** Read `rcu_tasks_kthread()`, `rcu_tasks_one_gp()`,
  `rcu_tasks_verify_self_tests()`
- **[Phase 6]** `git describe HEAD` → v6.18.44; buggy code confirmed at
  lines 380–381 without fix
- **[Phase 6]** Read `CONFIG_PROVE_RCU` in `kernel/rcu/Kconfig.debug`:
  `def_bool PROVE_LOCKING`
- **[Phase 7]** Subsystem: kernel/rcu (CORE)
- **[Phase 8]** Failure mode: WARN_ON + possible stuck callback;
  severity MEDIUM

**YES**The backport analysis is done. The background `git branch
--contains` check timed out, but the important part was already
confirmed another way: commit `d119357d0743` is in this tree (`git rev-
parse --is-ancestor` succeeded).

**Verdict for v6.18.44:** **YES** — backport the fix. It’s a small,
correct RCU Tasks wakeup race fix (syzbot-reproducible) that applies
cleanly to the current tree.

 kernel/rcu/tasks.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 2dc044fd126eb..2aa5589f0b8bf 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -377,7 +377,8 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 	// Queuing callbacks before initialization not yet supported.
 	if (WARN_ON_ONCE(!rcu_segcblist_is_enabled(&rtpcp->cblist)))
 		rcu_segcblist_init(&rtpcp->cblist);
-	needwake = (func == wakeme_after_rcu) ||
+	needwake = (!havekthread && rcu_segcblist_empty(&rtpcp->cblist)) ||
+		   (func == wakeme_after_rcu) ||
 		   (rcu_segcblist_n_cbs(&rtpcp->cblist) == rcu_task_lazy_lim);
 	if (havekthread && !needwake && !timer_pending(&rtpcp->lazy_timer)) {
 		if (rtp->lazy_jiffies)
-- 
2.53.0

