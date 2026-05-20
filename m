Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF7C3F8706;
	Wed, 20 May 2026 18:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301566; cv=none; b=XI7J3YZ0YOX4gXSImBwCVGDavvtTFmsyeb9WfRue169VPfVEqfvhaiT3oehqT6WYzRPBU5AII40EjU3bKNuOq5oAKJOJ9e8uN8syc4oci+TCVz8tc0LZSxgDkzDC/x84SMR/7/OR13a8WNnlXr/sdaWyHCcuLg285yLwr+Yv3UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301566; c=relaxed/simple;
	bh=3XQitr4h9EKiu3n3pW187cYzhfPbmJGG+H+v+dSgBLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuEIzMC8JhBWnIcA11VFDGF8Cvvg3eLejFo115uhCGaCDb82YpsFjurKgyu6o5sJhkRmVSaBhI/jegWhf7aedJ1HBB8RDeHTBD24s3w7h1IwazsIhMM59SJ4PpZ0prK9rG1tlCJC052a10Whiud0tTqoiqD1C27OoSvLJVepvzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEZeLiu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEZeLiu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C961F000E9;
	Wed, 20 May 2026 18:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301565;
	bh=Vwge2Pq2W6PZol2+jPeyA0A+1jMdIQVMfTsojqBDTkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEZeLiu/kFiN82wEfxHWPrHuUjgJ6oYNAe/qxaZ2MYPBx0HQHBrPCS0yJuKuXaurm
	 wSf8c8tUVb+CyCOYKgwr9BIkxc2Osyu8GKF8hBjVqEiT9ElTMGl4Mw1LBVGH7LOZIT
	 XnFFnvdz/8Fmm7Owf7M0GJ9gR23lW3K4IsV1hahU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 602/666] net: bcmgenet: fix leaking free_bds
Date: Wed, 20 May 2026 18:23:33 +0200
Message-ID: <20260520162124.315702814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 3f3168300efb839028328d720ab3962f91d6a0d0 ]

While reclaiming the tx queue we fast forward the write pointer to
drop any data in flight. These dropped frames are not added back
to the pool of free bds. We also need to tell the netdev that we
are dropping said data.

Fixes: f1bacae8b655 ("net: bcmgenet: support reclaiming unsent Tx packets")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260406175756.134567-3-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 1cad32ba101bb..1263d00058736 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1933,6 +1933,7 @@ static unsigned int bcmgenet_tx_reclaim(struct net_device *dev,
 		drop = (ring->prod_index - ring->c_index) & DMA_C_INDEX_MASK;
 		released += drop;
 		ring->prod_index = ring->c_index & DMA_C_INDEX_MASK;
+		ring->free_bds += drop;
 		while (drop--) {
 			cb_ptr = bcmgenet_put_txcb(priv, ring);
 			skb = cb_ptr->skb;
@@ -1944,6 +1945,7 @@ static unsigned int bcmgenet_tx_reclaim(struct net_device *dev,
 		}
 		if (skb)
 			dev_consume_skb_any(skb);
+		netdev_tx_reset_queue(netdev_get_tx_queue(dev, ring->index));
 		bcmgenet_tdma_ring_writel(priv, ring->index,
 					  ring->prod_index, TDMA_PROD_INDEX);
 		wr_ptr = ring->write_ptr * WORDS_PER_BD(priv);
-- 
2.53.0



