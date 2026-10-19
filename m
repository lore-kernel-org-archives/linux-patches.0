Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4990456982F;
	Mon, 19 Oct 2026 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418266; cv=none; b=t6WBIjmjHplGtgigcDQNlVUZo6EwHYBt3yZVJGuSgotVwt3n4iwcoKYNVvs3CpkMbcWuu0PA2Ttcl84bw3e89cCDUz17gSKxOj3Tau8LIlNEW6mLYIHx04PUnEu1tr+8k8AXZY76tHqmUW9sKvbtRcmStdrH2hYrAIYAPinIM9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418266; c=relaxed/simple;
	bh=wiqPXWVlTTveYzvN9waZ4nUny+eZwY9OurxyivW9KuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGgrcSgSmdu5tFxyxbSrzQERVB8MhlNNxgD/FPn5vkwDV7H1JC93blge9J9c35GYFPjqc58OGs915Iy1jBs0ERYwSGhT+vMr11Ot+p66X5rAshNsUNxCBX06qRNqo0Gp1YOWFU8cHzsWwDeN9+HXUYyD8fxYS628QvFbRKkEoA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYsFsmFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYsFsmFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E481F000C6;
	Mon, 19 Oct 2026 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418263;
	bh=MGmTAbgILO+6jEkopSYybQ9rcFhYEntoql9d3wDhxuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYsFsmFqWOG9Dwhte03PRlpm0r9FiOW0+2net+qKlP5aLpOL/WG4u5yoRT6fL6c4H
	 4Vhr3jn+T5BkIEzehsQAi49zU5nxR9dFhXZdKT7p0Sf0S8HgeSy9WnrXio73krruo3
	 V3sJBxHB+lb5H+QE+fKaSYT/RdRqGWtGqpd36UAkmWr+fjFIY25hif/YpYhDqn9Udz
	 gu+AjXl7L16pZL4bOQpZa8Z4Rr9Lvv8itVYdYHqqI0HZPSMYDChTOvAgTNcA54SeDm
	 +5mIM6vJXkVz2IGMvsHKoI6c7NB4jxgBl1VcQLOaUiyJg3uC2WAC0xyNcoN1OBJr/6
	 D64fTvou7B6Yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sumeet Pawnikar <sumeet4linux@gmail.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] powercap: intel_rapl: Fix kernel panic during PMU unbind
Date: Mon, 19 Oct 2026 09:46:59 -0400
Message-ID: <20261019135441.1420968-128-sashal@kernel.org>
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

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit 916b61abba586d950a4d8264e2841cc5ccfa4df1 ]

rapl_package_add_pmu() fails internally at perf_pmu_register(),
and rapl_pmu_update() leaves the global rapl_pmu.pmu structure
zero-initialized via memset and returns an error. But any
previously probed packages retain has_pmu = true.

When the driver is subsequently unbound or removed,
rapl_package_remove_pmu_locked() sees has_pmu == true and
unconditionally calls perf_pmu_unregister(&rapl_pmu.pmu) on the
zeroed-out structure. This attempts a list_del_rcu() on a NULL
list head, immediately causing a kernel panic.

Fix this by checking if the PMU is actually registered before
attempting to unregister it.

Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
[ rjw: Added empty line after the new conditional ]
Link: https://patch.msgid.link/20260822094657.12489-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The panic path is
present here; only the later `_locked` wrapper is missing, so the same
two-line check belongs in `rapl_package_remove_pmu`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[powercap: intel_rapl:] [Fix] [kernel panic during PMU
unbind]**
Subsystem `powercap` / Intel RAPL. Verb is explicitly **fix**. Claimed
intent: stop a panic when the RAPL perf PMU is unbound after a failed
registration.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reviewed-by:** Abel Vesa `<abel.vesa@oss.qualcomm.com>`
- **Link:** `https://patch.msgid.link/20260822094657.12489-1-
  sumeet4linux@gmail.com`
- **Signed-off-by:** Sumeet Pawnikar (author); Rafael J. Wysocki (PM
  maintainer)
- **Ignored (pipeline):** Signed-off-by: Sasha Levin (not present on
  this candidate text, but would be ignored)
- **No Fixes:** tag (expected)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / syzbot**

Notable: PM subsystem maintainer applied it; one external Reviewed-by.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `rapl_pmu_update()` can fail at `perf_pmu_register()` after
  `memset` of `rapl_pmu.pmu`. Packages that already succeeded keep
  `has_pmu = true`.
- **Symptom:** On unbind/remove, `rapl_package_remove_pmu*()` sees
  `has_pmu` and calls `perf_pmu_unregister()` on a PMU whose `list_head`
  is NULL → `list_del_rcu()` NULL deref → **kernel panic**.
- **Root cause:** Unregister is gated only on `rp->has_pmu`, not on
  whether the global PMU is actually registered.
- **Version info in message:** none. Introduced with RAPL PMU APIs
  (verified in Phase 3 as v6.11).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** This is an explicit panic fix, not cleanup
disguised as a fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/powercap/intel_rapl_common.c`
- **Scope:** 2 insertions, 1 deletion (plus blank line from rjw)
- **Function (upstream):** `rapl_package_remove_pmu_locked()`
- **Classification:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** If this package has `has_pmu` and no other package still
  needs the PMU, always `perf_pmu_unregister(&rapl_pmu.pmu)` then
  `memset` the global `rapl_pmu`.
- **After:** Same, but unregister only if `rapl_pmu.registered`.
- **Path:** driver remove / unbind / (later kernels) CPU-hotplug
  teardown — error-recovery path after a failed PMU (re)register.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[NULL deref / invalid list_del on unregistered PMU]**

In this tree, `rapl_pmu_update()` (unchanged since 575024a8aa7cf):

```1996:2024:drivers/powercap/intel_rapl_common.c
        /* Unregister previous registered PMU */
        if (rapl_pmu.registered)
                perf_pmu_unregister(&rapl_pmu.pmu);

        rapl_pmu.registered = false;
        rapl_pmu.domain_map |= rp->domain_map;

        memset(&rapl_pmu.pmu, 0, sizeof(struct pmu));
        /* ... fill callbacks ... */
        ret = perf_pmu_register(&rapl_pmu.pmu, "power", -1);
        if (ret) {
                pr_info("Failed to register PMU\n");
                return ret;   /* does NOT set rp->has_pmu; does NOT
restore prior PMU */
        }
        rapl_pmu.registered = true;
end:
        rp->has_pmu = true;
```

If package A already registered, then package B needs extra domains
(documented dual-package Psys case): previous PMU is unregistered,
`pmu.entry` is zeroed, re-register fails. Package A still has `has_pmu
== true`. Remove of A then hits:

```2104:2105:drivers/powercap/intel_rapl_common.c
        perf_pmu_unregister(&rapl_pmu.pmu);
        memset(&rapl_pmu, 0, sizeof(struct rapl_pmu));
```

`perf_pmu_unregister()` does `list_del_rcu(&pmu->entry)`. A zeroed
`list_head` has `next = prev = NULL`. `__list_del(entry->prev,
entry->next)` writes through NULL → oops.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: **Obviously correct.** `rapl_pmu.registered` is already
maintained in this file (set true only after successful
`perf_pmu_register()`, cleared before re-register). Skipping unregister
when it is false cannot skip a still-registered PMU. Regression risk is
very low. No API/data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: Unconditional `perf_pmu_unregister` in
`rapl_package_remove_pmu()` is from **575024a8aa7cf** (“powercap:
intel_rapl: Introduce APIs for PMU support”, Zhang Rui, 2024-04-28).
`git describe --contains` → **v6.11**. Present in this 6.12 tree (`git
merge-base --is-ancestor 575024a8aa7cf HEAD` succeeded).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. The introducing commit is 575024a8aa7cf; TPMI
started calling it in **963a9ad3c589** (“Enable PMU support”), also in
this tree (v6.11).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- **35cf088430978** already in this tree (v6.12.110): “Handle PMU
  registration failure during probe”. That only logs
  `rapl_package_add_pmu()` failure; probe still succeeds; remove still
  calls `rapl_package_remove_pmu()`. It does **not** fix the panic.
- No `remove_pmu_locked` commits here.
- Standalone logic; not patch X/Y of a series that 6.12 needs.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Sumeet Pawnikar has several powercap fixes in this tree,
including 35cf088 (already backported). Not the RAPL maintainer; Zhang
Rui / Rafael Wysocki own the subsystem. Rafael applied this patch as
7.3-rc material.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Upstream applies the check in
`rapl_package_remove_pmu_locked()`, added later (~6.19) by “Fix possible
recursive lock warning” (`dcd0b625`) together with MSR RAPL PMU. **`git
merge-base --is-ancestor dcd0b625… HEAD` failed** — that refactor is
**not** in 6.12. It is **not required**: 6.12 already has
`rapl_pmu.registered` and the same unregister in
`rapl_package_remove_pmu()`. Standalone one-line semantic backport.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c` cannot be used on this SHA (commit is not in the
  checkout). Related commit 35cf088 was found as v3 on lore.
- Original: 2026-07-26 (linux-pm). Resend: 2026-08-22, msgid
  `20260822094657.12489-1-sumeet4linux@gmail.com`.
- URLs: https://lists.openwall.net/linux-kernel/2026/08/22/310 and
  https://lkml.iu.edu/2608.2/11624.html
- Abel Vesa: “Looks OK to me” + Reviewed-by. Rafael: “Applied as 7.3-rc
  material, thanks!”
- No NAKs. Same 3-line diff from v1 through resend. No reviewer request
  for Cc: stable.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc: Rafael J. Wysocki, linux-pm, linux-kernel. Reviewer Abel
Vesa. Applied by the PM maintainer. Appropriate audience.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Mechanism is explained in the commit
(list_del_rcu on NULL). Author of the sibling probe-failure patch, so
this is from the same investigation, not theoretical cleanup.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Sibling **35cf088** already in 6.12.110. This panic fix is the
missing half of that failure handling. Not a multi-patch series that
6.12 lacks.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable returned 403. Open web search found no
stable-list rejection. **UNVERIFIED:** whether anyone already asked for
this on stable@ (does not change the technical verdict).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: Upstream: `rapl_package_remove_pmu_locked`. This tree:
`rapl_package_remove_pmu`. Related: `rapl_pmu_update`,
`rapl_package_add_pmu`.

**Step 5.2: TRACE CALLERS**

Record:
- `intel_rapl_tpmi_remove()` → `rapl_package_remove_pmu()` (only caller
  in 6.12; MSR driver does **not** use these APIs here).
- `intel_rapl_tpmi_probe()` → `rapl_package_add_pmu()` →
  `rapl_pmu_update()`. Probe **continues** if add_pmu fails (after
  35cf088, still `return 0`).
- Remove runs on unbind, rmmod, or TPMI device teardown — process
  context, not IRQ.

**Step 5.3: TRACE CALLEES**

Record: `perf_pmu_unregister()` → `list_del_rcu(&pmu->entry)` under
`pmus_lock`, then `synchronize_srcu` / `synchronize_rcu`, sysfs
teardown. `list_add_rcu(&pmu->entry, &pmus)` happens only at the **end**
of successful `perf_pmu_register()`. Failed register never links
`entry`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable on Intel TPMI RAPL (`CONFIG_INTEL_RAPL_TPMI` +
`CONFIG_PERF_EVENTS`): Meteor Lake / Lunar Lake / Arrow Lake class
platforms that 6.12 actually ships on. Trigger: successful PMU add, then
a later package’s `rapl_pmu_update()` re-register fails, then driver
remove. Unprivileged users typically cannot unbind, but
rmmod/unbind/hot-unplug and failed second-package probe are real
admin/boot paths. Documented dual-package Psys re-register is exactly
this update path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same file already checks `rapl_pmu.registered` before unregister
**inside** `rapl_pmu_update()`. Remove path is the missing twin of that
check. No other RAPL unregister site in 6.12.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/powercap/intel_rapl_common.c` lines 2089–2106:
`rapl_package_remove_pmu()` still calls `perf_pmu_unregister` with only
a `has_pmu` guard. `struct rapl_pmu { … bool registered; }` exists at
1574–1579. Bug since **v6.11** (575024a8aa7cf + 963a9ad3c589).

Local tree: `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`, `make
kernelversion` = **6.12.111**, branch `pending-6.12`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor context rework, not a semantic rewrite.**
- Function name: `rapl_package_remove_pmu` vs upstream `_locked`
- Extra `guard(cpus_read_lock)()` still in the 6.12 function
- `EXPORT_SYMBOL_GPL` vs `EXPORT_SYMBOL_NS_GPL`

The two-line `if (rapl_pmu.registered)` change applies in place.
`registered` already exists.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: 35cf088 is here and only adds a `dev_info`. **This panic is not
already fixed.** `git log --grep='panic during PMU'` on this path is
empty.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **drivers/powercap (Intel RAPL)** — **IMPORTANT** for Intel
platforms with TPMI RAPL + perf, not core-mm/VFS. Panic still takes down
the machine.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature driver; PMU APIs added in v6.11. Moderate churn (platform
IDs, locking, leak fixes). This is a leftover hole in the v6.11 PMU
feature, not a brand-new 7.x path.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Config/driver-specific:** `CONFIG_INTEL_RAPL_TPMI` +
`CONFIG_PERF_EVENTS` on Intel TPMI RAPL hardware (client MTL/LNL/ARL and
any TPMI Xeon). Not universal, not staging.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: (1) At least one package successfully added the PMU
(`has_pmu=true`, `registered=true`). (2) A later package causes
unregister + `memset(&rapl_pmu.pmu)` + failed `perf_pmu_register`
(`registered` stays false; prior packages keep `has_pmu`). (3) Last
`has_pmu` package is removed. Dual-package extra-domain update is
documented in-tree. First-package-only register failure is already safe
(`has_pmu` not set). Commonness: uncommon; severity when hit: panic.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Kernel oops/panic** via NULL deref in `list_del_rcu` /
`__list_del`. **Severity: CRITICAL.**

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Prevents a real panic on TPMI RAPL unbind after a failed
  PMU update. Complements the probe-failure log already in 6.12.110.
- **Risk:** Very low — one boolean already used on the add path; skip
  unregister only when the PMU is not on the perf list.
- **Ratio:** Strongly favors backport. Needs a 2-line context-adjusted
  backport, not the later `_locked` API.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real kernel panic (`list_del_rcu` on a zeroed `pmu->entry`)
- Buggy code and `rapl_pmu.registered` both exist in 6.12.111
- Bug present since v6.11
- 2-line, obviously correct
- Reviewed and applied by Rafael Wysocki
- Sibling PMU-failure handling already backported here (35cf088)
- No new feature/API

**AGAINST:**
- Exact hunk targets `rapl_package_remove_pmu_locked()` (post-6.12
  split) — needs a tiny backport
- Trigger needs a failed re-register after a successful one (not every
  boot)
- TPMI-only in this tree
- No syzbot / no Fixes tag (expected)

**UNRESOLVED:**
- Stable@ discussion (lore 403)
- Whether a later mainline `rapl_pmu_update()` memsets the whole
  `rapl_pmu` on error (6.12 path is still panic-capable as shown)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — flag already tracks
   registration; maintainer applied it.
2. Fixes a real bug that affects users? **PASS** — panic on RAPL TPMI
   unbind after failed PMU update.
3. Important issue? **PASS** — kernel panic, CRITICAL.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** (with trivial rename/context:
   same check in `rapl_package_remove_pmu`).

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It is a straight
crash fix.

**Step 9.4: MAKE YOUR DECISION**

This is a small, obviously correct panic fix for code that 6.12 has had
since v6.11. The `_locked` wrapper is not a dependency. Backport the
same `if (rapl_pmu.registered)` guard into `rapl_package_remove_pmu()`.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Abel Vesa; Link msgid
  20260822094657; Rafael SOB; no Fixes/Cc:stable/syzbot
- [Phase 1] Body describes list_del_rcu on NULL after failed register +
  leftover has_pmu
- [Phase 2] Diff: 2 lines in remove path; add `if (rapl_pmu.registered)`
  before `perf_pmu_unregister`
- [Phase 2] Local `rapl_pmu_update()` confirmed: memset pmu, set
  registered=false, return on register failure without clearing other
  packages’ has_pmu
- [Phase 2] `perf_pmu_unregister` → `list_del_rcu(&pmu->entry)`;
  `list_add_rcu` only after successful register
- [Phase 3] git blame: 575024a8aa7cf (v6.11) introduced the bug;
  ancestor of HEAD
- [Phase 3] 963a9ad3c589 TPMI Enable PMU support is in this tree
- [Phase 3] 35cf088430978 already in v6.12.110; does not fix unregister
  panic
- [Phase 3] dcd0b625 `_locked` split is NOT an ancestor of HEAD
- [Phase 4] Original 2026-07-26; resend 2026-08-22; Abel Reviewed-by;
  Rafael applied as 7.3-rc; no NAK
- [Phase 4] b4 dig on this SHA N/A (commit not in tree); b4 dig on
  35cf088 found v3 lore thread
- [Phase 4] lore.kernel.org/stable fetch 403 — UNVERIFIED stable-list
  history
- [Phase 5] Only 6.12 caller: intel_rapl_tpmi_remove; probe ignores
  add_pmu errors
- [Phase 6] git describe HEAD: p-6.12-3-gc504cf0baa3d8; kernelversion
  6.12.111; buggy unregister at intel_rapl_common.c:2104
- [Phase 6] rapl_pmu.registered exists; patch needs function-name
  context tweak
- [Phase 8] Failure mode: NULL deref / oops on unbind, severity CRITICAL
- UNVERIFIED: whether anyone nominated this on stable@

The fix is small, surgical, and meets the stable criteria for this 6.12
tree.

**YES**

 drivers/powercap/intel_rapl_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index f08ac99f5e55e..977c4c90923d5 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -2106,7 +2106,9 @@ void rapl_package_remove_pmu(struct rapl_package *rp)
 			return;
 	}
 
-	perf_pmu_unregister(&rapl_pmu.pmu);
+	if (rapl_pmu.registered)
+		perf_pmu_unregister(&rapl_pmu.pmu);
+
 	memset(&rapl_pmu, 0, sizeof(struct rapl_pmu));
 }
 EXPORT_SYMBOL_GPL(rapl_package_remove_pmu);
-- 
2.53.0

