Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753B92FC893;
	Sat, 25 Oct 2025 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409188; cv=none; b=ZIp0l8t9yOqhfKgqGg+1pq7uMRd5mWLnZx4mfP1rwxLL4SL5hBAfXd57KMqnl/npKaHlbtBI2tMa9H8A7slPt34aIVaet5hPHcS/TACLAUzEuLQsfT7aS5ZmxzgAdWjeELLX/h56H2ye5WEov8Aqc5S5t/+qRnWrd6oEjqzuT5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409188; c=relaxed/simple;
	bh=0INRknouDY6zSv8UMlu6PaWl5VKia21kkymZeVt/Y1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyZWo6ZGR34Bb6MvDL57hfc25gBGfu9OJxgsoJQSwlONSWn/p314cmyOzLlBGuuBoYOS6f/c7UV96+Kn1To+OIznr/SA5y2udWAdl+2vPLCJW9wCjqwN3SnaPWhE/LDh+zpzR4YpvWTIt8jp5ofUzw1wXuO+5l6gZ2uZfW2Ux7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRq7rhU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRq7rhU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4154BC116D0;
	Sat, 25 Oct 2025 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409188;
	bh=0INRknouDY6zSv8UMlu6PaWl5VKia21kkymZeVt/Y1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRq7rhU+AwJlm5/3XtGRMn3oAwAvLBr/U1Yvrn582n8ZM64fZLZ1p6Gnb5naO7XkF
	 T0v0rWxD1Sg30iolka/9ozHCN058XOZ6NYtDjq8hfCmnQzUa2mvjLNp4c4l9zEOzlp
	 zd9XzPrrp9yEMPqZYSq/fwn0drqU0h+n2T6XqTPpNRGBMHnCyVfgHTmfzPvYM4nyjY
	 m8b4tn2FPBqJiyjjHrzeCNydBok60gouF9vpmV87jAd0j4um+2BCHW8uZ9vwi9eMt4
	 ZrklstCe4PFPxrKnbgbnT4qhoNna0H3A/HRzSmR+Gp7pA6lU7HG7oxSFQyP/UC5+2z
	 kTYotmwod01rg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	claudiu.manoil@nxp.com,
	alexandre.belloni@bootlin.com,
	UNGLinuxDriver@microchip.com,
	linux@armlinux.org.uk,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] net: dsa: felix: support phy-mode = "10g-qxgmii"
Date: Sat, 25 Oct 2025 11:57:46 -0400
Message-ID: <20251025160905.3857885-235-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6f616757dd306fce4b55131df23737732e347d8f ]

The "usxgmii" phy-mode that the Felix switch ports support on LS1028A is
not quite USXGMII, it is defined by the USXGMII multiport specification
document as 10G-QXGMII. It uses the same signaling as USXGMII, but it
multiplexes 4 ports over the link, resulting in a maximum speed of 2.5G
per port.

This change is needed in preparation for the lynx-10g SerDes driver on
LS1028A, which will make a more clear distinction between usxgmii
(supported on lane 0) and 10g-qxgmii (supported on lane 1). These
protocols have their configuration in different PCCR registers (PCCRB vs
PCCR9).

Continue parsing and supporting single-port-per-lane USXGMII when found
in the device tree as usual (because it works), but add support for
10G-QXGMII too. Using phy-mode = "10g-qxgmii" will be required when
modifying the device trees to specify a "phys" phandle to the SerDes
lane. The result when the "phys" phandle is present but the phy-mode is
wrong is undefined.

The only PHY driver in known use with this phy-mode, AQR412C, will gain
logic to transition from "usxgmii" to "10g-qxgmii" in a future change.
Prepare the driver by also setting PHY_INTERFACE_MODE_10G_QXGMII in
supported_interfaces when PHY_INTERFACE_MODE_USXGMII is there, to
prevent breakage with existing device trees.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250903130730.2836022-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Adds explicit support for the 10G-QXGMII interface in the Felix
  (VSC9959) DSA driver, aligning it with PHY and PCS support already
  present in the tree. This prevents link failures or mode validation
  errors when device trees or PHYs select 10G-QXGMII.
- Key changes:
  - Advertise 10G-QXGMII as supported when DT phy-mode is USXGMII
    (compatibility/superset). This avoids negotiation/validation
    mismatches when a PHY transitions to reporting 10G-QXGMII:
    - drivers/net/dsa/ocelot/felix.c:1154-1159
  - Allow parsing and validating DT phy-mode = "10g-qxgmii" by mapping
    it to a new ocelot port mode flag:
    - drivers/net/dsa/ocelot/felix.c:1360-1368
    - drivers/net/dsa/ocelot/felix.h:15-17
    - drivers/net/dsa/ocelot/felix_vsc9959.c:33-38
- Why this is needed and safe:
  - PHY and PCS already know about 10G-QXGMII:
    - Aquantia PHY can translate USXGMII to 10G-QXGMII (quad-replicator)
      based on firmware fingerprint, so the MAC must accept 10G-QXGMII
      to avoid phylink validation issues:
      - drivers/net/phy/aquantia/aquantia_main.c:532, 785, 1121, 1132
    - Lynx PCS handles 10G-QXGMII identically to USXGMII for in-band AN
      and state/config:
      - drivers/net/pcs/pcs-lynx.c:52, 119, 215, 325, 350
    - The interface string is already part of kernel APIs and DT
      bindings:
      - include/linux/phy.h:279-280 (returns "10g-qxgmii")
      - Documentation/devicetree/bindings/net/ethernet-
        controller.yaml:81
  - Fixes real user-facing issues:
    - With updated DTs using "10g-qxgmii" or when the PHY reports
      10G-QXGMII, the existing Felix code rejects the mode in
      felix_validate_phy_mode, leaving ports non-functional. This patch
      adds the mapping and port-mode bit so validation passes and serdes
      configuration via phy_set_mode_ext works correctly:
      - drivers/net/dsa/ocelot/felix.c:1370-1374 (validation path)
      - drivers/net/ethernet/mscc/ocelot.c:1002-1022 (serdes configured
        using parsed phy_mode)
  - Constrained and low-risk:
    - No architectural changes and no new uAPI; only extends mode
      acceptance/advertisement for a MAC-PHY interface that already
      exists upstream.
    - MAC capabilities remain unchanged (no 10G per-port advertised),
      which is correct for 10G-QXGMII where per-port maximum is 2.5G:
      - drivers/net/dsa/ocelot/felix.c:1150-1152
    - Change is limited to the Felix driver and its header; other ocelot
      variants (e.g., seville) are unaffected.
- Backport considerations:
  - Requires that the target stable tree already has
    PHY_INTERFACE_MODE_10G_QXGMII and PCS/PHY support (present in this
    codebase). For older trees lacking those enums/support, additional
    enabling patches would be needed.
  - No device tree binding changes are introduced; this only enables
    Felix to honor the existing "10g-qxgmii" string.

Conclusion: This is a small, contained compatibility fix that prevents
breakage with updated PHY behavior and device trees. It follows stable
rules (bug fix, minimal risk, confined to a subsystem). Backporting is
advisable.

 drivers/net/dsa/ocelot/felix.c         | 4 ++++
 drivers/net/dsa/ocelot/felix.h         | 3 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 2dd4e56e1cf11..20ab558fde247 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1153,6 +1153,9 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 
 	__set_bit(ocelot->ports[port]->phy_mode,
 		  config->supported_interfaces);
+	if (ocelot->ports[port]->phy_mode == PHY_INTERFACE_MODE_USXGMII)
+		__set_bit(PHY_INTERFACE_MODE_10G_QXGMII,
+			  config->supported_interfaces);
 }
 
 static void felix_phylink_mac_config(struct phylink_config *config,
@@ -1359,6 +1362,7 @@ static const u32 felix_phy_match_table[PHY_INTERFACE_MODE_MAX] = {
 	[PHY_INTERFACE_MODE_SGMII] = OCELOT_PORT_MODE_SGMII,
 	[PHY_INTERFACE_MODE_QSGMII] = OCELOT_PORT_MODE_QSGMII,
 	[PHY_INTERFACE_MODE_USXGMII] = OCELOT_PORT_MODE_USXGMII,
+	[PHY_INTERFACE_MODE_10G_QXGMII] = OCELOT_PORT_MODE_10G_QXGMII,
 	[PHY_INTERFACE_MODE_1000BASEX] = OCELOT_PORT_MODE_1000BASEX,
 	[PHY_INTERFACE_MODE_2500BASEX] = OCELOT_PORT_MODE_2500BASEX,
 };
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 211991f494e35..a657b190c5d7b 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -12,8 +12,9 @@
 #define OCELOT_PORT_MODE_SGMII		BIT(1)
 #define OCELOT_PORT_MODE_QSGMII		BIT(2)
 #define OCELOT_PORT_MODE_2500BASEX	BIT(3)
-#define OCELOT_PORT_MODE_USXGMII	BIT(4)
+#define OCELOT_PORT_MODE_USXGMII	BIT(4) /* compatibility */
 #define OCELOT_PORT_MODE_1000BASEX	BIT(5)
+#define OCELOT_PORT_MODE_10G_QXGMII	BIT(6)
 
 struct device_node;
 
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7b35d24c38d76..8cf4c89865876 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -34,7 +34,8 @@
 					 OCELOT_PORT_MODE_QSGMII | \
 					 OCELOT_PORT_MODE_1000BASEX | \
 					 OCELOT_PORT_MODE_2500BASEX | \
-					 OCELOT_PORT_MODE_USXGMII)
+					 OCELOT_PORT_MODE_USXGMII | \
+					 OCELOT_PORT_MODE_10G_QXGMII)
 
 static const u32 vsc9959_port_modes[VSC9959_NUM_PORTS] = {
 	VSC9959_PORT_MODE_SERDES,
-- 
2.51.0

