Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D3C7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FA2C433D7;
	Wed,  2 Nov 2022 03:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358444;
	bh=4P4cTZv/MZhRvVklFvwJ3BF4fz3KKXU3dq57Z9HKQr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXmOlY1X9YDi+1mVmtlmODMQ0Ck8nt5TzDbExM1sgqA8cJn7EkJRwp5x7XoipIQVw
	 FHyvNv6naVDNCMN1IGYsN9IfyarXnNisAznOC1EHfvRBkVpqBydQ0DM9txANCoiquY
	 7UOGK+/FisKvoEFmlzYWIf4Sq/hKxC+QuznCUUyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergiu Moga <sergiu.moga@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/132] net: macb: Specify PHY PM management done by MAC
Date: Wed,  2 Nov 2022 03:33:00 +0100
Message-Id: <20221102022101.556401124@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergiu Moga <sergiu.moga@microchip.com>

[ Upstream commit 15a9dbec631cd69dfbbfc4e2cbf90c9dd8432a8f ]

The `macb_resume`/`macb_suspend` methods already call the
`phylink_start`/`phylink_stop` methods during their execution so
explicitly say that the PM of the PHY is done by MAC by using the
`mac_managed_pm` flag of the `struct phylink_config`.

This also fixes the warning message issued during resume:
WARNING: CPU: 0 PID: 237 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0x144/0x148

Depends-on: 96de900ae78e ("net: phylink: add mac_managed_pm in phylink_config structure")
Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Sergiu Moga <sergiu.moga@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221019120929.63098-1-sergiu.moga@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 3ca3f9d0fd9b..61efb2350412 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -880,6 +880,7 @@ static int macb_mii_probe(struct net_device *dev)
 
 	bp->phylink_config.dev = &dev->dev;
 	bp->phylink_config.type = PHYLINK_NETDEV;
+	bp->phylink_config.mac_managed_pm = true;
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		bp->phylink_config.poll_fixed_state = true;
-- 
2.35.1



