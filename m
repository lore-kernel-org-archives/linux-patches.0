Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C900920B3E;
	Tue, 23 Apr 2024 21:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908552; cv=none; b=IBn/8aeSFRK+tQIjtC4iZjj4pcJSvVjCJAlDK3n5GLLq//1aSZcklRZPspHKQlF8QpEkZ6bg6Udboco5cltHaU42OIEguuqizpNqwTAYPKXEoNq0G6EvOY8bzc3/v6imNYMp3+ZvGYBG8TFi/uKbTp5+SrjlSEvA4sPXN0U11Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908552; c=relaxed/simple;
	bh=XYsjPkjKZ0x3GBDFo+HM75RSoJDILXaFP9KFTfmc7tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIEDPMiVvug/gyCOVrEs7LIQnBhMCx/q9vkueq2cz4is3EuCfxWOYn+il/AHGIYrho9w7t04fnR4L4iE2a4iH/3FMWWIkCTyVruTPFeXqGxfzKtAcOqVYpsok0zYbPT3BTlt4URhm224ovgga6sz4/bK0J3T8wLbr14qYSUPwtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS6LgcSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS6LgcSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E123C116B1;
	Tue, 23 Apr 2024 21:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908552;
	bh=XYsjPkjKZ0x3GBDFo+HM75RSoJDILXaFP9KFTfmc7tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SS6LgcSVvZyAXEOkZsVDZZQbEFPgORL0w7O2Uv2c8DAZx8sapqx/59IRT+rMpJn8B
	 y2uOPhmaWEb3tlbwYUN2Yo9Tg+tbLMhqlm1eu2IiuYzUkQRSLHmOj0eBbaRVTvqZZH
	 sOZ24bx19w/kTIAmF6smldPl0Vk49bR5u4+KWffc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 154/158] net: dsa: mt7530: fix enabling EEE on MT7531 switch on all boards
Date: Tue, 23 Apr 2024 14:39:36 -0700
Message-ID: <20240423213900.851224145@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arınç ÜNAL <arinc.unal@arinc9.com>

commit 06dfcd4098cfdc4d4577d94793a4f9125386da8b upstream.

The commit 40b5d2f15c09 ("net: dsa: mt7530: Add support for EEE features")
brought EEE support but did not enable EEE on MT7531 switch MACs. EEE is
enabled on MT7531 switch MACs by pulling the LAN2LED0 pin low on the board
(bootstrapping), unsetting the EEE_DIS bit on the trap register, or setting
the internal EEE switch bit on the CORE_PLL_GROUP4 register. Thanks to
SkyLake Huang (黃啟澤) from MediaTek for providing information on the
internal EEE switch bit.

There are existing boards that were not designed to pull the pin low.
Because of that, the EEE status currently depends on the board design.

The EEE_DIS bit on the trap pertains to the LAN2LED0 pin which is usually
used to control an LED. Once the bit is unset, the pin will be low. That
will make the active low LED turn on. The pin is controlled by the switch
PHY. It seems that the PHY controls the pin in the way that it inverts the
pin state. That means depending on the wiring of the LED connected to
LAN2LED0 on the board, the LED may be on without an active link.

To not cause this unwanted behaviour whilst enabling EEE on all boards, set
the internal EEE switch bit on the CORE_PLL_GROUP4 register.

My testing on MT7531 shows a certain amount of traffic loss when EEE is
enabled. That said, I haven't come across a board that enables EEE. So
enable EEE on the switch MACs but disable EEE advertisement on the switch
PHYs. This way, we don't change the behaviour of the majority of the boards
that have this switch. The mediatek-ge PHY driver already disables EEE
advertisement on the switch PHYs but my testing shows that it is somehow
enabled afterwards. Disabling EEE advertisement before the PHY driver
initialises keeps it off.

With this change, EEE can now be enabled using ethtool.

Fixes: 40b5d2f15c09 ("net: dsa: mt7530: Add support for EEE features")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/20240408-for-net-mt7530-fix-eee-for-mt7531-mt7988-v3-1-84fdef1f008b@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |   17 ++++++++++++-----
 drivers/net/dsa/mt7530.h |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2712,18 +2712,25 @@ mt7531_setup(struct dsa_switch *ds)
 	priv->p5_interface = PHY_INTERFACE_MODE_NA;
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
-	/* Enable PHY core PLL, since phy_device has not yet been created
-	 * provided for phy_[read,write]_mmd_indirect is called, we provide
-	 * our own mt7531_ind_mmd_phy_[read,write] to complete this
-	 * function.
+	/* Enable Energy-Efficient Ethernet (EEE) and PHY core PLL, since
+	 * phy_device has not yet been created provided for
+	 * phy_[read,write]_mmd_indirect is called, we provide our own
+	 * mt7531_ind_mmd_phy_[read,write] to complete this function.
 	 */
 	val = mt7531_ind_c45_phy_read(priv, MT753X_CTRL_PHY_ADDR,
 				      MDIO_MMD_VEND2, CORE_PLL_GROUP4);
-	val |= MT7531_PHY_PLL_BYPASS_MODE;
+	val |= MT7531_RG_SYSPLL_DMY2 | MT7531_PHY_PLL_BYPASS_MODE;
 	val &= ~MT7531_PHY_PLL_OFF;
 	mt7531_ind_c45_phy_write(priv, MT753X_CTRL_PHY_ADDR, MDIO_MMD_VEND2,
 				 CORE_PLL_GROUP4, val);
 
+	/* Disable EEE advertisement on the switch PHYs. */
+	for (i = MT753X_CTRL_PHY_ADDR;
+	     i < MT753X_CTRL_PHY_ADDR + MT7530_NUM_PHYS; i++) {
+		mt7531_ind_c45_phy_write(priv, i, MDIO_MMD_AN, MDIO_AN_EEE_ADV,
+					 0);
+	}
+
 	mt7531_setup_common(ds);
 
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -634,6 +634,7 @@ enum mt7531_clk_skew {
 #define  RG_SYSPLL_DDSFBK_EN		BIT(12)
 #define  RG_SYSPLL_BIAS_EN		BIT(11)
 #define  RG_SYSPLL_BIAS_LPF_EN		BIT(10)
+#define  MT7531_RG_SYSPLL_DMY2		BIT(6)
 #define  MT7531_PHY_PLL_OFF		BIT(5)
 #define  MT7531_PHY_PLL_BYPASS_MODE	BIT(4)
 


