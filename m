Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56350171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B190FC433D2;
	Mon, 22 May 2023 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783185;
	bh=oxIQdb45YaHBKc8ZszgHUls+KoUTjRerowhu8rQLo7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS1wdrpLcxk3j/SJT7jz+07o8toV2/e6bAAT3irMabVaQzZS2CwEsyqTs5eRp/WKX
	 n4aLQer84k6FoPx331BVnzM3bwEwHv1J2JM15iaYr/f/BsqidkoYI1v+bBG951a2jf
	 RWOyi5UHwZG0xjgK7anG5pnZvr+UDCJuBGfWvctg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/203] net: bcmgenet: Restore phy_stop() depending upon suspend/close
Date: Mon, 22 May 2023 20:09:33 +0100
Message-Id: <20230522190359.094735739@linuxfoundation.org>
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

[ Upstream commit 225c657945c4a6307741cb3cc89467eadcc26e9b ]

Removing the phy_stop() from bcmgenet_netif_stop() ended up causing
warnings from the PHY library that phy_start() is called from the
RUNNING state since we are no longer stopping the PHY state machine
during bcmgenet_suspend().

Restore the call to phy_stop() but make it conditional on being called
from the close or suspend path.

Fixes: c96e731c93ff ("net: bcmgenet: connect and disconnect from the PHY state machine")
Fixes: 93e0401e0fc0 ("net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230515025608.2587012-1-f.fainelli@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 35bf840716d57..9d4f406408c9d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3401,7 +3401,7 @@ static int bcmgenet_open(struct net_device *dev)
 	return ret;
 }
 
-static void bcmgenet_netif_stop(struct net_device *dev)
+static void bcmgenet_netif_stop(struct net_device *dev, bool stop_phy)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
@@ -3416,6 +3416,8 @@ static void bcmgenet_netif_stop(struct net_device *dev)
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
+	if (stop_phy)
+		phy_stop(dev->phydev);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
@@ -3441,7 +3443,7 @@ static int bcmgenet_close(struct net_device *dev)
 
 	netif_dbg(priv, ifdown, dev, "bcmgenet_close\n");
 
-	bcmgenet_netif_stop(dev);
+	bcmgenet_netif_stop(dev, false);
 
 	/* Really kill the PHY state machine and disconnect from it */
 	phy_disconnect(dev->phydev);
@@ -4241,7 +4243,7 @@ static int bcmgenet_suspend(struct device *d)
 
 	netif_device_detach(dev);
 
-	bcmgenet_netif_stop(dev);
+	bcmgenet_netif_stop(dev, true);
 
 	if (!device_may_wakeup(d))
 		phy_suspend(dev->phydev);
-- 
2.39.2



