Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CA0440644;
	Mon, 31 Aug 2026 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183231; cv=none; b=FPZX1w+uiWWEVE9tXGeRWozdReTx16EkpgWc3dNsMOfWas95sSvtk4ol8gosFCulPil39RELFcJK6tucbgdh0wUYykdhWhwLOQHsqQuYztNqg96oy8QmEJuN+183TsqA25esaUHXEsKh/6938yC+etga8naZSI81VOuuJB0wzEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183231; c=relaxed/simple;
	bh=YfnjULeoCIyTH+gFVKi8rUa87evviCfdX3+NyNtMil8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJwxik5sLclTnS5kIH05hDq9oWGU1deceI4kw9duTBQYfgCKBQipX4/8+7eSi0q0TlNrwCNjijZp6Xydf4Wt9IZWPu6vwZY0TBjYIiqiMWFVG6YpxMGIZ0u0wbUQuw76wd24s5aEKnfyNjbXFPkt4kYKt9VvN1UIwQ7nKO23E8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4Viux0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4Viux0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C061F00ACA;
	Mon, 31 Aug 2026 13:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183228;
	bh=HJcpBxG0WxAHgLKFkKvOzBL2KDDtVHpZPlJTJFGdmsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4Viux0a0H9cGo8COU+TD6QHnPrl0UJ6P5jz98GSMOWnMJU6MRF2AfZkZ5nDZddFC
	 GNZOromcnGBfGVBr3WJXAxD0iAmi+pp6khlt5mxOFfsSJZhzPc/fzsHZiSMHO9lUfj
	 zL2bKldJ0caBbLupYSazSIl6GDZj/Lb2F8ZE7SsoYes3JXUIul4Nj8uHmXk0w0+aLr
	 k/9SEHN8smmIwR8lcrIoV8H5I0j6Tvx2mnzpjtdfRAl4+KYzXHjfs7uALNW4QOf06P
	 C3Euc1tOHyJ3fgmYN5rpMc7ovprcR6eaL3s4cv3lZw3L/XHilTAj9iVqpZe/cyvO7x
	 EWy5ZmOwiI8Fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "chunzhi.lin" <linchunzhi0@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Sae@motor-comm.com,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] net: phy: motorcomm: use device properties for firmware tuning
Date: Mon, 31 Aug 2026 09:20:50 -0400
Message-ID: <20260831133314.4125787-22-sashal@kernel.org>
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

From: "chunzhi.lin" <linchunzhi0@gmail.com>

[ Upstream commit fffedfece2b46bb99b00740697f6c0c874de3cf4 ]

The Motorcomm PHY driver reads optional firmware properties via
of_property_read_*() from phydev->mdio.dev.of_node. This works for
Device Tree based systems, but causes ACPI platforms to ignore the same
properties when they are supplied through _DSD.

As a result, ACPI-described Motorcomm PHY devices fall back to default
settings instead of applying firmware-provided tuning such as
rx/tx internal delay, drive strength, clock output frequency, and
optional boolean controls like auto-sleep-disabled,
keep-pll-enabled, and tx clock inversion.

Switch these lookups to device_property_read_*() so the driver uses the
generic firmware node interface and can consume the same property names
from either Device Tree or ACPI.

This keeps the existing DT behavior unchanged while allowing ACPI
platforms to honor PHY configuration from firmware.

We have completed testing on Sophgo RISC-V architecture server SD3-10.
This server has a 64-core Thead C920 CPU whose DWMAC is connected to
Motorcomm's PHY YT8531. This server supports UEFI boot and it would like
to use the ACPI table.

Signed-off-by: chunzhi.lin <linchunzhi0@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260507040221.3679454-2-linchunzhi0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: phy: motorcomm: use device properties
for firmware tuning`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net: phy: motorcomm]` `[use]` — Switch Motorcomm PHY
firmware property lookups from Open Firmware–only APIs to the generic
device property interface so ACPI `_DSD` properties are honored.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | chunzhi.lin \<linchunzhi0@gmail.com\> (author) |
| Reviewed-by | Andrew Lunn \<andrew@lunn.ch\> (PHY maintainer) |
| Link |
https://patch.msgid.link/20260507040221.3679454-2-linchunzhi0@gmail.com
|
| Signed-off-by | Jakub Kicinski \<kuba@kernel.org\> (net maintainer
merge) |

**Notable patterns:** Maintainer review present. No `Fixes:`, `Reported-
by:`, `Cc: stable`, or syzbot tags (absence of stable tag is expected
per pipeline rules).

### Step 1.3: Body analysis
**Record:**
- **Bug:** Driver reads optional PHY tuning properties via
  `of_property_read_*()` on `phydev->mdio.dev.of_node`, which is NULL on
  ACPI systems; ACPI `_DSD` properties are never seen.
- **Symptom:** ACPI-described Motorcomm PHYs ignore firmware tuning
  (RGMII internal delays, drive strength, clock output frequency, auto-
  sleep, keep-PLL, TX clock inversion) and use driver defaults.
- **Failure mode:** Incorrect or missing PHY configuration; on ACPI
  platforms that depend on non-default tuning, Ethernet may fail to link
  or be unreliable.
- **Root cause:** OF-only property access instead of generic
  `device_property_*()` via `dev->fwnode`.
- **Testing:** Verified on Sophgo SD3-10 (64-core RISC-V, YT8531 PHY,
  UEFI/ACPI boot).
- **Version info:** None stated; ACPI impact is platform-specific.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although phrased as an interface switch, this is a
functional bug fix: firmware-provided board configuration is silently
dropped on ACPI, which can break networking on affected hardware.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/phy/motorcomm.c` only (~30 lines changed)
- **Scope:** Single-file, surgical mechanical replacement
- **Functions modified:**
  - `ytphy_get_delay_reg_value()`
  - `yt8531_set_ds()`
  - `yt8521_probe()` (removes unused `node`)
  - `yt8531_probe()`
  - `yt8521_config_init()`
  - `yt8531_config_init()`
  - `yt8531_link_change_notify()`
- **Include change:** `#include <linux/of.h>` → `#include
  <linux/property.h>`

### Step 2.2: Code flow per hunk
**Record:**
| Location | Before | After |
|----------|--------|-------|
| All property reads | `of_property_read_*(&phydev->mdio.dev.of_node,
...)` | `device_property_read_*(&phydev->mdio.dev, ...)` |
| DT systems | Reads from `of_node` | `dev_fwnode()` prefers `of_node`
when present — same source |
| ACPI systems | `of_node == NULL` → read fails → defaults |
`dev->fwnode` (ACPI `_DSD`) consulted → firmware values applied |

Affected paths: PHY probe and `config_init` during device bring-up;
`link_change_notify` on link/speed changes.

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic/correctness — firmware configuration
path bug.

On ACPI, `of_property_read_u32(NULL, ...)` returns `-EINVAL` (via
`of_find_property()` on NULL node), so optional properties are skipped
and defaults used. Properties supplied through ACPI `_DSD` are on
`dev->fwnode`, reachable only through `device_property_read_*()`.

Properties affected include `rx-internal-delay-ps`, `tx-internal-delay-
ps`, `motorcomm,clk-out-frequency-hz`, `motorcomm,rx-clk-drv-microamp`,
`motorcomm,rx-data-drv-microamp`, `motorcomm,auto-sleep-disabled`,
`motorcomm,keep-pll-enabled`, and TX clock inversion properties.

### Step 2.4: Fix quality
**Record:**
- **Correctness:** High — matches established PHY subsystem pattern
  (`adin.c`, `dp83822.c`, `nxp-c45-tja11xx.c`, `phy_device.c`).
- **Minimal:** Pure API substitution; no logic changes.
- **Regression risk:** Very low for DT (verified: `dev_fwnode()` returns
  OF fwnode when `of_node` is set).
- **Red flags:** None — no API changes, no refactoring, no cross-
  subsystem impact.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Changed lines in `ytphy_get_delay_reg_value()` trace to
`5d324e5159d9e` (v6.18 merge base, Nov 2025). All 13
`of_property_read_*` uses are present in current tree. Bug present since
property support was added to this driver revision.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:**
- `git log --oneline -- drivers/net/phy/motorcomm.c` shows 2 commits in
  this tree: merge base + `d441696397088` (LED duplex fix, Jan 2026).
- Candidate commit is **not** in this tree yet.
- Standalone one-patch fix; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Author chunzhi.lin has no other commits in this tree's
motorcomm history. Patch reviewed by Andrew Lunn (PHY maintainer).

### Step 3.5: Dependencies
**Record:** No dependencies. `device_property_read_*()` and
`<linux/property.h>` exist in 6.18. Patch applies cleanly as a
mechanical substitution. Self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c HEAD` matched an unrelated Qualcomm commit (wrong
target). Subject-based `b4 dig` returned empty. Link fetch to
patch.msgid.link and lore.kernel.org blocked by Anubis bot protection.
**Could not read mailing list thread.**

### Step 4.2: Reviewers
**Record:** Commit message includes `Reviewed-by: Andrew Lunn`. `b4 dig
-w` not usable without valid commitish in tree.

### Step 4.3: Bug report
**Record:** No external bug report linked. Author reports real-hardware
testing on Sophgo SD3-10 ACPI server.

### Step 4.4: Related patches
**Record:** No series indicated. Single patch.

### Step 4.5: Stable list history
**Record:** Lore search blocked. No stable-list discussion verified.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ytphy_get_delay_reg_value`, `yt8531_set_ds`,
`yt8521_probe`, `yt8531_probe`, `yt8521_config_init`,
`yt8531_config_init`, `yt8531_link_change_notify`.

### Step 5.2: Callers
**Record:**
- `yt8521_probe` / `yt8531_probe` — PHY driver `.probe` during MDIO
  enumeration
- `yt8521_config_init` / `yt8531_config_init` — `.config_init` during
  PHY initialization
- `ytphy_rgmii_clk_delay_config` → called from `config_init` paths
- `yt8531_link_change_notify` — `.link_change_notify` on link state
  changes
- All are standard PHY bring-up paths for YT8521/YT8531 hardware

### Step 5.3: Callees
**Record:** Property reads via `fwnode_property_read_*` through
`dev_fwnode()`; PHY register modify helpers unchanged.

### Step 5.4: Reachability
**Record:** Triggered during kernel boot / network interface bring-up on
systems with Motorcomm YT8521/YT8531 PHYs. ACPI path reachable on
UEFI/ACPI servers (e.g., Sophgo SD3-10). Not userspace-triggered, but
affects every boot on affected hardware.

### Step 5.5: Similar patterns
**Record:** Multiple PHY drivers in this tree already use
`device_property_read_*()` instead of `of_property_read_*()` on
`of_node`. `motorcomm.c` is inconsistent with subsystem practice.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Verified 13 `of_property_read_*` calls on
`phydev->mdio.dev.of_node` in `drivers/net/phy/motorcomm.c`. Zero
`device_property_read_*` calls. Fix not yet applied.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Mechanical replacement in one
file. No conflicting changes in recent motorcomm history. Only post-
merge change is unrelated LED duplex fix (`d441696397088`).

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. `git log --grep="device propert" --
drivers/net/phy/motorcomm.c` returns nothing.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/phy/` — **IMPORTANT** (network PHY driver).
Affects Ethernet connectivity on platforms using Motorcomm PHYs.

### Step 7.2: Subsystem activity
**Record:** Active — recent stable commits in PHY subsystem include
marvell, realtek, sfp, micrel fixes. Motorcomm driver is mature with
extensive property support documented in
`Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml`.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Platform-specific** — systems booting with ACPI (not DT)
that have Motorcomm YT8521/YT8531 PHYs with `_DSD` property tables.
Known case: Sophgo SD3-10 RISC-V server. DT-based systems are unaffected
(behavior unchanged).

### Step 8.2: Trigger conditions
**Record:**
- **Trigger:** Boot with ACPI firmware describing Motorcomm PHY
  properties via `_DSD`
- **Likelihood:** Uncommon globally, but deterministic on affected ACPI
  platforms
- **Unprivileged trigger:** No — hardware/platform configuration issue,
  not a syscall attack vector

### Step 8.3: Failure mode severity
**Record:**
- **Failure:** Wrong RGMII internal delays, drive strength, clock
  output, or power-management settings → link failure, unreliable
  Ethernet, or incorrect clock output to dependent hardware
- **Severity:** **HIGH** for affected ACPI platforms (complete loss of
  network functionality possible); **NONE** for DT platforms

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected ACPI hardware; enables firmware-
  intended PHY operation
- **Risk:** VERY LOW — small, reviewed, DT behavior preserved via
  `dev_fwnode()` semantics
- **Ratio:** Favorable for backport to this tree

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: ACPI `_DSD` properties unreachable via `of_node`
- Can break Ethernet on ACPI Motorcomm platforms (tested Sophgo server)
- Small, surgical, maintainer-reviewed fix
- Matches established PHY driver pattern in this tree
- Zero DT regression risk (verified `dev_fwnode()` behavior)
- Documented properties in `motorcomm,yt8xxx.yaml` should work on all
  firmware types
- Buggy code confirmed present in 6.18.43

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock
- Affects niche hardware population (ACPI + Motorcomm PHY)
- Properties are optional with documented defaults — some boards may
  work without fix
- Could be framed as ACPI enablement rather than universal bug fix
- Mailing list discussion not verified (lore blocked)

**Unresolved:** Full reviewer thread content; extent of other ACPI
Motorcomm deployments beyond Sophgo.

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard API, maintainer
reviewed, hardware tested |
| 2. Fixes real bug affecting users? | **PASS** — ACPI firmware config
silently ignored |
| 3. Important issue? | **PASS** — network failure on affected ACPI
servers (HIGH for those users) |
| 4. Small and contained? | **PASS** — one file, ~30 lines |
| 5. No new features/APIs? | **PASS** — same property names, same
behavior on DT |
| 6. Can apply to local tree? | **PASS** — buggy code present, clean
apply expected |

### Step 9.3: Exception categories
**Record:** Closest match: **hardware workaround / platform
configuration fix** — firmware-provided PHY tuning (RGMII delays, drive
strength) is board-specific configuration analogous to documented
quirk/workaround fixes accepted in stable.

### Step 9.4: Decision rationale
For **Linux 6.18.43**, the Motorcomm PHY driver with full property
support is present and uses OF-only property reads that definitively
fail on ACPI (`of_node == NULL`). This prevents firmware from supplying
board-critical RGMII timing and electrical tuning, which can render
Ethernet non-functional on ACPI platforms such as the tested Sophgo
server. The fix is minimal, maintainer-reviewed, follows existing PHY
subsystem conventions, and poses negligible regression risk to DT users.
While the affected population is smaller than a core-kernel crash fix,
the functional impact on those platforms is severe (no networking),
meeting stable criteria for an important hardware-configuration bug.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed Reviewed-by: Andrew Lunn; no Fixes:/Reported-
  by:/Cc: stable
- **[Phase 2]** Diff analysis: 13 `of_property_read_*` →
  `device_property_read_*` in 7 functions, one file
- **[Phase 2]** Verified include swap: `linux/of.h` → `linux/property.h`
- **[Phase 3]** `git describe HEAD`: v6.18.43-1-gc7f0dac02d232; Makefile
  VERSION=6 PATCHLEVEL=18 SUBLEVEL=43
- **[Phase 3]** `git blame -L 845,855`: buggy lines from 5d324e5159d9e
- **[Phase 3]** `git log --oneline -- drivers/net/phy/motorcomm.c`: 2
  commits; fix not present
- **[Phase 3]** `git log -S 'of_property_read_u32' --
  drivers/net/phy/motorcomm.c`: present since merge base
- **[Phase 4]** `b4 dig -c HEAD`: returned unrelated Qualcomm URL (no
  valid commitish in tree)
- **[Phase 4]** `b4 dig` by subject: empty result
- **[Phase 4]** WebFetch patch.msgid.link and lore.kernel.org: blocked
  by Anubis — **UNVERIFIED** mailing list discussion
- **[Phase 5]** `grep of_property_read_ drivers/net/phy/motorcomm.c`: 13
  matches confirmed
- **[Phase 5]** `grep device_property_read_
  drivers/net/phy/motorcomm.c`: 0 matches (fix absent)
- **[Phase 5]** `grep device_property_read_ drivers/net/phy/`: 10 other
  PHY files use same pattern
- **[Phase 5]** Read `drivers/base/property.c`:
  `device_property_read_u32` →
  `fwnode_property_read_u32(dev_fwnode(dev), ...)`
- **[Phase 5]** Read `dev_fwnode()`: prefers `of_node` when CONFIG_OF
  and of_node set; else `dev->fwnode`
- **[Phase 5]** Read `of_find_property_value_of_size()`: NULL np →
  `-EINVAL`
- **[Phase 5]** Traced PHY driver ops table:
  probe/config_init/link_change_notify on YT8521/YT8531
- **[Phase 6]** Confirmed buggy code exists in local tree at lines 851,
  1000, 1017, 1100, 1172, 1679, 1687, 1807, 1816, 1851, 1857, 1859, 1861
- **[Phase 6]** Read
  `Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml`:
  documents all affected properties with defaults
- **[Phase 6]** `git log --grep` for related fix in motorcomm.c: none
  found
- **[Phase 8]** Failure mode: ACPI property ignore → wrong PHY config →
  potential link failure; severity HIGH for affected platforms

**YES**

 drivers/net/phy/motorcomm.c | 41 ++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index b49897500a592..b76011b227c46 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -10,7 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
-#include <linux/of.h>
+#include <linux/property.h>
 
 #define PHY_ID_YT8511		0x0000010a
 #define PHY_ID_YT8521		0x0000011a
@@ -843,12 +843,12 @@ static u32 ytphy_get_delay_reg_value(struct phy_device *phydev,
 				     u16 *rxc_dly_en,
 				     u32 dflt)
 {
-	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device *dev = &phydev->mdio.dev;
 	int tb_size_half = tb_size / 2;
 	u32 val;
 	int i;
 
-	if (of_property_read_u32(node, prop_name, &val))
+	if (device_property_read_u32(dev, prop_name, &val))
 		goto err_dts_val;
 
 	/* when rxc_dly_en is NULL, it is get the delay for tx, only half of
@@ -992,12 +992,12 @@ static int yt8531_get_ds_map(struct phy_device *phydev, u32 cur)
 
 static int yt8531_set_ds(struct phy_device *phydev)
 {
-	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device *dev = &phydev->mdio.dev;
 	u32 ds_field_low, ds_field_hi, val;
 	int ret, ds;
 
 	/* set rgmii rx clk driver strength */
-	if (!of_property_read_u32(node, "motorcomm,rx-clk-drv-microamp", &val)) {
+	if (!device_property_read_u32(dev, "motorcomm,rx-clk-drv-microamp", &val)) {
 		ds = yt8531_get_ds_map(phydev, val);
 		if (ds < 0)
 			return dev_err_probe(&phydev->mdio.dev, ds,
@@ -1014,7 +1014,7 @@ static int yt8531_set_ds(struct phy_device *phydev)
 		return ret;
 
 	/* set rgmii rx data driver strength */
-	if (!of_property_read_u32(node, "motorcomm,rx-data-drv-microamp", &val)) {
+	if (!device_property_read_u32(dev, "motorcomm,rx-data-drv-microamp", &val)) {
 		ds = yt8531_get_ds_map(phydev, val);
 		if (ds < 0)
 			return dev_err_probe(&phydev->mdio.dev, ds,
@@ -1047,7 +1047,6 @@ static int yt8531_set_ds(struct phy_device *phydev)
  */
 static int yt8521_probe(struct phy_device *phydev)
 {
-	struct device_node *node = phydev->mdio.dev.of_node;
 	struct device *dev = &phydev->mdio.dev;
 	struct yt8521_priv *priv;
 	int chip_config;
@@ -1097,7 +1096,7 @@ static int yt8521_probe(struct phy_device *phydev)
 			return ret;
 	}
 
-	if (of_property_read_u32(node, "motorcomm,clk-out-frequency-hz", &freq))
+	if (device_property_read_u32(dev, "motorcomm,clk-out-frequency-hz", &freq))
 		freq = YTPHY_DTS_OUTPUT_CLK_DIS;
 
 	if (phydev->drv->phy_id == PHY_ID_YT8521) {
@@ -1165,11 +1164,11 @@ static int yt8521_probe(struct phy_device *phydev)
 
 static int yt8531_probe(struct phy_device *phydev)
 {
-	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device *dev = &phydev->mdio.dev;
 	u16 mask, val;
 	u32 freq;
 
-	if (of_property_read_u32(node, "motorcomm,clk-out-frequency-hz", &freq))
+	if (device_property_read_u32(dev, "motorcomm,clk-out-frequency-hz", &freq))
 		freq = YTPHY_DTS_OUTPUT_CLK_DIS;
 
 	switch (freq) {
@@ -1661,7 +1660,7 @@ static int yt8521_resume(struct phy_device *phydev)
  */
 static int yt8521_config_init(struct phy_device *phydev)
 {
-	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device *dev = &phydev->mdio.dev;
 	int old_page;
 	int ret = 0;
 
@@ -1676,7 +1675,7 @@ static int yt8521_config_init(struct phy_device *phydev)
 			goto err_restore_page;
 	}
 
-	if (of_property_read_bool(node, "motorcomm,auto-sleep-disabled")) {
+	if (device_property_read_bool(dev, "motorcomm,auto-sleep-disabled")) {
 		/* disable auto sleep */
 		ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
 				       YT8521_ESC1R_SLEEP_SW, 0);
@@ -1684,7 +1683,7 @@ static int yt8521_config_init(struct phy_device *phydev)
 			goto err_restore_page;
 	}
 
-	if (of_property_read_bool(node, "motorcomm,keep-pll-enabled")) {
+	if (device_property_read_bool(dev, "motorcomm,keep-pll-enabled")) {
 		/* enable RXC clock when no wire plug */
 		ret = ytphy_modify_ext(phydev, YT8521_CLOCK_GATING_REG,
 				       YT8521_CGR_RX_CLK_EN, 0);
@@ -1797,14 +1796,14 @@ static int yt8521_led_hw_control_get(struct phy_device *phydev, u8 index,
 
 static int yt8531_config_init(struct phy_device *phydev)
 {
-	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device *dev = &phydev->mdio.dev;
 	int ret;
 
 	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
 	if (ret < 0)
 		return ret;
 
-	if (of_property_read_bool(node, "motorcomm,auto-sleep-disabled")) {
+	if (device_property_read_bool(dev, "motorcomm,auto-sleep-disabled")) {
 		/* disable auto sleep */
 		ret = ytphy_modify_ext_with_lock(phydev,
 						 YT8521_EXTREG_SLEEP_CONTROL1_REG,
@@ -1813,7 +1812,7 @@ static int yt8531_config_init(struct phy_device *phydev)
 			return ret;
 	}
 
-	if (of_property_read_bool(node, "motorcomm,keep-pll-enabled")) {
+	if (device_property_read_bool(dev, "motorcomm,keep-pll-enabled")) {
 		/* enable RXC clock when no wire plug */
 		ret = ytphy_modify_ext_with_lock(phydev,
 						 YT8521_CLOCK_GATING_REG,
@@ -1840,7 +1839,7 @@ static int yt8531_config_init(struct phy_device *phydev)
  */
 static void yt8531_link_change_notify(struct phy_device *phydev)
 {
-	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device *dev = &phydev->mdio.dev;
 	bool tx_clk_1000_inverted = false;
 	bool tx_clk_100_inverted = false;
 	bool tx_clk_10_inverted = false;
@@ -1848,17 +1847,17 @@ static void yt8531_link_change_notify(struct phy_device *phydev)
 	u16 val = 0;
 	int ret;
 
-	if (of_property_read_bool(node, "motorcomm,tx-clk-adj-enabled"))
+	if (device_property_read_bool(dev, "motorcomm,tx-clk-adj-enabled"))
 		tx_clk_adj_enabled = true;
 
 	if (!tx_clk_adj_enabled)
 		return;
 
-	if (of_property_read_bool(node, "motorcomm,tx-clk-10-inverted"))
+	if (device_property_read_bool(dev, "motorcomm,tx-clk-10-inverted"))
 		tx_clk_10_inverted = true;
-	if (of_property_read_bool(node, "motorcomm,tx-clk-100-inverted"))
+	if (device_property_read_bool(dev, "motorcomm,tx-clk-100-inverted"))
 		tx_clk_100_inverted = true;
-	if (of_property_read_bool(node, "motorcomm,tx-clk-1000-inverted"))
+	if (device_property_read_bool(dev, "motorcomm,tx-clk-1000-inverted"))
 		tx_clk_1000_inverted = true;
 
 	if (phydev->speed < 0)
-- 
2.53.0

