Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3877841D102;
	Mon, 31 Aug 2026 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183250; cv=none; b=fJsKCJjL4ecFO88EeBaIpXYpBnfiUvHNdZuQnQYr38pPVAD/KspFGXxiZbnkuZyeLayY4tt6TTX5pWO7pVvV7cC4NoopzP/xBlpiC08tjwARZ2u/T0rV7jYtqrmGM5AXCjasqV6F6GtktCUfig8JDVeBr98NTOH1iRfZh8C1TP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183250; c=relaxed/simple;
	bh=tjXasVs+nT5roRKPQZ+XkODiyUAi55MdVEyKSyyNSPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUrDKe+MZgPRaRCZWPZ1jcP2Cg4EctX5hbEnJ57XLuwL74P9MB12wGOWsds7N0OOJkK4TvBjaIsAlhFFuGZy9/wA5A4y0Cukp72Z4cLMjDB3oocMli7/oz5NF2rWJiq8lTPdOYwsIkAVgta7o06ZIO5QKpmE0x/JFLLEozO0rnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohChnuKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohChnuKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8FC1F000E9;
	Mon, 31 Aug 2026 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183248;
	bh=zeHrhVztDTg2l1DwUE5J1tlsgorWbl/Rkj3/n7D97Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohChnuKvriNvttD+e4hRkLocsaM3+Sc8sVJnHm5u7wbJSOs0AiqCRpHUaKAXP2Hq2
	 0OV53LJccFmqhQVY3kKHHM6UJ9q8nsnCYsnRlRcLSxwpL9kEtgcTNdOH0lviNmIq+P
	 EP4YmFIjXjW5dZikSSTw8A87NnsLsLNxm3bhZfVDbsS7w0uyY8ps7cwja4VIY8onc8
	 7MuUpBHv0cFJLSWNfdZHlCQWQJ7orWaZC3a+GeFJlBeewyaaCJnQfjsj3TAvEc3NCJ
	 pxLibouymYvePhfKhQUyh9KrZk71P8G/6ivMZoQIelvQXhpwTLHGG5b/g6a/o04yeF
	 TcOOwJPaDvBIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/arm/komeda: fix error handling for clk_prepare_enable() and callers
Date: Mon, 31 Aug 2026 09:21:02 -0400
Message-ID: <20260831133314.4125787-34-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>

[ Upstream commit 6502eb8cfcd6f7bc5f1f8b73ee524112bd93319d ]

komeda_dev_resume() calls clk_prepare_enable() without checking the
return value. If the clock fails to enable, the function returns 0
(success) while IRQs are enabled and IOMMU is connected on potentially
unclocked hardware, causing undefined behavior on resume.

Propagate the error from clk_prepare_enable() and fix all call sites
in komeda_drv.c that previously ignored the return value of
komeda_dev_resume():

- komeda_platform_probe(): if resume fails, jump to err_destroy_mdev
  (skipping the suspend call, since the clock was never enabled)
- komeda_pm_resume(): propagate the error and skip
  drm_mode_config_helper_resume() on failure

This issue was found by code review without access to Komeda hardware.

Signed-off-by: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260609130828.1066038-1-kaneko.dev@pm.me
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/arm/komeda: fix error handling for
clk_prepare_enable() and callers`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/arm/komeda]` `[fix]` — Correct error handling for
`clk_prepare_enable()` and propagate errors to all callers.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by:** Liviu Dudau `<liviu.dudau@arm.com>` (Komeda/ARM DRM
  maintainer)
- **Acked-by:** — absent
- **Link:**
  https://patch.msgid.link/20260609130828.1066038-1-kaneko.dev@pm.me
- **Cc: stable:** — absent (not a negative signal)
- **Signed-off-by:** Gustavo Kenji Mendonça Kaneko (author); Liviu Dudau
  (maintainer); ignore pipeline-added Sasha Levin SOB

**Notable:** Reviewed by subsystem maintainer. No syzbot/user crash
report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `komeda_dev_resume()` calls `clk_prepare_enable()` without
  checking its return value.
- **Symptom:** On clock-enable failure, function returns 0 (success)
  while IRQs are enabled and IOMMU is connected on potentially unclocked
  hardware.
- **Failure mode:** Undefined behavior — MMIO to display blocks without
  a running clock.
- **Affected paths:** System suspend/resume (`komeda_pm_resume`), probe
  when runtime PM is disabled, and the core resume helper itself.
- **Root cause:** Missing error propagation from `clk_prepare_enable()`
  through resume call chain.
- **Version info:** None stated.
- **Discovery:** Code review only; author had no Komeda hardware.

### Step 1.4: Hidden bug fix detection
**Record:** Explicit bug fix, not disguised cleanup. Classic missing-
return-value-check pattern in a PM/resume path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `komeda_dev.c` | +4 / -1 (check `clk_prepare_enable` return) |
| `komeda_drv.c` | +10 / -4 (propagate errors in probe and system PM
resume) |

**Functions modified:** `komeda_dev_resume()`,
`komeda_platform_probe()`, `komeda_pm_resume()`
**Scope:** Single-driver, surgical fix (~15 net lines). Two files, one
subsystem.

### Step 2.2: Code flow per hunk

**Hunk 1 — `komeda_dev_resume()`:**
- **Before:** `clk_prepare_enable()` return ignored; always proceeds to
  `enable_irq()` and `connect_iommu()`, returns 0.
- **After:** On clock failure, return error immediately; skip IRQ/IOMMU
  setup.
- **Path:** Resume / probe-init path.

**Hunk 2 — `komeda_platform_probe()`:**
- **Before:** `komeda_dev_resume()` called with ignored return; probe
  continues to KMS attach on failure.
- **After:** On failure, `goto err_destroy_mdev` (skips
  `komeda_dev_suspend()` since clock was never enabled).
- **Path:** Probe error path when runtime PM is not enabled.

**Hunk 3 — `komeda_pm_resume()`:**
- **Before:** `komeda_dev_resume()` failure ignored;
  `drm_mode_config_helper_resume()` always runs.
- **After:** Propagate resume error; skip DRM mode-config resume on
  hardware failure.
- **Path:** System sleep resume.

### Step 2.3: Bug mechanism
**Record:** **Category:** Error-path / logic correctness fix.
**Mechanism:** Ignored `clk_prepare_enable()` error allows subsequent
MMIO (`d71_enable_irq()` → `malidp_write32_mask()` on GCU/CU/LPU/DOU
blocks; `d71_connect_iommu()` → GCU/LPU register writes) on unclocked
hardware, while callers believe resume succeeded.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and follows standard kernel error-propagation patterns.
- `err_destroy_mdev` correctly avoids calling `komeda_dev_suspend()`
  when resume never enabled the clock.
- `komeda_rt_pm_resume()` already returned `komeda_dev_resume()`'s
  value; this patch completes coverage for probe and system PM.
- **Regression risk:** Low. Only adds early error returns on failure
  paths.
- **Note:** `enable_irq()` and `connect_iommu()` return values remain
  ignored (pre-existing; out of scope).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy `clk_prepare_enable()` without check introduced in
`2ebb6701654e0d` ("drm/komeda: Adds power management support",
2019-09-26). IRQ/IOMMU code added in `efb46508851874` (2019-12-12). Bug
has existed since Komeda PM support landed.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent komeda changes in this tree are unrelated (FB
creation, AFBC overflow fix, DRM client setup). No prior fix for this
clk error-handling issue. Standalone patch, not part of a series.

### Step 3.4: Author commits
**Record:** No prior komeda commits from Kaneko in this tree. Fix
reviewed/committed by maintainer Liviu Dudau.

### Step 3.5: Dependencies
**Record:** No dependencies. No prerequisite commits. Self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Link from commit message (`patch.msgid.link`) blocked by
Anubis bot protection. `b4 dig` requires a commit hash; commit is not in
this tree, so `b4 dig -c` could not be used. Lore.kernel.org search also
blocked. **Could not retrieve mailing list thread content.**

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 `-w`. Commit message confirms **Reviewed-
by: Liviu Dudau** (ARM Komeda maintainer).

### Step 4.3: Bug report
**Record:** No external bug report. Author states issue found by code
review without hardware access.

### Step 4.4: Related patches / series
**Record:** Standalone 1-patch fix. No series dependencies identified.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore stable search blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `komeda_dev_resume()`, `komeda_platform_probe()`,
`komeda_pm_resume()`.

### Step 5.2: Callers
**Record:**
| Caller | Context |
|--------|---------|
| `komeda_platform_probe()` | Device probe, when
`!pm_runtime_enabled(dev)` |
| `komeda_rt_pm_resume()` | Runtime PM resume (already propagated
return) |
| `komeda_pm_resume()` | System sleep resume |

Komeda supports `arm,mali-d71` and `arm,mali-d32` (local tree; mainline
also has `armchina,linlon-d6`).

### Step 5.3: Callees
**Record:** `clk_prepare_enable()` → on success,
`mdev->funcs->enable_irq()` (MMIO mask writes) and optional
`connect_iommu()` (MMIO + timeout polling).

### Step 5.4: Reachability
**Record:** Triggered on every system resume and probe (when runtime PM
disabled) for Komeda hardware. `CONFIG_DRM_KOMEDA` tristate driver for
ARM SoCs with Mali-D71/D32 display. Reachable from kernel PM resume —
not a userspace syscall path, but affects all suspend/resume cycles on
affected hardware.

### Step 5.5: Similar patterns
**Record:** Other DRM drivers in this tree have received clk error-
handling fixes (e.g., mediatek, rockchip, cdns-mhdp). Same class of bug.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.y)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at `komeda_dev.c:316` has unchecked
`clk_prepare_enable(mdev->aclk)`. Callers at `komeda_drv.c:78` and
`:144` ignore the return value. Bug present since 2019, well before 6.18
branch.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Local
`komeda_drv.c`/`komeda_dev.c` match the patch's "before" state at all
change sites. Only cosmetic difference: mainline `of_match` includes
`armchina,linlon-d6`; that entry is outside the fix hunks and does not
affect applicability.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git log --grep` found no prior komeda clk error-
handling fix in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/gpu/drm/arm/komeda** — PERIPHERAL (ARM Mali
display IP, embedded/SoC). Important for platforms using Komeda, not
universal.

### Step 7.2: Subsystem activity
**Record:** Moderately active in 6.18.y (client setup, DMA mask, AFBC
fixes). Mature driver with ongoing maintenance.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_DRM_KOMEDA` on ARM SoCs with Mali-D71/D32
(and linlon-d6 on newer trees). Platform-specific, not all kernel users.

### Step 8.2: Trigger conditions
**Record:** `clk_prepare_enable(mdev->aclk)` returns an error — clock
provider failure, DT misconfiguration, resume ordering issue, power-
domain not ready. Uncommon on healthy systems, more plausible during
suspend/resume or probe on misconfigured/problematic platforms. Not
userspace-triggerable directly.

### Step 8.3: Failure mode severity
**Record:** MMIO to display controller blocks without clock → bus hang,
kernel oops, or unpredictable hardware behavior. Function returns
success, so PM stack and DRM resume continue on broken hardware.
**Severity: HIGH** (potential crash/hang on resume); not CRITICAL (no
demonstrated exploit, rare trigger, no user reports).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents undefined hardware access and false-success
  resume on clock failure; correct probe teardown on init failure.
- **Risk:** Very low — ~15 lines, error-path only, maintainer-reviewed.
- **Ratio:** Favorable for stable. Conservative error handling with
  minimal regression surface.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable bug: ignored `clk_prepare_enable()` return since 2019
- Subsequent code performs MMIO (`enable_irq`, `connect_iommu`)
  requiring clock
- Fix propagates errors through probe and system PM resume
- Small, surgical, maintainer-reviewed (Liviu Dudau)
- Bug exists in this 6.18.y tree; patch applies at all change sites
- PM/resume error-handling fixes are standard stable material

**AGAINST backport:**
- No user report, syzbot report, or hardware reproduction
- Trigger (clock enable failure) likely rare on production systems
- Driver affects a limited hardware population
- Could not verify mailing list discussion (lore blocked)

**Unresolved:**
- Full review thread content unavailable
- No confirmation of explicit stable nomination in review

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — Standard pattern;
maintainer reviewed; no hardware test claimed |
| 2. Fixes a real bug? | **PASS** — Ignored error + false success is a
real logic bug |
| 3. Important issue? | **PASS** — HIGH: potential crash/hang on resume
via unclocked MMIO |
| 4. Small and contained? | **PASS** — ~15 lines, 2 files, one driver |
| 5. No new features/APIs? | **PASS** — Error propagation only |
| 6. Applies to local tree? | **PASS** — Buggy code confirmed in
v6.18.44 |

### Step 9.3: Exception categories
**Record:** N/A — not a device ID, quirk, DT, build, or docs fix.
Qualifies on bug-fix merits.

### Step 9.4: Decision rationale

For **this 6.18.y tree**, the Komeda driver is present and has carried
this resume error-handling bug since 2019. When `clk_prepare_enable()`
fails, the driver enables IRQs and connects IOMMU via MMIO on unclocked
hardware while reporting success — a legitimate PM correctness bug with
crash/hang potential. The fix is minimal, reviewed by the subsystem
maintainer, and should apply cleanly. The lack of a user report lowers
urgency but does not negate the technical merit; stable trees routinely
take ignored-return-value fixes in driver PM paths.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed Reviewed-by: Liviu Dudau; no Reported-
  by/syzbot/Fixes tags
- **[Phase 2]** Diff analysis: 2 files, 3 functions, error-propagation
  pattern verified
- **[Phase 2]** Read `d71_enable_irq()` and `d71_connect_iommu()` — both
  perform MMIO requiring clock
- **[Phase 3]** `git blame -L 314,325 komeda_dev.c`: bug since
  `2ebb6701654e0d` (2019-09-26)
- **[Phase 3]** `git show 2ebb6701654e0d`: original PM support commit
- **[Phase 3]** `git log -20 -- komeda_dev.c komeda_drv.c`: no related
  prior fix
- **[Phase 4]** WebFetch patch.msgid.link: **BLOCKED** (Anubis)
- **[Phase 4]** WebFetch lore.kernel.org: **BLOCKED** (Anubis)
- **[Phase 4]** `b4 dig -c`: not usable — commit not in local tree
- **[Phase 5]** Grep callers: probe (line 78), rt_pm_resume (123),
  pm_resume (144)
- **[Phase 5]** Verified `komeda_rt_pm_resume` already returns resume
  error; probe/pm_resume did not
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Read current `komeda_dev.c:314-325` and
  `komeda_drv.c:76-146`: buggy code confirmed present
- **[Phase 6]** Line-by-line comparison: patch hunks match local file
  structure
- **[Phase 6]** `git log --grep`: no duplicate fix in tree
- **[Phase 7]** Read `drivers/gpu/drm/arm/display/Kconfig`:
  `CONFIG_DRM_KOMEDA` tristate, depends on DRM+OF+COMMON_CLK
- **[Phase 8]** Assessed severity from verified MMIO-after-clk-failure
  code path
- **UNVERIFIED:** Mailing list review discussion content
- **UNVERIFIED:** Explicit stable nomination in review thread
- **UNVERIFIED:** Formal `git apply --check` (test patch malformed;
  manual hunk comparison confirms applicability)

**YES**

 drivers/gpu/drm/arm/display/komeda/komeda_dev.c |  6 +++++-
 drivers/gpu/drm/arm/display/komeda/komeda_drv.c | 14 +++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_dev.c b/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
index 5ba62e637a616..9aad1d1d28ec0 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
@@ -313,7 +313,11 @@ void komeda_dev_destroy(struct komeda_dev *mdev)
 
 int komeda_dev_resume(struct komeda_dev *mdev)
 {
-	clk_prepare_enable(mdev->aclk);
+	int err;
+
+	err = clk_prepare_enable(mdev->aclk);
+	if (err)
+		return err;
 
 	mdev->funcs->enable_irq(mdev);
 
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_drv.c b/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
index 358c1512b0879..fc1816c634087 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
@@ -74,8 +74,11 @@ static int komeda_platform_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(dev);
-	if (!pm_runtime_enabled(dev))
-		komeda_dev_resume(mdrv->mdev);
+	if (!pm_runtime_enabled(dev)) {
+		err = komeda_dev_resume(mdrv->mdev);
+		if (err)
+			goto err_destroy_mdev;
+	}
 
 	mdrv->kms = komeda_kms_attach(mdrv->mdev);
 	if (IS_ERR(mdrv->kms)) {
@@ -93,7 +96,7 @@ static int komeda_platform_probe(struct platform_device *pdev)
 		pm_runtime_disable(dev);
 	else
 		komeda_dev_suspend(mdrv->mdev);
-
+err_destroy_mdev:
 	komeda_dev_destroy(mdrv->mdev);
 
 free_mdrv:
@@ -139,11 +142,12 @@ static int __maybe_unused komeda_pm_suspend(struct device *dev)
 static int __maybe_unused komeda_pm_resume(struct device *dev)
 {
 	struct komeda_drv *mdrv = dev_get_drvdata(dev);
+	int err = 0;
 
 	if (!pm_runtime_status_suspended(dev))
-		komeda_dev_resume(mdrv->mdev);
+		err = komeda_dev_resume(mdrv->mdev);
 
-	return drm_mode_config_helper_resume(&mdrv->kms->base);
+	return err ? err : drm_mode_config_helper_resume(&mdrv->kms->base);
 }
 
 static const struct dev_pm_ops komeda_pm_ops = {
-- 
2.53.0

