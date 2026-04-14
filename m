Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458EB3DE426;
	Tue, 14 Apr 2026 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165924; cv=none; b=MmFzafxj3CZCwprrubvzbpJ69pJwNnIu/yTJCeJ49DqkYYDZ9jmJWBlE3xERtZ/P6ub6WaXMwiupQ73P3R/KmATpPeGbCH8eSBfBXFb2X6hxRZaw1OddJbE6cXxxP4zgtb/SufVKqzFFKuaJjHG/dQ1QP2ts3J88ZqHMTDuUkU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165924; c=relaxed/simple;
	bh=Ta/hm6NRVE22lBnoq5DBMBWzc8sZInol9jpzrXHLxFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYQu6LHJ72jaQjHpWCetTA8ai5dRtFlsrRkzUbovBJjJJsGqhFthZ24+vw4l1xyergedckQl6tWWYt8wlCUlVH0zakU9YNiZinads9aWufpRgVE0B7rF++pwJnbaPeoIPuf1HdT2Ht13+lepOG3K+k/MxNMqvqzp4ThArt1C0jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJY6Q+pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJY6Q+pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC26C2BCB6;
	Tue, 14 Apr 2026 11:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165924;
	bh=Ta/hm6NRVE22lBnoq5DBMBWzc8sZInol9jpzrXHLxFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJY6Q+pOpjWAdBnTGZH79OA77LDJMeEASW0EYU6/PT6eTAX5Bspa+knn/teKkf4rL
	 Zunnyk82zPQAwhht73yRQbrvkjJLebmHyhYcS0VJf0aBSZQOfcMqeVDpQDRuBqhG0l
	 VVq3t2F/OLn0uQI+zpAdBs6xJxJF7aW+pZTxgDyCLdDvKXi+JKI2evTRomJhaiYe0D
	 Z8bQNJew2JJS/EFqxSZy+onPU43w+DnYXjDkjkgJGuDRnIZWQMDub1fme7fuYWlhbO
	 n/CFkfLbpkfDbACULxjW26cvbEdC0596ScD1o+QwjAj+d3nwEIt0vX9RiwpX8o6yy5
	 BYydfjlhE82gA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomasz Merta <tomasz.merta@arrow.com>,
	Tomasz Merta <tommerta@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	olivier.moysan@foss.st.com,
	arnaud.pouliquen@foss.st.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ASoC: stm32_sai: fix incorrect BCLK polarity for DSP_A/B, LEFT_J
Date: Tue, 14 Apr 2026 07:25:05 -0400
Message-ID: <20260414112509.410217-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414112509.410217-1-sashal@kernel.org>
References: <20260414112509.410217-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.12
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomasz Merta <tomasz.merta@arrow.com>

[ Upstream commit 0669631dbccd41cf3ca7aa70213fcd8bb41c4b38 ]

The STM32 SAI driver do not set the clock strobing bit (CKSTR) for DSP_A,
DSP_B and LEFT_J formats, causing data to be sampled on the wrong BCLK
edge when SND_SOC_DAIFMT_NB_NF is used.

Per ALSA convention, NB_NF requires sampling on the rising BCLK edge.
The STM32MP25 SAI reference manual states that CKSTR=1 is required for
signals received by the SAI to be sampled on the SCK rising edge.
Without setting CKSTR=1, the SAI samples on the falling edge, violating
the NB_NF convention. For comparison, the NXP FSL SAI driver correctly
sets FSL_SAI_CR2_BCP for DSP_A, DSP_B and LEFT_J, consistent with its
I2S handling.

This patch adds SAI_XCR1_CKSTR for DSP_A, DSP_B and LEFT_J in
stm32_sai_set_dai_fmt which was verified empirically with a cs47l35 codec.
RIGHT_J (LSB) is not investigated and addressed by this patch.

Note: the STM32 I2S driver (stm32_i2s_set_dai_fmt) may have the same issue
for DSP_A mode, as I2S_CGFR_CKPOL is not set. This has not been verified
and is left for a separate investigation.

Signed-off-by: Tomasz Merta <tommerta@gmail.com>
Link: https://patch.msgid.link/20260408084056.20588-1-tommerta@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have comprehensive data. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
- **Subsystem:** ASoC: stm32_sai (STM32 Serial Audio Interface driver)
- **Action verb:** "fix" — explicitly a bug fix
- **Summary:** Fixes incorrect BCLK (bit clock) polarity for DSP_A,
  DSP_B, and LEFT_J audio formats

Record: [ASoC: stm32_sai] [fix] [incorrect BCLK polarity for DSP_A/B,
LEFT_J formats]

### Step 1.2: Parse All Commit Message Tags
- **Signed-off-by:** Tomasz Merta <tommerta@gmail.com> — patch author
- **Link:**
  https://patch.msgid.link/20260408084056.20588-1-tommerta@gmail.com —
  patch submission link
- **Signed-off-by:** Mark Brown <broonie@kernel.org> — ASoC subsystem
  maintainer applied it
- **No Fixes: tag** — expected for commits under review
- **No Cc: stable** — expected for commits under review
- **No Reported-by** — author discovered this themselves

Record: Applied by Mark Brown (ASoC maintainer). No Fixes: or Cc:stable
tags. Single-patch submission, no series.

### Step 1.3: Analyze the Commit Body Text
The commit explains:
- **Bug:** The CKSTR (Clock STRobing) bit is not set for DSP_A, DSP_B,
  and LEFT_J formats
- **Symptom:** Data sampled on the wrong BCLK edge when
  SND_SOC_DAIFMT_NB_NF is used
- **Root cause:** Per ALSA convention, NB_NF (Normal Bit clock, Normal
  Frame) requires sampling on the rising BCLK edge. The STM32MP25
  reference manual confirms CKSTR=1 is needed for rising edge sampling.
  Without it, data is sampled on the falling edge.
- **Verification:** Empirically verified with a cs47l35 codec
- **Reference:** NXP FSL SAI driver correctly sets the equivalent bit
  for these formats

Record: Real hardware bug — audio data sampled on wrong clock edge for
DSP_A, DSP_B, LEFT_J formats. Causes incorrect audio behavior.

### Step 1.4: Detect Hidden Bug Fixes
This is an explicit bug fix — not hidden. The subject says "fix" and the
commit describes the exact hardware behavior violation.

Record: Explicit bug fix, no hidden nature.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
- **File:** sound/soc/stm/stm32_sai_sub.c
- **Lines added:** 3
- **Lines removed:** 0
- **Functions modified:** `stm32_sai_set_dai_fmt()`
- **Scope:** Single-file, single-function, surgical fix

Record: 1 file, +3 lines, 0 removed. Only stm32_sai_set_dai_fmt()
modified. Extremely small and surgical.

### Step 2.2: Understand the Code Flow Change
Three hunks, each adding `cr1 |= SAI_XCR1_CKSTR;`:
1. **SND_SOC_DAIFMT_MSB (LEFT_J):** Before: only set FSPOL and FSDEF.
   After: also sets CKSTR for rising-edge sampling.
2. **SND_SOC_DAIFMT_DSP_A:** Before: only set FSPOL and FSOFF. After:
   also sets CKSTR.
3. **SND_SOC_DAIFMT_DSP_B:** Before: only set FSPOL. After: also sets
   CKSTR.

The I2S case already had `cr1 |= SAI_XCR1_CKSTR;` — the fix makes the
other formats consistent.

Note the later code at line 828-832: the SND_SOC_DAIFMT_INV_MASK switch
uses XOR (`cr1 ^= SAI_XCR1_CKSTR`) to invert the polarity. Without CKSTR
being initially set, the XOR for IB_NF would SET it instead of clearing
it — the inversion logic only works correctly when CKSTR starts at the
right default value.

Record: Each hunk adds the missing CKSTR bit to a format case. Fix makes
DSP_A, DSP_B, LEFT_J consistent with I2S (which already had CKSTR). Also
fixes the inversion logic interaction.

### Step 2.3: Identify the Bug Mechanism
Category: **Logic/correctness fix** — missing hardware register bit
configuration.

The STM32 SAI hardware defaults to sampling on the falling edge
(CKSTR=0). ALSA convention says NB_NF means rising edge. Without setting
CKSTR=1 for these formats, audio data is sampled on the wrong clock
edge, leading to corrupted or incorrect audio output.

Record: Logic/correctness bug. Missing register bit causes wrong clock
edge for audio sampling.

### Step 2.4: Assess the Fix Quality
- **Obviously correct:** Yes. The I2S case already sets CKSTR, and the
  FSL SAI driver (a well-established reference implementation) sets the
  equivalent bit for all these formats. The hardware reference manual
  confirms CKSTR=1 is needed.
- **Minimal/surgical:** Extremely — 3 identical one-line additions
- **Regression risk:** Very low. Only affects users of STM32 SAI with
  DSP_A, DSP_B, or LEFT_J formats. Cannot affect other formats or other
  hardware.
- **Red flags:** None

Record: Obviously correct (confirmed by reference manual, FSL SAI
comparison, empirical testing). Zero regression risk for unaffected
configurations.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
The buggy code was introduced by commit `3e086edfe0c73d` ("ASoC: stm32:
add SAI driver") from 2017-04-10, by Olivier Moysan. This was the
**initial driver commit** creating the entire stm32_sai_sub.c file.
First appeared in **v4.12**.

Record: Bug present since the initial driver addition in v4.12 (2017).
Present in ALL stable trees that have this driver.

### Step 3.2: Follow the Fixes: Tag
No Fixes: tag present. The implicit fixes target is `3e086edfe0c73d`
(the initial driver commit).

Record: Bug is original to the driver (v4.12). Present in all stable
trees.

### Step 3.3: Check File History for Related Changes
Recent changes to stm32_sai_sub.c are mostly cleanup, probe error path
fixes, and stm32mp25 support additions. None touch the
`stm32_sai_set_dai_fmt()` function's format handling.

Record: No recent changes to the same code region. Patch applies cleanly
to any stable tree containing this driver.

### Step 3.4: Check the Author's Other Commits
Tomasz Merta has no other commits in the kernel tree. This is a first-
time contributor. However, the fix was accepted by Mark Brown (ASoC
subsystem maintainer) which validates it.

Record: First-time contributor, but fix accepted by subsystem maintainer
Mark Brown.

### Step 3.5: Check for Dependent/Prerequisite Commits
None. The fix adds 3 identical lines (`cr1 |= SAI_XCR1_CKSTR;`) in
switch cases that have been unchanged since v4.12. No dependencies.

Record: Fully standalone. No prerequisites needed.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Find the Original Patch Discussion
From the agent research: The patch was submitted on April 8, 2026, and
applied by Mark Brown the same day to his `for-7.0` branch. Only two
messages in the thread — submission and Mark Brown's automated "Applied
to" message. No substantive review discussion.

Record: Lore URL:
https://patch.msgid.link/20260408084056.20588-1-tommerta@gmail.com.
Applied same day by maintainer. No concerns raised.

### Step 4.2: Check Who Reviewed the Patch
Mark Brown (ASoC maintainer) applied the patch. Olivier Moysan (original
STM32 SAI driver author) was CC'd but did not comment.

Record: Applied by subsystem maintainer. No objections.

### Step 4.3: Search for Bug Report
No formal Reported-by tag. Author discovered this empirically while
working with a cs47l35 codec on STM32 hardware.

Record: Author-discovered bug during empirical testing.

### Step 4.4: Check for Related Patches and Series
Single patch, not part of a series. The commit message notes the STM32
I2S driver may have a similar issue but that is a separate
investigation.

Record: Standalone fix.

### Step 4.5: Check Stable Mailing List History
No prior stable discussion found for this specific issue.

Record: No prior stable discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Identify Key Functions in the Diff
Only `stm32_sai_set_dai_fmt()` is modified.

### Step 5.2: Trace Callers
`stm32_sai_set_dai_fmt` is registered as `.set_fmt` in two
`snd_soc_dai_ops` structs (lines 1368 and 1380). It is called by the
ASoC framework during DAI configuration — a standard, commonly exercised
path whenever audio playback/capture begins with this hardware.

Record: Called by ASoC framework during DAI setup. Common path for any
audio operation on STM32 SAI hardware.

### Step 5.3-5.4: Trace Callees and Call Chain
The function configures hardware registers via `regmap_update_bits`.
Standard ASoC driver pattern with no unusual side effects.

Record: Standard register configuration function.

### Step 5.5: Search for Similar Patterns
Confirmed by FSL SAI driver comparison: `fsl_sai.c` lines 325, 333, 342,
351 all set `FSL_SAI_CR2_BCP` (the equivalent bit) for I2S, LEFT_J,
DSP_A, and DSP_B formats. The STM32 SAI driver was missing it for 3 of 4
formats.

Record: FSL SAI driver confirms the correct pattern — BCP/CKSTR must be
set for all these formats.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Does the Buggy Code Exist in Stable Trees?
The buggy code was introduced in v4.12. The function
`stm32_sai_set_dai_fmt()` and the specific switch cases have been
unchanged since then. The bug exists in **all active stable trees**
(5.10, 5.15, 6.1, 6.6, 6.12+).

Record: Bug present in all active stable trees.

### Step 6.2: Check for Backport Complications
None of the recent commits touch the format switch in
`stm32_sai_set_dai_fmt()`. The patch adds simple one-line additions to
existing switch cases. Expected to apply cleanly to all stable trees.

Record: Clean apply expected for all stable trees.

### Step 6.3: Check if Related Fixes Are Already in Stable
No related clock polarity fixes have been applied to this driver.

Record: No existing fixes for this issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Identify the Subsystem and Its Criticality
- **Subsystem:** ASoC (ALSA System on Chip) / STM32 SAI driver
- **Criticality:** PERIPHERAL — affects STM32 (ARM embedded) platform
  users
- **User base:** STM32MP1, STM32MP2 series users running Linux (embedded
  systems, IoT, industrial)

Record: PERIPHERAL. Affects STM32 ARM SoC users.

### Step 7.2: Assess Subsystem Activity
The stm32_sai_sub.c file has had 65 changes since v4.19. Moderate
activity, mostly maintenance and cleanup. The core format handling code
has been stable since v4.12.

Record: Moderate activity. Format handling code very stable.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Determine Who Is Affected
Users of STM32 SAI hardware using DSP_A, DSP_B, or LEFT_J audio formats
with codecs. This is specific to STM32 embedded platform users.

Record: STM32 SAI users with DSP_A/DSP_B/LEFT_J formats. Niche but real
user population.

### Step 8.2: Determine the Trigger Conditions
The bug triggers whenever:
1. STM32 SAI driver is used (common on STM32MP platforms)
2. Audio format is DSP_A, DSP_B, or LEFT_J (common for certain codecs)
3. NB_NF clock polarity convention is used (the default/normal case)

This is deterministic — it always triggers for these configurations, not
a race or timing issue.

Record: Deterministic trigger for affected configurations. Always
broken, not intermittent.

### Step 8.3: Determine the Failure Mode Severity
- Audio data sampled on wrong clock edge
- Results in **incorrect audio output** — corrupted, distorted, or
  silent audio
- This is a **functional correctness** issue, not a crash or security
  issue
- Severity: **MEDIUM** — incorrect hardware behavior, but no
  crash/corruption/security impact

Record: Incorrect audio output. MEDIUM severity. No crash or data
corruption.

### Step 8.4: Calculate Risk-Benefit Ratio
- **BENEFIT:** Medium. Fixes broken audio for STM32 SAI users with
  DSP_A/DSP_B/LEFT_J formats. Deterministic bug.
- **RISK:** Very low. 3 one-line additions. Identical pattern to
  existing I2S case. Cannot affect other formats or other hardware.
  Confirmed correct by hardware reference manual and NXP FSL SAI
  reference implementation.
- **Ratio:** Favorable. Very low risk, meaningful benefit for affected
  users.

Record: Benefit=MEDIUM, Risk=VERY LOW. Favorable ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Compile the Evidence

**Evidence FOR backporting:**
- Fixes a real hardware bug: audio data sampled on wrong clock edge
- Bug present since v4.12 (initial driver addition) — affects all stable
  trees
- Extremely small and surgical: 3 identical one-line additions
- Obviously correct: confirmed by hardware reference manual, FSL SAI
  reference driver, and empirical testing
- No dependencies or prerequisites
- Will apply cleanly to all stable trees
- Accepted by subsystem maintainer Mark Brown
- Deterministic bug (always triggers for affected configs)

**Evidence AGAINST backporting:**
- Driver-specific, affecting only STM32 SAI users
- No crash, data corruption, or security impact — functional audio
  correctness only
- No Reported-by tags — unclear how many users are affected in practice
- No formal bug reports from users

**Unresolved:**
- Exact number of users affected is unknown (STM32 embedded is a niche
  but real market)

### Step 9.2: Apply the Stable Rules Checklist
1. **Obviously correct and tested?** YES — empirically verified with
   cs47l35 codec, confirmed by hardware manual and FSL SAI reference
2. **Fixes a real bug?** YES — wrong clock edge for audio sampling
3. **Important issue?** MEDIUM — incorrect audio output, not
   crash/security
4. **Small and contained?** YES — 3 lines in 1 file, 1 function
5. **No new features or APIs?** Correct — pure bug fix
6. **Can apply to stable trees?** YES — clean apply expected

### Step 9.3: Check for Exception Categories
This falls under a **hardware workaround/correctness fix** — fixing
incorrect hardware register configuration for an existing driver.

### Step 9.4: Decision
This is a well-understood, minimal, obviously correct fix for a real
hardware bug that has existed since the driver was first added. While it
only affects STM32 SAI users with specific audio formats (not a crash or
security issue), the fix is so small and risk-free that the benefit
clearly outweighs the negligible risk. It meets all stable kernel
criteria and is the kind of small driver fix that routinely goes to
stable.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (Tomasz Merta) and
  maintainer (Mark Brown). Link to patch.msgid.link. No Fixes: or Cc:
  stable (expected).
- [Phase 2] Diff analysis: 3 identical one-line additions of `cr1 |=
  SAI_XCR1_CKSTR;` in MSB, DSP_A, DSP_B cases of
  stm32_sai_set_dai_fmt().
- [Phase 2] FSL SAI comparison verified: fsl_sai.c:325,333,342,351 all
  set FSL_SAI_CR2_BCP for I2S, LEFT_J, DSP_A, DSP_B — confirms the STM32
  fix is correct.
- [Phase 2] SAI_XCR1_CKSTR definition verified: stm32_sai.h:63 defines
  it as BIT(9).
- [Phase 3] git blame: all affected lines trace to 3e086edfe0c73d
  (2017-04-10, "ASoC: stm32: add SAI driver"), first in v4.12.
- [Phase 3] git tag --contains 3e086edfe0c73d: confirms first release
  was v4.12-rc1.
- [Phase 3] No other commits touch the format switch in
  stm32_sai_set_dai_fmt — clean apply expected.
- [Phase 3] Author (Tomasz Merta) has no other kernel commits — first-
  time contributor.
- [Phase 4] Mailing list: 2-message thread. Applied by Mark Brown same
  day. No objections, no stable nomination.
- [Phase 5] stm32_sai_set_dai_fmt registered in .set_fmt ops (lines
  1368, 1380) — called by ASoC framework during standard DAI setup.
- [Phase 6] File exists unchanged in all stable trees (v5.10+, v6.1+,
  v6.6+). No conflicting changes to the format switch.
- [Phase 7] Subsystem: ASoC STM32 SAI. PERIPHERAL criticality.
- [Phase 8] Failure mode: incorrect audio sampling (wrong clock edge).
  MEDIUM severity. VERY LOW regression risk.

**YES**

 sound/soc/stm/stm32_sai_sub.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 450e1585edeee..3e82fa90e719a 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -802,6 +802,7 @@ static int stm32_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
 		break;
 	/* Left justified */
 	case SND_SOC_DAIFMT_MSB:
+		cr1 |= SAI_XCR1_CKSTR;
 		frcr |= SAI_XFRCR_FSPOL | SAI_XFRCR_FSDEF;
 		break;
 	/* Right justified */
@@ -809,9 +810,11 @@ static int stm32_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
 		frcr |= SAI_XFRCR_FSPOL | SAI_XFRCR_FSDEF;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
+		cr1 |= SAI_XCR1_CKSTR;
 		frcr |= SAI_XFRCR_FSPOL | SAI_XFRCR_FSOFF;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
+		cr1 |= SAI_XCR1_CKSTR;
 		frcr |= SAI_XFRCR_FSPOL;
 		break;
 	default:
-- 
2.53.0

