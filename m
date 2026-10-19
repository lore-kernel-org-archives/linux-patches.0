Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E172162C0DB;
	Mon, 19 Oct 2026 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418716; cv=none; b=RM9ToqiZsoede9Na1hrEWfqzIfBEE5FBrrJRnuZwfiRfFiD7mWiURUbvQkyNSQFOKrR7xqwXZie2yc2VnZ5z2JtCAmG1wd8YqmJ32+oZSXPEzdRKXvviWU2+ffbjZsynqmmPPrg6W8PXmBvlMS93ruDDRwRC/B8scP7LHZNPMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418716; c=relaxed/simple;
	bh=NS+dYxfyjC54yA8xF4W3zeUdqixq8YahZ/6nL88VUbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C45aUY/Qpz07li8B1RfWKoHl8GNaFJTkRUda9/jHUyBbB/lb7yW6y7GQ4SX3ajbRDt1SNJkDci2r/IwHiwnWrGT8xzkRgAgLfiIR/jb1tF2p7YVjcHb8JDIIBviskxKssAjqWEQUz8SxF+5P25flivTa09wCuKA4Kd2Uj1qaaN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bf/E01hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bf/E01hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C221F000C9;
	Mon, 19 Oct 2026 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418713;
	bh=OJnDRXaD8MXKY+HfVAGx8ycJVEcnB4lWDfYJHPvkKb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bf/E01hjpu608+YAIXvBZ8sLKTH6wN4X6fCJ266yZXD9IUA84iZ5tHSbvtTkUThwg
	 j7b75Zfd9bwTyHXiMvYncHq4rvcE65DsDqz/aIEmmci2ek9dbiCVmsmivlxi4rmXyd
	 0hCF6sI/KvQuEynwTYJ3xs7j8KKiF54nWaVmGdVaTduzmV2qBJSfrnLNuFyQhPu7B0
	 0DReVvYr6GaJMZb1Ucxw9mccPd0om2AQlljhVhl6eKiHMuvKaCcGbZ2BYq7EugqtFN
	 7gGQJvbk6uaR63I2smHhQLXfeH4HjMUkcU7kYw8EBcxoGPlfWo7yzzg1aumaig8pA0
	 2sqzRO8psMLCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Atish Patra <atishp@meta.com>,
	Sashiko AI <sashiko-bot@kernel.org>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	atish.patra@linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] RISC-V: perf: fix resource cleanup on driver probe failure
Date: Mon, 19 Oct 2026 09:52:14 -0400
Message-ID: <20261019135441.1420968-443-sashal@kernel.org>
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

From: Atish Patra <atishp@meta.com>

[ Upstream commit e24a1418e90beac2ef4384bc9b0b5a10f19b806e ]

Sashiko pointed out various UAF and memory leak issues around
pmu_sbi_device_probe() error paths.

If the probe fails, here are list of cleanups needed.
a. Already registered pmu must be freed
b. per cpu IRQ must be released
c. pmu_ctr_list data structure must be freed
d. cpu hotplug state must be cleaned up only if added.

Fix the resource cleanup by reorganizing the code around probe failure.

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Link: https://patch.msgid.link/20260807-counter_delegation-v9-1-58658104e487@meta.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.12.111** (`pending-6.12`). The buggy probe cleanup is
present here, the patch applies, and it is a real UAF/leak/crash fix — a
YES for this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[RISC-V perf / SBI PMU] [fix] [resource cleanup on driver probe
failure]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Reported-by: Sashiko AI <sashiko-bot@kernel.org>` — static-analysis
  bot, not a user oops, but it named concrete UAF/leak paths
- `Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>` — RISC-V
  reviewer
- `Signed-off-by: Atish Patra <atishp@meta.com>` — original SBI PMU
  driver author
- `Link: https://patch.msgid.link/20260807-counter_delegation-v9-1-
  58658104e487@meta.com` — **v9 01/20** of the counter-delegation series
- `Signed-off-by: Paul Walmsley <pjw@kernel.org>` — RISC-V maintainer
- No `Fixes:` tag (expected)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  — none on the real commit `e24a1418e90be`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `pmu_sbi_device_probe()` error paths leak and leave live
  references to freed objects
- **Needed cleanups:** (a) unregister an already-registered PMU, (b)
  release the per-CPU IRQ, (c) free `pmu_ctr_list`, (d) remove the CPU-
  hotplug instance only if it was added
- **Symptom:** UAF and memory leaks if probe fails after partial setup
- **Root cause:** probe does `goto out_unregister` / `out_free` without
  matching teardown
- **Version info:** none in the message; code dates to 2022–2024

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. It is an explicit error-path UAF/leak fix.
“Reorganizing probe failure” is the usual `goto` cleanup pattern, not a
refactor-for-its-own-sake.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/perf/riscv_pmu_sbi.c` — **+27 / −6** (33 insertions, 6
  deletions)
- Functions: `pmu_sbi_setup_irqs()`, `riscv_pmu_destroy()`,
  `pmu_sbi_device_probe()`
- Scope: single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:

1. **`pmu_sbi_setup_irqs()`**
   - Before: domain/mapping/request failures return immediately.
     `riscv_pmu_use_irq` can stay **true** even though no IRQ was
     installed. Mapping leaked if `request_percpu_irq()` failed.
   - After: those paths `goto err`, dispose a created mapping, set
     `riscv_pmu_use_irq = false`.

2. **`riscv_pmu_destroy()`**
   - Before: always `cpuhp_state_remove_instance()` even when the
     instance was never added.
   - After: only if `!hlist_unhashed(&pmu->node)`.

3. **`pmu_sbi_device_probe()`**
   - Before: `riscv_pm_pmu_register` / `perf_pmu_register` failures jump
     to `out_unregister` (destroy + `kfree(pmu)` only). Snapshot-alloc
     and cpuhp-add failures also skip `perf_pmu_unregister`. IRQ,
     `hw_events`, and `pmu_ctr_list` never freed.
   - After: `irq_requested` tracks a successful IRQ request. Failures
     before PMU register go to `out_destroy`. Failures after register go
     to `out_unregister` which now calls `perf_pmu_unregister`. Then
     IRQ/percpu/`pmu_ctr_list`/`pmu` are freed.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Error-path resource leak + UAF + NULL deref**, with a logic
fix on the IRQ fallback path.

Verified mechanisms in **this** tree:

| Bug | Mechanism |
|---|---|
| **UAF of registered PMU** | `perf_pmu_register()` then
`pmu_sbi_snapshot_alloc()` or `cpuhp_state_add_instance()` fails →
`kfree(pmu)` while the PMU stays in perf core |
| **NULL deref / list corruption** | `riscv_pmu_destroy()` →
`cpuhp_state_remove_instance()` → `hlist_del()` → `WRITE_ONCE(*pprev,
next)` with `pprev == NULL` on a `kzalloc`’d node |
| **IRQ + cookie UAF** | successful `request_percpu_irq(..., hw_events)`
then later probe fail frees `pmu`/`hw_events` without `free_percpu_irq`
|
| **Leaks** | `alloc_percpu` `hw_events` and `kcalloc` `pmu_ctr_list`
only freed on the new `out_free` |
| **Wrong IRQ flag on success path** | IRQ setup failure is **non-
fatal**; probe continues with `PERF_PMU_CAP_NO_INTERRUPT` but
`riscv_pmu_use_irq` stayed true, so `pmu_sbi_starting_cpu()` can
`enable_percpu_irq(0)` |

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct and minimal. `out_unregister` is only reached
after a successful `perf_pmu_register`. `out_destroy` does not
unregister. `hlist_unhashed` matches `cpuhp` (node is hashed only after
successful add). IRQ free happens before `free_percpu(hw_events)`.

Regression risk: **low**. Remaining gaps (sysctl not unregistered;
`sbi_pmu_snapshot_available` static key not disabled) are pre-existing
and not introduced here. They do not make this patch unsafe.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- IRQ error returns: `4905ec2fb7e642` (Atish Patra, 2022-02-18) —
  sscofpmf
- Destroy / `out_unregister`: `e9a023f2b73ac3` (Eric Lin, 2022-07-05) —
  PM notifier
- Snapshot + moving `cpuhp_state_add_instance` **after** register:
  `a8625217a054ca` (Atish Patra, 2024-04-20) — **this is when the
  registered-PMU UAF became real**
- Original `kfree(pmu)`-only `out_free`: `e9991434596f53` (2022-02-18) —
  driver introduction

All of these are ancestors of this 6.12 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Buggy code is still in this checkout (see Phase
6).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (this tree, `git log --oneline -20 --
drivers/perf/riscv_pmu_sbi.c`): overflow-IRQ NULL check, bitmap cmask,
errno/firmware-event fixes. None of those replace this cleanup. `git log
--oneline e24a1418e90be..origin/master -- drivers/perf/riscv_pmu_sbi.c`
only shows later overflow-mask/bitmap work; they do not revert or redo
this cleanup.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Atish Patra wrote the SBI PMU driver (`e9991434596f53`) and the
snapshot code. This is a maintainer-area fix, not drive-by.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Msgid is `counter_delegation-v9-1`. Patches 2–20 add
Smcsrind/Ssccfg/Smcdeleg and a new PMU path. They are **features**, not
prerequisites. This hunk only uses `hlist_unhashed`,
`perf_pmu_unregister`, `free_percpu_irq`, `irq_dispose_mapping`,
`free_percpu`, `pmu_ctr_list` — all already in 6.12. **Standalone.**
`git show e24a1418e90be | git apply --check` succeeded (offsets only).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c e24a1418e90be`: matched patch-id; lore URL `https://patch.m
  sgid.link/20260807-counter_delegation-v9-1-58658104e487@meta.com`
- `b4 dig -a`: cleanup first appeared as **v7 01/22** (2026-06-22), then
  **v9 01/20** (committed)
- WebFetch of lore returned **403** (Anubis). Thread was recovered via
  `b4 dig -m /tmp/riscv-pmu-cleanup.mbox`
- No NAK on this patch. Paul Walmsley queued the first ten patches
  (including this one) for `riscv/for-next`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Charlie Jenkins `Reviewed-by`. Paul Walmsley applied it.
Recipients are the RISC-V list / maintainers (from msgid and SOBs). No
`Cc: stable` in review.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Reporter is Sashiko, not syzbot. v9 review of **this** patch
restates remaining **pre-existing** issues (snapshot disable without CPU
pin, static key, sysctl leak, init-time cpuhp leak). It does **not** NAK
the cleanup. The UAF it describes of a registered-then-freed PMU is
exactly what `perf_pmu_unregister` addresses.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Rest of v9 is new ISA / delegation code. Not needed for this
cleanup. Later origin/master commits on this file do not change these
error labels.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable WebFetch also 403. **UNVERIFIED** whether
stable@ already discussed this. Absence of `Cc: stable` is expected for
this review queue.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `pmu_sbi_setup_irqs`, `riscv_pmu_destroy`,
`pmu_sbi_device_probe`. Related: `pmu_sbi_starting_cpu`,
`riscv_pmu_alloc`, `pmu_sbi_get_ctrinfo`.

**Step 5.2: TRACE CALLERS**

Record:
- `pmu_sbi_device_probe` — `.probe` of `pmu_sbi_driver`
- Called from `pmu_sbi_devinit()` (`device_initcall`) via
  `platform_device_register_simple(RISCV_PMU_SBI_PDEV_NAME, ...)`
- `pmu_sbi_starting_cpu` / `pmu_sbi_dying_cpu` read `riscv_pmu_use_irq`
  (the flag this patch clears on IRQ setup failure)

**Step 5.3: TRACE CALLEES**

Record: `riscv_pmu_alloc()` does `kzalloc` + `alloc_percpu_gfp` (this
tree, `drivers/perf/riscv_pmu.c`). `pmu_sbi_get_ctrinfo()` `kcalloc`s
`pmu_ctr_list`. `cpuhp_state_remove_instance()` always `hlist_del()`s.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Boot/init on RISC-V with SBI PMU (`CONFIG_RISCV_PMU_SBI`
**default y**). Trigger is probe failure after partial success:
`snapshot_alloc` ENOMEM, `perf_pmu_register` failure,
`cpuhp_state_add_instance` failure, or `cpu_pm_register_notifier`
failure. After a successful `perf_pmu_register` and a later fail,
userspace `perf` can touch a PMU whose `struct riscv_pmu` is already
`kfree`d — **userspace-reachable UAF**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same file’s `pmu_sbi_devinit()` still leaks
`cpuhp_setup_state_multi` if `platform_driver_register` fails. Pre-
existing, out of this patch’s scope.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** This checkout is 6.12.111; `e24a1418e90be` is **not**
an ancestor (`git merge-base --is-ancestor` exit 1).

Current probe error path (`drivers/perf/riscv_pmu_sbi.c`):

```1462:1468:drivers/perf/riscv_pmu_sbi.c
out_unregister:
        riscv_pmu_destroy(pmu);

out_free:
        kfree(pmu);
        return ret;
```

`riscv_pmu_destroy()` still unconditionally removes the cpuhp instance.
`pmu_sbi_setup_irqs()` still returns without clearing
`riscv_pmu_use_irq` or disposing a mapping.

Bug introduced: leaks since v5.17-era driver; UAF of registered PMU
since snapshot/cpuhp reorder in `a8625217a054ca` (in this tree).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git apply --check` — all 6 hunks succeeded
with −54 line offset). Context differs (`bitmap_copy` vs mainline
`pmu->cmask = cmask`) because 6.12 already has `143668c424772` (counter
mask as bitmap). No rework required.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No equivalent cleanup. Bitmap and overflow-IRQ fixes in this
tree are independent.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: `drivers/perf` / RISC-V SBI PMU. **IMPORTANT** for RISC-V
(default-on perf), not core-mm/VFS. Not staging.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Mature driver (2022) with ongoing RISC-V perf fixes. This is a
long-standing error-path hole, not churn in brand-new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: RISC-V systems with `CONFIG_RISCV_PMU_SBI` (default y) and SBI
PMU (QEMU virt, most recent boards). Driver-specific, not universal.

**Step 8.2: TRIGGER CONDITIONS**

Record:
- Common path: probe succeeds — no crash
- Realistic fail: `pmu_sbi_snapshot_alloc()` ENOMEM (page alloc
  GFP_ATOMIC per CPU) **after** `perf_pmu_register`
- IRQ mapping fail with SSCOF/T-Head/Andes: probe **continues**,
  `riscv_pmu_use_irq` wrongly stays true
- Unprivileged user cannot force probe, but **can** open the registered
  `"cpu"` PMU in the failure window

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- Registered PMU then `kfree(pmu)` → **UAF** → HIGH
- `hlist_del` on unhashed node → **oops** → HIGH
- IRQ cookie UAF → HIGH
- One-time leaks if probe dies before register → MEDIUM
- `enable_percpu_irq(0)` on fallback success path → MEDIUM–HIGH

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** high for RISC-V 6.12 — prevents oops/UAF on probe fail
  and a wrong IRQ flag on a continued probe
- **Risk:** low — ~27 net lines, error path + one flag clear, applies
  cleanly
- **Ratio:** favor backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**FOR:**
- Real UAF: perf-registered PMU freed without unregister (snapshot/cpuhp
  fail after `perf_pmu_register`)
- Real oops: `cpuhp_state_remove_instance` → `hlist_del` with NULL
  `pprev`
- Real IRQ leak/UAF and `pmu_ctr_list`/`hw_events` leaks
- `riscv_pmu_use_irq` left true on non-fatal IRQ setup failure (success-
  path bug)
- Small, obviously correct, reviewed by Charlie Jenkins, authored by the
  driver owner
- Buggy code and helpers exist in 6.12; patch applies cleanly
- Standalone despite being 01/20 of a feature series

**AGAINST:**
- Probe-fail is uncommon (except IRQ-setup fallback, which is not fatal
  and is common on some platforms)
- Incomplete: sysctl, snapshot static key, init-time cpuhp still leak
  (pre-existing)
- RISC-V only
- Reported by an AI bot, not a production oops

**UNRESOLVED:** stable@ thread (lore 403); whether Sashiko had a
concrete reproducer beyond code review.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — reviewed, applied by RISC-V
   maintainer, logic matches the four listed holes
2. Fixes a real bug that affects users? **PASS** — UAF/oops/leaks in the
   default RISC-V PMU driver
3. Important issue? **PASS** — UAF and NULL deref are HIGH; not a style
   cleanup
4. Small and contained? **PASS** — one file, +27/−6
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean

**Step 9.3: EXCEPTION CATEGORIES**

Record: None. Ordinary bugfix.

**Step 9.4: DECISION**

This 6.12 tree has the buggy probe path. The fix is small, applies, and
closes UAF/oops/leak holes in a default-on RISC-V driver. Remaining
cleanup gaps are not a reason to withhold the part that is correct.

---

## What this means for 6.12 users

On RISC-V with SBI PMU, a failed probe after `perf_pmu_register()`
currently frees `struct riscv_pmu` while perf still holds it, and
`riscv_pmu_destroy()` oopses by deleting an unhashed cpuhp node. The
same path leaks the per-CPU IRQ cookie, `hw_events`, and `pmu_ctr_list`.
IRQ setup failure is treated as non-fatal but leaves `riscv_pmu_use_irq`
set, so hotplug can enable IRQ 0. The patch only rewires those gotos and
frees; it does not pull in counter-delegation.

Risk is low relative to leaving a registered-PMU UAF in a long-term
tree.

---

## Verification

- **[Phase 1]** Parsed tags: Sashiko Reported-by, Charlie Jenkins
  Reviewed-by, Atish Patra + Paul Walmsley SOBs, msgid v9 01/20; no
  Fixes
- **[Phase 2]** Diff: +27/−6 in `riscv_pmu_sbi.c`; IRQ err goto,
  `hlist_unhashed` guard, `perf_pmu_unregister`,
  `free_percpu_irq`/`free_percpu`/`kfree(pmu_ctr_list)`
- **[Phase 2]** Read 6.12 `pmu_sbi_device_probe` lines 1367–1468:
  destroy + `kfree(pmu)` only
- **[Phase 2]** Read `kernel/cpu.c` `__cpuhp_state_remove_instance`:
  always `hlist_del(node)`
- **[Phase 2]** Read `include/linux/list.h` `__hlist_del`:
  `WRITE_ONCE(*pprev, next)` NULL-derefs if never hashed
- **[Phase 2]** Read `__cpuhp_state_add_instance_cpuslocked`:
  `hlist_add_head` only on success
- **[Phase 3]** `git blame` IRQ path `4905ec2fb7e642` (2022); destroy
  `e9a023f2b73ac3` (2022); snapshot/cpuhp order `a8625217a054ca` (2024,
  in this tree)
- **[Phase 3]** `git merge-base --is-ancestor e24a1418e90be HEAD` → not
  in this tree; `e9a023f2b73ac3` / `a8625217a054ca` / `e9991434596f53` →
  in this tree
- **[Phase 3]** Follow-ups on origin/master do not redo this cleanup
- **[Phase 4]** `b4 dig -c e24a1418e90be` → patch.msgid.link v9-1; `-a`
  shows v7 first, v9 applied
- **[Phase 4]** `b4 dig -m`: 31-message mbox; Sashiko comments are pre-
  existing leftovers; Paul queued first ten patches; no NAK
- **[Phase 4]** WebFetch lore/stable: 403 — UNVERIFIED stable-list
  discussion
- **[Phase 5]** Probe from `device_initcall(pmu_sbi_devinit)`;
  `riscv_pmu_alloc` allocates `hw_events`; `pmu_sbi_get_ctrinfo`
  allocates `pmu_ctr_list`
- **[Phase 5]** `pmu_sbi_starting_cpu` uses `riscv_pmu_use_irq` /
  `riscv_pmu_irq`
- **[Phase 6]** `git describe HEAD` → `p-6.12-4-gbf6fcdf761abd`; `make
  kernelversion` → **6.12.111**
- **[Phase 6]** `git apply --check` of `e24a1418e90be`: all hunks OK
- **[Phase 7]** `CONFIG_RISCV_PMU_SBI` default y in
  `drivers/perf/Kconfig`
- **[Phase 8]** Failure mode: UAF of registered PMU + cpuhp oops → HIGH
- **UNVERIFIED:** live user oops; stable@ nomination history

**YES**

 drivers/perf/riscv_pmu_sbi.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 25f3a45dd7869..10f64b7b60c53 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1258,22 +1258,29 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
 					  DOMAIN_BUS_ANY);
 	if (!domain) {
 		pr_err("Failed to find INTC IRQ root domain\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 
 	riscv_pmu_irq = irq_create_mapping(domain, riscv_pmu_irq_num);
 	if (!riscv_pmu_irq) {
 		pr_err("Failed to map PMU interrupt for node\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 
 	ret = request_percpu_irq(riscv_pmu_irq, pmu_sbi_ovf_handler, "riscv-pmu", hw_events);
 	if (ret) {
 		pr_err("registering percpu irq failed [%d]\n", ret);
-		return ret;
+		irq_dispose_mapping(riscv_pmu_irq);
+		riscv_pmu_irq = 0;
+		goto err;
 	}
 
 	return 0;
+err:
+	riscv_pmu_use_irq = false;
+	return ret;
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1340,7 +1347,8 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
 		}
 	}
 	riscv_pm_pmu_unregister(pmu);
-	cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
+	if (!hlist_unhashed(&pmu->node))
+		cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 }
 
 static void pmu_sbi_event_init(struct perf_event *event)
@@ -1462,6 +1470,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	struct riscv_pmu *pmu = NULL;
 	int ret = -ENODEV;
 	int num_counters;
+	bool irq_requested = false;
 
 	pr_info("SBI PMU extension is available\n");
 	pmu = riscv_pmu_alloc();
@@ -1490,6 +1499,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_EXCLUDE;
 	}
+	irq_requested = (ret == 0);
 
 	pmu->pmu.attr_groups = riscv_pmu_attr_groups;
 	pmu->pmu.parent = &pdev->dev;
@@ -1508,11 +1518,11 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 
 	ret = riscv_pm_pmu_register(pmu);
 	if (ret)
-		goto out_unregister;
+		goto out_destroy;
 
 	ret = perf_pmu_register(&pmu->pmu, "cpu", PERF_TYPE_RAW);
 	if (ret)
-		goto out_unregister;
+		goto out_destroy;
 
 	/* SBI PMU Snapsphot is only available in SBI v2.0 */
 	if (sbi_v2_available) {
@@ -1553,9 +1563,20 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	return 0;
 
 out_unregister:
+	perf_pmu_unregister(&pmu->pmu);
+
+out_destroy:
 	riscv_pmu_destroy(pmu);
+	if (irq_requested) {
+		free_percpu_irq(riscv_pmu_irq, pmu->hw_events);
+		irq_dispose_mapping(riscv_pmu_irq);
+		riscv_pmu_irq = 0;
+	}
 
 out_free:
+	free_percpu(pmu->hw_events);
+	kfree(pmu_ctr_list);
+	pmu_ctr_list = NULL;
 	kfree(pmu);
 	return ret;
 }
-- 
2.53.0

