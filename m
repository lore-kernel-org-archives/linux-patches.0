Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49C750B3B5;
	Mon, 19 Oct 2026 14:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418751; cv=none; b=trVmU6AM4TfCXQAzx7mR2/OQGXOrHzSID+zoiO4yDKl+K++jabTDYQcf53+08Gb2pLgKgvHsnzUvtbN0W7/grcyNsq9qYCxDfWjTbVBXub2bIlqxKjYwIyhg4fd5oH4cl52rHzqtTk/Cm/mzh/pcNTW7H4qcG86R2959FNUHExc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418751; c=relaxed/simple;
	bh=/5RjBPUuYHuoAi4FygzDJ6RkC17xlrOylmKGZ0czhEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fWGAfZtizdNTyvGvH/WAotWdo3ApuAoT3NM4VAmMPtxdzRLNPZZa3dI7fuEb6ptHY1P7L4VuhCJZ79aX287nNmRfYmenvsgX2XnLHq8SM7d8F3Y9kMDxCscpTXza/eIAkaDrnmMA7/6KJN5YLw0pPScyh/IbgdTbePD19lf+wNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWSl6jDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWSl6jDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6EA1F000C5;
	Mon, 19 Oct 2026 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418747;
	bh=xL5gRDFc7YMEPr92ywowGO8zMnBcNQC7WwUWBW61RzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWSl6jDea+3qUGnRqbwcPPK5vWcNQjMjP/w6nXmAAx7BQ1+QVLLUdwGtSdiYepSiP
	 0fPi6SEHKuP0TyCZHQtIP4RRJZC1/Ma+qIuyLikyGQx1BF4yKn+4WGaOCfEu+wPUcE
	 EFlmyNTFZdOKMoYBNL3KXHcpqgFp0pqH7jmBqYN9oFGfv6LW79UMr3j2V+uzAzGLpC
	 CLxzSPoqClSRMPne+Xuhnlv+GJJW2mmcMLlh4ryhsAlxsuV2GQInKnX4WPPMscOcyT
	 5KcxJIeHDYeHOxjp3DYnlmv0jzbS59BeuaRweaTLl+6//TI0ehP7wra+3KCg4x0Ixa
	 rkplXStW+26gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aisheng.dong@nxp.com,
	linux-i2c@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] i2c: imx-lpi2c: properly unwind resources on probe failure
Date: Mon, 19 Oct 2026 09:52:38 -0400
Message-ID: <20261019135441.1420968-467-sashal@kernel.org>
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

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit cbd043b00ee3f542c115c8809c4d9a67465c07d5 ]

When probe fails at devm_clk_rate_exclusive_get() or clk_get_rate(),
which occur before runtime PM is initialized, the clocks enabled by
clk_bulk_prepare_enable() are never disabled.

When probe fails after runtime PM is initialized, the previous error
path called pm_runtime_put_sync(), which triggers the runtime suspend
callback. However, due to different clock management strategies on
different SoCs[1] (to avoid deadlocks between the global prepare_lock
and runtime PM), the callback may only disable clocks without
unpreparing them, causing an incomplete unwind.

Introduce a new error label 'clk_disable' to explicitly invoke
clk_bulk_disable_unprepare(). Replace pm_runtime_put_sync() with the
sequence of pm_runtime_disable(), pm_runtime_set_suspended() and
pm_runtime_put_noidle() to bypass the runtime suspend callback during
error recovery. During the LPI2C driver probe phase, clock APIs are
used exclusively to manage clocks. Once probing succeeds, clock
management is handed over to the runtime PM core.

[1] https://lore.kernel.org/all/20251125084718.2156168-1-carlos.song@nxp.com/

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260716071957.2670263-2-carlos.song@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy probe unwind
is present here; the later SoC-specific clock strategy is not. The leak
is real and the fix is a small error-path change.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[i2c: imx-lpi2c]** **[properly unwind]** probe resources are
not released when `lpi2c_imx_probe()` fails. “Properly unwind” is fix
language (missing cleanup), not a feature.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review queue)
- **Reported-by / Tested-by / Acked-by / Cc: stable:** none
- **Reviewed-by:** Frank Li &lt;Frank.Li@nxp.com&gt;
- **Signed-off-by:** Carlos Song &lt;carlos.song@nxp.com&gt; (author);
  Andi Shyti &lt;andi.shyti@kernel.org&gt; (I2C maintainer, merger)
- **Link:** https://lore.kernel.org/r/20260716071957.2670263-2-
  carlos.song@oss.nxp.com
- **Inline [1]:** https://lore.kernel.org/all/20251125084718.2156168-1-
  carlos.song@nxp.com/ (later SoC clock/IRQ RPM split)
- Ignore any pipeline SOBs / “Upstream commit” markers

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** After `clk_bulk_prepare_enable()`, two classes of probe
  failure leak clocks.
  1. Failures **before** RPM init (`devm_clk_rate_exclusive_get()`,
     `clk_get_rate()`): early `return` leaves clocks prepared **and**
     enabled.
  2. Failures **after** RPM init: `pm_runtime_put_sync()` runs
     `lpi2c_runtime_suspend()`, which on this tree only
     `clk_bulk_disable()`s (no unprepare), so the prepare count is left
     elevated.
- **Symptom:** Unbalanced clock prepare/enable. On `-EPROBE_DEFER` the
  prepare count grows on every retry.
- **Root cause:** Probe uses clock APIs; after success, RPM owns
  enable/disable. Error paths mixed the two and did not fully unwind.
- **Version info in message:** none for 6.12. `[1]` is the later
  i.MX8QXP/8QM RPM split (`949f647eff76a`, **not** in this tree).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit resource-leak / incomplete error-path
unwind. Not style cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/i2c/busses/i2c-imx-lpi2c.c` (+14 / −7)
- **Function:** `lpi2c_imx_probe()` only
- **Scope:** single-file, error-path only

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Hunk 1 (pre-RPM errors):** `return dev_err_probe(...)` after
  exclusive-get / `clk_get_rate()` failure → `goto clk_disable` so
  `clk_bulk_disable_unprepare()` runs.
- **Hunk 2 (post-RPM errors):** `rpm_disable` no longer
  `pm_runtime_put_sync()`. It now `pm_runtime_disable()`,
  `pm_runtime_set_suspended()`, `pm_runtime_put_noidle()`, then falls
  through to `clk_disable` for `clk_bulk_disable_unprepare()`.
- **Success path:** unchanged (`pm_runtime_put_autosuspend()` still
  hands clocks to RPM).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Error-path resource leak (clock prepare/enable).**
- Missing `clk_bulk_disable_unprepare()` on early probe failure.
- RPM suspend used as unwind, but in **this** tree
  `lpi2c_runtime_suspend()` is only `clk_bulk_disable()` (since
  `fa39065833dbd`), so prepare is never reversed.
- `clk_disable` is an added put/unprepare, not a double-free: RPM
  suspend is skipped, then clocks are disabled and unprepared once.

Step 2.4: ASSESS THE FIX QUALITY
Record: Surgical and correct for this tree. Same pattern as other probe-
fail RPM unwinds. Success path untouched. Regression risk is low; the
only real risk is pairing `put_sync` with `disable_unprepare` (double-
disable). This patch removes `put_sync` and does one explicit unwind.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record (this checkout):
- Early leak: `4268254a39484` (“Avoid calling clk_get_rate during
  transfer”, 2024-05-06) — **in v6.12**.
- RPM enable/disable-only callbacks: `fa39065833dbd` (2023) — **in
  v6.12**.
- `rpm_disable` + `put_sync`: `4f4388a55019d` / upstream `b1852c5de2f2a`
  (“Fix clock count when probe defers”) — **already in this 6.12 tree**.
  That only fixed the **enable** count; prepare still leaks.
- `-EPROBE_DEFER` from recovery pinctrl: `188542964e782` — **in this
  tree**.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Bug-introducing history above is in this tree.
`cbd043b00ee3f` is **not** an ancestor of HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Latest local change is `4f4388a55019d` (the incomplete enable-
count fix). This commit is the missing prepare-count half of that
unwind. Standalone for 6.12; does not need DMA, `hwdata`, or
`need_prepare_unprepare_clk`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Carlos Song is an NXP LPI2C contributor (GPIO recovery in this
tree). Frank Li reviewed. Andi Shyti merged. Series v6 patch 2
(`a4c419356a333`, controller reset) is independent and not required.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Message cites later SoC clock strategies (`949f647eff76a`,
2026-01-19) — **not in 6.12**. The **code** of this fix does not use
`hwdata` / `need_prepare_unprepare_clk`. Needed APIs
(`clk_bulk_disable_unprepare`, `pm_runtime_put_noidle`,
`pm_runtime_set_suspended`) exist in 6.12. **Can be backported
standalone** with context tweaks.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- SHA: `cbd043b00ee3f542c115c8809c4d9a67465c07d5`
- `b4 dig -c`: https://patch.msgid.link/20260716071957.2670263-2-
  carlos.song@oss.nxp.com
- Series: **v6 1/2** “fix probe error handling and reset controller”
  (v4/v5/v6 of the same subject)
- Andi Shyti: merged to `i2c/i2c-2` (2026-07-28). No NAK.
- Cover letter: v3 replaced `put_sync` with disable + set_suspended +
  put_noidle specifically to avoid the suspend callback during error
  recovery.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): linux-i2c, imx@lists, linux-arm-kernel; Andi
Shyti; Dong Aisheng (LPI2C maintainer in MAINTAINERS); Frank Li
(Reviewed-by); Pengutronix i.MX folks. Right audience.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Bug is from code review / NXP analysis, not
a crash report. Still a concrete leak with a documented `-EPROBE_DEFER`
path.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Patch 2/2 (reset in probe) is a separate hang-on-boot issue; not
a dependency. Earlier `b1852c5`/`4f4388a55019d` is the related
incomplete stable fix already here.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable returned HTTP 403. No stable nomination
on the patch itself. Related defer clock-count fix **was** `Cc: stable #
v4.16+` and is already in this tree.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `lpi2c_imx_probe()` only. Unwind interacts with
`lpi2c_runtime_suspend()` (not edited).

Step 5.2: TRACE CALLERS
Record: `.probe = lpi2c_imx_probe` on the platform driver. Called from
driver core on DT devices (`fsl,imx7ulp-lpi2c`) and on deferred retry.
Not a syscall hot path.

Step 5.3: TRACE CALLEES
Record: `clk_bulk_prepare_enable` / `clk_bulk_disable_unprepare`,
`devm_clk_rate_exclusive_get`, `clk_get_rate`, RPM helpers,
`lpi2c_imx_init_recovery_info()` (`devm_pinctrl_get` → `-EPROBE_DEFER`),
`i2c_add_adapter()`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable at boot and on probe defer.
`lpi2c_imx_init_recovery_info()` is a real `-EPROBE_DEFER` source when
pinctrl is not ready. Unprivileged userspace does not need to trigger
it.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Other I2C drivers use `clk_disable:` /
`clk_bulk_disable_unprepare` on probe fail (`i2c-qcom-geni.c`,
`i2c-qcom-cci.c`). This driver was the odd one out after RPM callbacks
stopped unpreparing.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `lpi2c_imx_probe()` in `drivers/i2c/busses/i2c-imx-
lpi2c.c` still does:

```609:625:drivers/i2c/busses/i2c-imx-lpi2c.c
        ret = clk_bulk_prepare_enable(lpi2c_imx->num_clks,
lpi2c_imx->clks);
        if (ret)
                return ret;
        ...
        if (ret)
                return dev_err_probe(...);  /* exclusive_get: leak */
        ...
        if (!lpi2c_imx->rate_per)
                return dev_err_probe(...);  /* rate 0: leak */
```

```654:657:drivers/i2c/busses/i2c-imx-lpi2c.c
rpm_disable:
        pm_runtime_dont_use_autosuspend(&pdev->dev);
        pm_runtime_put_sync(&pdev->dev);
        pm_runtime_disable(&pdev->dev);
```

```672:679:drivers/i2c/busses/i2c-imx-lpi2c.c
static int __maybe_unused lpi2c_runtime_suspend(struct device *dev)
{
        ...
        clk_bulk_disable(lpi2c_imx->num_clks, lpi2c_imx->clks);
```

No `hwdata` / `need_prepare_unprepare_clk` here, so **every** SoC only
disables in RPM. The prepare leak on `rpm_disable` is unconditional.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **`git apply --check` fails** because context includes
`hwdata->need_prepare_unprepare_clk` and later DMA probe code. Logical
change maps 1:1 onto this probe (same exclusive-get returns, same
`rpm_disable` + `put_sync`). Difficulty: **minor context backport**, not
a rewrite.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `4f4388a55019d` is here and only switched `pm_runtime_put()` to
`put_sync()`. It does **not** unprepare. No other unwind of this leak in
this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: I2C bus driver for i.MX LPI2C (`CONFIG_I2C_IMX_LPI2C`,
`ARCH_MXC`). **IMPORTANT** for i.MX boards (PMIC, audio, sensors on that
bus), not core MM/VFS. Maintainer: Dong Aisheng; I2C maintainer merged
it.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature driver (since ~2016). This tree’s recent churn is small
fixes, not a rewrite. The big SoC RPM split landed after 6.12.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / platform-specific** — i.MX systems using
LPI2C. Common on i.MX7ULP / i.MX8 class boards, not all Linux users.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Exclusive-get / zero clock rate: uncommon hard errors.
- **`-EPROBE_DEFER` from pinctrl in recovery init:** normal boot race;
  retries leak another prepare each time.
- `i2c_add_adapter()` failure: less common.
- Not a userspace-triggered security path.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Clock prepare leak (and enable leak on the pre-RPM returns).
Repeated defer can unbalance the clock tree, keep parents prepared, and
block low power. Not an oops/corruption/CVE. **Severity: MEDIUM**,
higher if defer retries pile up.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** Completes the unwind that `4f4388a55019d` only half-
  fixed; stops prepare-count growth on defer. Medium benefit for i.MX
  LPI2C users.
- **Risk:** ~20-line error-path change; success path unchanged. Low risk
  if backported without keeping `put_sync`.
- **Ratio:** Favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real clock leak on probe failure, including a documented
  `-EPROBE_DEFER` path.
- Buggy code is in this 6.12 tree (exclusive-get + disable-only RPM +
  `put_sync` unwind).
- This tree already took the enable-count half (`4f4388a55019d`); this
  is the remaining prepare-count fix.
- Small, probe-error only; reviewed and merged by the I2C maintainer.
- No new API/feature; no `hwdata` dependency in the changed lines.

**AGAINST:**
- Does not apply with `git apply` as-is (later DMA/`hwdata` context).
- Not a crash/security/corruption bug.
- No `Cc: stable` / syzbot / user crash report.
- Message talks about later per-SoC clock strategies that 6.12 does not
  have (the leak is still real here, and simpler).

**UNRESOLVED:**
- Stable list search was blocked (HTTP 403). Unverified whether anyone
  already NAK’d this for stable.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — explicit unwind; merged
   after v4–v6 review.
2. Fixes a real bug that affects users? **PASS** — clock leak on probe
   fail/defer.
3. Important issue? **PASS** at medium — not panic-level, but resource
   leak on a normal defer path; sister fix already went to stable.
4. Small and contained? **PASS** — one function, error labels only.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS with backport** — code is here;
   context needs a small edit. Not “code missing / bug introduced after
   branch.”

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not an ID/quirk/DT/build/docs exception). Qualifies as a
normal small bugfix.

Step 9.4: MAKE YOUR DECISION
Backport to **this** 6.12 tree. The later SoC RPM split is not required.
Drop `hwdata`/DMA context and apply the same `goto clk_disable` + RPM-
bypass + `clk_bulk_disable_unprepare()` sequence to `lpi2c_imx_probe()`.

Verification:
- [Phase 1] Tags: Reviewed-by Frank Li; SOB Andi Shyti; Link to v6 1/2;
  no Fixes/Cc:stable/syzbot
- [Phase 2] Diff: +14/−7 in `lpi2c_imx_probe()`; two early returns →
  `clk_disable`; `put_sync` → disable/set_suspended/put_noidle +
  `clk_bulk_disable_unprepare`
- [Phase 3] Blame: leak from `4268254a39484` (in v6.12); RPM disable-
  only from `fa39065833dbd` (in v6.12); incomplete enable fix
  `4f4388a55019d` already in HEAD
- [Phase 3] `git merge-base --is-ancestor cbd043b00ee3f HEAD` → not in
  this tree
- [Phase 3] `949f647eff76a` (`need_prepare_unprepare_clk`) → **not** in
  this tree
- [Phase 4] `b4 dig -c cbd043b00ee3f`: lore v6 1/2; Andi merged to
  i2c-2; no NAK
- [Phase 4] Cover: v3 introduced the RPM-bypass unwind; patch 2/2 is
  independent
- [Phase 4] UNVERIFIED: stable@ lore (403)
- [Phase 5] Probe is platform `.probe`; `-EPROBE_DEFER` from
  `devm_pinctrl_get` in recovery init
- [Phase 6] `git describe` / Makefile: 6.12.111; buggy returns and
  `rpm_disable` present; `git apply --check` fails on `hwdata` context
- [Phase 8] Failure mode: clock prepare leak, worse on deferred probe;
  severity MEDIUM; risk low

The leak exists on this 6.12 branch, the fix is small and correct, and
it finishes an unwind this tree already started.

**YES**

 drivers/i2c/busses/i2c-imx-lpi2c.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 24c70ea371bb9..7c560a4f68319 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -1500,14 +1500,18 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 	 * each transfer
 	 */
 	ret = devm_clk_rate_exclusive_get(&pdev->dev, lpi2c_imx->clks[0].clk);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "can't lock I2C peripheral clock rate\n");
+	if (ret) {
+		ret = dev_err_probe(&pdev->dev, ret,
+				    "can't lock I2C peripheral clock rate\n");
+		goto clk_disable;
+	}
 
 	lpi2c_imx->rate_per = clk_get_rate(lpi2c_imx->clks[0].clk);
-	if (!lpi2c_imx->rate_per)
-		return dev_err_probe(&pdev->dev, -EINVAL,
-				     "can't get I2C peripheral clock rate\n");
+	if (!lpi2c_imx->rate_per) {
+		ret = dev_err_probe(&pdev->dev, -EINVAL,
+				    "can't get I2C peripheral clock rate\n");
+		goto clk_disable;
+	}
 
 	pm_runtime_set_autosuspend_delay(&pdev->dev, I2C_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
@@ -1545,8 +1549,11 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 
 rpm_disable:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+clk_disable:
+	clk_bulk_disable_unprepare(lpi2c_imx->num_clks, lpi2c_imx->clks);
 
 	return ret;
 }
-- 
2.53.0

