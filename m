Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754496FB1;
	Tue,  5 Dec 2023 03:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV+8A9Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35B8C433C8;
	Tue,  5 Dec 2023 03:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746604;
	bh=0AagSZOtqiX6HY3uJFNduHEFXa5IC+rVPRi3pwkKAqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TV+8A9Ffo45zz7RrkV3dHlptzWXGamAFor2Kw4T63UQPYFW+ZN1bb02pQ/RxNduzT
	 y7vda+jSjgPfo9SoTUdjAtI7ywoPpNkLLnXXfuFU1B+9DqnEVH52poyDeBSzwxWaWv
	 dSjKd/a9Ic+VrjxFf33l2wzF9idTnc05YFOwXOqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/134] dpaa2-eth: recycle the RX buffer only after all processing done
Date: Tue,  5 Dec 2023 12:16:00 +0900
Message-ID: <20231205031541.017874574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit beb1930f966d1517921488bd5d64147f58f79abf ]

The blamed commit added support for Rx copybreak. This meant that for
certain frame sizes, a new skb was allocated and the initial data buffer
was recycled. Instead of waiting to recycle the Rx buffer only after all
processing was done on it (like accessing the parse results or timestamp
information), the code path just went ahead and re-used the buffer right
away.

This sometimes lead to corrupted HW and SW annotation areas.
Fix this by delaying the moment when the buffer is recycled.

Fixes: 50f826999a80 ("dpaa2-eth: add rx copybreak support")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 774377db0b4bd..888509cf1f210 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -516,8 +516,6 @@ struct sk_buff *dpaa2_eth_alloc_skb(struct dpaa2_eth_priv *priv,
 
 	memcpy(skb->data, fd_vaddr + fd_offset, fd_length);
 
-	dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(fd));
-
 	return skb;
 }
 
@@ -589,6 +587,7 @@ void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa2_eth_drv_stats *percpu_extras;
 	struct device *dev = priv->net_dev->dev.parent;
+	bool recycle_rx_buf = false;
 	void *buf_data;
 	u32 xdp_act;
 
@@ -618,6 +617,8 @@ void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			dma_unmap_page(dev, addr, priv->rx_buf_size,
 				       DMA_BIDIRECTIONAL);
 			skb = dpaa2_eth_build_linear_skb(ch, fd, vaddr);
+		} else {
+			recycle_rx_buf = true;
 		}
 	} else if (fd_format == dpaa2_fd_sg) {
 		WARN_ON(priv->xdp_prog);
@@ -637,6 +638,9 @@ void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 		goto err_build_skb;
 
 	dpaa2_eth_receive_skb(priv, ch, fd, vaddr, fq, percpu_stats, skb);
+
+	if (recycle_rx_buf)
+		dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(fd));
 	return;
 
 err_build_skb:
-- 
2.42.0



