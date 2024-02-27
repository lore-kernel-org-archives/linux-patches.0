Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C09654BD4;
	Tue, 27 Feb 2024 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042311; cv=none; b=UKd0aO21ZuKC8/dAnw6M57MlpPwYqpsYRhCCQ7PqP64yM/wwcRVGFaBbgSU2HLXyBypyHlNoTvSOZo0ljPCNK1U/YE/bY71NSchkWyvbZPU/FjP7TevIVWTwbU9K/xlWhfE10KZhrnFT7cGUS+WZcrpcQL8AZlY6C22t+KjYia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042311; c=relaxed/simple;
	bh=N0yLrMNiu//0OAgJexN6lR6vSEYf/Hd1KzGppZH9DNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMbtz+zLtZpjrHHsgPruNZNT01OotFkNWCleLYbbG8kisxbeR7OmhZzXOnoO7R9nyDZXoj1FLJMthAV24lBOAeWsq/tfYdcGRn/QhFKjup4aYMaaHDD7fmhjJrRlr+1tJkU/VziSoZiwnEnCpp8DGTFzAhYONLPjbBUHhiGvbgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXJKH9N+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXJKH9N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA4AC433C7;
	Tue, 27 Feb 2024 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042311;
	bh=N0yLrMNiu//0OAgJexN6lR6vSEYf/Hd1KzGppZH9DNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXJKH9N+dP7C8t6EWX98R76C1Tb3l8WTieOBWe7bXbAwHL9Vn0uYC29s2xD4cYUj9
	 y8QTtYoSYS+v5ftj2zNuw6IsGYdhgjCuZ2piy24bKgN85b7oTWbK+IftEvUdwmM7eK
	 vWVACxdPa3Ed9fsttovwMcfjvtOmTzGrooHSOPhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Sakharov <p.sakharov@ispras.ru>,
	Serge Semin <fancer.lancer@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/299] net: stmmac: Fix incorrect dereference in interrupt handlers
Date: Tue, 27 Feb 2024 14:25:55 +0100
Message-ID: <20240227131633.579878110@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
index f1614ad2daaa7..5b3423d1af3f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5951,11 +5951,6 @@ static irqreturn_t stmmac_mac_interrupt(int irq, void *dev_id)
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
@@ -5971,11 +5966,6 @@ static irqreturn_t stmmac_safety_interrupt(int irq, void *dev_id)
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
@@ -5997,11 +5987,6 @@ static irqreturn_t stmmac_msi_intr_tx(int irq, void *data)
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
@@ -6028,11 +6013,6 @@ static irqreturn_t stmmac_msi_intr_rx(int irq, void *data)
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



