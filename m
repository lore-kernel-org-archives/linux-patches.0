Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694124D17BA;
	Thu, 17 Sep 2026 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666133; cv=none; b=bZQzy7gO7PE7oO/bRTsRdW78ZOeLE6YuZwch1fYRMjjXMCIWr6rrsidVmZtrQiDrXWhf0iYZfkuW0qbDq/tvzUY/hPpgb1dzmBuAMAVutJHBZk5OwQmGTb/F0VFdumi6qqNHC0cT6gJf93KMb5oOrq5GXGFVJwTez/pKVBbBa5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666133; c=relaxed/simple;
	bh=NVHqH9Atu+aP/xmddIa8z2ANrnLj8vVN/u5M+3184Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWoso0YASa3//XWDMXE4aBoIPjQILe8hs8JPLfzwOgpVmfwTc9g6HRTaJ1thayy0K6LHR8mSc/mwaDdUoLBMzwShLASea2yVwRBFt0prCmnGE9LDpKRy3A+kKiOGQ77RK4wp+6pwmXO88x7lBgSXjYRcIOIwjzbOSBJTFfih3q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRwWRiU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRwWRiU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523201F000FF;
	Thu, 17 Sep 2026 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666131;
	bh=KJVkjdJVd40NxDaths1dIsD2Tizpg+Fs654w9SQac5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRwWRiU6u6AlfRrmtF6wEnIoZQ4CY8R6HIUbiDl5QCvxDA+/tAlLpjSAwLaweu9+z
	 KJlClJK+31zC2ugRFigVQrCu0ohG/U6Xd5Uq5gGWkXJCZaW0C3k0R6ITpnMow8GkKL
	 +i9xA+jPHlLQyJWUyxJbhYh6MoHhG6UBU3KwdpU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Vladislav Karmanov <vladislav.karmanov.dev@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0934/1250] net: phy: mediatek-ge: disable EEE on the MT7530 PHY
Date: Thu, 17 Sep 2026 16:12:09 +0100
Message-ID: <20260917151617.331589396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladislav Karmanov <vladislav.karmanov.dev@gmail.com>

[ Upstream commit ccbe7540e4aad0d1c3acc249697350b93ccb8025 ]

The MT7530 internal GE PHY advertises EEE by hardware default, but its
EEE support is defective: with EEE advertised, some link partners fail
to establish a stable link. On a 2-pair (4-wire) cable where both ends
advertise gigabit, 1000BASE-T training cannot succeed, and instead of
falling back to 100 Mbps the port loops, so no link or DHCP lease is
ever obtained. MediaTek confirms the hardware is the root cause (Landen
Chao, 2021): "EEE of the 10-year-old MT7530 internal gephy has many IOT
problems, so it is recommended to disable its EEE."

mtk_gephy_config_init() used to clear the EEE advertisement early, but
commit af3b4b0e59de ("net: phy: mediatek-ge: do not disable EEE
advertisement") removed that on the rationale that the DSA subdriver
already performs an early disable. That holds for MT7531, whose
mt7531_setup() clears MDIO_AN_EEE_ADV on each switch PHY, but not for
the MT7530 PHY: neither the MT7621 integrated switch nor the dedicated
MT7530 IC ever had such a loop, so removing it left those boards
without any working early EEE disable and the link flapping came back.

Since the broken hardware is the PHY, fix it in the PHY driver so it
covers all users of this PHY, integrated in a switch or standalone:

  - clear MDIO_AN_EEE_ADV in probe(), as early as possible, before
    anything can negotiate EEE with the link partner;
  - clear it again in config_init() and call phy_disable_eee() there.
    config_init() is what phy_init_hw() replays after a PHY reset, when
    the register is back at its EEE-advertising hardware default, and
    it runs after of_set_phy_eee_broken() in phy_probe(), so the
    eee_disabled_modes mask survives and neither phylib nor userspace
    can re-enable EEE. dp83867 disables broken EEE from config_init()
    the same way.

Auto-negotiation then falls back to a stable 100 Mbps link instead of
looping at gigabit. Tested on ASUS RT-AX53U (MT7621): with a 2-pair
cable on the WAN port, a single clean 100 Mbps link comes up and a
DHCP lease is obtained, where the unpatched driver loops.

Fixes: af3b4b0e59de ("net: phy: mediatek-ge: do not disable EEE advertisement")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladislav Karmanov <vladislav.karmanov.dev@gmail.com>
Link: https://patch.msgid.link/20260908145213.3976508-1-vladislav.karmanov.dev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mediatek/mtk-ge.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/mediatek/mtk-ge.c b/drivers/net/phy/mediatek/mtk-ge.c
index 73d9b72f9d9e2..96d8ac5154e5e 100644
--- a/drivers/net/phy/mediatek/mtk-ge.c
+++ b/drivers/net/phy/mediatek/mtk-ge.c
@@ -62,10 +62,38 @@ static void mtk_gephy_config_init(struct phy_device *phydev)
 		       FIELD_PREP(MTK_MCC_NEARECHO_OFFSET_MASK, 0x3));
 }
 
+static int mt7530_phy_probe(struct phy_device *phydev)
+{
+	/* The MT7530 internal GE PHY has broken EEE: with EEE advertised,
+	 * some link partners fail to establish a stable link (on a 2-pair
+	 * cable, 1000BASE-T training fails and the port loops instead of
+	 * falling back). MediaTek recommends disabling EEE on this PHY.
+	 * Clear the advertisement as early as possible, before anything
+	 * can negotiate EEE with the link partner.
+	 */
+	return phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+}
+
 static int mt7530_phy_config_init(struct phy_device *phydev)
 {
+	int ret;
+
 	mtk_gephy_config_init(phydev);
 
+	/* The probe() clear alone is not durable: phy_init_hw() replays only
+	 * ->config_init after a PHY reset, with the register back at its
+	 * EEE-advertising hardware default, and phy_probe() zeroes
+	 * eee_disabled_modes (of_set_phy_eee_broken()) after ->probe already
+	 * ran. Clear the advertisement again and mark EEE disabled, so that
+	 * neither phylib nor userspace can re-enable it; dp83867 disables
+	 * broken EEE from config_init() the same way.
+	 */
+	ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+	if (ret)
+		return ret;
+
+	phy_disable_eee(phydev);
+
 	/* Increase post_update_timer */
 	phy_write_paged(phydev, MTK_PHY_PAGE_EXTENDED_3,
 			MTK_PHY_RG_LPI_PCS_DSP_CTRL_REG11, 0x4b);
@@ -100,6 +128,7 @@ static struct phy_driver mtk_gephy_driver[] = {
 	{
 		PHY_ID_MATCH_EXACT(MTK_GPHY_ID_MT7530),
 		.name		= "MediaTek MT7530 PHY",
+		.probe		= mt7530_phy_probe,
 		.config_init	= mt7530_phy_config_init,
 		/* Interrupts are handled by the switch, not the PHY
 		 * itself.
-- 
2.53.0



