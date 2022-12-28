Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A8C1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41672C433D2;
	Wed, 28 Dec 2022 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245854;
	bh=C3RC0Yrm4veCKkUtVQf7IfSeqqzrNdIAO8x8D1o2zLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajQzyrVJRIiVZaQml7UJzTdezL4K/aczqAxz3F4/yvMHzKXMm9E/5cEA+LGqjykOX
	 k4ixwjg594yxHZ7i4N7JW8CwP0Ohvu3H73Mutwu6Klrb2OwUdYTzS6R4YOEBgYzmIF
	 qD37S8BiDon9C3t8pvYm+c68Ccfp8gNRMW6Vr8l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Shenwei Wang <Shenwei.wang@nxp.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0936/1146] net: fec: check the return value of build_skb()
Date: Wed, 28 Dec 2022 15:41:15 +0100
Message-Id: <20221228144355.724466461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 19e72b064fc32cd58f6fc0b1eb64ac2e4f770e76 ]

The build_skb might return a null pointer but there is no check on the
return value in the fec_enet_rx_queue(). So a null pointer dereference
might occur. To avoid this, we check the return value of build_skb. If
the return value is a null pointer, the driver will recycle the page and
update the statistic of ndev. Then jump to rx_processing_done to clear
the status flags of the BD so that the hardware can recycle the BD.

Fixes: 95698ff6177b ("net: fec: using page pool to manage RX buffers")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Shenwei Wang <Shenwei.wang@nxp.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20221219022755.1047573-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 23e1a94b9ce4..f250b0df27fb 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1642,6 +1642,14 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 * bridging applications.
 		 */
 		skb = build_skb(page_address(page), PAGE_SIZE);
+		if (unlikely(!skb)) {
+			page_pool_recycle_direct(rxq->page_pool, page);
+			ndev->stats.rx_dropped++;
+
+			netdev_err_once(ndev, "build_skb failed!\n");
+			goto rx_processing_done;
+		}
+
 		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
 		skb_put(skb, pkt_len - 4);
 		skb_mark_for_recycle(skb);
-- 
2.35.1



