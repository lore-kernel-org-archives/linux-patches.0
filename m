Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B45D3B52E0;
	Mon, 20 Apr 2026 13:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691408; cv=none; b=exhRcBKMqdzqjC5hj8aW7yqvkIe42i2CDiVYqsgCyx5qdMnwT3VFCyeTpyBKG1Z6sp+LZHtmzWEW92nR+QxDNUgiipetM12vOJEedOCTCOhSI73NglgVb14N6zWMa8g/FPAdcWE3xK8FKCzz0y3698yChIhYwK39BOZW6OlXwMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691408; c=relaxed/simple;
	bh=WJDSyxUOR4RJXk43zQxmajHePsyAzx3QqzEfKuaS1sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dkBHHwYDK8K/sIRUzEdvAxh5K57tK2KXdGn0JZqJyRtgHFWVKy40aSNFCvZKxptAXUdhIW7oePr9qxuOjsDRha65d9QRYjaJgxPwr8IwhyObyNb+ZVu1quIBTQKFsC0pCIK3TMlUMW05qrhtA4m4TvCxocaxwfXiVaP+4LlJAsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fK3UzSIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fK3UzSIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3B4C19425;
	Mon, 20 Apr 2026 13:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691408;
	bh=WJDSyxUOR4RJXk43zQxmajHePsyAzx3QqzEfKuaS1sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK3UzSIbgLnB17f60lDv8WXBIEIqoqFPMO+xzariK0DcLAlfsMNn8YH78IbX3uzu/
	 u4YQ9np2ynvXEL9NOtyMonxzqPc7Qef+V5TQFIKcH8w9XDzWI62iiNf+bfvHdG8EYF
	 s1+XlbE7RmDp9zgXH7w5FqtjGWmXAgdLMHDyRCTaoswMJjxaB8W9xJkqwwAeV25PB/
	 uBbtAzHqgukSG9jsnl5NQhsZDWzway1KVQhNajf3RQAWyNwcS6FDGDKKOiyNLtMlVp
	 454NHHzQzfiSLB2a86R/B1nBl/w3dfbh5JFNBekW74NrmYBLDdE4e6HzBQi6LL+QZl
	 +PiZHwGrO+h/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aravind Anilraj <aravindanilraj0702@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ASoC: Intel: bytcr_rt5651: Fix MCLK leak on platform_clock_control error
Date: Mon, 20 Apr 2026 09:16:42 -0400
Message-ID: <20260420132314.1023554-8-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aravind Anilraj <aravindanilraj0702@gmail.com>

[ Upstream commit b022e5c142efe4c5497e6cfda1f143618b4b9254 ]

If byt_rt5651_prepare_and_enable_pll1() fails, the function returns
without calling clk_disable_unprepare() on priv->mclk, which was
already enabled earlier in the same code path. Add the missing
cleanup call to prevent the clock from leaking.

Signed-off-by: Aravind Anilraj <aravindanilraj0702@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260401220507.23557-3-aravindanilraj0702@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: ASoC: Intel: bytcr_rt5651
- **Action verb**: "Fix" — explicitly a bug fix
- **Summary**: Fix clock (MCLK) resource leak on error path in
  `platform_clock_control`

### Step 1.2: Tags
- **Signed-off-by**: Aravind Anilraj (author, community contributor — no
  prior commits in this subsystem)
- **Reviewed-by**: Cezary Rojewski (Intel audio maintainer)
- **Link**: patch.msgid.link/20260401220507.23557-3 — patch 3 in a
  series
- **Signed-off-by**: Mark Brown (ASoC subsystem maintainer — applied the
  patch)
- No Fixes: tag, no Cc: stable, no Reported-by (all expected for autosel
  review)

### Step 1.3: Commit Body
The message clearly describes: if `byt_rt5651_prepare_and_enable_pll1()`
fails, the function returns without calling `clk_disable_unprepare()` on
`priv->mclk`, which was already enabled by `clk_prepare_enable()`. This
is a straightforward clock resource leak on an error path.

### Step 1.4: Hidden Bug Fix?
No — this is explicitly labeled as a bug fix and is genuinely one. The
commit message directly describes the resource leak mechanism.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`sound/soc/intel/boards/bytcr_rt5651.c`)
- **Lines added**: 2 (`+if (ret < 0)` and
  `+clk_disable_unprepare(priv->mclk);`)
- **Lines removed**: 0
- **Function modified**: `platform_clock_control()`
- **Scope**: Single-file, single-function, 2-line surgical fix

### Step 2.2: Code Flow Change
**Before**: In the `SND_SOC_DAPM_EVENT_ON` branch:
1. `clk_prepare_enable(priv->mclk)` — enables the clock
2. `byt_rt5651_prepare_and_enable_pll1()` — configures PLL
3. If step 2 fails, `ret < 0` falls through to the error path at line
   225, which logs the error and returns — **without disabling the
   clock**

**After**: If `byt_rt5651_prepare_and_enable_pll1()` fails,
`clk_disable_unprepare(priv->mclk)` is called immediately, properly
balancing the earlier `clk_prepare_enable()`.

### Step 2.3: Bug Mechanism
**Category**: Resource leak (clock) on error path.
- `clk_prepare_enable()` increments the clock's reference count
- On PLL1 failure, the corresponding `clk_disable_unprepare()` was never
  called
- The clock remains permanently enabled, leaking the resource

### Step 2.4: Fix Quality
- **Obviously correct**: Yes — directly mirrors the existing cleanup in
  the `else` branch (line 221-222)
- **Minimal**: Yes — 2 lines, no unnecessary changes
- **Regression risk**: Essentially zero — only executes on an existing
  error path

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- Line 206 (`clk_prepare_enable`): Refactored by `a8627df5491e00` (Andy
  Shevchenko, 2021-10-07) — but the original logic dates to
  `02c0a3b3047f8f` (Pierre-Louis Bossart, 2017-10-12)
- Line 211 (`byt_rt5651_prepare_and_enable_pll1`): Introduced by
  `aeec6cc0821573` (Hans de Goede, 2018-03-04) — **this is when the bug
  was introduced**. The PLL1 call was added between the clock enable and
  the end of the branch, without error handling for the clock.

### Step 3.2: Fixes Target
No explicit Fixes: tag. The implicit fix target is `aeec6cc0821573`
("ASoC: Intel: bytcr_rt5651: Configure PLL1 before using it",
v4.17-rc1). This commit is present in **all active stable trees** (it
dates to 2018).

### Step 3.3: Related Changes
The file has had several unrelated changes since the bug was introduced,
but none touch the specific error path being fixed. The fix applies
cleanly.

### Step 3.4: Author
Aravind Anilraj appears to be a community contributor (no other commits
in this subsystem found). However, the patch was **Reviewed-by** Cezary
Rojewski (Intel audio maintainer) and **merged by** Mark Brown (ASoC
maintainer).

### Step 3.5: Dependencies
None. The fix is completely standalone — it references only `priv->mclk`
and `clk_disable_unprepare()`, both of which have existed since the
original code. No prerequisites needed.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.2: Patch Discussion
The Link tag indicates this is patch 3 in a series (message-id contains
"23557-3"). Lore.kernel.org was blocked by anti-bot protection,
preventing direct discussion retrieval. However:
- The patch was reviewed by Intel's audio maintainer (Cezary Rojewski)
- Merged by the ASoC subsystem maintainer (Mark Brown)
- Both are strong trust indicators

### Step 4.3-4.5
No explicit bug report or syzbot link — this appears to be found by code
inspection. No previous stable discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Function Context
`platform_clock_control()` is registered as a DAPM supply callback:

```253:255:sound/soc/intel/boards/bytcr_rt5651.c
        SND_SOC_DAPM_SUPPLY("Platform Clock", SND_SOC_NOPM, 0, 0,
                            platform_clock_control, SND_SOC_DAPM_PRE_PMU
|
                            SND_SOC_DAPM_POST_PMD),
```

This is called every time the audio path is powered up (PRE_PMU) or down
(POST_PMD). It is a **common path** for any user of this audio hardware.

### Step 5.3: Callees
- `clk_prepare_enable()` / `clk_disable_unprepare()`: standard Linux
  clock framework
- `byt_rt5651_prepare_and_enable_pll1()`: configures PLL via
  `snd_soc_dai_set_pll()` and `snd_soc_dai_set_sysclk()` — can fail if
  the codec rejects the configuration

### Step 5.4: Sibling Pattern Confirmation
The sibling driver `bytcr_rt5640.c` has the **identical bug** at lines
285-291:

```285:291:sound/soc/intel/boards/bytcr_rt5640.c
        if (SND_SOC_DAPM_EVENT_ON(event)) {
                ret = clk_prepare_enable(priv->mclk);
                if (ret < 0) {
                        dev_err(card->dev, "could not configure MCLK
state\n");
                        return ret;
                }
                ret = byt_rt5640_prepare_and_enable_pll1(codec_dai,
48000);
```

No `clk_disable_unprepare()` on PLL1 failure there either. This confirms
the bug pattern is real and systematic.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code in Stable
The buggy code was introduced in `aeec6cc0821573` (v4.17-rc1, March
2018). This code exists in **all active stable trees** (5.4.y, 5.10.y,
5.15.y, 6.1.y, 6.6.y, 6.12.y).

### Step 6.2: Backport Complications
The fix is 2 lines with minimal context sensitivity. The surrounding
code has been stable since the a8627df5491e00 refactoring in 2021. It
should apply cleanly to all trees from 5.15+ at minimum; older trees may
need trivial context adjustment for the `BYT_RT5651_MCLK_EN` quirk check
that was removed by `a8627df5491e00`.

### Step 6.3: No related fixes for this bug already in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- **Subsystem**: ASoC / Intel audio machine driver
- **Criticality**: PERIPHERAL — affects users of Bay Trail / Cherry
  Trail devices with RT5651 codec (budget tablets, laptops)
- **Activity**: Moderate — file sees occasional updates

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users with Intel Bay Trail or Cherry Trail devices using the RT5651
audio codec. These are common budget tablets and laptops.

### Step 8.2: Trigger Conditions
Triggered when: (a) audio starts playing (DAPM PRE_PMU event), AND (b)
PLL1 configuration fails. While PLL failure is itself an error
condition, repeated failures with clock leaks can compound the problem
and prevent power management from working correctly.

### Step 8.3: Failure Mode
- **Severity: MEDIUM** — The leaked clock prevents the MCLK from being
  disabled, which:
  - Wastes power (clock stays enabled)
  - May prevent subsequent clock operations from working correctly
  - Could contribute to audio subsystem malfunction after error recovery

### Step 8.4: Risk-Benefit
- **Benefit**: Fixes a real resource leak, prevents clock reference
  count imbalance
- **Risk**: Essentially zero — 2-line addition only on error path,
  obviously correct
- **Ratio**: Very favorable for backport

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real clock resource leak on error path
- 2-line fix, minimal and surgical
- Obviously correct (mirrors existing cleanup pattern in the else
  branch)
- Reviewed by Intel audio maintainer, merged by ASoC subsystem
  maintainer
- Bug exists since v4.17, present in all active stable trees
- No dependencies, completely standalone
- Sibling driver (bytcr_rt5640) has the identical bug, confirming the
  pattern

**AGAINST backporting:**
- The trigger requires PLL1 configuration failure (uncommon in normal
  operation)
- No user reports or syzbot bugs — found by code inspection
- Author is a community contributor with no other commits in this
  subsystem

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — trivially correct, reviewed
   by maintainer
2. Fixes a real bug? **YES** — clock resource leak on error path
3. Important issue? **MEDIUM** — resource leak, not a crash
4. Small and contained? **YES** — 2 lines in 1 file
5. No new features/APIs? **YES** — no new functionality
6. Applies to stable trees? **YES** — code unchanged, clean apply
   expected

### Step 9.3: Exception Categories
Not applicable — this is a standard bug fix, not an exception category.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Cezary Rojewski (Intel), Signed-
  off-by Mark Brown (ASoC maintainer)
- [Phase 2] Diff analysis: 2 lines added to error path in
  `platform_clock_control()`, adds missing `clk_disable_unprepare()`
- [Phase 3] git blame: buggy code path introduced in `aeec6cc0821573`
  (v4.17-rc1, 2018-03-04), present in all stable trees
- [Phase 3] git describe: confirmed `aeec6cc0821573` first appeared in
  v4.17-rc1
- [Phase 3] git log: no prior fix for this issue exists
- [Phase 4] lore.kernel.org: blocked by anti-bot protection, could not
  read discussion
- [Phase 4] b4 dig: confirmed PLL1 commit is patch v3 15/22 from Hans de
  Goede series
- [Phase 5] Verified `platform_clock_control()` is a DAPM supply
  callback (line 253-255), called on every audio path enable/disable
- [Phase 5] Verified sibling `bytcr_rt5640.c` has identical bug pattern
  at lines 285-291
- [Phase 6] Code exists in all active stable trees (bug from v4.17,
  2018)
- [Phase 8] Failure mode: clock resource leak preventing proper power
  management, severity MEDIUM
- UNVERIFIED: Could not read mailing list discussion due to anti-bot
  protection; relied on tags in commit message for review assessment

The fix is small, surgical, obviously correct, and meets all stable
kernel criteria. It fixes a genuine resource leak with zero regression
risk.

**YES**

 sound/soc/intel/boards/bytcr_rt5651.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 68cf463f1d507..8932fc5d6f4f2 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -209,6 +209,8 @@ static int platform_clock_control(struct snd_soc_dapm_widget *w,
 			return ret;
 		}
 		ret = byt_rt5651_prepare_and_enable_pll1(codec_dai, 48000, 50);
+		if (ret < 0)
+			clk_disable_unprepare(priv->mclk);
 	} else {
 		/*
 		 * Set codec clock source to internal clock before
-- 
2.53.0

