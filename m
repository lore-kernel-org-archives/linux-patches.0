Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05B533D4E2;
	Thu, 30 Jul 2026 14:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422101; cv=none; b=p4xbqvhLPGk/RHALTnyPurrIhhFCIPGUIWM/XFzy0AqedZHR/q3JE5kSM2M88Gymrs5R7m5d00+DPBm7EBc8J93oOgBIZ+OH1CsJUx2rx6lO2DJUXG1j/zya/q+H/rjlNg/DVkNq8Qx7xbURelhgUaSg/fnGYmmWMyAzLgkELpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422101; c=relaxed/simple;
	bh=kZ08jnZUM1Hdl2oQErmItYYmwW7ak2tTrc85N4YFYhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQxPeIQb0yaCuklrDXa88mHAoE0e0c9NmK9UKdm+fOQPWHEQdQAfev76WIPhVL3XsykdVGeNwLNqBlUxVLPelYPYP3/j6MjwOW7yqbxcgzvFxnR3m0GMk1X7XFXHCCUl6kNDJb/KCWC75ROFsPpc8EkuYzJUpghvkvrQLylJO1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUV3d/Ry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUV3d/Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169751F000E9;
	Thu, 30 Jul 2026 14:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422098;
	bh=Usbnz8RUqQKaFeXcTzvmfTgE4/5r2pQUWdrRjOP+SHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUV3d/RypG6KpolfqjmtS5xTIYzKcfbU90RmIO82AiF2YE4Nk6HPOwkWDS9tuRf94
	 I0Ng3/iuJYBUwhcC6etFeIgpOseRlPU3wWxXFySs+A67WQN4t3bxY8NfwoGBbBqoda
	 WlyHsjDXJnSNJxvrjes4OK9YaV9kxSWgbEnZTUqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	vadik likholetov <vadikas@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 325/744] net: stmmac: enable the MAC on link up for all supported speeds
Date: Thu, 30 Jul 2026 16:09:58 +0200
Message-ID: <20260730141451.193431079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: vadik likholetov <vadikas@gmail.com>

[ Upstream commit 9c99db3a2080b8c2cbbb1100369586a9bea43321 ]

stmmac_mac_link_down() clears the MAC's transmit and receive enable bits.
stmmac_mac_link_up() is expected to set them again through
stmmac_mac_set(..., true), but it first switches on the negotiated speed
and returns early for a speed the switch does not list. The MAC is then
left gated off.

The speed selection is split into three switches, keyed on the interface.
The generic branch -- taken for everything that is neither USXGMII nor
XLGMII, so including PHY_INTERFACE_MODE_10GBASER -- lists only SPEED_2500,
SPEED_1000, SPEED_100 and SPEED_10.

MGBE on Tegra234 runs 10GBASE-R into an Aquantia AQR113C. That PHY does
rate matching, so phylink_link_up() replaces the media speed with the
MAC-side interface speed before calling into the MAC:

	case RATE_MATCH_PAUSE:
		speed = phylink_interface_max_speed(link_state.interface);
		duplex = DUPLEX_FULL;

The driver is therefore called as

	stmmac_mac_link_up(interface=10GBASER, speed=10000, duplex=1)

which falls through to "default: return;". The interface stops passing
traffic after the first link flap.

The failure is easy to misread. The link still comes up, because the PHY
is polled over MDIO and needs no MAC, so the interface reports carrier 1
at the media speed. The DMA is untouched, so its start bits stay set and
descriptors are still consumed. Only the MAC itself is gated off: the
receiver counts nothing (mmc_rx_framecount_gb stops advancing, RE is 0)
and nothing reaches the wire (TE is 0). The interface survives boot only
because stmmac_hw_setup(), called from ndo_open, enables the MAC
unconditionally -- so the problem appears only once the cable has been
unplugged and plugged back in, and "ip link set dev <ethX> down && ip
link set dev <ethX> up" appears to fix it.

The interface is not what the speed bits depend on: with the single
exception of 2.5G, which is selected through the XGMII block on USXGMII
and through the regular speed bits otherwise, each speed maps to one
field of struct mac_link. The per-interface switches are speed
validation, and phylink already validates the speed against
priv->hw->link.caps. So collapse the three switches into one keyed on the
speed alone, keeping the interface test only for the 2.5G case. This
covers 10G on 10GBASE-R, and equally 5G, and 1G/100/10 on USXGMII, all of
which hit "default: return;" today.

A core that does not support a speed leaves the corresponding mac_link
field at 0, and phylink will not offer it that speed in the first place.
For dwxgmac2 at 10G, link.xgmii.speed10000 is XGMAC_CONFIG_SS_10000,
which is 0 and is the correct speed selection for a 10GBASE-R MAC: ctrl
then equals old_ctrl, the register write is skipped, and execution
reaches stmmac_mac_set(..., true).

Log an error in the default case, since a speed with no entry here leaves
the MAC disabled and the symptom does not point at the cause.

Fixes: d8ca113724e7 ("net: stmmac: tegra: Add MGBE support")
Suggested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: vadik likholetov <vadikas@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260713074911.30090-1-vadikas@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 92 ++++++++-----------
 1 file changed, 37 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 50dfdf5bd3eb02..755f48a34314b1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1083,63 +1083,45 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	old_ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl = old_ctrl & ~priv->hw->link.speed_mask;
 
-	if (interface == PHY_INTERFACE_MODE_USXGMII) {
-		switch (speed) {
-		case SPEED_10000:
-			ctrl |= priv->hw->link.xgmii.speed10000;
-			break;
-		case SPEED_5000:
-			ctrl |= priv->hw->link.xgmii.speed5000;
-			break;
-		case SPEED_2500:
+	switch (speed) {
+	case SPEED_100000:
+		ctrl |= priv->hw->link.xlgmii.speed100000;
+		break;
+	case SPEED_50000:
+		ctrl |= priv->hw->link.xlgmii.speed50000;
+		break;
+	case SPEED_40000:
+		ctrl |= priv->hw->link.xlgmii.speed40000;
+		break;
+	case SPEED_25000:
+		ctrl |= priv->hw->link.xlgmii.speed25000;
+		break;
+	case SPEED_10000:
+		ctrl |= priv->hw->link.xgmii.speed10000;
+		break;
+	case SPEED_5000:
+		ctrl |= priv->hw->link.xgmii.speed5000;
+		break;
+	case SPEED_2500:
+		if (interface == PHY_INTERFACE_MODE_USXGMII)
 			ctrl |= priv->hw->link.xgmii.speed2500;
-			break;
-		default:
-			return;
-		}
-	} else if (interface == PHY_INTERFACE_MODE_XLGMII) {
-		switch (speed) {
-		case SPEED_100000:
-			ctrl |= priv->hw->link.xlgmii.speed100000;
-			break;
-		case SPEED_50000:
-			ctrl |= priv->hw->link.xlgmii.speed50000;
-			break;
-		case SPEED_40000:
-			ctrl |= priv->hw->link.xlgmii.speed40000;
-			break;
-		case SPEED_25000:
-			ctrl |= priv->hw->link.xlgmii.speed25000;
-			break;
-		case SPEED_10000:
-			ctrl |= priv->hw->link.xgmii.speed10000;
-			break;
-		case SPEED_2500:
-			ctrl |= priv->hw->link.speed2500;
-			break;
-		case SPEED_1000:
-			ctrl |= priv->hw->link.speed1000;
-			break;
-		default:
-			return;
-		}
-	} else {
-		switch (speed) {
-		case SPEED_2500:
+		else
 			ctrl |= priv->hw->link.speed2500;
-			break;
-		case SPEED_1000:
-			ctrl |= priv->hw->link.speed1000;
-			break;
-		case SPEED_100:
-			ctrl |= priv->hw->link.speed100;
-			break;
-		case SPEED_10:
-			ctrl |= priv->hw->link.speed10;
-			break;
-		default:
-			return;
-		}
+		break;
+	case SPEED_1000:
+		ctrl |= priv->hw->link.speed1000;
+		break;
+	case SPEED_100:
+		ctrl |= priv->hw->link.speed100;
+		break;
+	case SPEED_10:
+		ctrl |= priv->hw->link.speed10;
+		break;
+	default:
+		netdev_err(priv->dev,
+			   "unsupported speed %s on %s, leaving the MAC disabled\n",
+			   phy_speed_to_str(speed), phy_modes(interface));
+		return;
 	}
 
 	if (priv->plat->fix_mac_speed)
-- 
2.53.0



