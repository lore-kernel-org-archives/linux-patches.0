Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FABC526589;
	Mon, 19 Oct 2026 13:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418155; cv=none; b=IU7n+ZPOYqtHIrWiq4sJHrg6Vz7ZDjivZ915rLB8ybhNNO+I8c1Kasb8vAqlFwrbFQevMb/eFM2a/hhq5/17vSF4qlitGWn5AYE9Wx0R5gE4fKPTP+ApTTShb7Pv9DMg2vMtDq4jhlz6OvieaboFQA2Pz0vmLYQH0viNz4Fg5t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418155; c=relaxed/simple;
	bh=GpeGF23/0ndaKfPkCvfzSX3le+5Je4tMnJfZGoVzDLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gO7Rkf9FpAM0Z5OflWwijxyGSvC/X/F7cKLdWEHNOfPzu1uX6+Q0UbP5k0u/O9RQFjj1UHJgykFWbOW2wtAQwAIfnsL/WhtadWQydyK0jpab10gSsgIqIz0wVVjNr+HPxJq5Dh/Qd+UJXOURSE925RxFCBVDi3kRZc4BguVAaNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5yTfeLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5yTfeLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8281F000CA;
	Mon, 19 Oct 2026 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418152;
	bh=IXS7+Wu5B0w/k/V9X63id6/3DMYVdPBEmileCy/KlVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5yTfeLDE9mEasJfr1W6aDjROcDnkBP6nztI4Byqpu3rjo/kgE4ywGMBg8e4N6zMc
	 lQztElhAFG8V7m9JGBVmr2WWSlCEprTEAdc+zHm5XLFWL/ZSM1zYgD/7FSUyX9mor7
	 UaPerYDQKwml9u6MbBmm1J0xzt59+h2WLIzbvEYh8gU0ug5OZGnzPc+73iVa8C7pmk
	 zAhdrWSn8CMM66MKlvWHkD6SGdckShDQy+NBGXnP/Rjv2nPTtiNLwDiIPy9eeJpSMf
	 KeR+aZkioq6/E5h1aArc2uzeUsLLTolnNQnKo4QefT4AYG1FdES5QN3bAybu5KgAPY
	 T7GTooDRfaaAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	andersson@kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] remoteproc: core: Full attach detach during recovery
Date: Mon, 19 Oct 2026 09:45:40 -0400
Message-ID: <20261019135441.1420968-49-sashal@kernel.org>
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

From: Tanmay Shah <tanmay.shah@amd.com>

[ Upstream commit d93ffd549fb4df18c934ca7a47d4128a18c718cb ]

Current attach on recovery mechanism loads the clean resource table
during recovery, but doesn't re-allocate the resources. RPMsg
communication will fail after recovery due to this. Fix this
incorrect behavior by doing the full detach and attach of remote
processor during the recovery. This will load the clean resource table
and re-allocate all the resources, which will set up correct vring
information in the resource table.

Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Link: https://lore.kernel.org/r/20260630004806.3835488-2-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline). The buggy attach-on-recovery
path exists here (since v6.1), and the change is a small, real recovery-
path fix: after a remoteproc crash, RPMsg stays dead because vrings are
not reallocated.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [remoteproc/core] [fix disguised as “Full attach detach”] [do a
full detach+cleanup+attach on crash recovery so resources/vrings are
reallocated]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Tanmay Shah \<tanmay.shah@amd.com\> (author)
- Link:
  https://lore.kernel.org/r/20260630004806.3835488-2-tanmay.shah@amd.com
- Signed-off-by: Mathieu Poirier \<mathieu.poirier@linaro.org\>
  (remoteproc maintainer)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, or Cc:
  stable (absence of Fixes/Cc:stable is expected for this review)
- Message-ID numbering `...-2-...` shows this is patch 1/2 of a series
  (cover is -1, xlnx crash detection is -3)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: attach-on-recovery loads a clean resource table but does **not**
  re-allocate resources.
- Symptom: **RPMsg communication fails after recovery**.
- Root cause: `__rproc_attach()` only prepares/attaches/starts
  subdevices; it does not call `rproc_handle_resources()` /
  `rproc_alloc_registered_carveouts()`, so vring addresses in the
  resource table stay invalid (0xffffffff after reset).
- Failure mode: IPC to the coprocessor remains broken until Linux is
  rebooted, even though recovery “succeeded”.
- Version info: none in the message. Feature dates to v6.1
  (`ba194232edc03`).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: This is an explicit functional bug fix, not a disguised cleanup.
The extra teardown lines look like “cleanup” but they are the missing
half of `rproc_detach()` so `rproc_attach()` can rebuild vrings.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/remoteproc/remoteproc_core.c` (+14 / -1)
- Function: `rproc_attach_recovery()` only
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: Before: `__rproc_detach()` then `__rproc_attach()`. After:
`__rproc_detach()`, then the same teardown
`rproc_detach()`/`__rproc_shutdown()` already use
(`rproc_resource_cleanup`, `rproc_unprepare_device`,
`rproc_disable_iommu`, free `cached_table`), then `rproc_attach()` which
re-enables IOMMU, prepares the device, loads the resource table, handles
resources, allocates carveouts, and calls `__rproc_attach()`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Logic / correctness] Incomplete recovery left virtio/RPMsg
resources stale. Full resource teardown + `rproc_attach()` rebuilds
vrings. Not UAF/leak/race/overflow.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct: the new block is copied from `rproc_detach()`
/ `__rproc_shutdown()`. `rproc_attach()` is `static` in this file and
does **not** take `rproc->lock`, so calling it from
`rproc_trigger_recovery()` (which already holds the lock) is not a
deadlock. Regression risk is low-medium: recovery now unregisters virtio
devices and frees carveouts instead of only resetting subdevices; that
is the intended repair. No API/data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Buggy `rproc_attach_recovery()` introduced in `ba194232edc03`
(“remoteproc: Support attach recovery after rproc crash”, Peng Fan,
2022-09-28). First appears in **v6.1-rc1**. Present in this tree (`git
merge-base --is-ancestor ba194232edc03 HEAD` → yes).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The introducing commit is `ba194232edc03`
(verified by blame and `git show`). Enabled for hardware by
`6eed169c7fefd` (imx_rproc, i.MX8QM/QXP).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Standalone core fix. Same-series follow-up `5ae3dc0788746`
(“remoteproc: xlnx: Add crash detection mechanism”) is a **new xlnx
feature** and is **not** required for this core change. Later core
commits (`026a3fada4326`, crash/rproc_del races) do not revert or
rewrite this recovery path. Earlier attach error-path leak fixes
(`7692c9fbedd90`, `bcd241230fdbc`) already exist in this tree and make
`rproc_attach()` safer on failure.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Tanmay Shah is the AMD/Xilinx remoteproc contributor, not the
subsystem maintainer. Maintainer Mathieu Poirier merged it. Related work
is xlnx attach/detach and crash detection, not a pile of hidden core
prerequisites.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `rproc_attach()`, `rproc_resource_cleanup()`,
`rproc_unprepare_device()`, `rproc_disable_iommu()`, and
`rproc_attach_recovery()` — all present here. Can apply standalone. Does
**not** need series patch 2.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record: `b4 dig -c d93ffd549fb4d` →
https://patch.msgid.link/20260630004806.3835488-2-tanmay.shah@amd.com
Revisions: RFC (2025-10-02) → several v1–v4 shapes → v5 (2026-06-10) →
**v6 applied** (2026-06-29).
RFC review (Mathieu Poirier): do not mix `__rproc_detach` with
`rproc_attach`; resource-table reset already happens in detach. Author
replied that `__rproc_attach()` never calls `rproc_handle_resources()` /
`rproc_alloc_registered_carveouts()`, so vrings stay unset and RPMsg
cannot start. v3 tried public `rproc_detach()`+`rproc_boot()`
(lock/state mess). v5/v6 inlined `rproc_detach()`’s cleanup and called
`rproc_attach()` (no extra lock). Mathieu applied v6 with “Applied.” No
NAK on the committed version. No reviewer Cc:stable.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To/Cc: Bjorn Andersson, Mathieu Poirier, linux-remoteproc,
linux-kernel. Maintainer applied it. No extra Reviewed-by.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Author hit it on AMD-Xilinx attach-on-
recovery. Independent in-tree user: i.MX8QM/QXP
(`imx_rproc_partition_notify` → `rproc_report_crash()` on partition
reboot).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: v6 0/2 “remoteproc: xlnx: remote crash recovery”. Patch 2 adds
xlnx crash reporting via resource table + mailbox. This patch is self-
contained for existing `RPROC_FEAT_ATTACH_ON_RECOVERY` users.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable-list discussion of this subject found. UNVERIFIED:
lore.kernel.org HTTP fetch returned 403; used `b4 dig`, mbox, and
openwall instead.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `rproc_attach_recovery()`; callees added:
`rproc_resource_cleanup`, `rproc_unprepare_device`,
`rproc_disable_iommu`, `rproc_attach`.

Step 5.2: TRACE CALLERS
Record:
- `rproc_attach_recovery()` ← `rproc_trigger_recovery()` when
  `RPROC_FEAT_ATTACH_ON_RECOVERY` is set
- `rproc_trigger_recovery()` ← `rproc_crash_handler_work()` (automatic),
  sysfs `recovery`, debugfs recovery
- Feature set in `imx_rproc.c` (i.MX8QM/QXP, not Linux-owned core) and
  `xlnx_r5_remoteproc.c` (this series’ patch 2)

Step 5.3: TRACE CALLEES
Record: Teardown matches `rproc_detach()`. `rproc_attach()` does IOMMU,
prepare, `rproc_set_rsc_table`, `rproc_handle_resources`, carveouts,
`__rproc_attach`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable from userspace (sysfs/debugfs) and from hardware (i.MX
SCU reboot IRQ; xlnx mailbox crash report). Not a theoretical-only path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Boot recovery still uses `rproc_stop()` + `rproc_start()` and
keeps existing allocations; attach recovery must rebuild host-side
mappings because the remote rebooted itself. No sibling copy-paste bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Tree is **Linux 7.3.0-rc4** (`git describe HEAD` →
`v7.3-rc4-27-gf0100363d8c37`). `rproc_attach_recovery()` exists; bug
introduced v6.1. Pre-image of this commit is `__rproc_detach()` +
`__rproc_attach()`.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply on this tree: `rproc_attach()` is already a same-
file static helper; teardown helpers exist. Expected difficulty: clean
apply.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No earlier equivalent fix. This commit is the fix. `git merge-
base --is-ancestor d93ffd549fb4d HEAD` is true because this is mainline
that already merged it; that is not used as circular “already selected”
reasoning.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drivers/remoteproc] [IMPORTANT for SoCs with coprocessors using
RPMsg; not core mm/VFS]. Affects i.MX8QM/QXP and Xilinx R5 attach-on-
recovery.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature core with ongoing platform work. Attach-on-recovery
itself has been in place since v6.1, so this is a long-standing hole,
not a brand-new API.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver/config-specific: `CONFIG_REMOTEPROC` platforms with
`RPROC_FEAT_ATTACH_ON_RECOVERY` (i.MX8QM/QXP; Xilinx R5 after patch 2).
Not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Remote core crash/watchdog + recovery enabled. i.MX: SCU
partition reboot IRQ. Also sysfs/debugfs `recover`. Unprivileged users
typically cannot trigger unless debugfs/sysfs is exposed.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Host kernel does not oops. RPMsg/virtio IPC stays dead after
“successful” recovery until Linux reboot. Severity: **HIGH** for those
SoCs (recovery feature is non-functional), not CRITICAL host crash.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit: restores the documented attach-on-recovery path (real
i.MX and Xilinx users). Risk: ~15 lines, copies existing detach
teardown, no new lock. Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real user-visible bug: RPMsg fails after attach-on-recovery (author
  reproduced; mechanism verified in `__rproc_attach()` vs
  `rproc_attach()`).
- Bug in code since v6.1; i.MX8QM/QXP already uses the feature and
  reports crash on partition reboot.
- Small, surgical, mirrors `rproc_detach()` then `rproc_attach()`.
- No deadlock: `rproc_attach()` does not take `rproc->lock`.
- Maintainer applied v6 after RFC/v3 locking mistakes were dropped.
- No new APIs; standalone without series patch 2.

AGAINST:
- Not a host oops/UAF/security issue.
- Series also adds xlnx crash detection (feature); this patch is still a
  core correctness fix.
- Recovery path is not universal.
- Initial maintainer concern about mixing `__rproc_detach` and
  `rproc_attach`; committed form inlines detach cleanup instead of
  taking the public `rproc_detach()` lock/state path (the correct choice
  under `rproc_trigger_recovery()`’s mutex).

UNRESOLVED:
- lore.kernel.org HTTP 403; discussion recovered via b4/mbox/openwall.
- No public i.MX user report independent of the Xilinx series (code path
  still real).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — teardown copied from
   `rproc_detach()`; author tested RPMsg recovery; maintainer applied
   v6.
2. Fixes a real bug that affects users? **PASS** — attach-on-recovery
   leaves RPMsg dead; i.MX8 and Xilinx hit this path.
3. Important issue? **PASS** — recovery is supposed to restore IPC;
   without this, a coprocessor watchdog forces a Linux reboot. Not a
   host panic, but a serious functional break on those SoCs.
4. Small and contained? **PASS** — 15 lines, one function.
5. No new features or APIs? **PASS** — repairs existing recovery.
6. Can apply to the local tree? **PASS** — helpers and
   `rproc_attach_recovery()` exist in 7.3-rc4.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal small bug fix.

Step 9.4: MAKE YOUR DECISION
This tree has the attach-on-recovery bug. The patch is a small, verified
repair of that path. It should be backported here.

Verification:
- [Phase 1] Tags: author SOB, maintainer SOB, lore Link
  `20260630004806.3835488-2`; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +14/-1 in `rproc_attach_recovery()`; `__rproc_attach`
  → cleanup + `rproc_attach`
- [Phase 2] Confirmed `rproc_attach()` is static and does not take
  `rproc->lock` (no deadlock with `rproc_trigger_recovery()`)
- [Phase 2] Cleanup matches `rproc_detach()` / `__rproc_shutdown()` in
  the same file
- [Phase 3] `git blame`: buggy function from `ba194232edc03` (v6.1-rc1)
- [Phase 3] `git merge-base --is-ancestor ba194232edc03 HEAD` → 0
  (present)
- [Phase 3] imx enable: `6eed169c7fefd`; crash trigger:
  `imx_rproc_partition_notify()` → `rproc_report_crash()`
- [Phase 3] Series patch 2 `5ae3dc0788746` is xlnx crash detection, not
  a prerequisite
- [Phase 4] `b4 dig -c d93ffd549fb4d`: msgid.link for v6 1/2; `-a`
  RFC→v6; `-w` Andersson/Poirier/linux-remoteproc
- [Phase 4] mbox: Mathieu “Applied.” on v6; RFC explained missing
  `rproc_handle_resources()`
- [Phase 4] lore.kernel.org fetch: 403; used b4/openwall
- [Phase 4] stable list search: no discussion of this patch
- [Phase 5] Callers: crash work, sysfs, debugfs
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 8] Failure mode: RPMsg dead after recovery, not host oops
- UNVERIFIED: full lore HTML thread (403); no independent public i.MX
  bugzilla report

**YES**

 drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index bbc781e41a1b8..2336c55eb021d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1784,7 +1784,20 @@ static int rproc_attach_recovery(struct rproc *rproc)
 	if (ret)
 		return ret;
 
-	return __rproc_attach(rproc);
+	/* clean up all acquired resources */
+	rproc_resource_cleanup(rproc);
+
+	/* release HW resources if needed */
+	rproc_unprepare_device(rproc);
+
+	rproc_disable_iommu(rproc);
+
+	/* Free the copy of the resource table */
+	kfree(rproc->cached_table);
+	rproc->cached_table = NULL;
+	rproc->table_ptr = NULL;
+
+	return rproc_attach(rproc);
 }
 
 static int rproc_boot_recovery(struct rproc *rproc)
-- 
2.53.0

