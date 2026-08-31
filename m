Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BA7598C1A;
	Mon, 31 Aug 2026 13:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184293; cv=none; b=UJC5DtNy2p9TUmdFsn3gqtOVej22ext6l9CtCAfQ0AEJZ9oiKmfO0Ev0npOc0jbH2xvbDsxjKxFrXnH1TjbVkeWmpVAFYs332vUl2Lfh8a4kD367J4HfsPYNZ4Q8ss17c/OrrMcWM7pxxZxPaoM4oxCQSLAmxhbG3uE1/68yYrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184293; c=relaxed/simple;
	bh=v5ZMJlOH1V+t6sk9VxXUjHBvPkc5a1+FmnY6EFcbhsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCDzF6lbnOPjwsZCCCVG1Efccte94VVHIshJQKRDXdQ3u1CJ+vLSSrvhA2AMBzM8grw+j1cX4sDQP77HjnYzUa0coMza/Uyc9bZMRjdnFXKYBdLuCxibZO6u+fBiDyUM9csgUW7gwxIfNUq1VPyryHrQvujyQNCV1vOcDcsJnLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6iDyMee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6iDyMee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB731F00ACA;
	Mon, 31 Aug 2026 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184291;
	bh=dh6MyRa0J41c0SieQ8P0Fr7mP2A3Cx+98hhwgUoyAdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6iDyMeejz2qgwNwqn1FfM0UUZQR2yTDlWWR1nAevra5l5pn1+5yO/pvzuyNtgwXY
	 UCDwM3SZRQMGCFUPoixJ4pbdoWjyGMpxr7ZK7uAyikNI47WwgRl7iPBxDwHQRPQ3eC
	 /JzOETHbYtAT8lle7hrOgyGCF0Zl8In79rbuMf/DLWWjg4wlfoEkc3h3+tYkB1oF5c
	 +XtpwUj/lQW4UMRJGQeDionjZNBRxiDhrE4NsH/DM3uCMrg3QHN4oE0WpDzK74VkZU
	 uSvadw02VSM8jOsdobtT4IKKswI1K8BUr115QoBdMhgSCKr2oHJbpHFsaijsC1jDJ4
	 OvrVORc8a6ycA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	robin.clark@oss.qualcomm.com,
	joro@8bytes.org,
	iommu@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iommu: arm-smmu-qcom: Ensure smmu is powered up in set_ttbr0_cfg
Date: Mon, 31 Aug 2026 09:30:33 -0400
Message-ID: <20260831133314.4125787-605-sashal@kernel.org>
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

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

[ Upstream commit 8a0aab012b52b5c044ca3bec523e91f95dd40765 ]

arm_smmu_write_context_bank() assumes it is being called with RPM
active, but it turns out that is not guaranteed in the path from
qcom_adreno_smmu_set_ttbr0_cfg(), so it's possible for the register
writes to get lost when configuring the context bank while the GPU is
idle, leading to page faults later.
Add the RPM calls here to make sure the SMMU is active before we touch
it.

Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Reviewed-by: Rob Clark <rob.clark@oss.qualcomm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `iommu: arm-smmu-qcom: Ensure smmu is
powered up in set_ttbr0_cfg`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)
**Mainline commit:** `8a0aab012b52` — **not yet merged** into this
checkout (`git merge-base --is-ancestor` → NOT_IN_TREE)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[iommu/arm-smmu-qcom]` `[ensure]` — Ensure the Qualcomm
Adreno SMMU is runtime-PM-active before writing context-bank registers
in `set_ttbr0_cfg`.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Anna Maniscalco, Will Deacon (ignore pipeline-added
SOBs) |
| Reviewed-by | Rob Clark `<rob.clark@oss.qualcomm.com>` (Qualcomm/msm
maintainer) |
| Reviewed-by | Robin Murphy `<robin.murphy@arm.com>` (ARM SMMU
maintainer) |
| Fixes: | **Absent** (expected for manual review) |
| Reported-by: | **Absent** |
| Cc: stable | **Absent** (expected) |
| Link: | **Absent** in final commit; v3 cover letter links v1/v2 on
lore |

Notable: dual Reviewed-by from GPU and IOMMU subsystem experts. No
syzbot report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `arm_smmu_write_context_bank()` assumes runtime PM (RPM) is
  active, but `qcom_adreno_smmu_set_ttbr0_cfg()` does not guarantee
  that.
- **Symptom:** Register writes are silently lost when the SMMU is
  powered down (GPU idle); later GPU accesses cause **IOMMU page
  faults**.
- **Root cause:** Missing `pm_runtime_resume_and_get()` /
  `pm_runtime_put_autosuspend()` around the hardware register write.
- **Version info:** None explicit; bug tied to runtime-PM-enabled Adreno
  SMMU path.

### Step 1.4: Hidden bug fix detection
**Record:** Not disguised — this is an explicit correctness bug fix. The
"ensure" verb and page-fault consequence clearly indicate a real
functional defect, not cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c` (+9 lines, 0
  removed)
- **Function modified:** `qcom_adreno_smmu_set_ttbr0_cfg()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| Variable | No `ret` | `int ret;` added |
| Before `arm_smmu_write_context_bank()` | Direct register write, no RPM
| `pm_runtime_resume_and_get()`; error → `-ENODEV` |
| After write | Immediate `return 0` | `pm_runtime_put_autosuspend()`
then `return 0` |

Affected path: both enable-TTBR0 (`pgtbl_cfg != NULL`) and disable-TTBR0
(`pgtbl_cfg == NULL`) branches, executed when the msm GPU driver
switches per-instance pagetables.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — hardware access without power domain
  active (runtime PM omission).
- **Mechanism:** When the Adreno GPU is idle, the SMMU can be
  autosuspended. `qcom_adreno_smmu_set_ttbr0_cfg()` updates in-memory
  `cb->tcr[0]` / `cb->ttbr[0]` then calls
  `arm_smmu_write_context_bank()` to push them to hardware. Without RPM
  resume, MMIO writes are dropped. Software state and hardware state
  diverge → GPU page faults on next use.

Sibling functions `qcom_adreno_smmu_set_prr_bit()` and
`qcom_adreno_smmu_set_prr_addr()` already use the identical RPM pattern
(added in `7f2ef1bfc758f`, Jan 2025). `set_ttbr0_cfg` was the omission.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — mirrors existing pattern in the same file
  at lines 158–169 and 178–188.
- **Minimal:** RPM acquired only around the single hardware write, per
  v2 review feedback.
- **Regression risk:** Very low. Same API used elsewhere; no new locks
  or data-structure changes.
- **Minor concern:** On RPM failure, in-memory `cb` state is already
  modified but hardware write is skipped. Pre-existing pattern (early
  returns on `-EINVAL` also leave divergent state); not introduced by
  this fix.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `qcom_adreno_smmu_set_ttbr0_cfg()` introduced entirely in
`5c7469c66f953` (Jordan Crouse, **2020-11-09**) — "Add implementation
for the adreno GPU SMMU". The RPM omission has existed since
introduction. Line 263 (`arm_smmu_write_context_bank` call) unchanged
since then.

### Step 3.2: Fixes: tag
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: Related file history
**Record:**
- `7f2ef1bfc758f` (Jan 2025): Added PRR callbacks with RPM — same
  omission left in `set_ttbr0_cfg`.
- `70892277ca2db` (May 2025): `set_stall` RPM handling when device is on
  — related runtime-PM theme.
- `0b4eeee2876f2` (Jul 2024): TBU driver registration;
  `pm_runtime_enable()` when `dev->pm_domain` is set.
- **Standalone:** Yes — single patch, v1→v2→v3 series converged on final
  minimal form. No other patches required.

### Step 3.4: Author context
**Record:** Anna Maniscalco has no other iommu commits in this tree. Fix
reviewed by Rob Clark (msm/Adreno) and Robin Murphy (arm-smmu core).

### Step 3.5: Dependencies
**Record:** No dependencies. Requires only code present in 6.18.y:
- `qcom_adreno_smmu_set_ttbr0_cfg` — present
- `pm_runtime_resume_and_get` / `pm_runtime_put_autosuspend` — used in
  same file
- `linux/pm_runtime.h` — already included (line 12)

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 8a0aab012b52`: matched patch-id to v2 thread
- **URL:** https://patch.msgid.link/20260325-qcom_smmu_pmfix-v2-1-
  ba769a6ad0be@gmail.com
- **Series (b4 dig -a):** v1 (2026-02-10), v2 (2026-03-25); committed
  version is v3 (2026-05-07)
- v3 changes: self-contained commit message, collected Reviewed-by tags
- v2 changes: narrowed RPM scope to just around
  `arm_smmu_write_context_bank()`
- **Stable nomination in thread:** Not found (lkml archive shows cover
  letter only, no reply thread with Cc: stable)
- **NAKs:** None found

### Step 4.2: Reviewers
**Record (b4 dig -w):** To: Rob Clark, Will Deacon, Robin Murphy, Joerg
Roedel. Cc: iommu@, linux-arm-msm@, linux-arm-kernel@, linux-kernel@.
Appropriate maintainer coverage.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or Bugzilla reference.
Bug identified through code analysis (RPM assumption violated). Failure
mode (page faults) is described in commit message.

### Step 4.4: Series context
**Record:** Standalone 1-patch fix. No companion patches needed.

### Step 4.5: Stable list history
**Record:** Not searched exhaustively (no stable-specific discussion
found in available sources). Absence of prior stable discussion is not a
negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `qcom_adreno_smmu_set_ttbr0_cfg()` (modified);
`arm_smmu_write_context_bank()` (callee).

### Step 5.2: Callers
**Record:** Called from `drivers/gpu/drm/msm/msm_iommu.c`:
1. **`msm_iommu_pagetable_create()`** (line ~582): first per-instance
   pagetable → enable TTBR0. Return value checked; failure aborts
   pagetable creation.
2. **`msm_iommu_pagetable_destroy()`** (line ~234): last pagetable
   destroyed → disable TTBR0. Return value **not** checked (pre-
   existing).

Registered via `priv->set_ttbr0_cfg` in `arm-smmu-qcom.c` line 351 for
`qcom,adreno-smmu` devices.

### Step 5.3: Callees
**Record:** `pm_runtime_resume_and_get()`,
`arm_smmu_write_context_bank()` (MMIO register writes to SMMU context
bank), `pm_runtime_put_autosuspend()`, `dev_err()`.

### Step 5.4: Reachability
**Record:**
- Triggered when userspace opens a GPU context requiring per-instance
  pagetables (common on Qualcomm Android/Chromebook devices).
- Especially when GPU was previously idle (SMMU autosuspended) — e.g.,
  launching an app after idle, or teardown after app exit.
- **Userspace-reachable:** Yes, via GPU ioctl/mmap paths in drm/msm.
- In `msm_iommu_pagetable_create()`, `set_ttbr0_cfg` runs **before**
  `set_prr_addr`/`set_prr_bit` (which do have RPM), confirming TTBR0
  writes can be lost even when subsequent PRR setup succeeds.

### Step 5.5: Similar patterns
**Record:** Identical RPM wrap in `qcom_adreno_smmu_set_prr_bit()` and
`qcom_adreno_smmu_set_prr_addr()`. `arm_smmu_destroy_domain_context()`
in `arm-smmu.c` uses `arm_smmu_rpm_get()` before
`arm_smmu_write_context_bank()`. This fix brings `set_ttbr0_cfg` in line
with established conventions.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `qcom_adreno_smmu_set_ttbr0_cfg()` at lines 227–265
in `arm-smmu-qcom.c` calls `arm_smmu_write_context_bank()` without any
RPM calls. Bug present since feature introduction (5.12+ era, commit
2020-11-09). Runtime PM enabled when `dev->pm_domain` is set (line
750–752).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** The function and surrounding code
are unchanged between this tree and mainline at the patch site. No
conflicting modifications in recent history of this function.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git merge-base --is-ancestor 8a0aab012b52 HEAD` →
NOT_IN_TREE. No grep hits for "powered up" or "qcom_smmu_pmfix" in this
tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/iommu** (ARM SMMU, Qualcomm variant) +
**drivers/gpu/drm/msm**. Criticality: **IMPORTANT** — affects GPU IOMMU
on widely deployed Qualcomm SoCs (sm8250, sm8350, sm8450, sm8550,
sm8650, etc., confirmed via DTS `qcom,adreno-smmu` compatibles).

### Step 7.2: Subsystem activity
**Record:** Actively maintained. Recent commits in `arm-smmu-qcom.c`
include fastrpc compatible fix, probe registration change, SMR group
handling (2025–2026).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Qualcomm Adreno GPUs with split pagetables
(`qcom,adreno-smmu`), primarily **arm64** Android phones, tablets, and
some Chromebooks running drm/msm with `CONFIG_ARM_SMMU` and
`CONFIG_DRM_MSM`.

### Step 8.2: Trigger conditions
**Record:**
- GPU idle long enough for SMMU runtime autosuspend.
- Application or kernel initiates per-instance pagetable create/destroy
  (TTBR0 enable/disable).
- **Likelihood:** Realistic on mobile (frequent idle/suspend cycles).
  Not every-boot, but common in production workloads.

### Step 8.3: Failure mode severity
**Record:** **IOMMU page faults** on GPU memory accesses → GPU faults,
application crashes, potential display freeze. Severity: **HIGH**
(functional failure of GPU subsystem; not a kernel panic but user-
visible and disruptive).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected Qualcomm platforms — prevents silent
  hardware misconfiguration.
- **Risk:** VERY LOW — 9-line addition matching proven pattern in same
  file.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes a real, reproducible-class bug (lost MMIO writes when SMMU
  suspended)
- Concrete user-visible failure: GPU page faults
- Small, surgical, obviously correct fix
- Reviewed by Rob Clark and Robin Murphy
- Bug present in this tree since 2020; not a mainline-only regression
- Matches established RPM pattern in sibling functions
- Standalone, no dependencies
- Clean apply to 6.18.43

**AGAINST backport:**
- Platform-specific (Qualcomm Adreno only) — mitigated: stable routinely
  takes targeted driver fixes
- No syzbot/user bug report — mitigated: clear technical analysis and
  expert review
- Intermittent (requires idle GPU) — mitigated: common on mobile devices

**Unresolved:** No independent user crash report verified; impact
inferred from code analysis and commit message.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors existing RPM
pattern; reviewed by subsystem maintainers |
| 2. Fixes real bug affecting users? | **PASS** — lost register writes →
GPU page faults |
| 3. Important issue? | **PASS** — HIGH severity GPU/IOMMU functional
failure |
| 4. Small and contained? | **PASS** — 9 lines, 1 file, 1 function |
| 5. No new features/APIs? | **PASS** — runtime PM only |
| 6. Can apply to local tree? | **PASS** — buggy code present; clean
apply expected |

### Step 9.3: Exception categories
**Record:** Hardware workaround / driver correctness fix for existing
Qualcomm Adreno SMMU hardware. Qualifies under stable driver bug-fix
norms.

### Step 9.4: Decision rationale
This commit closes a long-standing gap where
`qcom_adreno_smmu_set_ttbr0_cfg()` wrote SMMU context-bank registers
without ensuring runtime PM was active. On Qualcomm Adreno platforms in
this 6.18.y tree, that can silently drop TTBR0 configuration when the
GPU is idle, causing later IOMMU page faults. The fix is minimal,
follows an established pattern already used by `set_prr_bit` and
`set_prr_addr` in the same file, and has maintainer review. It meets all
stable kernel criteria for this tree.

---

## Verification

- [Phase 1] Parsed subject, tags (Reviewed-by: Rob Clark, Robin Murphy),
  body; no Fixes:/Reported-by:
- [Phase 2] Diff: +9 lines in `qcom_adreno_smmu_set_ttbr0_cfg()`, RPM
  wrap around `arm_smmu_write_context_bank()`
- [Phase 3] `git blame -L 227,265`: function from `5c7469c66f953`
  (2020-11-09); no RPM since introduction
- [Phase 3] `git log -S 'qcom_adreno_smmu_set_ttbr0_cfg'`: introduced in
  `5c7469c66f953`
- [Phase 3] `7f2ef1bfc758f`: PRR functions added with RPM pattern;
  `set_ttbr0_cfg` omitted
- [Phase 3] `70892277ca2db`: related RPM fix for `set_stall`
- [Phase 4] `b4 dig -c 8a0aab012b52`: found v2 thread at
  patch.msgid.link
- [Phase 4] `b4 dig -a`: v1 (Feb 2026), v2 (Mar 2026); committed as v3
  (May 2026)
- [Phase 4] `b4 dig -w`: maintainers CC'd (Rob Clark, Will Deacon, Robin
  Murphy, Joerg Roedel)
- [Phase 4] lkml.iu.edu v3 cover letter: confirms bug description and
  review tags; no stable nomination found
- [Phase 5] `grep set_ttbr0_cfg`: callers in `msm_iommu.c` lines 234,
  582; registration at `arm-smmu-qcom.c:351`
- [Phase 5] Read `msm_iommu_pagetable_create()`: `set_ttbr0_cfg` called
  before RPM-protected `set_prr_addr`/`set_prr_bit`
- [Phase 5] Read `qcom_adreno_smmu_set_prr_bit/addr`: identical RPM
  pattern confirmed
- [Phase 6] `git describe HEAD`: v6.18.43; `make kernelversion`: 6.18.43
- [Phase 6] Read `arm-smmu-qcom.c:227-265`: buggy code confirmed present
  (no RPM)
- [Phase 6] `git merge-base --is-ancestor 8a0aab012b52 HEAD`:
  NOT_IN_TREE
- [Phase 6] `git show 8a0aab012b52`: mainline commit exists and matches
  provided diff
- [Phase 7] DTS grep: `qcom,adreno-smmu` on
  sm8250/sm8350/sm8450/sm8550/sm8650
- [Phase 8] Failure mode: page faults on GPU access; severity HIGH for
  affected platforms

**YES**The background git searches finished and line up with the earlier
analysis:

- **Related history:** `qcom_adreno_smmu_set_ttbr0_cfg()` has been in
  the tree since 2020; sibling functions like
  `set_prr_bit`/`set_prr_addr` already use runtime PM, but this path was
  missed.
- **Author search:** Anna Maniscalco has drm/msm commits in this tree,
  but no iommu commits — this fix is her iommu contribution.
- **Fix presence:** No match for `set_ttbr0` or `qcom_smmu_pmfix` in
  this tree; mainline commit `8a0aab012b52` is not merged into 6.18.43.

**Verdict unchanged: YES** — worth backporting to this 6.18.y tree. It’s
a small, low-risk fix for a real Qualcomm Adreno GPU bug where TTBR0
register writes can be lost while the SMMU is runtime-suspended, causing
later GPU page faults.

 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 3b9fb1c71e5f9..f7cb7de80cfb9 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -231,6 +231,7 @@ static int qcom_adreno_smmu_set_ttbr0_cfg(const void *cookie,
 	struct io_pgtable *pgtable = io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops);
 	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
 	struct arm_smmu_cb *cb = &smmu_domain->smmu->cbs[cfg->cbndx];
+	int ret;
 
 	/* The domain must have split pagetables already enabled */
 	if (cb->tcr[0] & ARM_SMMU_TCR_EPD1)
@@ -260,8 +261,16 @@ static int qcom_adreno_smmu_set_ttbr0_cfg(const void *cookie,
 		cb->ttbr[0] |= FIELD_PREP(ARM_SMMU_TTBRn_ASID, cb->cfg->asid);
 	}
 
+	ret = pm_runtime_resume_and_get(smmu_domain->smmu->dev);
+	if (ret < 0) {
+		dev_err(smmu_domain->smmu->dev, "failed to get runtime PM: %d\n", ret);
+		return -ENODEV;
+	}
+
 	arm_smmu_write_context_bank(smmu_domain->smmu, cb->cfg->cbndx);
 
+	pm_runtime_put_autosuspend(smmu_domain->smmu->dev);
+
 	return 0;
 }
 
-- 
2.53.0

