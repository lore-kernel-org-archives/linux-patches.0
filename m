Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF6E5740AA;
	Mon, 31 Aug 2026 13:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184138; cv=none; b=YrthSnA3AIJhoz7KwVYMZwvxT3SfqZD/T7MFO7Sd0n1DnZKHip8KCtMfsREQGTMWuvProLaHyAJZMhwJJjvDZMvkx3Uq9KLbe6ro5/4C8z8vBeFDPptaD5guJjS2y209GXPDimpu85QGgJdebe1wlx8dMSgp0pxuBRB82OSnP7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184138; c=relaxed/simple;
	bh=1jDpXDiJt1A7Pbmrk3A4boKy0YANjOhgFv7bBY2OXsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGRkE8eTqj8ZLnj4q/OuE1YepW8ph4tNH3vcfVJt3IYJM25faxpT6Cg9I+2mzzamZheM5rzkn42TURoAouv6f76yfiJDdV/tQymnXEOUuTUrJsUbeUBrw697t2mCWPM6ztfoBAa4dCe7kPk/i3+cW0VQoEXuyGTFCo97t53ro5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZITkX+ZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZITkX+ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8F81F00ADB;
	Mon, 31 Aug 2026 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184134;
	bh=hv05+zTA0Jb00LrEJVlNWMYzyTNPLjsQgkanl5k33tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZITkX+ZNYlWjqH6DgI0EHwYULnZQb/gFcNY0as+yHpAJKo9PUJMsfuybHuzA70Ab0
	 M3gkp6s8G8+MkA3od+WD+VFAwH1vdaxtuzyYmRSZisK62PcUGZxvB8FRf+V0lae3aW
	 agk3lRPt+hcmzPp58T2N85pTYlIewBHN4YfcZYeb60k1s7kso0dSg8a3m0r/ZbxDkK
	 6mgTxp41IZ+kAMa2GXpoTQ7lNb5hfoaGMGFRcYEAG2nkvG3ViY0zc3gmREVRYybszG
	 cAqJxubhdbZFWtc3QPk73T6mrsvDlphJGAGVcIaihYxkO4tzM20DYeZIcxHLUJB01a
	 HuLPxY5CjOOHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Denzeel Oliva <wachiturroxd150@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	s.nawrocki@samsung.com,
	cw00.choi@samsung.com,
	peter.griffin@linaro.org,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-samsung-soc@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] clk: samsung: exynos990: Fix PERIC0/1 USI clock types
Date: Mon, 31 Aug 2026 09:29:00 -0400
Message-ID: <20260831133314.4125787-512-sashal@kernel.org>
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

From: Denzeel Oliva <wachiturroxd150@gmail.com>

[ Upstream commit e11560b050ce867bd7d3ccea138231db54e2250a ]

Use nMUX() for USI and UART user muxes to allow reparenting between
OSC and CMU IP output when changing rates, and use DIV_F() with
CLK_SET_RATE_PARENT on their dividers and gates so rate requests
propagate upward.

Consolidate identical USI parent arrays into shared
mout_peric0_nonbususer_p and mout_peric1_nonbususer_p.

Signed-off-by: Denzeel Oliva <wachiturroxd150@gmail.com>
Link: https://patch.msgid.link/20260528-perics-usi-v1-1-13a6ee4d1a6f@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `clk: samsung: exynos990: Fix PERIC0/1 USI
clock types`

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**

Record: `[clk: samsung: exynos990]` `[Fix]` — Correct PERIC0/1 USI clock
types (mux/div clock framework flags).

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Denzeel Oliva <wachiturroxd150@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260528-perics-
  usi-v1-1-13a6ee4d1a6f@gmail.com`
- `Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>` (clk/samsung
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: maintainer commit; no fuzzer or user bug reports.

**Step 1.3 — Body analysis**

Record:
- **Bug:** PERIC0/1 USI and UART user muxes use `MUX()`
  (`CLK_SET_RATE_NO_REPARENT`) and plain `DIV()` without
  `CLK_SET_RATE_PARENT`, so rate changes cannot reparent between
  `oscclk` and `dout_cmu_peric*_ip`, and rate requests do not propagate
  up the tree.
- **Symptom:** USI peripherals (UART/SPI/I2C via Samsung USI blocks) and
  UART debug cannot get correct clock rates when drivers call
  `clk_set_rate()`.
- **Root cause:** Wrong clock-type macros at PERIC bring-up (author's
  earlier PERIC0/1 commit).
- **Version info:** None explicit; bug introduced when PERIC0/1 support
  landed in 6.18.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite "Fix" in the subject, this is a functional
clock-tree correctness bug, not cosmetic cleanup. Same class of bug
fixed earlier on GS101 (`7b54d9113cd49`).

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/clk/samsung/clk-exynos990.c` only (+143 / −164
  lines, net −21)
- **Functions/sections:** `peric0_mux_clks[]`, `peric0_div_clks[]`,
  `peric1_mux_clks[]`, `peric1_div_clks[]`, parent-name arrays
- **Scope:** Single-file, mechanical clock registration fix

**Step 2.2 — Code flow per hunk**

Record:
- **PERIC0/1 parent arrays:** 11+12 duplicate `PNAME()` arrays → 2
  shared `mout_peric*_nonbususer_p` arrays (no behavior change).
- **Mux clocks:** `MUX()` → `nMUX()` for UART_DBG and all USI user
  muxes. Before: reparenting blocked on rate change. After: reparenting
  between OSC (~24.5 MHz) and CMU IP output allowed.
- **Div clocks:** `DIV()` → `DIV_F(..., CLK_SET_RATE_PARENT, 0)` for all
  USI dividers. Before: rate requests stopped at divider. After:
  propagate to parent mux.
- **Gates:** unchanged (commit message mentions gates, but diff does not
  modify `GATE()` entries).

**Step 2.3 — Bug mechanism**

Record: **Logic / correctness fix** in clock framework registration.
- `MUX()` sets `CLK_SET_RATE_NO_REPARENT` (see `clk.h` line 145).
- `nMUX()` clears that flag (line 151–152).
- `DIV_F()` with `CLK_SET_RATE_PARENT` enables upward rate propagation.
- Category: hardware clock configuration bug; analogous to GS101 PERIC0
  USI SPI fix.

**Step 2.4 — Fix quality**

Record:
- **Obviously correct:** Matches established GS101 pattern for the same
  IP block family.
- **Minimal:** Only affected clocks changed; parent arrays consolidated.
- **Regression risk:** Low — enables intended CCF behavior; no API or
  structural changes.
- **Note:** Commit message overstates gate changes; gates remain plain
  `GATE()` without `CLK_SET_RATE_PARENT` (unlike GS101). Maintainer
  accepted as-is.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**

Record: Buggy `MUX(CLK_MOUT_PERIC0_USI00_USI_USER, ...)` introduced in
`b3b314ef13e46` (Denzeel Oliva, 2025-09-04) — "Add PERIC0 and PERIC1
clock support". Present since v6.18.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag. Originating commit `b3b314ef13e46` is an
ancestor of `v6.18.44`.

**Step 3.3 — Related file history**

Record:
- `bdd03ebf721f7` (2024-12-14): Introduce Exynos990 clock driver
- `b3b314ef13e46` (2025-09-07): Add PERIC0/PERIC1 — introduced bug
- `44b0a8e433aaa`: Enable PERIC0/PERIC1 in exynos990 DT
- Fix commit `e11560b050ce8` is the only change to this file between
  `v6.18.44` and mainline
- Standalone 1/1 patch, no series dependencies

**Step 3.4 — Author context**

Record: Denzeel Oliva authored both PERIC bring-up and this fix.
Krzysztof Kozlowski (samsung-clk maintainer) committed it.

**Step 3.5 — Prerequisites**

Record: No dependencies. `nMUX`, `DIV_F`, and `CLK_SET_RATE_PARENT` all
exist in this tree's `drivers/clk/samsung/clk.h`. Patch applies cleanly
(`git apply --check` passed).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c e11560b050ce8` → https://patch.msgid.link/20260528-perics-
  usi-v1-1-13a6ee4d1a6f@gmail.com
- Single-patch series (v1, 1/1)
- Krzysztof Kozlowski: "Applied, thanks!" — no review thread, no stable
  nomination, no NAKs

**Step 4.2 — Reviewers**

Record: CC'd Krzysztof Kozlowski, Sylwester Nawrocki, Chanwoo Choi, Alim
Akhtar, Michael Turquette, Stephen Boyd, Brian Masney; lists `linux-
clk`, `linux-samsung-soc`, `linux-arm-kernel`.

**Step 4.3 — Bug reports**

Record: N/A — no `Reported-by:` or bugzilla/syzbot links.

**Step 4.4 — Related patches**

Record: Direct precedent — `7b54d9113cd49` "clk: samsung: gs101:
propagate PERIC0 USI SPI clock rate" documents identical mechanism (nMUX
+ DIV_F + GATE CLK_SET_RATE_PARENT for USI on GS101 PERIC0).

**Step 4.5 — Stable list**

Record: No stable-list discussion found for this patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key symbols**

Record: PERIC0/1 mux/div clock tables in `clk-exynos990.c`; no new
functions.

**Step 5.2 — Callers**

Record: Clocks registered at init via exynos990 CMU probe; consumed at
runtime by device drivers via `clk_get()` / `clk_set_rate()`. PERIC0/1
CMUs are enabled in `exynos990.dtsi` (`cmu_peric0`, `cmu_peric1`).

**Step 5.3 — Callees**

Record: Samsung CCF helpers (`samsung_clk_register_mux`,
`samsung_clk_register_div`); standard Linux common clock framework
rate/recalc paths.

**Step 5.4 — Reachability**

Record: Reachable when exynos990 drivers request peripheral clocks. USI
device nodes are not yet in mainline exynos990 DTS, but PERIC clock
controllers are live and UART_DBG mux is also fixed. Any future or out-
of-tree USI/UART driver using these clocks hits the bug today.

**Step 5.5 — Similar patterns**

Record: GS101 PERIC0/1 USI clocks use `nMUX` +
`DIV_F(CLK_SET_RATE_PARENT)` + `GATE(..., CLK_SET_RATE_PARENT)`.
Exynos850 CMGP USI uses `MUX_F(CLK_SET_RATE_PARENT)` +
`DIV_F(CLK_SET_RATE_PARENT)`. Exynos990 PERIC was the outlier using
plain `MUX`/`DIV`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Current HEAD still has `MUX()` for USI user muxes and
`DIV()` for USI dividers (e.g. lines 1568–1640). Fix commit
`e11560b050ce8` is **not** in HEAD. Bug introduced in 6.18 with PERIC
support.

**Step 6.2 — Backport complications**

Record: **Clean apply** — `git apply --check` on `e11560b050ce8` patch
succeeded against HEAD. Only one intervening commit on this file between
v6.18.44 and the fix.

**Step 6.3 — Related fixes already present?**

Record: **No** equivalent fix in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 — Subsystem / criticality**

Record: `drivers/clk/samsung` — **PERIPHERAL** (Exynos990 platform-
specific), but PERIC clocks underpin UART/SPI/I2C for the SoC.

**Step 7.2 — Activity**

Record: exynos990 clk driver actively developed; PERIC support added in
6.18 cycle.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**

Record: Exynos990 users (Galaxy S21 family boards: x1s, c1s, r8s, etc.
in `arch/arm64/boot/dts/exynos/`). Config/platform-specific, not
universal.

**Step 8.2 — Trigger conditions**

Record: Any driver calling `clk_set_rate()` on a PERIC0/1 USI or
UART_DBG clock. Common during SPI/UART/I2C device probe and transfer
setup. Not security-relevant; unprivileged users cannot trigger
directly.

**Step 8.3 — Failure mode severity**

Record: **Incorrect clock rates** → peripheral probe failure, wrong
baud/SPI timing, device malfunction. **Severity: MEDIUM** (functional
hardware breakage, not kernel crash/oops/corruption).

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** Fixes a regression introduced in 6.18 itself; unblocks
  correct USI/UART clock operation on exynos990; matches proven GS101
  fix pattern.
- **Risk:** Very low — declarative flag changes only, clean apply,
  maintainer-reviewed.
- **Ratio:** Favorable for 6.18.y where the buggy PERIC code already
  shipped.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR:**
- Real functional bug in clock registration
- Bug introduced in this stable series (6.18) with PERIC0/1 support
- Buggy code confirmed present in v6.18.44
- Small, mechanical, obviously correct fix
- Clean apply, no dependencies
- Direct precedent (GS101 USI clock fix)
- Samsung clk maintainer committed

**AGAINST:**
- No crash/security/corruption — functional hardware issue only
- No user reports, syzbot, or Tested-by
- exynos990 USI device nodes not yet in mainline DTS (limited immediate
  impact)
- Commit message inaccurately claims gate changes that aren't in the
  diff
- Platform-specific, narrow user base on mainline stable

**Unresolved:** Whether gate clocks also need `CLK_SET_RATE_PARENT` (as
on GS101) — not addressed by this commit; maintainer accepted without
gate changes.

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — matches GS101 pattern;
no Tested-by |
| 2. Fixes real bug affecting users? | **PASS** — broken clock rate
setting for USI/UART |
| 3. Important issue? | **PASS** (borderline) — MEDIUM severity hardware
functionality bug, regression in 6.18 |
| 4. Small and contained? | **PASS** — single file, mechanical |
| 5. No new features/APIs? | **PASS** — corrects existing clock flags
only |
| 6. Applies to local tree? | **PASS** — clean apply verified |

**Step 9.3 — Exception categories**

Record: N/A — not a device ID, quirk, DT, build, or docs fix. Standard
driver correctness fix.

**Step 9.4 — Decision rationale**

This is a regression fix for code that shipped broken in Linux 6.18. The
PERIC0/1 USI and UART mux/div clocks were registered with flags that
prevent the common clock framework from reparenting and propagating rate
changes — exactly the problem documented and fixed on GS101. For the
v6.18.44 tree, the buggy code is present, the fix applies cleanly, and
exynos990 platform support (including PERIC CMUs in DT) is already in
this release. While severity is functional rather than a kernel crash,
correcting a driver bug introduced in the same stable series is
appropriate stable material.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Read `clk.h` lines 144–198: confirmed `MUX()` =
  `CLK_SET_RATE_NO_REPARENT`, `nMUX()` allows reparenting, `DIV_F()`
  supports `CLK_SET_RATE_PARENT`
- [Phase 2] Full diff via `git show e11560b050ce8`: 143+/164−, no gate
  changes despite message claim
- [Phase 3] `git describe HEAD` → `v6.18.44`; Makefile → 6.18.44
- [Phase 3] `git blame` lines 1568–1570 → `b3b314ef13e46` introduced
  buggy MUX
- [Phase 3] `git merge-base --is-ancestor b3b314ef13e46 v6.18.44` →
  PERIC0 in tree; fix NOT in HEAD
- [Phase 3] `git tag --contains b3b314ef13e46 | grep v6.18` → present
  since v6.18-rc1
- [Phase 3] `git show 7b54d9113cd49` — GS101 precedent with detailed
  USI/SPI clk_set_rate explanation
- [Phase 4] `b4 dig -c e11560b050ce8` → lore URL found
- [Phase 4] `b4 dig -w` → maintainers CC'd
- [Phase 4] `/tmp/perics-usi.mbx` — only maintainer "Applied, thanks!"
  reply; no stable nomination
- [Phase 5] Grep exynos990 DTS — `cmu_peric0`/`cmu_peric1` enabled; no
  USI device nodes yet
- [Phase 5] Grep `clk-gs101.c` — CLK_SET_RATE_PARENT on USI mux/div/gate
  clocks
- [Phase 6] Grep current tree — buggy `MUX()`/`DIV()` still present at
  lines 1565–1640, 2123+
- [Phase 6] `git apply --check` of fix patch against HEAD → clean apply
- [Phase 6] `git log v6.18.44..e11560b050ce8 -- clk-exynos990.c` → 1
  commit (the fix)
- [Phase 8] Failure mode assessed as MEDIUM (functional), not CRITICAL
  (no oops/corruption)

**YES**The background searches finished and line up with the earlier
analysis:

- **PERIC0 history:** Buggy PERIC0/1 support came in with
  `b3b314ef13e46` ("Add PERIC0 and PERIC1 clock support"), which is in
  this `v6.18.44` tree.
- **Fix commit:** The fix is `e11560b050ce8` on mainline; it is **not**
  in the checked-out `v6.18.44` tree yet.
- **GS101 precedent:** `7b54d9113cd49` ("propagate PERIC0 USI SPI clock
  rate") is the same class of fix and is present in this tree's history.

That supports the earlier verdict: **YES** for backport to this `6.18.y`
tree.

 drivers/clk/samsung/clk-exynos990.c | 307 +++++++++++++---------------
 1 file changed, 143 insertions(+), 164 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos990.c b/drivers/clk/samsung/clk-exynos990.c
index 6277dd557fab6..4385c3b76dd68 100644
--- a/drivers/clk/samsung/clk-exynos990.c
+++ b/drivers/clk/samsung/clk-exynos990.c
@@ -1546,54 +1546,44 @@ static const unsigned long peric0_clk_regs[] __initconst = {
 
 /* Parent clock list for CMU_PERIC0 muxes */
 PNAME(mout_peric0_bus_user_p) = { "oscclk", "dout_cmu_peric0_bus" };
-PNAME(mout_peric0_uart_dbg_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi00_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi01_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi02_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi03_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi04_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi05_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi13_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi14_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi15_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi_i2c_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
+PNAME(mout_peric0_nonbususer_p) = { "oscclk", "dout_cmu_peric0_ip" };
 
 static const struct samsung_mux_clock peric0_mux_clks[] __initconst = {
 	MUX(CLK_MOUT_PERIC0_BUS_USER, "mout_peric0_bus_user",
 	    mout_peric0_bus_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_BUS_USER,
 	    4, 1),
-	MUX(CLK_MOUT_PERIC0_UART_DBG, "mout_peric0_uart_dbg",
-	    mout_peric0_uart_dbg_p, PLL_CON0_MUX_CLKCMU_PERIC0_UART_DBG,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI00_USI_USER, "mout_peric0_usi00_usi_user",
-	    mout_peric0_usi00_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI00_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI01_USI_USER, "mout_peric0_usi01_usi_user",
-	    mout_peric0_usi01_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI01_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI02_USI_USER, "mout_peric0_usi02_usi_user",
-	    mout_peric0_usi02_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI02_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI03_USI_USER, "mout_peric0_usi03_usi_user",
-	    mout_peric0_usi03_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI03_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI04_USI_USER, "mout_peric0_usi04_usi_user",
-	    mout_peric0_usi04_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI04_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI05_USI_USER, "mout_peric0_usi05_usi_user",
-	    mout_peric0_usi05_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI05_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI13_USI_USER, "mout_peric0_usi13_usi_user",
-	    mout_peric0_usi13_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI13_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI14_USI_USER, "mout_peric0_usi14_usi_user",
-	    mout_peric0_usi14_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI14_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI15_USI_USER, "mout_peric0_usi15_usi_user",
-	    mout_peric0_usi15_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI15_USI_USER,
-	    4, 1),
+	nMUX(CLK_MOUT_PERIC0_UART_DBG, "mout_peric0_uart_dbg",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_UART_DBG,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI00_USI_USER, "mout_peric0_usi00_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI00_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI01_USI_USER, "mout_peric0_usi01_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI01_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI02_USI_USER, "mout_peric0_usi02_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI02_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI03_USI_USER, "mout_peric0_usi03_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI03_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI04_USI_USER, "mout_peric0_usi04_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI04_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI05_USI_USER, "mout_peric0_usi05_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI05_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI13_USI_USER, "mout_peric0_usi13_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI13_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI14_USI_USER, "mout_peric0_usi14_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI14_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI15_USI_USER, "mout_peric0_usi15_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI15_USI_USER,
+	     4, 1),
 	MUX(CLK_MOUT_PERIC0_USI_I2C_USER, "mout_peric0_usi_i2c_user",
-	    mout_peric0_usi_i2c_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI_I2C_USER,
+	    mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI_I2C_USER,
 	    4, 1),
 };
 
@@ -1602,42 +1592,42 @@ static const struct samsung_div_clock peric0_div_clks[] __initconst = {
 	    "mout_peric0_uart_dbg",
 	    CLK_CON_DIV_DIV_CLK_PERIC0_UART_DBG,
 	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI00_USI, "dout_peric0_usi00_usi",
-	    "mout_peric0_usi00_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI00_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI01_USI, "dout_peric0_usi01_usi",
-	    "mout_peric0_usi01_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI01_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI02_USI, "dout_peric0_usi02_usi",
-	    "mout_peric0_usi02_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI02_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI03_USI, "dout_peric0_usi03_usi",
-	    "mout_peric0_usi03_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI03_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI04_USI, "dout_peric0_usi04_usi",
-	    "mout_peric0_usi04_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI04_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI05_USI, "dout_peric0_usi05_usi",
-	    "mout_peric0_usi05_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI05_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI13_USI, "dout_peric0_usi13_usi",
-	    "mout_peric0_usi13_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI13_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI14_USI, "dout_peric0_usi14_usi",
-	    "mout_peric0_usi14_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI14_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI15_USI, "dout_peric0_usi15_usi",
-	    "mout_peric0_usi15_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI15_USI,
-	    0, 4),
+	DIV_F(CLK_DOUT_PERIC0_USI00_USI, "dout_peric0_usi00_usi",
+	      "mout_peric0_usi00_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI00_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI01_USI, "dout_peric0_usi01_usi",
+	      "mout_peric0_usi01_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI01_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI02_USI, "dout_peric0_usi02_usi",
+	      "mout_peric0_usi02_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI02_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI03_USI, "dout_peric0_usi03_usi",
+	      "mout_peric0_usi03_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI03_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI04_USI, "dout_peric0_usi04_usi",
+	      "mout_peric0_usi04_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI04_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI05_USI, "dout_peric0_usi05_usi",
+	      "mout_peric0_usi05_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI05_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI13_USI, "dout_peric0_usi13_usi",
+	      "mout_peric0_usi13_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI13_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI14_USI, "dout_peric0_usi14_usi",
+	      "mout_peric0_usi14_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI14_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI15_USI, "dout_peric0_usi15_usi",
+	      "mout_peric0_usi15_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI15_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
 	DIV(CLK_DOUT_PERIC0_USI_I2C, "dout_peric0_usi_i2c",
 	    "mout_peric0_usi_i2c_user",
 	    CLK_CON_DIV_DIV_CLK_PERIC0_USI_I2C,
@@ -2107,58 +2097,47 @@ static const unsigned long peric1_clk_regs[] __initconst = {
 
 /* Parent clock list for CMU_PERIC1 muxes */
 PNAME(mout_peric1_bus_user_p)  = { "oscclk", "dout_cmu_peric1_bus" };
-PNAME(mout_peric1_uart_bt_user_p) = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi06_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi07_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi08_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi09_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi10_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi11_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi12_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi18_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi16_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi17_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi_i2c_user_p) = { "oscclk", "dout_cmu_peric1_ip" };
+PNAME(mout_peric1_nonbususer_p) = { "oscclk", "dout_cmu_peric1_ip" };
 
 static const struct samsung_mux_clock peric1_mux_clks[] __initconst = {
 	MUX(CLK_MOUT_PERIC1_BUS_USER, "mout_peric1_bus_user",
 	    mout_peric1_bus_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_BUS_USER,
 	    4, 1),
-	MUX(CLK_MOUT_PERIC1_UART_BT_USER, "mout_peric1_uart_bt_user",
-	    mout_peric1_uart_bt_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_UART_BT_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI06_USI_USER, "mout_peric1_usi06_usi_user",
-	    mout_peric1_usi06_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI06_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI07_USI_USER, "mout_peric1_usi07_usi_user",
-	    mout_peric1_usi07_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI07_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI08_USI_USER, "mout_peric1_usi08_usi_user",
-	    mout_peric1_usi08_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI08_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI09_USI_USER, "mout_peric1_usi09_usi_user",
-	    mout_peric1_usi09_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI09_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI10_USI_USER, "mout_peric1_usi10_usi_user",
-	    mout_peric1_usi10_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI10_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI11_USI_USER, "mout_peric1_usi11_usi_user",
-	    mout_peric1_usi11_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI11_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI12_USI_USER, "mout_peric1_usi12_usi_user",
-	    mout_peric1_usi12_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI12_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI18_USI_USER, "mout_peric1_usi18_usi_user",
-	    mout_peric1_usi18_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI18_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI16_USI_USER, "mout_peric1_usi16_usi_user",
-	    mout_peric1_usi16_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI16_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI17_USI_USER, "mout_peric1_usi17_usi_user",
-	    mout_peric1_usi17_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI17_USI_USER,
-	    4, 1),
+	nMUX(CLK_MOUT_PERIC1_UART_BT_USER, "mout_peric1_uart_bt_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_UART_BT_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI06_USI_USER, "mout_peric1_usi06_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI06_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI07_USI_USER, "mout_peric1_usi07_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI07_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI08_USI_USER, "mout_peric1_usi08_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI08_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI09_USI_USER, "mout_peric1_usi09_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI09_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI10_USI_USER, "mout_peric1_usi10_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI10_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI11_USI_USER, "mout_peric1_usi11_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI11_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI12_USI_USER, "mout_peric1_usi12_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI12_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI18_USI_USER, "mout_peric1_usi18_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI18_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI16_USI_USER, "mout_peric1_usi16_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI16_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI17_USI_USER, "mout_peric1_usi17_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI17_USI_USER,
+	     4, 1),
 	MUX(CLK_MOUT_PERIC1_USI_I2C_USER, "mout_peric1_usi_i2c_user",
-	    mout_peric1_usi_i2c_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI_I2C_USER,
+	    mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI_I2C_USER,
 	    4, 1),
 };
 
@@ -2167,46 +2146,46 @@ static const struct samsung_div_clock peric1_div_clks[] __initconst = {
 	    "mout_peric1_uart_bt_user",
 	    CLK_CON_DIV_DIV_CLK_PERIC1_UART_BT,
 	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI06_USI, "dout_peric1_usi06_usi",
-	    "mout_peric1_usi06_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI06_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI07_USI, "dout_peric1_usi07_usi",
-	    "mout_peric1_usi07_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI07_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI08_USI, "dout_peric1_usi08_usi",
-	    "mout_peric1_usi08_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI08_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI18_USI, "dout_peric1_usi18_usi",
-	    "mout_peric1_usi18_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI18_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI12_USI, "dout_peric1_usi12_usi",
-	    "mout_peric1_usi12_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI12_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI09_USI, "dout_peric1_usi09_usi",
-	    "mout_peric1_usi09_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI09_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI10_USI, "dout_peric1_usi10_usi",
-	    "mout_peric1_usi10_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI10_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI11_USI, "dout_peric1_usi11_usi",
-	    "mout_peric1_usi11_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI11_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI16_USI, "dout_peric1_usi16_usi",
-	    "mout_peric1_usi16_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI16_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI17_USI, "dout_peric1_usi17_usi",
-	    "mout_peric1_usi17_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI17_USI,
-	    0, 4),
+	DIV_F(CLK_DOUT_PERIC1_USI06_USI, "dout_peric1_usi06_usi",
+	      "mout_peric1_usi06_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI06_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI07_USI, "dout_peric1_usi07_usi",
+	      "mout_peric1_usi07_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI07_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI08_USI, "dout_peric1_usi08_usi",
+	      "mout_peric1_usi08_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI08_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI18_USI, "dout_peric1_usi18_usi",
+	      "mout_peric1_usi18_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI18_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI12_USI, "dout_peric1_usi12_usi",
+	      "mout_peric1_usi12_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI12_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI09_USI, "dout_peric1_usi09_usi",
+	      "mout_peric1_usi09_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI09_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI10_USI, "dout_peric1_usi10_usi",
+	      "mout_peric1_usi10_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI10_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI11_USI, "dout_peric1_usi11_usi",
+	      "mout_peric1_usi11_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI11_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI16_USI, "dout_peric1_usi16_usi",
+	      "mout_peric1_usi16_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI16_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI17_USI, "dout_peric1_usi17_usi",
+	      "mout_peric1_usi17_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI17_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
 	DIV(CLK_DOUT_PERIC1_USI_I2C, "dout_peric1_usi_i2c",
 	    "mout_peric1_usi_i2c_user",
 	    CLK_CON_DIV_DIV_CLK_PERIC1_USI_I2C,
-- 
2.53.0

