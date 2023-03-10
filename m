Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DDE8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9B2C433D2;
	Fri, 10 Mar 2023 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459868;
	bh=Ab3+alOoHwKOBJBhwq6PuMnwt9PBYc8nLLDWm77uAss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkUp6vOoDY7YAR0hZDsv0qsLi2LE/+eK31G/fW5P0h9pTIsHU/ilFtxjNzc2leIPg
	 DjqW4BatpHaGmB1Uxf7C/rpfFzQlnSuoUP7pA7biwDT5LaCCC6zwTCopS3NKIrg6Wg
	 uqdL3HPhtbG8x7VZYb68z2lgPaUQ1AlifRUMwcDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/529] net: bcmgenet: fix MoCA LED control
Date: Fri, 10 Mar 2023 14:34:48 +0100
Message-Id: <20230310133811.685903197@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index f9e91304d2327..4b875838a6467 100644
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



