Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215863E3D8C;
	Mon, 20 Apr 2026 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691484; cv=none; b=B9NCEnOq2B/zO5ZgQcP1LMAoHkNp7CHA9ZGMXM/KEyn87MODA7kk2sdbGBLX7Pk2oH5qmRlsLW3G0IS/Nxq9BChgkiWLxHkNpb1v+/sDcPGJtdyed3DXCPvIMONsicrgWvuDhtHk4JDxwKwZponKz79W9rQUJJolVpl5wYbNOaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691484; c=relaxed/simple;
	bh=u/m0nK3jj9zYqW7ipcuLuRyeUWHlPMos+x2YZBKnBv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGIrS9YdFwfjTzKMNM7Iplg6xbS88CcVSgTitog8DpfVs+MwBnvzp76vtUx3kbUO95rJLfeyhsEhARNzuYycGZ7Demn8jSzDa15NHXl6jDOzr5BBu07hm4rQmMX8jRYuCIx8we30C5mDhFELl548o5LJXTolP7dgCVRq8KX57S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBAou7mA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBAou7mA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862EEC2BCB6;
	Mon, 20 Apr 2026 13:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691484;
	bh=u/m0nK3jj9zYqW7ipcuLuRyeUWHlPMos+x2YZBKnBv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBAou7mAOMmowpvF3/JH8/Fh2WLb4xdCgqqP7GqWcnC9PgNRE5Njwm2+DLUWa9xbU
	 ooJ6dI1v/3Yeoo31hp4dKq84yR4DaO24/Q7UtOnylXUMVN/B5B+UV7dOvZ3yNJFvj/
	 GfWGBDJMFGqjIWuJpnqyv9YoinnR3yk8UWgsuBDbv/3Y9sMybP+0ac62bMl4M6b/tk
	 iTWy2NwH8Sh1uyz3VodQ2D0mJLYjsXHGtq88/prcO41LHjQEcPK2+W7vO5CmbKMxNT
	 19JbmpxrTGGfSIxOpOFzhca3gRea23JOJXQ3N6Vw1LFUwU5h0cfUgAkyDe09g7/dhi
	 ZAB+fL/49rXtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sheetal <sheetal@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ASoC: rt5640: Handle 0Hz sysclk during stream shutdown
Date: Mon, 20 Apr 2026 09:17:30 -0400
Message-ID: <20260420132314.1023554-56-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 247d1c13992d2c501e2e020e84d9d2920e11bf78 ]

Commit 2458adb8f92a ("SoC: simple-card-utils: set 0Hz to sysclk when
shutdown") sends a 0Hz sysclk request during stream shutdown to clear
codec rate constraints. The rt5640 codec forwards this 0Hz to
clk_set_rate(), which can cause clock controller firmware faults on
platforms where MCLK is SoC-driven (e.g. Tegra) and 0Hz falls below
the hardware minimum rate.

Handle the 0Hz case by clearing the internal sysclk state and
returning early, avoiding the invalid clk_set_rate() call.

Signed-off-by: Sheetal <sheetal@nvidia.com>
Link: https://patch.msgid.link/20260406090547.988966-1-sheetal@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The code is identical across v6.6, v6.12, and v7.0. The fix will apply
cleanly. Let me now compile my complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: ASoC: rt5640 (audio codec driver)
- **Action verb**: "Handle" - indicates fixing incorrect handling of a
  specific case
- **Summary**: Handles the 0Hz sysclk case during stream shutdown to
  prevent clock controller faults

### Step 1.2: Tags
- **Link**:
  `https://patch.msgid.link/20260406090547.988966-1-sheetal@nvidia.com`
  - original patch submission
- **Signed-off-by**: Sheetal (NVIDIA) - author, and Mark Brown
  (subsystem maintainer) - applied it
- No Fixes: tag (expected for autosel candidates)
- No Reported-by tag
- No Cc: stable tag

### Step 1.3: Commit Body Analysis
The commit explains:
- **Cause**: Commit 2458adb8f92a added a 0Hz sysclk request during
  stream shutdown
- **Bug**: rt5640 forwards this 0Hz to `clk_set_rate()`, which causes
  clock controller firmware faults on Tegra platforms where MCLK is SoC-
  driven and 0Hz falls below hardware minimum
- **Symptom**: Clock controller firmware fault during audio stream
  shutdown
- **Fix approach**: Check for 0Hz, clear internal sysclk state, return
  early

### Step 1.4: Hidden Bug Fix Detection
This is explicitly a bug fix for an interaction between two commits. The
word "Handle" means "fix the missing handling of this case."

Record: This IS a bug fix - it prevents firmware faults during normal
audio stream shutdown.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files**: `sound/soc/codecs/rt5640.c` only (single file)
- **Lines**: +4 added, 0 removed
- **Function modified**: `rt5640_set_dai_sysclk()`
- **Scope**: Single-file surgical fix

### Step 2.2: Code Flow Change
- **Before**: `rt5640_set_dai_sysclk()` enters the switch statement
  unconditionally. With `clk_id=0` (RT5640_SCLK_S_MCLK),
  `clk_set_rate(rt5640->mclk, 0)` is called, hitting the clock
  controller with an invalid 0Hz rate.
- **After**: When `freq==0`, the function sets `rt5640->sysclk = 0` and
  returns early, avoiding the `clk_set_rate(mclk, 0)` call entirely.

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** (missing case handling)
- The 0Hz value is a convention from `simple-card-utils` to signal
  "clear constraints"
- rt5640 didn't handle this convention, passing the invalid rate
  directly to the clock framework
- This causes firmware faults on platforms like Tegra

### Step 2.4: Fix Quality
- **Obviously correct**: Yes - the exact same pattern exists in
  rockchip, ep93xx, wm8904, and stm32 sai drivers
- **Minimal/surgical**: Yes - 4 lines, single early-return guard
- **Regression risk**: Extremely low - only affects the freq==0 case,
  which was already broken
- **No red flags**: Doesn't touch locking, APIs, or other subsystems

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- `rt5640_set_dai_sysclk()` original structure by Bard Liao (2013,
  v3.11-era)
- `clk_set_rate()` call added by Sameer Pujar (9f138bb2eaf661, v6.3) -
  an NVIDIA engineer
- The 0Hz shutdown behavior (2458adb8f92ad) was added in v5.10

### Step 3.2: Fixes tag analysis
No explicit Fixes: tag, but the commit references 2458adb8f92a. The bug
is an interaction between:
1. 2458adb8f92a (v5.10) - sends 0Hz sysclk on shutdown
2. 9f138bb2eaf661 (v6.3) - added `clk_set_rate(mclk, freq)` to rt5640

Both commits are in v6.6 and later stable trees.

### Step 3.3: Related changes
Multiple identical fixes exist for the same 0Hz issue in other drivers:
- f1879d7b98dc9 - rockchip (v5.10)
- 9b7a7f921689d - stm32 sai (v5.10)
- 66dc3b9b9a6f4 - ep93xx (v6.3) - includes a concrete crash stack trace
- 2a0bda276c642 - wm8904

### Step 3.4: Author context
Sheetal is an NVIDIA Tegra audio engineer. Sameer Pujar (who added
clk_set_rate) is also NVIDIA. This is the team that owns this platform
and hit this bug directly.

### Step 3.5: Dependencies
None. The fix is completely standalone - it adds a guard before the
existing switch statement.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.2: Patch discussion
- b4 dig could not find the commit by message-id (too new)
- Lore is behind Anubis anti-scraping protection
- Mark Brown (ASoC maintainer) applied it directly, confirming
  acceptance
- The pattern is well-established: identical fixes for ep93xx, rockchip,
  stm32, wm8904

### Step 4.3: Bug report
The ep93xx fix (66dc3b9b9a6f4) includes a full stack trace showing
`__div0` crash from `clk_set_rate(0)` during shutdown. The rt5640 commit
describes "clock controller firmware faults" on Tegra - same class of
issue.

### Step 4.4-4.5: Series context
This is a standalone single-patch fix, not part of a series.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Function context
`rt5640_set_dai_sysclk()` is registered as `.set_sysclk` in the DAI ops.
It is called by `snd_soc_dai_set_sysclk()` from the ASoC core, triggered
by `asoc_simple_shutdown()` during every stream close.

### Step 5.3-5.4: Call chain
```
PCM stream close -> soc_pcm_close -> soc_pcm_clean ->
snd_soc_link_shutdown
-> asoc_simple_shutdown -> snd_soc_dai_set_sysclk(codec_dai, 0, 0, ...)
-> rt5640_set_dai_sysclk(freq=0) -> clk_set_rate(mclk, 0) -> FIRMWARE
FAULT
```

This is a normal-operation path triggered on every audio stream
shutdown.

### Step 5.5: Similar patterns
Verified: at least 4 other drivers already have identical 0Hz guards
(`if (!freq) return 0` or `if (freq == 0) return 0`).

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy code in stable?
- **v6.1.y**: Does NOT have 9f138bb2eaf661 (`clk_set_rate()` not added)
  - bug does not exist
- **v6.6.y**: HAS both 2458adb8f92a and 9f138bb2eaf661 - **BUG EXISTS**
- **v6.12.y**: Same code, **BUG EXISTS**

### Step 6.2: Backport complications
The `rt5640_set_dai_sysclk()` code is **identical** in v6.6, v6.12, and
v7.0. The patch will apply cleanly without any modifications.

### Step 6.3: Related fixes already in stable
No other fix for this specific issue in rt5640 found.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
- **Subsystem**: ASoC codecs (sound/soc/codecs/) - audio driver
- **Criticality**: IMPORTANT - rt5640 is a widely-used Realtek audio
  codec found in many embedded platforms (Tegra, Chromebooks, etc.)

### Step 7.2: Subsystem activity
Active development - multiple recent commits for rt5640.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected users
Users of platforms combining:
- rt5640 codec with SoC-driven MCLK (Tegra platforms specifically
  mentioned)
- simple-card or audio-graph-card machine driver with `mclk-fs` property

### Step 8.2: Trigger conditions
- Triggered on **every audio stream shutdown** - extremely common
  operation
- No special conditions needed beyond the hardware configuration above
- This is a normal-operation failure, not an edge case

### Step 8.3: Failure mode severity
- **Clock controller firmware fault** - platform-dependent, but can
  cause:
  - Error returns from `clk_set_rate()` breaking audio shutdown
  - On some platforms (ep93xx), division by zero causing kernel crash
  - On Tegra, firmware-level faults that may affect system stability
- **Severity**: HIGH (firmware fault on every stream close)

### Step 8.4: Risk-benefit ratio
- **Benefit**: HIGH - prevents firmware fault/crash on every audio
  stream shutdown on affected platforms
- **Risk**: VERY LOW - 4-line early return guard, only affects the
  freq==0 case which was already broken
- **Ratio**: Excellent - this is exactly the kind of fix stable trees
  are meant to carry

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compilation

**FOR backporting**:
- Fixes a real bug: clock controller firmware faults during normal audio
  stream shutdown
- Well-established fix pattern: identical fixes exist for 4+ other
  drivers
- Concrete crash evidence from ep93xx (division by zero stack trace)
- Tiny, surgical fix: 4 lines, single early-return guard
- Obviously correct: follows exact pattern validated in other drivers
- Clean applicability: code is identical in v6.6, v6.12, and v7.0
- Applied by Mark Brown (ASoC maintainer)
- Author is from the affected platform team (NVIDIA/Tegra)

**AGAINST backporting**:
- None identified

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **YES** - identical pattern used in 4+
   other drivers, applied by maintainer
2. Fixes a real bug? **YES** - firmware faults on every stream shutdown
3. Important issue? **YES** - prevents crash/fault on normal audio
   operations
4. Small and contained? **YES** - 4 lines, single function
5. No new features/APIs? **YES** - pure defensive guard
6. Can apply to stable? **YES** - verified identical code in v6.6 and
   v6.12

### Step 9.3: Exception categories
Not an exception category - this is a straightforward bug fix.

## Verification

- [Phase 1] Parsed tags: Link to patch.msgid.link, Signed-off-by Mark
  Brown (maintainer)
- [Phase 2] Diff analysis: 4 lines added, inserts `if (!freq) {
  rt5640->sysclk = 0; return 0; }` before switch in
  `rt5640_set_dai_sysclk()`
- [Phase 3] git blame: `clk_set_rate()` added by 9f138bb2eaf661 (Sameer
  Pujar, v6.3); 0Hz shutdown added by 2458adb8f92ad (v5.10)
- [Phase 3] `git merge-base --is-ancestor`: 9f138bb2eaf661 IS in v6.6
  (YES), NOT in v6.1 (NO)
- [Phase 3] `git merge-base --is-ancestor`: 2458adb8f92ad IS in v6.6
  (YES) - both triggering commits present
- [Phase 3] git log: verified 4+ identical fixes (rockchip
  f1879d7b98dc9, ep93xx 66dc3b9b9a6f4, stm32 sai 9b7a7f921689d, wm8904
  2a0bda276c642)
- [Phase 3] git show 66dc3b9b9a6f4: confirmed ep93xx fix includes
  division-by-zero stack trace as concrete crash evidence
- [Phase 4] b4 dig: could not find original submission by message-id
  (recent commit)
- [Phase 4] lore: blocked by Anubis anti-scraping
- [Phase 5] grep: `rt5640_set_dai_sysclk` registered as `.set_sysclk` in
  DAI ops, called from ASoC framework during shutdown
- [Phase 6] `git show v6.6:sound/soc/codecs/rt5640.c`: code is identical
  to v7.0 - patch applies cleanly
- [Phase 6] `git show v6.12:sound/soc/codecs/rt5640.c`: code is
  identical to v7.0 - patch applies cleanly
- [Phase 8] Trigger: every audio stream shutdown on affected platforms;
  severity HIGH (firmware fault)

The fix is small (4 lines), surgical, obviously correct (proven pattern
in 4+ other drivers), fixes a real firmware fault on every audio stream
shutdown, and applies cleanly to all active stable trees containing the
buggy code (v6.6+).

**YES**

 sound/soc/codecs/rt5640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index db2222e6f2e75..f6c6294e15880 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -1838,6 +1838,11 @@ static int rt5640_set_dai_sysclk(struct snd_soc_dai *dai,
 	unsigned int pll_bit = 0;
 	int ret;
 
+	if (!freq) {
+		rt5640->sysclk = 0;
+		return 0;
+	}
+
 	switch (clk_id) {
 	case RT5640_SCLK_S_MCLK:
 		ret = clk_set_rate(rt5640->mclk, freq);
-- 
2.53.0

