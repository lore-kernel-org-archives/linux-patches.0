Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811B81D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HELR11+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3550C433C8;
	Wed,  4 Oct 2023 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443973;
	bh=ce2eTZWOc1CWl4QWDj/2vX1tjzamRwsPTvpKWnt5DPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HELR11+arfHKj61KaQYbS1svca3RfA4x9AuYEKLSY1MffVSM3+/k7hmdDA5Xb8sl1
	 hgw5ZBtsadsbLfySq25ftASZkeruka1b9iT3bZEXGiD1sWWVYzIDTjiijqJbeq+Go8
	 +DeaYL1i/eQJS3MhBgUDK2WK/x4xXlG4mAkoIfJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinas Rasheed <srasheed@marvell.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 057/321] octeon_ep: fix tx dma unmap len values in SG
Date: Wed,  4 Oct 2023 19:53:22 +0200
Message-ID: <20231004175231.809344363@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shinas Rasheed <srasheed@marvell.com>

[ Upstream commit 350db8a59eb392bf42e62b6b2a37d56b5833012b ]

Lengths of SG pointers are kept in the following order in
the SG entries in hardware.
 63      48|47     32|31     16|15       0
 -----------------------------------------
 |  Len 0  |  Len 1  |  Len 2  |  Len 3  |
 -----------------------------------------
 |                Ptr 0                  |
 -----------------------------------------
 |                Ptr 1                  |
 -----------------------------------------
 |                Ptr 2                  |
 -----------------------------------------
 |                Ptr 3                  |
 -----------------------------------------
Dma pointers have to be unmapped based on their
respective lengths given in this format.

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeon_ep/octep_main.c  |  8 ++++----
 .../net/ethernet/marvell/octeon_ep/octep_tx.c    |  8 ++++----
 .../net/ethernet/marvell/octeon_ep/octep_tx.h    | 16 +++++++++++++++-
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 4424de2ffd70c..dbc518ff82768 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -734,13 +734,13 @@ static netdev_tx_t octep_start_xmit(struct sk_buff *skb,
 dma_map_sg_err:
 	if (si > 0) {
 		dma_unmap_single(iq->dev, sglist[0].dma_ptr[0],
-				 sglist[0].len[0], DMA_TO_DEVICE);
-		sglist[0].len[0] = 0;
+				 sglist[0].len[3], DMA_TO_DEVICE);
+		sglist[0].len[3] = 0;
 	}
 	while (si > 1) {
 		dma_unmap_page(iq->dev, sglist[si >> 2].dma_ptr[si & 3],
-			       sglist[si >> 2].len[si & 3], DMA_TO_DEVICE);
-		sglist[si >> 2].len[si & 3] = 0;
+			       sglist[si >> 2].len[3 - (si & 3)], DMA_TO_DEVICE);
+		sglist[si >> 2].len[3 - (si & 3)] = 0;
 		si--;
 	}
 	tx_buffer->gather = 0;
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
index 5a520d37bea02..d0adb82d65c31 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
@@ -69,12 +69,12 @@ int octep_iq_process_completions(struct octep_iq *iq, u16 budget)
 		compl_sg++;
 
 		dma_unmap_single(iq->dev, tx_buffer->sglist[0].dma_ptr[0],
-				 tx_buffer->sglist[0].len[0], DMA_TO_DEVICE);
+				 tx_buffer->sglist[0].len[3], DMA_TO_DEVICE);
 
 		i = 1; /* entry 0 is main skb, unmapped above */
 		while (frags--) {
 			dma_unmap_page(iq->dev, tx_buffer->sglist[i >> 2].dma_ptr[i & 3],
-				       tx_buffer->sglist[i >> 2].len[i & 3], DMA_TO_DEVICE);
+				       tx_buffer->sglist[i >> 2].len[3 - (i & 3)], DMA_TO_DEVICE);
 			i++;
 		}
 
@@ -131,13 +131,13 @@ static void octep_iq_free_pending(struct octep_iq *iq)
 
 		dma_unmap_single(iq->dev,
 				 tx_buffer->sglist[0].dma_ptr[0],
-				 tx_buffer->sglist[0].len[0],
+				 tx_buffer->sglist[0].len[3],
 				 DMA_TO_DEVICE);
 
 		i = 1; /* entry 0 is main skb, unmapped above */
 		while (frags--) {
 			dma_unmap_page(iq->dev, tx_buffer->sglist[i >> 2].dma_ptr[i & 3],
-				       tx_buffer->sglist[i >> 2].len[i & 3], DMA_TO_DEVICE);
+				       tx_buffer->sglist[i >> 2].len[3 - (i & 3)], DMA_TO_DEVICE);
 			i++;
 		}
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
index 2ef57980eb47b..21e75ff9f5e71 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
@@ -17,7 +17,21 @@
 #define TX_BUFTYPE_NET_SG        2
 #define NUM_TX_BUFTYPES          3
 
-/* Hardware format for Scatter/Gather list */
+/* Hardware format for Scatter/Gather list
+ *
+ * 63      48|47     32|31     16|15       0
+ * -----------------------------------------
+ * |  Len 0  |  Len 1  |  Len 2  |  Len 3  |
+ * -----------------------------------------
+ * |                Ptr 0                  |
+ * -----------------------------------------
+ * |                Ptr 1                  |
+ * -----------------------------------------
+ * |                Ptr 2                  |
+ * -----------------------------------------
+ * |                Ptr 3                  |
+ * -----------------------------------------
+ */
 struct octep_tx_sglist_desc {
 	u16 len[4];
 	dma_addr_t dma_ptr[4];
-- 
2.40.1



