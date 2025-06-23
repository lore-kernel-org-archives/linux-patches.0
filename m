Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FD71D86DC;
	Mon, 23 Jun 2025 22:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716223; cv=none; b=hJsbqoksSBeMguu2bqp1QAx1NapRPhuNXw5P16y+UulI4d134tMF/Hvv19trsHHaiXtk/e8nR+pJxeLnsIY1vdEr/LBWc79wX326wdbFVRqQLqXX3SwaOjcePRFk4zLZL+dlizZY5aJIql6nzqCRcOQuFTLqNKPoIDzddt06znE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716223; c=relaxed/simple;
	bh=oeAi965yVTviCYjmsCrkQ7ZuCvkWcJ3SiRerBlwI6+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai9y2B/TUFtvJJHvVYgJ9pHjVDh9vjdeJv14EsYfNQK2qKfuYD26PYtAA1WLjQZTLMEzFMwvxl5Su4fr3ydA9Z7a4D3L3mV9vn+GbBndSrNKcSFKwVlyMPFhyrxHxjK1/KWjAWmnOOtWLSGrLZYtDK3C61nbHQSSh5Shk1qEP58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0c4eUlrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0c4eUlrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF5AC4CEEA;
	Mon, 23 Jun 2025 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716223;
	bh=oeAi965yVTviCYjmsCrkQ7ZuCvkWcJ3SiRerBlwI6+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0c4eUlrK1IzWedM2M2EIN2JC9DMt2lR4jZ01O+hK4twSK3IEMQQFBixIc9Jcrv3x2
	 6fit/Yoz6PtjlQ4or7pEGiDrne+8BKX8tMI/hZS0mZBMm0kYjhqPqGQZBH3gCGxZEq
	 xQPtunA4hYB+4cKXSk7TcxKyGxVDekSIwQtXSxHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 530/592] net: ti: icssg-prueth: Fix packet handling for XDP_TX
Date: Mon, 23 Jun 2025 15:08:08 +0200
Message-ID: <20250623130713.040511341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 60524f1d2bdf222db6dc3f680e0272441f697fe4 ]

While transmitting XDP frames for XDP_TX, page_pool is
used to get the DMA buffers (already mapped to the pages)
and need to be freed/reycled once the transmission is complete.
This need not be explicitly done by the driver as this is handled
more gracefully by the xdp driver while returning the xdp frame.
__xdp_return() frees the XDP memory based on its memory type,
under which page_pool memory is also handled. This change fixes
the transmit queue timeout while running XDP_TX.

logs:
[  309.069682] icssg-prueth icssg1-eth eth2: NETDEV WATCHDOG: CPU: 0: transmit queue 0 timed out 45860 ms
[  313.933780] icssg-prueth icssg1-eth eth2: NETDEV WATCHDOG: CPU: 0: transmit queue 0 timed out 50724 ms
[  319.053656] icssg-prueth icssg1-eth eth2: NETDEV WATCHDOG: CPU: 0: transmit queue 0 timed out 55844 ms
...

Fixes: 62aa3246f462 ("net: ti: icssg-prueth: Add XDP support")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250616063319.3347541-1-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index d88a0180294e0..7ae069e7af92b 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -98,20 +98,11 @@ void prueth_xmit_free(struct prueth_tx_chn *tx_chn,
 {
 	struct cppi5_host_desc_t *first_desc, *next_desc;
 	dma_addr_t buf_dma, next_desc_dma;
-	struct prueth_swdata *swdata;
-	struct page *page;
 	u32 buf_dma_len;
 
 	first_desc = desc;
 	next_desc = first_desc;
 
-	swdata = cppi5_hdesc_get_swdata(desc);
-	if (swdata->type == PRUETH_SWDATA_PAGE) {
-		page = swdata->data.page;
-		page_pool_recycle_direct(page->pp, swdata->data.page);
-		goto free_desc;
-	}
-
 	cppi5_hdesc_get_obuf(first_desc, &buf_dma, &buf_dma_len);
 	k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &buf_dma);
 
@@ -135,7 +126,6 @@ void prueth_xmit_free(struct prueth_tx_chn *tx_chn,
 		k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
 	}
 
-free_desc:
 	k3_cppi_desc_pool_free(tx_chn->desc_pool, first_desc);
 }
 EXPORT_SYMBOL_GPL(prueth_xmit_free);
@@ -612,13 +602,8 @@ u32 emac_xmit_xdp_frame(struct prueth_emac *emac,
 	k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &buf_dma);
 	cppi5_hdesc_attach_buf(first_desc, buf_dma, xdpf->len, buf_dma, xdpf->len);
 	swdata = cppi5_hdesc_get_swdata(first_desc);
-	if (page) {
-		swdata->type = PRUETH_SWDATA_PAGE;
-		swdata->data.page = page;
-	} else {
-		swdata->type = PRUETH_SWDATA_XDPF;
-		swdata->data.xdpf = xdpf;
-	}
+	swdata->type = PRUETH_SWDATA_XDPF;
+	swdata->data.xdpf = xdpf;
 
 	/* Report BQL before sending the packet */
 	netif_txq = netdev_get_tx_queue(ndev, tx_chn->id);
-- 
2.39.5



