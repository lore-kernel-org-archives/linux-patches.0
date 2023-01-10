Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686B8A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA739C433EF;
	Tue, 10 Jan 2023 18:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374551;
	bh=n7tc5ARTsuv1Q+XxG3kbtY5dIk6Dmq71j1oRw9w49Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MU0jWE7rw2dlbZBFEJeBNOoRwo7VP8MYxn7u5Dd+6/YiYPC8POBWPNgB6kzK9voB7
	 M6Gp81B8wggp/emduyeEg0ikMz3BMwEbVQnp9ZGwweQScXtKUjWtRCMI5bryjIV1WB
	 hkbWfjpZbZE1+ZhbKV/AuI5FX5M+vbIXMTFHyDxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/159] bnxt_en: Simplify bnxt_xdp_buff_init()
Date: Tue, 10 Jan 2023 19:03:04 +0100
Message-Id: <20230110180019.461115293@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit bbfc17e50ba2ed18dfef46b1c433d50a58566bf1 ]

bnxt_xdp_buff_init() does not modify the data_ptr or the len parameters,
so no need to pass in the addresses of these parameters.

Fixes: b231c3f3414c ("bnxt: refactor bnxt_rx_xdp to separate xdp_init_buff/xdp_prepare_buff")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9f8a6ce4b356..0166c99cb7c6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1922,7 +1922,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	dma_addr = rx_buf->mapping;
 
 	if (bnxt_xdp_attached(bp, rxr)) {
-		bnxt_xdp_buff_init(bp, rxr, cons, &data_ptr, &len, &xdp);
+		bnxt_xdp_buff_init(bp, rxr, cons, data_ptr, len, &xdp);
 		if (agg_bufs) {
 			u32 frag_len = bnxt_rx_agg_pages_xdp(bp, cpr, &xdp,
 							     cp_cons, agg_bufs,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c3065ec0a479..1847f191577d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -177,7 +177,7 @@ bool bnxt_xdp_attached(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
 }
 
 void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
-			u16 cons, u8 **data_ptr, unsigned int *len,
+			u16 cons, u8 *data_ptr, unsigned int len,
 			struct xdp_buff *xdp)
 {
 	struct bnxt_sw_rx_bd *rx_buf;
@@ -191,13 +191,13 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	offset = bp->rx_offset;
 
 	mapping = rx_buf->mapping - bp->rx_dma_offset;
-	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
+	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, len, bp->rx_dir);
 
 	if (bp->xdp_has_frags)
 		buflen = BNXT_PAGE_MODE_BUF_SIZE + offset;
 
 	xdp_init_buff(xdp, buflen, &rxr->xdp_rxq);
-	xdp_prepare_buff(xdp, *data_ptr - offset, offset, *len, false);
+	xdp_prepare_buff(xdp, data_ptr - offset, offset, len, false);
 }
 
 void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 505911ae095d..2bbdb8e7c506 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -27,7 +27,7 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 bool bnxt_xdp_attached(struct bnxt *bp, struct bnxt_rx_ring_info *rxr);
 
 void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
-			u16 cons, u8 **data_ptr, unsigned int *len,
+			u16 cons, u8 *data_ptr, unsigned int len,
 			struct xdp_buff *xdp);
 void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
 			      struct xdp_buff *xdp);
-- 
2.35.1



