Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C17651B168;
	Wed, 30 Sep 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789293; cv=none; b=nnEcKoURPxFB1pB9I7IkbLoRIpDq/svG/o/4VKNTM8c3AR8PtCwdP0JTgNYmiCe5AAyc+PXc2SKraGJOECw2iwUKKIVdzCPu0cLgU2FEHoa7jgjxrOhdMmo9hHyS5pUmByumtCGNLi/2/KsT+GRj4qHupHMNSQC/51TMIvNvWOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789293; c=relaxed/simple;
	bh=0w5aICu1RgEpvJ6NsTyPvsldA2TLS7/7AHDpYPS5F98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCZc6zTxPFO3gTjf1PZnuXruuSNPSkwBDsvBjE6Zv2mj0QrdH7WakvAt2LfoLOWqYEKsEghcl1oMf0mtcdOjvmMOuJF0syhCmSAqYG5tFilM1TFIMZoDO9wNka2uUDw5n/+Zkn02NXhYq+bY4w/9ZmFrS+QuYe2In11U0Iu+Jlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYwCylEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYwCylEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC7E1F000FF;
	Wed, 30 Sep 2026 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789292;
	bh=h4sUuxBNZc9H3R6t3uDe3qDn8SWYraWrKcWe7Nsxtdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYwCylEiX+ObW5H3H/3y4FDDRCase49tOiKpuoTXC9f/9ZWXNB0XhWe3qLb5qro3+
	 NDkPPwUD9XVKaM8lA8Fvza1ux0YT1bvqp7wFWjueheG8aRxDheszaaOu0SOB803OBr
	 rrBPpdHMK/AxGBMGSGbYLr7+KwsoIyTolr9Py34E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 426/877] net: bcmgenet: allow return of power up status
Date: Wed, 30 Sep 2026 17:22:17 +0200
Message-ID: <20260930152423.882516099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 2432b9817b7cb91aaae9e5032da0bb017cb3102d ]

It is possible for a WoL power up to fail due to the GENET being
reset while in the suspend state. Allow these failures to be
returned as error codes to allow different recovery behavior
when necessary.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250306192643.2383632-14-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbbc1aee7776 ("net: bcmgenet: do not skip WoL power up on GENET V1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 13 ++++++++-----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  4 ++--
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 12 +++++++-----
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index af7657de90591..fc1d4cef3ad81 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1693,13 +1693,14 @@ static int bcmgenet_power_down(struct bcmgenet_priv *priv,
 	return ret;
 }
 
-static void bcmgenet_power_up(struct bcmgenet_priv *priv,
-			      enum bcmgenet_power_mode mode)
+static int bcmgenet_power_up(struct bcmgenet_priv *priv,
+			     enum bcmgenet_power_mode mode)
 {
+	int ret = 0;
 	u32 reg;
 
 	if (!bcmgenet_has_ext(priv))
-		return;
+		return ret;
 
 	reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
 
@@ -1735,11 +1736,13 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 		}
 		break;
 	case GENET_POWER_WOL_MAGIC:
-		bcmgenet_wol_power_up_cfg(priv, mode);
-		return;
+		ret = bcmgenet_wol_power_up_cfg(priv, mode);
+		break;
 	default:
 		break;
 	}
+
+	return ret;
 }
 
 static struct enet_cb *bcmgenet_get_txcb(struct bcmgenet_priv *priv,
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 3e0878a03b43d..532a4ea04c6e6 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -739,8 +739,8 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol);
 int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol);
 int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 				enum bcmgenet_power_mode mode);
-void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
-			       enum bcmgenet_power_mode mode);
+int bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
+			      enum bcmgenet_power_mode mode);
 
 void bcmgenet_eee_enable_set(struct net_device *dev, bool enable);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index d67f1cb14a800..945b32fe5697d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -227,14 +227,14 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	return 0;
 }
 
-void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
-			       enum bcmgenet_power_mode mode)
+int bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
+			      enum bcmgenet_power_mode mode)
 {
 	u32 reg;
 
 	if (mode != GENET_POWER_WOL_MAGIC) {
 		netif_err(priv, wol, priv->dev, "invalid mode: %d\n", mode);
-		return;
+		return -EINVAL;
 	}
 
 	clk_disable_unprepare(priv->clk_wol);
@@ -247,7 +247,7 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	if (priv->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE)) {
 		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
 		if (!(reg & MPD_EN))
-			return;	/* already reset so skip the rest */
+			return -EPERM;	/* already reset so skip the rest */
 		reg &= ~(MPD_EN | MPD_PW_EN);
 		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 	}
@@ -256,7 +256,7 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	if (priv->wolopts & WAKE_FILTER) {
 		reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
 		if (!(reg & RBUF_ACPI_EN))
-			return;	/* already reset so skip the rest */
+			return -EPERM;	/* already reset so skip the rest */
 		reg &= ~(RBUF_HFB_EN | RBUF_ACPI_EN);
 		bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
 	}
@@ -267,4 +267,6 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg &= ~CMD_CRC_FWD;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	spin_unlock_bh(&priv->reg_lock);
+
+	return 0;
 }
-- 
2.53.0



