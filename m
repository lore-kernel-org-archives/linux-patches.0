Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD5E50CBBD;
	Mon, 19 Oct 2026 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418185; cv=none; b=Jt+VCYIPj/ObTvHDWsP2t9ioVTS0UhXjb9MxBU1+zIyyO4zEVU5VG326PA74BmDEdRU7F8G51nXnEPOHUahr1DOJlQLTRpodIC9+MG8rMBFGd9JC5Ag1pYGc2xubvPjW9zC8Bzd9dQOLtNyJPyAOlZk+ZtdYzCIAyQUU00R3b/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418185; c=relaxed/simple;
	bh=oRSgi9m6tNVev+RV35gtRhQDlaLVGxMlbKfvGN9Gn2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D89ACGoWyKS6XNsZUHgBsd6cnOUXLFot36C4b3N+M360+7+b6fLuBvaHdhW7IZNnObModDt3hf8SR+6oQUMwbbiROEMbT51xt1oB4LC4l8zAZPukS9694LqDL7S50yxhwOof+RP2NSKVsk54F270fIRSw95hHv6kzOXVBPoIoRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJCvPCYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJCvPCYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141EF1F000C9;
	Mon, 19 Oct 2026 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418183;
	bh=AFyxxzpR/USn3B7USGX27xITd1JY7TPKw3RoZo3vEug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJCvPCYV9mP8qRS1uAwB0NB5Z5VLEjbyOhid1CGqDf8RWOgyOW4Dd/IGaw3hoJgqT
	 zYjMmWuhgIA6kXIRncph2WV7iVIIyQczQA4mlTtfkHL8rHTT0X9Mv0bXZm7QGuSgwN
	 yvpKRBXA4iL41/wXXSVxEWPIABAPKTb2n0VAuBuuJGgJ28oiqWzRNBd4N2RqAOZB6w
	 lfwTBzvSKArUguTpCjzWtXAccq4izJ2DtjnITzwcSfQvJYehDi+59p0IaLDEJFV2e2
	 nki9ZHZHU6IQS+L1lPoumQBOI/jvanT3iL5Rt0sRm9M9EmiQZYxk4XVoOpqUpJb6gD
	 0DL7D+LvFM8yw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] iommu/qcom: Publish pgtbl_ops before releasing init_mutex
Date: Mon, 19 Oct 2026 09:46:02 -0400
Message-ID: <20261019135441.1420968-71-sashal@kernel.org>
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

[ Upstream commit a05b67cd45ad09a19f41b2d37255da714512e0ca ]

qcom_domain->pgtbl_ops was assigned after mutex_unlock(). Another thread
calling qcom_iommu_init_domain() would see qcom_domain->iommu already set
(domain fully initialized) and skip re-initialization under the mutex.
If it then called qcom_iommu_map() before the first thread set pgtbl_ops,
it would observe a NULL ops pointer and return -ENODEV for valid mappings.

Move the assignment to before mutex_unlock() so that once the mutex is
released the domain is fully visible to concurrent operations.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3-rc4** (mainline). The driver is present, the
race is real, and the fix is a five-line lock-ordering correction. Below
is the full nine-phase review.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[iommu/qcom] [Publish] Publish pgtbl_ops before releasing
init_mutex`
Subsystem: Qualcomm IOMMU (`drivers/iommu/arm/arm-smmu/qcom_iommu.c`).
Verb “Publish … before” is a visibility/ordering fix (equivalent to
“ensure” / “prevent”).

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>`
- `Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>` (author)
- `Signed-off-by: Will Deacon <will@kernel.org>` (IOMMU/SMMU maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable`
  (absence expected; not a negative)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `qcom_domain->pgtbl_ops` was stored after
  `mutex_unlock(&init_mutex)`.
- **Symptom:** A concurrent `qcom_iommu_init_domain()` sees
  `qcom_domain->iommu` already set, skips init, then `qcom_iommu_map()`
  reads a NULL ops pointer and returns `-ENODEV` for valid mappings.
- **Root cause:** The “domain initialized” flag (`iommu`) is published
  under the mutex; page-table ops are published after the mutex is
  dropped, so the domain is only half-visible.
- **Version info:** None in the message. Blame shows the unlock-then-
  assign pattern dates to the original driver (2017).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit race with a concrete failure (`-ENODEV`
on map). Not cleanup/refactor.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/iommu/arm/arm-smmu/qcom_iommu.c` — 2 insertions, 3
  deletions
- Function: `qcom_iommu_init_domain()`
- Scope: single-file surgical reorder of three statements

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
**Before:** program context banks → `mutex_unlock(init_mutex)` →
`pgtbl_ops = …` → `return 0`.
**After:** program context banks → `pgtbl_ops = …` →
`mutex_unlock(init_mutex)` → `return 0`.
Error paths (`out_clear_iommu` / `out_unlock`) are unchanged. This is
the success-path publication of domain state.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Synchronization / race]**.
`qcom_domain->iommu` is set near the start of init (under the mutex) and
is the “already initialized” flag:

```227:229:drivers/iommu/arm/arm-smmu/qcom_iommu.c
        mutex_lock(&qcom_domain->init_mutex);
        if (qcom_domain->iommu)
                goto out_unlock;
```

`qcom_iommu_map()` does not take `init_mutex`; it only checks
`pgtbl_ops`:

```436:439:drivers/iommu/arm/arm-smmu/qcom_iommu.c
        struct io_pgtable_ops *ops = qcom_domain->pgtbl_ops;

        if (!ops)
                return -ENODEV;
```

Unlocking before the store lets another attach skip init and then map
with a NULL ops pointer. The fix publishes ops while still holding the
mutex so that once waiters proceed, the domain is fully usable.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct publish-under-lock. Minimal. No new locks,
APIs, or control flow besides statement order. Regression risk is very
low: the assignment is a plain pointer store of a fully constructed
object; holding the mutex a few extra instructions does not create
deadlock (map/unmap use `pgtbl_lock`, not `init_mutex`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Unlock-then-assign was introduced in `0ae349a0f33fb`
(“iommu/qcom: Add qcom_iommu”, Rob Clark, 2017-08-09), first in
**v4.14-rc1**. The bug is ~9 years old in this driver, not a recent
regression.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy code is the original 2017 driver, which
is an ancestor of this tree.

**Step 3.3: CHECK FILE HISTORY**
Record: Same-day series from Mukesh Ojha (applied 2026-07-22 by Will
Deacon):
- `3c748a5554f96` — leak of `pgtbl_ops` on error (patch 4/6)
- `a05b67cd45ad0` — this commit (patch 5/6)
- `cb776a03a5342` — clocks before ctx probe (patch 6/6)

This patch only reorders unlock vs assignment. It does **not** depend on
the leak fix.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Mukesh Ojha (Qualcomm) submitted a “Misc Fixes” series for the
legacy qcom_iommu driver. Not the IOMMU subsystem maintainer; Will
Deacon applied it. Konrad Dybcio (Qualcomm) reviewed.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. v2 series is 6 patches; this one has no code
dependency on the others. Can apply alone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore (from `b4 dig -c a05b67cd45ad0`): https://patch.msgid.link/202607
  17144608.3216274-6-mukesh.ojha@oss.qualcomm.com
- **v1:** `[PATCH 5/8]` 2026-06-23 — https://patch.msgid.link/2026062312
  2034.1166295-6-mukesh.ojha@oss.qualcomm.com
- **v2:** `[PATCH v2 5/6]` 2026-07-17 (applied version; same diff as v1
  for this patch)
- Konrad on v1: `Reviewed-by` plus a non-blocking note that a
  `guard(mutex)` wrapper would also work. No NAK.
- Will Deacon applied the whole v2 series to `iommu (arm/smmu/updates)`
  on 2026-07-22. No stable nomination, no risk flags.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Mukesh Ojha, Rob Clark, Will Deacon, Joerg Roedel,
Alex Williamson, Robin Murphy, Konrad Dybcio; lists
`iommu@lists.linux.dev`, `linux-arm-msm`, `linux-arm-kernel`.
Appropriate maintainers were on Cc. Konrad reviewed; Will applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, syzbot, or bugzilla. Author analysis only.
UNVERIFIED whether anyone hit this in the field.

**Step 4.4: RELATED PATCHES AND SERIES**
Record: Part of “iommu/qcom: Misc Fixes”. Other patches (fault-log
polarity, pm_runtime, leak, clocks) are independent. v1 patches 6/8 and
8/8 were dropped after review; this patch was unchanged.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search for `pgtbl_ops qcom` did not show
this patch. Hits were unrelated (`arm-smmu-qcom` power-up). No evidence
it was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `qcom_iommu_init_domain()` (modified). Related:
`qcom_iommu_attach_dev()`, `qcom_iommu_map()`, `qcom_iommu_unmap()`,
`qcom_iommu_iova_to_phys()`.

**Step 5.2: TRACE CALLERS**
Record:
- `qcom_iommu_init_domain()` is only called from
  `qcom_iommu_attach_dev()`.
- `attach_dev` is the IOMMU `.attach_dev` op
  (`qcom_iommu_ops.default_domain_ops`).
- Core path: `__iommu_attach_device()` → `domain->ops->attach_dev()`.
- This driver `select ARM_DMA_USE_IOMMU`. `arm_iommu_attach_device()`
  documents that more than one client may share a mapping, and calls
  `iommu_attach_device()`. Parallel probe of two devices sharing a
  mapping is a realistic concurrent `init_domain` on the same
  `qcom_domain`. Group mutex serializes attach **within** a group;
  `generic_device_group` means one device per group, so two devices are
  two groups and are **not** serialized against each other.

**Step 5.3: TRACE CALLEES**
Record: `alloc_io_pgtable_ops()`, `qcom_scm_restore_sec_cfg()`, context-
bank MMIO, `mutex_lock/unlock`. SCM and register programming make the
critical section long; waiters pile up on `init_mutex` and then race the
post-unlock store.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from device probe / DMA attach on Qualcomm “B family”
SMMU platforms (MSM8916/8937/8939/8953/8976, etc.). Not a syscall fuzzer
path; it is a normal boot/probe path. Userspace-triggered concurrent
attach is also possible via the ARM DMA mapping API / VFIO-style attach
of separate groups to one domain.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `init_mutex` comment is “Protects iommu pointer” — the original
code treated `iommu` as the publication point and left `pgtbl_ops`
outside the lock. No sibling qcom function has the same bug.
`map`/`unmap`/`iova_to_phys` all NULL-check `pgtbl_ops` and return
`-ENODEV`/0 rather than crashing — so the race fails mappings instead of
oopsing.

semcode MCP: not available; used git grep and reads.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: `v7.3-rc4-27-gf0100363d8c37`, `make kernelversion` =
  **7.3.0-rc4**.
- File exists at `drivers/iommu/arm/arm-smmu/qcom_iommu.c`.
- `git merge-base --is-ancestor a05b67cd45ad0 HEAD` succeeds: this
  commit is already in this checkout (landed as
  `v7.2-rc2-7-ga05b67cd45ad0`).
- Pre-fix code existed here from v4.14 until that commit. The race is in
  this driver’s design, not in code added after this tree branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Five-line reorder around a pattern present since 2017. File
moved in `e86d1aa8b60f7` (v5.8) from `drivers/iommu/qcom_iommu.c`; this
tree already uses the new path. Expected apply: **clean**. No
conflicting churn around the unlock.

**Step 6.3: RELATED FIXES ALREADY HERE**
Record: The leak fix `3c748a5554f96` is also here and is independent. No
alternate fix for this race.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: `[iommu / Qualcomm legacy SMMU] [IMPORTANT]`
Not mm/core, but IOMMU DMA for a family of Qualcomm SoCs still in DT
(phones, Dragonboard-class boards, embedded). Mapping failures break DMA
for those devices.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Legacy driver (“Misc Fixes” cover letter). Recent Qualcomm
fixes; not a new subsystem. Mature code, long-present bug.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **driver-specific / config-specific** — `CONFIG_QCOM_IOMMU` on
`ARCH_QCOM` (MSM8916, MSM8937, MSM8939, MSM8953, MSM8976, …). Not
universal.

**Step 8.2: TRIGGER CONDITIONS**
Record: Two threads attaching the same `qcom_iommu_domain` (shared ARM
DMA mapping, or two groups attached to one domain). After the first
drops `init_mutex` and before it stores `pgtbl_ops`, the second skips
init and maps. Window is a few instructions, but **preemption after
unlock** makes it realistic; SCM-held init also means waiters are ready
to run immediately. Not triggerable by an unprivileged syscall alone in
the usual case; it is a probe/attach race. No field `Reported-by`
(UNVERIFIED in production).

**Step 8.3: FAILURE MODE SEVERITY**
Record: **Failed IOMMU map (`-ENODEV`) for valid mappings** → DMA setup
failure / device non-functional. Not a KASAN UAF or panic (`map` NULL-
checks). **Severity: HIGH** (device DMA broken), not CRITICAL (no
oops/corruption).

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Prevents a real attach/map race on Qualcomm IOMMU;
  devices keep working under concurrent attach.
- **Risk:** Very low (3-statement reorder, no API/locking change).
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real race: initialized flag published under lock, ops pointer
  published after unlock.
- User-visible failure: valid maps return `-ENODEV` (DMA/device
  failure).
- Bug in the driver since v4.14; this tree’s driver still has that
  design.
- 5-line, obviously correct publish-under-lock.
- Reviewed by Konrad Dybcio; applied by Will Deacon.
- Self-contained; not a new feature.
- Used on real Qualcomm SoCs that still ship on LTS-class kernels.

**AGAINST:**
- No `Reported-by` / syzbot / crash log.
- Window is small; needs concurrent attach to the **same** domain.
- Failure is `-ENODEV`, not oops/UAF/corruption.
- Cover letter calls the series “Misc Fixes”; nobody Cc’d stable.
- Peripheral vs core (legacy qcom_iommu, not arm-smmu-v3).

**UNRESOLVED:**
- No confirmed production hit.
- lore.kernel.org HTML fetch returned 403; discussion recovered via `b4
  dig`/`b4 mbox`.
- How often qcom platforms share one `dma_iommu_mapping` across devices
  is not fully quantified; the ARM DMA API and `init_mutex` exist
  specifically for that case.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reorder is locally
   checkable; Konrad R-b; Will applied; in mainline since v7.2-rc2.
2. Fixes a real bug that affects users? **PASS** — concurrent attach can
   fail valid DMA maps.
3. Important issue? **PASS** — DMA map failure can take devices out; not
   a panic, but not cosmetic.
4. Small and contained? **PASS** — 5 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same file/function; already
   the current code here.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device-ID/quirk/DT/build/doc exception). It is a
normal small race fix.

**Step 9.4: DECISION**

This tree is **7.3-rc4**. The Qualcomm IOMMU driver is here, and the
race is in the original 2017 init/map split, not in later architecture.
The patch is a correct, tiny publication-order fix: once `init_mutex` is
dropped, `pgtbl_ops` must already be visible so a concurrent attach
cannot skip init and then fail `qcom_iommu_map()`.

It meets stable rules: real bug, user-visible DMA failure, surgical
change, no new API, no prerequisites. Benefit outweighs the tiny race
window and lack of a field report.

---

## Verification
- [Phase 1] Parsed tags: Reviewed-by Konrad Dybcio; SOB Mukesh Ojha +
  Will Deacon; no Fixes/Reported-by/Cc-stable
- [Phase 2] Diff: 2+/3- in `qcom_iommu_init_domain()`; move `pgtbl_ops`
  store before `mutex_unlock`
- [Phase 2] Confirmed `map()` NULL-checks ops and returns `-ENODEV`;
  `init_domain` early-outs on `qcom_domain->iommu`
- [Phase 3] `git blame`: unlock-then-assign from `0ae349a0f33fb`
  (v4.14-rc1, Rob Clark)
- [Phase 3] No Fixes tag; leak fix `3c748a5554f96` is independent
- [Phase 3] `git merge-base --is-ancestor a05b67cd45ad0 HEAD` → yes
  (already in this 7.3-rc4 checkout)
- [Phase 3] `git describe a05b67cd45ad0` → `v7.2-rc2-7-ga05b67cd45ad0`
- [Phase 4] `b4 dig -c a05b67cd45ad0`: v2 5/6 at
  patch.msgid.link/20260717144608.3216274-6-…
- [Phase 4] `b4 dig -a`: v1 5/8 (2026-06-23) → v2 5/6 (2026-07-17); this
  hunk unchanged
- [Phase 4] `b4 dig -w`: iommu maintainers + linux-arm-msm Cc’d
- [Phase 4] Konrad v1 review: R-b; optional `guard(mutex)` suggestion
  only; Will applied v2
- [Phase 4] lore.kernel.org WebFetch 403; used b4 mbox instead
- [Phase 4] stable@ search: this commit not discussed; unrelated arm-
  smmu-qcom hits
- [Phase 5] Callers: only `qcom_iommu_attach_dev` ← IOMMU `.attach_dev`
  ← `__iommu_attach_device`
- [Phase 5] `ARM_DMA_USE_IOMMU` / `arm_iommu_attach_device()` allows
  shared mappings across devices
- [Phase 5] semcode unavailable; used git grep + file reads
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Current file already has assignment before unlock (this
  commit)
- [Phase 7] DT: msm8916/8937/8939/8953/8976 use `qcom,msm-iommu-v1/v2`
- [Phase 8] Failure: `-ENODEV` on valid map, severity HIGH; not oops
- UNVERIFIED: production reproduction; exact share-mapping frequency on
  qcom boards

The fix is small, surgical, and meets the stable criteria for this
tree’s Qualcomm IOMMU driver.

**YES**

 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 792585321bd11..1a046122fca0d 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -306,13 +306,12 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
 		ctx->domain = domain;
 	}
 
-	mutex_unlock(&qcom_domain->init_mutex);
-
 	/* Publish page table ops for map/unmap */
 	qcom_domain->pgtbl_ops = pgtbl_ops;
 
-	return 0;
+	mutex_unlock(&qcom_domain->init_mutex);
 
+	return 0;
 out_clear_iommu:
 	qcom_domain->iommu = NULL;
 out_unlock:
-- 
2.53.0

