Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AD45BC5DA;
	Mon, 19 Oct 2026 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418462; cv=none; b=oQ2rEKVQdYe6/4xRFE8ZV9M7KahFeYHWxaPR1FJiw02qChNZCULrEUFQagPt/Zq2LYOERaB7RvL4KUSHIbYo1StUD1qmlQo/dIGDX6WskJpDbX/W+CWR7UfZIZcOQXJv9YadikYp68ni+/yD0R+cIdTYVK0kPaZOh5SGkxbpvqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418462; c=relaxed/simple;
	bh=FUX3IQjGIME8ayk1HYjNINFEq7tElspJYcU3YBrRwcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oth0ZSGfTcK4c9RjAzqjcyOWPZSqGwrJt+c18He84/4WSc61rPT9Vf7Q043+rE0316hOdUN6KJRC15n53Q2SdovIX5G1tEtLXsk9qxLqX9OwYoWAiUJHFv/66YRB+w0YSBs+y+Waq8h7esrN0BMYJf+OVGPpmjEOfAWSvflYI5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZbAdPRW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZbAdPRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6321F000C4;
	Mon, 19 Oct 2026 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418460;
	bh=Qz0JSkSBhIzaGHZMmX3RidrcaxWvyHDYr8hqxjLYEq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZbAdPRWsDcamSDiH8taZ2FJE9yu9XnbGn6tkdgwIJUXLiIuCFN+LX6H+sTh+uUT9
	 SsosfLwtPathEAC/nXXVL1rPsBLY3No6rmXg7hxVv9AyRwyvFrWAw6lk0um7pT4kgP
	 mjJJBaRKt0ONMyBSMov8pRSapux1VBzupJewFtT7BDkQ4J+33MBoDB6Pb5lMH4//Jn
	 0bcsga9pGuk1EMocw40cXzQSdtv5t1fJWIDbCNa1zhXQFHl0N+ZgnELYoDNiV6w8I8
	 UhEGxX6pnNEweMltXfWLhxqrfXPzMme/6FPPGhTXbM45b0D9cMsB2Gfl3dxv4dJGOK
	 IV2/scegKlmvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	han.xu@nxp.com,
	haibo.chen@nxp.com,
	linux-spi@vger.kernel.org,
	imx@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] spi: nxp-fspi: disable runtime PM on probe failures
Date: Mon, 19 Oct 2026 09:49:15 -0400
Message-ID: <20261019135441.1420968-264-sashal@kernel.org>
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

[ Upstream commit 5d14285d60ba95561609a293064654a0c7d7d928 ]

nxp_fspi_probe() enables runtime PM and autosuspend before
several operations that can fail.

Some failure paths returned directly before the devm cleanup
action was installed, leaving runtime PM enabled.

Route those failures through a common runtime PM cleanup path.
Use pm_runtime_resume_and_get() for the initial clock enable.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_8FC0B8DFAF4AE67AEBA20548045D53A77707@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the leak is in this 6.18 tree, the fix is small
and self-contained, and it does not depend on later rework.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[spi: nxp-fspi]** **[disable]** disable runtime PM on probe
failures. Action is a cleanup of leftover runtime PM after
`nxp_fspi_probe()` fails.

**Step 1.2: Tags**
Record:
- `Signed-off-by: Jiawen Liu <1298662399@qq.com>` (author)
- `Link: https://patch.msgid.link/tencent_8FC0B8DFAF4AE67AEBA20548045D53
  A77707@qq.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (SPI maintainer
  applied it)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence is expected)
- Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  5d14285d60ba...]` ignored as candidate-prep markers

**Step 1.3: Body**
Record:
- **Bug:** `nxp_fspi_probe()` calls `pm_runtime_enable()` + autosuspend,
  then can fail before `devm_add_action_or_reset(..., nxp_fspi_cleanup,
  ...)`.
- **Symptom:** runtime PM left enabled after a failed probe; no
  `nxp_fspi_cleanup()` to disable it.
- **Root cause:** early `return` on clock get/put, IRQ request, and
  mutex init.
- **Fix:** common `err_disable_pm` path; switch initial get to
  `pm_runtime_resume_and_get()`.
- **Version info in message:** none.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. This is an explicit probe error-path resource-leak
fix.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/spi/spi-nxp-fspi.c` (+22 / −9)
- Function: `nxp_fspi_probe()` only
- Scope: single-file surgical error-path fix

**Step 2.2: Code flow**
Record (verified against parent of `03a9171de3f13`):

Before:
1. `pm_runtime_enable` / `use_autosuspend`
2. `pm_runtime_get_sync()` — on error, **return** (RPM stays enabled;
   usage count stays incremented because `get_sync` increments even on
   failure)
3. `pm_runtime_put_sync()` — on error, **return** (RPM stays enabled)
4. `devm_request_irq()` — on error, **return**
5. `devm_mutex_init()` — on error, **return**
6. Only later `devm_add_action_or_reset(..., nxp_fspi_cleanup)` disables
   RPM

After: those four failures `goto err_disable_pm`, which does
`pm_runtime_dont_use_autosuspend()` + `pm_runtime_disable()`. Initial
get uses `pm_runtime_resume_and_get()` so a failed resume does **not**
leave the usage count up.

`devm_add_action_or_reset` failure still returns directly: on add
failure that helper already runs `nxp_fspi_cleanup()`, which disables
RPM. That path is correct as-is.

**Step 2.3: Bug mechanism**
Record: **Error-path resource leak** (runtime PM left enabled; usage-
count leak on failed `get_sync`). Also a small **correctness** change:
`get_sync` → `resume_and_get`, matching the kernel header guidance that
`get_sync` leaves the counter incremented on error.

**Step 2.4: Fix quality**
Record: Obviously correct and minimal. Regression risk is low: only
probe-failure paths plus the get API swap. Remaining gaps (unchecked
`nxp_fspi_default_setup()`, unchecked get in `nxp_fspi_cleanup()`) are
pre-existing and not introduced here.

## Phase 3: Git history

**Step 3.1: Blame**
Record: The buggy `pm_runtime_enable` / `get_sync` / early returns come
from `97be4b919a609` ("spi: spi-nxp-fspi: enable runtime pm for fspi",
Haibo Chen, 2025-04-28). Present in v6.16 and in this tree. Cleanup
action is `9f7cd1bcb6363` ("use devm instead of remove"), also in this
tree.

**Step 3.2: Fixes: tag**
Record: No `Fixes:` tag. Introducer is `97be4b919a609` (verified via
blame). `git merge-base --is-ancestor 97be4b919a609 v6.18` succeeds.

**Step 3.3: File history**
Record: Recent work is SoC clock/DTR features, not RPM probe cleanup. No
later commit on this file after the candidate. Standalone vs this file.

**Step 3.4: Author**
Record: Jiawen Liu submitted a 4-patch SPI PM error-path series
(atcspi200, bcmbca-hsspi, fsl-dspi, nxp-fspi). Not the driver
maintainer; NXP people (Han Xu, Haibo Chen) maintain this driver. Mark
Brown applied the series.

**Step 3.5: Dependencies**
Record: Cover letter says the four patches are independent. This hunk
only needs `pm_runtime_enable`/`use_autosuspend` (present) and
`pm_runtime_resume_and_get()` (present in `include/linux/pm_runtime.h`).
Can apply standalone. Applies cleanly to this tree’s probe function.

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record:
- `b4 dig -c 5d14285d60ba95561609a293064654a0c7d7d928` → https://patch.m
  sgid.link/tencent_8FC0B8DFAF4AE67AEBA20548045D53A77707@qq.com
- Series: `[PATCH 0/4] spi: fix PM error handling in several drivers`
  (2026-06-20), **v1 only** for this commit
- Cover letter: patches are independent; local error paths only
- Frank Li: style comment only — use `PM_RUNTIME_ACQUIRE` instead of
  `goto` (not a NAK of the leak fix)
- Mark Brown applied the series to `for-7.3` as-is, including `[4/4]` as
  `5d14285d60ba`
- sashiko-bot: this patch still leaves clocks on if `put_sync` fails;
  also flagged pre-existing `default_setup` / cleanup get issues. Those
  did **not** block merge.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Mark Brown, linux-spi, Han Xu, Haibo Chen, Yogesh Gaur,
imx@lists.linux.dev, linux-arm-kernel. Right maintainers were on Cc.

**Step 4.3: Bug report**
Record: No user/syzbot report. Found by code review of probe error
paths.

**Step 4.4: Related series**
Record: Later `[PATCH v2 0/3] spi: nxp-fspi: fix runtime PM error
handling` (2026-07-28) *reworks* this fix with
`devm_pm_runtime_enable()` / `PM_RUNTIME_ACQUIRE_AUTOSUSPEND()`, plus
`default_setup` and cleanup checks. That follow-up is **not** in this
tree (`rg` found no `devm_pm_runtime_enable` in the driver). Haibo Chen
rejected `PM_RUNTIME_ACQUIRE` in cleanup. The later series is extra
hardening/style, not a revert of this leak fix.

**Step 4.5: Stable list**
Record: lore.kernel.org search returned 403; no stable-thread evidence
obtained. UNVERIFIED whether anyone nominated this on stable@
separately.

## Phase 5: Semantic analysis

**Step 5.1: Functions**
Record: `nxp_fspi_probe()` only.

**Step 5.2: Callers**
Record: Platform `.probe = nxp_fspi_probe` in this file. Runs at device
bind / deferred probe, not from a syscall hot path.

**Step 5.3: Callees**
Record: `pm_runtime_resume_and_get`, `pm_runtime_put_sync`,
`devm_request_irq`, `devm_mutex_init`,
`pm_runtime_dont_use_autosuspend`, `pm_runtime_disable`. Runtime resume
enables clocks via `nxp_fspi_clk_prep_enable()`.

**Step 5.4: Reachability**
Record: Yes, from device probe on `CONFIG_SPI_NXP_FLEXSPI`
(i.MX8/i.MX9/Layerscape FlexSPI). Trigger is a **failed** probe after
RPM enable (clock resume fail, put fail, IRQ request fail, mutex init
fail). Not unprivileged userspace on a working board.

**Step 5.5: Similar patterns**
Record: Same author fixed other SPI PM error paths. `spi-rockchip.c`
already has `err_disable_pm_runtime`. This is a known driver pattern.

## Phase 6: Local tree (this checkout)

**Step 6.1: Does the bug exist here?**
Record:
- Tree: `v6.18.53-5049-g0f0bdc2b0dffb`, `Makefile` 6.18.53, branch
  `autosel`
- Buggy sequence exists in `03a9171de3f13^` (`pm_runtime_get_sync` +
  early returns after `pm_runtime_enable`)
- Introduced by `97be4b919a609`, ancestor of v6.18
- Driver file and RPM enablement are present

**Step 6.2: Backport difficulty**
Record: **Clean apply**. Context matches this tree (`device_set_node`
and DTR caps are already here). `pm_runtime_resume_and_get()` exists.

**Step 6.3: Related fixes already here?**
Record: No other probe RPM-disable fix. Later v2 rework is not present.
`nxp_fspi_cleanup()` still disables RPM only after successful
`devm_add_action_or_reset`.

## Phase 7: Subsystem context

**Step 7.1:** `drivers/spi/` — NXP FlexSPI (`CONFIG_SPI_NXP_FLEXSPI`).
Criticality: **IMPORTANT** for i.MX/Layerscape boards (often the
boot/SPI-NOR controller), **PERIPHERAL** for everyone else.

**Step 7.2:** Actively maintained (clock/DTR/DLL work through
2025–2026). RPM itself is from 6.16-era, so the leak has been in 6.18
for the life of this driver feature.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Users of NXP FlexSPI (`nxp,imx8mm-fspi`, `imx8mp`, `imx8ulp`,
`imx93`, `imx95`, `lx2160a-fspi`, etc.) when probe fails after RPM is
enabled.

**Step 8.2: Trigger**
Record: Failed probe after `pm_runtime_enable()`. Not every boot. Clock
resume failure is the important case: old `get_sync` leaves `usage_count
> 0` and RPM enabled, so a later bind hits `pm_runtime_enable()` on an
already-enabled device (WARN). IRQ/mutex failures after a successful put
leave RPM enabled on an unbound device.

Cannot be triggered by an unprivileged user on a healthy probe path.

**Step 8.3: Failure mode**
Record:
- Runtime PM enabled after failed bind
- Failed `get_sync`: usage-count leak, device stuck “active”
- Re-probe: `pm_runtime_enable()` WARN
- Autosuspend still armed if put succeeded before a later failure

Severity: **MEDIUM** (probe error path, not a success-path
crash/corruption). Still a real leak/WARN class that stable regularly
takes.

**Step 8.4: Risk-benefit**
Record:
- **Benefit:** Medium for i.MX/Layerscape; stops leftover RPM state and
  usage-count leak on failed probe.
- **Risk:** Low (~20 lines, error path only, recommended PM helper).
- Ratio supports backport.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real probe error-path leak: RPM enabled before `nxp_fspi_cleanup` is
  installed
- `pm_runtime_get_sync()` on failure leaks the usage count;
  `resume_and_get` + disable is the right fix
- Small, obviously correct, no new API
- Bug present since RPM was added (`97be4b919a609`), which is in this
  6.18 tree
- SPI maintainer applied it; cover letter says the series is independent
- Driver is used on common NXP boards

AGAINST:
- No crash/syzbot/user report; probe-failure only
- Incomplete vs later review (ignored `nxp_fspi_default_setup()`,
  cleanup get)
- Frank Li preferred helpers over `goto` (style; not a functional NAK)

UNRESOLVED:
- Could not fetch lore.kernel.org (403); discussion recovered via `b4
  dig -m` and lkml.iu.edu
- No stable@ thread found

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — maintainer applied; logic
   matches PM docs
2. Real user-visible bug? **PASS** — leftover RPM / usage-count leak /
   re-probe WARN
3. Important? **PASS** — resource leak that can WARN and leave PM state
   wrong; not a success-path panic, but standard driver-core leak
4. Small and contained? **PASS** — one function, +22/−9
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — buggy code and helpers are here

**Step 9.3: Exception category**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary error-
path leak fix.

**Step 9.4: Decision**
This 6.18 tree has the leak. The patch is a small, correct disable of
runtime PM on probe failures, with the right `resume_and_get` pairing.
Later optional rework is not a reason to skip this.

### What it solves for stable users
On NXP FlexSPI, probe currently enables runtime PM, then can return on
clock/IRQ/mutex failure before the devm cleanup action. That leaves RPM
enabled (and, with `get_sync`, an elevated usage count). A later bind
can WARN. The patch disables RPM on those paths.

### Risk vs benefit
Low risk, clear benefit on a widely used embedded SPI-NOR controller. No
prerequisites beyond code already in 6.18.

---

Verification:
- [Phase 1] Parsed tags: author Jiawen Liu, Link msgid, SOB Mark Brown;
  no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: `nxp_fspi_probe()` +22/−9; four early returns →
  `err_disable_pm`; `get_sync` → `resume_and_get`
- [Phase 2] Confirmed `pm_runtime_get_sync` increments usage even on
  error (`include/linux/pm_runtime.h`); `resume_and_get` does not
- [Phase 3] `git describe HEAD` / `make kernelversion`: **6.18.53**,
  branch `autosel`
- [Phase 3] `git blame` on parent: leak from `97be4b919a609`
  (2025-04-28)
- [Phase 3] `git merge-base --is-ancestor 97be4b919a609 v6.18`: yes
  (also in v6.16)
- [Phase 3] Parent probe still has `get_sync` + bare returns after
  `pm_runtime_enable`
- [Phase 4] `b4 dig -c 5d14285d60ba`: PATCH 4/4, lore msgid above
- [Phase 4] `b4 dig -a`: v1 only for this commit
- [Phase 4] `b4 dig -w`: Mark Brown, Han Xu, Haibo Chen, linux-spi, imx
  list
- [Phase 4] mbox: Frank Li style comment; Mark Brown applied 4/4 to
  for-7.3; cover letter says independent
- [Phase 4] Later v2 rework (Jul 2026) not in this tree
- [Phase 5] Probe is platform `.probe`; Kconfig `SPI_NXP_FLEXSPI` for
  i.MX/Layerscape
- [Phase 6] `pm_runtime_resume_and_get` exists; patch context matches
  local probe
- [Phase 8] Failure mode: RPM leak / usage-count leak / re-probe WARN,
  not a hot-path oops
- UNVERIFIED: lore.kernel.org HTTP 403; no dedicated stable@ discussion
  found

**YES**

 drivers/spi/spi-nxp-fspi.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index b504a5c86692a..0300f4ae1455d 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1426,9 +1426,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	pm_runtime_use_autosuspend(dev);
 
 	/* enable clock */
-	ret = pm_runtime_get_sync(f->dev);
-	if (ret < 0)
-		return dev_err_probe(dev, ret, "Failed to enable clock");
+	ret = pm_runtime_resume_and_get(f->dev);
+	if (ret < 0) {
+		ret = dev_err_probe(dev, ret, "Failed to enable clock");
+		goto err_disable_pm;
+	}
 
 	/* Clear potential interrupts */
 	reg = fspi_readl(f, f->iobase + FSPI_INTR);
@@ -1438,18 +1440,24 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	nxp_fspi_default_setup(f);
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret < 0)
-		return dev_err_probe(dev, ret, "Failed to disable clock");
+	if (ret < 0) {
+		ret = dev_err_probe(dev, ret, "Failed to disable clock");
+		goto err_disable_pm;
+	}
 
 	init_completion(&f->c);
 	ret = devm_request_irq(dev, irq,
 			nxp_fspi_irq_handler, 0, pdev->name, f);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to request irq\n");
+	if (ret) {
+		ret = dev_err_probe(dev, ret, "Failed to request irq\n");
+		goto err_disable_pm;
+	}
 
 	ret = devm_mutex_init(dev, &f->lock);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to initialize lock\n");
+	if (ret) {
+		ret = dev_err_probe(dev, ret, "Failed to initialize lock\n");
+		goto err_disable_pm;
+	}
 
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = NXP_FSPI_MAX_CHIPSELECT;
@@ -1467,6 +1475,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		return ret;
 
 	return devm_spi_register_controller(&pdev->dev, ctlr);
+
+err_disable_pm:
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static int nxp_fspi_runtime_suspend(struct device *dev)
-- 
2.53.0

