Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D26A3D813D;
	Mon, 20 Apr 2026 13:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691429; cv=none; b=N2lt56bqzKriwuNQl0i6iU8Bs7qzkH7hnZFvki1n3X3T5LfhTLM90rrxWpFlHEltGeEPlxRCHoYertB3fMUUP/BeQHAc5OOBekYcLfx24u6KcvrbSFuP9pKUuaAdQSfSzMDJhoeuW2KUCC+S+tkiuw7cnD3wVkOiVN0RdJAEhkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691429; c=relaxed/simple;
	bh=tndVcEmccZTuxB7kpIPKtjzN2f1jeKsWT0kgomyoWLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EQbyllLWom1xLtezTopCc5D7SDkd0pkPRvHXne3PhPnNNjh0haNKfyuvPvbLMg+DQpZht4JSOTndoaDUoz+bOkU+O5UQpwBjNWjaIYfL4SodrA1q7d58fxialtXwFc98A4qqY6lAHxJds4fvCPvdl7MoFnTbjrt2CNR9JNUFLYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLRfZq4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLRfZq4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3462FC19425;
	Mon, 20 Apr 2026 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691429;
	bh=tndVcEmccZTuxB7kpIPKtjzN2f1jeKsWT0kgomyoWLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLRfZq4gdZNce3MVuoxP9tPjvXW6o2pwIwc61+ndqjrRJvIAAAg0CTxQZVEnXmqT+
	 CpnKRRq/9TVJtoD+Ju03SZcjNAmvFVB9Kr2BeXqwegChEO1f6Ut7NhuOBqnQkHaUQg
	 lHPrJ0JnWu01Q5yvSiIo6cVYMr8CLuu+YxG0hpcRxkFYeVm6OFt9e5FvcmlhwqI/1D
	 zoR6pwYShyUdfjZEpkDfyV0UCi9JrVOBVb0A+V3y/uqVo4cdPAXCu8kc37Hhyn6zNr
	 3L1MF+zBjo5eJ5bllM/2mYZQgHLHnDXOvxB+TdpaDlCvV9Zxk0drfUzT7Vghz6GDDH
	 RFrzgaCPok5zw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomasz Lis <tomasz.lis@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] drm/xe/vf: Wait for all fixups before using default LRCs
Date: Mon, 20 Apr 2026 09:16:55 -0400
Message-ID: <20260420132314.1023554-21-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomasz Lis <tomasz.lis@intel.com>

[ Upstream commit f3fb5f1ebbf39e685dd2885c9dbc8bb0a80be7c6 ]

When a context is being created during save/restore, the LRC creation
needs to wait for GGTT address space to be shifted. But it also needs
to have fixed default LRCs. This is mandatory to avoid the situation
where LRC will be created based on data from before the fixups, but
reference within exec queue will be set too late for fixups.

This fixes an issue where contexts created during save/restore have
a large chance of having one unfixed LRC, due to the xe_lrc_create()
being synced for equal start to race with default LRC fixups.

v2: Move the fixups confirmation further, behind all fixups.
  Revert some renames.

Signed-off-by: Tomasz Lis <tomasz.lis@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patch.msgid.link/20260226212701.2937065-4-tomasz.lis@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the complete
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/xe/vf` (Intel Xe GPU driver, VF/SR-IOV path)
- Action verb: "Wait for" (= ensure, prevent — indicates fixing
  incorrect behavior)
- Summary: Wait for all fixups to complete before using default LRCs
  during VF migration recovery

Record: [drm/xe/vf] [Wait for / ensure] [Delays ggtt_need_fixes
completion signal until after all fixups, not just GGTT shift]

**Step 1.2: Tags**
- Signed-off-by: Tomasz Lis (author, Intel contributor with 30 commits
  in Xe driver)
- Reviewed-by: Matthew Brost (co-author of the original buggy commit
  3c1fa4aa60b14)
- Signed-off-by: Michal Wajdeczko (maintainer-level committer, 15
  commits to this file)
- Link: patch.msgid.link/20260226212701.2937065-4-tomasz.lis@intel.com
- No Fixes: tag, no Reported-by:, no Cc: stable (expected for autosel
  candidate)

Record: Reviewed by subsystem expert (Brost), committed by subsystem
lead (Wajdeczko). No explicit stable nomination.

**Step 1.3: Commit Body Analysis**
- Bug: LRC creation during save/restore can race with default LRC fixups
- Symptom: "contexts created during save/restore have a large chance of
  having one unfixed LRC"
- Root cause: `xe_lrc_create()` synced for "equal start to race with
  default LRC fixups" — meaning `ggtt_need_fixes` is cleared too early
  (after GGTT shift only, before default LRC hwsp rebase)
- Cover letter (from b4 dig): "Tests which create a lot of exec queues
  were sporadically failing due to one of LRCs having its state within
  VRAM damaged"

Record: Real race condition causing VRAM state corruption in LRC during
VF migration. Sporadic test failures observed.

**Step 1.4: Hidden Bug Fix Detection**
This IS explicitly described as a fix ("This fixes an issue where...").
Not hidden.

Record: Explicit bug fix for a race condition.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `xe_gt_sriov_vf.c`: ~15 lines changed. Removes 5 lines from
  `vf_get_ggtt_info()`, adds new function
  `vf_post_migration_mark_fixups_done()` (5 lines), adds 1 call in
  `vf_post_migration_recovery()`, updates 1 comment.
- `xe_gt_sriov_vf_types.h`: 1 line comment update.
- Scope: Single-file surgical fix (functionally), trivial doc change in
  header.

Record: 2 files changed, ~15 net lines modified. Functions:
`vf_get_ggtt_info()` (code removed), new
`vf_post_migration_mark_fixups_done()`, `vf_post_migration_recovery()`
(call added). Scope: surgical.

**Step 2.2: Code Flow Change**
- **Before**: `ggtt_need_fixes` set to `false` + `wake_up_all()` in
  `vf_get_ggtt_info()`, which is the FIRST step of
  `vf_post_migration_fixups()`. This means waiters (LRC creators) are
  released while `xe_sriov_vf_ccs_rebase()`,
  `xe_gt_sriov_vf_default_lrcs_hwsp_rebase()`, and
  `xe_guc_contexts_hwsp_rebase()` are still pending.
- **After**: `ggtt_need_fixes` cleared and waiters woken ONLY after
  `vf_post_migration_fixups()` returns, meaning ALL fixups (GGTT shift,
  CCS rebase, default LRC hwsp rebase, contexts hwsp rebase) are
  complete before `xe_lrc_create()` can proceed.

Record: Moves the "fixups done" signal from midway through fixups to
after ALL fixups complete. Eliminates a race window where LRC creation
proceeds with stale default LRC data.

**Step 2.3: Bug Mechanism**
Category: Race condition. Specifically:
1. Migration triggers recovery, sets `ggtt_need_fixes = true`
2. `vf_post_migration_fixups()` calls `xe_gt_sriov_vf_query_config()` →
   `vf_get_ggtt_info()`, which sets `ggtt_need_fixes = false` and wakes
   waiters
3. Concurrent `xe_lrc_create()` (in `__xe_exec_queue_init()`) was
   waiting on `ggtt_need_fixes` via `xe_gt_sriov_vf_wait_valid_ggtt()` —
   now it proceeds
4. But default LRC hwsp rebase hasn't happened yet — `xe_lrc_create()`
   uses unfixed default LRC data
5. Result: LRC created with stale VRAM state

Record: [Race condition] The `ggtt_need_fixes` flag is cleared after
GGTT shift but before default LRC fixups, allowing `xe_lrc_create()` to
use stale default LRC data.

**Step 2.4: Fix Quality**
- Obviously correct: moves signaling to logically correct location
  (after ALL fixups)
- Minimal/surgical: only moves existing code, creates a small helper
  function
- Regression risk: Very low. The only change is that waiters wait
  slightly longer (for all fixups instead of just GGTT shift). This
  cannot cause deadlock since the fixups are sequential and bounded.

Record: Fix is obviously correct, minimal, and has negligible regression
risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy code (clearing `ggtt_need_fixes` in `vf_get_ggtt_info`) was
introduced by commit `3c1fa4aa60b14` (Matthew Brost, 2025-10-08,
"drm/xe: Move queue init before LRC creation"). This commit first
appeared in v6.19.

Record: Buggy code introduced in 3c1fa4aa60b14, first present in v6.19.
Exists in 6.19.y and 7.0.y stable trees.

**Step 3.2: Fixes tag**
No explicit Fixes: tag in this commit. However, the series cover letter
and patch 1/4 have `Fixes: 3c1fa4aa60b1`.

Record: Implicitly fixes 3c1fa4aa60b14 which is in v6.19 and v7.0.

**Step 3.3: File History / Related Commits**
20+ commits to this file between v6.19 and v7.0. The VF migration
infrastructure is actively developed. Patch 1/4 of the same series
(99f9b5343cae8) is already in the tree.

Record: Active development area. Patch 1/4 already merged. Patches 2/4
and 4/4 not yet in tree.

**Step 3.4: Author**
Tomasz Lis has 30 commits in the xe driver, is an active contributor.
Matthew Brost (reviewer) authored the original buggy commit and is a key
xe/VF contributor. Michal Wajdeczko (committer) has 15 commits to this
specific file.

Record: Author and reviewers are all established subsystem contributors.

**Step 3.5: Dependencies**
This patch is standalone. It does NOT depend on patches 2/4 or 4/4:
- Patch 2/4 adds lrc_lookup_lock wrappers (separate race protection)
- Patch 4/4 adds LRC re-creation logic (a further improvement)
- This patch (3/4) only moves existing code and adds one call

Record: Standalone fix. No dependencies on other unmerged patches.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Original Discussion**
Found via `b4 dig`. Series went through 4 versions (v1 through v4).
Cover letter title: "drm/xe/vf: Fix exec queue creation during post-
migration recovery". The series description confirms sporadic test
failures with VRAM-damaged LRC state.

Record: lore URL:
patch.msgid.link/20260226212701.2937065-4-tomasz.lis@intel.com. 4
revisions. Applied version is v4 (latest).

**Step 4.2: Reviewers**
CC'd: intel-xe@lists.freedesktop.org, Michał Winiarski, Michał
Wajdeczko, Piotr Piórkowski, Matthew Brost. All Intel Xe subsystem
experts.

Record: Appropriate subsystem experts were all involved in review.

**Step 4.3-4.5: Bug Reports / Stable Discussion**
No explicit syzbot or external bug reports. The issue was found
internally through testing. No explicit stable discussion found.

Record: Internal testing found the bug. No external bug reports or
stable nominations.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.2: Functions Modified**
- `vf_get_ggtt_info()`: Called from `xe_gt_sriov_vf_query_config()`,
  which is called from `vf_post_migration_fixups()` during migration
  recovery.
- New `vf_post_migration_mark_fixups_done()`: Called from
  `vf_post_migration_recovery()`.
- `xe_gt_sriov_vf_wait_valid_ggtt()`: Called from
  `__xe_exec_queue_init()` which is called during exec queue creation —
  a common GPU path.

Record: The wait function is called during exec queue creation, which is
a common user-triggered path. The fix ensures correctness of this common
path during VF migration.

**Step 5.4: Call Chain**
User creates exec queue → `xe_exec_queue_create()` →
`__xe_exec_queue_init()` → `xe_gt_sriov_vf_wait_valid_ggtt()` →
`xe_lrc_create()`. The buggy path is directly reachable from userspace
GPU operations during VF migration.

Record: Path is reachable from userspace GPU operations.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable Trees**
The buggy commit 3c1fa4aa60b14 exists in v6.19 and v7.0. The bug does
NOT exist in v6.18 or earlier (the VF migration wait mechanism was added
in that commit).

Record: Bug exists in 6.19.y and 7.0.y stable trees only.

**Step 6.2: Backport Complications**
The patch should apply cleanly to the 7.0 tree. For 6.19, there may be
minor context differences but the code structure is the same.

Record: Expected clean apply for 7.0.y. Minor conflicts possible for
6.19.y.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem Criticality**
- Subsystem: `drivers/gpu/drm/xe` (Intel discrete GPU driver), VF/SR-IOV
  migration
- Criticality: PERIPHERAL — affects SR-IOV VF GPU users
  (cloud/virtualization deployments with Intel GPUs)

Record: PERIPHERAL criticality, but important for Intel GPU
virtualization users.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is Affected**
Users running Intel Xe GPU in SR-IOV VF mode with live migration
support. This is relevant for cloud/virtualization environments.

**Step 8.2: Trigger Conditions**
Triggered when exec queue creation (GPU workload submission setup)
happens concurrently with VF post-migration recovery. The cover letter
says "tests which create a lot of exec queues were sporadically
failing."

**Step 8.3: Failure Mode Severity**
LRC created with stale VRAM state → corrupted GPU context → GPU errors,
potential hangs, incorrect rendering. Severity: HIGH for affected users
(data corruption in GPU state).

**Step 8.4: Risk-Benefit**
- BENEFIT: Fixes sporadic GPU state corruption during VF migration.
  Important for virtualized GPU workloads.
- RISK: Very low. The fix moves 5 lines of signaling code to a later
  point. No new locking, no API changes, no functional changes beyond
  delaying the wake-up.
- Ratio: High benefit / Very low risk.

Record: [HIGH benefit for VF migration users] [VERY LOW risk] [Favorable
ratio]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**
FOR backporting:
- Fixes a real race condition causing GPU state corruption during VF
  migration
- Small, surgical fix (~15 lines, moves existing code)
- Obviously correct (signals fixups done after ALL fixups, not just one)
- Reviewed by the original code author (Brost) and committed by
  subsystem lead (Wajdeczko)
- 4 revisions of review before merge
- Standalone fix (does not require other patches from the series)
- Buggy code exists in 6.19.y and 7.0.y stable trees

AGAINST backporting:
- Part of a 4-patch series (but standalone as analyzed)
- Niche use case (SR-IOV VF migration on Intel Xe GPUs)
- No explicit Fixes: tag or Cc: stable (expected for autosel candidates)
- No syzbot or external bug reports

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES — logically obvious, reviewed, went
   through CI, 4 revisions
2. Fixes a real bug? YES — race condition causing LRC corruption during
   migration
3. Important issue? YES — GPU state corruption
4. Small and contained? YES — ~15 lines in one functional file
5. No new features or APIs? YES — no new features
6. Can apply to stable? YES — should apply cleanly to 7.0

**Step 9.3: Exception Categories**
Not an exception category — this is a standard bug fix.

**Step 9.4: Decision**
This is a clear, small, well-reviewed race condition fix that prevents
GPU state corruption during VF migration. It is standalone, obviously
correct, and meets all stable kernel criteria.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Matthew Brost, Signed-off-by Michal
  Wajdeczko (committer), Link to lore. No Fixes: tag (expected).
- [Phase 2] Diff analysis: Removes 5 lines from `vf_get_ggtt_info()`
  (ggtt_need_fixes clearing), adds new 5-line helper
  `vf_post_migration_mark_fixups_done()`, adds 1 call in
  `vf_post_migration_recovery()` after `vf_post_migration_fixups()`.
  Updates 2 comments.
- [Phase 3] git blame: Buggy code introduced in 3c1fa4aa60b14 (Oct 2025,
  v6.19), confirmed via `git blame` and `git tag --contains`.
- [Phase 3] git show 3c1fa4aa60b14: Confirmed this commit added the
  `ggtt_need_fixes` mechanism in `vf_get_ggtt_info()` with the premature
  clearing.
- [Phase 3] File history: 20+ commits between v6.19 and v7.0, active
  development area.
- [Phase 3] Patch 1/4 (99f9b5343cae8) already in tree. Patches 2/4 and
  4/4 not in tree. Verified patch 3/4 is standalone by reading diffs.
- [Phase 4] b4 dig: Found series at
  patch.msgid.link/20260226212701.2937065-2-tomasz.lis@intel.com. Series
  went v1→v4.
- [Phase 4] b4 dig -w: CC'd to intel-xe list, 4 Intel engineers.
- [Phase 4] Cover letter confirms: "sporadic failures due to one of LRCs
  having its state within VRAM damaged."
- [Phase 5] `xe_gt_sriov_vf_wait_valid_ggtt()` called from
  `__xe_exec_queue_init()` in `xe_exec_queue.c:318`, confirming the wait
  is in the LRC creation path.
- [Phase 5] `vf_post_migration_fixups()` confirmed to call
  `xe_gt_sriov_vf_query_config()` (which calls `vf_get_ggtt_info()`)
  FIRST, then `xe_sriov_vf_ccs_rebase()`,
  `xe_gt_sriov_vf_default_lrcs_hwsp_rebase()`,
  `xe_guc_contexts_hwsp_rebase()` — confirming the early clearing race.
- [Phase 6] Bug exists in v6.19 and v7.0 (verified via `git tag
  --contains 3c1fa4aa60b14`).
- [Phase 8] Failure mode: GPU state corruption in LRC during VF
  migration, severity HIGH.
- UNVERIFIED: Exact backport applicability to 6.19.y (context may differ
  slightly due to intermediate commits).

**YES**

 drivers/gpu/drm/xe/xe_gt_sriov_vf.c       | 16 +++++++++-------
 drivers/gpu/drm/xe/xe_gt_sriov_vf_types.h |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
index 30e8c2cf5f09a..b50f7181ce7a9 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -529,12 +529,6 @@ static int vf_get_ggtt_info(struct xe_gt *gt)
 		xe_tile_sriov_vf_fixup_ggtt_nodes_locked(gt_to_tile(gt), shift);
 	}
 
-	if (xe_sriov_vf_migration_supported(gt_to_xe(gt))) {
-		WRITE_ONCE(gt->sriov.vf.migration.ggtt_need_fixes, false);
-		smp_wmb();	/* Ensure above write visible before wake */
-		wake_up_all(&gt->sriov.vf.migration.wq);
-	}
-
 	return 0;
 }
 
@@ -839,6 +833,13 @@ static void xe_gt_sriov_vf_default_lrcs_hwsp_rebase(struct xe_gt *gt)
 		xe_default_lrc_update_memirq_regs_with_address(hwe);
 }
 
+static void vf_post_migration_mark_fixups_done(struct xe_gt *gt)
+{
+	WRITE_ONCE(gt->sriov.vf.migration.ggtt_need_fixes, false);
+	smp_wmb();	/* Ensure above write visible before wake */
+	wake_up_all(&gt->sriov.vf.migration.wq);
+}
+
 static void vf_start_migration_recovery(struct xe_gt *gt)
 {
 	bool started;
@@ -1373,6 +1374,7 @@ static void vf_post_migration_recovery(struct xe_gt *gt)
 	if (err)
 		goto fail;
 
+	vf_post_migration_mark_fixups_done(gt);
 	vf_post_migration_rearm(gt);
 
 	err = vf_post_migration_resfix_done(gt, marker);
@@ -1507,7 +1509,7 @@ static bool vf_valid_ggtt(struct xe_gt *gt)
 }
 
 /**
- * xe_gt_sriov_vf_wait_valid_ggtt() - VF wait for valid GGTT addresses
+ * xe_gt_sriov_vf_wait_valid_ggtt() - wait for valid GGTT nodes and address refs
  * @gt: the &xe_gt
  */
 void xe_gt_sriov_vf_wait_valid_ggtt(struct xe_gt *gt)
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_vf_types.h
index 4ef881b9b6623..fca18be589db9 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf_types.h
@@ -73,7 +73,7 @@ struct xe_gt_sriov_vf_migration {
 	bool recovery_queued;
 	/** @recovery_inprogress: VF post migration recovery in progress */
 	bool recovery_inprogress;
-	/** @ggtt_need_fixes: VF GGTT needs fixes */
+	/** @ggtt_need_fixes: VF GGTT and references to it need fixes */
 	bool ggtt_need_fixes;
 };
 
-- 
2.53.0

