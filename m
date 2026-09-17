Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D093BD65D;
	Thu, 17 Sep 2026 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670848; cv=none; b=Mmi/v+ZSh20+eN4/XOuegPF8H14O42gVkc8yhdqW4y+WPkOrO/P4kjtnrH/T8Ydo9PcdMhPG4Y/3u/sYATd8Vczp6gTdE7QUnHqDu7nsnYtfYfQAUEXO3WfVrLB85mmy8rMZ/2jW0MPEEfgt+zUornZT+pSOsc2Hm4BOOAPER3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670848; c=relaxed/simple;
	bh=ilBuBAeUxhQaaYm6p1LA8N5HEr0JV9TRdXNGRIK/Rlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4lRoX0mGPiQ6V7XoR+i+E2u4UQ1cuqUoRuxgZ/4TX7xl6AwrnC/UBIj6qCgX3gtoPJXCzgCTpsvUaOHbg2LgrD/Ok3lSh5c5KyozW3jzNXyovzy0TIXtLNapeMkwZUboC0V1/fu58Hqjp5xezLdNi/8DFgf46Wc3Q7zcPtztdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VG1d5+0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VG1d5+0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6811F000FF;
	Thu, 17 Sep 2026 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670846;
	bh=KEsTEW2ee7HvDHybREXR/qwnzFnDNCRTt2nz4HkQDpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VG1d5+0VDrNNGScMhXztiY577tCfgXn+nAcvXu4l83cOl0bptpbfC0+n1vqCgqgaC
	 dJahuutHc8Vo1yTAvvnL2YLMXVJtp2OlnVI8P6YCZxyNiXxWX2VE+M2zjfiKrcNk94
	 qzI5krUTcF7QcCbQol30ArsQcPwYqaUPrP7K19ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Vladislav Karmanov <vladislav.karmanov.dev@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0788/1102] net: phy: mediatek-ge: disable EEE on the MT7530 PHY
Date: Thu, 17 Sep 2026 16:12:11 +0100
Message-ID: <20260917151600.249688803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 54ea64a37ab3a..b22e50d1677ae 100644
--- a/drivers/net/phy/mediatek/mtk-ge.c
+++ b/drivers/net/phy/mediatek/mtk-ge.c
@@ -40,10 +40,38 @@ static void mtk_gephy_config_init(struct phy_device *phydev)
 	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0xa6, 0x300);
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
 	phy_write_paged(phydev, MTK_PHY_PAGE_EXTENDED_3, 0x11, 0x4b);
 
@@ -69,6 +97,7 @@ static struct phy_driver mtk_gephy_driver[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x03a29412),
 		.name		= "MediaTek MT7530 PHY",
+		.probe		= mt7530_phy_probe,
 		.config_init	= mt7530_phy_config_init,
 		/* Interrupts are handled by the switch, not the PHY
 		 * itself.
-- 
2.53.0



