Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120FD15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A234C433D6;
	Mon,  5 Dec 2022 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269009;
	bh=Enxqx8+ccmEv18hAD0KdaAuJunF98ysrY9pe8XuVPCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9L5uYHseKh3ELJLJ/cDV4zDrEkBAr0MvjABUzb9rDoqJ/5Yiv5IQdZbwff3r7GQ2
	 MzijEYr8cZfqCoI+thMsU2qRRGPMp/mYt7qxXRzjWX67Xgmxw3OXw3t4VM8HCrCr/U
	 CzG8k6lrFiqcvtFDDRwxKTTwaVqIjlERvjJ7ihts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Goh, Wei Sheng" <wei.sheng.goh@intel.com>,
	Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Goh
Subject: [PATCH 5.15 075/120] net: stmmac: Set MACs flow control register to reflect current settings
Date: Mon,  5 Dec 2022 20:10:15 +0100
Message-Id: <20221205190808.867755796@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Goh, Wei Sheng <wei.sheng.goh@intel.com>

commit cc3d2b5fc0d6f8ad8a52da5ea679e5c2ec2adbd4 upstream.

Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
is issued. This fix ensures the flow control change is reflected directly
in the GMAC_RX_FLOW_CTRL_RFE register.

Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -745,6 +745,8 @@ static void dwmac4_flow_ctrl(struct mac_
 	if (fc & FLOW_RX) {
 		pr_debug("\tReceive Flow-Control ON\n");
 		flow |= GMAC_RX_FLOW_CTRL_RFE;
+	} else {
+		pr_debug("\tReceive Flow-Control OFF\n");
 	}
 	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
 
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1158,8 +1158,16 @@ static void stmmac_mac_link_up(struct ph
 		ctrl |= priv->hw->link.duplex;
 
 	/* Flow Control operation */
-	if (tx_pause && rx_pause)
-		stmmac_mac_flow_ctrl(priv, duplex);
+	if (rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_AUTO;
+	else if (rx_pause && !tx_pause)
+		priv->flow_ctrl = FLOW_RX;
+	else if (!rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_TX;
+	else
+		priv->flow_ctrl = FLOW_OFF;
+
+	stmmac_mac_flow_ctrl(priv, duplex);
 
 	if (ctrl != old_ctrl)
 		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);


