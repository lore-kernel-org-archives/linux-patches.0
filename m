Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2810BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579C8C433D2;
	Tue,  7 Mar 2023 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215230;
	bh=i5uGj0BU9MhS6JMp7C7blwfjmmEE2m2zOo76kEQNd6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHbZ4bNvNSa9HhARQrQsTf4SFkB0NmxwjxLnHSggoFatrhZJkZ4KwKaSF43M1EGVE
	 dglYT/jc2V09yfCozdYNu20vvfnl2AD37Dst3PQ0ojNYeoloZ/Ys4RvdGUb3jlLr4h
	 HePmz59msqzFQ56yP0F+F1VfFFbtq4yL9lrkncpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/567] net: bcmgenet: fix MoCA LED control
Date: Tue,  7 Mar 2023 17:58:17 +0100
Message-Id: <20230307165912.911504394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit a7515af9fb8f0890fe540b108def4a86b9e8330a ]

When the bcmgenet_mii_config() code was refactored it was missed
that the LED control for the MoCA interface got overwritten by
the port_ctrl value. Its previous programming is restored here.

Fixes: 4f8d81b77e66 ("net: bcmgenet: Refactor register access in bcmgenet_mii_config")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index dbd2ede53f946..f61f832ea19ca 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -165,15 +165,6 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 
 static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 {
-	u32 reg;
-
-	if (!GENET_IS_V5(priv)) {
-		/* Speed settings are set in bcmgenet_mii_setup() */
-		reg = bcmgenet_sys_readl(priv, SYS_PORT_CTRL);
-		reg |= LED_ACT_SOURCE_MAC;
-		bcmgenet_sys_writel(priv, reg, SYS_PORT_CTRL);
-	}
-
 	if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
 		fixed_phy_set_link_update(priv->dev->phydev,
 					  bcmgenet_fixed_phy_link_update);
@@ -206,6 +197,8 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 
 		if (!phy_name) {
 			phy_name = "MoCA";
+			if (!GENET_IS_V5(priv))
+				port_ctrl |= LED_ACT_SOURCE_MAC;
 			bcmgenet_moca_phy_setup(priv);
 		}
 		break;
-- 
2.39.2



