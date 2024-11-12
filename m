Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E4821745F;
	Tue, 12 Nov 2024 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408058; cv=none; b=pUzRcDhFeaQuJGHTkG+lUHCna2zoHGSX/YqWIjmvzdUHjOFK1zfZh9dkZYasjCowxJzxfqehIUZpIKhQKOmrdM127KdgVs3oNLdG6SaITi8op5RjwI4LyAN88VzibN+Q1Lsrnmz8N7EX3h1AJp0nll5u0uGc0zDpYR3xDnRWpFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408058; c=relaxed/simple;
	bh=ZzqQmaruf51SoaJGbdbQus54UNZdXC5Vc4PTD7EVIDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTzFOSdlqgF85CHbAwc2EnlB95DA6WEZqeVGpwvmgxpfMPZSz6d99nEbpF6SvBHH3Kjdor4wDBPHg6h22rjnApd4DzDnH9ezkHqae7V76x0zneQCFP5w3H73hSjeqEh2csY6sb4ygsSLJXKDjO4BP1ncJFxNC7bk+mKhanwiI/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZkwNK/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZkwNK/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EA6C4CED4;
	Tue, 12 Nov 2024 10:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408058;
	bh=ZzqQmaruf51SoaJGbdbQus54UNZdXC5Vc4PTD7EVIDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZkwNK/0B8yeEO+qdzJR8MV5wzZj/839AYzlf8b1Yiq5HeShwoy7yjak+9QSUwE5e
	 XJFO27VE2PWDVS6hmDLn9XVHreGNOhFfttfJUl0R9pkkPhXWS60RkLSuatJr+MLrFG
	 6CnSvWYAx8edX3tFgG7StFEgTrS/jLiV4O7ge9do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 046/184] net: xilinx: axienet: Enqueue Tx packets in dql before dmaengine starts
Date: Tue, 12 Nov 2024 11:20:04 +0100
Message-ID: <20241112101902.631447982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit 5ccdcdf186aec6b9111845fd37e1757e9b413e2f ]

Enqueue packets in dql after dma engine starts causes race condition.
Tx transfer starts once dma engine is started and may execute dql dequeue
in completion before it gets queued. It results in following kernel crash
while running iperf stress test:

kernel BUG at lib/dynamic_queue_limits.c:99!
<snip>
Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
pc : dql_completed+0x238/0x248
lr : dql_completed+0x3c/0x248

Call trace:
  dql_completed+0x238/0x248
  axienet_dma_tx_cb+0xa0/0x170
  xilinx_dma_do_tasklet+0xdc/0x290
  tasklet_action_common+0xf8/0x11c
  tasklet_action+0x30/0x3c
  handle_softirqs+0xf8/0x230
<snip>

Start dmaengine after enqueue in dql fixes the crash.

Fixes: 6a91b846af85 ("net: axienet: Introduce dmaengine support")
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Link: https://patch.msgid.link/20241030062533.2527042-2-suraj.gupta2@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 0c4c57e7fddc2..877f190e3af4e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -862,13 +862,13 @@ axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device *ndev)
 	skbuf_dma->sg_len = sg_len;
 	dma_tx_desc->callback_param = lp;
 	dma_tx_desc->callback_result = axienet_dma_tx_cb;
-	dmaengine_submit(dma_tx_desc);
-	dma_async_issue_pending(lp->tx_chan);
 	txq = skb_get_tx_queue(lp->ndev, skb);
 	netdev_tx_sent_queue(txq, skb->len);
 	netif_txq_maybe_stop(txq, CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX),
 			     MAX_SKB_FRAGS + 1, 2 * MAX_SKB_FRAGS);
 
+	dmaengine_submit(dma_tx_desc);
+	dma_async_issue_pending(lp->tx_chan);
 	return NETDEV_TX_OK;
 
 xmit_error_unmap_sg:
-- 
2.43.0



