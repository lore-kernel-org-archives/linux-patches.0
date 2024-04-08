Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDCB2DF73;
	Mon,  8 Apr 2024 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581750; cv=none; b=Qz0W2Oy6jlmGsSrYfXzD49Q1o2VKsMGTI+qkwoYzeqJ56qPd/4uc+Jm92W74eGIayKecJ4Z0+1BIiz9wreZECTKMKWg3+8gv10KavcgBDP8buLjvERmQvTODLOrSTwEB+gKCxBE+xEYaO9L64g/QfzYy/BEi0Rhfv4fTZNcreLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581750; c=relaxed/simple;
	bh=fb7NgpMy6iuFTlBy8I7m1qCYZtBOiUG0pDR1WttjJuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMUuUQ9JPEhLDu2J/czXPogbIqNBwHXPPCZheBqX8wIGSi+8SjosrnP00mnsSyTRZ/fS8QNVVoGqV48LpHvi5/txvt+3IUyxz/orbmCe3eDJzbbUjukJbllpVnzOPESRVSH6TdeIHe8t0F6M1yE7RaNjiCmyFtU7Lls1IqsI8yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCnCPLKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCnCPLKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8762C433F1;
	Mon,  8 Apr 2024 13:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581750;
	bh=fb7NgpMy6iuFTlBy8I7m1qCYZtBOiUG0pDR1WttjJuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCnCPLKNABfVI3JlkU7e1PZgW0efX8QI3Spfq4csJ4PX3k2AmdcIhAC9wP0w2mLiO
	 zIFy2TNjoVDl2Q/x7DSErv16dKZ/6GWctE2lJJJc6df7N4NNlaYP8914xccjX2v0v4
	 V2TOeHQ1aEPCD9iP8hwnFxSPcpC03gl4e/ieNi9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Divya Koppera <divya.koppera@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 049/138] net: phy: micrel: lan8814: Fix when enabling/disabling 1-step timestamping
Date: Mon,  8 Apr 2024 14:57:43 +0200
Message-ID: <20240408125257.752523073@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2188,6 +2188,7 @@ static int lan8814_hwtstamp(struct mii_t
 	struct hwtstamp_config config;
 	int txcfg = 0, rxcfg = 0;
 	int pkt_ts_enable;
+	int tx_mod;
 
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
@@ -2237,9 +2238,14 @@ static int lan8814_hwtstamp(struct mii_t
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
 
 	if (config.rx_filter != HWTSTAMP_FILTER_NONE)
 		lan8814_config_ts_intr(ptp_priv->phydev, true);


