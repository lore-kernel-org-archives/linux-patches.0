Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8061D555;
	Thu, 23 May 2024 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470137; cv=none; b=JGiwFFWh6VRJxHJnzng1grAjiFzufcdCcBSTRoHfCk7dzUWRVI9+/6VG7E/ltQlpZtIpvlpoZb0Gq2f1GmWIqlw1oKl42iqsyQFaj4SOM5UBvrp7G7rWbThZjRwGVBj47cLbWLTOg+8dt+mLE/CtMxXhmBVcHyqRO/+avyGihqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470137; c=relaxed/simple;
	bh=iKpOEsP4JjfEQxPaT32spThVI9+cvczTDbmbH1D/WSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrLbadSX78DN1CrYSo7z65p8lwlg43hriRJYB/256ecwvbL7MJUcmJMWx8dmoLHJe2DpyUkOi5TvnYTW6qPGFV48t1EriwUZUqHp+yzM9q+hMsm09PFXetcj2Shyw6G6TVgPhrTInum67FEF0PK3NaHF6aFDz3WlmOU2wht6iUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/sN1ba6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/sN1ba6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDF7C2BD10;
	Thu, 23 May 2024 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470137;
	bh=iKpOEsP4JjfEQxPaT32spThVI9+cvczTDbmbH1D/WSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/sN1ba6886DvDLePtNEW/0BwVAqspDZpPfdtDz9BjS/Yh5hgzTDNeBUvth78UHN8
	 YpiIL65vVBEcQK02JyYVCThMPKjDgTYiAo1J8BP0oavbWXbej0br+vO08P0xYhdCAn
	 /DyHgRFFk+hGEJmJXg3RKS4vfWhm95XAsVZMQN4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 05/16] net: bcmgenet: keep MAC in reset until PHY is up
Date: Thu, 23 May 2024 15:12:38 +0200
Message-ID: <20240523130325.948607425@linuxfoundation.org>
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

commit 88f6c8bf1aaed5039923fb4c701cab4d42176275 upstream.

As noted in commit 28c2d1a7a0bf ("net: bcmgenet: enable loopback
during UniMAC sw_reset") the UniMAC must be clocked at least 5
cycles while the sw_reset is asserted to ensure a clean reset.

That commit enabled local loopback to provide an Rx clock from the
GENET sourced Tx clk. However, when connected in MII mode the Tx
clk is sourced by the PHY so if an EPHY is not supplying clocks
(e.g. when the link is down) the UniMAC does not receive the
necessary clocks.

This commit extends the sw_reset window until the PHY reports that
the link is up thereby ensuring that the clocks are being provided
to the MAC to produce a clean reset.

One consequence is that if the system attempts to enter a Wake on
LAN suspend state when the PHY link has not been active the MAC
may not have had a chance to initialize cleanly. In this case, we
remove the sw_reset and enable the WoL reception path as normal
with the hope that the PHY will provide the necessary clocks to
drive the WoL blocks if the link becomes active after the system
has entered suspend.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   10 ++++------
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 +++++-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |    6 ++++++
 3 files changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1991,6 +1991,8 @@ static void umac_enable_set(struct bcmge
 	u32 reg;
 
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET)
+		return;
 	if (enable)
 		reg |= mask;
 	else
@@ -2010,13 +2012,9 @@ static void reset_umac(struct bcmgenet_p
 	bcmgenet_rbuf_ctrl_set(priv, 0);
 	udelay(10);
 
-	/* disable MAC while updating its registers */
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
-
-	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
-	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
+	/* issue soft reset and disable MAC while updating its registers */
+	bcmgenet_umac_writel(priv, CMD_SW_RESET, UMAC_CMD);
 	udelay(2);
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -132,8 +132,12 @@ int bcmgenet_wol_power_down_cfg(struct b
 		return -EINVAL;
 	}
 
-	/* disable RX */
+	/* Can't suspend with WoL if MAC is still in reset */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET)
+		reg &= ~CMD_SW_RESET;
+
+	/* disable RX */
 	reg &= ~CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	mdelay(10);
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -96,6 +96,12 @@ void bcmgenet_mii_setup(struct net_devic
 			       CMD_HD_EN |
 			       CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE);
 		reg |= cmd_bits;
+		if (reg & CMD_SW_RESET) {
+			reg &= ~CMD_SW_RESET;
+			bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+			udelay(2);
+			reg |= CMD_TX_EN | CMD_RX_EN;
+		}
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
 		priv->eee.eee_active = phy_init_eee(phydev, 0) >= 0;


