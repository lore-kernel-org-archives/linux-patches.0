Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2201481DD;
	Sat, 30 May 2026 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161013; cv=none; b=BhRBD30nPxkLwyuGaRQRH/EfNtGjtr9WFx6jQLa1NsqfCKJQxzdGFaRFhlP9T8UmXIMkRK+dFpQ5c6Zct48WoL1ibhf2SeRsRslQH22K6IYQmk2D7JW+AWzXbRf6hW08ASI1Cr8qUfcgW4F4p6giON8SGjK8b35PTV88Kuik2mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161013; c=relaxed/simple;
	bh=FP3yI2uYRp9jyoui/UklKdvfa+hoVP2kiA53TRwyN7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJYQQ+xXLg/YXQWb+kLhFG2chetiZpxXTEsp60IDHYB2QgY/ngQF7y+NDtokY1tKV4xq5maAmmaXMyoQ2DGL75/wHshVSHSJ9Hnc5elfleiuC3w2pXwZ03NHtbPQg7tCcSf1jUy0KFWMAo9aoIJNs4VmD7oUd+YlptIBKDKIbf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7xw3hfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7xw3hfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A4D1F00893;
	Sat, 30 May 2026 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161012;
	bh=FSojE+g9oT93DRGtxrvo8lgz+wvAQ7q+cvYh6gFJi2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7xw3hfEUkFTs8oSIbfCEKKXVN31MQ+TZZGrWevh6EHpyFjkcFyuMSKt+YJF8PTJX
	 AnDskZ+dhNQAg8XbHB+avraJB/EvlRRe4QkMVqprfBKVqE+iHcSt6jPSiYXYSw3KUE
	 /Alc9FL93zkZXjXxYmVJ/xWE8O2lh+C6RIdXp3Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/969] net: bcmgenet: Remove custom ndo_poll_controller()
Date: Sat, 30 May 2026 17:59:54 +0200
Message-ID: <20260530160313.270327853@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 19537e125cc7cf2da43a606f5bcebbe0c9aea4cc ]

The driver gained a .ndo_poll_controller() at a time where the TX
cleaning process was always done from NAPI which makes this unnecessary.
See commit ac3d9dd034e5 ("netpoll: make ndo_poll_controller() optional")
for more background.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5393b2b5bee2 ("net: bcmgenet: fix racing timeout handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 1d679de9c3235..4d76c9aebd439 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3250,23 +3250,6 @@ static irqreturn_t bcmgenet_wol_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void bcmgenet_poll_controller(struct net_device *dev)
-{
-	struct bcmgenet_priv *priv = netdev_priv(dev);
-
-	/* Invoke the main RX/TX interrupt handler */
-	disable_irq(priv->irq0);
-	bcmgenet_isr0(priv->irq0, priv);
-	enable_irq(priv->irq0);
-
-	/* And the interrupt handler for RX/TX priority queues */
-	disable_irq(priv->irq1);
-	bcmgenet_isr1(priv->irq1, priv);
-	enable_irq(priv->irq1);
-}
-#endif
-
 static void bcmgenet_umac_reset(struct bcmgenet_priv *priv)
 {
 	u32 reg;
@@ -3736,9 +3719,6 @@ static const struct net_device_ops bcmgenet_netdev_ops = {
 	.ndo_set_mac_address	= bcmgenet_set_mac_addr,
 	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_features	= bcmgenet_set_features,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= bcmgenet_poll_controller,
-#endif
 	.ndo_get_stats		= bcmgenet_get_stats,
 	.ndo_change_carrier	= bcmgenet_change_carrier,
 };
-- 
2.53.0



