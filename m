Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2041D555;
	Thu, 23 May 2024 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470134; cv=none; b=CrAA4lfRGH7cc4XuieT+oQ4sLjpv62LOFV37GQd5ZgW0OhcEFlDO/Lde1IwmI86EZjp6027yhSvM+MMtM//OW798odkxSqg2gLC8dhcI+Fuq/k7x2XPRb5ni0SkU+Td5H1cDfaOozd0rSQKZfGLSd6WYCMC6R2SJsrnnf2CBDQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470134; c=relaxed/simple;
	bh=DRZs6rje9UHn0c2to7AH2OUhiFf+MgxFPWxzdaCords=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWeoWkXJNSb/LZIKmAx/ab2ThS5VYn9gR7E5F1jKm3p5Px3hxSLFeOmAry6oAdClN3fElMk05XW//WBwfh/mBU2SPLwV3MhOgzpXkKh81aa4b3ECFH+POZQFM/hqI2z+1G60R+JvmghHvPpwRvuIHyywz6enTxx5vuFYEQ3IaTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f39D6IRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f39D6IRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9196C32781;
	Thu, 23 May 2024 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470134;
	bh=DRZs6rje9UHn0c2to7AH2OUhiFf+MgxFPWxzdaCords=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f39D6IRD0Z/pIVQCUnjJ58Bncd7ZzPXl39oKdN4qqs6dD26BBSK4ApC9rvyPlUUcl
	 sjou8imvi5MRfS8NipM1kwBPRP1K0Ss/C6pnlYIDSTEPlO+JyibobNCoVB0YVBNYdy
	 nndAnmy/bgo5CMvhrvjbZXvLB5H5KmB0Znfx6xmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 04/16] Revert "net: bcmgenet: use RGMII loopback for MAC reset"
Date: Thu, 23 May 2024 15:12:37 +0200
Message-ID: <20240523130325.911651523@linuxfoundation.org>
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

commit 612eb1c3b9e504de24136c947ed7c07bc342f3aa upstream.

This reverts commit 3a55402c93877d291b0a612d25edb03d1b4b93ac.

This is not a good solution when connecting to an external switch
that may not support the isolation of the TXC signal resulting in
output driver contention on the pin.

A different solution is necessary.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Adjusted to accommodate lack of commit 4f8d81b77e66]
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    2 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c   |   33 -------------------------
 2 files changed, 2 insertions(+), 33 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2015,6 +2015,8 @@ static void reset_umac(struct bcmgenet_p
 
 	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
 	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
+	udelay(2);
+	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -187,38 +187,8 @@ int bcmgenet_mii_config(struct net_devic
 	const char *phy_name = NULL;
 	u32 id_mode_dis = 0;
 	u32 port_ctrl;
-	int bmcr = -1;
-	int ret;
 	u32 reg;
 
-	/* MAC clocking workaround during reset of umac state machines */
-	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	if (reg & CMD_SW_RESET) {
-		/* An MII PHY must be isolated to prevent TXC contention */
-		if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
-			ret = phy_read(phydev, MII_BMCR);
-			if (ret >= 0) {
-				bmcr = ret;
-				ret = phy_write(phydev, MII_BMCR,
-						bmcr | BMCR_ISOLATE);
-			}
-			if (ret) {
-				netdev_err(dev, "failed to isolate PHY\n");
-				return ret;
-			}
-		}
-		/* Switch MAC clocking to RGMII generated clock */
-		bcmgenet_sys_writel(priv, PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
-		/* Ensure 5 clks with Rx disabled
-		 * followed by 5 clks with Reset asserted
-		 */
-		udelay(4);
-		reg &= ~(CMD_SW_RESET | CMD_LCL_LOOP_EN);
-		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
-		/* Ensure 5 more clocks before Rx is enabled */
-		udelay(2);
-	}
-
 	priv->ext_phy = !priv->internal_phy &&
 			(priv->phy_interface != PHY_INTERFACE_MODE_MOCA);
 
@@ -250,9 +220,6 @@ int bcmgenet_mii_config(struct net_devic
 		phy_set_max_speed(phydev, SPEED_100);
 		bcmgenet_sys_writel(priv,
 				    PORT_MODE_EXT_EPHY, SYS_PORT_CTRL);
-		/* Restore the MII PHY after isolation */
-		if (bmcr >= 0)
-			phy_write(phydev, MII_BMCR, bmcr);
 		break;
 
 	case PHY_INTERFACE_MODE_REVMII:


