Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AB32AE94;
	Thu, 23 May 2024 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470323; cv=none; b=Igg8FBbb3uyNwN/fMm0W7NnhlrpwXpqMUnNWR7Zkgb9TRrb7flF3tQU3vWJCT/H0MOJ/z5EvzEyyehXieNtnSBhll2enErjRdevnJ3Rk1u+vmQmCxRWA4Kfo4k5muKrXNpNfwgyf5M5j4RbMXecykU3d4EyKeL/LJuBcBdeSCWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470323; c=relaxed/simple;
	bh=iErxtoDxp8LmuDORn28njsyzVyp08ESEdMx6kd/aMic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi0iI1ZWrt01xnn9uZoOLSn8kbfNvLFDwiPGIdiqSUWZe+yFqWfNn9jtNbQiRPbLzRrYY0pncr8UfumR06JaH/CNQznXqL+N8IknzHdx/wkJADXzHM86/ogXqByzCh0o+rxykOT3yKDBGgAN6Fn47c5SCi2CI+XfRGGjE0Q0whM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFoXiBjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFoXiBjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF2AC2BD10;
	Thu, 23 May 2024 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470323;
	bh=iErxtoDxp8LmuDORn28njsyzVyp08ESEdMx6kd/aMic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFoXiBjf8LsEJkycRnIcQlWsa+4cCtbNyl1HGpcBNQLUbHKI/b008363Y46V76E7k
	 l3TZTaXz8VQmQEpEuyNJW9au1bc+6U8D2gjMsJ3u5QOO2za3T2BL9KvaO3RxB4ogBd
	 DMsIghtyd4qYlXAvpCz+Px+c/HwmfpAeNOYCLvi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 07/23] net: bcmgenet: synchronize UMAC_CMD access
Date: Thu, 23 May 2024 15:13:03 +0200
Message-ID: <20240523130328.232362736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2424,14 +2424,18 @@ static void umac_enable_set(struct bcmge
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
@@ -2447,8 +2451,10 @@ static void reset_umac(struct bcmgenet_p
 	udelay(10);
 
 	/* issue soft reset and disable MAC while updating its registers */
+	spin_lock_bh(&priv->reg_lock);
 	bcmgenet_umac_writel(priv, CMD_SW_RESET, UMAC_CMD);
 	udelay(2);
+	spin_unlock_bh(&priv->reg_lock);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
@@ -3576,16 +3582,19 @@ static void bcmgenet_set_rx_mode(struct
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
@@ -3979,6 +3988,7 @@ static int bcmgenet_probe(struct platfor
 		goto err;
 	}
 
+	spin_lock_init(&priv->reg_lock);
 	spin_lock_init(&priv->lock);
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -572,6 +572,8 @@ struct bcmgenet_rxnfc_rule {
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
 
 	if (priv->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE)) {
@@ -185,6 +187,7 @@ int bcmgenet_wol_power_down_cfg(struct b
 	}
 
 	/* Enable CRC forward */
+	spin_lock_bh(&priv->reg_lock);
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = 1;
 	reg |= CMD_CRC_FWD;
@@ -192,6 +195,7 @@ int bcmgenet_wol_power_down_cfg(struct b
 	/* Receiver must be enabled for WOL MP detection */
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	spin_unlock_bh(&priv->reg_lock);
 
 	reg = UMAC_IRQ_MPD_R;
 	if (hfb_enable)
@@ -238,7 +242,9 @@ void bcmgenet_wol_power_up_cfg(struct bc
 	}
 
 	/* Disable CRC Forward */
+	spin_lock_bh(&priv->reg_lock);
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	spin_unlock_bh(&priv->reg_lock);
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


