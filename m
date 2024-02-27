Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B0A2F2D;
	Tue, 27 Feb 2024 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041239; cv=none; b=T32S42UC8ngmLnEDpGI+khJ6XZgZcc4396XZKYSKzdZBXQJpQ4iIvJ8C61AVjC+zz6bt37m3uf3ce+X+6dk2FV0MxBAtRcb0aBeOL4H0wGZT72Py25KgHLaniTiKqBIOvA5pb0CSlXhmrN9E1BcMlQu6xNHLvzC8nfCD+KBl4Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041239; c=relaxed/simple;
	bh=TJmXWha/iA3GxeV1i4dtftwesYv/PNmuFs3LxTJNxDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFdAWxB2x1LBCX9axQ8O5M/Xy9tzJewju7r+SlGe9MOeUdpla2WYJ7wHcuh2f+JPIRGvAGkMIswxHniFKV+/D11bmGPngRaxCBIHeHiCwMFJRSno5JPaCHPMYRGqfN/vMBR1C2BetRqFS/+RjRB0AQLnZWNV01nA3LHLgRDt4eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiT+HHrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiT+HHrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04493C433C7;
	Tue, 27 Feb 2024 13:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041239;
	bh=TJmXWha/iA3GxeV1i4dtftwesYv/PNmuFs3LxTJNxDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiT+HHrSu8JyEu2Sw2Y0l8B+lKSli8qguvY07M8+adAsovDG2zMpiFrb0Ai7Bxbxm
	 OQHJAD/6MjurbicCSlt4JqpB8avkLaITq7F+H+fRaAhg2yGJFfNFfrnt73KkQMRi0y
	 X/DzemVEL3vCztgb/BGLZYsZKUTqi2WDaOJ/mC+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Sakharov <p.sakharov@ispras.ru>,
	Serge Semin <fancer.lancer@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 268/334] net: stmmac: Fix incorrect dereference in interrupt handlers
Date: Tue, 27 Feb 2024 14:22:06 +0100
Message-ID: <20240227131639.621645750@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Sakharov <p.sakharov@ispras.ru>

[ Upstream commit 97dde84026339e4b4af9a6301f825d1828d7874b ]

If 'dev' or 'data' is NULL, the 'priv' variable has an incorrect address
when dereferencing calling netdev_err().

Since we get as 'dev_id' or 'data' what was passed as the 'dev' argument
to request_irq() during interrupt initialization (that is, the net_device
and rx/tx queue pointers initialized at the time of the call) and since
there are usually no checks for the 'dev_id' argument in such handlers
in other drivers, remove these checks from the handlers in stmmac driver.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX")
Signed-off-by: Pavel Sakharov <p.sakharov@ispras.ru>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ec34768e054da..e9a1b60ebb503 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5977,11 +5977,6 @@ static irqreturn_t stmmac_mac_interrupt(int irq, void *dev_id)
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (unlikely(!dev)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
-
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return IRQ_HANDLED;
@@ -5997,11 +5992,6 @@ static irqreturn_t stmmac_safety_interrupt(int irq, void *dev_id)
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (unlikely(!dev)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
-
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return IRQ_HANDLED;
@@ -6023,11 +6013,6 @@ static irqreturn_t stmmac_msi_intr_tx(int irq, void *data)
 	dma_conf = container_of(tx_q, struct stmmac_dma_conf, tx_queue[chan]);
 	priv = container_of(dma_conf, struct stmmac_priv, dma_conf);
 
-	if (unlikely(!data)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
-
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return IRQ_HANDLED;
@@ -6054,11 +6039,6 @@ static irqreturn_t stmmac_msi_intr_rx(int irq, void *data)
 	dma_conf = container_of(rx_q, struct stmmac_dma_conf, rx_queue[chan]);
 	priv = container_of(dma_conf, struct stmmac_priv, dma_conf);
 
-	if (unlikely(!data)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
-
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return IRQ_HANDLED;
-- 
2.43.0



