Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F046A171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CC8C433EF;
	Mon, 22 May 2023 19:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783151;
	bh=7cp/UyRcXEVtKZ7hBztTmStjpxwfPTY6RctpJwepqbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9XYICizuhbw04PE9HFX9fxr7jYxm919ud1V72OzE0MBsOZWKxDcxaG7wpuzzj49p
	 d+K8hE9W40M9Vmx3fQ/57u5AqA1OALv05NSuXwsXCswJI9cXzzKI9gIuccURnRbLAL
	 ta8tr7aDdS270yKo+pKcWCYPnSWUi9wumuNT3MYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/203] net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()
Date: Mon, 22 May 2023 20:09:32 +0100
Message-Id: <20230522190359.066441634@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 93e0401e0fc0c54b0ac05b687cd135c2ac38187c ]

The call to phy_stop() races with the later call to phy_disconnect(),
resulting in concurrent phy_suspend() calls being run from different
CPUs. The final call to phy_disconnect() ensures that the PHY is
stopped and suspended, too.

Fixes: c96e731c93ff ("net: bcmgenet: connect and disconnect from the PHY state machine")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 92cd2916e8015..35bf840716d57 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3416,7 +3416,6 @@ static void bcmgenet_netif_stop(struct net_device *dev)
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
-	phy_stop(dev->phydev);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
-- 
2.39.2



