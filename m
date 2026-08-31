Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A97B490C04;
	Mon, 31 Aug 2026 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183512; cv=none; b=coHY3mmQ7sxJroFOoGHbsfB+FFwTfM/e5//2aAtfoT1l3nroBl3+ewEQ6c9EewzYfCgZnDp5syRltmV+omuaG1IdLut8mYPdTH6imPgvmgkx9nThwInDkN2CKRBWyZYw9nIOSgjLamam77a5zAXLhlmVZkIkL4ZlScnqK6GIcLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183512; c=relaxed/simple;
	bh=D4jnDp8i2sObWxNYPHVxmKCsB2PC/u4qutfWV8zfqFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hAQIorGXLoVs2mcYdvVABYT8o8w2aTiMZwFO4xVMWj4+0Uh1hVJH0HSwAuffofbpm54+he/+1yTJyu4gn3Imk6S2MJ6W82VsWwlGB4GewQ7EsCCsRaXhDGEvTpU5SALphdDvEYXXJyK/Mwu80Vfwn8XJuR/fz6q3aUOjoyIy+NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmtaWE07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmtaWE07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0360C1F00A3E;
	Mon, 31 Aug 2026 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183510;
	bh=FwwPdvzqevX4qbZSbYXl0H1ZvCRmyAEVhmV3o6B+U7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmtaWE07lGGuhJnEVPgf3PEm3DbBNy15kBTIlHK8YrRITFckppe9rbzyJHoqov6uZ
	 cj+U/YeUiTJ3u4R35YRNms9ceGjs/iO2FcWt0sXGjeXnmkHiQkEhS04Tt5UJiryByw
	 i1h/z8d6aL3A3kCpxq4eWgHn7uGdcjNypZX4djj6LLWSWI+JVMGYrXJusmuJ9HJmlg
	 sjqRUvvDCvYaqMsYxUy945S2mMzClDfquTx+Ci4QyaBcBseoz/Yf/B4u4phTuNLm2/
	 FbV2mHP+iyIRH6rh+KXCGSbzs9vH2+8L8Mlti/5eYCb1dVg3M8jJuxDt2mtauTOc7E
	 OAqG0fucYHSCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Leach <matthew.leach@collabora.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] PM: hibernate: call preallocate_image() after freeze prepare
Date: Mon, 31 Aug 2026 09:22:47 -0400
Message-ID: <20260831133314.4125787-139-sashal@kernel.org>
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

From: Matthew Leach <matthew.leach@collabora.com>

[ Upstream commit 783c8109844503bd1c35dab41b6d5fd074a9f131 ]

Certain drivers release resources (pinned pages, etc.) into system
memory during the prepare freeze PM op, making them swappable.
Currently, hibernate_preallocate_memory() is called before prepare
freeze, so those drivers have no opportunity to release resources
first. If a driver is holding a large amount of unswappable system
RAM, this can cause hibernate_preallocate_memory() to fail.

Move the call to hibernate_preallocate_memory() after prepare freeze.

According to the documentation for the prepare callback, devices should
be left in a usable state, so storage drivers should still be able to
service I/O requests. This allows drivers to release unswappable
resources prior to preallocation, so they can be swapped out through
hibernate_preallocate_memory()'s reclaim path.

Also remove shrink_shmem_memory() since hibernate_preallocate_memory()
will have reclaimed enough memory for the hibernation image.

Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
[ rjw: Subject and changelog tweaks ]
Link: https://patch.msgid.link/20260403-hibernation-fixes-v3-1-31bc9fa3ba2d@collabora.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: PM: hibernate: call preallocate_image()
after freeze prepare

**Local tree:** `v6.18.44` (stable/linux-6.18.y)
**Upstream commit:** `783c8109844503bd1c35dab41b6d5fd074a9f131` (not
present in this tree; cherry-picks cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[PM: hibernate]` `[call/move]` — Reorder
`hibernate_preallocate_memory()` to run after `dpm_prepare(PMSG_FREEZE)`
instead of before it.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Matthew Leach (author), Rafael J. Wysocki
  (committer)
- **Reviewed-by:** Mario Limonciello (AMD) `<superm1@kernel.org>`
- **Link:** https://patch.msgid.link/20260403-hibernation-
  fixes-v3-1-31bc9fa3ba2d@collabora.com
- No Fixes:, Reported-by:, Tested-by:, or Cc: stable tags
- Pipeline-added Signed-off-by: Sasha Levin — ignored per instructions

**Notable:** Reviewed by the AMD maintainer who also committed the
existing `shrink_shmem_memory()` workaround in this tree.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `hibernate_preallocate_memory()` runs before
  `dpm_prepare(PMSG_FREEZE)`. Drivers release pinned/unswappable pages
  during `prepare`, but preallocation has already counted available
  memory, so preallocation can fail.
- **Symptom:** Hibernation fails with insufficient memory for the
  snapshot image.
- **Root cause:** Wrong ordering — resource release in `prepare` happens
  too late.
- **Fix approach:** Move preallocation after `dpm_prepare`; remove
  `shrink_shmem_memory()` as redundant (preallocate's reclaim path
  handles it).

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as reordering, but it fixes a real
functional bug (hibernation failure) and replaces an incomplete
workaround (`shrink_shmem_memory()`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `kernel/power/hibernate.c` only (+9 / -37 lines)
- **Functions modified:** removes `shrink_shmem_memory()`; reorders
  logic in `hibernation_snapshot()`
- **Scope:** Single-file, surgical reorder + cleanup

### Step 2.2: Code flow changes
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| `shrink_shmem_memory()` | Called after `dpm_prepare()` | Function
removed entirely |
| Preallocation | Before `freeze_kernel_threads()` | After
`dpm_prepare(PMSG_FREEZE)` |
| `freeze_kernel_threads()` error | `goto Cleanup` → `swsusp_free()` |
`goto Close` (nothing to free yet) |
| `dpm_prepare()` error | inline `dpm_complete` + `goto Thaw` | `goto
Complete` |
| Preallocate error (new position) | N/A | `goto Complete` →
`dpm_complete(PMSG_RECOVER)` + thaw |
| `Cleanup:` label | `swsusp_free()` on early errors | Removed
(preallocate not yet run) |

### Step 2.3: Bug mechanism
**Record:** **Logic / ordering bug** in the hibernation snapshot
sequence.
- Drivers like AMDGPU call `amdgpu_device_prepare()` →
  `amdgpu_device_evict_resources()` during `dpm_prepare()`, releasing
  pinned BO memory.
- Preallocation before `prepare` cannot see that memory; reclaim during
  preallocate cannot swap it out.
- The existing `shrink_shmem_memory()` workaround only partially
  addresses a related symptom (VRAM moved to shmem during prepare) and
  only reclaims ~50% of shmem.

### Step 2.4: Fix quality
**Record:** Obviously correct ordering fix. Error paths are simplified
and consistent with the new call order. `hibernate_preallocate_memory()`
already calls `shrink_all_memory()` internally (verified in
`snapshot.c:1918`), making the separate `shrink_shmem_memory()`
redundant. Low regression risk — reclaim-after-freeze was already done
at this point via `shrink_shmem_memory()`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Preallocate-before-prepare ordering: Rafael Wysocki, 2009
  (`64a473cb74a88`) — long-standing.
- `shrink_shmem_memory()`: Samuel Zhang, Jul 2025 (`2640e819474f4`) —
  workaround for AMDGPU dGPU hibernation failures, **present in this
  tree**.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent related commits in this tree:
- `2640e819474f4` — add `shrink_shmem_memory()` workaround (this commit
  removes it)
- `449c9c02537a1` — restore `pm_restrict_gfp_mask()` in
  `hibernation_snapshot()`, needed because `shrink_shmem_memory()`
  exposed swap/GFP issues (bugzilla #220555, Cc: stable 6.16+)
- `12ffc3b1513eb` — restrict swap use later in suspend sequence

### Step 3.4: Author context
**Record:** Matthew Leach (Collabora). Rafael Wysocki (PM maintainer)
committed upstream. Mario Limonciello (AMD, drm/PM) reviewed with LGTM
and previously committed the `shrink_shmem` workaround.

### Step 3.5: Dependencies
**Record:** Standalone single-patch series (`hibernation-fixes` v1→v3,
only this patch). No prerequisites beyond code already in 6.18.y.
Cherry-pick of `783c81098445` applies cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260403-hibernation-
  fixes-v3-1-31bc9fa3ba2d@collabora.com
- **Series:** v1 (Mar 21) → v2 (Mar 26) → v3 (Apr 3, committed version)
- v2 added removal of `shrink_shmem_memory()` and fixed error path; v3
  renamed error labels

### Step 4.2: Reviewers
**Record:** CC'd Rafael Wysocki, Pavel Machek, Len Brown, Mario
Limonciello, linux-pm@, linux-kernel@. Mario Limonciello: "LGTM" +
Reviewed-by.

### Step 4.3: Bug reports
**Record:** No direct Reported-by. Related bugzilla #220555 (from
`449c9c02537a1`) documents breakage from `shrink_shmem_memory()`
interaction with GFP restrictions — this commit removes that workaround.

### Step 4.4: Series context
**Record:** Single-patch series. Rafael raised deadlock/reclaim concerns
(frozen kthreads, OOM killer disabled); Matthew responded that reclaim
after freeze was already done via `shrink_shmem_memory()` at the same
position — not a new pattern.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found for this specific patch.
Related `449c9c02537a1` was explicitly nominated `Cc: stable 6.16+`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `hibernation_snapshot()`, `hibernate_preallocate_memory()`,
`shrink_shmem_memory()` (removed), `dpm_prepare()`.

### Step 5.2: Callers
**Record:** `hibernation_snapshot()` called from:
- `hibernate()` in `hibernate.c:836` — main hibernation entry via
  `/sys/power/disk`
- `snapshot_write()` in `user.c:311` — `/dev/snapshot` interface

Both are userspace-triggered hibernation paths (root/capability
required).

### Step 5.3: Callees
**Record:** `hibernate_preallocate_memory()` → `shrink_all_memory()` →
direct reclaim via `do_try_to_free_pages()`. `dpm_prepare()` → driver
`.prepare` callbacks (e.g. `amdgpu_pmops_prepare()` →
`amdgpu_device_prepare()` → `amdgpu_device_evict_resources()`).

### Step 5.4: Reachability
**Record:** Triggered by any hibernation attempt (`echo disk >
/sys/power/state`, etc.). Requires `CONFIG_HIBERNATION`. Common on
laptops and some servers.

### Step 5.5: Similar patterns
**Record:** `shrink_shmem_memory()` was the prior partial fix for the
same class of problem. This commit is the architecturally correct
replacement.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current `v6.18.44` tree has preallocate before
`dpm_prepare` and the `shrink_shmem_memory()` workaround at lines
428-460 of `kernel/power/hibernate.c`. Bug present since 2009;
workaround added Jul 2025.

### Step 6.2: Backport complications
**Record:** **Clean apply.** `git cherry-pick --no-commit 783c81098445`
succeeds with auto-merge; `1 file changed, 9 insertions(+), 37
deletions(-)`.

### Step 6.3: Related fixes already present?
**Record:** `shrink_shmem_memory()` workaround (`2640e819474f4`) and GFP
mask fix (`449c9c02537a1`) are already in 6.18.y. This commit supersedes
the workaround with the proper fix. No duplicate fix present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **kernel/power** — CORE subsystem for system
suspend/hibernate. Affects all hibernation users.

### Step 7.2: Activity
**Record:** Actively maintained; multiple hibernation fixes landed in
6.18.y cycle (GFP mask, hybrid-sleep, efivarfs freeze).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users who hibernate (`CONFIG_HIBERNATION=y`), especially
systems with AMDGPU/dGPUs or other drivers that release pinned memory
during `prepare`. The 6.18.y tree already carries the `shrink_shmem`
workaround, confirming real-world impact on this branch.

### Step 8.2: Trigger conditions
**Record:** Every hibernation attempt on affected hardware. Not timing-
dependent. Requires privilege to initiate hibernation (not unprivileged
attack vector).

### Step 8.3: Failure mode severity
**Record:** Hibernation fails — user cannot suspend-to-disk. **Severity:
MEDIUM-HIGH** for hibernation users (functional failure, no
crash/corruption, but complete feature breakage).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit: HIGH** for hibernation users — fixes root cause, improves
  on partial workaround, removes problematic `shrink_shmem_memory()`
  that required a separate GFP fix.
- **Risk: LOW** — net code reduction, reclaim-after-freeze already
  exercised in this tree, reviewed by subsystem experts, error paths
  simplified.
- **Ratio:** Strong benefit, low risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real hibernation failures on driver-heavy systems (AMD GPU evict
  during prepare verified in tree)
- 6.18.y already has the `shrink_shmem` workaround this commit properly
  replaces
- Small, surgical, net -28 lines
- Reviewed by Mario Limonciello (AMD) and committed by Rafael Wysocki
  (PM maintainer)
- Applies cleanly to v6.18.44
- Reclaim-after-freeze pattern already proven safe in this tree (via
  existing `shrink_shmem_memory()`)
- Removes code that previously caused GFP/swap issues (bugzilla #220555)

**AGAINST backport:**
- Not a crash, security, or data-corruption bug
- Partial workaround already in tree may mitigate the shmem-related case
- No explicit Cc: stable or user bug report on this specific patch

**Unresolved:** No end-user bugzilla for the pinned-pages case
specifically; impact inferred from commit message, AMDGPU code path, and
existing workaround history.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logical ordering fix;
   reviewed by AMD + PM maintainer; v1→v3 review addressed deadlock
   concerns.
2. Fixes real bug affecting users? **PASS** — hibernation failure on
   systems with drivers releasing pinned memory during prepare.
3. Important issue? **PASS** — hibernation completely fails (MEDIUM-HIGH
   for affected users).
4. Small and contained? **PASS** — 1 file, 46 lines changed.
5. No new features/APIs? **PASS** — reordering only.
6. Can apply to local tree? **PASS** — cherry-picks cleanly.

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not a quirk/DT/build/doc exception.

### Step 9.4: Problem and why it matters

The hibernation snapshot path preallocates memory for the image before
calling `dpm_prepare(PMSG_FREEZE)`. GPU and other drivers release large
amounts of pinned memory during `prepare`, but that happens too late —
preallocation has already failed or over-committed. The 6.18.y tree
currently papers over a related symptom with `shrink_shmem_memory()`,
which only partially reclaims shmem and required a separate GFP-mask
fix. This commit fixes the root ordering problem and removes the
workaround, making hibernation more reliable on affected hardware.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.44; parsed subject, tags, body
  from provided commit message
- [Phase 1] Tags: Reviewed-by Mario Limonciello; Link to lore; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Read `kernel/power/hibernate.c:395-500` — confirmed current
  buggy ordering and `shrink_shmem_memory()` present
- [Phase 2] Read `kernel/power/snapshot.c:1918` —
  `hibernate_preallocate_memory()` calls `shrink_all_memory()`
- [Phase 3] `git blame -L 428,460 kernel/power/hibernate.c` —
  preallocate ordering from 2009; shrink_shmem from 2640e819 (Jul 2025)
- [Phase 3] `git show 2640e819474f4` — workaround for dGPU VRAM→shmem
  hibernation failure
- [Phase 3] `git show 449c9c02537a1` — GFP fix needed because of
  shrink_shmem; bugzilla #220555; Cc: stable 6.16+
- [Phase 3] `git merge-base --is-ancestor 783c81098445 HEAD` →
  NOT_IN_CURRENT_TREE
- [Phase 3] `git log --oneline -20 -- kernel/power/hibernate.c` — recent
  PM hibernation activity
- [Phase 4] `b4 dig -c 1d74e7f09f725` → lore URL found
- [Phase 4] `b4 dig -c 1d74e7f09f725 -a` → v1/v2/v3 series; v3 is
  committed version
- [Phase 4] `b4 dig -c 1d74e7f09f725 -w` → CC'd Rafael, Pavel, Len,
  Mario, linux-pm@
- [Phase 4] `b4 dig -m /tmp/hibernate-fix.mbox` — Mario LGTM + Reviewed-
  by; Rafael deadlock questions answered
- [Phase 5] `grep hibernation_snapshot(` — callers in `hibernate.c:836`,
  `user.c:311`
- [Phase 5] Read `amdgpu_device.c:5174-5200` — `amdgpu_device_prepare()`
  evicts resources during prepare
- [Phase 6] Buggy code confirmed present in v6.18.44 at lines 428-460
- [Phase 6] `git cherry-pick --no-commit 783c81098445` → clean apply,
  9+/37-
- [Phase 6] `git diff HEAD..1d74e7f09f725 -- kernel/power/hibernate.c` —
  identical changes needed
- [Phase 7] Subsystem: kernel/power (CORE)
- [Phase 8] Failure mode: hibernation failure; severity MEDIUM-HIGH for
  hibernation users

**YES**The background searches finished and matched what the main
analysis already used:

- **Current tree (`v6.18.44`):** no match for this commit by
  subject/grep — it isn’t in `stable/linux-6.18.y` yet.
- **`autosel` branch:** found upstream commit `783c81098445` / stable-
  prepared `1d74e7f09f725` — *PM: hibernate: call preallocate_image()
  after freeze prepare*.
- **Hibernation-fixes series:** single-patch series (v1→v3); nothing
  else required for backport.

**Verdict for 6.18.y: YES** — real hibernation failure on driver
`prepare` paths, replaces the partial `shrink_shmem_memory()` workaround
already in this tree, cherry-picks cleanly.

 kernel/power/hibernate.c | 46 ++++++++--------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 26e45f86b9554..26289e3c28ae7 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -392,23 +392,6 @@ static int create_image(int platform_mode)
 	return error;
 }
 
-static void shrink_shmem_memory(void)
-{
-	struct sysinfo info;
-	unsigned long nr_shmem_pages, nr_freed_pages;
-
-	si_meminfo(&info);
-	nr_shmem_pages = info.sharedram; /* current page count used for shmem */
-	/*
-	 * The intent is to reclaim all shmem pages. Though shrink_all_memory() can
-	 * only reclaim about half of them, it's enough for creating the hibernation
-	 * image.
-	 */
-	nr_freed_pages = shrink_all_memory(nr_shmem_pages);
-	pr_debug("requested to reclaim %lu shmem pages, actually freed %lu pages\n",
-			nr_shmem_pages, nr_freed_pages);
-}
-
 /**
  * hibernation_snapshot - Quiesce devices and create a hibernation image.
  * @platform_mode: If set, use platform driver to prepare for the transition.
@@ -425,14 +408,9 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		goto Close;
 
-	/* Preallocate image memory before shutting down devices. */
-	error = hibernate_preallocate_memory();
-	if (error)
-		goto Close;
-
 	error = freeze_kernel_threads();
 	if (error)
-		goto Cleanup;
+		goto Close;
 
 	if (hibernation_test(TEST_FREEZER)) {
 
@@ -445,19 +423,13 @@ int hibernation_snapshot(int platform_mode)
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
-	if (error) {
-		dpm_complete(PMSG_RECOVER);
-		goto Thaw;
-	}
+	if (error)
+		goto Complete;
 
-	/*
-	 * Device drivers may move lots of data to shmem in dpm_prepare(). The shmem
-	 * pages will use lots of system memory, causing hibernation image creation
-	 * fail due to insufficient free memory.
-	 * This call is to force flush the shmem pages to swap disk and reclaim
-	 * the system memory so that image creation can succeed.
-	 */
-	shrink_shmem_memory();
+	/* Preallocate image memory before shutting down devices. */
+	error = hibernate_preallocate_memory();
+	if (error)
+		goto Complete;
 
 	console_suspend_all();
 	pm_restrict_gfp_mask();
@@ -492,10 +464,10 @@ int hibernation_snapshot(int platform_mode)
 	platform_end(platform_mode);
 	return error;
 
+ Complete:
+	dpm_complete(PMSG_RECOVER);
  Thaw:
 	thaw_kernel_threads();
- Cleanup:
-	swsusp_free();
 	goto Close;
 }
 
-- 
2.53.0

