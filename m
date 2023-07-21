Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE75F1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72423C433C7;
	Fri, 21 Jul 2023 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955998;
	bh=neAPo5fNJGPPDfPd10rkT8VOueG2X9zldENTHLY2l4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQjt5bCbd02u+6iWw5zatJhRTQhrDBMu6Ycz8l92dIfYKU5ZDH4tZTcmwe6coUvub
	 TuyLAtvSBUQzh0F9VNfx399Z5Fw83f2Usy7FREistComqHweY4MQz8j6/AzGYh+G/N
	 mh9VrFw/jmuXBBJeb8htD2TbGKPlif4seEoQaDdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 081/292] net: fec: remove useless fec_enet_reset_skb()
Date: Fri, 21 Jul 2023 18:03:10 +0200
Message-ID: <20230721160532.287049347@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 2ae9c66b04554bf5b3eeaab8c12a0bfb9f28ebde ]

This patch is a cleanup for fec driver. The fec_enet_reset_skb()
is used to free skb buffers for tx queues and is only invoked in
fec_restart(). However, fec_enet_bd_init() also resets skb buffers
and is invoked in fec_restart() too. So fec_enet_reset_skb() is
redundant and useless.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 20f797399035 ("net: fec: recycle pages for transmitted XDP frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 38e5b5abe067c..c08331f7da7b3 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1011,24 +1011,6 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 	}
 }
 
-static void fec_enet_reset_skb(struct net_device *ndev)
-{
-	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_enet_priv_tx_q *txq;
-	int i, j;
-
-	for (i = 0; i < fep->num_tx_queues; i++) {
-		txq = fep->tx_queue[i];
-
-		for (j = 0; j < txq->bd.ring_size; j++) {
-			if (txq->tx_skbuff[j]) {
-				dev_kfree_skb_any(txq->tx_skbuff[j]);
-				txq->tx_skbuff[j] = NULL;
-			}
-		}
-	}
-}
-
 /*
  * This function is called to start or restart the FEC during a link
  * change, transmit timeout, or to reconfigure the FEC.  The network
@@ -1071,9 +1053,6 @@ fec_restart(struct net_device *ndev)
 
 	fec_enet_enable_ring(ndev);
 
-	/* Reset tx SKB buffers. */
-	fec_enet_reset_skb(ndev);
-
 	/* Enable MII mode */
 	if (fep->full_duplex == DUPLEX_FULL) {
 		/* FD enable */
-- 
2.39.2



