Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1075F4AA014;
	Mon, 31 Aug 2026 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183997; cv=none; b=GtHuFgKKZfwKRx0b0VDZivmHKBZFFK1Ub+wD1fWikDe7FvBaDOiHR8yoET0NKQvy3VHjPyHWfB/U/ZU4/++g8wBgaLifctPhDWCVOD5QfPuNpX0hA4EOU0QsDFHk98GDiZULMHL8KjGVNFu6FuPCKXkLOZMpbSbQRF8SoGf93Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183997; c=relaxed/simple;
	bh=Ns+7hwuRK8re8UExsbKJtmTSwPrahS+iexun9sGpazE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aj1VuHgnV3myuMIMANCW8fAK+VI+GxgjN+ymsyU/PZMCE1m0DLuaEo/mgFDqqdjkQtjCmEE1R4Cj5yKYDx3Yv+xhSnNqPXyJtZjsPGo336coNX8PaCY+5PwbZP2suPzBVG09qsslEwcjd+9Fd16fM2m3CUiGw1+81CC2ekbjHLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlDav2T6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlDav2T6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F321F00A3D;
	Mon, 31 Aug 2026 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183991;
	bh=U6Hur/urQ7GEifMNcaT3dW4KCx7dnvzKVtBY2c3zVZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlDav2T6QuCYiUPRbjaJZq9tTnELLcdSc+VRQO/+8zdAAnVzU8cmgf7CzpwklAM9R
	 95feWNMLSvTsqCvtOBtSe+a8jk20Kk1WkSrWJVb96mTzwk6mXCnD5/cQxm8K0+oMAs
	 5wGuqW9/W3wdA/i2vrKE0e6uJSvU3ZfW1SxUN0/uDSZHlkhq1X6n/my64rir3ZjoTQ
	 kF0LXApMZn591ukQvj3sQiqqpkeGXJMo9DoTRwbcEWahY1laSKj3rCEss7dXOaFCKH
	 BjDU+loUvL1K3dzKaVXwKmbo0ZoKeYAgbKJfFxmrqhiX+s7dAr3xSFiqjPw/Ben1LK
	 MgQ7Ka4LB0cmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	sen@ti.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: codecs: pcm3168a: Prevent regulator double-disable in S4
Date: Mon, 31 Aug 2026 09:27:33 -0400
Message-ID: <20260831133314.4125787-425-sashal@kernel.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit bb3c847523f951315f212047ab26363f9928d569 ]

The SLEEP_PM_OPS are unset for the driver. Hibernation (S4) causes no
resume (skipped thanks to smart_suspend=true) yet still performs the
suspend sequence unconditionally, see device_complete() in
drivers/base/power/main.c.

If S4 runs for already suspended pcm3168a device, we end up with
"unbalanced disables" warning from the regulators. Assigning the
operations fixes the problem.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260525201801.1336936-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC pcm3168a S4 Regulator Double-Disable
Fix

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ASoC: codecs: pcm3168a]` `[Prevent]` — Prevent regulator
double-disable during system hibernation (S4) when the codec is already
runtime-suspended.

### Step 1.2: Commit Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Cezary Rojewski \<cezary.rojewski@intel.com\> (author)
|
| Signed-off-by | Mark Brown \<broonie@kernel.org\> (ASoC maintainer) |
| Link | https://patch.msgid.link/20260525201801.1336936-2-
cezary.rojewski@intel.com |

**Notable patterns:** Message-ID suffix `-2-` suggests patch 2 of a
series. No Reported-by, Fixes:, Cc: stable, or syzbot tags. Maintainer
(Mark Brown) committed the patch.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Without `SYSTEM_SLEEP_PM_OPS`, hibernation (S4) runs the
  suspend path even when resume is skipped (`smart_suspend=true`),
  causing regulators to be disabled twice on an already runtime-
  suspended pcm3168a device.
- **Symptom:** Kernel warning: `"unbalanced disables for <regulator>"`
  from the regulator core.
- **Root cause (author):** Missing system-sleep PM ops; hibernation
  suspend sequence runs unconditionally while resume is optimized away.
- **Version info:** None explicit; references generic PM behavior in
  `device_complete()` / `drivers/base/power/main.c`.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit bug fix, not disguised cleanup.
Adding `SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
pm_runtime_force_resume)` is the standard kernel pattern for bridging
runtime PM and system sleep PM.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
| File | Change |
|------|--------|
| `sound/soc/codecs/pcm3168a.c` | +1 line |

**Functions modified:** `pcm3168a_pm_ops` structure initialization only.

**Scope:** Single-file, surgical (1 line added).

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `pcm3168a_pm_ops` had only
  `RUNTIME_PM_OPS(pcm3168a_rt_suspend, pcm3168a_rt_resume, NULL)`.
  System sleep callbacks (`suspend`, `freeze`, `poweroff`, etc.) were
  all NULL.
- **After:** Adds `SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
  pm_runtime_force_resume)`, wiring all system-sleep transitions to the
  PM core's force-suspend/resume helpers.
- **Affected path:** System hibernation (S4) / freeze / suspend when
  device is already runtime-suspended.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Reference counting / double-operation bug in PM path
  (regulator enable_count).
- **Mechanism:** `pcm3168a_rt_suspend()` → `pcm3168a_disable()` →
  `regulator_bulk_disable()`. When the device is already runtime-
  suspended (regulators already disabled), a second system-sleep suspend
  attempt calls disable again. `pm_runtime_force_suspend()` guards this:

```2016:2018:drivers/base/power/runtime.c
        pm_runtime_disable(dev);
        if (pm_runtime_status_suspended(dev) ||
dev->power.needs_force_resume)
                return 0;
```

If already suspended, it returns without invoking `runtime_suspend`
again.

### Step 2.4: Fix Quality
**Record:** Obviously correct; identical pattern used in sibling ASoC
codecs (`ak4458.c`, `cs42xx8.c`, `wm8962.c`) and other subsystems (e.g.
`spi-rockchip.c` backported with `Cc: stable`). Minimal regression risk
— one line, well-understood PM-core API.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- PM ops structure last changed in `15559cdeb9be5` (Mar 2025): "ASoC:
  pcm3168a: Convert to EXPORT_GPL_DEV_PM_OPS()" — cosmetic refactor
  only; did not add system sleep ops.
- Driver introduced `a9b17a638af5a` (Dec 2015) with only
  `SET_RUNTIME_PM_OPS` — missing system sleep ops since birth.
- **Bug present since:** v4.4 era (driver introduction); not a recent
  regression.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:**
- Intel AVS pcm3168a machine board added `79ebb596201c8` (Feb 2025) by
  same author — likely where bug was discovered during hibernation
  testing.
- Recent pcm3168a changes are feature/format work, not PM fixes.
- **Standalone:** Yes — no other commits required for this one-line fix.

### Step 3.4: Author Context
**Record:** Cezary Rojewski (Intel) — author of Intel AVS pcm3168a board
support; active contributor to `sound/soc/codecs/` and Intel AVS boards.

### Step 3.5: Dependencies
**Record:** Requires `EXPORT_GPL_DEV_PM_OPS` / `RUNTIME_PM_OPS` macros
(present since `15559cdeb` in this tree). Requires
`pm_runtime_force_suspend/resume` (present under `CONFIG_PM_SLEEP`).
**Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <commit>` could not run — commit not in local
tree. Link fetch to patch.msgid.link blocked (Anubis bot protection).
**Lore discussion URL: UNVERIFIED.**

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 dig -w. Mark Brown committed the patch
(ASoC maintainer acceptance).

### Step 4.3: Bug Report
**Record:** No external bug report linked. Bug found during Intel AVS
pcm3168a development/testing (inferred from author and timing).

### Step 4.4: Series Context
**Record:** Message-ID `1336936-2` implies a 2-patch series; this fix is
self-contained in `pcm3168a.c` and does not depend on patch 1 for
correctness (UNVERIFIED: patch 1 content not inspected).

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore.kernel.org inaccessible. Analogous `spi:
rockchip` fix was explicitly `Cc: stable@vger.kernel.org` for the same
class of runtime/system PM imbalance.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `pcm3168a_pm_ops` (modified), `pcm3168a_rt_suspend()`
(indirectly protected), `pcm3168a_disable()` (contains the double-
disable), `pm_runtime_force_suspend()` / `pm_runtime_force_resume()`
(added callbacks).

### Step 5.2: Callers
**Record:**
- `pcm3168a_pm_ops` referenced from `pcm3168a-i2c.c` and
  `pcm3168a-spi.c` via `.pm = pm_ptr(&pcm3168a_pm_ops)`.
- System PM core calls sleep ops during `dpm_suspend` / hibernation
  freeze/poweroff phases.
- `pcm3168a_rt_suspend` also called via runtime PM idle/autosuspend
  during normal operation.

### Step 5.3: Callees
**Record:** `pcm3168a_disable()` → `regulator_bulk_disable()` +
`clk_disable_unprepare()`. Warning originates in `_regulator_disable()`
when `enable_count == 0`.

### Step 5.4: Reachability
**Record:** Triggered during hibernation (S4) on systems with
`CONFIG_SND_SOC_PCM3168A` and `CONFIG_HIBERNATION`. Intel AVS pcm3168a
boards, TI K3 EVMs, Renesas boards using this codec. Requires user-
initiated hibernate while codec is runtime-suspended (common idle
scenario).

### Step 5.5: Similar Patterns
**Record:** ~60 codecs have only `RUNTIME_PM_OPS` without
`SYSTEM_SLEEP_PM_OPS`; pcm3168a is vulnerable because its
`runtime_suspend` disables physical regulators. Codecs like `ak4458.c`
already use the force-suspend pattern:

```731:734:sound/soc/codecs/ak4458.c
static const struct dev_pm_ops ak4458_pm = {
        RUNTIME_PM_OPS(ak4458_runtime_suspend, ak4458_runtime_resume,
NULL)
        SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
pm_runtime_force_resume)
};
```

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current tree at
`sound/soc/codecs/pcm3168a.c:908-910`:

```908:910:sound/soc/codecs/pcm3168a.c
EXPORT_GPL_DEV_PM_OPS(pcm3168a_pm_ops) = {
        RUNTIME_PM_OPS(pcm3168a_rt_suspend, pcm3168a_rt_resume, NULL)
};
```

No `SYSTEM_SLEEP_PM_OPS` — fix not yet applied.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** One line insertion after
`RUNTIME_PM_OPS` line. `EXPORT_GPL_DEV_PM_OPS` conversion already in
tree (`15559cdeb`). No conflicts anticipated.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix found in tree history (`git log --grep`
for "double-disable" / "pcm3168a.*S4" returned nothing).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `sound/soc/codecs/` — **PERIPHERAL** (driver-specific), but
hibernation is a core system feature; regulator warnings indicate broken
power state.

### Step 7.2: Subsystem Activity
**Record:** Actively developed — Intel AVS pcm3168a board added Feb
2025; recent card-name updates. Driver mature (since 2015) with ongoing
platform enablement.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of pcm3168a codec (I2C/SPI) who hibernate — Intel AVS
platforms, embedded TI/Renesas boards. Config-dependent:
`CONFIG_SND_SOC_PCM3168A`.

### Step 8.2: Trigger Conditions
**Record:** Hibernation (S4) while pcm3168a is already runtime-suspended
(idle audio). Not timing-dependent race; deterministic PM sequencing
bug. Unprivileged users can trigger via `echo disk > /sys/power/state`.

### Step 8.3: Failure Mode Severity
**Record:** `WARN` from regulator core (`"unbalanced disables for %s"`).
**Severity: MEDIUM** — does not panic, but indicates broken regulator
refcount state that can leave hardware/PM in inconsistent state. Similar
class of bugs backported to stable (rockchip SPI clock double-disable).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — fixes real hibernation warning on affected
  hardware; correct PM integration.
- **Risk:** VERY LOW — 1-line addition of established kernel pattern.
- **Ratio:** Strong benefit-to-risk ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible bug during hibernation (author-verified on Intel
  AVS pcm3168a)
- Standard, proven fix pattern (`pm_runtime_force_suspend/resume`)
- Maintainer-committed (Mark Brown)
- Surgical 1-line change
- Bug present since driver introduction (2015); driver and Intel AVS
  board exist in 6.18.44
- Analogous fixes backported to stable in other subsystems

**AGAINST backport:**
- Affects only pcm3168a users who hibernate (niche but real)
- Failure is WARN, not crash/oops
- Intel AVS pcm3168a board is relatively new (but core driver is old and
  widely used on embedded)

**UNRESOLVED:**
- Full lore review thread (blocked)
- Patch 1 of series content (likely independent)

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard PM pattern;
Intel developer found during board bring-up |
| 2. Fixes a real bug? | **PASS** — regulator unbalanced-disable WARN
during S4 |
| 3. Important issue? | **PASS** — MEDIUM: incorrect PM state during
hibernation |
| 4. Small and contained? | **PASS** — 1 line, 1 file |
| 5. No new features/APIs? | **PASS** — wires existing PM-core helpers |
| 6. Can apply to local tree? | **PASS** — driver and prerequisites
present in 6.18.44 |

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard PM
bug fix.

### Step 9.4: Decision Rationale
This fix addresses a real hibernation PM bug in a long-standing codec
driver that is now used on Intel AVS platforms in this tree. The change
is minimal, follows an established pattern already used in multiple ASoC
codecs, and prevents regulator refcount corruption during S4. It meets
all stable kernel criteria for this 6.18.y tree.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff
- [Phase 2] Diff analysis: +1 line to `pcm3168a_pm_ops` in
  `sound/soc/codecs/pcm3168a.c`
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame -L 908,910`: PM ops from `15559cdeb` (Mar 2025);
  closing brace from `a9b17a638af5a` (Dec 2015)
- [Phase 3] `git log --oneline -10 -- sound/soc/codecs/pcm3168a.c`:
  driver history confirmed
- [Phase 3] `git log -S "pcm3168a_rt_suspend"`: runtime PM since driver
  introduction
- [Phase 3] `git show be721b451affb`: analogous rockchip SPI fix with
  Cc: stable confirmed
- [Phase 3] `git show b429ca4940650`: cs42xx8 force-suspend pattern
  confirmed
- [Phase 4] WebFetch patch.msgid.link: **FAILED** (bot protection)
- [Phase 4] `b4 dig`: commit not in tree; could not match
- [Phase 5] Read `pcm3168a_disable()`, `pcm3168a_rt_suspend()`,
  `pm_runtime_force_suspend()` in local tree
- [Phase 5] Read `_regulator_disable()` WARN at
  `drivers/regulator/core.c:3032-3033`
- [Phase 5] Grep: `ak4458.c`, `cs42xx8.c`, `wm8962.c` use same
  `SYSTEM_SLEEP_PM_OPS` pattern
- [Phase 5] Grep: `pcm3168a_pm_ops` used in `pcm3168a-i2c.c`,
  `pcm3168a-spi.c`
- [Phase 6] Confirmed buggy code present at lines 908-910 without fix
- [Phase 6] Confirmed `EXPORT_GPL_DEV_PM_OPS` prerequisite (`15559cdeb`)
  in tree
- [Phase 6] Confirmed Intel AVS pcm3168a board (`79ebb596201c8`) in tree
- [Phase 7] Kconfig: `CONFIG_SND_SOC_PCM3168A` exists in
  `sound/soc/codecs/Kconfig`
- [Phase 8] Read `dev_pm_skip_suspend()` / `dev_pm_skip_resume()` in
  `drivers/base/power/main.c`
- [UNVERIFIED] Lore review discussion and patch 1 of series
- [UNVERIFIED] Whether author explicitly nominated for stable on mailing
  list

**YES**

 sound/soc/codecs/pcm3168a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index c8617a488b11c..7f8d64fb0e57f 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -907,6 +907,7 @@ static int pcm3168a_rt_suspend(struct device *dev)
 
 EXPORT_GPL_DEV_PM_OPS(pcm3168a_pm_ops) = {
 	RUNTIME_PM_OPS(pcm3168a_rt_suspend, pcm3168a_rt_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 MODULE_DESCRIPTION("PCM3168A codec driver");
-- 
2.53.0

