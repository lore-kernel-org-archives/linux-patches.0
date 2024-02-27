Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B793B16423;
	Tue, 27 Feb 2024 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043093; cv=none; b=qbsStBbbKUmgCQKUC/bzKTAPFTDyW6deEDLubZ2UYhM97SwR7HiYTP0Zpwsea9AdJU/n1FbTjm+a2Kabengnu/Vh9Fm935z0u7csGj1hdgp8gtHtdZ8RwfNFku+GdtM1VCbZQA95rnSViqL4AZij3mD4kq//TPHyhQxTrtvilvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043093; c=relaxed/simple;
	bh=jAeHqBaQWgxOVQmqQ7fb+mbST9odAfQkm04QC2IGShs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N93RneEN67HFYnlfL7zfzNDKhi6JqqoSqsyhR4cor92f80WXleMJHK7PheOHR1Ill5FQ8L1ysXgMec0f3pNRKcZXlnHtnSTvSF096+6hWs4TT/4MazPCBhAqOEv2uRI6iF1KXuNEUZoET4b3bBhSlqVSLeUk+VpiCFIrdXsZ6F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3u7efND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3u7efND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421CDC433C7;
	Tue, 27 Feb 2024 14:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043093;
	bh=jAeHqBaQWgxOVQmqQ7fb+mbST9odAfQkm04QC2IGShs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3u7efNDDF2yxrrRcAKfS0Tf5aEwYjyoysGPuqAZBAjTXv4xmWZKcr6oCUlKdf9r7
	 MK1taG5F08tgkvsDQklOU+Fj82kLdzmy8MilCS4rQpKrAFjmfLuWc4zLNJcYoz4gGx
	 Dd/0aGtl3Frsy4vldDqlI8HKPSe5JtFKj/CRODeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Sakharov <p.sakharov@ispras.ru>,
	Serge Semin <fancer.lancer@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/245] net: stmmac: Fix incorrect dereference in interrupt handlers
Date: Tue, 27 Feb 2024 14:26:42 +0100
Message-ID: <20240227131622.164294290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ab3ded6e0e6a3..a1c1e353ca072 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5737,11 +5737,6 @@ static irqreturn_t stmmac_mac_interrupt(int irq, void *dev_id)
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
@@ -5757,11 +5752,6 @@ static irqreturn_t stmmac_safety_interrupt(int irq, void *dev_id)
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
@@ -5781,11 +5771,6 @@ static irqreturn_t stmmac_msi_intr_tx(int irq, void *data)
 
 	priv = container_of(tx_q, struct stmmac_priv, tx_queue[chan]);
 
-	if (unlikely(!data)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
-
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return IRQ_HANDLED;
@@ -5824,11 +5809,6 @@ static irqreturn_t stmmac_msi_intr_rx(int irq, void *data)
 
 	priv = container_of(rx_q, struct stmmac_priv, rx_queue[chan]);
 
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



