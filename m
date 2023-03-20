Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420091C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A1BC433EF;
	Mon, 20 Mar 2023 15:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325570;
	bh=wza1VQyBOYnVChFYuu+Mh6QjVI0weLFFy+XqOQLpq+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTPwAW3kLqjdCNEauBhMWB2LiT0K+bgzS4lKNv0/UzoV0V4r7NvtFAfZucNiMxjMi
	 r7Ss/o2/RAbqYYcyNv/LYi9x41H0umaTBChb2SqNEnkT32Lg7+EoouApemsJrA2Q/y
	 r6809BVImljGiTYKPrVUAnsgSiga3Oy2vyRyXmx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 063/211] net: ethernet: mtk_eth_soc: only write values if needed
Date: Mon, 20 Mar 2023 15:53:18 +0100
Message-Id: <20230320145515.865320669@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 6e933a804c7db8be64f367f33e63cd7dcc302ebb ]

Only restart auto-negotiation and write link timer if actually
necessary. This prevents losing the link in case of minor
changes.

Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 612f65bb03454..83976dc868875 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -38,20 +38,16 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  const unsigned long *advertising,
 			  bool permit_pause_to_mac)
 {
+	bool mode_changed = false, changed, use_an;
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
 	unsigned int rgc3, sgm_mode, bmcr;
 	int advertise, link_timer;
-	bool changed, use_an;
 
 	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
 							     advertising);
 	if (advertise < 0)
 		return advertise;
 
-	link_timer = phylink_get_link_timer_ns(interface);
-	if (link_timer < 0)
-		return link_timer;
-
 	/* Clearing IF_MODE_BIT0 switches the PCS to BASE-X mode, and
 	 * we assume that fixes it's speed at bitrate = line rate (in
 	 * other words, 1000Mbps or 2500Mbps).
@@ -77,13 +73,16 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	}
 
 	if (use_an) {
-		/* FIXME: Do we need to set AN_RESTART here? */
-		bmcr = SGMII_AN_RESTART | SGMII_AN_ENABLE;
+		bmcr = SGMII_AN_ENABLE;
 	} else {
 		bmcr = 0;
 	}
 
 	if (mpcs->interface != interface) {
+		link_timer = phylink_get_link_timer_ns(interface);
+		if (link_timer < 0)
+			return link_timer;
+
 		/* PHYA power down */
 		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
 				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
@@ -101,16 +100,17 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
 				   RG_PHY_SPEED_3_125G, rgc3);
 
+		/* Setup the link timer */
+		regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
+
 		mpcs->interface = interface;
+		mode_changed = true;
 	}
 
 	/* Update the advertisement, noting whether it has changed */
 	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
 				 SGMII_ADVERTISE, advertise, &changed);
 
-	/* Setup the link timer and QPHY power up inside SGMIISYS */
-	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
-
 	/* Update the sgmsys mode register */
 	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
 			   SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN |
@@ -118,7 +118,7 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 
 	/* Update the BMCR */
 	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
-			   SGMII_AN_RESTART | SGMII_AN_ENABLE, bmcr);
+			   SGMII_AN_ENABLE, bmcr);
 
 	/* Release PHYA power down state
 	 * Only removing bit SGMII_PHYA_PWD isn't enough.
@@ -132,7 +132,7 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	usleep_range(50, 100);
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
 
-	return changed;
+	return changed || mode_changed;
 }
 
 static void mtk_pcs_restart_an(struct phylink_pcs *pcs)
-- 
2.39.2



