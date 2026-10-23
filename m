Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774553;
	b=WU+4lI5LvPVVEGGnKiB7ptLelccnz31pc7u7O4cCKzzFCEEh/OArOzIcptVzaMPbxVTt
	 7YTxOYZKlQJACTXerWmFcTlYhrZ2VhxfE9IKGzK4/FSp6por1gKuFXkjIXzcgYzNl6GV2
	 VTntfo9dw11HkjptodbCqFJe94S+ZQv/5vkt09x8TngI7BLqv6JRIIxs/xC1cOGEKPz22
	 qHJG+wJhv4Wcs5ecV4t6ZV9KpxOYxLcJR3+7u2iGCZ0u8km/nyHOinkQ7itPYCqZPWmwN
	 8YWQhISUCTflfSP/QiX62XBbcH4xz4a1OWFwlsMPPQ99mtpNrc643/y/vkHmmEHskaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHXlMKO/r2bGFPaj2PmiSKgN9daaLZq3YZQ0qHXYYOs=;
	b=aiwwbd78a5t5xuMBz1KbFMLmCbO4jBsmoOpQwWsM8XGJuite34d6NJ6s7PjwAaT+SLxM
	 f1J7G4Pbu0z3XaGgxfzwB1aCqgTA4oB2WIKAALmTays7AkiVrTMYOGMCZVRP2HHK8/xvw
	 s4d/e2JSdx8dY+IzlugvFklXrqMDwBO9VpjMSdT/sB9l0wTcmoQ0iLQsw1kkY0uRjWlfQ
	 YuhEk3ZU42BmWhpYbersr7Zdt9AA6PPhaLS+pBBcoaFB3db/WjNcG3jtFT1fqM3Sha79d
	 83Pry9Qcbgp4QRgpwDR34HsYMmsSX91B2Oi+3wWjMwXEJYixEpdCeR7YhuSiuMVloIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwCwo2ph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC06606A31A;
	Fri, 23 Oct 2026 16:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwCwo2ph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579401F01825;
	Fri, 23 Oct 2026 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774552;
	bh=ZHXlMKO/r2bGFPaj2PmiSKgN9daaLZq3YZQ0qHXYYOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwCwo2phQDOZKE0g0MBfxy0LXCzRNpxMGZz6fWX+lyGKurFQodAzPD/B+q7dHE7HC
	 fgrGoBNEtltTV4gSG+lHTjnIe3oAostx/S+rfw2ufyq7d2l79L4UzCuAXdGQ9VLrn7
	 sVmSZB20eJRwABgS0qW51j5ZQO5k0W6Img0QnxXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 078/242] net: mv643xx: move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:40 +0200
Message-ID: <20261023163715.624328274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit a3eef3d2cca032d8768b5eb07aab0f46b79bfd8a ]

mv643xx_eth_probe() connects the PHY before dev->netdev_ops is
assigned. phy_attach_direct() -> phy_link_topo_add_phy() reads
dev->netdev_ops through netdev_need_ops_lock() since the commit in
question, so probing crashes with a NULL pointer dereference when
CONFIG_NET_SHAPER is enabled.

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261008022656.3592191-6-mmyangfl@gmail.com
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 1881583be5ce2..5b2546aa5b7a6 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3171,6 +3171,8 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	netif_set_real_num_tx_queues(dev, mp->txq_count);
 	netif_set_real_num_rx_queues(dev, mp->rxq_count);
 
+	dev->netdev_ops = &mv643xx_eth_netdev_ops;
+
 	err = 0;
 	if (pd->phy_node) {
 		phydev = of_phy_connect(mp->dev, pd->phy_node,
@@ -3221,8 +3223,6 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	}
 	dev->irq = irq;
 
-	dev->netdev_ops = &mv643xx_eth_netdev_ops;
-
 	dev->watchdog_timeo = 2 * HZ;
 	dev->base_addr = 0;
 
-- 
2.53.0



