Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4619E17990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RL8zhqyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FFDC433CC;
	Mon,  9 Oct 2023 13:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857152;
	bh=xPJCrio6RI6HNyR/LwL/pI+fq3p1DLjsNRu5wWcs0/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RL8zhqyfC/zbGi0QAeWQlaRYoGLr/kenHGf17QphrkkRvizbObKbfvZ9xqnUoORDJ
	 zBgSHHWj6g7z5sWjko2yxrh87iAxzcmN5fKP1ruxF3v8pyAU1tHqPWhElVoQTzHb+e
	 YMFZxSjZ4s8c4/VIfGZDyRJhpt5fJlc9nim8cHF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 113/163] net: renesas: rswitch: Add spin lock protection for irq {un}mask
Date: Mon,  9 Oct 2023 15:01:17 +0200
Message-ID: <20231009130127.146993330@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit c4f922e86c8e0f7c5fe94e0547e9835fc9711f08 ]

Add spin lock protection for irq {un}mask registers' control.

After napi_complete_done() and this protection were applied,
a lot of redundant interrupts no longer occur.

For example: when "iperf3 -c <ipaddr> -R" on R-Car S4-8 Spider
 Before the patches are applied: about 800,000 times happened
 After the patches were applied: about 100,000 times happened

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: a0c55bba0d0d ("rswitch: Fix PHY station management clock setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 12 ++++++++++++
 drivers/net/ethernet/renesas/rswitch.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 449ed1f5624c9..215854812f80a 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -799,6 +799,7 @@ static int rswitch_poll(struct napi_struct *napi, int budget)
 	struct net_device *ndev = napi->dev;
 	struct rswitch_private *priv;
 	struct rswitch_device *rdev;
+	unsigned long flags;
 	int quota = budget;
 
 	rdev = netdev_priv(ndev);
@@ -817,8 +818,10 @@ static int rswitch_poll(struct napi_struct *napi, int budget)
 	netif_wake_subqueue(ndev, 0);
 
 	if (napi_complete_done(napi, budget - quota)) {
+		spin_lock_irqsave(&priv->lock, flags);
 		rswitch_enadis_data_irq(priv, rdev->tx_queue->index, true);
 		rswitch_enadis_data_irq(priv, rdev->rx_queue->index, true);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 out:
@@ -835,8 +838,10 @@ static void rswitch_queue_interrupt(struct net_device *ndev)
 	struct rswitch_device *rdev = netdev_priv(ndev);
 
 	if (napi_schedule_prep(&rdev->napi)) {
+		spin_lock(&rdev->priv->lock);
 		rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, false);
 		rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, false);
+		spin_unlock(&rdev->priv->lock);
 		__napi_schedule(&rdev->napi);
 	}
 }
@@ -1430,14 +1435,17 @@ static void rswitch_ether_port_deinit_all(struct rswitch_private *priv)
 static int rswitch_open(struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
+	unsigned long flags;
 
 	phy_start(ndev->phydev);
 
 	napi_enable(&rdev->napi);
 	netif_start_queue(ndev);
 
+	spin_lock_irqsave(&rdev->priv->lock, flags);
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, true);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, true);
+	spin_unlock_irqrestore(&rdev->priv->lock, flags);
 
 	if (bitmap_empty(rdev->priv->opened_ports, RSWITCH_NUM_PORTS))
 		iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDIE);
@@ -1451,6 +1459,7 @@ static int rswitch_stop(struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_gwca_ts_info *ts_info, *ts_info2;
+	unsigned long flags;
 
 	netif_tx_stop_all_queues(ndev);
 	bitmap_clear(rdev->priv->opened_ports, rdev->port, 1);
@@ -1466,8 +1475,10 @@ static int rswitch_stop(struct net_device *ndev)
 		kfree(ts_info);
 	}
 
+	spin_lock_irqsave(&rdev->priv->lock, flags);
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, false);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, false);
+	spin_unlock_irqrestore(&rdev->priv->lock, flags);
 
 	phy_stop(ndev->phydev);
 	napi_disable(&rdev->napi);
@@ -1869,6 +1880,7 @@ static int renesas_eth_sw_probe(struct platform_device *pdev)
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	spin_lock_init(&priv->lock);
 
 	priv->ptp_priv = rcar_gen4_ptp_alloc(pdev);
 	if (!priv->ptp_priv)
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index bb9ed971a97ca..9740398067140 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -1011,6 +1011,8 @@ struct rswitch_private {
 	struct rswitch_etha etha[RSWITCH_NUM_PORTS];
 	struct rswitch_mfwd mfwd;
 
+	spinlock_t lock;	/* lock interrupt registers' control */
+
 	bool gwca_halt;
 };
 
-- 
2.40.1



