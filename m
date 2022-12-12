Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DF728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E59C433D2;
	Mon, 12 Dec 2022 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852792;
	bh=+NGKycjcMmD0kRBGzEFEgVT8Bbz8POQ7HEBpkc10hpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sn/CX4qZuL1f4wBgFF42ajwRBJg4QTfL+FHT7YHgsskGYk5nqFMd+/nmczMFIZPXI
	 ayWaNHKS8eaEn1C2R1XepyeEToBsx5rZ45dWBLda+/f0he0w88FRIYYhhgKHQbDVgB
	 RLSfuz7qfIfxq/aLHjr/bxtkjp/7FhdAW30rowVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinjun Zhang <yinjun.zhang@corigine.com>,
	Richard Donkin <richard.donkin@corigine.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 115/157] nfp: correct desc type when header dma len is 4096
Date: Mon, 12 Dec 2022 14:17:43 +0100
Message-Id: <20221212130939.472392119@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit 5c306de8f787ab7df51f846e57ac79cd713537d5 ]

When there's only one buffer to dma and its length is 4096, then
only one data descriptor is needed to carry it according to current
descriptor definition. So the descriptor type should be `simple`
instead of `gather`, the latter requires more than one descriptor,
otherwise it'll be dropped by application firmware.

Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
Fixes: d9d950490a0a ("nfp: nfdk: implement xdp tx path for NFDK")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Richard Donkin <richard.donkin@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221202134646.311108-1-simon.horman@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 2b427d8ccb2f..ccacb6ab6c39 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -282,7 +282,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	dma_len = skb_headlen(skb);
 	if (skb_is_gso(skb))
 		type = NFDK_DESC_TX_TYPE_TSO;
-	else if (!nr_frags && dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	else if (!nr_frags && dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -927,7 +927,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 	dma_len = pkt_len;
 	dma_addr = rxbuf->dma_addr + dma_off;
 
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -1325,7 +1325,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	txbuf = &tx_ring->ktxbufs[wr_idx];
 
 	dma_len = skb_headlen(skb);
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
-- 
2.35.1



