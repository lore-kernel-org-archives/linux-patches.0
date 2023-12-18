Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E63A1D0;
	Mon, 18 Dec 2023 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+vy3hEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844ADC433C8;
	Mon, 18 Dec 2023 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908792;
	bh=9GLFVoFzvItoG/728pD6guthJ8HDrl3XY4zRplATp74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+vy3hEHV2rDhixfsKgpq2dUJ9PGkArY8HdPhIlGnaJ49zHpIFHC22b2gczQJNkFb
	 a7KIBwa5g0q6M40X5SrwxRgHX3tXEvqjsRKF8Q4MBh2Gw2IneEAQ+qDSWv+wo+YaBJ
	 BuIryT/sJaLRbQKv1/ozFmGL9v1GPDSGtM3lLBms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/83] net: ena: Fix xdp drops handling due to multibuf packets
Date: Mon, 18 Dec 2023 14:51:49 +0100
Message-ID: <20231218135050.978326675@linuxfoundation.org>
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

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 505b1a88d311ff6f8c44a34f94e3be21745cce6f ]

Current xdp code drops packets larger than ENA_XDP_MAX_MTU.
This is an incorrect condition since the problem is not the
size of the packet, rather the number of buffers it contains.

This commit:

1. Identifies and drops XDP multi-buffer packets at the
   beginning of the function.
2. Increases the xdp drop statistic when this drop occurs.
3. Adds a one-time print that such drops are happening to
   give better indication to the user.

Fixes: 838c93dc5449 ("net: ena: implement XDP drop support")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Link: https://lore.kernel.org/r/20231211062801.27891-3-darinzon@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index da83580a11391..7d4b862be783d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1626,20 +1626,23 @@ static void ena_set_rx_hash(struct ena_ring *rx_ring,
 	}
 }
 
-static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
+static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp, u16 num_descs)
 {
 	struct ena_rx_buffer *rx_info;
 	int ret;
 
+	/* XDP multi-buffer packets not supported */
+	if (unlikely(num_descs > 1)) {
+		netdev_err_once(rx_ring->adapter->netdev,
+				"xdp: dropped unsupported multi-buffer packets\n");
+		ena_increase_stat(&rx_ring->rx_stats.xdp_drop, 1, &rx_ring->syncp);
+		return ENA_XDP_DROP;
+	}
+
 	rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
 	xdp_prepare_buff(xdp, page_address(rx_info->page),
 			 rx_info->page_offset,
 			 rx_ring->ena_bufs[0].len, false);
-	/* If for some reason we received a bigger packet than
-	 * we expect, then we simply drop it
-	 */
-	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
-		return ENA_XDP_DROP;
 
 	ret = ena_xdp_execute(rx_ring, xdp);
 
@@ -1708,7 +1711,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			  ena_rx_ctx.l4_proto, ena_rx_ctx.hash);
 
 		if (ena_xdp_present_ring(rx_ring))
-			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp);
+			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp, ena_rx_ctx.descs);
 
 		/* allocate skb and fill it */
 		if (xdp_verdict == ENA_XDP_PASS)
-- 
2.43.0



