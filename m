Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF64527FB1;
	Mon, 19 Oct 2026 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418574; cv=none; b=qyPWc/8Y3bn/LYQmQm8H94dburBBvNjoEcBSLO7I6FJ0eclN6cjckoztKaoIKiwFPyO33Q0Uay73UOK04LhNvD4hprV3VbLem0OCK4qsS3NQ+IPi6vsZC4JD9rinjacfvE3s4wkbgd8TpBAZjj11O9EGhcARqxtF/Lf1bfSFCCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418574; c=relaxed/simple;
	bh=+1ZWmQmS7jC1pco+Ozx6kg7JXui4zpUeJ0lalaES/0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QKNcRLJ6DsCnzu0nNrfl9u6WZFzGABXj6sBiDOTvzl5VxUxL3OxUEZdjE8osTcaGhLnzwP3wKMFEed+m7JZOEiuU9GSD85cV4MqsLjtaaOeiwB4OjuRaE0h2E4sltSmeWZqup7Qut6M3lPy/fzVxI3WwaSct2BaOSrGx+b8DYdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqXoXndN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqXoXndN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F86A1F000C4;
	Mon, 19 Oct 2026 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418571;
	bh=kvnjUFG/xYwm+NO+qD6stlC04XHUVrYTPecZAg78TVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqXoXndNKnS8fnPbfriMzHZ+67xbnT+aM4apZ4mCSmVhejV08Btca1t0aLb/BzPK8
	 MKkfNKtn+BJh2P5re4b/Q2WSKc/jsYWbzZwXlmYtTwyjHE1QXMKJU2e1EaeMcUYfHd
	 XDp39gUf+Alh8xwIVxGgrZ8f8iCRSNvRFzsxXZGxV65F7+NavVTPsTDelD2XxOrFIU
	 4J2W42vFcqaTDRUK9sc6syMq0vd+PGhws6I78Ipc8KfUPvtd1F9Fsan3BMeSQ4qDRm
	 4GBQWhxWqxr4rY0gwtI+9q97fRyG8qqe2QmOgmmh5CBQF61ExTPQMlw8HUYtPRjEY1
	 wCvnSpb3Zy30g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	robin.clark@oss.qualcomm.com,
	joro@8bytes.org,
	iommu@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iommu/qcom: Check pm_runtime_resume_and_get() return in probe
Date: Mon, 19 Oct 2026 09:50:33 -0400
Message-ID: <20261019135441.1420968-342-sashal@kernel.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit e910315ae08a23bc953daed10b1c518abac1df49 ]

The SMMU_INTR_SEL_NS register write in qcom_iommu_device_probe() uses
pm_runtime_get_sync() without checking the return value. If runtime
resume fails the subsequent writel_relaxed() would access hardware with
clocks potentially disabled.

Switch to pm_runtime_resume_and_get() which handles the usage-count
cleanup on failure, check the return value, and unwind the already
registered iommu device on error.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the tree version, the probe path, series context, and review
thread. Compiling the nine-phase analysis and verdict next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[iommu/qcom]** **[Check]** Check `pm_runtime_resume_and_get()`
return in probe. “Check” here is a missing-error-handling fix, not a
feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reviewed-by:** Konrad Dybcio \<konrad.dybcio@oss.qualcomm.com\>
  (Qualcomm reviewer)
- **Signed-off-by:** Mukesh Ojha \<mukesh.ojha@oss.qualcomm.com\>
  (author)
- **Signed-off-by:** Will Deacon \<will@kernel.org\> (IOMMU/SMMU
  maintainer who applied it)
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Link / Acked-by**
- Ignore any pipeline “Signed-off-by: Sasha Levin” / “[Upstream commit
  …]” markers (none in the real commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `qcom_iommu_device_probe()` does `pm_runtime_get_sync()` then
  `writel_relaxed()` to `SMMU_INTR_SEL_NS` without checking the PM call.
- **Symptom:** If runtime resume fails, MMIO is written with clocks
  possibly off. On Qualcomm that can hang the interconnect / SError, and
  probe still returns success so interrupt routing may be wrong.
- **Root cause:** ignored `pm_runtime_get_sync()` return; that API also
  leaves the usage count up on failure (the new API drops it).
- **Fix:** `pm_runtime_resume_and_get()`, check `ret`, unwind
  `iommu_device_unregister` + existing sysfs remove.
- **Version info:** none in the message. Code dates to the original
  driver (v4.14).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. Explicit error-path / unclocked-access fix. The
“usage-count cleanup” wording is slightly overstated at this site
because the old code always called `pm_runtime_put_sync()` after the
write; the real bugs are the unclocked `writel` and probe succeeding
after a failed resume.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/iommu/arm/arm-smmu/qcom_iommu.c` (+5 / −1)
- Function: `qcom_iommu_device_probe()`
- Scope: single-file surgical probe error path

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: Before (only when `qcom_iommu->local_base` is set):
`pm_runtime_get_sync` → always `writel_relaxed(0xffffffff, local_base +
SMMU_INTR_SEL_NS)` → `pm_runtime_put_sync` → return 0. After:
`pm_runtime_resume_and_get`; on failure `goto err_iommu_unregister`
(unregister IOMMU, remove sysfs, return error); on success same write +
put as before.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** (a) error-path unwind + (g) missing return check, which
  prevents unclocked MMIO.
- **Mechanism:** `qcom_iommu_resume()` enables iface/bus/tbu clocks via
  `clk_bulk_prepare_enable()`. If that (or SCM restore) fails, the old
  path still wrote `SMMU_INTR_SEL_NS`. Switch to
  `pm_runtime_resume_and_get()` is required: `pm_runtime_get_sync()` can
  return `1` (already active), so `if (ret)` on get_sync would mis-
  handle success.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Minimal and correct. `pm_runtime_resume_and_get()` returns 0 or
negative (`include/linux/pm_runtime.h`). Unwind matches
`qcom_iommu_device_remove()`. Regression risk is low: only the RPM-
failure path starts failing probe instead of succeeding after a possibly
unclocked write. If clocks cannot be enabled, failing probe is the right
outcome.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: The `if (qcom_iommu->local_base)` write was added in
**0ae349a0f33fb0** (“iommu/qcom: Add qcom_iommu”, Rob Clark,
2017-08-09), first in **v4.14-rc1**. Present in this tree (`git merge-
base --is-ancestor 0ae349a0f33fb0 HEAD`). Long-lived bug, not new code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. Buggy code is the original 2017 driver, not a
recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Same-day IOMMU pull (Will Deacon, 2026-07-22):
- `c579f18e79599` — adds `err_sysfs_remove` (**soft prerequisite** for
  the new goto)
- `bf69e515b1802` — `devm_pm_runtime_enable()` (series 2/6; changes
  nearby error labels)
- **`e910315ae08a2`** — this commit (series 3/6)
- Later 4/6–6/6 are other bugs in the same file, not needed for this
  hunk

Standalone for the probe RPM check, but the hunk assumes
`err_sysfs_remove` exists. That label is in this tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Mukesh Ojha (Qualcomm) sent the “iommu/qcom: Misc Fixes” series.
Not the file’s listed maintainer (Rob Clark); Konrad reviewed, Will
applied. Related author commits on this file are the rest of that
series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `err_sysfs_remove` from `c579f18e79599` (cover letter:
series sits on Haoxiang Li’s sysfs cleanup).
`pm_runtime_resume_and_get()` exists in this tree. Can apply standalone
**on this checkout**. Does not need 4/6–6/6.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:** v2 3/6, https://patch.msgid.link/20260717144608.3216274-4-
  mukesh.ojha@oss.qualcomm.com
- **Revisions:** v1 3/8 (2026-06-23) → v2 3/6 (2026-07-17). Same hunk;
  v1 still had `err_pm_disable` (removed by 2/6).
- Konrad R-b on v1 with no requested changes: Message-ID
  `f636b144-807f-4a10-bf44-d06b169fce21@oss.qualcomm.com`
- Will applied the whole v2 series 2026-07-22; no NAKs
- No reviewer asked for Cc: stable

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc included Rob Clark, Will Deacon, Joerg Roedel, Robin
Murphy, `iommu@lists.linux.dev`, `linux-arm-msm`. Konrad R-b; Will
merged.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by, syzbot, or bugzilla. Author analysis of the
error path, not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Cover: “[PATCH v2 0/6] iommu/qcom: Misc Fixes”. Independent
fixes in one file. This patch does not need 4/6 (pgtbl leak), 5/6 (mutex
publish), or 6/6 (ctx_probe clocks). 2/6 only shifts nearby labels.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: gnuweeb `/stable/?q=qcom_iommu+pm_runtime_resume_and_get` had no
discussion of this fix. Not previously rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `qcom_iommu_device_probe()`; new label `err_iommu_unregister`
calling `iommu_device_unregister()`.

**Step 5.2: TRACE CALLERS**

Record: `.probe = qcom_iommu_device_probe` on `qcom-iommu`. Triggered by
DT `qcom,msm-iommu-v1` / `v2` during boot (or bind). Not a syscall.
`local_base` is optional (first MEM resource); the RPM get/write runs
only if that resource exists.

**Step 5.3: TRACE CALLEES**

Record: `pm_runtime_resume_and_get` → `qcom_iommu_resume` →
`clk_bulk_prepare_enable` and possibly `qcom_scm_restore_sec_cfg`. Then
`writel_relaxed` to `SMMU_INTR_SEL_NS` (0x2000), `pm_runtime_put_sync`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Boot/device probe on MSM8916-class SoCs. Unprivileged users can
rebind if they can unbind the driver; typical trigger is boot. Path is
real on those boards.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same file still uses unchecked `pm_runtime_get_sync` in
`domain_free`, `attach_dev`, `identity_attach`, `unmap`,
`flush_iotlb_all`. Comments there already warn about unclocked TLB
access. This commit only fixes probe. Sibling 6/6 adds a checked resume
around ctx-bank FSR access.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Local tree is **v7.3-rc4** (`git describe HEAD` =
`v7.3-rc4-27-gf0100363d8c37`, `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
EXTRAVERSION=-rc4`). Driver is present. The unclocked-write pattern
existed here from v4.14 until `e910315ae08a2`. HEAD already has the
fixed form in `qcom_iommu_device_probe()` (lines 866–880). Evaluation is
technical merit for this tree’s code, not “already landed.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree: `err_sysfs_remove` and
`devm_pm_runtime_enable` are present. Hunk matches current/pre-fix
context.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No alternate fix for this probe RPM check. Sysfs unwind
(`c579f18e79599`) is here and is what this goto chains into.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **IOMMU / Qualcomm legacy SMMU** (`drivers/iommu/arm/arm-
smmu/qcom_iommu.c`). **IMPORTANT** for MSM8916/8917/8937/8939/8953/8976
(DT still uses `qcom,msm-iommu-v1`). Not core MM/VFS; IOMMU failures
break DMA/display/modem on those SoCs.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature “legacy qcom_iommu” (author’s words). Occasional
correctness fixes in 2026, not heavy churn. Long-lived bug, more
relevant for stable.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver/platform-specific**, `CONFIG_QCOM_IOMMU`, older
Qualcomm ARM64 boards listed above. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Probe, and only if `local_base` is mapped **and** runtime resume
fails (`clk_bulk_prepare_enable` or SCM restore). Uncommon on healthy
hardware; realistic on clock/GDSC/SCM failure. Not a normal userspace
trigger.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Unclocked MMIO → possible **bus hang / SError** (**HIGH** if it
fires). Otherwise probe succeeds with `SMMU_INTR_SEL_NS` not programmed
(**MEDIUM** functional). Trigger rarity → overall **MEDIUM–HIGH**, still
a real hang class, not cosmetic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Avoid hang/abort and false-successful probe when clocks
  cannot come up; fail cleanly and unwind registration.
- **Risk:** Very low (6-line error path, reviewed, standard API).
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real unclocked MMIO on a documented-sensitive Qualcomm path
- Small (+5/−1), obviously correct
- `pm_runtime_resume_and_get` is the right API (get_sync’s `1` is
  success)
- Konrad R-b, Will merged; no NAKs
- Driver in this tree since v4.14; DT still ships for several SoCs
- Same-file comments treat unclocked access as a real hang risk
- Prerequisites (`err_sysfs_remove`, `pm_runtime_resume_and_get`) are in
  this tree
- Matches stable’s “oops, hang, … or some ‘oh, that’s not good’ issue”

**AGAINST:**
- No user/syzbot report; error path is uncommon
- Series patch 3/6 (but functionally independent)
- Other `get_sync` sites in the file remain unchecked
- Usage-count leak at this site was already balanced by `put_sync`

**UNRESOLVED:** lore.kernel.org HTTP 403; discussion recovered via `b4
dig` mbox, gnuweeb, and openwall. No evidence of a field crash, only
code-path analysis.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — API contract matches;
   maintainer applied after R-b
2. Fixes a real bug that affects users? **PASS** — unclocked write and
   successful probe after failed resume on shipped MSM8916-class IOMMU
3. Important issue? **PASS** — hang/SError class; trigger is rare but
   severity is not “trivial”
4. Small and contained? **PASS** — 6 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code and labels exist here

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk table, DT, build, or doc fix).
Qualifies as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**

This is a small, reviewed probe-path fix that stops a `writel` to SMMU
MMIO when runtime resume (clocks) has failed, and fails probe instead of
continuing. That is a real stability bug on a still-used Qualcomm IOMMU,
the change is contained, and this checkout has the driver plus the sysfs
unwind label the hunk uses. Benefit outweighs risk.

---

### What the commit solves for this tree

`qcom_iommu_device_probe()` programmed `SMMU_INTR_SEL_NS` after
`pm_runtime_get_sync()` with no check. Resume enables the IOMMU clocks;
on failure the write can hit unclocked hardware (hang/SError) and probe
still returned 0. The fix uses `pm_runtime_resume_and_get()`, returns
the error, and unregisters the IOMMU device.

It meets stable rules: obviously correct, real hang-class bug, ~6 lines,
no new API. Risk is confined to the already-broken clock-failure path.

---

### Verification

- **[Phase 1]** Parsed `e910315ae08a2`: R-b Konrad Dybcio; SOB Mukesh
  Ojha, Will Deacon; no Fixes/Reported-by/stable Cc
- **[Phase 2]** Diff: +5/−1 in `qcom_iommu_device_probe()`;
  `pm_runtime_get_sync` → checked `pm_runtime_resume_and_get` +
  `err_iommu_unregister`
- **[Phase 2]** Confirmed `pm_runtime_resume_and_get()` returns 0 or
  negative (`include/linux/pm_runtime.h`); `get_sync` may return 1
- **[Phase 2]** Confirmed resume path: `qcom_iommu_resume()` →
  `clk_bulk_prepare_enable()`
- **[Phase 3]** Blame: write from `0ae349a0f33fb0` (v4.14-rc1); `merge-
  base --is-ancestor` true
- **[Phase 3]** `c579f18e79599` and `bf69e515b1802` are ancestors of
  HEAD
- **[Phase 4]** `b4 dig -c e910315ae08a2`: v2 3/6 of “Misc Fixes”; v1
  3/8 same hunk
- **[Phase 4]** `b4 dig -a/-w/-m`: Konrad R-b, Will applied 1/6–6/6;
  recipients were IOMMU/QCOM lists; no NAK
- **[Phase 4]** Stable-list search: no prior discussion of this fix
- **[Phase 5]** Probe is platform driver for `qcom,msm-iommu-v1/v2`; DT
  hits in msm8916/8917/8937/8939/8953/8976
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  Makefile 7.3.0-rc4; driver present; hunk matches
- **[Phase 8]** Failure mode: unclocked MMIO hang/SError if RPM resume
  fails at probe; severity HIGH if hit, trigger uncommon
- **UNVERIFIED:** lore.kernel.org 403 (mbox/mirrors used instead); no
  field reproducer found

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 9bee85259c69e..fbe4bd3ec0c42 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -863,13 +863,17 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	}
 
 	if (qcom_iommu->local_base) {
-		pm_runtime_get_sync(dev);
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret)
+			goto err_iommu_unregister;
 		writel_relaxed(0xffffffff, qcom_iommu->local_base + SMMU_INTR_SEL_NS);
 		pm_runtime_put_sync(dev);
 	}
 
 	return 0;
 
+err_iommu_unregister:
+	iommu_device_unregister(&qcom_iommu->iommu);
 err_sysfs_remove:
 	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
-- 
2.53.0

