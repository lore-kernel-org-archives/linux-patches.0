Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B34623883;
	Mon, 19 Oct 2026 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418691; cv=none; b=pn7FlhoYmykVO8s6HkSchM6V/4SLLL2CyrPfa6JbklW76us1w+LojhcSf5De9dnc8Z3pAkksWmGw2aJcJZDQ8d5v0qFtMPT40qQyLJ8y5nADI2PPdCNT4XcY4UuseMM7SbbwAPncYQcWLjJkob//FUIg21VRR755wyBG6lx6TCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418691; c=relaxed/simple;
	bh=F/UsXT1e7/AvWIqMK34SiQX1vfA56FuuYZ5XTjxUBKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TYgKF78NYfR9MBeSez/VV5w546OLc21BfsQss044sRvA25MJqyXsBh0kFCcPfYHk903Jk95Yxn79jcREhFd0DCyjkQrb7QCJioGoqrVfQ75gqB7PpecA+Ti6O/wgXXBMCXjzFQlT4u3ZRIPEcdXhLH9cA0RiXmCtUZQb7K+d2HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7TraGz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7TraGz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBE51F000C6;
	Mon, 19 Oct 2026 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418689;
	bh=WTU9jE6vfY4VsFTKT81fPJrxMMr0twbpuj3cAR+x5pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7TraGz+mpaJ8iodszG+WiXHkxbnZYFL/7JttE5RqEtJ5ovQOvIVi/HI2OQEaekp0
	 0AmhAxpZeiF+LX25JjO/SazdHpifz1WoHge2TIlOf/8gSuDthNur/V6T+kurmIi9ix
	 zoNS1Gc1U51ucQJ6DF6w1/IpOgx946ZXmBo/FaCxwxj46YKLZyutqyAaywghsW+fiP
	 xHh8mwI42AL9PK3mrSYcn+OY0AUntk+b/glX0eRvn7qET60kbQt+rpYOnnjVP8O/X0
	 VC1L1GXnsWXJkjMk4O5Pvknq3movujmn3nCaiIVtzqBMprS+bq2NB3oeif6yj4G2Ov
	 J28uFx3iqqqiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	olteanv@gmail.com,
	linux-spi@vger.kernel.org,
	imx@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] spi: fsl-dspi: clean up after failed suspend and resume
Date: Mon, 19 Oct 2026 09:51:57 -0400
Message-ID: <20261019135441.1420968-426-sashal@kernel.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 2543355f3da56a297e3803ccb5d29f4dce5f18f1 ]

dspi_suspend() disabled the IRQ before spi_controller_suspend(),
but ignored a suspend failure and kept tearing the device down.
Restore the IRQ and return the error if suspend fails.

dspi_resume() also left the clock prepared if controller resume or
hardware init failed. Route those failures through clock cleanup.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_427FA55E3D59112524886E9C931CA0F92F06@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I compared the pre-image to v6.18.53: the buggy suspend/resume path is
there unchanged, so this is a standalone fix for this tree.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[spi: fsl-dspi:] [clean up] [restore IRQ / clocks after
  failed suspend and resume]`
- Subsystem is Freescale DSPI. The verb is “clean up”, but the body
  describes ignored errors and missing rollback.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Signed-off-by: Jiawen Liu <1298662399@qq.com>` (author)
  - `Link: https://patch.msgid.link/tencent_427FA55E3D59112524886E9C931C
    A0F92F06@qq.com`
  - `Signed-off-by: Mark Brown <broonie@kernel.org>` (SPI maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, or `Cc: stable` (absence of those last two is expected for
    this review)
  - Pipeline-added `Signed-off-by: Sasha Levin` / `[ Upstream commit
    2543355f3da5... ]` ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record: **Bug:** `dspi_suspend()` calls `disable_irq()` then
  `spi_controller_suspend()` but ignores a non-zero return and still
  disables the clock and selects the sleep pin state. **Symptom:** on a
  failed controller suspend the IRQ stays off, clocks are gated, pins go
  to sleep, and suspend is reported as success. **Resume bug:**
  `clk_prepare_enable()` is not undone if `spi_controller_resume()` or
  `dspi_init()` fails. **Root cause:** missing error checks and missing
  rollback. No version range in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Yes. “Clean up” is error-path recovery: re-enable IRQ and
  return the error on suspend failure; `clk_disable_unprepare()` on
  resume failure. That is a leak/imbalance fix, not style.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: `drivers/spi/spi-fsl-dspi.c` only; **+18 / −3**. Functions:
  `dspi_suspend()`, `dspi_resume()`. Single-file surgical PM error-path
  fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **suspend before:** disable IRQ → ignore `spi_controller_suspend()`
    → always `clk_disable_unprepare()` → sleep pinctrl → return 0.
  - **suspend after:** disable IRQ → if `spi_controller_suspend()`
    fails, `enable_irq()` and return `ret` (clocks/pinctrl untouched).
  - **resume before:** enable clock → ignore `spi_controller_resume()` →
    on `dspi_init()` failure return with clock still prepared.
  - **resume after:** those failures go to `disable_clk`
    (`clk_disable_unprepare()` + return `ret`). IRQ is still enabled
    only on the success path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: **Error-path / resource-leak / IRQ imbalance.**
  `spi_controller_suspend()` can return `-EBUSY` from `spi_stop_queue()`
  after a 5s wait (`drivers/spi/spi.c`). Continuing then gates the clock
  under a live controller and leaves the IRQ disabled. Resume can leak a
  prepared clock.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: Minimal and obviously correct; matches other SPI drivers that
  already check these returns. Regression risk is low: only error paths
  change. Idle suspend still returns 0 after stop-queue succeeds. Pre-
  existing IRQ-before-stop-queue ordering is not introduced here
  (Sashiko noted it as pre-existing). Resume still does not undo
  `spi_controller_resume()` on later `dspi_init()` failure;
  `dspi_init()` only fails on invalid `trans_mode` after a successful
  probe, so that path is essentially dead.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: On v6.18.53, suspend/resume blame is `c5412ec5f68773`
  (“Reinitialize DSPI regs after resuming for S32G”, 2025-05-22), which
  kept the ignore-error pattern. That pattern already existed before
  S32G (`git show c5412ec5f68773^`). Original driver `349ad66c0ab0b`
  (Vybrid VF610) already ignored `spi_master_suspend()` and always
  disabled the clock. Bug is old, not post-6.18.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Not applicable beyond that.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: Related: `3d87b613d6a3c` (“Fix external abort on interrupt in
  resume or exit paths”) added `disable_irq()` in suspend because a
  shared IRQ after clocks-off caused an external abort on Vybrid. That
  makes restoring the IRQ on suspend failure required. `9bd77a9ce31dd`
  only fixed a NULL drvdata in PM. This patch is standalone; later
  autosel `b6d8099e44987` only switches PM macros.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Jiawen Liu is not the SPI maintainer. Same series on this
  tree: `spi: atcspi200`, `spi: bcmbca-hsspi`, `spi: bcm-qspi`, `spi:
  bcm63xx-hsspi`, `spi: bcm63xx`, plus `spi: nxp-fspi` probe RPM. Each
  driver is independent. Mark Brown applied the series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: No new helpers. Uses `spi_controller_suspend`/`resume`,
  `enable_irq`/`disable_irq`, `clk_disable_unprepare` already in 6.18.
  Standalone. Series 3/4 does not need 1/4 or 2/4 for this file.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `b4 dig -c 2543355f3da5` → https://patch.msgid.link/tencent_42
  7FA55E3D59112524886E9C931CA0F92F06@qq.com
- Series: v1 only, `[PATCH 3/4]`. Mark Brown applied all four to
  `broonie/spi.git for-7.3`. No NAK on this patch. Sashiko flagged two
  **pre-existing** ordering issues (IRQ before stop-queue; resume queue
  before `dspi_init()`), not regressions from this diff. No reviewer
  `Cc: stable`. Direct lore fetch returned 403; thread recovered via `b4
  dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: `b4 dig -w`: To Mark Brown; Cc linux-spi, linux-kernel, linux-
  arm-kernel, imx@, NXP (olteanv, han.xu, haibo.chen). No human
  Reviewed-by on this patch. Maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No Reported-by / bugzilla / syzbot. Bug is from code
  inspection of ignored returns.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: 1/4 atcspi200, 2/4 bcmbca-hsspi, 3/4 this, 4/4 nxp-fspi
  (different bug: probe RPM). This hunk does not depend on the others.
  Frank Li replied only to 4/4.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search via WebFetch returned 403.
  UNVERIFIED whether stable@ discussed this SHA. No in-tree evidence it
  was rejected.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `dspi_suspend()`, `dspi_resume()`. Callees of interest:
  `spi_controller_suspend()`, `spi_controller_resume()`, `dspi_init()`.

**Step 5.2: TRACE CALLERS**
- Record: Only `SIMPLE_DEV_PM_OPS(dspi_pm, dspi_suspend, dspi_resume)`
  on v6.18.53 → system-sleep PM for this platform device. Not a syscall
  hot path; triggered by suspend/resume on i.MX / Vybrid / LS1021A / S32
  / ColdFire DSPI.

**Step 5.3: TRACE CALLEES**
- Record: `spi_controller_suspend()` → `spi_stop_queue()` (up to 500 ×
  ~10ms, then `-EBUSY`) then `__spi_mark_suspended()`.
  `dspi_transfer_one_message()` waits on `dspi->xfer_done` when
  `dspi->irq` is set; completion is from `dspi_interrupt()`. DMA mode
  waits on DMA completions, not that IRQ.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Userspace/system suspend → driver PM → `dspi_suspend()`.
  Reachable whenever this hardware is present and `CONFIG_PM_SLEEP`. In-
  flight IRQ-mode transfer at suspend can make `spi_stop_queue()` fail;
  that is the interesting path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Many SPI drivers already check `spi_controller_suspend()`
  (omap2-mcspi, atmel, qup, rockchip, stm32, …). Same author fixed the
  ignored-return pattern in several Broadcom SPI drivers. Systematic,
  not one-off.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: Local tree is **6.18.53** (`git describe HEAD` →
  `v6.18.53-5049-g0f0bdc2b0dffb`, `VERSION=6 PATCHLEVEL=18
  SUBLEVEL=53`). At **v6.18.53**, `dspi_suspend()` still ignores the
  suspend return and `dspi_resume()` still returns from `dspi_init()`
  failure without `clk_disable_unprepare()`. Candidate `1248ec26ed99f`
  is **not** an ancestor of `v6.18.53`. Bug present.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: Pre-image on v6.18.53 matches the patch (including `#ifdef
  CONFIG_PM_SLEEP` / `SIMPLE_DEV_PM_OPS`). Expected apply: **clean**.
  `git apply --check` on current autosel HEAD fails only because the
  candidate is already sitting on this working branch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: `3d87b613d6a3c` (IRQ disable in suspend) **is** in v6.18.53.
  No other fix for ignored `spi_controller_suspend()` on this file.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: `drivers/spi/spi-fsl-dspi.c`. **IMPORTANT** (common
  NXP/Freescale SPI; not core mm/vfs). `SPI_FSL_DSPI` depends on
  `ARCH_MXC || ARCH_NXP || M5441x || COMPILE_TEST`. Kconfig: S32, VF610,
  LS1021A, ColdFire.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: File still gets platform and DMA work (S32G series in 2025).
  PM error handling itself is old and stale.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: Driver-specific: boards with Freescale DSPI that suspend.
  Embedded/i.MX/Layerscape/S32 population, not all Linux systems.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: System suspend while `spi_stop_queue()` cannot drain
  (busy/queued messages for ~5s). IRQ-mode in-flight transfer is a
  realistic trigger because `disable_irq()` runs first and
  `dspi_transfer_one_message()` uses
  `wait_for_completion(&dspi->xfer_done)`. Unprivileged users do not
  call this directly; a suspend with SPI activity can. Resume clock
  leak: `spi_controller_resume()` `-EBUSY` or `dspi_init()` `-EINVAL`
  (latter essentially unreachable after probe).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: Failed suspend that still gates clocks: possible MMIO abort /
  hang (this driver already hit “external abort on non-linefetch” when
  the IRQ ran after clocks off — `3d87b613d6a3c`). IRQ left disabled
  while the device is still active: SPI completions never fire → hung
  transfers. Resume clock leak: extra power / unbalanced clk prepare.
  **Severity: HIGH** on the suspend path (hang / abort), **MEDIUM** on
  the resume leak.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record: **Benefit:** high for DSPI suspend users — fail suspend
  instead of disabling clocks/IRQ incorrectly. **Risk:** low — 21 lines,
  error paths only, no API/struct change. If stop-queue fails, aborting
  suspend is the intended PM policy.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real ignored-error bug: teardown after failed
  `spi_controller_suspend()`.
- IRQ not restored → hung SPI (completion in `dspi_interrupt()`).
- Clock gated while the controller may still be busy → abort/hang; same
  class as the already-stable `3d87b613d6a3c` abort fix.
- Resume path clock leak on error.
- Small, local, obviously correct; SPI maintainer applied it.
- Buggy code is in v6.18.53; no extra prerequisites.
- Same class of SPI PM error-path fixes already common in-tree.

AGAINST:
- No user/syzbot report.
- Worded as “clean up”; failure is an error path, not every suspend.
- `dspi_init()` resume failure is almost unreachable.
- Sashiko pre-existing ordering notes (not introduced here).
- Incomplete undo of `spi_controller_resume()` if `dspi_init()` failed
  (dead in practice).

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ discussion not independently fetched
  (thread was recovered with b4).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mechanical error-return
   handling; applied by Mark Brown.
2. Fixes a real bug that affects users? **PASS** — IRQ/clock teardown on
   failed suspend; clk leak on resume.
3. Important issue? **PASS** — hang / possible bus abort, not a style
   nit.
4. Small and contained? **PASS** — +18/−3, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — v6.18.53 pre-image matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: Not a device-ID/quirk/DT/build/doc exception. Qualifies as a
  normal bugfix.

**Step 9.4: DECISION**

This should be backported to **this 6.18.53 tree**. The important part
is suspend: do not disable clocks and leave the IRQ off when
`spi_controller_suspend()` fails. That is a real stability bug on a
production NXP SPI controller, small enough for stable, and it applies
cleanly here.

### What the commit solves for stable users
On Freescale DSPI, suspend currently disables the IRQ, then ignores
`spi_controller_suspend()`. If the message queue does not stop
(`-EBUSY`), the driver still turns off the clock and puts pins to sleep
while reporting success. The IRQ stays disabled. That can hang in-flight
transfers (`wait_for_completion` never completes) or MMIO-abort if the
hardware is still live. Resume can also leave `clk_prepare_enable()`
unbalanced. The patch stops teardown on suspend failure and unwinds the
clock on resume failure.

### Risk vs benefit
Benefit is preventing a broken/hung SPI device and possible abort after
a failed controller suspend. Risk is confined to those error returns;
successful idle suspend is unchanged.

### Concerns
No extra commits are required. Do not confuse autosel already having
this SHA with “already selected for 6.18.y”; `v6.18.53` still has the
bug.

Verification:
- [Phase 1] Subject/body/tags from `git log -1` / `git show
  1248ec26ed99f`: no Fixes/Reported-by; Link msgid; SOB Jiawen Liu +
  Mark Brown
- [Phase 2] Diff: +18/−3 in `dspi_suspend`/`dspi_resume` only
- [Phase 3] `git blame` on v6.18.53: `c5412ec5f68773`; ignore-error PM
  since `349ad66c0ab0b`; `3d87b613d6a3c` in this tree
- [Phase 3] `git merge-base --is-ancestor 1248ec26ed99f v6.18.53` → no;
  ancestor of HEAD (autosel) → yes
- [Phase 3] Author series: several independent SPI PM error-path patches
- [Phase 4] `b4 dig -c 2543355f3da5`: patch 3/4 v1, lore msgid, applied
  to broonie for-7.3; Sashiko pre-existing notes only; no NAK
- [Phase 4] WebFetch lore/stable: 403 — UNVERIFIED stable@ thread
- [Phase 5] `spi_controller_suspend` → `spi_stop_queue` `-EBUSY`; DSPI
  IRQ path `wait_for_completion` / `dspi_interrupt`; PM ops only callers
- [Phase 6] `git describe HEAD` / Makefile: 6.18.53; v6.18.53 file
  matches patch pre-image
- [Phase 7] `SPI_FSL_DSPI` on ARCH_MXC/NXP
- [Phase 8] Failure: hung SPI / possible external abort; severity HIGH
  on suspend error path

**YES**

 drivers/spi/spi-fsl-dspi.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 83ea296597e94..1283a193b6fcc 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1464,10 +1464,18 @@ static int dspi_init(struct fsl_dspi *dspi)
 static int dspi_suspend(struct device *dev)
 {
 	struct fsl_dspi *dspi = dev_get_drvdata(dev);
+	int ret;
 
 	if (dspi->irq)
 		disable_irq(dspi->irq);
-	spi_controller_suspend(dspi->ctlr);
+
+	ret = spi_controller_suspend(dspi->ctlr);
+	if (ret) {
+		if (dspi->irq)
+			enable_irq(dspi->irq);
+		return ret;
+	}
+
 	clk_disable_unprepare(dspi->clk);
 
 	pinctrl_pm_select_sleep_state(dev);
@@ -1485,12 +1493,15 @@ static int dspi_resume(struct device *dev)
 	ret = clk_prepare_enable(dspi->clk);
 	if (ret)
 		return ret;
-	spi_controller_resume(dspi->ctlr);
+
+	ret = spi_controller_resume(dspi->ctlr);
+	if (ret)
+		goto disable_clk;
 
 	ret = dspi_init(dspi);
 	if (ret) {
 		dev_err(dev, "failed to initialize dspi during resume\n");
-		return ret;
+		goto disable_clk;
 	}
 
 	dspi_set_mtf(dspi);
@@ -1499,6 +1510,10 @@ static int dspi_resume(struct device *dev)
 		enable_irq(dspi->irq);
 
 	return 0;
+
+disable_clk:
+	clk_disable_unprepare(dspi->clk);
+	return ret;
 }
 #endif /* CONFIG_PM_SLEEP */
 
-- 
2.53.0

