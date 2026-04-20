Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAD73BC67C;
	Mon, 20 Apr 2026 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691519; cv=none; b=QljIR1H2RyPVs7hmFGUy6UljjC3lqHMXEfeYw3skM6sS5ZLIINDNiH2c6rQgXGR2PSLsev6HtXw3pvTaK1BWfat8RTX1eSleCW3vLg85+UbzFSi4U8Tqc45BZ5kwzfO4uPIGuVUq2+H0ER8lcWGTpaRzPGj9idk3Js/kwW4bMfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691519; c=relaxed/simple;
	bh=2WenpJpauDKcsmxbdzzadx+CKzBVD2DP/jmTNdOnrG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJVpEFjLlCpXnLsBUzaUCDlje9mqZBhY9iMWa9vIW4cJhbAGRaPPKbGOi+Ats638jI2kKjZKa3p1Pnod1DSdY+9FUWJC0vxvKqxfj22xnfDHgAPswKM6fuddq+1ANYm1amdL4HHoIO9ERzyRp1Cx2Tpy+GNMMFljqo8u3QXpi4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T90UfdDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T90UfdDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CF4C2BCC6;
	Mon, 20 Apr 2026 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691519;
	bh=2WenpJpauDKcsmxbdzzadx+CKzBVD2DP/jmTNdOnrG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T90UfdDHymDnjvaIgz9oDG2zK9GS8v7t/BKBi+Z+YOiafIY1OAs7yQEz5AZhLkSDY
	 W+noP8K3SOGJn6964BwKcNwkHtp+T5c8MLSN9dPX6647t5HlJafrSLtw1Gazqpu47g
	 R68W5GrRFMlwOOd1nQee6X/qZ/3V1LyX2ekFVs+tq3v7KFiT3kfvp13IH7vhkElEbl
	 mp/zTZD03MYJ4r8O1rqSF6Mc8ZdxQCRrd4YKLKOEk68rIKY04O9hrnUTH8U6nrq+cD
	 FuBnXGFNZxn/FMPUGebOVsKe8txvZE0BHjtIhI8jwOOb2CNmMc9H1PWJDeSg7VZZNE
	 EyR7yKyRZ6xXA==
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
Subject: [PATCH AUTOSEL 7.0-5.10] ASoC: Intel: cht_bsw_rt5672: Fix MCLK leak on platform_clock_control error
Date: Mon, 20 Apr 2026 09:17:51 -0400
Message-ID: <20260420132314.1023554-77-sashal@kernel.org>
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

[ Upstream commit dced5a373a96cfd9f3bd0ffcf5339a7579d1473a ]

If snd_soc_dai_set_pll() or snd_soc_dai_set_sysclk() fail inside the
EVENT_ON path, the function returns without calling
clk_disable_unprepare() on ctx->mclk, which was already enabled earlier
in the same code path. Add the missing clk_disable_unprepare() calls
before returning the error.

Signed-off-by: Aravind Anilraj <aravindanilraj0702@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260401220507.23557-4-aravindanilraj0702@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have all the information needed for a complete analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [ASoC: Intel: cht_bsw_rt5672] [Fix] [MCLK leak on
platform_clock_control error path]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by:** Aravind Anilraj (author)
- **Reviewed-by:** Cezary Rojewski (Intel ASoC reviewer)
- **Link:** patch.msgid.link to the original patch
- **Signed-off-by:** Mark Brown (ASoC subsystem maintainer, committer)
- No Fixes: tag (expected for manual review candidates)
- No Reported-by: tag
- No Cc: stable tag

Record: Reviewed by Intel ASoC developer and merged by ASoC subsystem
maintainer. No syzbot or external reporter — this is a code-inspection-
found bug.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit message clearly states: if `snd_soc_dai_set_pll()` or
`snd_soc_dai_set_sysclk()` fail in the EVENT_ON path, the function
returns without calling `clk_disable_unprepare()` on `ctx->mclk`, which
was already enabled. The fix adds the missing cleanup calls.

Record: Bug: clock resource leak on error paths. Symptom: MCLK left
enabled after error, preventing proper power management. Root cause:
missing cleanup in two error return paths.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is explicitly labeled as a "Fix" and describes a resource leak — no
disguise here.

Record: This is an overt bug fix for a resource leak.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- **File:** `sound/soc/intel/boards/cht_bsw_rt5672.c`
- **Lines added:** +4 (two `if (ctx->mclk)
  clk_disable_unprepare(ctx->mclk);` blocks)
- **Lines removed:** 0
- **Functions modified:** `platform_clock_control()`
- **Scope:** Single-file, surgical fix

Record: 1 file, 4 lines added, 0 removed. Single function modified.
Extremely contained.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
- **Before:** In the EVENT_ON path, after
  `clk_prepare_enable(ctx->mclk)` succeeds, if either
  `snd_soc_dai_set_pll()` or `snd_soc_dai_set_sysclk()` fails, the
  function returns the error without disabling the clock.
- **After:** Both error paths now call
  `clk_disable_unprepare(ctx->mclk)` (guarded by `if (ctx->mclk)`)
  before returning the error.

Record: Error paths now properly clean up the enabled clock before
returning.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Category: Error path / resource leak fix.**

The clock `ctx->mclk` is enabled via `clk_prepare_enable()` at line 67.
If subsequent calls fail (lines 78-81 or 86-89), the function returns
without the matching `clk_disable_unprepare()`. This leaves the platform
clock running, preventing proper power management. The EVENT_OFF path at
line 103-104 already properly calls `clk_disable_unprepare()`,
confirming the intended pattern.

Record: Resource leak — MCLK left in enabled/prepared state on error
paths.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct:** Yes. Mirrors the existing cleanup pattern in
  the EVENT_OFF path (line 103-104). The `if (ctx->mclk)` guard is
  consistent with the guard at line 66.
- **Minimal/surgical:** Yes. Only 4 lines added, no unrelated changes.
- **Regression risk:** Extremely low. Only affects error paths. The
  `clk_disable_unprepare()` call is the exact counterpart to
  `clk_prepare_enable()` that was already called.

Record: Fix is obviously correct, minimal, and has negligible regression
risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The MCLK handling was introduced by commit `c25695ae88ce26` (Pierre-
Louis Bossart, 2017-06-23) — "ASoC: Intel: cht_bsw_rt5672: 19.2MHz clock
for Baytrail platforms". The bug has existed since that commit, which
was included in v4.13-rc1.

Record: Buggy code introduced in c25695ae88ce26 (v4.13-rc1, 2017).
Present in all active stable trees.

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present. However, the logical "Fixes:" target is
`c25695ae88ce26`, which introduced the MCLK handling without proper
error path cleanup.

Record: The implicit Fixes target (c25695ae88ce26) is in all stable
trees since v4.13.

### Step 3.3: CHECK FILE HISTORY
The file has had ~20 commits over the years, mostly cleanups and
conversions. No prior attempt to fix this specific leak was found (no
commits matching "MCLK leak" in the history).

Record: Standalone fix, no prerequisites needed. No prior fix for this
issue exists.

### Step 3.4: CHECK THE AUTHOR
The author (Aravind Anilraj) appears to be a new contributor. However,
the patch was reviewed by Cezary Rojewski (Intel ASoC reviewer) and
merged by Mark Brown (ASoC subsystem maintainer).

Record: Reviewed by experienced subsystem developers despite being from
a new contributor.

### Step 3.5: CHECK FOR DEPENDENCIES
The fix only adds `clk_disable_unprepare()` calls to existing error
paths. No new functions, structures, or APIs are used. The fix is
completely self-contained.

Record: No dependencies. Can apply standalone.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5: PATCH DISCUSSION
The lore.kernel.org site was not reachable due to bot protection. b4 dig
could not find the commit by message-id (it doesn't exist in this tree
as a commit). However, the commit tags show:
- **Reviewed-by:** Cezary Rojewski (Intel) — an active ASoC reviewer
- **Signed-off-by:** Mark Brown — the ASoC subsystem maintainer who
  merged it

These signatures indicate the patch went through proper review.

Record: Proper review by Intel ASoC developer and subsystem maintainer.
Could not access lore discussion directly.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: FUNCTION AND CALLERS
`platform_clock_control()` is registered as a DAPM supply widget
callback:

```114:116:sound/soc/intel/boards/cht_bsw_rt5672.c
        SND_SOC_DAPM_SUPPLY("Platform Clock", SND_SOC_NOPM, 0, 0,
                        platform_clock_control, SND_SOC_DAPM_PRE_PMU |
                        SND_SOC_DAPM_POST_PMD),
```

It is called by the DAPM framework whenever the "Platform Clock" supply
widget powers up (PRE_PMU) or down (POST_PMD). This happens during every
audio playback/capture start and stop operation. All audio paths
("Headphone", "Headset Mic", "Int Mic", "Ext Spk") depend on this widget
(lines 130-133).

Record: Called on every audio stream open/close. High frequency for
audio-active systems.

### Step 5.3-5.5: SIMILAR PATTERNS
I found the same bug pattern in sibling drivers `bytcr_rt5651.c` and
`bytcr_rt5640.c`, though those have slightly different code structure.
The `cht_bsw_rt5672.c` fix is specific to this driver and doesn't
require changes to siblings.

Record: Similar pattern exists in sibling drivers but this fix is self-
contained for cht_bsw_rt5672.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE
The buggy code was introduced in v4.13-rc1 (commit c25695ae88ce26). It
exists in all active stable trees (5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y,
etc.).

Record: Bug affects all active stable trees.

### Step 6.2: BACKPORT COMPLICATIONS
The file has been relatively stable. The current code at the fix site
matches what was introduced in c25695ae88ce26, with only minor changes
(the `if (ctx->mclk)` guard and the `65b2df10a1e62` commit that changed
the EVENT_OFF path). The fix should apply cleanly or with minimal
adjustment.

Record: Expected clean or near-clean apply to all stable trees.

### Step 6.3: RELATED FIXES
No prior fix for this specific issue was found in any tree.

Record: No existing fix for this leak.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem:** sound/soc/intel/boards — ASoC Intel machine driver
- **Criticality:** PERIPHERAL (specific to Cherryview/Baytrail platforms
  with RT5672 codec)
- **Affected hardware:** Lenovo and other Cherryview/Baytrail-based
  laptops/tablets with RT5670/RT5672 codec (reasonably common consumer
  devices)

Record: ASoC Intel board driver, PERIPHERAL but for consumer devices
(laptops/tablets).

### Step 7.2: SUBSYSTEM ACTIVITY
The file sees occasional updates (cleanups and fixes). It's a mature
driver.

Record: Mature, stable driver with occasional maintenance commits.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: AFFECTED USERS
Users of Cherryview/Baytrail platforms with RT5670/RT5672 codec. This
includes Lenovo and similar consumer laptops/tablets from the Baytrail
era.

Record: Platform-specific but for real consumer devices.

### Step 8.2: TRIGGER CONDITIONS
The bug triggers when `snd_soc_dai_set_pll()` or
`snd_soc_dai_set_sysclk()` fails during audio stream start. While these
failures are not common in normal operation, they can occur during
hardware errors, suspend/resume transitions, or codec communication
issues.

Record: Trigger requires PLL/sysclk configuration failure during audio
start. Uncommon but possible.

### Step 8.3: FAILURE MODE SEVERITY
When triggered, the platform clock remains enabled (leaked), preventing
proper power management. Repeated triggering could cause increased power
consumption. The clock framework may also track prepare/enable counts
incorrectly, potentially affecting system suspend or causing warnings.

Record: Severity: MEDIUM (resource leak affecting power management, no
crash).

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** Fixes a real resource leak on error paths, improves power
  management reliability.
- **Risk:** Very low — 4 lines added, only on error paths, mirrors
  existing cleanup patterns.
- **Ratio:** Favorable. Even though the trigger is uncommon, the fix is
  trivially safe.

Record: Benefit outweighs risk. Minimal fix with no regression
potential.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION
**FOR backporting:**
- Fixes a real clock resource leak (missing `clk_disable_unprepare()` on
  error paths)
- Extremely small and surgical (4 lines, single file, single function)
- Obviously correct — mirrors existing cleanup pattern in the same
  function
- Bug has existed since v4.13-rc1 (2017), affects all stable trees
- Reviewed by Intel ASoC developer, merged by subsystem maintainer
- No dependencies, self-contained
- No regression risk

**AGAINST backporting:**
- No user reports of the issue (code-inspection find)
- Trigger requires error conditions that are uncommon in normal
  operation
- Driver-specific (not core kernel)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — reviewed by Intel developer,
   merged by maintainer
2. Fixes a real bug? **YES** — clock resource leak on error paths
3. Important issue? **MEDIUM** — resource leak, not a crash
4. Small and contained? **YES** — 4 lines, single file
5. No new features or APIs? **YES** — only adds cleanup calls
6. Can apply to stable? **YES** — code unchanged since introduction

### Step 9.3: EXCEPTION CATEGORIES
Not an exception category — this is a straightforward bug fix.

### Step 9.4: DECISION
This is a small, obvious, and safe fix for a real resource leak. The fix
adds missing `clk_disable_unprepare()` calls on two error paths where
the clock was already enabled. It's reviewed by the right people, has no
dependencies, and applies to all stable trees.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Cezary Rojewski (Intel), merged by
  Mark Brown (ASoC maintainer)
- [Phase 2] Diff analysis: 4 lines added, two `if (ctx->mclk)
  clk_disable_unprepare(ctx->mclk)` blocks on error paths
- [Phase 3] git blame: buggy code introduced in c25695ae88ce26
  (v4.13-rc1, 2017), present in all stable trees
- [Phase 3] git show c25695ae88ce26: confirmed original commit added
  MCLK handling without error path cleanup
- [Phase 3] git describe --contains c25695ae88ce26:
  v4.13-rc1~142^2~1^2~5^2~8 — confirmed it's been in mainline since
  v4.13
- [Phase 3] git log --oneline -20 -- file: no prior MCLK leak fix found
- [Phase 4] b4 dig: could not find commit by message-id in local tree;
  lore blocked by bot protection
- [Phase 5] DAPM widget registration at lines 114-116 confirms
  `platform_clock_control` is called on every audio stream start/stop
- [Phase 5] DAPM routes at lines 130-133 confirm all audio paths depend
  on Platform Clock
- [Phase 5] Grep for clk_disable_unprepare in sibling drivers confirms
  the same cleanup pattern is expected
- [Phase 6] Code at the fix site is essentially unchanged since
  c25695ae88ce26 — clean apply expected
- [Phase 8] Failure mode: clock resource leak preventing proper power
  management, severity MEDIUM
- UNVERIFIED: Could not access lore.kernel.org discussion for reviewer
  commentary on stable suitability

**YES**

 sound/soc/intel/boards/cht_bsw_rt5672.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/intel/boards/cht_bsw_rt5672.c b/sound/soc/intel/boards/cht_bsw_rt5672.c
index 359723f2700e4..57d6997eb12ff 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5672.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -77,6 +77,8 @@ static int platform_clock_control(struct snd_soc_dapm_widget *w,
 				CHT_PLAT_CLK_3_HZ, 48000 * 512);
 		if (ret < 0) {
 			dev_err(card->dev, "can't set codec pll: %d\n", ret);
+			if (ctx->mclk)
+				clk_disable_unprepare(ctx->mclk);
 			return ret;
 		}
 
@@ -85,6 +87,8 @@ static int platform_clock_control(struct snd_soc_dapm_widget *w,
 			48000 * 512, SND_SOC_CLOCK_IN);
 		if (ret < 0) {
 			dev_err(card->dev, "can't set codec sysclk: %d\n", ret);
+			if (ctx->mclk)
+				clk_disable_unprepare(ctx->mclk);
 			return ret;
 		}
 	} else {
-- 
2.53.0

