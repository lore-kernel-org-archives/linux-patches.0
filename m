Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C954FB9D4;
	Mon, 31 Aug 2026 13:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183692; cv=none; b=RxUuXApntzdl9kETRtL9SvPmpVoPwGFUZLykSN9AwvDGmgF4Zfi5epX8SASL89Ss+WPDV/ATy05kWtHOZ7TT645nSVLX4EAGbcte42b967EgvpukAmgAkEX5slMV3R9p6ApV+vm4yDQxKNiTL+O8tKM3yiSaDCZgiNvQjiVXK5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183692; c=relaxed/simple;
	bh=PUm7uMgdUV3Rb8tefvy5CYz6eu3nuqdKgTzNHDgciOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oW78fEtW+Drzazx2qx5U7EyDe7mH2bmGIUoOHVw5GDnQ4aMbqI4U+WRU4CfoG8FuInlNYlw3+zGOnCYrehtWjR45kds8cD3UKZAmaPnRkTo7yH/db1ImGdzTKPg8tAlzwn7NedeWGBABCYFa710bRYTgQlQdW7kZLcgJY6MpPao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvoYp6YJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvoYp6YJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FA21F000E9;
	Mon, 31 Aug 2026 13:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183689;
	bh=XDqSKgGV//gQU+mzSlxLV5q54IoLXRRkDEmhxgLCrFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvoYp6YJIFbPqWs34nSrA8OhiYB0vZ7nJbjxh7TNix8aJfnKOB9uiajTmmtj+tBp6
	 6Gd8O83gYjKeyZWyyUFZkmmvjE68M7DSs/x+qat1iUW0zSCVotQPi9DcYB4iH4lrSK
	 vRVqi1FeWuFaa+PxfTHR7FQZfM5N0bQJ+27kD9esg8JSlQRmW+pi0vNXgf6D6b6c03
	 0fP+vAzEWGeG70p/ZrZibAS6bYpGMGRft5l5CLmM8rADHtWmoM1kyifVLPBxrNVVdc
	 bL+u0qmRaDpaMHzJfhcDnvCFzBGpMsl0VLyVe58C+0Q/XNHi6fzpnNptSQtKia1GII
	 GJl9FUp62TMhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rudi Heitbaum <rudi@heitbaum.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: rt5645: Perform the initial jack detect at probe
Date: Mon, 31 Aug 2026 09:24:34 -0400
Message-ID: <20260831133314.4125787-246-sashal@kernel.org>
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

From: Rudi Heitbaum <rudi@heitbaum.com>

[ Upstream commit 54b279699279411c77c8afbc73b83c70740a7303 ]

The only initial jack detect is the rt5645_irq(0, rt5645) at the end of
rt5645_set_jack_detect(). A card described with simple-audio-card has no
machine driver to call that, so jack state is only ever sampled from an
edge on hp-detect-gpios.

A headphone already in the socket at boot is therefore never noticed, and
the card is silent with every mixer control set correctly.
rt5645_jack_detect() is what force enables the "LDO2" and "Mic Det Power"
supplies that the "HP amp" widget depends on, and what programs
RT5645_CHARGE_PUMP away from its reset value, so without it "HP amp"
cannot power up. Unplugging and replugging the jack is the only way to
recover.

Do the detect at the end of the component probe when the driver owns a
hp-detect GPIO and the codec's own jack detect is unused, which is the
case that has no other trigger. A machine driver calling
rt5645_set_jack_detect() later just repeats it.

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
Link: https://patch.msgid.link/anNU3tOUR7rOReSB@5e001e58230e
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[ASoC: rt5645]` `[Perform]` — Perform initial headphone
jack detection during component probe for GPIO-based jack-detect setups
without a machine driver.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Rudi Heitbaum `<rudi@heitbaum.com>` (author)
- **Link:** https://patch.msgid.link/anNU3tOUR7rOReSB@5e001e58230e
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer,
  committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer ack/applied; no syzbot or multi-reporter tags

### Step 1.3: Body analysis
**Record:**
- **Bug:** With `simple-audio-card` (no machine driver calling
  `rt5645_set_jack_detect()`), jack state is only sampled on GPIO edge
  transitions. Headphones already inserted at boot are never detected.
- **Symptom:** Card is silent despite correct mixer settings;
  unplug/replug is the only recovery.
- **Root cause:** `rt5645_jack_detect()` enables `LDO2`, `Mic Det
  Power`, and programs `RT5645_CHARGE_PUMP` — required for the `HP amp`
  DAPM widget. Without an initial detect, HP amp cannot power up.
- **Fix approach:** Call `rt5645_irq(0, rt5645)` at end of
  `rt5645_probe()` when `jd_mode == 0` and codec `hp-detect` GPIO is
  present.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — clearly a functional bug fix disguised as
initialization. Not cleanup or optimization; restores missing probe-time
hardware setup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/soc/codecs/rt5645.c` (+4 lines, 0 removed)
- **Function modified:** `rt5645_probe()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `rt5645_probe()` returns after EQ param allocation with no
  jack detect when using external GPIO (`jd_mode == 0`).
- **After:** When `!rt5645->pdata.jd_mode && rt5645->gpiod_hp_det`,
  calls `rt5645_irq(0, rt5645)`, which queues `jack_detect_work` (250 ms
  delay), reads GPIO, and runs `rt5645_jack_detect()` to power codec
  paths.
- **Path affected:** Component probe initialization for GPIO jack-detect
  configurations.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness — missing initialization
- **Mechanism:** Initial jack detect only happened via
  `rt5645_set_jack_detect()` → `rt5645_irq(0, rt5645)`. Cards without a
  machine driver never trigger this; GPIO edges after boot are the only
  other trigger, so a pre-inserted jack is missed and HP power path
  stays off.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: reuses the existing `rt5645_irq()` →
  `rt5645_jack_detect_work()` → `rt5645_jack_detect()` path already used
  by `rt5645_set_jack_detect()`.
- Minimal and self-contained.
- **Regression risk:** Low. `snd_soc_jack_report()` safely no-ops on
  NULL jack (`if (!jack || !jack->jack) return;`). Machine drivers that
  call `rt5645_set_jack_detect()` later simply repeat detection, per
  commit message. Condition limits scope to `jd_mode == 0` with codec
  `hp-detect` GPIO.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Probe return path (lines 3493–3500) dates to 2018 (EQ param)
and 2021 (ENOMEM check). Missing initial detect is longstanding. GPIO
hp-detect path via `gpiod_hp_det` since commit `0b0cefc8fd105` (2015).
`jd_mode == 0` GPIO path in `rt5645_jack_detect_work()` since
`6e747d5311fc6` (2015).

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent rt5645 changes in this tree include deadlock fix
(`6ef5d5b92f711`), DMI quirks, push-button fixes.
`rt5645_set_jack_detect()` added in `f3fa1bbd836a7` (2014); `set_jack`
component callback in `7f6ecc220272d` (2023). Standalone one-patch fix,
not part of a series.

### Step 3.4: Author context
**Record:** Rudi Heitbaum is an active embedded/DRM contributor; this is
his first rt5645 change in this tree. Mark Brown (maintainer) committed
it to mainline as `54b2796992794`.

### Step 3.5: Dependencies
**Record:** No prerequisites. All symbols (`rt5645_irq`, `gpiod_hp_det`,
`jd_mode`) exist in this tree. `git apply --check` on mainline patch
succeeds cleanly.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/anNU3tOUR7rOReSB@5e001e58230e
- **Series:** v1 only (single patch)
- **Feedback:** Mark Brown applied to `for-7.2` sound tree; no NAKs, no
  stable nomination in thread
- Thread saved via `b4 dig -m /tmp/rt5645-jack.mbox`

### Step 4.2: Reviewers
**Record:** CC'd: `lgirdwood@gmail.com`, `broonie@kernel.org`, `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug described in
commit message from author's platform experience.

### Step 4.4: Related patches
**Record:** Standalone; no series dependencies.

### Step 4.5: Stable list
**Record:** Not searched (lore blocked for web fetch); b4 thread shows
no stable nomination. Absence is not a negative signal per instructions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `rt5645_probe()` (modified); calls `rt5645_irq()` →
`rt5645_jack_detect_work()` → `rt5645_jack_detect()`.

### Step 5.2: Callers
**Record:** `rt5645_probe()` is the component `.probe` callback, invoked
during ASoC card bring-up. `rt5645_irq()` also called from
`rt5645_set_jack_detect()` (machine drivers: `rockchip_rt5645.c`, Intel
`cht_bsw_rt5645.c`, `bdw-rt5650.c`, AMD `acp-rt5645.c`, Mediatek mt8173
boards) and codec I2C IRQ handler.

### Step 5.3: Callees
**Record:** `rt5645_irq()` queues delayed work; work handler reads
`gpiod_hp_det`, calls `rt5645_jack_detect()` which writes registers,
enables DAPM pins (`LDO2`, `Mic Det Power`), programs charge pump.

### Step 5.4: Reachability
**Record:** Triggered at every boot/probe for boards with `jd_mode == 0`
and codec `hp-detect` GPIO. Common on embedded DT boards using `simple-
audio-card` without custom machine driver.
`simple_util_init_aux_jacks()` does not help rt5645 because rt5645 lacks
`get_jack_type` callback.

### Step 5.5: Similar patterns
**Record:** `rt5645_set_jack_detect()` already ends with `rt5645_irq(0,
rt5645)` — fix mirrors that established pattern.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **v6.18.44** (`stable/linux-6.18.y`).
`rt5645_probe()` at lines 3497–3500 returns without initial jack detect.
All relevant infrastructure (`gpiod_hp_det`, `jd_mode`, `rt5645_irq`,
`rt5645_jack_detect_work` case 0) is present. Bug predates 6.18 branch
(present since ~2015 GPIO path).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` on mainline commit
`54b2796992794` succeeds with no conflicts.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in this tree. Commit `54b2796992794` is in
mainline but not in `stable/linux-6.18.y` (confirmed via `git log
stable/linux-6.18.y..origin/master -- sound/soc/codecs/rt5645.c`).

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — ASoC codec driver
(`sound/soc/codecs/rt5645.c`). Affects audio on rt5645/rt5650 platforms
(ARM SBCs, some x86 ACPI tablets).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent stable-tree rt5645 commits
include DMI quirks, deadlock fix, push-button fixes.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** **Platform-specific** — boards using rt5645 with:
- `realtek,jd-mode = <0>` (or unset jd_mode via DT parse path)
- Codec `hp-detect` GPIO
- No machine driver calling `rt5645_set_jack_detect()` (e.g. `simple-
  audio-card`)

### Step 8.2: Trigger conditions
**Record:** Headphones plugged in before/during boot. Deterministic on
affected hardware; not timing-dependent. Unprivileged users cannot
trigger remotely, but every boot with pre-inserted headphones hits it.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM-HIGH** — complete loss of headphone audio at boot
(silent output). No crash, corruption, or security impact. Workaround
exists (unplug/replug). For embedded devices this is a significant
functional defect.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware users (audio works at boot)
- **Risk:** VERY LOW (4 lines, reuses existing path, guarded conditions)
- **Ratio:** Favorable — classic hardware workaround fix

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible user-visible bug (silent audio with headphones at
  boot)
- Small, surgical, obviously correct fix
- Maintainer-reviewed and merged
- Hardware platform workaround category (explicit stable exception)
- Buggy code exists in v6.18.44; patch applies cleanly
- No dependencies

**AGAINST backport:**
- Not a crash/security/corruption issue
- Narrow hardware configuration
- User workaround available (replug jack)
- No explicit stable nomination or external bug reports

**Unresolved:** No independent Tested-by; exact board DT that triggered
the fix not identified in-tree (no rt5645 DTS nodes in this checkout).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors
   `rt5645_set_jack_detect()`; maintainer merged; logic verified in code
2. Fixes a real bug affecting users? **PASS** — silent audio on affected
   boards
3. Important issue? **PASS** — significant functional failure on
   affected hardware (hardware quirk category)
4. Small and contained? **PASS** — 4 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception category
**Record:** Hardware quirk/workaround — missing initialization for GPIO
jack-detect platforms.

### Step 9.4: Decision rationale

For **linux-6.18.y (v6.18.44)**, this commit fixes a longstanding
initialization gap where rt5645 codec HP amplifier power paths are never
enabled when headphones are already inserted at boot on GPIO jack-detect
platforms without a machine driver. The fix is minimal, reuses existing
detection infrastructure, applies cleanly, and falls squarely in the
hardware workaround category that stable trees routinely accept. While
not a crash or security issue, silent audio on every cold boot is a
meaningful functional defect for affected embedded platforms.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.44; parsed commit message tags
  and body
- [Phase 2] Read diff and `rt5645_probe()`, `rt5645_irq()`,
  `rt5645_jack_detect_work()`, `rt5645_jack_detect()` in local tree
- [Phase 2] Verified `snd_soc_jack_report()` NULL safety in
  `sound/soc/soc-jack.c:39-40`
- [Phase 3] `git blame -L 3493,3500 sound/soc/codecs/rt5645.c` → lines
  from 2015–2021
- [Phase 3] `git log -S "gpiod_hp_det"` → introduced `0b0cefc8fd105`
  (2015)
- [Phase 3] `git show 7f6ecc220272d` → set_jack callback (2023), present
  in tree
- [Phase 3] `git show 54b2796992794` → mainline commit SHA and metadata
- [Phase 3] `git log stable/linux-6.18.y..origin/master --
  sound/soc/codecs/rt5645.c` → fix not yet in stable branch
- [Phase 4] `b4 dig -c 54b2796992794` → lore URL found
- [Phase 4] `b4 dig -c 54b2796992794 -a` → single v1 patch
- [Phase 4] `b4 dig -c 54b2796992794 -w` → CC list with
  broonie@kernel.org, linux-sound
- [Phase 4] `b4 dig -m /tmp/rt5645-jack.mbox` → Mark Brown applied, no
  objections
- [Phase 5] `grep rt5645_set_jack_detect` → machine driver call sites
  verified
- [Phase 5] Verified rt5645 lacks `get_jack_type` →
  `simple_util_init_aux_jacks()` won't call set_jack
- [Phase 6] Confirmed missing fix at `rt5645_probe()` lines 3497–3500
- [Phase 6] `git apply --check` on `54b2796992794` patch → clean apply
- [Phase 6] `grep rt5645` in `*.dts*` → no in-tree DTS examples (driver
  code still present)
- [Phase 8] Verified `rt5645_get_pdata()` / `rt5645_check_dp()` jd_mode
  handling in local tree

**YES**

 sound/soc/codecs/rt5645.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 29a403526cd9e..428cc6850dc5e 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3497,6 +3497,10 @@ static int rt5645_probe(struct snd_soc_component *component)
 	if (!rt5645->eq_param)
 		return -ENOMEM;
 
+	/* no machine driver to call rt5645_set_jack_detect(), so detect here */
+	if (!rt5645->pdata.jd_mode && rt5645->gpiod_hp_det)
+		rt5645_irq(0, rt5645);
+
 	return 0;
 }
 
-- 
2.53.0

