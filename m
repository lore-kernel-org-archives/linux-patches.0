Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B902C63A5;
	Sat, 30 Dec 2023 12:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLK9ztBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425B0C433C7;
	Sat, 30 Dec 2023 12:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937831;
	bh=3BXQr6o9TOFoHsUF4dGtjcfEXSGNAePHFYgPIoXDIM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLK9ztBxv/V9IECgt71y/VRcbe6+DfcR7aklyCKFvLermh79WfLwwiF4wx2t8nRnt
	 Igj5UkOPckMmfmGjjW0TGxnawqvowdIvI9S3VVpLS6Cax5AIWXIlrfQ0cb0KzGyc9y
	 EWSx/BbvJsmqtASOQb8DCi5MOdRB70YWqSVombNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/156] bnxt_en: do not map packet buffers twice
Date: Sat, 30 Dec 2023 11:58:29 +0000
Message-ID: <20231230115814.135415743@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Andy Gospodarek <andrew.gospodarek@broadcom.com>

[ Upstream commit 23c93c3b6275a59f2a685f4a693944b53c31df4e ]

Remove double-mapping of DMA buffers as it can prevent page pool entries
from being freed.  Mapping is managed by page pool infrastructure and
was previously managed by the driver in __bnxt_alloc_rx_page before
allowing the page pool infrastructure to manage it.

Fixes: 578fcfd26e2a ("bnxt_en: Let the page pool manage the DMA mapping")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: David Wei <dw@davidwei.uk>
Link: https://lore.kernel.org/r/20231214213138.98095-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 96f5ca778c67d..8cb9a99154aad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -59,7 +59,6 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 	for (i = 0; i < num_frags ; i++) {
 		skb_frag_t *frag = &sinfo->frags[i];
 		struct bnxt_sw_tx_bd *frag_tx_buf;
-		struct pci_dev *pdev = bp->pdev;
 		dma_addr_t frag_mapping;
 		int frag_len;
 
@@ -73,16 +72,10 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 		txbd = &txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
 
 		frag_len = skb_frag_size(frag);
-		frag_mapping = skb_frag_dma_map(&pdev->dev, frag, 0,
-						frag_len, DMA_TO_DEVICE);
-
-		if (unlikely(dma_mapping_error(&pdev->dev, frag_mapping)))
-			return NULL;
-
-		dma_unmap_addr_set(frag_tx_buf, mapping, frag_mapping);
-
 		flags = frag_len << TX_BD_LEN_SHIFT;
 		txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
+		frag_mapping = page_pool_get_dma_addr(skb_frag_page(frag)) +
+			       skb_frag_off(frag);
 		txbd->tx_bd_haddr = cpu_to_le64(frag_mapping);
 
 		len = frag_len;
-- 
2.43.0



