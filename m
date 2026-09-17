Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF04E4ABBC6;
	Thu, 17 Sep 2026 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659947; cv=none; b=JUaULuRXrLeXb+8vSg8cCGaX01Ar5g2K5+EHnNpf36QzlKYr1pNwjOYjntGodHB18f1EW2LVI0HDr4kJ2az82FzUBw0SN6EUBZ7zIn/m89OzYl/QoDbDHV4mGDRjkwPVNS20ssQS5RirOKRTQ9mlabtKVpYOApX6yS/Y2pH6xRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659947; c=relaxed/simple;
	bh=LNlW3Lj3TTWYk5irdmRrMOt2wClzS1Dr+Dy5NpnMicw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDyasRvuIxe+KTUDYcOPwBriOIXHWpmIlaCr5b+iI+dz7P5z7n+7D9chKQ5wbZVE8QiNhdJVdR7a23+DZjMi27Kx6MJ+r0TcpPi7DM2HaINAa4p7gbcxBz7gNtS5NYATjgPmjCgbvgECmgIX54zdUliaz6h+/Vo7rOVkP81CojQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mYVS0e9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mYVS0e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404DC1F00898;
	Thu, 17 Sep 2026 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659940;
	bh=4moJ6pTA+6iNERhuhLEfJbYoHfB0B8dRuZEn18+HYdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mYVS0e9aKhmm28GUXweAuq9D8bifixcVcXR93yYf6bxuu4+SOHkymjuO/RXQ2wRA
	 9hyOGYX1kK+GlrMV6cLac4J+XsQ7E5ea9KFK7b2FWS9C1J6c23OCJ7YQbyBEHNHES5
	 ohB+bEHnKQvJbAOZfCUNkOVwtNW1Z4fQxpTnYn7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 426/733] net: dsa: mt7530: add EN7528 support
Date: Thu, 17 Sep 2026 16:12:14 +0100
Message-ID: <20260917151402.437837192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit cf23fcc9437e5c383d9f282197d580a5a3fd6e6e ]

The EcoNet EN7528 SoC integrates an MT7530 switch (the chip revision
register reads 0x7530), memory-mapped in the SoC register space and
reached through the same MMIO glue used for the built-in switches of the
MediaTek MT7988 and Airoha EN7581/AN7583 SoCs. Its reset sequence and its
PHY indirect access registers are the same as on those switches, so add
an ID_EN7528 variant bound with the "econet,en7528-switch" compatible,
reusing mt7988_setup() and the indirect PHY accessors.

The switch core, however, is an MT7530 and not an MT7531 derivative: the
CPU port to trap frames to is set through the MT7530-style CPU_EN /
CPU_PORT fields of the MFC register rather than the MT7531 CFC register,
so add it to the MT7530 handling in mt753x_conduit_state_change(). For the
same reason the MT7530 mirror and force-mode register layouts already
apply to it as the default of the MT753X_*() macros.

The four user ports (1-4) are connected to integrated Gigabit PHYs at
MDIO addresses 9-12 of the switch internal MDIO bus. The CPU port (port
6) is connected to the SoC Ethernet MAC at a fixed 1000 Mbps full duplex
link, so the port capabilities cannot be shared with the MT7988 and
EN7581 switches, whose CPU ports run at 10 Gbps.

The LAN GPHYs advertise EEE by default, but negotiating EEE with some
link partners results in an unstable link with dropped frames. Leave the
LPI capabilities empty for the EN7528 so that phylink disables EEE on
these PHYs and refuses to enable it from userspace.

Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Link: https://patch.msgid.link/8c7dfabd860ab0a6dd771c2bac7b7599eb369a4f.1783770059.git.naseefkm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3c18e3c9a54e ("net: dsa: mt7530: populate lpi_interfaces to fix EEE support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530-mmio.c |  1 +
 drivers/net/dsa/mt7530.c      | 58 ++++++++++++++++++++++++++++++-----
 drivers/net/dsa/mt7530.h      |  1 +
 3 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mt7530-mmio.c b/drivers/net/dsa/mt7530-mmio.c
index 119fdd863d917..fd68b1cd06306 100644
--- a/drivers/net/dsa/mt7530-mmio.c
+++ b/drivers/net/dsa/mt7530-mmio.c
@@ -12,6 +12,7 @@
 static const struct of_device_id mt7988_of_match[] = {
 	{ .compatible = "airoha,an7583-switch", .data = &mt753x_table[ID_AN7583], },
 	{ .compatible = "airoha,en7581-switch", .data = &mt753x_table[ID_EN7581], },
+	{ .compatible = "econet,en7528-switch", .data = &mt753x_table[ID_EN7528], },
 	{ .compatible = "mediatek,mt7988-switch", .data = &mt753x_table[ID_MT7988], },
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index aa33d94e11b5f..55131bfd11f6d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2902,6 +2902,30 @@ static void en7581_mac_port_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
+static void en7528_mac_port_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	switch (port) {
+	/* Ports which are connected to switch PHYs. There is no MII pinout. */
+	case 1 ... 4:
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+
+		config->mac_capabilities |= MAC_10 | MAC_100 | MAC_1000FD;
+		break;
+
+	/* Port 6 is connected to SoC's GMAC at 1000 Mbps full duplex. There
+	 * is no MII pinout.
+	 */
+	case 6:
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+
+		config->mac_capabilities |= MAC_1000FD;
+		break;
+	}
+}
+
 static void
 mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
@@ -3091,17 +3115,24 @@ static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
 				    struct phylink_config *config)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 eeecr;
 
 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE;
 
-	config->lpi_capabilities = MAC_100FD | MAC_1000FD | MAC_2500FD;
-
-	eeecr = mt7530_read(priv, MT753X_PMEEECR_P(port));
-	/* tx_lpi_timer should be in microseconds. The time units for
-	 * LPI threshold are unspecified.
+	/* The EN7528 GPHYs report EEE capability, but negotiating EEE with
+	 * common link partners (e.g. Realtek GbE NICs) results in an unstable
+	 * link with dropped frames. Leave the LPI capabilities empty so that
+	 * phylink disables EEE on these PHYs and refuses to enable it from
+	 * userspace.
 	 */
-	config->lpi_timer_default = FIELD_GET(LPI_THRESH_MASK, eeecr);
+	if (priv->id != ID_EN7528) {
+		u32 eeecr = mt7530_read(priv, MT753X_PMEEECR_P(port));
+
+		config->lpi_capabilities = MAC_100FD | MAC_1000FD | MAC_2500FD;
+		/* tx_lpi_timer should be in microseconds. The time units for
+		 * LPI threshold are unspecified.
+		 */
+		config->lpi_timer_default = FIELD_GET(LPI_THRESH_MASK, eeecr);
+	}
 
 	priv->info->mac_port_get_caps(ds, port, config);
 }
@@ -3244,7 +3275,8 @@ mt753x_conduit_state_change(struct dsa_switch *ds,
 	 * forwarded to the numerically smallest CPU port whose conduit
 	 * interface is up.
 	 */
-	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
+	if (priv->id != ID_MT7530 && priv->id != ID_MT7621 &&
+	    priv->id != ID_EN7528)
 		return;
 
 	mask = BIT(cpu_dp->index);
@@ -3449,6 +3481,16 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
 		.mac_port_get_caps = en7581_mac_port_get_caps,
 	},
+	[ID_EN7528] = {
+		.id = ID_EN7528,
+		.pcs_ops = &mt7530_pcs_ops,
+		.sw_setup = mt7988_setup,
+		.phy_read_c22 = mt7531_ind_c22_phy_read,
+		.phy_write_c22 = mt7531_ind_c22_phy_write,
+		.phy_read_c45 = mt7531_ind_c45_phy_read,
+		.phy_write_c45 = mt7531_ind_c45_phy_write,
+		.mac_port_get_caps = en7528_mac_port_get_caps,
+	},
 };
 EXPORT_SYMBOL_GPL(mt753x_table);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index dd33b0df3419e..5f1e841f42c0e 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -21,6 +21,7 @@ enum mt753x_id {
 	ID_MT7988 = 3,
 	ID_EN7581 = 4,
 	ID_AN7583 = 5,
+	ID_EN7528 = 6,
 };
 
 #define	NUM_TRGMII_CTRL			5
-- 
2.53.0



