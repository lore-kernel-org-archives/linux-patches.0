Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146FC4E80CE;
	Mon, 31 Aug 2026 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183617; cv=none; b=oaF4wUGxQO+hKv5VttyzdsEmbdKnOZIpLkuOtXztJy1qs8uEcoV0lPOvXABdtMYNpTJykVdTXUkFda9eH38kirkLdxo696lVXug57hxTP+QNhozltIYf26/vfOFsSPI0D8aXxSuEyx23KgDLxiCtWrVCXOmLXw1DN5sb3f7f620=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183617; c=relaxed/simple;
	bh=FF0rj7jkhCJv5WeBMBcyBA3vfUyV1mDNwa9GNRVpfts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmNaJhwnHQyZECnqw6inJoSyINj5iid8iWPtL8XZErNhz2yPTQ4AxGHx4giZovAIKhtd0T2DfkJ4OL4lvKtn0DLDA4HLqb2HhTnyC6Op7ULRhU/Cm/xjsEORtulYWcfupVbtlWEjf6bxtBoQ2Q66cFbXhefa8c/HbYPsG6DGRmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAxSGlzk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAxSGlzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E67D1F00A3E;
	Mon, 31 Aug 2026 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183614;
	bh=9tQOm1ZLIVOY99xhF85nCz+7Wr8eSSAaqPMF364hkyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAxSGlzkTR6qQ5UUYM5Y2LRdABUEkwvBUKY4qb6q8CRSi1pY6P2XiJjZcuswz8DOu
	 fcsn8VfuZOyThRCI8RAF13B2khoIwwRB9n1izymbPqOeqbI3raazEzWjqDmAsmQAid
	 wfWJRVkTesHSHDF+2C53Wv0tai4bB4aK+tR2k9Nl4vEyFEeyafYwqw50p9jiDiW0Yl
	 g/LWNF+KJsymOXfArWPx1dJSUGvD9CWCJQbIh9ypRaQvPC4h3sF1dRb0/uinDcTKj/
	 1wPh6JhtbEx3T35WVvOZQ4a6fEz2l7cBrqdar2873i/wu67mwJh+p9eBWD9MqF3HEn
	 kgftRU4U3Tb2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexey Klimov <alexey.klimov@linaro.org>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	s.nawrocki@samsung.com,
	cw00.choi@samsung.com,
	peter.griffin@linaro.org,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] clk: samsung: exynos850: mark APM I3C clocks as critical
Date: Mon, 31 Aug 2026 09:23:47 -0400
Message-ID: <20260831133314.4125787-199-sashal@kernel.org>
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

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 44984aaf1aa727ff944dd4b72fcf069d08b0056d ]

The Exynos850 APM co-processor relies on the I3C bus to communicate with
the PMIC. Currently, there is no dedicated PMIC consumer driver managing
these clocks, so the clock subsystem automatically gates them during the
initialisation. Once gated, any subsequent ACPM communication with APM
results in timeouts.

As a temporary workaround (and let's hope it doesn't become permanent),
mark both `gout_i3c_pclk` and `gout_i3c_sclk` as CLK_IS_CRITICAL ones to
prevent the clock subsystem from disabling them. This makes the ACPM
communication functional. This workaround should be reverted once a
proper ACPM PMIC driver is implemented to manage these clocks.

Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260430-exynos850-i3c-criticalclocks-v1-1-6e1fd8dfa21b@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[clk: samsung: exynos850]` `[mark]` — Mark APM I3C clocks
(`gout_i3c_pclk`, `gout_i3c_sclk`) as `CLK_IS_CRITICAL` to prevent the
clock core from gating them.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Sam Protsenko \<semen.protsenko@linaro.org\>, Tudor
  Ambarus \<tudor.ambarus@linaro.org\>
- **Acked-by:** — none
- **Cc:** Sam Protsenko, Tudor Ambarus (not stable@vger.kernel.org)
- **Link:** https://patch.msgid.link/20260430-exynos850-i3c-
  criticalclocks-v1-1-6e1fd8dfa21b@linaro.org
- **Signed-off-by:** Alexey Klimov, Krzysztof Kozlowski (ignore
  pipeline-added SOBs)

Notable: two Reviewed-by tags from Linaro Exynos850 platform developers;
no syzbot or user bug reports.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** With no PMIC consumer driver holding references, the clock
  framework gates `gout_i3c_pclk` and `gout_i3c_sclk` during init.
- **Symptom:** After gating, all ACPM communication with the Exynos850
  APM co-processor times out.
- **Root cause:** APM uses I3C to talk to the PMIC; those bus clocks
  must stay enabled but nothing claims them.
- **Fix approach:** Temporary `CLK_IS_CRITICAL` workaround until a
  proper ACPM PMIC driver manages the clocks.
- **Version info:** none in the message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as a workaround, but it fixes real broken
platform behavior (ACPM timeouts). Same pattern as other
`CLK_IS_CRITICAL` entries in this file for clocks that must stay on
without a consumer driver.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/clk/samsung/clk-exynos850.c` (+3 / −2, net +1 line)
- **Functions:** `apm_gate_clks[]` static init table (inside
  `exynos850_cmu_apm` init path)
- **Scope:** Single-file, surgical hardware workaround

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (I3C PCLK gate):** `GATE(..., 0, 0)` → `GATE(...,
  CLK_IS_CRITICAL, 0)` for `gout_i3c_pclk`
- **Hunk 2 (I3C SCLK gate):** `GATE(..., 0, 0)` → `GATE(...,
  CLK_IS_CRITICAL, 0)` for `gout_i3c_sclk`
- **Path affected:** Boot-time APM CMU clock registration; prevents
  automatic disable of I3C clocks after init.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware workaround / clock-gating correctness
- **Mechanism:** Ungated clocks with no consumer get disabled by
  `clk_disable_unused()`; APM I3C to PMIC then stops working and ACPM
  mailbox traffic times out.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: mirrors `gout_pmu_alive_pclk` on line 698 in the
  same table.
- Minimal, no API changes.
- **Regression risk:** Low — keeps two clocks enabled that must remain
  on; minor power cost on Exynos850 only.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** In this checkout, I3C gate lines are at 687–690 with flags
`0, 0`. Blame points to `a112b91dd6349` (history is flattened in this
stable checkout). Verified directly: buggy code is present at HEAD.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:**
- Commit `44984aaf1aa72` on `master` is this fix.
- Related on master: `e57c36bc1a3e4` (APM-to-AP mailbox clock).
- Fix is **not** an ancestor of HEAD (`fix NOT in HEAD`).
- Standalone 1/1 patch (b4 dig `-a` shows only v1).

### Step 3.4: Author Context
**Record:** Alexey Klimov (Linaro). Reviewed by Sam Protsenko (original
Exynos850 clk author per file copyright). Krzysztof Kozlowski (Samsung
clk maintainer) committed it.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `CLK_IS_CRITICAL` and
`GATE()` macro. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/20260430-exynos850-i3c-
  criticalclocks-v1-1-6e1fd8dfa21b@linaro.org
- **Revisions:** v1 only
- **Feedback:** Sam Protsenko Reviewed-by (May 8); Tudor Ambarus
  Reviewed-by (May 6); Krzysztof Kozlowski "Applied, thanks!" (May 14)
- **Stable nomination:** none in thread
- **NAKs:** none

### Step 4.2: Reviewers
**Record:** CC'd: Krzysztof Kozlowski, Sylwester Nawrocki, Chanwoo Choi,
Alim Akhtar, Michael Turquette, Stephen Boyd, linux-clk@vger.kernel.org,
linux-samsung-soc@vger.kernel.org. Appropriate maintainers were
included.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Issue comes from
platform bring-up experience (Linaro/Samsung Exynos850 work).

### Step 4.4: Related Patches
**Record:** Standalone; not part of a multi-patch series.

### Step 4.5: Stable List History
**Record:** Lore fetch blocked by bot protection for web search; mbox
thread has no stable discussion. UNVERIFIED for lore.kernel.org/stable
search.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `apm_gate_clks[]` in `drivers/clk/samsung/clk-exynos850.c`;
registered via `exynos850_cmu_apm` `CLK_OF_DECLARE` path.

### Step 5.2: Callers
**Record:** Samsung CMU init during early DT clock probe for
`samsung,exynos850-cmu-apm` (present in
`arch/arm64/boot/dts/exynos/exynos850.dtsi`). Runs at boot on Exynos850
boards.

### Step 5.3: Callees
**Record:** `GATE()` macro populates `samsung_gate_clock` with `.flags =
CLK_IS_CRITICAL`, preventing disable when unused.

### Step 5.4: Reachability
**Record:** Boot path on Exynos850 (`exynos850-e850-96.dts`,
`exynosautov920*.dts`, etc.). ACPM (`drivers/firmware/samsung/exynos-
acpm.c`) uses mailbox to APM; PMIC access depends on APM I3C staying up.

### Step 5.5: Similar Patterns
**Record:** Same file already uses `CLK_IS_CRITICAL` for
`gout_pmu_alive_pclk` (line 698) and many other gates. GPIO gates use
`CLK_IGNORE_UNUSED` with TODO comments for the same class of problem.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, Makefile 6.18.43). At HEAD lines 687–690:

```687:690:drivers/clk/samsung/clk-exynos850.c
        GATE(CLK_GOUT_I3C_PCLK, "gout_i3c_pclk", "dout_apm_bus",
             CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_PCLK, 21, 0, 0),
        GATE(CLK_GOUT_I3C_SCLK, "gout_i3c_sclk", "mout_apm_i3c",
             CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_SCLK, 21, 0, 0),
```

Also confirmed at `v6.18` and `v6.18.43` tags. Exynos850 DT and drivers
are present in this tree.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 5-line change, no conflicts. File is
2338 lines with no recent churn in this stable branch.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `git merge-base --is-ancestor 44984aaf1aa72 HEAD` → fix
**NOT** in HEAD.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/clk/samsung/` — **IMPORTANT** (platform-specific
clock driver). Exynos850 is ARM64 SoC support (consumer boards +
automotive `exynosautov920`).

### Step 7.2: Subsystem Activity
**Record:** Exynos850 clk driver is actively maintained; recent master
commits add mailbox clocks and this I3C fix.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Exynos850 platform users only — WinLink E850-96, Exynos Auto
V920, and other `samsung,exynos850` boards using ACPM/APM PMIC
communication.

### Step 8.2: Trigger Conditions
**Record:** Every boot on affected hardware after clock init completes
and `clk_disable_unused()` runs. Deterministic, not a race. Unprivileged
users cannot trigger directly, but all Exynos850 boots hit this path.

### Step 8.3: Failure Mode Severity
**Record:** ACPM communication timeouts → broken PMIC co-processor path.
**Severity: HIGH** for affected platforms (essential firmware
communication broken; power/PMIC management non-functional). Not a
kernel oops, but platform is effectively broken for ACPM consumers.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for Exynos850 users on 6.18.y
- **Risk:** VERY LOW — 2 flag changes + comment; established pattern
- **Ratio:** Strong benefit for affected hardware, negligible risk
  elsewhere

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible platform bug in this tree (6.18.43)
- Breaks ACPM/APM PMIC communication on every affected boot
- Tiny, obviously correct hardware workaround
- Reviewed by Exynos850 platform experts and committed by clk maintainer
- Fits hardware-quirk exception (clock must stay on)
- Clean backport, no dependencies
- Fix not yet in stable/linux-6.18.y

**AGAINST backport:**
- Platform-specific (Exynos850 only)
- Labeled "temporary workaround"
- No kernel crash/oops/security issue — functional timeout
- No explicit stable nomination in review thread

**Unresolved:** Stable mailing list search blocked by lore bot
protection.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — matches existing
   `CLK_IS_CRITICAL` pattern; reviewed by platform developers
2. Fixes a real bug affecting users? **PASS** — ACPM timeouts on
   Exynos850
3. Important issue? **PASS** — breaks essential APM/PMIC communication
   on affected SoCs
4. Small and contained? **PASS** — 5 lines, one file
5. No new features or APIs? **PASS** — flag change only
6. Can apply to local tree? **PASS** — buggy code present, clean apply

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround — clocks that must remain enabled
for PMIC I3C on APM, analogous to existing `CLK_IS_CRITICAL` entries in
the same table.

### Step 9.4: Decision Rationale
Exynos850 support is fully present in this 6.18.43 stable tree, and the
I3C clock gating bug is present without the fix. Without this patch,
ACPM communication with the APM co-processor fails after boot-time clock
initialization — a serious functional defect for every Exynos850
deployment on 6.18.y. The fix is minimal, follows an established pattern
in the same file, and carries negligible regression risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes:/Reported-by/syzbot;
  two Reviewed-by from Linaro
- [Phase 2] Diff: 5 lines in `clk-exynos850.c`, `CLK_IS_CRITICAL` on two
  I3C gates
- [Phase 3] `git describe HEAD` → v6.18.43; `44984aaf1aa72` on master;
  `fix NOT in HEAD`
- [Phase 3] `git show 44984aaf1aa72` — full commit message and patch
  confirmed
- [Phase 3] `git cat-file -e v6.18:drivers/clk/samsung/clk-exynos850.c`
  — file exists (2338 lines)
- [Phase 3] `git show v6.18.43:...` — I3C gates have `0, 0` flags
  (buggy)
- [Phase 4] `b4 dig -c 44984aaf1aa72` — lore URL found
- [Phase 4] `b4 dig -c 44984aaf1aa72 -w` — maintainers CC'd
- [Phase 4] `b4 dig -c 44984aaf1aa72 -a` — v1 only, standalone
- [Phase 4] `/tmp/exynos850-i3c.mbox` — Reviewed-by from Sam Protsenko
  and Tudor Ambarus; Krzysztof applied; no stable nomination
- [Phase 5] Grep: `gout_i3c_pclk` at lines 687–690 with flags `0, 0`;
  `gout_pmu_alive_pclk` uses `CLK_IS_CRITICAL` at line 698
- [Phase 5] DT: `exynos850.dtsi`, `exynos850-e850-96.dts`,
  `exynosautov920.dtsi` present
- [Phase 5] ACPM driver present at `drivers/firmware/samsung/exynos-
  acpm.c`
- [Phase 6] HEAD detached from `stable/linux-6.18.y` at Linux 6.18.43
- [Phase 6] Buggy code verified at HEAD; fix absent from tree
- [Phase 8] Failure mode: ACPM timeouts, HIGH severity for Exynos850
  platforms
- UNVERIFIED: lore.kernel.org/stable search (bot protection)

**YES**

 drivers/clk/samsung/clk-exynos850.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos850.c b/drivers/clk/samsung/clk-exynos850.c
index 56f27697c76b1..413faf14eded9 100644
--- a/drivers/clk/samsung/clk-exynos850.c
+++ b/drivers/clk/samsung/clk-exynos850.c
@@ -684,10 +684,11 @@ static const struct samsung_gate_clock apm_gate_clks[] __initconst = {
 	     CLK_CON_GAT_GOUT_APM_APBIF_RTC_PCLK, 21, 0, 0),
 	GATE(CLK_GOUT_TOP_RTC_PCLK, "gout_top_rtc_pclk", "dout_apm_bus",
 	     CLK_CON_GAT_GOUT_APM_APBIF_TOP_RTC_PCLK, 21, 0, 0),
+	/* TODO: Should be dealt with or enabled in PMIC ACPM driver */
 	GATE(CLK_GOUT_I3C_PCLK, "gout_i3c_pclk", "dout_apm_bus",
-	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_PCLK, 21, 0, 0),
+	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_PCLK, 21, CLK_IS_CRITICAL, 0),
 	GATE(CLK_GOUT_I3C_SCLK, "gout_i3c_sclk", "mout_apm_i3c",
-	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_SCLK, 21, 0, 0),
+	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_SCLK, 21, CLK_IS_CRITICAL, 0),
 	GATE(CLK_GOUT_SPEEDY_PCLK, "gout_speedy_pclk", "dout_apm_bus",
 	     CLK_CON_GAT_GOUT_APM_SPEEDY_APM_PCLK, 21, 0, 0),
 	/* TODO: Should be enabled in GPIO driver (or made CLK_IS_CRITICAL) */
-- 
2.53.0

