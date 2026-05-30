Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDF3481DD;
	Sat, 30 May 2026 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161035; cv=none; b=ePDwfUB6JA3+PIwnqvFnCs3W0mEnJhhyWnj3sS7YXWd8jP+RdCuqnf+h6t25fX/+gaVH8ahMfMU4LMMYBgg4wMVOUeRS+KsZGN5UXH3l1QKP4d4aFZ+XWrOXfrMfTvogCzf5SsLDvezaPtbAqDUOyJ9N6qqKU3RBuYXx69YCzlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161035; c=relaxed/simple;
	bh=lCLIxsSUwxmxvNbiXrskBXJLIle8r9WDCcGDOcn3VoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewpYS4IpLPwRw6XclKR5EjKJxhIdaIxaLZ04+hQFg52R29Jfp5Lk+fiUEB3lbA3WBHYVCr1uv9Dij9JsDOu37SSOR9IEAzHk2nM3iYpE4yOlpcFAfdwJ32aX28/R7nuaELwlkgbfgUVTfjCL52G9/wWHOq3AgnhpxvF+pxDfWXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXwrftil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXwrftil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E181F00893;
	Sat, 30 May 2026 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161032;
	bh=DoHJs7RnHYwxgT4pkLoKoN0bO1BoXIizJTL7uwCOceA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXwrftilq9uP3Kf9lK91lfrJoquW/JtGFhL9Eb5CjqRtEz18J30Y2+1HZ+6K1/ujX
	 nPZR7iEdwtKxgEP7JpmOYgrTFz+QeGjGqWEPKl09ZThcbdM2FA39W0psth1ZFXwgHx
	 3dmlpccz+xw0sFcu5oWvlOJtBpfeYCAjbGXiV0Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 475/969] net: bcmgenet: fix racing timeout handler
Date: Sat, 30 May 2026 17:59:59 +0200
Message-ID: <20260530160313.413008292@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 5393b2b5bee2ac51a0043dc7f4ac3475f053d08d ]

The bcmgenet_timeout handler tries to take down all tx queues when
a single queue times out. This is over zealous and causes many race
conditions with queues that are still chugging along. Instead lets
only restart the timed out queue.

Fixes: 13ea657806cf ("net: bcmgenet: improve TX timeout")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260406175756.134567-4-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 22 ++++++++-----------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 12aa07fb81db3..43fba7b47d1cd 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3469,27 +3469,23 @@ static void bcmgenet_dump_tx_queue(struct bcmgenet_tx_ring *ring)
 static void bcmgenet_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	u32 int1_enable = 0;
-	unsigned int q;
+	struct bcmgenet_tx_ring *ring = &priv->tx_rings[txqueue];
+	struct netdev_queue *txq = netdev_get_tx_queue(dev, txqueue);
 
 	netif_dbg(priv, tx_err, dev, "bcmgenet_timeout\n");
 
-	for (q = 0; q <= priv->hw_params->tx_queues; q++)
-		bcmgenet_dump_tx_queue(&priv->tx_rings[q]);
-
-	bcmgenet_tx_reclaim_all(dev);
+	bcmgenet_dump_tx_queue(ring);
 
-	for (q = 0; q <= priv->hw_params->tx_queues; q++)
-		int1_enable |= (1 << q);
+	bcmgenet_tx_reclaim(dev, ring, true);
 
-	/* Re-enable TX interrupts if disabled */
-	bcmgenet_intrl2_1_writel(priv, int1_enable, INTRL2_CPU_MASK_CLEAR);
+	/* Re-enable the TX interrupt for this ring */
+	bcmgenet_intrl2_1_writel(priv, 1 << txqueue, INTRL2_CPU_MASK_CLEAR);
 
-	netif_trans_update(dev);
+	txq_trans_cond_update(txq);
 
-	BCMGENET_STATS64_INC((&priv->tx_rings[txqueue].stats64), errors);
+	BCMGENET_STATS64_INC((&ring->stats64), errors);
 
-	netif_tx_wake_all_queues(dev);
+	netif_tx_wake_queue(txq);
 }
 
 #define MAX_MDF_FILTER	17
-- 
2.53.0



