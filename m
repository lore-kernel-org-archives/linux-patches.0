Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A063B560ADA;
	Mon, 31 Aug 2026 13:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184061; cv=none; b=mK6kkBcm9+M+4NzIyUe6vmADzC8UwEgBSpUWlHI9Kkd8L/nzfLuRZY6H54fBs/TbxfehdV/Un5KHRaIo64plrDPx8jkEuzYRy/9HluUwCcjFCb3DGCxt8DD6AVn8QHSoPrLmd6efQYHWNGZyTJPU/YDhFJ71FYqYXSDwDDmb4Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184061; c=relaxed/simple;
	bh=NVqwtR2JMe9AwlW3LuScSuLjgbnBlXiLis2DuFJWAVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1xNmY30fZklBEaC3SbfhafpGKOwOLsTeBZqrNl6yq3qf6VTCF38EuQD8B+/CTqVGT9iH9rAjz/vk1yRGS+rJE3Y7lzk6uI2vnrkocJCk9gQPpPK7XYQiqERoTfD7Lw7jwHAjENn13uiJeqnw4NXFHRRwFdH+D87CQi9dnPd8/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2mevS4t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2mevS4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD7D1F000E9;
	Mon, 31 Aug 2026 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184058;
	bh=Tw6EkeI3MsODnaTUWFwS7+qgu5zD8t+eKLWoa27lKJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2mevS4t0zh+4x+9ZzG6DqWQUheBofGMhid+6ZypeFFyRLcI0ILpiW/6jnGIu+E58
	 Xx5DevoVwSSub+I9LvHH2tmTjv/wnO/HOMtU8aejIAzDlEEtNtG0rDoGz6I2XfqbdN
	 Y75FOhVzFxKvjpI03GSMovV+haJNMvbT8td6/2JBmwqMgvFG0P7fiyELs+qfP+h9vs
	 1i3CBFAmbXN9R4wsnVplRh4C50XQjStZ2BPDo08CA/hYezYBTA90swqFZslb3pdQdv
	 KW2QY7KoMbc2zIiQTv2wPJe6/zx3aIP0D6myYQ6dVRSgdPV5k4YDhlJI47zmt3qoO9
	 yc4tm9CreLG4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Petr Wozniak <petr.wozniak@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux@armlinux.org.uk,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] net: phy: sfp: probe for RollBall I2C-to-MDIO bridge in mdio-i2c
Date: Mon, 31 Aug 2026 09:28:14 -0400
Message-ID: <20260831133314.4125787-466-sashal@kernel.org>
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

From: Petr Wozniak <petr.wozniak@gmail.com>

[ Upstream commit 8fe125892f40cbe284fba8eda49a0407984fc74c ]

The "OEM"/"SFP-10G-T" quirk entry in sfp_fixup_rollball_cc()
unconditionally forces MDIO_I2C_ROLLBALL for all modules matching that
vendor/part-number combination.  This works for modules that genuinely
implement a RollBall I2C-to-MDIO bridge, but silently breaks modules
that share the same EEPROM strings without having such a bridge.

The Realtek RTL8261BE-CG is one such module: a pure copper 10G SFP+
media converter with no I2C-to-MDIO bridge.  Its EEPROM reports
vendor="OEM", part="SFP-10G-T-I", and -- critically -- Vendor OUI
00:00:00, making OUI-based differentiation impossible.  With
MDIO_I2C_ROLLBALL forced, the module silently ACKs the unlock password
write, the MDIO bus is created, but no PHY responds; the SFP state
machine cycles through the RollBall PHY-probe retry window before
reporting no PHY.

Move the probe into i2c_mii_init_rollball() in mdio-i2c.c, where the
RollBall protocol constants are already defined.  After sending the
unlock password, issue a CMD_READ and poll for CMD_DONE up to 200 ms
(10 x 20 ms, matching the existing rollball poll tolerance).  A genuine
RollBall bridge asserts CMD_DONE within that window; modules without a
bridge never do, so i2c_mii_init_rollball() returns -ENODEV.
mdio_i2c_alloc() propagates -ENODEV to the caller to signal that no
bridge is present and PHY probing should be skipped.
sfp_sm_add_mdio_bus() catches -ENODEV and transitions
sfp->mdio_protocol to MDIO_I2C_NONE so the rest of the state machine
skips PHY probing for this module.

Any I2C-level error (NACK, timeout) during the probe is also treated as
-ENODEV: if the module does not respond at I2C address 0x51 at all,
there is certainly no RollBall bridge there, and SFP initialization
should not abort.

The probe writes are safe with respect to SFP EEPROM integrity: only
modules explicitly listed in the quirk table enter this path, and the
RollBall password unlock write to 0x51 was already issued by
i2c_mii_init_rollball() before the probe for all such modules.  Any
module without a device at 0x51 NACKs the transfer and is treated as
-ENODEV.

Add "OEM"/"SFP-10G-T-I" to the quirk table so RTL8261BE modules enter
the probe path; genuine RollBall modules continue to work as before.

Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260527053909.2118-1-petr.wozniak@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[net: phy: sfp]` `[probe]` — Add runtime detection of
  RollBall I2C-to-MDIO bridge before using RollBall MDIO protocol; add
  quirk for OEM/SFP-10G-T-I (RTL8261BE).

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>` (author)
  - `Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>`
    (SFP/mdio-i2c contributor)
  - `Link: https://patch.msgid.link/20260527053909.2118-1-
    petr.wozniak@gmail.com`
  - `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev
    maintainer)
  - No `Fixes:`, no `Reported-by:`, no `Cc: stable@vger.kernel.org`, no
    syzbot
  - Notable: maintainer sign-off + subsystem reviewer; v8 changelog
    documents hardware testing on BPI-R4 (MT7988A, 6.12.87)

**Step 1.3 — Body analysis**
- Record:
  - **Bug:** `sfp_fixup_rollball_cc()` for `"OEM"/"SFP-10G-T"`
    unconditionally sets `MDIO_I2C_ROLLBALL`. Modules with matching
    EEPROM strings but no RollBall bridge get the wrong protocol.
  - **Affected hardware:** Realtek RTL8261BE-CG (`vendor="OEM"`,
    `part="SFP-10G-T-I"`, OUI `00:00:00`).
  - **Symptom:** Password unlock ACKs, MDIO bus is created, no PHY
    responds; state machine burns through RollBall PHY-probe retries
    (`phy_t_retry` = 1s × `R_PHY_RETRY` = 25 → up to ~25s) before
    logging “no PHY detected”.
  - **Fix:** Probe RollBall bridge in `i2c_mii_init_rollball()` after
    unlock; return `-ENODEV` if no `CMD_DONE`; `sfp_sm_add_mdio_bus()`
    downgrades to `MDIO_I2C_NONE` and skips PHY probing. Add
    `"OEM"/"SFP-10G-T-I"` quirk to enter probe path.
  - **Root cause:** EEPROM-based quirk matching cannot distinguish
    RollBall vs non-RollBall modules sharing OEM strings.

**Step 1.4 — Hidden bug fix?**
- Record: Yes. Described as probing/enhancement, but it fixes incorrect
  MDIO protocol selection — a functional hardware-support bug, not
  cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record:
  - `drivers/net/mdio/mdio-i2c.c`: +~48 lines (new
    `i2c_mii_probe_rollball()`, extend `i2c_mii_init_rollball()`, adjust
    error logging in `mdio_i2c_alloc()`)
  - `drivers/net/phy/sfp.c`: +~9 lines (new quirk entry, `-ENODEV`
    handling in `sfp_sm_add_mdio_bus()`)
  - Functions: `i2c_mii_probe_rollball()`, `i2c_mii_init_rollball()`,
    `mdio_i2c_alloc()`, `sfp_sm_add_mdio_bus()`
  - Scope: two-file, surgical hardware-quirk fix

**Step 2.2 — Code flow per hunk**

| Hunk | Before | After |
|------|--------|-------|
| `i2c_mii_init_rollball()` | Password write only; success → return 0 |
Password write + RollBall CMD_READ/CMD_DONE probe (10×20ms); I2C NACK →
`-ENODEV` |
| `mdio_i2c_alloc()` ROLLBALL case | Any init failure logged as error |
`-ENODEV` (no bridge) logged silently |
| `sfp_sm_add_mdio_bus()` | Always create bus if protocol ≠ NONE | On
`-ENODEV`, set `mdio_protocol = MDIO_I2C_NONE`, continue |
| `sfp_quirks[]` | No `SFP-10G-T-I` entry | Add `SFP_QUIRK_F("OEM",
"SFP-10G-T-I", sfp_fixup_rollball)` |

**Step 2.3 — Bug mechanism**
- Record: **Logic / hardware-quirk correctness fix.** Wrong MDIO
  protocol forced by EEPROM quirk matching. Non-RollBall copper SFP+
  modules get RollBall init + lengthy failed PHY probes. Fix adds
  runtime bridge detection and graceful fallback.

**Step 2.4 — Fix quality**
- Record: Obviously correct; reuses existing RollBall constants and
  10×20ms polling pattern from `i2c_rollball_mii_poll()`. Minimal
  regression risk for genuine RollBall modules (probe must pass
  CMD_DONE, which real bridges do). Low risk: only modules already in
  quirk table enter this path.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record:
  - `i2c_mii_init_rollball()`: introduced `09bbedac72d5a` (2022-09-30,
    v6.1 era) — password-only init, no bridge probe
  - `sfp_fixup_rollball_cc()` / `OEM/SFP-10G-T` quirk: introduced
    `324e88cbe3b7b` (2022-09-30)
  - `OEM/SFP-10G-T` also touched in `5859a99b52254` (Fiberstore/Walsun
    support, 2024)
  - All present in this tree (v6.18.44)

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag. Underlying issue introduced with
  RollBall support (2022); unconditional quirk matching is the design
  gap.

**Step 3.3 — Related file history**
- Record: Recent stable churn in these files includes `86d379fcf1b79`
  (mii_bus free in destroy), SMBus support, other SFP quirks. No
  conflicting fix for this issue. Standalone patch (v8, no series
  dependency).

**Step 3.4 — Author context**
- Record: Petr Wozniak has one prior commit in this tree
  (`86d379fcf1b79`, SFP mii_bus free). Maxime Chevallier contributed
  SMBus mdio-i2c and SFP SMBus support. Jakub Kicinski is netdev
  maintainer.

**Step 3.5 — Dependencies**
- Record: Self-contained. All symbols (`i2c_transfer_rollball`,
  `ROLLBALL_*` constants, `sfp_fixup_rollball`, `sfp_sm_add_mdio_bus`)
  exist in v6.18.44. No prerequisite commits required.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record: Local mbox `v8_20260527_petr_wozniak_net_phy_sfp_probe_for_rol
  lball_i2c_to_mdio_bridge_in_mdio_i2c.mbx` contains v8 submission. `b4
  dig` on commit hash failed (commit not in local tree); `b4 am` found
  2-message thread. Lore web fetch blocked (403/Anubis). Review
  evolution v1→v8 documented in cover letter.

**Step 4.2 — Reviewers**
- Record: `Reviewed-by: Maxime Chevallier` (mdio-i2c/SFP contributor).
  Jakub Kicinski merged. Multiple review rounds with Maxime and Jakub
  feedback incorporated.

**Step 4.3 — Bug report**
- Record: No formal bugzilla/syzbot. Hardware validation documented in
  v8 changelog: RTL8261BE → `MDIO_I2C_NONE`, link Up 10Gbps; genuine
  RollBall `OEM/SFP-10G-T` → bridge detected, link Up 10Gbps. Tested on
  BPI-R4, kernel 6.12.87.

**Step 4.4 — Series context**
- Record: Standalone 1-patch series (v8). No other patches required.

**Step 4.5 — Stable list**
- Record: No stable-list discussion found (lore fetch blocked). Not a
  negative signal per instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `i2c_mii_probe_rollball()`, `i2c_mii_init_rollball()`,
  `mdio_i2c_alloc()`, `sfp_i2c_mdiobus_create()`,
  `sfp_sm_add_mdio_bus()`, `sfp_sm_probe_for_phy()`

**Step 5.2 — Callers**
- Record:
  - `mdio_i2c_alloc()` ← `sfp_i2c_mdiobus_create()` ←
    `sfp_sm_add_mdio_bus()` ← SFP state machine `SFP_S_INIT` (module
    hotplug/insertion)
  - Triggered on every SFP module insert for quirk-matched RollBall
    candidates

**Step 5.3 — Callees**
- Record: `i2c_transfer()`, `i2c_transfer_rollball()`, `msleep(20)`,
  `mdiobus_alloc/free/register`

**Step 5.4 — Reachability**
- Record: Userspace cannot directly trigger; triggered by SFP hotplug on
  hardware with `CONFIG_SFP` + SFP cage. Common embedded/router use case
  (e.g. BPI-R4). Bug affects real device bring-up.

**Step 5.5 — Similar patterns**
- Record: `i2c_rollball_mii_poll()` already uses identical 10×20ms
  CMD_DONE polling (lines 318–331 of `mdio-i2c.c`). New probe mirrors
  established pattern.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**
- Record: **Yes.** `i2c_mii_init_rollball()` at line 422 does password-
  only init. `OEM/SFP-10G-T` quirk at line 582 uses
  `sfp_fixup_rollball_cc`. No `SFP-10G-T-I` quirk. No
  `i2c_mii_probe_rollball()`. Fix not yet applied.

**Step 6.2 — Backport complications**
- Record: Clean apply expected. File structure matches diff context. No
  significant refactor since RollBall support landed.

**Step 6.3 — Related fixes already present?**
- Record: None. `grep` confirms `SFP-10G-T-I` and
  `i2c_mii_probe_rollball` absent.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
- Record: `drivers/net/phy/sfp.c` + `drivers/net/mdio/mdio-i2c.c` —
  network PHY/SFP. Criticality: **IMPORTANT** (not universal core, but
  affects all SFP cage users with copper modules).

**Step 7.2 — Activity**
- Record: Actively maintained; recent quirk additions and SMBus support
  in 6.18.y.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users of copper SFP/SFP+ modules on RollBall-quirk-matched
  EEPROM strings, especially RTL8261BE (`OEM/SFP-10G-T-I`) and any
  `OEM/SFP-10G-T` modules lacking a RollBall bridge. Platform-specific
  (SFP-capable hardware).

**Step 8.2 — Trigger conditions**
- Record: SFP module insertion with matching EEPROM vendor/part. Common
  on hotplug. Not security-relevant; not userspace-triggerable directly.

**Step 8.3 — Failure mode severity**
- Record:
  - Wrong RollBall protocol → up to ~25s PHY-probe delay (`phy_t_retry`
    1s × 25 retries for RollBall-quirked modules)
  - “no PHY detected” — link may fail or come up without proper PHY
    management depending on module
  - RTL8261BE: without fix, module not correctly handled (author tested:
    with fix → 10G link up)
  - Severity: **MEDIUM** (functional breakage / long bring-up delay, not
    crash/corruption)

**Step 8.4 — Risk-benefit**
- Record:
  - **Benefit:** HIGH for affected hardware users — restores working 10G
    copper SFP+ operation; eliminates lengthy failed probe loops
  - **Risk:** LOW — ~63 lines, reviewed, hardware-tested, only affects
    quirk-listed modules, genuine RollBall bridges pass probe
  - **Ratio:** Favorable for stable

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Fixes real hardware breakage (RTL8261BE and similar OEM copper SFP+
  modules)
- Classic hardware quirk/workaround category (explicit stable exception)
- Small, contained, reviewed by subsystem expert, merged by maintainer
- Hardware-tested (10G link up on both affected and genuine RollBall
  modules)
- Buggy code present in v6.18.44; fix applies cleanly
- Prevents up to ~25s failed PHY-probe delay on misidentified modules

AGAINST backport:
- Not a crash, security, or data-corruption issue
- Affects only SFP-capable systems with specific modules
- No syzbot/user bugzilla report (author hardware test only)

UNRESOLVED: None affecting the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — reviewed, hardware-tested,
   mirrors existing poll logic
2. Fixes real bug affecting users? **PASS** — broken/slow SFP module
   bring-up on real hardware
3. Important issue? **PASS** — functional hardware breakage (MEDIUM
   severity)
4. Small and contained? **PASS** — 2 files, ~63 lines
5. No new features/APIs? **PASS** — runtime detection within existing
   RollBall framework; one quirk table entry
6. Can apply to local tree? **PASS** — all prerequisites present, clean
   apply expected

**Step 9.3 — Exception category**
- Record: **Hardware quirk/workaround** for misidentified SFP modules —
  explicitly stable-appropriate.

**Step 9.4 — Decision rationale**

This patch fixes incorrect MDIO protocol selection for copper SFP+
modules that share OEM EEPROM identifiers with RollBall designs but lack
the RollBall I2C-to-MDIO bridge. In v6.18.44, the unconditional RollBall
quirk path and password-only init are present; RTL8261BE modules are not
handled correctly. The fix adds a conservative runtime probe and a
targeted quirk entry, with hardware validation and maintainer review. It
fits the stable hardware-quirk exception, is low-risk, and restores
working netdev functionality for affected users.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  local mbox file
- [Phase 1] Confirmed `Reviewed-by: Maxime Chevallier`, `Signed-off-by:
  Jakub Kicinski`, no syzbot/Fixes tags
- [Phase 2] Diff analysis: 2 files, ~63 lines; functions identified from
  diff and source
- [Phase 2] Read current `i2c_mii_init_rollball()` (lines 422–446) —
  password-only, no probe
- [Phase 2] Read `i2c_rollball_mii_poll()` (lines 318–331) — confirms
  10×20ms poll pattern reused
- [Phase 3] `git describe HEAD` → v6.18.44 / 6.18.44
- [Phase 3] `git blame` on `i2c_mii_init_rollball()` → `09bbedac72d5a`
  (2022-09-30)
- [Phase 3] `git blame` on `sfp_fixup_rollball_cc()` → `324e88cbe3b7b`
  (2022-09-30)
- [Phase 3] `git show 5859a99b52254` — `OEM/SFP-10G-T` quirk added for
  Fiberstore/Walsun RollBall modules
- [Phase 3] `git log --oneline -15` on modified files — no duplicate fix
- [Phase 3] `git log --grep='RollBall'` — RollBall support chain
  confirmed in tree
- [Phase 4] Read local mbox v8 — hardware test results, review history
  v1–v8
- [Phase 4] `b4 dig` on URL — thread found (2 messages); lore web fetch
  blocked
- [Phase 5] Traced call chain: `SFP_S_INIT` → `sfp_sm_add_mdio_bus()` →
  `sfp_i2c_mdiobus_create()` → `mdio_i2c_alloc()` (lines 2754,
  2023–2028, 827–832)
- [Phase 5] Read `sfp_sm_probe_for_phy()` and retry logic (lines
  2042–2063, 2771–2781)
- [Phase 5] Confirmed `R_PHY_RETRY=25`, RollBall `phy_t_retry=1000ms` →
  up to ~25s delay
- [Phase 6] `grep SFP-10G-T-I` — not in tree; fix absent
- [Phase 6] `grep i2c_mii_probe_rollball` — not in tree
- [Phase 6] Confirmed `OEM/SFP-10G-T` quirk at line 582 with
  `sfp_fixup_rollball_cc`
- [Phase 6] Read `sfp_lookup_quirk()` / `sfp_match()` — exact-length
  string match (SFP-10G-T ≠ SFP-10G-T-I)
- [Phase 7] Confirmed subsystem paths and recent maintenance activity
- [Phase 8] Assessed failure mode from state machine code and commit
  message — functional breakage + long delay, not oops

**YES**The background `git log -S` check didn’t finish (it was killed
after hanging), but the same question was already answered with faster
lookups: this tree is **v6.18.44**, and the fix is **not** present —
there’s no `SFP-10G-T-I` quirk and no `i2c_mii_probe_rollball()` in
`drivers/net/phy/sfp.c` or `drivers/net/mdio/mdio-i2c.c`.

The prior analysis stands: this is a small hardware-quirk fix for
misidentified copper SFP+ modules (e.g. RTL8261BE), and it should be
backported to this tree.

**YES**

 drivers/net/mdio/mdio-i2c.c | 59 ++++++++++++++++++++++++++++++++-----
 drivers/net/phy/sfp.c       | 14 +++++++--
 2 files changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
index ed20352a589a3..b88f63234b4e6 100644
--- a/drivers/net/mdio/mdio-i2c.c
+++ b/drivers/net/mdio/mdio-i2c.c
@@ -419,6 +419,50 @@ static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int devad,
 	return 0;
 }
 
+static int i2c_mii_probe_rollball(struct i2c_adapter *i2c)
+{
+	u8 data_buf[] = { ROLLBALL_DATA_ADDR, 0x01, 0x00, 0x00 };
+	u8 cmd_buf[]  = { ROLLBALL_CMD_ADDR, ROLLBALL_CMD_READ };
+	u8 cmd_addr   = ROLLBALL_CMD_ADDR;
+	struct i2c_msg msgs[2];
+	u8 result;
+	int ret;
+	int i;
+
+	msgs[0].addr  = ROLLBALL_PHY_I2C_ADDR;
+	msgs[0].flags = 0;
+	msgs[0].len   = sizeof(data_buf);
+	msgs[0].buf   = data_buf;
+	msgs[1].addr  = ROLLBALL_PHY_I2C_ADDR;
+	msgs[1].flags = 0;
+	msgs[1].len   = sizeof(cmd_buf);
+	msgs[1].buf   = cmd_buf;
+
+	ret = i2c_transfer_rollball(i2c, msgs, ARRAY_SIZE(msgs));
+	if (ret < 0)
+		return -ENODEV;
+
+	msgs[0].addr  = ROLLBALL_PHY_I2C_ADDR;
+	msgs[0].flags = 0;
+	msgs[0].len   = 1;
+	msgs[0].buf   = &cmd_addr;
+	msgs[1].addr  = ROLLBALL_PHY_I2C_ADDR;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len   = 1;
+	msgs[1].buf   = &result;
+
+	for (i = 0; i < 10; i++) {
+		msleep(20);
+		ret = i2c_transfer_rollball(i2c, msgs, ARRAY_SIZE(msgs));
+		if (ret < 0)
+			return -ENODEV;
+		if (result == ROLLBALL_CMD_DONE)
+			return 0;
+	}
+
+	return -ENODEV;
+}
+
 static int i2c_mii_init_rollball(struct i2c_adapter *i2c)
 {
 	struct i2c_msg msg;
@@ -438,11 +482,11 @@ static int i2c_mii_init_rollball(struct i2c_adapter *i2c)
 
 	ret = i2c_transfer(i2c, &msg, 1);
 	if (ret < 0)
-		return ret;
-	else if (ret != 1)
+		return -ENODEV;
+	if (ret != 1)
 		return -EIO;
-	else
-		return 0;
+
+	return i2c_mii_probe_rollball(i2c);
 }
 
 static bool mdio_i2c_check_functionality(struct i2c_adapter *i2c,
@@ -487,9 +531,10 @@ struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
 	case MDIO_I2C_ROLLBALL:
 		ret = i2c_mii_init_rollball(i2c);
 		if (ret < 0) {
-			dev_err(parent,
-				"Cannot initialize RollBall MDIO I2C protocol: %d\n",
-				ret);
+			if (ret != -ENODEV)
+				dev_err(parent,
+					"Cannot initialize RollBall MDIO I2C protocol: %d\n",
+					ret);
 			mdiobus_free(mii);
 			return ERR_PTR(ret);
 		}
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index af43530ffb2c3..e242c1a1238f9 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -579,6 +579,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
 	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
 
+	SFP_QUIRK_F("OEM", "SFP-10G-T-I", sfp_fixup_rollball),
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
 	SFP_QUIRK_S("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_S("OEM", "SFP-2.5G-BX10-D", sfp_quirk_2500basex),
@@ -2024,10 +2025,17 @@ static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
 
 static int sfp_sm_add_mdio_bus(struct sfp *sfp)
 {
-	if (sfp->mdio_protocol != MDIO_I2C_NONE)
-		return sfp_i2c_mdiobus_create(sfp);
+	int ret;
 
-	return 0;
+	if (sfp->mdio_protocol == MDIO_I2C_NONE)
+		return 0;
+
+	ret = sfp_i2c_mdiobus_create(sfp);
+	if (ret == -ENODEV) {
+		sfp->mdio_protocol = MDIO_I2C_NONE;
+		return 0;
+	}
+	return ret;
 }
 
 /* Probe a SFP for a PHY device if the module supports copper - the PHY
-- 
2.53.0

