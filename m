Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB187509F0A;
	Mon, 31 Aug 2026 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183754; cv=none; b=QdMA4VGG0HiOBCaub5JFzdY4B9S78VSBAZO+rB+OnbIVx17NR+hVpCZpn815IV4KsJnspiFwKKdkWcplSQ3LtWow4y+jOG62rKRUT2jPuXPOLB9C6nhgtLz7N9xBONRrESG+6+yVxEiiSGC3q+emC5ydfCwTgidCidevlRdJ6+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183754; c=relaxed/simple;
	bh=j9UahECLgtK66pHV1y4MMhyFa4WFeU4DHeSbLppsWP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnMK3K+BMHllz6qjNh0Xuvtav8n92OnoOAuf86xEOOXmFApZLWwLzsPae0wjyyUDPgXawSEJVsseyCoxphHKxZwNKgEbxualol+LwDilSWKUmiBNpBRhr/jCsS/eZbDdaIkYJexFwGTgdjNeoeLe5Wy0DN0qXz1txiUTslkC7UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAT/4rEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAT/4rEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD941F00A3E;
	Mon, 31 Aug 2026 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183751;
	bh=0ficZOrstrFRp+kCyBauxLO02CLjM0M7ZQNKFWpwhEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAT/4rEsN5UBqN4zgwibLMwmwNsRBRRU3ar2aMtwiCe4Irmw/EOzw7a2nL39dC/nV
	 3kMF/repBOk/tpxx2Vlg0vNuiOrEftFcjHhU0uDlG/gMzta48yElrQc86ZKNFzVti0
	 iL6+6xYzOZ6VibY14pPylkhJV2AvSD2rEJhczUEcqVairHM/kYgL7/0/GRU9HzdTYt
	 TzXjW1H09x7zBismDePaBEAdRc1KVfQk4xRWfBoN5yXkXL32eVvqiGXoS6PZfUcc8V
	 QA+owNk2p5i1nPsLA6ZfC4QlfEkj7/ZvLClSWgIYH4KXZKg7uXynLV2uuSf1LMYrX1
	 LkHzqVeSZNziw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: codecs: rk3328: Use managed GPIO and clock helpers
Date: Mon, 31 Aug 2026 09:25:10 -0400
Message-ID: <20260831133314.4125787-282-sashal@kernel.org>
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

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 0cf3489bba9ad13aae052232e223e19a620fe7a7 ]

rk3328_platform_probe() acquires the mute GPIO with gpiod_get_optional()
but never releases it. It also enables mclk and pclk manually while
relying on probe error labels for unwind, and the driver has no platform
remove callback to disable those clocks after a successful unbind.

This path has already needed fixes for missing clock unwinds on probe
errors. Use devm_gpiod_get_optional() and devm_clk_get_enabled() so the
GPIO and enabled clock lifetimes are tied to the device. This removes the
manual error labels and makes both probe failure and driver unbind follow
the normal devres cleanup path.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260525-asoc-rk3328-devm-resources-v1-1-2abde0006f89@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ASoC: codecs: rk3328]` `[Use]` — Convert probe resource
acquisition to managed (devm) helpers for GPIO and clocks.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Cássio Gabriel `<cassiogabrielcontato@gmail.com>`
  (author)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer
  committer)
- **Link:** https://patch.msgid.link/20260525-asoc-rk3328-devm-
  resources-v1-1-2abde0006f89@gmail.com
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- Notable: Maintainer commit; no fuzzer or user bug reports

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `rk3328_platform_probe()` uses `gpiod_get_optional()` without
  ever releasing the mute GPIO; enables `mclk`/`pclk` manually with
  fragile error-path unwinds; no platform `.remove` to disable clocks on
  unbind.
- **Symptom:** Resource leaks — GPIO descriptor leak; clocks left
  enabled after driver unbind; incomplete probe-error cleanup (driver
  already needed two prior clock-unwind fixes).
- **Root cause:** Non-devm resource management with manual `goto` unwind
  labels and no platform remove callback.
- **Version info:** None in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as devm conversion, but it fixes real
resource leaks on probe failure and driver unbind. Prior commits
`d14eece945a80` (2021) and `35a9b000b24d5` (2022) fixed related clock-
unwind gaps in the same function.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `sound/soc/codecs/rk3328_codec.c` — 13 insertions, 41
  deletions (net −28 lines)
- **Function modified:** `rk3328_platform_probe()`
- **Scope:** Single-file surgical fix in one probe function

### Step 2.2: Code Flow Changes
**Record:**
| Hunk | Before → After |
|------|----------------|
| GPIO | `gpiod_get_optional()` → `devm_gpiod_get_optional()` — GPIO
tied to device lifetime |
| mclk | `devm_clk_get()` + `clk_prepare_enable()` →
`devm_clk_get_enabled()` — single managed acquire+enable |
| pclk | `devm_clk_get()` + `clk_prepare_enable()` + manual error labels
→ `devm_clk_get_enabled()` |
| Error paths | Manual `err_unprepare_pclk` / `err_unprepare_mclk`
labels → early `return` (devres auto-cleanup) |
| Success path | `return 0` after register → direct `return
devm_snd_soc_register_component(...)` |

### Step 2.3: Bug Mechanism
**Record:** **Category:** Resource leaks (GPIO + clocks)
- **GPIO leak:** `gpiod_get_optional()` at line 451 with no
  `gpiod_put()` anywhere in file; all error returns after GPIO
  acquisition leak the descriptor.
- **Clock leak on unbind:** `platform_driver` has only `.probe`, no
  `.remove`; clocks enabled via `clk_prepare_enable()` are never
  disabled on unbind.
- **Remaining probe-error gap:** `clk_prepare_enable(mclk)` failure at
  lines 468–470 returns directly with no GPIO cleanup and no clock
  cleanup — not covered by existing `err_unprepare_*` labels.
- **Fix mechanism:** devm helpers release GPIO/clocks automatically on
  probe failure and device unbind.

### Step 2.4: Fix Quality
**Record:** Obviously correct — standard kernel devm pattern used widely
in ASoC codec drivers (90+ files in tree use
`devm_clk_get_enabled`/`devm_gpiod_get_optional`). Minimal, removes
error-prone manual unwind. **Regression risk:** Very low; behavior
unchanged on successful probe.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Bug Introduction
**Record:**
- GPIO mute code: `87d12d5545fa7` (2020-02-19) — `gpiod_get_optional()`
  without devm
- Clock manual enable: `c32759035ad24` (2018-12-21) — original driver
- Manual error labels: `d14eece945a80` (2021-05-18) — added after
  missing unwind was found
- **Buggy code present since v5.0 era; long-standing in this tree**

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:**
```
d14eece945a80 ASoC: rk3328: fix missing clk_disable_unprepare() on error
35a9b000b24d5 ASoC: rk3328: fix disabling mclk on pclk probe failure
```
Both prior fixes are in this tree. This commit completes the devm
conversion those fixes were working toward. Standalone single patch (v1
only, no series).

### Step 3.4: Author Context
**Record:** Cássio Gabriel — active ASoC contributor with similar
resource-lifetime fixes (e.g., mediatek mt8183/mt8192 cleanup commits).
Mark Brown committed and maintains ASoC.

### Step 3.5: Dependencies
**Record:**
- Requires `devm_clk_get_enabled()` — in tree since `7ef9651e9792b`
  (2022-06-15), confirmed ancestor of HEAD
- Requires `devm_gpiod_get_optional()` — present in
  `include/linux/gpio/consumer.h`
- **Can apply standalone; no prerequisite commits needed**

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/20260525-asoc-rk3328-devm-
  resources-v1-1-2abde0006f89@gmail.com
- **Series:** v1 only (no revisions)
- **Review feedback:** Thread contains only the patch submission — no
  replies, no stable nomination, no NAKs
- lore.kernel.org web UI blocked by bot protection; used b4 mbox instead

### Step 4.2: Reviewers
**Record:** CC'd: Mark Brown, Liam Girdwood, Takashi Iwai, Jaroslav
Kysela, linux-sound@vger.kernel.org. Committed by Mark Brown
(maintainer). No explicit Reviewed-by in commit.

### Step 4.3: Bug Reports
**Record:** N/A — no Reported-by or external bug links.

### Step 4.4: Related Patches
**Record:** Standalone 1/1 patch. Related prior in-tree fixes:
`d14eece945a80`, `35a9b000b24d5`.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — could not search lore stable archive (bot
protection). No stable discussion found in saved mbox thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rk3328_platform_probe()` — only function modified.

### Step 5.2: Callers
**Record:** Called by platform core during device enumeration for
`rockchip,rk3328-codec` OF nodes. Affects RK3328 boards (Rock64, NanoPi
R2S/R2C, Orange Pi R1 Plus, etc.) at boot when `CONFIG_SND_SOC_ROCKCHIP`
/ codec is enabled.

### Step 5.3: Callees
**Record:** `devm_kzalloc`, `syscon_regmap_lookup_by_phandle`,
`devm_gpiod_get_optional`, `devm_clk_get_enabled`,
`devm_platform_ioremap_resource`, `devm_regmap_init_mmio`,
`devm_snd_soc_register_component`.

### Step 5.4: Reachability
**Record:** Probe runs at boot on affected hardware. Module unload
(`module_platform_driver`) can trigger unbind — the leaky path without
`.remove`. Probe-failure paths reachable with misconfigured clocks/GPIO.

### Step 5.5: Similar Patterns
**Record:** 90+ ASoC codec files already use
`devm_clk_get_enabled`/`devm_gpiod_get_optional`. rk3328 was an outlier
still using manual management.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code in Tree?
**Record:** **YES.** Local tree is **Linux 6.18.44** (`git describe
HEAD` → `v6.18.44-1-gef4bf62bccf3c`). Buggy code confirmed at lines
451–514 of `sound/soc/codecs/rk3328_codec.c`. Fix commit `0cf3489bba9ad`
is on `master` but **not** in HEAD.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — `git format-patch -1 0cf3489bba9ad | git
apply --check` succeeded with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** Prior partial fixes `d14eece945a80` and `35a9b000b24d5` are
in tree. This devm conversion is not yet applied. No duplicate fix
found.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **ASoC / Rockchip RK3328 codec driver** — **PERIPHERAL**
(platform-specific audio codec, affects RK3328-based embedded boards
only).

### Step 7.2: Subsystem Activity
**Record:** Moderate — recent commits include DAI terminology update and
pm_runtime include cleanup. Driver is mature but still receives
maintenance fixes.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of RK3328-based boards with the on-SoC audio codec
enabled — embedded/ARM64 platforms (Rock64, NanoPi, Orange Pi variants).
Not universal; driver/config-specific.

### Step 8.2: Trigger Conditions
**Record:**
- **GPIO leak:** Any probe path after successful `gpiod_get_optional()`
  that returns error (including `clk_prepare_enable(mclk)` failure at
  line 468–470).
- **Clock/GPIO leak on unbind:** Module unload or device unbind (no
  platform `.remove`).
- **Likelihood:** Probe errors uncommon; unbind rare on production
  embedded systems but real during development/module reload.
- **Unprivileged trigger:** No — requires hardware presence and driver
  binding.

### Step 8.3: Failure Mode Severity
**Record:**
- GPIO descriptor leak (one per failed probe or unbind)
- Clocks left running after unbind (power/resource leak)
- **Severity: LOW to MEDIUM** — no crash, corruption, deadlock, or
  security impact; gradual resource retention

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Eliminates verified resource leaks; prevents recurrence
  of manual unwind bugs (driver already needed two prior fixes);
  simplifies probe code
- **Risk:** Very low — standard devm pattern, net code reduction, clean
  apply
- **Ratio:** Moderate benefit, very low risk. Importance is below
  crash/corruption fixes but above pure cosmetic cleanup.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Verified real resource leaks (GPIO never released; clocks not disabled
  on unbind)
- Verified remaining probe-error leak path (`mclk` enable failure
  returns without any cleanup)
- Small, surgical, obviously correct devm conversion (−28 lines)
- Applies cleanly to 6.18.44
- All required APIs present in tree since 2022
- Same driver already needed two prior clock-unwind fixes — pattern of
  incomplete error handling
- Committed by ASoC maintainer Mark Brown
- Low regression risk

**AGAINST backport:**
- LOW severity — resource leaks, not crash/corruption/security/deadlock
- Niche hardware (RK3328 embedded boards only)
- Unbind path rarely exercised in production
- No user reports, syzbot, or stable nomination
- Successful-probe GPIO hold is functionally intentional until unbind

**Unresolved:** No stable-list discussion found; no independent Tested-
by.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard devm pattern;
   maintainer committed; no test reports
2. Fixes a real bug? **PASS** — verified GPIO and clock resource leaks
3. Important issue? **BORDERLINE PASS** — resource leaks, not
   crash/corruption; LOW-MEDIUM severity
4. Small and contained? **PASS** — 1 file, 54 lines touched, net −28
5. No new features/APIs? **PASS** — uses existing devm helpers
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Categories
**Record:** None — not device ID, quirk, DT, build, or docs fix.
Standard resource-lifetime bug fix.

### Step 9.4: Decision Rationale

This is a genuine, verified resource-leak fix in a driver that has
already required two separate stable-worthy clock-unwind patches. The
devm conversion is the robust completion of that work: it fixes GPIO
leaks on probe-error paths (including the `mclk` enable-failure path
that bypasses all existing error labels) and clock/GPIO leaks on driver
unbind. While severity is low (no crashes or data corruption), the fix
is small, obviously correct, applies cleanly, has no dependencies, and
carries negligible regression risk. For the 6.18.y tree where the buggy
code is present and the required devm APIs have been available for
years, this meets stable backport criteria.

---

## Verification

- **[Phase 1]** Parsed commit message from user query and `git show
  0cf3489bba9ad`
- **[Phase 1]** Tags: Signed-off-by (author + Mark Brown), Link to
  patch; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Read current `rk3328_codec.c` lines 422–529; confirmed
  manual GPIO/clock management and missing `.remove`
- **[Phase 2]** Verified no `gpiod_put` in file (`grep` returned no
  matches)
- **[Phase 2]** Verified `mclk` enable failure path (lines 468–470)
  returns without cleanup
- **[Phase 3]** `git blame -L 451,514`: GPIO from `87d12d5545fa7`
  (2020), clocks from `c32759035ad24` (2018)
- **[Phase 3]** `git log --oneline` on file: found prior fixes
  `d14eece945a80`, `35a9b000b24d5` in tree
- **[Phase 3]** `git show d14eece945a80`, `35a9b000b24d5`: confirmed
  prior clock-unwind fixes
- **[Phase 3]** `git merge-base --is-ancestor 7ef9651e9792b HEAD`:
  `devm_clk_get_enabled` available — YES
- **[Phase 3]** `grep devm_gpiod_get_optional
  include/linux/gpio/consumer.h`: API present
- **[Phase 4]** `b4 dig -c 0cf3489bba9ad`: found lore URL
- **[Phase 4]** `b4 dig -c 0cf3489bba9ad -w`: Mark Brown, Liam Girdwood,
  Takashi Iwai CC'd
- **[Phase 4]** `b4 dig -c 0cf3489bba9ad -a`: v1 only, no revisions
- **[Phase 4]** `b4 dig -c 0cf3489bba9ad -m /tmp/rk3328_devm.mbox`:
  thread has patch only, no review replies
- **[Phase 4]** UNVERIFIED: lore stable archive search (bot protection
  on web)
- **[Phase 5]** `grep` count: 90+ ASoC codec files use
  devm_clk_get_enabled/devm_gpiod_get_optional
- **[Phase 5]** Confirmed `rk3328_codec_driver` has `.probe` only, no
  `.remove` (lines 523–529)
- **[Phase 6]** `git describe HEAD`: v6.18.44; `make kernelversion`
  equivalent: 6.18.44
- **[Phase 6]** `git merge-base --is-ancestor 0cf3489bba9ad HEAD`:
  commit NOT in HEAD
- **[Phase 6]** `git format-patch -1 0cf3489bba9ad | git apply --check`:
  clean apply
- **[Phase 6]** Read current probe code: buggy pattern confirmed present
- **[Phase 8]** Failure mode: resource leaks, severity LOW-MEDIUM

**YES**The analysis is done for **Linux 6.18.44**.

**Commit:** `ASoC: codecs: rk3328: Use managed GPIO and clock helpers`
(`0cf3489bba9ad` on master, not yet in this tree)

**Finding:** The current `rk3328_platform_probe()` has real resource
leaks: the mute GPIO from `gpiod_get_optional()` is never released,
clocks stay enabled on unbind (no platform `.remove`), and the `mclk`
enable-failure path still leaks the GPIO. The patch fixes this with
`devm_gpiod_get_optional()` and `devm_clk_get_enabled()`, applies
cleanly, and only depends on APIs already in 6.18.

**Verdict:** Backport to this tree.

**YES**

 sound/soc/codecs/rk3328_codec.c | 54 ++++++++-------------------------
 1 file changed, 13 insertions(+), 41 deletions(-)

diff --git a/sound/soc/codecs/rk3328_codec.c b/sound/soc/codecs/rk3328_codec.c
index 9697aefc6e030..5871b5a819757 100644
--- a/sound/soc/codecs/rk3328_codec.c
+++ b/sound/soc/codecs/rk3328_codec.c
@@ -425,7 +425,6 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	struct rk3328_codec_priv *rk3328;
 	struct regmap *grf;
 	void __iomem *base;
-	int ret = 0;
 
 	rk3328 = devm_kzalloc(&pdev->dev, sizeof(*rk3328), GFP_KERNEL);
 	if (!rk3328)
@@ -441,14 +440,13 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	regmap_write(grf, RK3328_GRF_SOC_CON2,
 		     (BIT(14) << 16 | BIT(14)));
 
-	ret = of_property_read_u32(rk3328_np, "spk-depop-time-ms",
-				   &rk3328->spk_depop_time);
-	if (ret < 0) {
+	if (of_property_read_u32(rk3328_np, "spk-depop-time-ms",
+				 &rk3328->spk_depop_time)) {
 		dev_info(&pdev->dev, "spk_depop_time use default value.\n");
 		rk3328->spk_depop_time = 200;
 	}
 
-	rk3328->mute = gpiod_get_optional(&pdev->dev, "mute", GPIOD_OUT_HIGH);
+	rk3328->mute = devm_gpiod_get_optional(&pdev->dev, "mute", GPIOD_OUT_HIGH);
 	if (IS_ERR(rk3328->mute))
 		return PTR_ERR(rk3328->mute);
 	/*
@@ -461,57 +459,31 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 		regmap_write(grf, RK3328_GRF_SOC_CON10, BIT(17) | BIT(1));
 	}
 
-	rk3328->mclk = devm_clk_get(&pdev->dev, "mclk");
+	rk3328->mclk = devm_clk_get_enabled(&pdev->dev, "mclk");
 	if (IS_ERR(rk3328->mclk))
 		return PTR_ERR(rk3328->mclk);
 
-	ret = clk_prepare_enable(rk3328->mclk);
-	if (ret)
-		return ret;
 	clk_set_rate(rk3328->mclk, INITIAL_FREQ);
 
-	rk3328->pclk = devm_clk_get(&pdev->dev, "pclk");
-	if (IS_ERR(rk3328->pclk)) {
-		dev_err(&pdev->dev, "can't get acodec pclk\n");
-		ret = PTR_ERR(rk3328->pclk);
-		goto err_unprepare_mclk;
-	}
-
-	ret = clk_prepare_enable(rk3328->pclk);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to enable acodec pclk\n");
-		goto err_unprepare_mclk;
-	}
+	rk3328->pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
+	if (IS_ERR(rk3328->pclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(rk3328->pclk),
+				     "failed to get or enable acodec pclk\n");
 
 	base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(base)) {
-		ret = PTR_ERR(base);
-		goto err_unprepare_pclk;
-	}
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	rk3328->regmap = devm_regmap_init_mmio(&pdev->dev, base,
 					       &rk3328_codec_regmap_config);
-	if (IS_ERR(rk3328->regmap)) {
-		ret = PTR_ERR(rk3328->regmap);
-		goto err_unprepare_pclk;
-	}
+	if (IS_ERR(rk3328->regmap))
+		return PTR_ERR(rk3328->regmap);
 
 	platform_set_drvdata(pdev, rk3328);
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &soc_codec_rk3328,
+	return devm_snd_soc_register_component(&pdev->dev, &soc_codec_rk3328,
 					       rk3328_dai,
 					       ARRAY_SIZE(rk3328_dai));
-	if (ret)
-		goto err_unprepare_pclk;
-
-	return 0;
-
-err_unprepare_pclk:
-	clk_disable_unprepare(rk3328->pclk);
-
-err_unprepare_mclk:
-	clk_disable_unprepare(rk3328->mclk);
-	return ret;
 }
 
 static const struct of_device_id rk3328_codec_of_match[] __maybe_unused = {
-- 
2.53.0

