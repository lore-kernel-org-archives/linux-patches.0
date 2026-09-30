Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BA4371049;
	Wed, 30 Sep 2026 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796863; cv=none; b=gYazlKGL3+DcZ9bMraKB4Li621MZr8wCsc8wFGclhPbKOpNbQ0F/SPUNa6KWZE4IkumOIlXVw9+5EFml8xALtAuxjBwuMtWb4sK09sv0GLZZCHNE5X/oI3mthUxWsbWJPtpxbs9jKys/32uoAUDFFb4CrNO0guSQftS/VNYLJqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796863; c=relaxed/simple;
	bh=LJMYoErFlYdKAXJ49HU/dPb7B6wl+Y1UsRSkqcvu/1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVqHimGO4BYTCDfoYx1rjwaZHz+Qj2Pd4urpOhe4pgYjnuLFbL9wghIucXb6o33Q78pYOHVb31+AoWVdPqBcI6NlPGLtE9ucOM/SpIjE2ecC7Ath8h2zuAUMrXWxv9UsT/pmPRKYVm7W+nxj+XUWqiykDX8fRctPAnPsPCRrg/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0dUOzf/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0dUOzf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19271F000FF;
	Wed, 30 Sep 2026 19:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796862;
	bh=nBuOMJsmc8TXhP/Q2JZ6qyR/3xGnp8ju92gXg42UYFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0dUOzf/dPc8+03csoX9/dqHpw4+W6s7L4MnVzbZNgaQ1Hb36ierRwQb6kYqAeQ1J
	 oiKUns3kCAz4bo9GuWCnRRqw6hOv9VnK0ozXkaU9GcRvBb5+OSP5pNdyLeJ8+ON8dw
	 OLjZjW6rO2Feo10NYReaAXTRkuDVzm1CnOkmwlcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1064/1193] net: bcmgenet: allow return of power up status
Date: Wed, 30 Sep 2026 17:29:08 +0200
Message-ID: <20260930152457.864436218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 24689433c8725..8f041b9b0bc41 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1702,13 +1702,14 @@ static int bcmgenet_power_down(struct bcmgenet_priv *priv,
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
 
@@ -1744,11 +1745,13 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
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
index bbbb4f317f9e0..5f0cf8f1f634d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -741,8 +741,8 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol);
 int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol);
 int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 				enum bcmgenet_power_mode mode);
-void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
-			       enum bcmgenet_power_mode mode);
+int bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
+			      enum bcmgenet_power_mode mode);
 
 void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
 			     bool tx_lpi_enabled);
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



