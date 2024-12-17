Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480CE142E77;
	Tue, 17 Dec 2024 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456148; cv=none; b=S8hycrU90pZXiUsyt8tIFGYULXK+wz3cmNtdIXnQVqfbasKhwXRgdP156qn783cYU8fetppvkTV7cdaJffgwVixqmvSDbmu18n9lkq5iMqOuYcQizQC7BuAQmyCpH2+UJxj8Ejg8GjV2G4PUu2SrL/adOA1PJto+xfiwfUiSMjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456148; c=relaxed/simple;
	bh=V7H/+lg2VJq2/ksJ9tAsOAKrjCEwpJpsC1DbfKb7gRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqwxvAMLkWi22+Lagc9mJYTIqBMfYS/sJ4m4bLFIn3CQBbys5giA4VqutnLPqC3NgJgDxW4jNWSZI+oYVvEtYPilpGNNrBP/aRhM/wqk7+00Wg05C87FsZzImwMe3hYyYO7H0YoafS/IEDYHFiZPSBOhsObFyJufevmldVMchw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4j0cKP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4j0cKP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA75EC4CED3;
	Tue, 17 Dec 2024 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456148;
	bh=V7H/+lg2VJq2/ksJ9tAsOAKrjCEwpJpsC1DbfKb7gRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4j0cKP3XqPjyFOUTrNp+w8f6PdZVID5n304dd0AkMlt73WXmxM6QLw2uKrLYsTuF
	 AIESYmHHnAUrKfUH3NsaV8pjuVyZ3p9Msi42fgSaYIBJyu3xbyE5txDCKdVyvMuTkA
	 Fsg9FtbyhPV46IOLo09KvnL17DJJ9Kh60bBLhtwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/109] net: renesas: rswitch: handle stop vs interrupt race
Date: Tue, 17 Dec 2024 18:08:01 +0100
Message-ID: <20241217170536.599560553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit 3dd002f20098b9569f8fd7f8703f364571e2e975 ]

Currently the stop routine of rswitch driver does not immediately
prevent hardware from continuing to update descriptors and requesting
interrupts.

It can happen that when rswitch_stop() executes the masking of
interrupts from the queues of the port being closed, napi poll for
that port is already scheduled or running on a different CPU. When
execution of this napi poll completes, it will unmask the interrupts.
And unmasked interrupt can fire after rswitch_stop() returns from
napi_disable() call. Then, the handler won't mask it, because
napi_schedule_prep() will return false, and interrupt storm will
happen.

This can't be fixed by making rswitch_stop() call napi_disable() before
masking interrupts. In this case, the interrupt storm will happen if
interrupt fires between napi_disable() and masking.

Fix this by checking for priv->opened_ports bit when unmasking
interrupts after napi poll. For that to be consistent, move
priv->opened_ports changes into spinlock-protected areas, and reorder
other operations in rswitch_open() and rswitch_stop() accordingly.

Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Link: https://patch.msgid.link/20241209113204.175015-1-nikita.yoush@cogentembedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 33 ++++++++++++++------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index d04a79ece698..4dd218b6f308 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -839,8 +839,10 @@ static int rswitch_poll(struct napi_struct *napi, int budget)
 
 	if (napi_complete_done(napi, budget - quota)) {
 		spin_lock_irqsave(&priv->lock, flags);
-		rswitch_enadis_data_irq(priv, rdev->tx_queue->index, true);
-		rswitch_enadis_data_irq(priv, rdev->rx_queue->index, true);
+		if (test_bit(rdev->port, priv->opened_ports)) {
+			rswitch_enadis_data_irq(priv, rdev->tx_queue->index, true);
+			rswitch_enadis_data_irq(priv, rdev->rx_queue->index, true);
+		}
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
@@ -1467,20 +1469,20 @@ static int rswitch_open(struct net_device *ndev)
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	unsigned long flags;
 
-	phy_start(ndev->phydev);
+	if (bitmap_empty(rdev->priv->opened_ports, RSWITCH_NUM_PORTS))
+		iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDIE);
 
 	napi_enable(&rdev->napi);
-	netif_start_queue(ndev);
 
 	spin_lock_irqsave(&rdev->priv->lock, flags);
+	bitmap_set(rdev->priv->opened_ports, rdev->port, 1);
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, true);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, true);
 	spin_unlock_irqrestore(&rdev->priv->lock, flags);
 
-	if (bitmap_empty(rdev->priv->opened_ports, RSWITCH_NUM_PORTS))
-		iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDIE);
+	phy_start(ndev->phydev);
 
-	bitmap_set(rdev->priv->opened_ports, rdev->port, 1);
+	netif_start_queue(ndev);
 
 	return 0;
 };
@@ -1492,7 +1494,16 @@ static int rswitch_stop(struct net_device *ndev)
 	unsigned long flags;
 
 	netif_tx_stop_all_queues(ndev);
+
+	phy_stop(ndev->phydev);
+
+	spin_lock_irqsave(&rdev->priv->lock, flags);
+	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, false);
+	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, false);
 	bitmap_clear(rdev->priv->opened_ports, rdev->port, 1);
+	spin_unlock_irqrestore(&rdev->priv->lock, flags);
+
+	napi_disable(&rdev->napi);
 
 	if (bitmap_empty(rdev->priv->opened_ports, RSWITCH_NUM_PORTS))
 		iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDID);
@@ -1505,14 +1516,6 @@ static int rswitch_stop(struct net_device *ndev)
 		kfree(ts_info);
 	}
 
-	spin_lock_irqsave(&rdev->priv->lock, flags);
-	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, false);
-	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, false);
-	spin_unlock_irqrestore(&rdev->priv->lock, flags);
-
-	phy_stop(ndev->phydev);
-	napi_disable(&rdev->napi);
-
 	return 0;
 };
 
-- 
2.39.5



