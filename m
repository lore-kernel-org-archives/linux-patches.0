Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5962F6A352;
	Mon,  8 Apr 2024 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582749; cv=none; b=WUJxwdszCghs7QQ1hJ/ZiLqBopMN9g0Wu7Az7FWDfH0WpOykxn02R+hmb2togICww4M2W9EjEF+77OP9kMCgWBVoie8vMiAmqSvezeb3c2BtHa6CfX8NOC9wg3WehATwyGkBAOWp695qp244KmOIrzrSvPSxGvTckZo3psoBov8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582749; c=relaxed/simple;
	bh=RVQFmo1KufOWlFjgh6jxAM3MQX3w7XwC/3RydgHWQM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otUCpp9AHSSdAeo2dkUigFvyATCfGZ9V5aaVYTB9nUKCOCEhglCCzg0RipyWq4Wmve5wx8mhVnI2+c1rOSAItkmCvDmrrIxUepTG+mjnMrjuGvxBr1CoEqodxdENO/EvSa4bOCa2FyYldI+XttpBOEsqCZsPXx6dnhGPLXNMaWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoBORV4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoBORV4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F7EC433C7;
	Mon,  8 Apr 2024 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582749;
	bh=RVQFmo1KufOWlFjgh6jxAM3MQX3w7XwC/3RydgHWQM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoBORV4xkKqvw/TD1hpDnu7bPDxclXMq06ZGDr547QCE6rHXdXJ4+5lCWcNwtXga3
	 muYGMlTG+bz3WxnGN4Gd1gNYidM2TAki+fDucfYPBmmXCkZ9A99wk3QNcff5D1QqXn
	 NFlXfB79vIKl9SvA63JQQmAxGMZCbAt7i6Tzycw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Divya Koppera <divya.koppera@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 102/273] net: phy: micrel: lan8814: Fix when enabling/disabling 1-step timestamping
Date: Mon,  8 Apr 2024 14:56:17 +0200
Message-ID: <20240408125312.478026376@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

commit de99e1ea3a35f23ff83a31d6b08f43d27b2c6345 upstream.

There are 2 issues with the blamed commit.
1. When the phy is initialized, it would enable the disabled of UDPv4
   checksums. The UDPv6 checksum is already enabled by default. So when
   1-step is configured then it would clear these flags.
2. After the 1-step is configured, then if 2-step is configured then the
   1-step would be still configured because it is not clearing the flag.
   So the sync frames will still have origin timestamps set.

Fix this by reading first the value of the register and then
just change bit 12 as this one determines if the timestamp needs to
be inserted in the frame, without changing any other bits.

Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Divya Koppera <divya.koppera@microchip.com>
Link: https://lore.kernel.org/r/20240402071634.2483524-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2416,6 +2416,7 @@ static int lan8814_hwtstamp(struct mii_t
 	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
 	int txcfg = 0, rxcfg = 0;
 	int pkt_ts_enable;
+	int tx_mod;
 
 	ptp_priv->hwts_tx_type = config->tx_type;
 	ptp_priv->rx_filter = config->rx_filter;
@@ -2462,9 +2463,14 @@ static int lan8814_hwtstamp(struct mii_t
 	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_RX_TIMESTAMP_EN, pkt_ts_enable);
 	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_TIMESTAMP_EN, pkt_ts_enable);
 
-	if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ONESTEP_SYNC)
+	tx_mod = lanphy_read_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD);
+	if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ONESTEP_SYNC) {
 		lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
-				      PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+				      tx_mod | PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+	} else if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ON) {
+		lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
+				      tx_mod & ~PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+	}
 
 	if (config->rx_filter != HWTSTAMP_FILTER_NONE)
 		lan8814_config_ts_intr(ptp_priv->phydev, true);


