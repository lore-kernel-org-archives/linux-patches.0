Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CE7129EC7;
	Mon, 18 Dec 2023 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wK8JRL1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3672EC433C8;
	Mon, 18 Dec 2023 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908733;
	bh=EylXFISy4rGI93RIRU46J1eWNz0ZY1N5EOseK8/xG30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wK8JRL1ShzYfdCV1ZoRja0g4Gh9TQoOrrQoo6BfKYTxnamFgFUwa+dLhWM46udchP
	 l9Sia8TpuOcEekvS2RRWQE4ic0Nw21vyjHhhLMf/9g+yeTV7mcNohNmlb9F0tV3Vj+
	 JYP+ghXiUTwOkptXTZYuiuMFxvQfbUhIMeJctJMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/83] qca_debug: Fix ethtool -G iface tx behavior
Date: Mon, 18 Dec 2023 14:51:35 +0100
Message-ID: <20231218135050.396722513@linuxfoundation.org>
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

[ Upstream commit 96a7e861d9e04d07febd3011c30cd84cd141d81f ]

After calling ethtool -g it was not possible to adjust the TX ring
size again:

  # ethtool -g eth1
  Ring parameters for eth1:
  Pre-set maximums:
  RX:		4
  RX Mini:	n/a
  RX Jumbo:	n/a
  TX:		10
  Current hardware settings:
  RX:		4
  RX Mini:	n/a
  RX Jumbo:	n/a
  TX:		10
  # ethtool -G eth1 tx 8
  netlink error: Invalid argument

The reason for this is that the readonly setting rx_pending get
initialized and after that the range check in qcaspi_set_ringparam()
fails regardless of the provided parameter. So fix this by accepting
the exposed RX defaults. Instead of adding another magic number
better use a new define here.

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20231206141222.52029-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_debug.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index 061b08b91d1be..8b61bebd96e4b 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -30,6 +30,8 @@
 
 #define QCASPI_MAX_REGS 0x20
 
+#define QCASPI_RX_MAX_FRAMES 4
+
 static const u16 qcaspi_spi_regs[] = {
 	SPI_REG_BFR_SIZE,
 	SPI_REG_WRBUF_SPC_AVA,
@@ -250,9 +252,9 @@ qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 {
 	struct qcaspi *qca = netdev_priv(dev);
 
-	ring->rx_max_pending = 4;
+	ring->rx_max_pending = QCASPI_RX_MAX_FRAMES;
 	ring->tx_max_pending = TX_RING_MAX_LEN;
-	ring->rx_pending = 4;
+	ring->rx_pending = QCASPI_RX_MAX_FRAMES;
 	ring->tx_pending = qca->txr.count;
 }
 
@@ -261,7 +263,7 @@ qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
 {
 	struct qcaspi *qca = netdev_priv(dev);
 
-	if ((ring->rx_pending) ||
+	if (ring->rx_pending != QCASPI_RX_MAX_FRAMES ||
 	    (ring->rx_mini_pending) ||
 	    (ring->rx_jumbo_pending))
 		return -EINVAL;
-- 
2.43.0



