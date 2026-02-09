Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5527A37BE78;
	Mon,  9 Feb 2026 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647991; cv=none; b=pzxbjRVbCooUCscCMRTYLCDtx2e1bsH5aHcmu4I6x+mLiCQcpNq2/yuT6akG/TLTS7yBIeLZqvgnYlCm30mdEVQgEtfpmXybP8PGwaLZ4s+p1vgAuWloXxzzpWvUlpZUq5sAWZ8v3KswYKu/SzJiEmT7SzpFRl0ue36m6tlG1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647991; c=relaxed/simple;
	bh=i6YmMTtEuMXC31lHJY+Mlh30k2n/KZ7DiLO5b94+pxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiHijfCjcEZZN3VHVPJfDp3M9hnU4htP1LMejkduANoDgkcQGygPMpq9Kr3GX9+LQkwv2cOuBU6a2fCbdyvtzo0Q5AWBLj9xIDtK3NDpjmrwETU6aVrLHPpcuKkITolkxpUy0UkF2Qs/dtU1oKGW9pnTajzjQQAZkRRwCEDxhYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bu/8GKEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bu/8GKEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A85C116C6;
	Mon,  9 Feb 2026 14:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647991;
	bh=i6YmMTtEuMXC31lHJY+Mlh30k2n/KZ7DiLO5b94+pxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bu/8GKEQFKBabZrxkfLksZRcSUiOlvNkkRRYTirjnCForhYABOggRjYNKZs8BeXg1
	 znroz8DZydEm5xWZA/kxrnlsss2K1+GqTZwuACZ7wUX1Fltn3oStKZW361NLwpao9R
	 J8KtuXrQ6p0EshIG9eYqJciGEeGBPbkwb29Sr4xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/113] net: sfp: convert sfp quirks to modify struct sfp_module_support
Date: Mon,  9 Feb 2026 15:23:57 +0100
Message-ID: <20260209142313.347133356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit a7dc35a9e49b103ff2a8a96519c47e149d733ccd ]

In order to provide extensible module support properties, arrange for
the SFP quirks to modify any member of the sfp_module_support struct,
rather than just the ethtool link modes and interfaces.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1uydVe-000000061WK-3KwI@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: adcbadfd8e05 ("net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c |  5 ++--
 drivers/net/phy/sfp.c     | 49 +++++++++++++++++++--------------------
 drivers/net/phy/sfp.h     |  4 ++--
 3 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 35030c527fbed..b77190494b045 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -373,9 +373,8 @@ static void sfp_init_module(struct sfp_bus *bus,
 	sfp_module_parse_port(bus, id);
 	sfp_module_parse_may_have_phy(bus, id);
 
-	if (quirk && quirk->modes)
-		quirk->modes(id, bus->caps.link_modes,
-			     bus->caps.interfaces);
+	if (quirk && quirk->support)
+		quirk->support(id, &bus->caps);
 }
 
 /**
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 90bb5559af5bf..05dd0cf093482 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -439,45 +439,44 @@ static void sfp_fixup_rollball_cc(struct sfp *sfp)
 }
 
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
-				unsigned long *modes,
-				unsigned long *interfaces)
+				struct sfp_module_caps *caps)
 {
-	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT, modes);
-	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+			 caps->link_modes);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, caps->interfaces);
 }
 
 static void sfp_quirk_disable_autoneg(const struct sfp_eeprom_id *id,
-				      unsigned long *modes,
-				      unsigned long *interfaces)
+				      struct sfp_module_caps *caps)
 {
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, modes);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, caps->link_modes);
 }
 
 static void sfp_quirk_oem_2_5g(const struct sfp_eeprom_id *id,
-			       unsigned long *modes,
-			       unsigned long *interfaces)
+			       struct sfp_module_caps *caps)
 {
 	/* Copper 2.5G SFP */
-	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, modes);
-	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
-	sfp_quirk_disable_autoneg(id, modes, interfaces);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			 caps->link_modes);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, caps->interfaces);
+	sfp_quirk_disable_autoneg(id, caps);
 }
 
 static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
-				      unsigned long *modes,
-				      unsigned long *interfaces)
+				      struct sfp_module_caps *caps)
 {
 	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
 	 * types including 10G Ethernet which is not truth. So clear all claimed
 	 * modes and set only one mode which module supports: 1000baseX_Full.
 	 */
-	linkmode_zero(modes);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, modes);
+	linkmode_zero(caps->link_modes);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+			 caps->link_modes);
 }
 
-#define SFP_QUIRK(_v, _p, _m, _f) \
-	{ .vendor = _v, .part = _p, .modes = _m, .fixup = _f, }
-#define SFP_QUIRK_M(_v, _p, _m) SFP_QUIRK(_v, _p, _m, NULL)
+#define SFP_QUIRK(_v, _p, _s, _f) \
+	{ .vendor = _v, .part = _p, .support = _s, .fixup = _f, }
+#define SFP_QUIRK_S(_v, _p, _s) SFP_QUIRK(_v, _p, _s, NULL)
 #define SFP_QUIRK_F(_v, _p, _f) SFP_QUIRK(_v, _p, NULL, _f)
 
 static const struct sfp_quirk sfp_quirks[] = {
@@ -517,7 +516,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	// HG MXPD-483II-F 2.5G supports 2500Base-X, but incorrectly reports
 	// 2600MBd in their EERPOM
-	SFP_QUIRK_M("HG GENUINE", "MXPD-483II", sfp_quirk_2500basex),
+	SFP_QUIRK_S("HG GENUINE", "MXPD-483II", sfp_quirk_2500basex),
 
 	// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd NRZ in
 	// their EEPROM
@@ -526,9 +525,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	// Lantech 8330-262D-E can operate at 2500base-X, but incorrectly report
 	// 2500MBd NRZ in their EEPROM
-	SFP_QUIRK_M("Lantech", "8330-262D-E", sfp_quirk_2500basex),
+	SFP_QUIRK_S("Lantech", "8330-262D-E", sfp_quirk_2500basex),
 
-	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
+	SFP_QUIRK_S("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
 	// Walsun HXSX-ATR[CI]-1 don't identify as copper, and use the
 	// Rollball protocol to talk to the PHY.
@@ -541,9 +540,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
 
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
-	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
-	SFP_QUIRK_M("OEM", "SFP-2.5G-BX10-D", sfp_quirk_2500basex),
-	SFP_QUIRK_M("OEM", "SFP-2.5G-BX10-U", sfp_quirk_2500basex),
+	SFP_QUIRK_S("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
+	SFP_QUIRK_S("OEM", "SFP-2.5G-BX10-D", sfp_quirk_2500basex),
+	SFP_QUIRK_S("OEM", "SFP-2.5G-BX10-U", sfp_quirk_2500basex),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-2.5G", sfp_fixup_rollball),
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 1fd097dccb9fc..879dff7afe6a4 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -9,8 +9,8 @@ struct sfp;
 struct sfp_quirk {
 	const char *vendor;
 	const char *part;
-	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes,
-		      unsigned long *interfaces);
+	void (*support)(const struct sfp_eeprom_id *id,
+			struct sfp_module_caps *caps);
 	void (*fixup)(struct sfp *sfp);
 };
 
-- 
2.51.0



