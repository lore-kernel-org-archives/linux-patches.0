Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED5251C48;
	Mon,  8 Jan 2024 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4Htcm3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E4CC433AD;
	Mon,  8 Jan 2024 15:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728535;
	bh=72vPY/eS5O5AMAKa2p4+xWuLjxw3QF5mH/0/EoIrEUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4Htcm3KTrvQLbbYa74UDt/5aEg72mNxkIB9BvQgRDKeaNDcj4j00vSNAnU9MnfFx
	 foBgwAPzk3j9kaLj7u+wHMv+y6WV8JbVNnYL6xaCLq+0jKA+FBa17Uo/OO2OaW0sRy
	 dT/xh/aa0ozmOwVX8brvKPH68BPaujn5n+OXuNTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/150] dpaa2-eth: recycle the RX buffer only after all processing done
Date: Mon,  8 Jan 2024 16:35:58 +0100
Message-ID: <20240108153516.105189297@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b58162ce81d87..de62eee58a00e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -509,8 +509,6 @@ static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 
 	memcpy(skb->data, fd_vaddr + fd_offset, fd_length);
 
-	dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(fd));
-
 	return skb;
 }
 
@@ -528,6 +526,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	struct dpaa2_eth_drv_stats *percpu_extras;
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpaa2_fas *fas;
+	bool recycle_rx_buf = false;
 	void *buf_data;
 	u32 status = 0;
 	u32 xdp_act;
@@ -560,6 +559,8 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			dma_unmap_page(dev, addr, priv->rx_buf_size,
 				       DMA_BIDIRECTIONAL);
 			skb = dpaa2_eth_build_linear_skb(ch, fd, vaddr);
+		} else {
+			recycle_rx_buf = true;
 		}
 	} else if (fd_format == dpaa2_fd_sg) {
 		WARN_ON(priv->xdp_prog);
@@ -607,6 +608,8 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 
 	list_add_tail(&skb->list, ch->rx_list);
 
+	if (recycle_rx_buf)
+		dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(fd));
 	return;
 
 err_build_skb:
-- 
2.43.0



