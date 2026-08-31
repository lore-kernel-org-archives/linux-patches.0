Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05231485CC4;
	Mon, 31 Aug 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183487; cv=none; b=CY836nD0LEZCawM9//9ZB8JZbv/m5HzVDTrNgQswLh/TLf+dc3a5wdLcJCCdxtTda9bAPRJRbQp5Vc9tBFLCKXuzQuTIgxBYJMyk3UBXkA2B+jilnr845ZOPQO+xqcVssAuHf+7XHqWUCEs5jHBhX0rVy9l7lGQtS8Jp7Mc+4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183487; c=relaxed/simple;
	bh=StpQ1iPH5C1RTadg3qaMSm7ReaIYMlq1adkj2M/QTdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L13SMEqsWQIbbvda7tgcnC0mLpgn+juduWgiod7J73RcgjsSLrNPSU9YYcQJOfzdXIRyS1OURo/Kn4JoxAqta0nuEbrWqYTaYNvwi6kamRw9A7Iki/m2VDwyOIXxhMRSnp3nuEmy3XCPWT7VF9HsPtv20mdfXRyY1Sas4Jt+H58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFYwWXFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFYwWXFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BC51F00A3D;
	Mon, 31 Aug 2026 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183484;
	bh=2GPnmN3E3Ldl1J2uBgjrNLFYb5skGIA23TTI8oRt1T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFYwWXFSYUdpFBV+tbQBZjlcWsqsaXNzkhodx1ia3zKmDTw8aFmGLK2wtmwCpDs+A
	 WzT7QTIXAPhGGo8E0TUPXq8QrbTRoYlLfCd0YSCDPu88+Ebavj3cSMUXmJW+/IdQUa
	 98e57kW8ZCES0mclvTu6J/anfrLn36cLw5icTQcxU4NeUFqQYBePOnEhVjvKc8CG+H
	 ZpjGOKvZ2ysBYxubxQNBFRhB13U/ikg6mpeBTuqxedLZTRdkh4a91/pnQHc4cYS/nO
	 o31QbQv3e01+1INrownWgL/pOqN4Dol2CWq/6mnXi1u0lK2Xb9iHPVRnDd2Ou9NQ/A
	 q3KO6Qz0qRv5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	linux-pm@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] thermal/drivers/tegra/soctherma: Switch to devm cooling device registration
Date: Mon, 31 Aug 2026 09:22:32 -0400
Message-ID: <20260831133314.4125787-124-sashal@kernel.org>
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

From: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>

[ Upstream commit ee126267bc04bfb03816ae9d71ca24c5bf99e739 ]

Use devm_thermal_of_cooling_device_register() to simplify resource
management and avoid manual cleanup in error paths.

As a side effect this change has the benefit of solving an existing
issue. Before, the function tegra_soctherm_remove() only called
debugfs_remove_recursive() and never called thermal_cooling_device_unregister()
for any of the cooling devices registered here.

After the driver removal, the thermal framework's cdev list would
still hold references to thermal_cooling_device objects whose devdata
pointer (ts) pointed to memory already freed by the platform device's
devm cleanup.

With this change, the cooling device is unregistered when the driver
is removed, thus fixing the issue above.

Signed-off-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260424160019.41710-2-daniel.lezcano@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: tegra/soctherm devm cooling device
registration

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[thermal/drivers/tegra/soctherma]` `[Switch]` — move
throttle cooling-device registration to the devm thermal API.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Daniel Lezcano `<daniel.lezcano@oss.qualcomm.com>`,
  Daniel Lezcano `<daniel.lezcano@kernel.org>`
- **Reviewed-by:** Lukasz Luba `<lukasz.luba@arm.com>`
- **Link:** https://patch.msgid.link/20260424160019.41710-2-
  daniel.lezcano@oss.qualcomm.com
- **Absent (expected):** Fixes:, Reported-by:, Tested-by:, Cc:
  stable@vger.kernel.org
- **Notable:** Part of a 2-patch series; no syzbot/fuzzer report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `tegra_soctherm_remove()` never calls
  `thermal_cooling_device_unregister()` for throttle cooling devices
  registered in `soctherm_init_hw_throt_cdev()`.
- **Symptom:** After driver removal, the thermal core still holds
  `thermal_cooling_device` entries whose `devdata` points at `struct
  tegra_soctherm *ts`, but `ts` is freed by devm when the platform
  device is torn down → use-after-free.
- **Root cause:** Non-devm `thermal_of_cooling_device_register()` with
  no matching unregister in `.remove`.
- **Fix approach:** `devm_thermal_of_cooling_device_register(dev, ...)`
  so unregister happens automatically on device release.

### Step 1.4: Hidden bug fix?
**Record:** Yes. The commit is framed as resource-management cleanup,
but it explicitly fixes a real UAF on driver removal.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/thermal/tegra/soctherm.c` only (+3 / −3 lines)
- **Function modified:** `soctherm_init_hw_throt_cdev()`
- **Scope:** Single-file, surgical change

### Step 2.2: Code flow change
**Record:**
- **Before:** `thermal_of_cooling_device_register(np_stcc, name, ts,
  &throt_cooling_ops)` — lifetime not tied to `pdev->dev`; survives past
  `.remove`.
- **After:** `devm_thermal_of_cooling_device_register(dev, np_stcc,
  name, ts, &throt_cooling_ops)` — cooling device unregistered when
  `dev` is released.
- **Path affected:** Probe-time throttle cooling-device registration;
  cleanup on driver remove/unbind.

### Step 2.3: Bug mechanism
**Record:** **Category:** Use-after-free / missing resource cleanup on
driver removal.

Mechanism verified in tree:
1. `tegra` is allocated with `devm_kzalloc(&pdev->dev, ...)` (line
   2101).
2. Cooling devices store `ts` as `devdata` (line 1704).
3. `throt_get_cdev_cur_state()` dereferences `cdev->devdata` as `ts` and
   reads `ts->regs` (lines 1512–1515).
4. `tegra_soctherm_remove()` only removes debugfs and disables clocks —
   no cooling-device unregister (lines 2228–2235).
5. After remove, thermal framework callbacks can touch freed `ts`
   memory.

### Step 2.4: Fix quality
**Record:** Obviously correct; matches the pattern already used in the
same probe path for thermal zones (`devm_thermal_of_zone_register` at
line 2197). Minimal regression risk; no new APIs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on the registration lines attributes them to
`7e22de67e545d` (“drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()”),
which is clearly unrelated — this tree’s git history for `soctherm.c`
appears squashed/corrupted. **Cannot reliably determine the introducing
commit or kernel version from history in this checkout.**

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in the commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -- drivers/thermal/tegra/soctherm.c`
returns only the unrelated amdgpu commit. History is not usable here.
The buggy pattern is present in the current file content.

### Step 3.4: Author context
**Record:** Daniel Lezcano is a thermal maintainer. No other tegra
thermal commits visible in this tree’s truncated history.

### Step 3.5: Dependencies
**Record:** Patch is **2/2** in a series with patch 1/2 (clock disable
via `devm_add_action_or_reset`). **Patch 2/2 is standalone** — it only
changes the cooling-device registration call and does not depend on
patch 1. `devm_thermal_of_cooling_device_register()` already exists in
this tree’s `thermal_core.c` (lines 1217–1240).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260424160019.41710-2-
  daniel.lezcano@oss.qualcomm.com
- **Series:** 2 patches (clock devm cleanup + this cooling-device devm
  fix)
- **b4:** Reports patch applies clean to current tree
- **Review:** `Reviewed-by: Lukasz Luba` on patch 1/2; no separate
  replies found for patch 2/2 in thread grep
- **Stable nomination:** None found in thread or stable@ search

### Step 4.2: Reviewers
**Record:** CC’d: Rafael Wysocki, Daniel Lezcano, Thierry Reding,
Jonathan Hunter; lists: linux-pm, linux-tegra.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or crash log — bug
identified by code inspection during cleanup.

### Step 4.4: Series context
**Record:** Patch 1/2 is independent (clock error-path cleanup). Not
required for this fix to work.

### Step 4.5: Stable list
**Record:** No prior stable@ discussion found for this issue.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `soctherm_init_hw_throt_cdev()`,
`throt_get_cdev_cur_state()`, `tegra_soctherm_remove()`,
`tegra_soctherm_probe()`.

### Step 5.2: Callers
**Record:**
- `soctherm_init_hw_throt_cdev()` called from `tegra_soctherm_probe()`
  (line 2180)
- Driver registered via `module_platform_driver(tegra_soctherm_driver)`
  (line 2288) — `.remove` runs on unbind/module unload
- Thermal zone trip handling also references `ts->throt_cfgs[i].cdev`
  (lines 617–628)

### Step 5.3: Callees
**Record:** Registration goes through
`devm_thermal_of_cooling_device_register()` →
`__thermal_cooling_device_register()` with devm release via
`thermal_cooling_device_release()`.

### Step 5.4: Reachability
**Record:**
- Requires `CONFIG_TEGRA_SOCTHERM` (tristate, `ARCH_TEGRA ||
  COMPILE_TEST`)
- Requires DT `throttle-cfgs` child nodes with non-OC throttle entries
  (`stc->id < THROTTLE_OC1`)
- Trigger: platform driver remove/unbind after successful probe with
  throttle cooling devices registered
- Post-remove thermal activity (zone polling, trip handling, sysfs) can
  invoke cooling-device ops → UAF

### Step 5.5: Similar patterns
**Record:** Same file already uses devm for zones
(`devm_thermal_of_zone_register`), `tegra` struct, clocks, and other
probe allocations. Cooling-device registration was the outlier.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Lines 1703–1705 still use
`thermal_of_cooling_device_register()`; `tegra_soctherm_remove()` has no
unregister. The fix is not yet in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply.** Verified with `git apply --check` — 3
insertions, 3 deletions, no conflicts.
`devm_thermal_of_cooling_device_register()` is declared in
`include/linux/thermal.h` and implemented in
`drivers/thermal/thermal_core.c`.

### Step 6.3: Related fixes already present?
**Record:** No. `grep thermal_cooling_device_unregister
drivers/thermal/tegra/` returns nothing. Bug remains unfixed.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** `drivers/thermal/tegra/` — Tegra platform thermal driver.
**PERIPHERAL** (Tegra/embedded only), but thermally safety-relevant on
affected hardware.

### Step 7.2: Activity
**Record:** File history unavailable in this checkout; driver is mature
and actively maintained upstream (April 2026 patch series).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Systems with `CONFIG_TEGRA_SOCTHERM` built-in or as a
module, DT `throttle-cfgs` present, and throttle cooling devices
registered (LIGHT/HEAVY, not OC-only configs).

### Step 8.2: Trigger conditions
**Record:** Driver removal/unbind/module unload — not every boot, but a
real kernel code path. Any subsequent thermal-framework access to the
stale cooling device can trigger the bug.

### Step 8.3: Failure mode severity
**Record:** **Use-after-free** via `ts->regs` in
`throt_get_cdev_cur_state()` → kernel oops/panic, unpredictable
behavior. **Severity: HIGH.**

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected Tegra systems — prevents UAF on
  teardown
- **Risk:** VERY LOW — 3-line change, established devm API, no
  structural changes
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real UAF on driver removal, clearly described and verified in code
- Dangling `devdata` (`ts`) dereferenced in `throt_get_cdev_cur_state()`
- Small, surgical, obviously correct devm fix
- `devm_thermal_of_cooling_device_register()` exists in v6.18.44
- Patch applies cleanly
- Reviewed in series by Arm thermal reviewer; thermal maintainer
  authored

**AGAINST backport:**
- Tegra-specific, not universal
- Driver removal is less common than steady-state operation (often
  built-in)
- No fuzzer report or user crash log
- Git history in this checkout cannot confirm how long the bug has
  existed

**Unresolved:** Exact commit that introduced the bug (history unusable
in this tree).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard devm pattern;
   series reviewed
2. Fixes a real user-affecting bug? **PASS** — UAF on driver teardown
3. Important issue? **PASS** — UAF / potential crash
4. Small and contained? **PASS** — 3 lines, one function
5. No new features/APIs? **PASS** — uses existing devm API
6. Can apply to local tree? **PASS** — verified clean apply; API present

### Step 9.3: Exception categories
**Record:** None (not a quirk/DT-ID/docs fix) — standard bug fix.

### Step 9.4: Decision rationale
For **Linux 6.18.44**, the buggy non-devm cooling-device registration
exists, `tegra_soctherm_remove()` does not unregister those devices, and
thermal callbacks dereference the freed `ts` pointer. The fix is
minimal, self-contained, uses infrastructure already in this tree, and
applies cleanly. This meets stable criteria for a real, important UAF
fix.

---

## Verification

- **[Phase 1]** Parsed subject, tags, and body from provided commit
  message
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Read `soctherm.c` lines 1502–1534, 1655–1719, 2101,
  2180, 2228–2235
- **[Phase 2]** Confirmed `throt_get_cdev_cur_state()` dereferences
  `cdev->devdata` as `ts`
- **[Phase 2]** Confirmed `tegra_soctherm_remove()` has no
  `thermal_cooling_device_unregister()`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`
- **[Phase 3]** `git blame -L 1700,1710` → history unreliable (unrelated
  amdgpu commit)
- **[Phase 3]** `git log --oneline -- drivers/thermal/tegra/soctherm.c`
  → single unrelated commit
- **[Phase 3]** Verified `devm_thermal_of_cooling_device_register` in
  `thermal_core.c:1217-1240` and `thermal.h:259`
- **[Phase 4]** `b4 am 20260424160019.41710-2-...` → 2-patch series,
  applies clean
- **[Phase 4]** curl lore mbox → patch 2/2 content and series metadata;
  Reviewed-by on patch 1/2 only
- **[Phase 4]** curl stable@ search → no prior discussion found
- **[Phase 5]** Traced call chain: `probe` →
  `soctherm_init_hw_throt_cdev` → thermal callbacks on stale cdev
- **[Phase 5]** `grep thermal_cooling_device_unregister
  drivers/thermal/tegra/` → no matches
- **[Phase 6]** Confirmed buggy `thermal_of_cooling_device_register()`
  at lines 1703–1705
- **[Phase 6]** `git apply --check` on provided diff → clean apply
  (3+/3-)
- **[Phase 6]** Read `Kconfig` → `CONFIG_TEGRA_SOCTHERM` tristate,
  `ARCH_TEGRA || COMPILE_TEST`
- **[Phase 8]** Failure mode: UAF via `ts->regs` → severity HIGH
- **UNVERIFIED:** Exact kernel version/commit that introduced the non-
  devm registration (git history in this checkout is not trustworthy)

**YES**

 drivers/thermal/tegra/soctherm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/tegra/soctherm.c b/drivers/thermal/tegra/soctherm.c
index 5d26b52beaba7..9d3eb3be2db02 100644
--- a/drivers/thermal/tegra/soctherm.c
+++ b/drivers/thermal/tegra/soctherm.c
@@ -1700,9 +1700,9 @@ static void soctherm_init_hw_throt_cdev(struct platform_device *pdev)
 			stc->init = true;
 		} else {
 
-			tcd = thermal_of_cooling_device_register(np_stcc,
-							 (char *)name, ts,
-							 &throt_cooling_ops);
+			tcd = devm_thermal_of_cooling_device_register(dev, np_stcc,
+								      (char *)name, ts,
+								      &throt_cooling_ops);
 			if (IS_ERR_OR_NULL(tcd)) {
 				dev_err(dev,
 					"throttle-cfg: %s: failed to register cooling device\n",
-- 
2.53.0

