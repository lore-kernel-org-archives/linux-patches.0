Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A89C129EC7;
	Mon, 18 Dec 2023 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+bXIRqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798E9C433C8;
	Mon, 18 Dec 2023 14:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908730;
	bh=ujaXOElD79h/TLmHlahZgPddl8Idr2Wdc8VyRiznCLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+bXIRqyBv/hHHRmw7y439+u8BT/bRj41rYKRwjrJfkZaI50kjHVYsH6Toi0K70IT
	 r4ImYtVQp1F6jHB4Tz5MbcfSWXuBincalES5PXw0ZUWe6EtRx8fPglH2CTc4j/u8ls
	 x4K5/vRoti6fVVCv7zOZQDWw+FihxNivR3fmxoiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/83] qca_debug: Prevent crash on TX ring changes
Date: Mon, 18 Dec 2023 14:51:34 +0100
Message-ID: <20231218135050.359181721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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
index d59fff2fbcc63..061b08b91d1be 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -259,7 +259,6 @@ qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 static int
 qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
 	struct qcaspi *qca = netdev_priv(dev);
 
 	if ((ring->rx_pending) ||
@@ -267,14 +266,14 @@ qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
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
index a047bab1d7c7e..c8d8b85c09e85 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -581,6 +581,18 @@ qcaspi_spi_thread(void *data)
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



