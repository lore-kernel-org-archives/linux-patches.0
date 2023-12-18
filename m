Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E8B1D13D;
	Mon, 18 Dec 2023 14:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZEaYFxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA97C433C7;
	Mon, 18 Dec 2023 14:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908448;
	bh=yAFq6zEYAXrQAmhT99SfJjKSKWmlpWa3TkyDnZC1xsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZEaYFxDsu7c08SXle8YTbNxQR8wD1f+i/qhqKZQ7LvoJhkGjO/3WZZJ6lGokY3bY
	 xHxcudgvJ1bcdp1l0ADASsZU7IorSviBQRHxCW4ziJpT7sohbDkwQOk6KIHAv/K1aX
	 WCj4/fJ1SXoh7SxRJvhoXszRpHGxLx+mj0eW3bGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/62] qca_debug: Prevent crash on TX ring changes
Date: Mon, 18 Dec 2023 14:51:29 +0100
Message-ID: <20231218135046.456685261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit f4e6064c97c050bd9904925ff7d53d0c9954fc7b ]

The qca_spi driver stop and restart the SPI kernel thread
(via ndo_stop & ndo_open) in case of TX ring changes. This is
a big issue because it allows userspace to prevent restart of
the SPI kernel thread (via signals). A subsequent change of
TX ring wrongly assume a valid spi_thread pointer which result
in a crash.

So prevent this by stopping the network traffic handling and
temporary park the SPI thread.

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20231206141222.52029-2-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_debug.c |  9 ++++-----
 drivers/net/ethernet/qualcomm/qca_spi.c   | 12 ++++++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index 702aa217a27ad..4c6c1792fdc77 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -258,7 +258,6 @@ qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 static int
 qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
 	struct qcaspi *qca = netdev_priv(dev);
 
 	if ((ring->rx_pending) ||
@@ -266,14 +265,14 @@ qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 	    (ring->rx_jumbo_pending))
 		return -EINVAL;
 
-	if (netif_running(dev))
-		ops->ndo_stop(dev);
+	if (qca->spi_thread)
+		kthread_park(qca->spi_thread);
 
 	qca->txr.count = max_t(u32, ring->tx_pending, TX_RING_MIN_LEN);
 	qca->txr.count = min_t(u16, qca->txr.count, TX_RING_MAX_LEN);
 
-	if (netif_running(dev))
-		ops->ndo_open(dev);
+	if (qca->spi_thread)
+		kthread_unpark(qca->spi_thread);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 44fa959ebcaa5..b08a4b2a6a996 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -573,6 +573,18 @@ qcaspi_spi_thread(void *data)
 	netdev_info(qca->net_dev, "SPI thread created\n");
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_park()) {
+			netif_tx_disable(qca->net_dev);
+			netif_carrier_off(qca->net_dev);
+			qcaspi_flush_tx_ring(qca);
+			kthread_parkme();
+			if (qca->sync == QCASPI_SYNC_READY) {
+				netif_carrier_on(qca->net_dev);
+				netif_wake_queue(qca->net_dev);
+			}
+			continue;
+		}
+
 		if ((qca->intr_req == qca->intr_svc) &&
 		    !qca->txr.skb[qca->txr.head])
 			schedule();
-- 
2.43.0



