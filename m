Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98091BE222;
	Tue,  2 Jul 2024 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940036; cv=none; b=rbOwDSE/l+cunwzCcPAAjIh875C/rTt+SEdeh3vvQWpISpoYNBpq1WT5qMklZAZjWcj9e5IVmboCB5+HZr0QR/E67MvXPWTTIndlD3QQyGnhSx4859BUZWGRpfhYsviSDwWt3YQBV5dIPuAq5B2w9Mo0kD8RaTxX4kY16EcF6/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940036; c=relaxed/simple;
	bh=RuKdTle0IDLSbzCl7PcLx085U6Y9cD4ZZ96fAK64z9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvVSpFVA7PqcmryFNDHk+qZ7DoU6eb2YUq143PGwKAp2zwSYC0atJTabRrpWrYMv+vXDjKmJDOrxabtOpGgcVqIIlQLsjL/oRTMqVTE9fu2DyCwS0FnPyDseHTZs2UFviWCZ681JX/ieWmwXFNS7pDuKF1FOwy1OYvBBnFdLIwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gorNA/Qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gorNA/Qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2859EC116B1;
	Tue,  2 Jul 2024 17:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940036;
	bh=RuKdTle0IDLSbzCl7PcLx085U6Y9cD4ZZ96fAK64z9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gorNA/QqfVJxBcvZbssJDsH5v39D7QP6VPcQ6l8NIVYOOQUEaQTdqS/NDKfaDb7wZ
	 lQpZQxwRUh5lKiRi9Kkh5JlKA1969c9oGQGEyQquQ72IWg/EQn4z1OE4FbSr5NEXQb
	 Neg9o5tMkYH8xF6WKtKQyv8aMZcx1Q7UjHG+m7+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 033/222] ionic: fix kernel panic due to multi-buffer handling
Date: Tue,  2 Jul 2024 19:01:11 +0200
Message-ID: <20240702170245.243095837@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit e3f02f32a05009a688a87f5799e049ed6b55bab5 ]

Currently, the ionic_run_xdp() doesn't handle multi-buffer packets
properly for XDP_TX and XDP_REDIRECT.
When a jumbo frame is received, the ionic_run_xdp() first makes xdp
frame with all necessary pages in the rx descriptor.
And if the action is either XDP_TX or XDP_REDIRECT, it should unmap
dma-mapping and reset page pointer to NULL for all pages, not only the
first page.
But it doesn't for SG pages. So, SG pages unexpectedly will be reused.
It eventually causes kernel panic.

Oops: general protection fault, probably for non-canonical address 0x504f4e4dbebc64ff: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 6.10.0-rc3+ #25
RIP: 0010:xdp_return_frame+0x42/0x90
Code: 01 75 12 5b 4c 89 e6 5d 31 c9 41 5c 31 d2 41 5d e9 73 fd ff ff 44 8b 6b 20 0f b7 43 0a 49 81 ed 68 01 00 00 49 29 c5 49 01 fd <41> 80 7d0
RSP: 0018:ffff99d00122ce08 EFLAGS: 00010202
RAX: 0000000000005453 RBX: ffff8d325f904000 RCX: 0000000000000001
RDX: 00000000670e1000 RSI: 000000011f90d000 RDI: 504f4e4d4c4b4a49
RBP: ffff99d003907740 R08: 0000000000000000 R09: 0000000000000000
R10: 000000011f90d000 R11: 0000000000000000 R12: ffff8d325f904010
R13: 504f4e4dbebc64fd R14: ffff8d3242b070c8 R15: ffff99d0039077c0
FS:  0000000000000000(0000) GS:ffff8d399f780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f41f6c85e38 CR3: 000000037ac30000 CR4: 00000000007506f0
PKRU: 55555554
Call Trace:
 <IRQ>
 ? die_addr+0x33/0x90
 ? exc_general_protection+0x251/0x2f0
 ? asm_exc_general_protection+0x22/0x30
 ? xdp_return_frame+0x42/0x90
 ionic_tx_clean+0x211/0x280 [ionic 15881354510e6a9c655c59c54812b319ed2cd015]
 ionic_tx_cq_service+0xd3/0x210 [ionic 15881354510e6a9c655c59c54812b319ed2cd015]
 ionic_txrx_napi+0x41/0x1b0 [ionic 15881354510e6a9c655c59c54812b319ed2cd015]
 __napi_poll.constprop.0+0x29/0x1b0
 net_rx_action+0x2c4/0x350
 handle_softirqs+0xf4/0x320
 irq_exit_rcu+0x78/0xa0
 common_interrupt+0x77/0x90

Fixes: 5377805dc1c0 ("ionic: implement xdp frags support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 2427610f4306d..aed7d9cbce038 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -480,6 +480,20 @@ int ionic_xdp_xmit(struct net_device *netdev, int n,
 	return nxmit;
 }
 
+static void ionic_xdp_rx_put_bufs(struct ionic_queue *q,
+				  struct ionic_buf_info *buf_info,
+				  int nbufs)
+{
+	int i;
+
+	for (i = 0; i < nbufs; i++) {
+		dma_unmap_page(q->dev, buf_info->dma_addr,
+			       IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
+		buf_info->page = NULL;
+		buf_info++;
+	}
+}
+
 static bool ionic_run_xdp(struct ionic_rx_stats *stats,
 			  struct net_device *netdev,
 			  struct bpf_prog *xdp_prog,
@@ -493,6 +507,7 @@ static bool ionic_run_xdp(struct ionic_rx_stats *stats,
 	struct netdev_queue *nq;
 	struct xdp_frame *xdpf;
 	int remain_len;
+	int nbufs = 1;
 	int frag_len;
 	int err = 0;
 
@@ -542,6 +557,7 @@ static bool ionic_run_xdp(struct ionic_rx_stats *stats,
 			if (page_is_pfmemalloc(bi->page))
 				xdp_buff_set_frag_pfmemalloc(&xdp_buf);
 		} while (remain_len > 0);
+		nbufs += sinfo->nr_frags;
 	}
 
 	xdp_action = bpf_prog_run_xdp(xdp_prog, &xdp_buf);
@@ -574,9 +590,6 @@ static bool ionic_run_xdp(struct ionic_rx_stats *stats,
 			goto out_xdp_abort;
 		}
 
-		dma_unmap_page(rxq->dev, buf_info->dma_addr,
-			       IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
-
 		err = ionic_xdp_post_frame(txq, xdpf, XDP_TX,
 					   buf_info->page,
 					   buf_info->page_offset,
@@ -586,23 +599,19 @@ static bool ionic_run_xdp(struct ionic_rx_stats *stats,
 			netdev_dbg(netdev, "tx ionic_xdp_post_frame err %d\n", err);
 			goto out_xdp_abort;
 		}
-		buf_info->page = NULL;
+		ionic_xdp_rx_put_bufs(rxq, buf_info, nbufs);
 		stats->xdp_tx++;
 
 		/* the Tx completion will free the buffers */
 		break;
 
 	case XDP_REDIRECT:
-		/* unmap the pages before handing them to a different device */
-		dma_unmap_page(rxq->dev, buf_info->dma_addr,
-			       IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
-
 		err = xdp_do_redirect(netdev, &xdp_buf, xdp_prog);
 		if (err) {
 			netdev_dbg(netdev, "xdp_do_redirect err %d\n", err);
 			goto out_xdp_abort;
 		}
-		buf_info->page = NULL;
+		ionic_xdp_rx_put_bufs(rxq, buf_info, nbufs);
 		rxq->xdp_flush = true;
 		stats->xdp_redirect++;
 		break;
-- 
2.43.0



