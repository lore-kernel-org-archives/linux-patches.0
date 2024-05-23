Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2061D52D;
	Thu, 23 May 2024 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470146; cv=none; b=Bn0LS3WLT47RZ8+vDIK+WWh9eaJQ7t4wn2NR60HPmntuoTtWA6yA64L+tRloZEYAIM/dTdcRR8i2AO6c+lI7hsjT17z9ln7p03he8lpCWiQXQWU12JUj3jR9KpLC+f+7BXTQYnuSMJy/J39/8SiBsU3o6nL5q8op4/W07FBiLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470146; c=relaxed/simple;
	bh=exfcqu3Y+++IZE6eH6/3RPN7L+4ZQEzB7BMUXLEyK5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDQ28c/ix+65o36FssGWFRsTTUlU48sYndEOZlH+l3+hU+DeZN5Fq6EyMRKRpihZD4dvra0Bx6v98a39bqswV8LiwuGDIWqnn8+8U8Y7mzb6cADB+ZdpkYWEFpUyMtgWFn7miAU6aihXUFJFbwCqXeVODRp2ZRw1A59eT4Y23Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPr+3DfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPr+3DfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442A0C2BD10;
	Thu, 23 May 2024 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470145;
	bh=exfcqu3Y+++IZE6eH6/3RPN7L+4ZQEzB7BMUXLEyK5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPr+3DfV9TriTOzjcBLuDyrdNL08BUADVQER4zkIQ7trfPcjEsIxVE4fZOuvIFema
	 3EomWy1/Hd1Tr46JVbtNPhqYbJCwygpQwZkx+2i29kgvIB2VVauSjdtrSN8TZagy4/
	 7fMQbTJl14uZDapMr0wKME/cso9bExfymClEEb7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 08/16] net: bcmgenet: synchronize UMAC_CMD access
Date: Thu, 23 May 2024 15:12:41 +0200
Message-ID: <20240523130326.062490292@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit 0d5e2a82232605b337972fb2c7d0cbc46898aca1 upstream.

The UMAC_CMD register is written from different execution
contexts and has insufficient synchronization protections to
prevent possible corruption. Of particular concern are the
acceses from the phy_device delayed work context used by the
adjust_link call and the BH context that may be used by the
ndo_set_rx_mode call.

A spinlock is added to the driver to protect contended register
accesses (i.e. reg_lock) and it is used to synchronize accesses
to UMAC_CMD.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Cc: stable@vger.kernel.org
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   12 +++++++++++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |    2 ++
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 ++++++
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |    2 ++
 4 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1990,14 +1990,18 @@ static void umac_enable_set(struct bcmge
 {
 	u32 reg;
 
+	spin_lock_bh(&priv->reg_lock);
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	if (reg & CMD_SW_RESET)
+	if (reg & CMD_SW_RESET) {
+		spin_unlock_bh(&priv->reg_lock);
 		return;
+	}
 	if (enable)
 		reg |= mask;
 	else
 		reg &= ~mask;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	spin_unlock_bh(&priv->reg_lock);
 
 	/* UniMAC stops on a packet boundary, wait for a full-size packet
 	 * to be processed
@@ -2013,8 +2017,10 @@ static void reset_umac(struct bcmgenet_p
 	udelay(10);
 
 	/* issue soft reset and disable MAC while updating its registers */
+	spin_lock_bh(&priv->reg_lock);
 	bcmgenet_umac_writel(priv, CMD_SW_RESET, UMAC_CMD);
 	udelay(2);
+	spin_unlock_bh(&priv->reg_lock);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
@@ -3148,16 +3154,19 @@ static void bcmgenet_set_rx_mode(struct
 	 * 3. The number of filters needed exceeds the number filters
 	 *    supported by the hardware.
 	*/
+	spin_lock(&priv->reg_lock);
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	if ((dev->flags & (IFF_PROMISC | IFF_ALLMULTI)) ||
 	    (nfilter > MAX_MDF_FILTER)) {
 		reg |= CMD_PROMISC;
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+		spin_unlock(&priv->reg_lock);
 		bcmgenet_umac_writel(priv, 0, UMAC_MDF_CTRL);
 		return;
 	} else {
 		reg &= ~CMD_PROMISC;
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+		spin_unlock(&priv->reg_lock);
 	}
 
 	/* update MDF filter */
@@ -3515,6 +3524,7 @@ static int bcmgenet_probe(struct platfor
 		goto err;
 	}
 
+	spin_lock_init(&priv->reg_lock);
 	spin_lock_init(&priv->lock);
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -608,6 +608,8 @@ struct bcmgenet_rx_ring {
 /* device context */
 struct bcmgenet_priv {
 	void __iomem *base;
+	/* reg_lock: lock to serialize access to shared registers */
+	spinlock_t reg_lock;
 	enum bcmgenet_version version;
 	struct net_device *dev;
 
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -133,6 +133,7 @@ int bcmgenet_wol_power_down_cfg(struct b
 	}
 
 	/* Can't suspend with WoL if MAC is still in reset */
+	spin_lock_bh(&priv->reg_lock);
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	if (reg & CMD_SW_RESET)
 		reg &= ~CMD_SW_RESET;
@@ -140,6 +141,7 @@ int bcmgenet_wol_power_down_cfg(struct b
 	/* disable RX */
 	reg &= ~CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	spin_unlock_bh(&priv->reg_lock);
 	mdelay(10);
 
 	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
@@ -163,6 +165,7 @@ int bcmgenet_wol_power_down_cfg(struct b
 		  retries);
 
 	/* Enable CRC forward */
+	spin_lock_bh(&priv->reg_lock);
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = 1;
 	reg |= CMD_CRC_FWD;
@@ -170,6 +173,7 @@ int bcmgenet_wol_power_down_cfg(struct b
 	/* Receiver must be enabled for WOL MP detection */
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	spin_unlock_bh(&priv->reg_lock);
 
 	return 0;
 }
@@ -191,8 +195,10 @@ void bcmgenet_wol_power_up_cfg(struct bc
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
 	/* Disable CRC Forward */
+	spin_lock_bh(&priv->reg_lock);
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	spin_unlock_bh(&priv->reg_lock);
 	priv->crc_fwd_en = 0;
 }
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -91,6 +91,7 @@ void bcmgenet_mii_setup(struct net_devic
 		reg |= RGMII_LINK;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 
+		spin_lock_bh(&priv->reg_lock);
 		reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 		reg &= ~((CMD_SPEED_MASK << CMD_SPEED_SHIFT) |
 			       CMD_HD_EN |
@@ -103,6 +104,7 @@ void bcmgenet_mii_setup(struct net_devic
 			reg |= CMD_TX_EN | CMD_RX_EN;
 		}
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+		spin_unlock_bh(&priv->reg_lock);
 
 		priv->eee.eee_active = phy_init_eee(phydev, 0) >= 0;
 		bcmgenet_eee_enable_set(dev,


