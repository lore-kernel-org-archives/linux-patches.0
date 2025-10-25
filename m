Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7069305053;
	Sat, 25 Oct 2025 16:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409636; cv=none; b=RvYjgCa+gIkLrOfsnAQpKuv3Tg9CuHieVaxuvUrSRPTj1lO8oOcQcg3gZE7UYnE26MfXzmGVm11S+c4Zvce66lY6GpX1iX6dGYS8FfBOfBzj51D1KSOmFn45PwTxUbhTvRx6gtFc6Vn9l19Q1z97vr/IAsX1lRJaylBDvcGvsoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409636; c=relaxed/simple;
	bh=tm0Mdd7IQZCUXGPh6rBlD8ChZvnNbKC3q4hohYCI1UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tp51uKE80IImP4q+wkZZ7KiDB5447CJE3iFdcBWQqUI9Dua5O1fDbJfsxWckkN6dq6eFqn4rj732ZsFO4kwxfNKMnYCVx/DDYS7CpCB598Btd0JgSbVNZK9lergtJwxCMZJ2orK3P7i8kRcZPaXrNyvXNHMu6BNtub9SuclOXfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DuU1pnXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DuU1pnXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D50C4CEF5;
	Sat, 25 Oct 2025 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409636;
	bh=tm0Mdd7IQZCUXGPh6rBlD8ChZvnNbKC3q4hohYCI1UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuU1pnXn2sslsgsJLsQsWrMe88tkTlqACmIix22aHqIHga5q7hKOZezmgzUjJsagC
	 VIgJjhuAE+V/ZhNYHfX5RDwkiOpQIOpJI0mmTDsekIh4awu/Fmbimi09h5LjXEuAaq
	 CI7Oodp7gzMF20ORvdFgHCkBcmpILstXdD932NcEWn2TU7YFrqnIFq1rT+xih+WrVJ
	 ore0wyT0lbGgLw6+ZX5Hza1Ffc7cjE6XY9pLjVNdSbyPXgXZ7+UCUmnFpJwjD208Hf
	 so6wj7RjTVnEHt0rmyZi91228geju4zb1UDsWA5Su2EsKD8lxDWEPfMbI7MI6WkRf7
	 QOGeUpr/ID8Eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	vadim.fedorenko@linux.dev,
	horatiu.vultur@microchip.com,
	alexandre.f.demers@gmail.com,
	andrew@lunn.ch,
	rosenp@gmail.com,
	hkallweit1@gmail.com,
	christophe.jaillet@wanadoo.fr
Subject: [PATCH AUTOSEL 6.17] net: phy: mscc: report and configure in-band auto-negotiation for SGMII/QSGMII
Date: Sat, 25 Oct 2025 12:00:30 -0400
Message-ID: <20251025160905.3857885-399-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit df979273bd716a93ca9ffa8f84aeb205c9bf2ab6 ]

The following Vitesse/Microsemi/Microchip PHYs, among those supported by
this driver, have the host interface configurable as SGMII or QSGMII:
- VSC8504
- VSC8514
- VSC8552
- VSC8562
- VSC8572
- VSC8574
- VSC8575
- VSC8582
- VSC8584

All these PHYs are documented to have bit 7 of "MAC SerDes PCS Control"
as "MAC SerDes ANEG enable".

Out of these, I could test the VSC8514 quad PHY in QSGMII. This works
both with the in-band autoneg on and off, on the NXP LS1028A-RDB and
T1040-RDB boards.

Notably, the bit is sticky (survives soft resets), so giving Linux the
tools to read and modify this settings makes it robust to changes made
to it by previous boot layers (U-Boot).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250813074454.63224-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Ensures Linux can explicitly read/configure the PHY-side in-band
    autonegotiation state for SGMII/QSGMII links on MSCC/Microchip PHYs,
    avoiding mismatches with MAC-side PCS configuration and bootloader
    “sticky” settings. Without this, phylink may configure in-band usage
    on the MAC/PCS side but the PHY side can remain in an incompatible
    state, causing link bring-up problems or incorrect link reporting
    after soft resets.
  - The commit message notes the “MAC SerDes ANEG enable” bit is sticky
    across soft resets, and adds the knobs Linux needs to set it
    predictably, which is a practical bugfix in real deployments.

- Scope and change details
  - New register definitions for the PHY SerDes PCS control:
    - Adds `MSCC_PHY_SERDES_PCS_CTRL` and `MSCC_PHY_SERDES_ANEG` under
      “Extended Page 3 Registers” in `drivers/net/phy/mscc/mscc.h` (near
      the other Extended Page 3 counters, e.g.,
      `MSCC_PHY_SERDES_TX_VALID_CNT`; see
      drivers/net/phy/mscc/mscc.h:132 for the page constant already used
      in-tree).
  - Adds PHY driver hooks to surface capability and perform the
    configuration:
    - `vsc85xx_inband_caps()` advertises that in SGMII/QSGMII modes, the
      PHY supports both disabling and enabling in-band signalling
      (returns `LINK_INBAND_DISABLE | LINK_INBAND_ENABLE`). Inserted
      next to the AN state helpers (commit context shows around
      drivers/net/phy/mscc/mscc_main.c:2185).
    - `vsc85xx_config_inband()` programs the PHY SerDes PCS Control bit
      via a paged write on Extended Page 3, reg 16, bit 7:
      `phy_modify_paged(…, MSCC_PHY_PAGE_EXTENDED_3,
      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG, reg_val)`. This
      sets or clears “MAC SerDes ANEG enable” in one place with minimal
      risk (drivers/net/phy/mscc/mscc_main.c:2185).
  - Wires these into the `struct phy_driver` entries for the
    SGMII/QSGMII-capable parts (VSC8504, VSC8514, VSC8552, VSC856X,
    VSC8572/74/75, VSC8582/84) by adding `.inband_caps =
    vsc85xx_inband_caps` and `.config_inband = vsc85xx_config_inband`
    (see the vsc85xx driver array entries around
    drivers/net/phy/mscc/mscc_main.c:2394, :2419, :2538, :2562, :2584,
    :2610, :2636, :2660, :2684). Non‑SGMII/QSGMII parts remain
    unchanged.

- Fits existing core APIs and policies
  - Integrates with the in-band signalling negotiation framework already
    in stable: `phy_inband_caps()` and `phy_config_inband()`
    (include/linux/phy.h:957, include/linux/phy.h:967;
    drivers/net/phy/phy.c:1046, drivers/net/phy/phy.c:1066).
  - phylink consults PHY/PCS in-band capabilities and configures them
    during major reconfig: `phylink_pcs_neg_mode()` resolves the desired
    mode and then calls `phy_config_inband()` when needed
    (drivers/net/phy/phylink.c:1098, drivers/net/phy/phylink.c:1331).
    Without PHY support, phylink can’t force the PHY-side mode; with
    this commit it can, eliminating bootloader-induced mismatches.
  - Precedent: other PHYs already implement these hooks (e.g., Marvell’s
    m88e1111: drivers/net/phy/marvell.c:720 and
    drivers/net/phy/marvell.c:734), so this is an incremental, driver-
    local completion for MSCC parts.

- Risk assessment
  - Small and contained: one new register define and a single-bit write
    on a well-documented PHY register; driver tables updated to expose
    the capability/config callbacks only on models with SGMII/QSGMII
    host interfaces.
  - No architectural changes or user-visible API changes.
  - Only affects configurations where phylink selects in-band/out-of-
    band; otherwise inert.
  - Clear positive functional impact: makes link mode negotiation robust
    across soft resets and boot-loader configurations.

- Backport considerations
  - Depends on the in-band signalling framework added in late 2024
    (phy_inband_caps/config_inband and phylink negotiation of in-band).
    This is present in this stable series (e.g., 6.17; see
    drivers/net/phy/phylink.c:1098, include/linux/phy.h:957).
  - For older stable trees lacking these core hooks, this patch does not
    apply cleanly and would require backporting that infrastructure
    first.

Conclusion: This is an important, low-risk correctness fix enabling
Linux to control the PHY-side in-band AN state for MSCC SGMII/QSGMII
PHYs, aligning with existing phylink behavior and preventing subtle link
issues caused by sticky bootloader settings. It is suitable for
backporting to stable kernels that already include the in-band
negotiation framework.

 drivers/net/phy/mscc/mscc.h      |  3 +++
 drivers/net/phy/mscc/mscc_main.c | 40 ++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 2bfe314ef881c..2d8eca54c40a2 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -196,6 +196,9 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_PCS_CTRL	  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
+
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 24c75903f5354..ef0ef1570d392 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2202,6 +2202,28 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static unsigned int vsc85xx_inband_caps(struct phy_device *phydev,
+					phy_interface_t interface)
+{
+	if (interface != PHY_INTERFACE_MODE_SGMII &&
+	    interface != PHY_INTERFACE_MODE_QSGMII)
+		return 0;
+
+	return LINK_INBAND_DISABLE | LINK_INBAND_ENABLE;
+}
+
+static int vsc85xx_config_inband(struct phy_device *phydev, unsigned int modes)
+{
+	u16 reg_val = 0;
+
+	if (modes == LINK_INBAND_ENABLE)
+		reg_val = MSCC_PHY_SERDES_ANEG;
+
+	return phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
+				MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
+				reg_val);
+}
+
 static int vsc8514_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2414,6 +2436,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8514,
@@ -2437,6 +2461,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8530,
@@ -2557,6 +2583,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC856X,
@@ -2579,6 +2607,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8572,
@@ -2605,6 +2635,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8574,
@@ -2631,6 +2663,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8575,
@@ -2655,6 +2689,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8582,
@@ -2679,6 +2715,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8584,
@@ -2704,6 +2742,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
 	.link_change_notify = &vsc85xx_link_change_notify,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 }
 
 };
-- 
2.51.0

