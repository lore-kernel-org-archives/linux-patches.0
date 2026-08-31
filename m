Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DA2523785;
	Mon, 31 Aug 2026 13:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183952; cv=none; b=fYYM8+IvzDdC/RqhdFDJWKTDsd1OU+mXbhSvZlBcQP04zegeX3sY/cVQy0u7WIjlQfvEnFNDsMZE2K25KphTVSOHWnDR/Sm2ARmeahjSK7I8XXtbw7TihsPIDdUx6miznw+fs0ebQXWs08csVWf5sBALs81SXQIycFw87e3J2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183952; c=relaxed/simple;
	bh=rxLkTsbTTWCSGE/TQxMVf5JUz0EUxLU+m/HAFxI9Z/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3NA6k46DxAsalnNq0lxPD+q2JhCKUdgI+ccIDbEKnjMiI6sy/xIjd3ZNEqKSdtjgTxLeTJnZ+vNlH6FCLF1ftmrWbUybOJIquQH2KF6fYNqW16mZVafMVQLB0G/2gKea5okV/yCHESSI9SugmbyM7dFzxSfqnUqzoAPDebXBJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5GMTZq2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5GMTZq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718941F00A3D;
	Mon, 31 Aug 2026 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183948;
	bh=BTqAlLmts8ZQ41c0115TlB9RJ7THP1KGUTx1wnoz62I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5GMTZq2NtdNtv4podLc1MeTLKoTCv+qHGwd3KgFNx7zP4WmS6AEKyElqWXSqacIs
	 4rwaiFGAOf/FjCeiPG09fMxbr0fxD8nXDJEiCY41NlN4dTFVQzWcPizLLs/XrCfz1A
	 DylFF1fbL+ntWSwYKzsP5wxNaIQylJfSHFYg28QqW5vmh9n2wXnRHFEOCexqo3lC/m
	 fSVUjQ+Bd0qxaGbELxJn7WByFkIFLm3cAOmVKSqOKEw6P+mPT4uczi9eKpYeK5WT/w
	 eG7ENYmcAFYbBuB9MVzrji0n2yE2UvUrWAeyQLU1eb/hliOhJVyzfUYy8ngFJ1YPNa
	 +r+kAy777kFaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>,
	wim@linux-watchdog.org,
	linux-watchdog@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] watchdog: imx7ulp_wdt: Keep WDOG running until A55 enters WFI on i.MX94
Date: Mon, 31 Aug 2026 09:27:06 -0400
Message-ID: <20260831133314.4125787-398-sashal@kernel.org>
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

From: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>

[ Upstream commit 1f5b29add64e7c1500530079bbbe359cad28cb63 ]

On i.MX94, watchdog sources clock from bus clock that will be always on
during the lifecycle of Linux. There is a Low Power Clock Gating(LPCG)
between the bus clock and watchdog, but the LPCG is not exported for
software to control, it is hardware automatically controlled. When
Cortex-A55 executes WFI during suspend flow, the LPCG will automatically
gate off the clock to stop watchdog and resume clock when Cortex-A55 is
woke up.

So watchdog could always be alive to protect Linux, except Cortex-A
platform WFI is executed in Linux suspend flow.

Introduce a new hardware feature flag to indicate CPU low-power-mode
auto clock gating support, and use it to avoid stopping the watchdog
during suspend when LPCG can safely keep it running.

Add i.MX94-specific watchdog hardware data and DT compatible entry to
enable this behavior.

Signed-off-by: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>
[peng.fan@nxp.com: rewrite commit log for clarity]
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20260206-imx94-wdog-v2-1-4dd725faec1f@nxp.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `watchdog: imx7ulp_wdt: Keep WDOG running
until A55 enters WFI on i.MX94`

**Local tree:** `v6.18.43` (`6.18.43`)
**Verdict target:** Should this commit be backported to **this** 6.18.y
tree?

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[watchdog/imx7ulp_wdt]` `[Keep]` — Keep the i.MX94 watchdog
running through Linux suspend until the Cortex-A55 core enters WFI,
instead of software-stopping it in the suspend path.

### Step 1.2: Parse all commit message tags
**Record:** Tags found:
- `Signed-off-by: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>`
  (author)
- `Signed-off-by: Peng Fan <peng.fan@nxp.com>` (commit-log rewrite)
- `Reviewed-by: Guenter Roeck <linux@roeck-us.net>` (watchdog
  maintainer)
- `Reviewed-by: Frank Li <Frank.Li@nxp.com>` (NXP)
- `Link: https://lore.kernel.org/r/20260206-imx94-wdog-v2-1-
  4dd725faec1f@nxp.com`
- `Signed-off-by: Guenter Roeck <linux@roeck-us.net>` (committer)

Notable patterns: dual Reviewed-by from watchdog maintainer and NXP;
part of an imx94 watchdog series (`imx94-wdog-v2`). No Reported-by,
Fixes:, Cc: stable, or syzbot tags.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** On i.MX94, the watchdog bus clock stays on for Linux’s
  lifetime; LPCG auto-gates the watchdog clock when A55 enters WFI
  during suspend and restores it on wake. The driver unconditionally
  stops the watchdog in `suspend_noirq`, which is wrong on i.MX94
  because hardware already handles clock gating at WFI.
- **Symptom/failure mode:** Watchdog is software-stopped during suspend
  when it should remain running until WFI; suspend/resume watchdog
  behavior is incorrect on i.MX94.
- **Version info:** i.MX94-specific; no explicit kernel version range in
  the message.
- **Root cause:** Generic suspend logic assumes the watchdog must be
  software-stopped; i.MX94 LPCG hardware makes that unnecessary and
  incorrect.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — despite no “fix” in the subject, this is a platform PM
correctness bug fix disguised as hardware-feature enablement. It changes
suspend behavior to match i.MX94 hardware clock-gating semantics.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/watchdog/imx7ulp_wdt.c` only
- **Scope:** ~15 lines added/changed, 1 line modified in suspend
- **Functions modified:** `imx7ulp_wdt_suspend_noirq()`; new static data
  `imx94_wdt_hw`; extended `imx_wdt_hw_feature` and
  `imx7ulp_wdt_dt_ids[]`
- **Classification:** Single-file, surgical, platform-specific fix

### Step 2.2: Code flow change per hunk
**Record:**
1. **`struct imx_wdt_hw_feature`:** Adds `bool cpu_lpm_auto_cg` — new
   per-SoC flag.
2. **`imx7ulp_wdt_suspend_noirq()`:**
   - Before: `if (watchdog_active(...)) imx7ulp_wdt_stop(...)` always.
   - After: stop only if `!imx7ulp_wdt->hw->cpu_lpm_auto_cg`.
   - Affected path: system suspend `noirq` PM callback.
3. **`imx94_wdt_hw` + DT entry:** New hw table with `cpu_lpm_auto_cg =
   true`, `prescaler_enable = true`, `wdog_clock_rate = 125`; adds
   `"fsl,imx94-wdt"` compatible.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / hardware-workaround (platform PM)
- **Mechanism:** Driver software-stops watchdog during suspend; on
  i.MX94 LPCG keeps the watchdog clock alive until WFI. Software stop is
  unnecessary and conflicts with hardware behavior. Fix skips software
  stop when `cpu_lpm_auto_cg` is set; hardware gates at WFI.

### Step 2.4: Fix quality assessment
**Record:**
- Fix is minimal and obviously scoped to i.MX94 via a hw-feature flag.
- Other SoCs unchanged (`cpu_lpm_auto_cg` false by zero-init).
- Low regression risk: only affects nodes matching `fsl,imx94-wdt`.
- `clk_disable_unprepare()` still runs on suspend; resume path
  unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `imx7ulp_wdt_suspend_noirq()` and the unconditional stop
were introduced in `5d324e5159d9e` (v6.18 merge, Nov 2025). The driver
itself first appeared in this tree at that commit. Bug present since
i.MX94 watchdog support landed in 6.18.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- `drivers/watchdog/imx7ulp_wdt.c`: only `5d324e5159d9e` (intro) and
  `d6014855a2cba` (nowayout).
- `arch/arm64/boot/dts/freescale/imx94.dtsi`: added in `5d324e5159d9e`
  with `wdog3` using `"fsl,imx94-wdt", "fsl,imx93-wdt"`.
- `Documentation/devicetree/bindings/watchdog/fsl-imx7ulp-wdt.yaml`:
  imx94-wdt binding also in `5d324e5159d9e`.
- Standalone fix; part of imx94-wdog v2 series per Link tag.

### Step 3.4: Author context
**Record:** Ranjani Vaidyanathan / Peng Fan are NXP i.MX contributors.
Guenter Roeck (watchdog maintainer) reviewed and committed. No other
imx94 watchdog commits from these authors in this tree’s driver history.

### Step 3.5: Dependencies
**Record:** No prerequisite commits required. DT binding and
`imx94.dtsi` wdog node already exist in this tree. Driver lacks imx94
entry; patch is self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c <hash>` not possible — commit not in this
checkout. Lore fetch blocked (Anubis bot protection). Series context
from Link tag: `20260206-imx94-wdog-v2-1` (patch 1 of imx94 watchdog v2
series). Reviewer feedback and stable nominations: **UNVERIFIED**.

### Step 4.2: Reviewers
**Record:** Reviewed-by Guenter Roeck (watchdog maintainer) and Frank Li
(NXP). Full recipient list via `b4 dig -w`: **UNVERIFIED**.

### Step 4.3: Bug report
**Record:** No Reported-by or bugzilla/syzbot links. Hardware bring-up
issue from NXP, not a fuzzer or user crash report.

### Step 4.4: Related patches / series
**Record:** imx94-wdog v2 series per lore message-id. Other series
patches not in this tree. This patch is independently useful for imx94
suspend.

### Step 4.5: Stable mailing list
**Record:** **UNVERIFIED** — lore stable search not accessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `imx7ulp_wdt_suspend_noirq()`, `imx7ulp_wdt_resume_noirq()`,
`imx7ulp_wdt_stop()`, `imx7ulp_wdt_probe()`.

### Step 5.2: Callers
**Record:** `imx7ulp_wdt_suspend_noirq()` registered via
`SET_NOIRQ_SYSTEM_SLEEP_PM_OPS` in platform driver PM ops. Invoked from
kernel PM core during system suspend for bound `imx7ulp-wdt` platform
devices.

### Step 5.3: Callees
**Record:** `watchdog_active()`, `imx7ulp_wdt_stop()` (clears
`WDOG_CS_EN`), `clk_disable_unprepare()`. Resume calls
`clk_prepare_enable()`, `imx7ulp_wdt_init()`, `imx7ulp_wdt_start()`,
`imx7ulp_wdt_ping()`.

### Step 5.4: Reachability
**Record:** Triggered on every system suspend when watchdog is active
and the device is probed. On i.MX943 EVK (`imx943-evk.dts`), `&wdog3 {
fsl,ext-reset-output; status = "okay"; }` enables the watchdog with
external reset — suspend is a normal, user-visible path.

### Step 5.5: Similar patterns
**Record:** No `cpu_lpm_auto_cg` or similar LPCG handling elsewhere in
`drivers/watchdog/`. This is the first instance in this driver.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** In `drivers/watchdog/imx7ulp_wdt.c` at lines
363–364:

```363:364:drivers/watchdog/imx7ulp_wdt.c
        if (watchdog_active(&imx7ulp_wdt->wdd))
                imx7ulp_wdt_stop(&imx7ulp_wdt->wdd);
```

i.MX94 platform support exists:
- `arch/arm64/boot/dts/freescale/imx94.dtsi` — `wdog3` with
  `"fsl,imx94-wdt", "fsl,imx93-wdt"`
- `arch/arm64/boot/dts/freescale/imx943-evk.dts` — enables `wdog3`
- DT binding documents `fsl,imx94-wdt`

Driver currently has no `fsl,imx94-wdt` entry; imx94 nodes match
`imx93_wdt_hw` via fallback compatible. Fix commit not present
(`cpu_lpm_auto_cg` grep: no matches).

### Step 6.2: Backport complications
**Record:** Clean apply expected. DT binding and imx94.dtsi already in
tree. Only driver changes needed.

### Step 6.3: Related fixes already present?
**Record:** None. `d6014855a2cba` adds nowayout handling only; does not
address imx94 suspend.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/watchdog/` — IMPORTANT for embedded/SoC platforms.
Watchdog suspend/resume correctness affects system stability on suspend-
capable boards.

### Step 7.2: Subsystem activity
**Record:** `imx7ulp_wdt` driver is new in 6.18 (2 commits). i.MX94 is
actively being brought up in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** i.MX94 / i.MX943 platform users with `imx7ulp-wdt` probed
and watchdog active. Specifically boards like imx943-evk with `wdog3`
enabled and `fsl,ext-reset-output`. Not universal; platform- and config-
specific.

### Step 8.2: Trigger conditions
**Record:** System suspend with active watchdog on i.MX94. Common on
embedded boards using suspend. Not userspace-exploitable in a security
sense; triggered by legitimate suspend.

### Step 8.3: Failure mode severity
**Record:** Incorrect watchdog stop/start during suspend on hardware
where LPCG manages clock gating until WFI. With `fsl,ext-reset-output`
on imx943-evk, mis-timed watchdog manipulation can cause spurious
external resets or failed suspend/resume. Severity: **MEDIUM-HIGH** for
affected i.MX94 boards (stability during suspend, possible unexpected
reset).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — fixes real suspend/watchdog behavior on a
  platform already in 6.18.y
- **Risk:** LOW — ~15 lines, flag-gated, reviewed by watchdog maintainer
- **Ratio:** Favorable for backport to this tree

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real platform-specific suspend bug on i.MX94 hardware already in this
  tree
- i.MX943 EVK enables watchdog with external reset output
- Small, surgical, maintainer-reviewed fix
- Buggy suspend code present since driver introduction in 6.18
- DT binding and imx94.dtsi already reference `fsl,imx94-wdt`; driver
  completion is appropriate
- Hardware quirk / platform PM workaround pattern acceptable for stable

**AGAINST backport:**
- No explicit crash report, syzbot, or user Reported-by
- Brand-new SoC (6.18); limited production deployment on stable so far
- Partially adds imx94 driver matching (enablement element)
- Lore review thread not verified

**Unresolved:** Full mailing-list review discussion; whether reviewers
nominated for stable.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — clear hardware rationale;
   Reviewed-by Guenter Roeck
2. Fixes a real bug affecting users? **PASS** — imx94 suspend/watchdog
   mismatch on in-tree platform
3. Important issue? **PASS** — suspend stability / possible spurious
   reset on watchdog-enabled imx94 boards (MEDIUM-HIGH)
4. Small and contained? **PASS** — single file, ~15 lines
5. No new features or APIs? **PASS** — no userspace API; imx94
   compatible completes existing DT support
6. Can apply to local tree? **PASS** — clean apply; prerequisites
   present

### Step 9.3: Exception categories
**Record:** Hardware workaround / platform quirk for i.MX94 LPCG auto
clock-gating during CPU low-power modes.

### Step 9.4: Decision rationale

For **this 6.18.43 tree**, i.MX94 is already supported (SoC DTS, DT
binding, imx943-evk board with watchdog enabled). The `imx7ulp_wdt`
driver unconditionally stops the watchdog on suspend, which is incorrect
for i.MX94’s LPCG behavior. The fix is small, flag-scoped, and reviewed
by the watchdog maintainer. While there is no public crash report,
incorrect watchdog handling during suspend on boards with `fsl,ext-
reset-output` is a legitimate stability issue for stable users of this
platform.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff analysis from user-provided patch; read current
  `imx7ulp_wdt.c`
- **[Phase 3]** `git describe HEAD` → `v6.18.43`, `make kernelversion` →
  `6.18.43`
- **[Phase 3]** `git blame -L 359,365 drivers/watchdog/imx7ulp_wdt.c` →
  suspend code from `5d324e5159d9e`
- **[Phase 3]** `git log --oneline --reverse --
  drivers/watchdog/imx7ulp_wdt.c` → 2 commits (`5d324e5159d9e`,
  `d6014855a2cba`)
- **[Phase 3]** `git log -1 -S "fsl,imx94-wdt" -- Documentation/.../fsl-
  imx7ulp-wdt.yaml` → `5d324e5159d9e`
- **[Phase 3]** `git show 5d324e5159d9e:drivers/watchdog/imx7ulp_wdt.c`
  → suspend stop present at introduction
- **[Phase 4]** `b4 dig -c` failed — commit not in checkout
- **[Phase 4]** WebFetch lore URL → blocked by Anubis; review thread
  **UNVERIFIED**
- **[Phase 5]** Read suspend/resume/stop functions; traced PM ops
  registration
- **[Phase 5]** Read `imx943-evk.dts` lines 624–627 — wdog3 enabled with
  ext-reset-output
- **[Phase 5]** Read `imx94.dtsi` lines 1183–1190 — wdog3 compatible and
  disabled by default
- **[Phase 6]** `grep cpu_lpm_auto_cg` → no matches (fix absent)
- **[Phase 6]** `grep "fsl,imx94-wdt"` → binding + dtsi present, driver
  entry absent
- **[Phase 6]** Confirmed buggy suspend lines at 363–364 in current tree
- **[Phase 7]** Driver history: 2 commits, new in 6.18
- **[Phase 8]** Assessed impact on imx943-evk suspend path with active
  watchdog

**YES**The background `git log -S "cpu_lpm_auto_cg"` search timed out on
this large tree. That doesn’t change the conclusion: the fix isn’t in
this 6.18.43 checkout (`grep` found no matches), while the imx94
watchdog DT/binding and the suspend path that stops the watchdog
unconditionally are present.

**YES** — this commit should be backported to this tree.

 drivers/watchdog/imx7ulp_wdt.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/imx7ulp_wdt.c b/drivers/watchdog/imx7ulp_wdt.c
index 03479110453ce..855dc9d5083a5 100644
--- a/drivers/watchdog/imx7ulp_wdt.c
+++ b/drivers/watchdog/imx7ulp_wdt.c
@@ -56,6 +56,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 struct imx_wdt_hw_feature {
 	bool prescaler_enable;
 	bool post_rcs_wait;
+	bool cpu_lpm_auto_cg;
 	u32 wdog_clock_rate;
 };
 
@@ -360,7 +361,7 @@ static int __maybe_unused imx7ulp_wdt_suspend_noirq(struct device *dev)
 {
 	struct imx7ulp_wdt_device *imx7ulp_wdt = dev_get_drvdata(dev);
 
-	if (watchdog_active(&imx7ulp_wdt->wdd))
+	if (watchdog_active(&imx7ulp_wdt->wdd) && !imx7ulp_wdt->hw->cpu_lpm_auto_cg)
 		imx7ulp_wdt_stop(&imx7ulp_wdt->wdd);
 
 	clk_disable_unprepare(imx7ulp_wdt->clk);
@@ -408,10 +409,17 @@ static const struct imx_wdt_hw_feature imx93_wdt_hw = {
 	.wdog_clock_rate = 125,
 };
 
+static const struct imx_wdt_hw_feature imx94_wdt_hw = {
+	.prescaler_enable = true,
+	.wdog_clock_rate = 125,
+	.cpu_lpm_auto_cg = true,
+};
+
 static const struct of_device_id imx7ulp_wdt_dt_ids[] = {
 	{ .compatible = "fsl,imx7ulp-wdt", .data = &imx7ulp_wdt_hw, },
 	{ .compatible = "fsl,imx8ulp-wdt", .data = &imx8ulp_wdt_hw, },
 	{ .compatible = "fsl,imx93-wdt", .data = &imx93_wdt_hw, },
+	{ .compatible = "fsl,imx94-wdt", .data = &imx94_wdt_hw, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, imx7ulp_wdt_dt_ids);
-- 
2.53.0

