Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9686F08E;
	Mon,  8 Apr 2024 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581767; cv=none; b=IUJC5zofkAaAcKeFqHFE1gMwYrNa4F3aabS14aPpaQ0UU8nJVnJ86RMHSrJruQf7nAbepsoyXWh/t5XtLod8lZ+GH9uHV92GbS3KGLupmCESSRclWnZiOC6PlmVPQ0mJBCadi0CNB7Ynu3UVtpCe21ncQ8bW8uZoq+QAUcHDvIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581767; c=relaxed/simple;
	bh=UjpL3h4kzRSyjfbx60qv0kSkByarW7pzLum+ddBs1yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp7qnJyoIPPWqFb9V3deJF4LJiHqgLL0+7eaZQenUyVZ1tq1JmtOtjOpXCV0ZbMNq+9IaxaHt+cdGWivBoIH7xiqNsQkBRXjPDBEPpwUaseMErskvmt7Pgprw8I54Fziy5/j6J2MogC++bsD/j0RvR3JD/RW/0HtnzEJfwPx1yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GN/fKF6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GN/fKF6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37371C433F1;
	Mon,  8 Apr 2024 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581767;
	bh=UjpL3h4kzRSyjfbx60qv0kSkByarW7pzLum+ddBs1yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GN/fKF6C3aXV3LxjnJtPHozMuWyUPd7hMgYZa+Xa4NX4ML7EFEMq5Hyz5s1bI+Bi5
	 bZK7D+mM4762b2XdTlmhaqqy+vLEb9NNW1Lfv8CXj5rUJc+gx72T5CusZGU+qL3P+b
	 e/FLhBcjommUSyCap4Uvnxs4f1VayZS6QsuySHuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/252] net: bcmasp: Bring up unimac after PHY link up
Date: Mon,  8 Apr 2024 14:55:37 +0200
Message-ID: <20240408125307.823426302@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit dfd222e2aef68818320a57b13a1c52a44c22bc80 ]

The unimac requires the PHY RX clk during reset or it may be put
into a bad state. Bring up the unimac after link up to ensure the
PHY RX clk exists.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/asp2/bcmasp_intf.c  | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 9cae5a3090000..b3d04f49f77e9 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -391,7 +391,9 @@ static void umac_reset(struct bcmasp_intf *intf)
 	umac_wl(intf, 0x0, UMC_CMD);
 	umac_wl(intf, UMC_CMD_SW_RESET, UMC_CMD);
 	usleep_range(10, 100);
-	umac_wl(intf, 0x0, UMC_CMD);
+	/* We hold the umac in reset and bring it out of
+	 * reset when phy link is up.
+	 */
 }
 
 static void umac_set_hw_addr(struct bcmasp_intf *intf,
@@ -411,6 +413,8 @@ static void umac_enable_set(struct bcmasp_intf *intf, u32 mask,
 	u32 reg;
 
 	reg = umac_rl(intf, UMC_CMD);
+	if (reg & UMC_CMD_SW_RESET)
+		return;
 	if (enable)
 		reg |= mask;
 	else
@@ -429,7 +433,6 @@ static void umac_init(struct bcmasp_intf *intf)
 	umac_wl(intf, 0x800, UMC_FRM_LEN);
 	umac_wl(intf, 0xffff, UMC_PAUSE_CNTRL);
 	umac_wl(intf, 0x800, UMC_RX_MAX_PKT_SZ);
-	umac_enable_set(intf, UMC_CMD_PROMISC, 1);
 }
 
 static int bcmasp_tx_poll(struct napi_struct *napi, int budget)
@@ -656,6 +659,12 @@ static void bcmasp_adj_link(struct net_device *dev)
 			UMC_CMD_HD_EN | UMC_CMD_RX_PAUSE_IGNORE |
 			UMC_CMD_TX_PAUSE_IGNORE);
 		reg |= cmd_bits;
+		if (reg & UMC_CMD_SW_RESET) {
+			reg &= ~UMC_CMD_SW_RESET;
+			umac_wl(intf, reg, UMC_CMD);
+			udelay(2);
+			reg |= UMC_CMD_TX_EN | UMC_CMD_RX_EN | UMC_CMD_PROMISC;
+		}
 		umac_wl(intf, reg, UMC_CMD);
 
 		intf->eee.eee_active = phy_init_eee(phydev, 0) >= 0;
@@ -1061,9 +1070,6 @@ static int bcmasp_netif_init(struct net_device *dev, bool phy_connect)
 
 	umac_init(intf);
 
-	/* Disable the UniMAC RX/TX */
-	umac_enable_set(intf, (UMC_CMD_RX_EN | UMC_CMD_TX_EN), 0);
-
 	umac_set_hw_addr(intf, dev->dev_addr);
 
 	intf->old_duplex = -1;
@@ -1083,9 +1089,6 @@ static int bcmasp_netif_init(struct net_device *dev, bool phy_connect)
 
 	bcmasp_enable_rx(intf, 1);
 
-	/* Turn on UniMAC TX/RX */
-	umac_enable_set(intf, (UMC_CMD_RX_EN | UMC_CMD_TX_EN), 1);
-
 	intf->crc_fwd = !!(umac_rl(intf, UMC_CMD) & UMC_CMD_CRC_FWD);
 
 	bcmasp_netif_start(dev);
@@ -1321,7 +1324,14 @@ static void bcmasp_suspend_to_wol(struct bcmasp_intf *intf)
 	if (intf->wolopts & WAKE_FILTER)
 		bcmasp_netfilt_suspend(intf);
 
-	/* UniMAC receive needs to be turned on */
+	/* Bring UniMAC out of reset if needed and enable RX */
+	reg = umac_rl(intf, UMC_CMD);
+	if (reg & UMC_CMD_SW_RESET)
+		reg &= ~UMC_CMD_SW_RESET;
+
+	reg |= UMC_CMD_RX_EN | UMC_CMD_PROMISC;
+	umac_wl(intf, reg, UMC_CMD);
+
 	umac_enable_set(intf, UMC_CMD_RX_EN, 1);
 
 	if (intf->parent->wol_irq > 0) {
-- 
2.43.0



