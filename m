Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FF93B9D85;
	Mon, 23 Mar 2026 16:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283039; cv=none; b=Wx/aEIatOHI1+Zb/0X5/BOoFU7/40JTRA3MpkQtKoiHyZSt47a+8Zq4Cdr9AQtUZhEzfHATa4KCvNWg6I4daoZu4r5G2bXaHQVfu5LJg9zIcVs/aEhDKsvKdM/uroiWU5N/oN0KjbKVeJCjCpwt8hs1UuGW9TpA6vA9NFB1P3LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283039; c=relaxed/simple;
	bh=qg1SMW1jye+fzLbL7DnVUTLJ8HVgaqXXE5F/zNMwfDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gv1vSfVDYwTXj2jxp5MRfIj83TFtYCXraj2xv8n0+WEzJ+J9Q0HT8FDbq9FA6HJRnyjF+qzfS5Q1LHwzjmIjRxr8qZNqxCulgx6rMkJiUsYy1ysLOuarA4VtbCVCl3lmafd6Qesqdeo5niNnrbtzteVI8lFwkf4/wK1KM7SRC5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvNjHJE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvNjHJE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4651C4CEF7;
	Mon, 23 Mar 2026 16:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283039;
	bh=qg1SMW1jye+fzLbL7DnVUTLJ8HVgaqXXE5F/zNMwfDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvNjHJE7dJN5J+eTzUE0MaZomx/73y3WZZYkz02X4N/eFQKCRt0t7R+P4pJUKdBFw
	 Ml9pS9SaDspBQpI89iGh/UMwrrMGZbU7oxuBH17rH6c3Ad2omw2aY4ibbXJXtY8eXm
	 o8EQESckxGIntx1uPAJKNQi6k44VX46ZJTj8kcY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Groeneveld <kgroeneveld@lenbrook.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johnny Hao <johnny_haocn@sina.com>
Subject: [PATCH 6.1 372/481] net: fec: handle page_pool_dev_alloc_pages error
Date: Mon, 23 Mar 2026 14:45:54 +0100
Message-ID: <20260323134534.196626335@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Kevin Groeneveld <kgroeneveld@lenbrook.com>

[ Upstream commit 001ba0902046cb6c352494df610718c0763e77a5 ]

The fec_enet_update_cbd function calls page_pool_dev_alloc_pages but did
not handle the case when it returned NULL. There was a WARN_ON(!new_page)
but it would still proceed to use the NULL pointer and then crash.

This case does seem somewhat rare but when the system is under memory
pressure it can happen. One case where I can duplicate this with some
frequency is when writing over a smbd share to a SATA HDD attached to an
imx6q.

Setting /proc/sys/vm/min_free_kbytes to higher values also seems to solve
the problem for my test case. But it still seems wrong that the fec driver
ignores the memory allocation error and can crash.

This commit handles the allocation error by dropping the current packet.

Fixes: 95698ff6177b5 ("net: fec: using page pool to manage RX buffers")
Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250113154846.1765414-1-kgroeneveld@lenbrook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ The context change is due to the commit 6c8fae0caf5d
(net: fec: simplify the code logic of quirks")
in v6.2 which is irrelevant to the logic of this patch. ]
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1595,19 +1595,22 @@ fec_enet_copybreak(struct net_device *nd
 	return true;
 }
 
-static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
+static int fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 				struct bufdesc *bdp, int index)
 {
 	struct page *new_page;
 	dma_addr_t phys_addr;
 
 	new_page = page_pool_dev_alloc_pages(rxq->page_pool);
-	WARN_ON(!new_page);
-	rxq->rx_skb_info[index].page = new_page;
+	if (unlikely(!new_page))
+		return -ENOMEM;
 
+	rxq->rx_skb_info[index].page = new_page;
 	rxq->rx_skb_info[index].offset = FEC_ENET_XDP_HEADROOM;
 	phys_addr = page_pool_get_dma_addr(new_page) + FEC_ENET_XDP_HEADROOM;
 	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
+
+	return 0;
 }
 
 /* During a receive, the bd_rx.cur points to the current incoming buffer.
@@ -1632,6 +1635,7 @@ fec_enet_rx_queue(struct net_device *nde
 	int	index = 0;
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
 	struct page *page;
+	__fec32 cbd_bufaddr;
 
 #ifdef CONFIG_M532x
 	flush_cache_all();
@@ -1686,12 +1690,17 @@ fec_enet_rx_queue(struct net_device *nde
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		page = rxq->rx_skb_info[index].page;
+		cbd_bufaddr = bdp->cbd_bufaddr;
+		if (fec_enet_update_cbd(rxq, bdp, index)) {
+			ndev->stats.rx_dropped++;
+			goto rx_processing_done;
+		}
+
 		dma_sync_single_for_cpu(&fep->pdev->dev,
-					fec32_to_cpu(bdp->cbd_bufaddr),
+					fec32_to_cpu(cbd_bufaddr),
 					pkt_len,
 					DMA_FROM_DEVICE);
 		prefetch(page_address(page));
-		fec_enet_update_cbd(rxq, bdp, index);
 
 		/* The packet length includes FCS, but we don't want to
 		 * include that when passing upstream as it messes up


