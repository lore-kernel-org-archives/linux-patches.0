Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434393EC2FC;
	Mon, 20 Apr 2026 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691512; cv=none; b=KT4ZxXhcwdLyrD+//4PtXME0k3dgRG/gBfiHJVHb6D5kgL3AX7ywH8CW3eikZBoN9CYCRQ/Xtd1ixT0Qj/vSqzF7ddPVo7OeyNMkZLQ8tex+fiHebYqUanKxFeVbxXFWXBklzXJpyEyykMUTIUMbhqOxye84PyLBVb7oKAa5R5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691512; c=relaxed/simple;
	bh=RJBmDKkGRFqbpmS57CnARzcMy+oYZRfEn69JCVkwEW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szKlLwhWCp5YiewaWtakd7mMV6udHdjawx9gwK0sSz+jFb39aTWU6/8qLv06wmTeGCVmJLF4dqTRP5TwDdUtnKVTvO6Is9DdfCzBDlvpaFdpPI7kPOVXsxHmNYIbU+7vRA7uPXt/pjS+fItMmDoqK2oLMe0RxKW64DA4fNxLLJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrtWnGtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrtWnGtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3805EC2BCB6;
	Mon, 20 Apr 2026 13:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691512;
	bh=RJBmDKkGRFqbpmS57CnARzcMy+oYZRfEn69JCVkwEW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrtWnGtHK1GRlYckLjCylmkrBoGpBeMwk/fa0SjYqGAua2BLg+E8owI6V5ykFAl6L
	 qtaw7aociuEpi2ZLjlGNxvvOe2ZGSFc4ZmUGL7W7R7oJqvNLO6RUOUVC8v4XcZVBp6
	 11j4HgS/PbXj6NptVmdlMC8Rl2bCX3ln5Bx+oRJcD40PeTAONobp3GuBX1bTnr2O9t
	 1weTkF97Lqe50JH64QRoqYhJJxl1b8heBibBZzBVauAtik5qZ2SOzALXPBwPzgAkCb
	 9zR8VqH9aho2y1taHYuo87BCK6QsTYjWuaMI03nN3iduGbSrflksVY8LwvENCC+O20
	 jRUL8Eo4IbDUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bryan.whitehead@microchip.com,
	UNGLinuxDriver@microchip.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] net: lan743x: fix SGMII detection on PCI1xxxx B0+ during warm reset
Date: Mon, 20 Apr 2026 09:17:47 -0400
Message-ID: <20260420132314.1023554-73-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

[ Upstream commit e783e40fb689381caca31e03d28c39e10c82e722 ]

A warm reset on boards using an EEPROM-only strap configuration (where
no MAC address is set in the image) can cause the driver to incorrectly
revert to RGMII mode. This occurs because the ENET_CONFIG_LOAD_STARTED
bit may not persist or behave as expected.

Update pci11x1x_strap_get_status() to use revision-specific validation:

- For PCI11x1x A0: Continue using the legacy check (config load started
  or reset protection) to validate the SGMII strap.
- For PCI11x1x B0 and later: Use the newly available
  STRAP_READ_USE_SGMII_EN_ bit in the upper strap register to validate
  the lower SGMII_EN bit.

This ensures the SGMII interface is correctly identified even after a
warm reboot.

Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Link: https://patch.msgid.link/20260318063228.17110-1-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [net: lan743x] [fix] SGMII detection on PCI1xxxx B0+ during warm
reset. The verb "fix" directly indicates a bug fix.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by**: Thangaraj Samynathan (Microchip employee - device
  vendor)
- **Link**: https://patch.msgid.link/20260318063228.17110-1-
  thangaraj.s@microchip.com
- **Signed-off-by**: Jakub Kicinski (netdev maintainer - accepted the
  patch)
- No Fixes: tag (expected for candidates under review)
- No Cc: stable tag (expected)
- No Reported-by tag

Record: Patch from the device vendor (Microchip), accepted by the netdev
maintainer. No explicit stable nomination.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes a concrete bug: warm reset on boards with EEPROM-
only strap config (no MAC in image) causes incorrect revert to RGMII
mode. The root cause is that the `ENET_CONFIG_LOAD_STARTED` bit may not
persist. The fix uses revision-specific validation: A0 keeps legacy
check, B0+ uses `STRAP_READ_USE_SGMII_EN_` bit.

Record: Bug = SGMII interface misdetected as RGMII after warm reset.
Symptom = network interface uses wrong PHY mode. Root cause = config
load register bit doesn't persist across warm reset on B0+ with specific
strap configuration.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is an explicit bug fix, not disguised.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- `lan743x_main.c`: +13/-4 lines
- `lan743x_main.h`: +1/-0 lines
- New helper function: `pci11x1x_is_a0()` (4 lines)
- Modified function: `pci11x1x_strap_get_status()`
- New define: `ID_REV_CHIP_REV_PCI11X1X_A0_`
- Scope: single-file surgical fix in a single driver

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Before**: The condition checked `cfg_load &
GEN_SYS_LOAD_STARTED_REG_ETH_ || hw_cfg & HW_CFG_RST_PROTECT_`. If
either was set, it read the strap register and checked
`STRAP_READ_SGMII_EN_`. Otherwise, it fell through to FPGA check, which
for non-FPGA boards would set `is_sgmii_en = false`.

**After**: The condition now branches by revision:
- A0: Same legacy check (config load or reset protect)
- B0+: Checks `STRAP_READ_USE_SGMII_EN_` bit directly (the upper strap
  register bit)
- Also, `strap = lan743x_csr_read()` is moved outside the conditional
  (unconditionally read)

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: Logic/correctness fix. The hardware register
(`ENET_CONFIG_LOAD_STARTED`) doesn't reliably persist on B0+ after warm
reset in EEPROM-only configurations. This causes the conditional to
fail, and the code falls through to the FPGA path which sets
`is_sgmii_en = false`, making the driver use RGMII mode incorrectly.

### Step 2.4: ASSESS THE FIX QUALITY
The fix is obviously correct: it restores the original check method
(`STRAP_READ_USE_SGMII_EN_`) for B0+ hardware while preserving legacy
behavior for A0. The new `pci11x1x_is_a0()` helper is trivial. Very low
regression risk - A0 behavior unchanged, B0+ gets a more reliable
detection method.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
Verified via `git blame`: The buggy conditional (lines 51-52) was
introduced by `46b777ad9a8c26` ("net: lan743x: Add support to SGMII 1G
and 2.5G", Jun 2022). The original code in `a46d9d37c4f4fa` (Feb 2022)
checked `STRAP_READ_USE_SGMII_EN_` directly, which was the correct
approach for B0+.

Record: Bug introduced by `46b777ad9a8c26` (v5.19/v6.0). Original
working code was in `a46d9d37c4f4fa` (v5.18).

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag, but the bug was clearly introduced by `46b777ad9a8c26`.
This commit exists in stable trees v6.0+.

### Step 3.3: CHECK FILE HISTORY
The file has active development. The author (Thangaraj Samynathan) is a
Microchip employee and a regular contributor to the lan743x driver with
10+ commits.

### Step 3.4: AUTHOR CONTEXT
The author works at Microchip (the hardware vendor). They have deep
knowledge of this hardware.

### Step 3.5: DEPENDENCIES
The fix adds `ID_REV_CHIP_REV_PCI11X1X_A0_` define. The only nearby
dependency is `ID_REV_CHIP_REV_PCI11X1X_B0_` (added in `e4a58989f5c839`,
v6.10). For stable trees 6.1-6.9, the patch context would differ
slightly and need minor adaptation. For 6.12+, it should apply cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
Found via `b4 am`: The patch was submitted as "[PATCH v1]" and had 2
messages in the thread. The v0->v1 changelog shows: "Added helpers to
check if the device revision is a0". This was a single-patch submission
(not part of a series).

### Step 4.2: REVIEWER CONTEXT
The patch was accepted by Jakub Kicinski (netdev maintainer) directly.

### Step 4.3-4.5: BUG REPORT / STABLE DISCUSSION
No public bug report linked. The fix comes directly from the hardware
vendor, suggesting it was found during internal testing.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: FUNCTION ANALYSIS
`pci11x1x_strap_get_status()` is called from `lan743x_hardware_init()`
(line 3506), which is the main hardware initialization path. It's called
once during device probe and determines whether SGMII or RGMII mode is
used.

### Step 5.3-5.4: IMPACT CHAIN
`is_sgmii_en` controls:
1. SGMII_CTL register configuration (lines 3511-3518) - enables/disables
   SGMII
2. PHY interface mode selection (line 1357-1358) -
   `PHY_INTERFACE_MODE_SGMII` vs `RGMII`
3. MDIO bus configuration (lines 3576-3595) - C45 vs C22 access

If `is_sgmii_en` is incorrectly set to `false` on SGMII hardware, the
network interface will not work.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE TREES
The buggy code from `46b777ad9a8c26` exists in all stable trees from
v6.1+. The `ID_REV_CHIP_REV_PCI11X1X_B0_` prerequisite is in v6.10+, so
for 6.12+ the patch applies cleanly.

### Step 6.2: BACKPORT COMPLICATIONS
For 6.12+: should apply cleanly. For 6.1-6.9: minor context adjustment
needed (the `B0_` define line won't be present).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
Subsystem: Network driver (Ethernet) - IMPORTANT. The lan743x driver
supports Microchip PCI11010/PCI11414 Ethernet controllers used in
embedded and desktop systems.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: AFFECTED USERS
Users with PCI1xxxx B0+ hardware using EEPROM-only strap configuration
(no MAC in image) who perform warm resets.

### Step 8.2: TRIGGER CONDITIONS
Warm reset on affected hardware. This is a normal, common operation.

### Step 8.3: FAILURE MODE SEVERITY
Network interface uses wrong PHY mode -> network doesn't work after warm
reboot. Severity: HIGH (complete loss of network connectivity).

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit**: HIGH - fixes complete network failure on warm reset for
  affected hardware
- **Risk**: VERY LOW - 13 lines added, surgical fix, chip revision-based
  branching, no behavioral change for A0

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION

**FOR backporting**:
- Fixes a real hardware bug: network failure after warm reset
- From the device vendor (Microchip) with deep hardware knowledge
- Small and surgical: ~16 lines total change
- Accepted by netdev maintainer
- Very low regression risk: preserves A0 behavior, fixes B0+ detection
- Buggy code exists in stable trees 6.1+
- Restores original proven detection method for B0+

**AGAINST backporting**:
- No Fixes: tag (expected)
- No explicit stable nomination
- Adds new defines (but these are trivial hardware register constants)
- Minor context conflict possible in older stable trees

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - from hardware vendor,
   accepted by maintainer
2. Fixes a real bug? **YES** - SGMII misdetection causes network failure
3. Important issue? **YES** - complete loss of network connectivity
4. Small and contained? **YES** - ~16 lines, 2 files, single function
5. No new features or APIs? **YES** - this is a bug fix, no new
   functionality
6. Can apply to stable trees? **YES** for 6.12+; needs minor adaptation
   for 6.1-6.9

### Step 9.3: EXCEPTION CATEGORIES
This is a hardware workaround (chip revision-specific fix) which is an
accepted stable category.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from Microchip (vendor), accepted
  by Jakub Kicinski (netdev maintainer)
- [Phase 2] Diff analysis: +13/-4 in .c, +1 in .h; adds
  `pci11x1x_is_a0()` helper and revision-based conditional branching
- [Phase 3] git blame: buggy conditional introduced by `46b777ad9a8c26`
  (v5.19/v6.0, Jun 2022)
- [Phase 3] git show `a46d9d37c4f4fa`: confirmed original code checked
  `STRAP_READ_USE_SGMII_EN_` directly (the correct method for B0+)
- [Phase 3] git show `46b777ad9a8c26`: confirmed this commit replaced
  the direct check with `cfg_load`/`hw_cfg` check, introducing the
  regression
- [Phase 3] git tag: buggy code exists in v6.0+; prerequisite
  `PCI11X1X_B0_` define exists in v6.10+
- [Phase 4] b4 am: found original submission, v1 single patch, 2
  messages in thread
- [Phase 4] mbox read: changelog shows v0->v1 added the is_a0 helper
  (review feedback addressed)
- [Phase 5] Grep callers: `pci11x1x_strap_get_status()` called from
  `lan743x_hardware_init()` (line 3506)
- [Phase 5] Grep `is_sgmii_en`: controls PHY interface mode (line 1357),
  SGMII_CTL register (line 3511), MDIO bus setup (line 3576)
- [Phase 6] Code exists in stable trees v6.1+; clean apply expected for
  v6.12+
- [Phase 8] Failure mode: wrong PHY mode -> network failure; severity
  HIGH

**YES**

 drivers/net/ethernet/microchip/lan743x_main.c | 15 +++++++++++----
 drivers/net/ethernet/microchip/lan743x_main.h |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f0b5dd752f084..b4cabde6625a2 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -28,6 +28,12 @@
 
 #define RFE_RD_FIFO_TH_3_DWORDS	0x3
 
+static bool pci11x1x_is_a0(struct lan743x_adapter *adapter)
+{
+	u32 dev_rev = adapter->csr.id_rev & ID_REV_CHIP_REV_MASK_;
+	return dev_rev == ID_REV_CHIP_REV_PCI11X1X_A0_;
+}
+
 static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 {
 	u32 chip_rev;
@@ -47,10 +53,11 @@ static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 	cfg_load = lan743x_csr_read(adapter, ETH_SYS_CONFIG_LOAD_STARTED_REG);
 	lan743x_hs_syslock_release(adapter);
 	hw_cfg = lan743x_csr_read(adapter, HW_CFG);
-
-	if (cfg_load & GEN_SYS_LOAD_STARTED_REG_ETH_ ||
-	    hw_cfg & HW_CFG_RST_PROTECT_) {
-		strap = lan743x_csr_read(adapter, STRAP_READ);
+	strap = lan743x_csr_read(adapter, STRAP_READ);
+	if ((pci11x1x_is_a0(adapter) &&
+	     (cfg_load & GEN_SYS_LOAD_STARTED_REG_ETH_ ||
+	      hw_cfg & HW_CFG_RST_PROTECT_)) ||
+	    (strap & STRAP_READ_USE_SGMII_EN_)) {
 		if (strap & STRAP_READ_SGMII_EN_)
 			adapter->is_sgmii_en = true;
 		else
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 02a28b7091630..160d94a7cee66 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -27,6 +27,7 @@
 #define ID_REV_CHIP_REV_MASK_		(0x0000FFFF)
 #define ID_REV_CHIP_REV_A0_		(0x00000000)
 #define ID_REV_CHIP_REV_B0_		(0x00000010)
+#define ID_REV_CHIP_REV_PCI11X1X_A0_	(0x000000A0)
 #define ID_REV_CHIP_REV_PCI11X1X_B0_	(0x000000B0)
 
 #define FPGA_REV			(0x04)
-- 
2.53.0

