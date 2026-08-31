Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BA15A6E58;
	Mon, 31 Aug 2026 13:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184344; cv=none; b=iSG9mKj4QDzVN4x5SutN5THWg8JpEBU/8XobeVswYNf+ZTBL0EKpbo3bO+KfaByi+VXXoyQFCAUdpdpHxZZBiqnT3BG12pabx3hXRV0Mjex+sjj9WTTThK2EWWHr/Kbbs68hbio4DG78i7H/aXBL4kJfOEyPlH16QKNapbm0g8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184344; c=relaxed/simple;
	bh=LNMfrEgy3/SGQUYXMHRCIGVPeRF7zf0y3FC5XmW+KBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mj1VhypKTdb2MQr1EMv4Nf4ikMCEcVSO/FwfGgblVjtuE8Nno17mUSImrCudnyJoiqb9IGHkkQ19MSnydGYaR4hZPJEEJyyM3M4hoq6/LS5ZE5/vRtV6wUm5+hnGgLeogbJoFcGALomhv7BVesjiXztG4s3/FZnNj/F/Cu6EFrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUw3uKc+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUw3uKc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060491F00ACA;
	Mon, 31 Aug 2026 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184342;
	bh=2soAF6lmYUnjH69q0xPTWuMHpdk0vhzck1FpAB/Wmqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUw3uKc+FqpbJZ6zJ9Z+nQjoZowWDAtRSKSMWa4gCjuItY323BVPe/6pVQNDoeQ/c
	 qD/GvM/WL5V0SMlvw3GngoqyguiwZ7SX3eSbhsTfuqbMX2K27dOMvnSrZ58F1dCC7k
	 ONCIUWXSYiCpcFGn4+y/HEV3E/OzSLu5uiO0RR4stZT8+iB8vbrxNTfJTaku6BTI/t
	 qi+kAtuqv+vP/Ukx8y7qEFkh2QCwXAXSa5kgEaEXEE7uKKuTWTUhu+QQ3cmp+r7Xei
	 VnZfN2kUmdlrend0cp8EZV1cq8x28n0ePFynFpD71ErOVOcPCpUyDHR6oD9YSJNuQz
	 DntjNHKyLGMKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leo Yan <leo.yan@arm.com>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	alexander.shishkin@linux.intel.com,
	coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] coresight: Disable source helpers in coresight_disable_path()
Date: Mon, 31 Aug 2026 09:31:05 -0400
Message-ID: <20260831133314.4125787-637-sashal@kernel.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 5cae719943399929b4f9e612d9400017d3e2c1e1 ]

coresight_enable_path() enables helpers attached to every device in
the path, including those bound to the source. However,
coresight_disable_path() skips the source node, so source helpers had
to be disabled separately in coresight_disable_source().

Move source helper disabling into coresight_disable_path() instead.
Make coresight_disable_path_from() start from the passed node nd, so
it can also disable helpers on the source. Update the comments
accordingly.

As coresight_disable_path_from() now changes its semantics from
"start beyond nd" to "start from nd", update the failure handling in
coresight_enable_path(). If enabling a node fails, iterate to the
previous node (the last successfully enabled one) and pass it to
coresight_disable_path_from() for rollback.

Tested-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260515-arm_coresight_path_power_management_improvement-v14-15-f88c4a3ecfe9@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[coresight] [Disable] [source helpers in
coresight_disable_path()]`

Subsystem: CoreSight (ARM hardware tracing). Action: disable/fix
asymmetry in path teardown.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** Jie Gan `<jie.gan@oss.qualcomm.com>`, James Clark
  `<james.clark@linaro.org>`
- **Reviewed-by:** Yeoreum Yun `<yeoreum.yun@arm.com>`, James Clark
  `<james.clark@linaro.org>`
- **Link:** `https://lore.kernel.org/r/20260515-
  arm_coresight_path_power_management_improvement-v14-15-
  f88c4a3ecfe9@arm.com`
- **Cc: stable:** — none
- **Signed-off-by:** Leo Yan, Suzuki K Poulose (ignore pipeline SOB)

Notable: two subsystem reviewers and two testers; no syzbot/user crash
report.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `coresight_enable_path()` enables helpers on every path node
  (including the source), but `coresight_disable_path()` skipped the
  source node, so source-attached helpers were only torn down via a
  separate call in `coresight_disable_source()`.
- **Symptom:** Error rollback paths that call only
  `coresight_disable_path()` leave source helpers enabled
  (hardware/resource leak, inconsistent tracing state).
- **Root cause:** `coresight_disable_path_from()` used
  `list_for_each_entry_continue()` starting after the source node;
  enable/disable were asymmetric.
- **Fix:** Move source-helper teardown into `coresight_disable_path()`,
  change `coresight_disable_path_from()` to start *from* `nd`
  (`list_for_each_entry_from()`), and fix `coresight_enable_path()`
  rollback to pass the last successfully enabled node.
- **Version info:** Patch 15/28 of v14 CoreSight path power-management
  series (May 2026).

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised cleanup — explicit bug fix for enable/disable
imbalance. The existing in-tree comment at lines 380–388 already
documents this as a known problem.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/hwtracing/coresight/coresight-core.c` only (+8 /
  −19 lines)
- **Functions modified:** `coresight_disable_source()`,
  `coresight_disable_path_from()`, `coresight_disable_path()` (wrapper
  unchanged), `coresight_enable_path()`
- **Scope:** Single-file, surgical fix

### Step 2.2: CODE FLOW CHANGE (per hunk)
**Record:**
1. **`coresight_disable_source()`:** Before: disable source ops +
   `coresight_disable_helpers()`. After: disable source ops only;
   helpers owned by path disable.
2. **`coresight_disable_path_from()`:** Before:
   `list_for_each_entry_continue()` skipped the starting node (source
   when `nd==NULL`). After: `list_for_each_entry_from()` includes
   starting node; source case still skips source ops but runs
   `coresight_disable_helpers()` on source.
3. **`coresight_enable_path()` rollback:** Before: passed failing node
   `nd` to `disable_path_from()` with “beyond nd” semantics. After:
   advances to `list_next_entry(nd)` (last successfully enabled node)
   before rollback, matching new “from nd” semantics.

### Step 2.3: BUG MECHANISM
**Record:** **Category:** Error-path resource / hardware-state leak
(reference-counting / lifecycle asymmetry). **Mechanism:**
`coresight_enable_path()` calls `coresight_enable_helpers()` on all
nodes including source; `coresight_disable_path()` never visited the
source node, so source helpers stayed enabled unless
`coresight_disable_source()` was also called.

### Step 2.4: FIX QUALITY
**Record:** Fix is minimal and logically correct. In-tree callers of
`coresight_disable_source()` (`coresight-sysfs.c:98`, `coresight-etm-
perf.c:685`) are always followed by `coresight_disable_path()`, so
removing helper teardown from `disable_source()` is safe for in-tree
code. Low regression risk; `EXPORT_SYMBOL_GPL` means out-of-tree callers
that only call `disable_source()` would need updating (none found in-
tree).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Shallow tree (50 commits); `git blame` attributes current
`coresight_disable_source()` body to `a112b91dd6349`. Helper
infrastructure (`coresight_is_helper`, `coresight_enable_helpers`,
CATU/CTI/CTCU helpers) is present in this 6.18.43 tree. Related helper
introduction referenced in series as `6148652807ba` (“Enable and disable
helper devices adjacent to the path”) — not individually verifiable in
this shallow history, but helper code is present.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag on this commit. N/A.

### Step 3.3: FILE HISTORY FOR RELATED CHANGES
**Record:** Part of v14 28-patch series (`v14_20260515_leo_yan_coresight
_refactor_power_management_for_coresight_path.mbx`). Patch 15 is
standalone in `coresight-core.c`; patch 16 (“Control path with range”)
builds on it but is not a prerequisite. Related sibling fixes: patch 1
(idr_alloc failure), patch 2 (helper enable unwind).

### Step 3.4: AUTHOR'S OTHER COMMITS
**Record:** Leo Yan authored the CoreSight path PM series; Reviewed-by
includes Arm/Linaro maintainers. Strong subsystem review signal.

### Step 3.5: DEPENDENT/PREREQUISITE COMMITS
**Record:** No hard dependency on later series patches. Applies to
current tree structure (`coresight_enable_path()` with `sink_data`
parameter). Standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:** Lore fetch blocked (Anubis bot protection). Used local mbox:
`v14_20260515_leo_yan_coresight_refactor_power_management_for_coresight_
path.mbx`. Patch 15/28 confirmed at lines 2131–2234. Series cover letter
describes patches 14–23 as path enable/disable refactor. No stable
nomination found in mbox grep.

### Step 4.2: WHO REVIEWED
**Record:** `b4 dig -c HEAD` failed (commit not in tree). From commit
message: Yeoreum Yun (Arm), James Clark (Linaro) reviewed; Jie Gan
(Qualcomm) and James Clark tested.

### Step 4.3: BUG REPORT
**Record:** No external bug report or syzbot link. Bug inferred from
code asymmetry and documented in existing kernel comment.

### Step 4.4: RELATED PATCHES / SERIES
**Record:** 28-patch series; this is patch 15. Patches 1–2 fix related
teardown bugs. Patch 15 does not require the CPU-PM refactor patches
(11–28) for correctness in the current tree.

### Step 4.5: STABLE MAILING LIST HISTORY
**Record:** No `Cc: stable` or stable-list discussion found in local
mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `coresight_disable_source()`,
`coresight_disable_path_from()`, `coresight_disable_path()`,
`coresight_enable_path()`, `coresight_disable_helpers()`

### Step 5.2: TRACE CALLERS
**Record:**
- `coresight_enable_path()` ← `coresight_enable_sysfs()` (`coresight-
  sysfs.c:218`), `etm_event_start()` (`coresight-etm-perf.c:531`)
- `coresight_disable_path()` ← `coresight_enable_sysfs()` error path
  (`:262`), `coresight_disable_sysfs()` (`:308`), `etm_event_start()`
  failure (`:563`), `etm_event_stop()` (`:724`)

**Buggy callers (disable_path without prior disable_source):**
- `coresight-sysfs.c:262` — `enable_path` succeeded,
  `enable_source_sysfs` failed
- `coresight-etm-perf.c:563` — `enable_path` succeeded,
  `source_ops->enable` failed

### Step 5.3: TRACE CALLEES
**Record:** `coresight_disable_helpers()` → `coresight_disable_helper()`
→ `helper_ops()->disable()`; affects CATU, CTI, CTCU helper devices
attached to sources.

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:** Reachable from sysfs writes (`enable_source_store`) and perf
events (`perf record` with CoreSight/ETM). Requires `CONFIG_CORESIGHT`
and ARM CoreSight hardware. Admin/capability-gated, not arbitrary
unprivileged userspace — but real on Qualcomm/Arm platforms.

### Step 5.5: SIMILAR PATTERNS
**Record:** Existing comment explicitly documents the enable/disable
imbalance; patch 2 in same series fixes partial helper enable unwind in
`coresight_enable_helpers()`.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST?
**Record:** **YES.** Local tree is **6.18.43** (`git describe`:
`v6.18.43-1-gc7f0dac02d232`). Current code at `coresight-core.c:433`
uses `list_for_each_entry_continue`; `coresight_disable_source()` at
`:393` still calls `coresight_disable_helpers(csdev, NULL)`. Imbalance
comment present at `:384–388`.

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** Patch hunks match current file
structure (verified `err_disable_path` at lines 561–565). Only
`coresight-core.c` touched.

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** Commit not in tree. Patch 1 (idr_alloc) and patch 2 (helper
enable unwind) also not present — separate issues; patch 15 is
independently valuable.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
**Record:** **PERIPHERAL** — `drivers/hwtracing/coresight/`, ARM
debug/trace infrastructure. Important for Arm/Android/embedded
developers, not universal.

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** Actively developed; large v14 refactor series in flight.
Helper support (CATU, CTI, CTCU) present in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** Users of CoreSight tracing on Arm SoCs (sysfs manual trace,
perf aux trace). Config-specific: `CONFIG_CORESIGHT`.

### Step 8.2: TRIGGER CONDITIONS
**Record:** Error paths during trace session setup — source enable fails
after path (and source helpers) were enabled. Uncommon but realistic
during misconfiguration or transient hardware errors. Not every boot;
not unprivileged.

### Step 8.3: FAILURE MODE SEVERITY
**Record:** Source helper devices (e.g., CATU) left enabled →
**resource/hardware state leak**, subsequent tracing sessions may fail
until reboot. **Severity: MEDIUM-HIGH** for affected subsystem (not
kernel panic, not data corruption, but functional breakage of tracing
and leaked hardware state).

### Step 8.4: RISK-BENEFIT
**Record:**
- **Benefit:** Fixes real teardown bug on error paths; aligns
  enable/disable symmetry; improves `enable_path()` rollback
  correctness.
- **Risk:** Very low — 27-line single-file change, reviewed by subsystem
  maintainers, in-tree callers verified safe.
- **Ratio:** Moderate benefit for Arm tracing users, very low risk →
  favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backport:**
- Real, documented bug (in-tree comment acknowledges imbalance)
- Leaves helper hardware enabled on error paths
- Small, surgical, single-file fix
- Reviewed by Arm/Linaro maintainers; tested on Qualcomm/Arm hardware
- Buggy code confirmed present in 6.18.43
- Clean apply expected
- Fixes `enable_path()` rollback semantics bug

**AGAINST backport:**
- Part of larger 28-patch refactor (but patch 15 is standalone)
- Error-path only, not normal teardown
- Peripheral subsystem, config-gated
- No syzbot/crash report
- No explicit stable nomination
- Medium severity, not crash/security/corruption

**Unresolved:** Full lore thread inaccessible; cannot verify maintainer
stable discussion.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic clear; multiple
   Tested-by/Reviewed-by
2. Fixes a real bug affecting users? **PASS** — error-path helper leak
   on Arm CoreSight
3. Important issue? **PASS (borderline)** — hardware state leak /
   tracing breakage, not crash/corruption
4. Small and contained? **PASS** — one file, ~27 lines
5. No new features/APIs? **PASS** — lifecycle bug fix only
6. Can apply to local tree? **PASS** — code present, patch matches

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: DECISION RATIONALE

This commit fixes a genuine enable/disable asymmetry in CoreSight path
management. On error rollback paths in `coresight_enable_sysfs()` and
`etm_event_start()` that call only `coresight_disable_path()`, source-
attached helper devices remain enabled because the disable path skipped
the source node. That can leave tracing hardware in a bad state and
break subsequent sessions. The fix is small, reviewed, applies cleanly
to 6.18.43, and does not depend on the rest of the v14 refactor series.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 1] Confirmed no Fixes:/Reported-by/syzbot; found Tested-
  by/Reviewed-by/Link
- [Phase 2] Read current `coresight-core.c` lines 352–566; confirmed
  pre-patch imbalance
- [Phase 2] Identified bug class: error-path helper/hardware state leak
- [Phase 3] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 3] `git rev-list --count HEAD` → 50 (shallow); limited history
- [Phase 3] `git blame` on `coresight_disable_source()` lines 390–394
- [Phase 3] Read `v14_20260515_leo_yan_coresight_refactor_power_manageme
  nt_for_coresight_path.mbx` patch 15 and cover letter
- [Phase 4] WebFetch lore URL → blocked by Anubis; used local mbox
  instead
- [Phase 4] `b4 dig -c HEAD` → wrong commit; `b4 dig` with message-id →
  unsupported without commit in tree
- [Phase 4] Grep mbox for “stable” → no matches
- [Phase 5] `grep coresight_disable_path(` → 4 call sites in coresight
  subsystem
- [Phase 5] `grep coresight_disable_source(` → sysfs.c:98, etm-
  perf.c:685 (both followed by `disable_path`)
- [Phase 5] `grep coresight_enable_path(` → sysfs.c:218, etm-perf.c:531
- [Phase 5] Read `coresight_enable_sysfs()` error path at lines 218–266
- [Phase 5] Read `etm_event_start()` failure path at lines 531–563
- [Phase 6] Confirmed `list_for_each_entry_continue` at line 433 (buggy
  code present)
- [Phase 6] Confirmed helper infrastructure (`coresight_is_helper`,
  CATU/CTI/CTCU) in tree
- [Phase 6] Verified patch 16 builds on patch 15 but is not required for
  standalone apply
- [Phase 8] Assessed severity as MEDIUM-HIGH for CoreSight users, not
  system-wide CRITICAL

**YES**

 drivers/hwtracing/coresight/coresight-core.c | 27 ++++++--------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 4cf4a3e92c272..d57000626c060 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -378,19 +378,12 @@ static void coresight_disable_helpers(struct coresight_device *csdev, void *data
 }
 
 /*
- * Helper function to call source_ops(csdev)->disable and also disable the
- * helpers.
- *
- * There is an imbalance between coresight_enable_path() and
- * coresight_disable_path(). Enabling also enables the source's helpers as part
- * of the path, but disabling always skips the first item in the path (which is
- * the source), so sources and their helpers don't get disabled as part of that
- * function and we need the extra step here.
+ * coresight_disable_source() only disables the source, but do nothing for
+ * the associated helpers, which are controlled as part of the path.
  */
 void coresight_disable_source(struct coresight_device *csdev, void *data)
 {
 	source_ops(csdev)->disable(csdev, data);
-	coresight_disable_helpers(csdev, NULL);
 }
 EXPORT_SYMBOL_GPL(coresight_disable_source);
 
@@ -417,9 +410,9 @@ int coresight_resume_source(struct coresight_device *csdev)
 EXPORT_SYMBOL_GPL(coresight_resume_source);
 
 /*
- * coresight_disable_path_from : Disable components in the given path beyond
- * @nd in the list. If @nd is NULL, all the components, except the SOURCE are
- * disabled.
+ * coresight_disable_path_from : Disable components in the given path starting
+ * from @nd in the list. If @nd is NULL, all the components, except the SOURCE
+ * are disabled.
  */
 static void coresight_disable_path_from(struct coresight_path *path,
 					struct coresight_node *nd)
@@ -430,7 +423,7 @@ static void coresight_disable_path_from(struct coresight_path *path,
 	if (!nd)
 		nd = list_first_entry(&path->path_list, struct coresight_node, link);
 
-	list_for_each_entry_continue(nd, &path->path_list, link) {
+	list_for_each_entry_from(nd, &path->path_list, link) {
 		csdev = nd->csdev;
 		type = csdev->type;
 
@@ -450,12 +443,6 @@ static void coresight_disable_path_from(struct coresight_path *path,
 			coresight_disable_sink(csdev);
 			break;
 		case CORESIGHT_DEV_TYPE_SOURCE:
-			/*
-			 * We skip the first node in the path assuming that it
-			 * is the source. So we don't expect a source device in
-			 * the middle of a path.
-			 */
-			WARN_ON(1);
 			break;
 		case CORESIGHT_DEV_TYPE_LINK:
 			parent = list_prev_entry(nd, link)->csdev;
@@ -561,6 +548,8 @@ int coresight_enable_path(struct coresight_path *path, enum cs_mode mode,
 err_disable_helpers:
 	coresight_disable_helpers(csdev, path);
 err_disable_path:
+	/* Fetch the previous node, the last successfully enabled one */
+	nd = list_next_entry(nd, link);
 	coresight_disable_path_from(path, nd);
 	goto out;
 }
-- 
2.53.0

