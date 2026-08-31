Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAD24E13FE;
	Mon, 31 Aug 2026 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183586; cv=none; b=bdgqM4ju3jmu6hPYuWs3rIyZIA3B1ufdTZ7ish19f9xlLBmKxljmyA9u3jhJTTtw4lUpLZ7uz2v8SSqfX6yU+8/C4KQwQBoGGgAAoV5emULX6ifBsc6wbxLJYWG3slsnPD59x2Viu5d71GsWl6816vJ2qOePBF0Ycj/6El2V/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183586; c=relaxed/simple;
	bh=1+1K3LmACQLwhUjqIQzoJfyCz+De72NsOMQB/5Fa990=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZy3ax3rZikev6sbtCBFuqAYTB54tszA4MC8410EBY9XAepek/OKG+mjRk8JksGVrp6Djz6Uu73t7HzboaxlTKdo0d6myC3F0KA3/OYiIDiqsRmOhQhlhqrZkVGP+i8CGE+mfwYS46PC1wUrsUX/OqLS4ocxPaD5j/WoNm2r85s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ui6UzJD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ui6UzJD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547FF1F00A3E;
	Mon, 31 Aug 2026 13:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183584;
	bh=F3uvOzOifS1weX/AJqM1DfpFJiHfL+qAWaRCv9sb9Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui6UzJD4GULBoRYR1JVdIUUYo32wvnOpur2NXQDxQbhlPElDUrOwxuD+52OuPQVsl
	 JbdL2z++d+qwhlamaLK2Kw+xOC3sq6HsTiYRkx6qoXb0HD5h5/l03DSMh06hMRbhVV
	 zTtazybmF5uWjaXFA2BJ/fuoE2Zm3RiVZrEzJykYbPh7MU++IigdqO3sxWGLX/RAzb
	 nGpnlyZUnDg0mEW38k7q3yQf3MMSwDneoBVwKvOITMk2fbtVphQ6g6c2g8A+NAsXn6
	 NJeUpEeFhroVL718cUUw66VIzWF+zFAvtlmXyptB8fntMlfxapQh5BPj44xQLHyhPC
	 qr8g+6EE13BBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] spi: spi-qcom-qspi: Fix incomplete error handling in runtime PM
Date: Mon, 31 Aug 2026 09:23:30 -0400
Message-ID: <20260831133314.4125787-182-sashal@kernel.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit d283d5d4d9f6d081ddb65e371be26fffeb611c42 ]

The runtime PM functions had incomplete error handling that could leave the
system in an inconsistent state. If any operation failed midway through
suspend or resume, some resources would be left in the wrong state while
others were already changed, leading to potential clock/power imbalances.

Reorder the suspend/resume sequences to avoid brownout risk by ensuring the
performance state is set appropriately before clocks are enabled and clocks
are disabled before dropping the performance state.

Fix by adding proper error checking for all operations and using goto-based
cleanup to ensure all successfully acquired resources are properly released
on any error.

Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260429-spi-nor-v5-2-993016c9711e@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `spi: spi-qcom-qspi: Fix incomplete error
handling in runtime PM`

**Local tree:** `v6.18.43` (Linux 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[spi: spi-qcom-qspi]` `[Fix]` — Fix incomplete error
handling in runtime PM for the Qualcomm QSPI SPI controller driver.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none in final commit (Mark Brown reviewed during
  v3→v4 iteration per lkml)
- **Acked-by:** — none
- **Link:** `https://patch.msgid.link/20260429-spi-
  nor-v5-2-993016c9711e@oss.qualcomm.com` (patch 2/7 in spi-nor v5
  series)
- **Cc: stable:** — absent (expected)
- **Signed-off-by:** Viken Dadhaniya (author), Mark Brown (SPI
  maintainer)

Notable: No syzbot or user bug reports. Maintainer review feedback
incorporated (Mark Brown requested `__must_check` handling for
`clk_bulk_prepare_enable()` in error rollback).

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** Runtime suspend/resume had incomplete error handling and
  wrong resource ordering.
- **Symptom:** Mid-operation failures leave clocks, ICC, pinctrl, and
  OPP votes in inconsistent states; power/clock imbalance; brownout risk
  from dropping performance state before disabling clocks (suspend) or
  enabling clocks before raising performance state (resume).
- **Root cause:** Missing error checks on `pinctrl_pm_select_*()` and
  `dev_pm_opp_set_rate()`; early `return` without rollback; wrong
  sequencing of OPP vs clocks.
- **Version info:** None stated.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — explicitly a bug fix, not cosmetic cleanup. The
sequencing change affects the **normal** suspend/resume path on every
autosuspend cycle, not only error paths.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/spi/spi-qcom-qspi.c` (+36 / −8 lines)
- **Functions:** `qcom_qspi_runtime_suspend()`,
  `qcom_qspi_runtime_resume()`
- **Scope:** Single-file, surgical fix to two runtime PM callbacks.

### Step 2.2: Code Flow Changes

**Suspend — before → after:**
| Step | Before | After |
|------|--------|-------|
| 1 | Drop OPP to 0 (unchecked) | Disable clocks |
| 2 | Disable clocks (unchecked) | Disable ICC (with rollback) |
| 3 | Disable ICC; on failure return with clocks off, OPP 0, ICC on |
Set pinctrl sleep (with rollback) |
| 4 | Set pinctrl sleep (unchecked) | Drop OPP (with rollback) |

**Resume — before → after:**
| Step | Before | After |
|------|--------|-------|
| 1 | Set pinctrl default (unchecked) | Set OPP rate (checked) |
| 2 | Enable ICC; on failure return | Set pinctrl default (with
rollback) |
| 3 | Enable clocks; on failure return with ICC on | Enable ICC (with
rollback) |
| 4 | Set OPP (return value only) | Enable clocks (with rollback) |

**Record:** Normal and error paths both changed. Error paths now use
goto-based unwind.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness + error-path resource management +
  power sequencing.
- **Mechanism:**
  1. **Power sequencing (every suspend):** OPP dropped before clocks
     disabled → potential brownout/instability on Qualcomm OPP-managed
     domains.
  2. **Power sequencing (every resume):** Clocks enabled before OPP
     raised → running at insufficient performance/voltage level.
  3. **Error-path inconsistency:** Partial teardown without rollback
     (e.g., ICC disable fails after clocks off and OPP at 0).
  4. **Ignored return values:** `pinctrl_pm_select_*()` and
     `dev_pm_opp_set_rate()` failures silently ignored.

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct: standard kernel PM rollback pattern.
- Minimal, focused diff.
- Low regression risk: only affects runtime PM callbacks; rollback
  mirrors forward operations.
- Mark Brown reviewed and requested the `clk_bulk_prepare_enable()`
  error check in v4.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` attributes runtime PM functions to
`19eef1d98eeda` (shallow/tree-squash history in this checkout). Cannot
determine original introduction commit from this tree's limited history.
Buggy code is present at lines 816–858 in v6.18.43.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** `git log --oneline -- drivers/spi/spi-qcom-qspi.c` shows
only 3 commits (shallow history). Driver file exists fully formed in
6.18.43 with ICC, OPP, and runtime PM support.

### Step 3.4: Author Context
**Record:** Viken Dadhaniya is listed in MAINTAINERS for Qualcomm SPI-
related work. Patch is part of spi-nor v5 series (patches 2/7); this
patch is self-contained and does not require later series patches (e.g.,
patch 3 adds memory interconnect path).

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `icc_path_cpu_to_qspi`,
`ctrl->clks`, `ctrl->last_speed`, and standard PM APIs already in this
tree. Standalone backport.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://lkml.iu.edu/2604.3/08945.html — `[PATCH v4 2/7] spi:
  spi-qcom-qspi: Fix incomplete error handling in runtime PM`
- **Series:** v1→v4 revisions; committed version matches v4.
- **Reviewer feedback:** Mark Brown (v3 review) requested checking
  `clk_bulk_prepare_enable()` return value; addressed in v4.
- **Stable nomination:** None found in available threads.
- **NAKs:** None found.

`b4 dig` could not run without commit hash (fix not yet in tree).
`lore.kernel.org` blocked (403/Anubis). lkml.iu.edu archive accessible.

### Step 4.2: Reviewers
**Record:** Mark Brown (SPI maintainer) reviewed v3 and signed off final
commit. Patch CC'd linux-spi mailing list per series context.

### Step 4.3: Bug Reports
**Record:** No syzbot, bugzilla, or user Reported-by tags. Bug
identified through code review during driver hardening series.

### Step 4.4: Series Context
**Record:** Patch 2/7 in spi-nor v5 series. Later patches add memory
interconnect support (patch 3+) — **not required** for this fix. This
patch is independently applicable.

### Step 4.5: Stable List Discussion
**Record:** Could not access lore stable archive (blocked). No stable
discussion found via web search.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `qcom_qspi_runtime_suspend()`, `qcom_qspi_runtime_resume()`
— registered via `SET_RUNTIME_PM_OPS()` in `qcom_qspi_dev_pm_ops`.

### Step 5.2: Callers
**Record:** Called by kernel PM core on:
- Runtime autosuspend (250 ms delay, `pm_runtime_use_autosuspend()` in
  probe)
- `pm_runtime_force_suspend()` / `pm_runtime_force_resume()` from system
  sleep callbacks
- `host->auto_runtime_pm = true` — SPI core triggers runtime PM around
  transfers

High-frequency path on idle QSPI NOR flash access.

### Step 5.3: Callees
**Record:** `clk_bulk_disable_unprepare()`, `clk_bulk_prepare_enable()`,
`icc_disable()`, `icc_enable()`, `pinctrl_pm_select_sleep_state()`,
`pinctrl_pm_select_default_state()`, `dev_pm_opp_set_rate()`.

### Step 5.4: Reachability
**Record:** Reachable on every QSPI transfer completion (autosuspend)
and system suspend/resume on Qualcomm platforms with
`CONFIG_SPI_QCOM_QSPI`. DT platforms: SDM845, SC7180, SC7280 (SPI NOR
flash).

### Step 5.5: Similar Patterns
**Record:** Other SPI drivers (e.g., `spi-nxp-fspi.c`, `spi-
omap2-mcspi.c`) check `pinctrl_pm_select_sleep_state()` return values.
This driver was missing that pattern.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current tree at `drivers/spi/spi-qcom-
qspi.c:816-858` has the pre-fix code (OPP dropped first on suspend, no
error rollback, unchecked pinctrl/OPP returns).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Context matches patch index
`7e39038160e00`. Only runtime PM functions change; no structural
conflicts in 6.18.43.

### Step 6.3: Related Fixes Already Present?
**Record:** `git log --grep="incomplete error handling"` — no matches.
Fix not yet in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/spi/` — **IMPORTANT** (peripheral driver, but QSPI
NOR is often boot/storage flash on Qualcomm mobile/Chromebook
platforms).

### Step 7.2: Activity Level
**Record:** Driver actively maintained; Qualcomm contributor series in
2026. Platforms in DT: SDM845 phones, SC7180/SC7280 Chromebooks.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of `CONFIG_SPI_QCOM_QSPI` on ARCH_QCOM — SDM845,
SC7180, SC7280 devices using QSPI-attached SPI NOR flash.

### Step 8.2: Trigger Conditions
**Record:**
- **Every runtime suspend/resume** — wrong OPP/clock ordering (not
  error-only).
- **Error paths** — ICC, pinctrl, clock, or OPP failures during PM
  transitions.
- Autosuspend fires after 250 ms idle; common during flash I/O.
- Unprivileged users can trigger indirectly via flash/filesystem
  activity.

### Step 8.3: Failure Severity
**Record:**
- **Brownout/instability risk** on normal suspend — **HIGH** (hardware
  stress)
- **Inconsistent PM state** on error — device may fail to resume, SPI
  NOR reads/writes fail, potential system hang if flash is root —
  **HIGH**
- Not a classic UAF/crash, but can cause serious operational failures on
  production hardware — **HIGH overall**

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — fixes power sequencing on every PM cycle; prevents
  stuck/inconsistent device state
- **Risk:** LOW — 44-line change, established rollback pattern,
  maintainer-reviewed
- **Ratio:** Strong benefit, low risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real power-sequencing bug affecting every runtime suspend (OPP before
  clock disable) with explicit brownout risk
- Resume enables clocks before OPP vote — incorrect for OPP-managed
  domains
- Error paths leave ICC/clocks/pinctrl/OPP inconsistent
- Small, surgical, maintainer-reviewed fix
- Buggy code confirmed present in Linux 6.18.43
- Applies cleanly; no series dependencies
- Affects production Qualcomm hardware (phones, Chromebooks)

**AGAINST backport:**
- No syzbot or end-user crash reports
- Only triggers full failure mode on PM operation errors (though
  sequencing bug is on every cycle)
- Part of larger feature series (but this patch is standalone)

**Unresolved:**
- Exact kernel version that introduced runtime PM in this driver
  (shallow git history)
- Whether any stable-tree maintainer explicitly declined this for stable

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard PM rollback;
maintainer-reviewed v4 |
| 2. Fixes real bug? | **PASS** — power sequencing + error handling |
| 3. Important issue? | **PASS** — brownout risk, PM inconsistency,
device hang potential |
| 4. Small and contained? | **PASS** — 1 file, ~44 lines |
| 5. No new features/APIs? | **PASS** — error handling only |
| 6. Can apply to local tree? | **PASS** — code present, clean apply |

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
on merit as a power-management bug fix.

### Step 9.4: Decision Rationale
This fix addresses a real power-management defect in a production
Qualcomm driver present in Linux 6.18.43. The OPP/clock ordering problem
affects every runtime suspend/resume cycle — not merely rare error paths
— with documented brownout risk on OPP-managed Qualcomm platforms. The
error-handling gaps can leave the QSPI controller in an inconsistent
state, breaking SPI NOR access. The patch is small, self-contained,
maintainer-reviewed, and applies cleanly to this tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message;
  fetched v4 patch from lkml.iu.edu
- **[Phase 2]** Diff analysis: 2 functions, +36/−8 lines; identified
  sequencing and rollback changes
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git blame -L 816,858` →
  buggy code at those lines; shallow history (3 commits for file)
- **[Phase 3]** No Fixes: tag; no prerequisite commits identified
- **[Phase 4]** lkml.iu.edu/2604.3/08945.html — v4 2/7 patch confirmed;
  Mark Brown review on v3 noted
- **[Phase 4]** lore.kernel.org blocked (403/Anubis); `b4 dig`
  unavailable without commit hash
- **[Phase 5]** Read probe: `auto_runtime_pm=true`, autosuspend 250ms,
  OPP/ICC enabled
- **[Phase 5]** `SET_RUNTIME_PM_OPS` registration confirmed at line 892
- **[Phase 6]** Grep/read confirmed pre-fix code at lines 816–858 in
  6.18.43
- **[Phase 6]** DT bindings: sdm845, sc7180, sc7280 compatibles present
- **[Phase 6]** `CONFIG_SPI_QCOM_QSPI` in arm64 defconfig
- **[Phase 8]** Failure modes assessed from code flow analysis
- **UNVERIFIED:** Original commit SHA and date bug was introduced
  (shallow git history)
- **UNVERIFIED:** Explicit stable@ nomination in mailing list (lore
  blocked)

**YES**The background `b4 dig` run failed because of invalid syntax (`b4
dig` doesn't accept extra path arguments). That didn't block the
analysis — the patch was verified via lkml.iu.edu, direct code
inspection in your **v6.18.43** tree, and a clean-apply check against
the current `spi-qcom-qspi.c`.

**Verdict unchanged:** backport **YES** — the fix corrects OPP/clock
ordering on every runtime suspend/resume (brownout risk) and adds proper
error rollback in the Qualcomm QSPI driver.

 drivers/spi/spi-qcom-qspi.c | 44 ++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-qcom-qspi.c b/drivers/spi/spi-qcom-qspi.c
index 3c08dad8bd3f9..44175367bbd00 100644
--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -820,20 +820,34 @@ static int __maybe_unused qcom_qspi_runtime_suspend(struct device *dev)
 	struct qcom_qspi *ctrl = spi_controller_get_devdata(host);
 	int ret;
 
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(dev, 0);
 	clk_bulk_disable_unprepare(QSPI_NUM_CLKS, ctrl->clks);
 
 	ret = icc_disable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err_ratelimited(ctrl->dev, "%s: ICC disable failed for cpu: %d\n",
 			__func__, ret);
-		return ret;
+		goto err_enable_clk;
 	}
 
-	pinctrl_pm_select_sleep_state(dev);
+	ret = pinctrl_pm_select_sleep_state(dev);
+	if (ret)
+		goto err_enable_icc;
+
+	/* Drop the performance state vote */
+	ret = dev_pm_opp_set_rate(dev, 0);
+	if (ret)
+		goto err_select_default_state;
 
 	return 0;
+
+err_select_default_state:
+	pinctrl_pm_select_default_state(dev);
+err_enable_icc:
+	icc_enable(ctrl->icc_path_cpu_to_qspi);
+err_enable_clk:
+	if (clk_bulk_prepare_enable(QSPI_NUM_CLKS, ctrl->clks))
+		dev_err_ratelimited(ctrl->dev, "Failed to re-enable clocks\n");
+	return ret;
 }
 
 static int __maybe_unused qcom_qspi_runtime_resume(struct device *dev)
@@ -842,20 +856,34 @@ static int __maybe_unused qcom_qspi_runtime_resume(struct device *dev)
 	struct qcom_qspi *ctrl = spi_controller_get_devdata(host);
 	int ret;
 
-	pinctrl_pm_select_default_state(dev);
+	ret = dev_pm_opp_set_rate(dev, ctrl->last_speed * 4);
+	if (ret)
+		return ret;
+
+	ret = pinctrl_pm_select_default_state(dev);
+	if (ret)
+		goto err_opp_set_rate_zero;
 
 	ret = icc_enable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err_ratelimited(ctrl->dev, "%s: ICC enable failed for cpu: %d\n",
 			__func__, ret);
-		return ret;
+		goto err_select_sleep_state;
 	}
 
 	ret = clk_bulk_prepare_enable(QSPI_NUM_CLKS, ctrl->clks);
 	if (ret)
-		return ret;
+		goto err_disable_icc;
 
-	return dev_pm_opp_set_rate(dev, ctrl->last_speed * 4);
+	return 0;
+
+err_disable_icc:
+	icc_disable(ctrl->icc_path_cpu_to_qspi);
+err_select_sleep_state:
+	pinctrl_pm_select_sleep_state(dev);
+err_opp_set_rate_zero:
+	dev_pm_opp_set_rate(dev, 0);
+	return ret;
 }
 
 static int __maybe_unused qcom_qspi_suspend(struct device *dev)
-- 
2.53.0

