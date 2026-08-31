Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA2F4D90D4;
	Mon, 31 Aug 2026 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183559; cv=none; b=pOZC7YULYF0xptAO4tDdDWZGv6ZoGRFVzqgSwGahFhmS+ctOwXngil6DD5xfzEKYiLDKL+Q/IlZIdW3dUw/YSpgvcpLs9Hv4zabmZa/jhD3cry1/ljQh6MWwYqYRgW8oNPSaKJEAjgXJb4r2rWvnDZZd5QIPfAarHNUHG3nWSyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183559; c=relaxed/simple;
	bh=SMu6jGMzSN/PynIw1zhY5XdTivHH6CFyhp05zTT8QDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YN6c3LQzoZHSSp82fHoo0YpVufwgthRXsHNXTYySzJ8oYCI8bNm9lUMj8JcSVSnMs0SzCIOulFYLNrjZu+qevim2aUDqK52D4qgvazsa3FyOTOukEW0iAwd2ffjK+IhrAXATaur4cqAi337u64vI/lzSx+pXEv9La46YhTA3K+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PU5rtCXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PU5rtCXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6121F00ACA;
	Mon, 31 Aug 2026 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183556;
	bh=q85irKaJ5z/54tGl3R65hQIMxlS1xsWlaoAmw4QkZv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PU5rtCXXHePct+j6n4P55/bdoDs0wNhbQsubt4ne3FXAAMW50tmAjL2LE27bmipZr
	 VwzvF4W5R7GZ5ryPpH8zcNMUUQsSonar3SYvG0j9VjA7tzQwu3E3cIJaF51ROZuCq0
	 EpS1nbC+xsElZfKEvWd57AW/Dgoijgq947GFJm5S6CIlpqQebXCJghZVtPz1Y0pbqw
	 PVS4pA89AcTvSBIXcNPO+SSK9opHrUAscyOskihswQuQl8bqZL4+9uYiq21PGLKsm5
	 O95a384vTxzr2SOQOxjtQZtObvmLC8ocCcFHrywVXO7WC7zhKOfO+yopVdQvnFUzAb
	 f6JpC6PBGN4tA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: bui duc phuc <phucduc.bui@gmail.com>,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	heiko@sntech.de,
	linux-sound@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: rockchip: rockchip_pdm: Handle runtime PM resume failures in set_fmt
Date: Mon, 31 Aug 2026 09:23:15 -0400
Message-ID: <20260831133314.4125787-167-sashal@kernel.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit ee7b5f7b39332febf917f9ebf212842cc9379815 ]

rockchip_pdm_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260522110302.349421F000E9@smtp.kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse Subject Line
**Record:** `[ASoC: rockchip: rockchip_pdm]` `[Handle]` — Handle runtime
PM resume failures in the `set_fmt` DAI callback.

### Step 1.2: Parse All Commit Message Tags
**Record:**
| Tag | Value |
|-----|-------|
| Reported-by | Sashiko AI Review \<sashiko-bot@kernel.org\> |
| Closes |
https://lore.kernel.org/all/20260522110302.349421F000E9@smtp.kernel.org/
|
| Link |
https://patch.msgid.link/20260602101608.45137-6-phucduc.bui@gmail.com |
| Signed-off-by | bui duc phuc \<phucduc.bui@gmail.com\> |
| Signed-off-by | Mark Brown \<broonie@kernel.org\> (committer/ASoC
maintainer) |

Notable patterns: Static-analysis report (Sashiko AI), not syzbot or a
user crash report. No `Fixes:` tag (expected). No `Cc:
stable@vger.kernel.org`. Mark Brown merged it.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `rockchip_pdm_set_fmt()` calls `pm_runtime_get_sync()` but
  ignores its return value. If runtime resume fails, register writes
  proceed while the device is not powered/resumed.
- **Symptom:** Undefined device state; unpowered register accesses
  (historically documented as system hang in this driver).
- **Root cause:** Incomplete error handling when runtime PM resume fails
  (clock enable failure in `rockchip_pdm_runtime_resume()`).
- **Fix:** Replace `pm_runtime_get_sync()` with
  `pm_runtime_resume_and_get()` and return the error early.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised as cleanup — explicitly a bug fix. It
completes error handling that was left incomplete when runtime PM was
added to `set_fmt` in 2019 (commit `c85064435fe7a2`).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory Changes
**Record:**
- **File:** `sound/soc/rockchip/rockchip_pdm.c` (+5 / −1)
- **Function:** `rockchip_pdm_set_fmt()`
- **Scope:** Single-file, surgical fix (5 lines)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `pm_runtime_get_sync()` → always `regmap_update_bits()` →
  `pm_runtime_put()` → return 0, regardless of resume outcome.
- **After:** `pm_runtime_resume_and_get()` → on failure, return error
  immediately (no register access, no `pm_runtime_put()`) → on success,
  same register access path as before.
- **Path affected:** DAI format configuration during ASoC card setup
  (`set_fmt` callback).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Error-path / logic correctness fix (ignored return value
  → unsafe hardware access).
- **Mechanism:** `rockchip_pdm_runtime_resume()` can fail on
  `clk_prepare_enable()` for `pdm->clk` or `pdm->hclk`. With the old
  code, `pm_runtime_get_sync()` returns negative but execution continues
  to `regmap_update_bits()` on an unpowered controller. The 2019 commit
  that introduced `pm_runtime_get_sync()` here explicitly stated that
  regmap ops with power domain off "will lead system hang."

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct. Matches the pattern already used in
  `rockchip_pdm_resume()` in the same file (since commit
  `76a6f4537650e`, 2022).
- **Regression risk:** Very low. On failure, propagates error to caller
  instead of proceeding unsafely.
- **Red flags:** None. No API changes, no refactoring.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:**
- `rockchip_pdm_set_fmt()` body: original commit `fc05a5b2225306`
  (2017).
- `pm_runtime_get_sync()`/`pm_runtime_put()`: commit `c85064435fe7a2`
  (2019-04-03) — "fix regmap_ops hang issue."
- Buggy ignored-return-value pattern present since 2019.

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: File History for Related Changes
**Record:**
- `76a6f4537650e` (2022): Same `pm_runtime_resume_and_get()` + error
  check applied to `rockchip_pdm_resume()`.
- `ef0a098efb366`: Missing `clk_disable_unprepare()` fix in runtime
  resume.
- Part of series "[PATCH v2 0/5] ASoC: rockchip: Reorder clock enable
  sequence" (patch 5/5), but this hunk is **standalone** — it does not
  depend on the clock-reorder patches (patches 3–4).

### Step 3.4: Author's Other Commits
**Record:** Author phucduc.bui@gmail.com; no prior rockchip ASoC commits
in this tree. Mark Brown (committer) is ASoC maintainer.

### Step 3.5: Prerequisites
**Record:** No prerequisites. `pm_runtime_resume_and_get()` already
exists and is used in this file at line 685. Patch applies cleanly (`git
apply --check` passed).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260602101608.45137-6-phucduc.bui@gmail.com
- **Series:** v2, patch 5/5 of "ASoC: rockchip: Reorder clock enable
  sequence"
- **Sashiko review:** Flagged the ignored `pm_runtime_get_sync()` return
  value; also noted a separate pre-existing clock underflow issue in
  `rockchip_pdm_remove()` (unrelated to this patch).
- **Stable nominations:** None found in thread.
- **NAKs:** None found.

### Step 4.2: Reviewers
**Record:** CC'd Mark Brown, Heiko Stuebner, Liam Girdwood, Takashi
Iwai, linux-sound@, linux-rockchip@. Rob Herring Acked-by on an earlier
patch in the series (DT bindings), not specifically this one. Mark Brown
merged.

### Step 4.3: Bug Report
**Record:** Sashiko AI static analysis (not a runtime crash report).
Original Closes link points to the Sashiko review bot email. Patch
submission notes: **"compile-tested only."**

### Step 4.4: Related Patches / Series
**Record:** Patches 1–4 cover clock reorder and regcache sync in runtime
resume for PDM/SPDIF. This patch (5/5) is independent — only touches
`set_fmt` error handling.

### Step 4.5: Stable Mailing List
**Record:** Not searched separately; no stable nomination found in the
patch thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rockchip_pdm_set_fmt()` (modified); callers via
`rockchip_pdm_dai_ops.set_fmt`.

### Step 5.2: Trace Callers
**Record:**
- `rockchip_pdm_dai_ops.set_fmt` → registered in `rockchip_pdm_dai`
- Called via `snd_soc_dai_set_fmt()` in `sound/soc/soc-dai.c`
- Invoked from `soc-core.c` during machine/DAI link format setup
- **Context:** Normal audio card initialization/configuration path on
  Rockchip boards using PDM microphones.

### Step 5.3: Trace Callees
**Record:** `pm_runtime_resume_and_get()` → may call
`rockchip_pdm_runtime_resume()` → `clk_prepare_enable()`. On success:
`regmap_update_bits()`, `pm_runtime_put()`.

### Step 5.4: Call Chain / Reachability
**Record:** Reachable during audio subsystem setup when a machine driver
configures the PDM DAI format. Requires `CONFIG_SND_SOC_ROCKCHIP_PDM`
(or built-in rockchip audio). Trigger requires runtime resume failure
(e.g., clock failure), which is an error path but realistic.

### Step 5.5: Similar Patterns
**Record:** Same file already uses `pm_runtime_resume_and_get()` with
error check in `rockchip_pdm_resume()` (lines 685–687). Kernel docs in
`include/linux/pm_runtime.h` explicitly recommend
`pm_runtime_resume_and_get()` over `pm_runtime_get_sync()` when the
return value is checked.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Local tree is **v6.18.44** (`git describe HEAD`:
`v6.18.44-1-g2736c32da98b9`). At lines 337–339, `rockchip_pdm_set_fmt()`
still has unchecked `pm_runtime_get_sync()`. Fix commit `ee7b5f7b39332`
is on master but **not** in this tree.

### Step 6.2: Backport Complications
**Record:** Clean apply confirmed. No conflicting changes in the hunk
area. Low difficulty.

### Step 6.3: Related Fixes Already Present?
**Record:** `76a6f4537650e` (pm_runtime_resume_and_get in
`rockchip_pdm_resume`) is present. The `set_fmt` path was missed and
remains unfixed.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **ASoC / Rockchip PDM driver** — IMPORTANT for embedded
Rockchip platforms (rk3229, px30, rk3308, rk3568, rv1126), PERIPHERAL
globally.

### Step 7.2: Subsystem Activity
**Record:** Active — recent commits in `sound/soc/rockchip/` include
SAI, i2s-tdm, and runtime PM cleanups.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Rockchip SoCs with PDM (digital microphone
capture). Config/driver-specific, not universal.

### Step 8.2: Trigger Conditions
**Record:** `set_fmt` called while device is runtime-suspended AND
`rockchip_pdm_runtime_resume()` fails (clock enable failure).
Unprivileged users cannot directly trigger `set_fmt`, but audio
subsystem setup during boot or `modprobe`/card registration can. Failure
path is uncommon but valid.

### Step 8.3: Failure Mode Severity
**Record:** **System hang** — explicitly documented in the 2019 commit
that introduced runtime PM here: "regmap_ops will lead system hang" when
power domain is off. **Severity: CRITICAL** for affected hardware when
triggered; **LOW** probability.

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Prevents potential system hang on Rockchip PDM hardware
  during audio setup error paths; completes incomplete error handling
  from 2019.
- **Risk:** Very low — 5-line change, established API, same pattern
  already in the file.
- **Ratio:** Favorable for backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug: ignored runtime PM resume failure return value
- Documented hang risk from register access without power (2019 commit
  message)
- Small (5 lines), surgical, applies cleanly
- Follows pattern already in same file since 2022
- Merged by ASoC maintainer Mark Brown
- `pm_runtime_resume_and_get()` API present in this tree

**AGAINST backport:**
- Compile-tested only (no hardware Tested-by)
- Found by AI static analysis, not a user crash report
- Driver-specific (Rockchip PDM only)
- Trigger requires runtime resume failure (uncommon)
- Part of a 5-patch series (though this patch is standalone)

**Unresolved:** No hardware testing confirmation; no explicit stable
nomination from reviewers.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logically correct;
compile-tested only |
| 2. Fixes a real bug? | **PASS** — ignored error return on runtime PM
resume |
| 3. Important issue? | **PASS** — potential system hang on affected
hardware |
| 4. Small and contained? | **PASS** — 5 lines, 1 file |
| 5. No new features/APIs? | **PASS** — error handling only |
| 6. Can apply to local tree? | **PASS** — clean apply, buggy code
present |

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
driver bug fix.

### Step 9.4: Problem and Decision Rationale

This commit closes a gap in runtime PM error handling in
`rockchip_pdm_set_fmt()`. When runtime resume fails (e.g., clock enable
error in `rockchip_pdm_runtime_resume()`), the driver previously
proceeded to write hardware registers anyway. The original 2019 fix that
added `pm_runtime_get_sync()` explicitly documented that regmap access
without power causes a **system hang** — this patch ensures that failure
path is handled correctly by returning early, matching the pattern
already applied to `rockchip_pdm_resume()` in the same file.

For the **v6.18.y** tree checked out here, the buggy code is present,
the fix applies cleanly, and the change is minimal with negligible
regression risk. While the trigger is an error path and the patch is
compile-tested only, preventing a documented system hang on real
Rockchip hardware meets stable kernel criteria.

---

## Verification

- **[Phase 1]** Parsed commit `ee7b5f7b39332`: tags, body, Sashiko
  Reported-by
- **[Phase 2]** Diff: +5/−1 in `rockchip_pdm_set_fmt()`; error-path fix
  confirmed
- **[Phase 3]** `git blame -L 319,342`: pm_runtime lines from
  `c85064435fe7a2` (2019)
- **[Phase 3]** `git show c85064435fe7a2`: original commit documents
  system hang without power
- **[Phase 3]** `git show 76a6f4537650e`: same pattern already in
  `rockchip_pdm_resume()`
- **[Phase 3]** `git apply --check`: patch applies cleanly to local tree
- **[Phase 4]** `b4 dig -c ee7b5f7b39332`: lore URL found; patch 5/5 of
  v2 series
- **[Phase 4]** `b4 dig -a`: series context; standalone nature of this
  hunk verified
- **[Phase 4]** `b4 dig -w`: maintainers CC'd; Mark Brown merged
- **[Phase 4]** Mbox: Sashiko review + "compile-tested only" note; no
  stable nomination
- **[Phase 5]** `grep set_fmt sound/soc/soc-dai.c soc-core.c`: call
  chain via ASoC core confirmed
- **[Phase 5]** Read `rockchip_pdm_runtime_resume()`: clock enable
  failure returns negative
- **[Phase 5]** Read `include/linux/pm_runtime.h`: kernel recommends
  `pm_runtime_resume_and_get()`
- **[Phase 6]** `git describe HEAD`: v6.18.44; buggy code at line 337
  confirmed present
- **[Phase 6]** Fix not in tree; `pm_runtime_resume_and_get` already
  used at line 685
- **[Phase 8]** Failure mode: system hang per 2019 commit message;
  severity CRITICAL when triggered

**YES****Verdict: YES** — backport to this tree (v6.18.44).

`rockchip_pdm_set_fmt()` still ignores a failed runtime PM resume and
can touch registers while the PDM block is off; the 2019 hang fix left
that gap. The patch is small (5 lines), applies cleanly, and matches the
pattern already used in `rockchip_pdm_resume()` in the same file. Main
caveat: compile-tested only, found by static analysis rather than a user
crash report.

 sound/soc/rockchip/rockchip_pdm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index c69cdd6f24994..01292b63bf9d6 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -321,6 +321,7 @@ static int rockchip_pdm_set_fmt(struct snd_soc_dai *cpu_dai,
 {
 	struct rk_pdm_dev *pdm = to_info(cpu_dai);
 	unsigned int mask = 0, val = 0;
+	int ret;
 
 	mask = PDM_CKP_MSK;
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
@@ -334,7 +335,10 @@ static int rockchip_pdm_set_fmt(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	pm_runtime_get_sync(cpu_dai->dev);
+	ret = pm_runtime_resume_and_get(cpu_dai->dev);
+	if (ret)
+		return ret;
+
 	regmap_update_bits(pdm->regmap, PDM_CLK_CTRL, mask, val);
 	pm_runtime_put(cpu_dai->dev);
 
-- 
2.53.0

