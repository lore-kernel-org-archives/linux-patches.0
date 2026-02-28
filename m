Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD1373143;
	Sat, 28 Feb 2026 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301510; cv=none; b=BklviG+ydFrM8lqapVs2IULLkaotZnKu34V3xuAsMyG46gAvHAjDTP0LpmfcAaQmjBAQqkHSds0xQsVgvCrAgE68KB93lYxd9i1E397pP47U4in6Yqbjtsd1IARjZSdxWlM1NP+RwDWJHVwOGWeIQtaLuOxVT0bhKTU+rh5TKDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301510; c=relaxed/simple;
	bh=RczUF9kkuILK3lHcDztuudYaK1X19QCq4DINrhOjoqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9y7OUHB8B4b76w83wlYF7nETRsSUukJg/qQahYOISvtPJ7SKhMoNHSAmf+VTiGPELrQJHHZlhwUbMOIDhOCJTlw68ji8LBaTbv11TpOt3F0gjEJmFS8xfMzm/eXnjOVQJVcaTrwgxpMGnVGRjdoXDhOi93LKdSXHhR8pT+vhh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUSDUCKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUSDUCKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B46AC116D0;
	Sat, 28 Feb 2026 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301510;
	bh=RczUF9kkuILK3lHcDztuudYaK1X19QCq4DINrhOjoqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUSDUCKFwIupdwNInFQKgpOh3NGu8oZXzDQMYJmgQt4SkqnF0QVdUnEjjz8EwEsDw
	 KkHEBDZKiO/G590O3Sb6L4uh2SSvqldgh+R2lsOkxSpSzfscmkvp2aqNBc1t7Se/cF
	 I+DmiAnhoa/xvE3DRk4iyBq7AYm2Nsjdt+m+l5tcHI6Tpk1dJc+rS9NwvkwCAtfTEh
	 H8BZVSWTy9ia0Sh4DowdAYDzrqyTSRs0Pq7GS+BCOIr1gO9HlcQWKnvBdCnoay48vn
	 00c4YhSuA+FvY/3U1od8vYKqbQF8dQ4AAVgcWuR7fFt1g6lcz7vnC+Ag2TzTNwsLmE
	 VZK99AD9dL7aA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kevin Hao <haokexin@gmail.com>,
	stable@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 696/752] net: macb: Fix tx/rx malfunction after phy link down and up
Date: Sat, 28 Feb 2026 12:46:47 -0500
Message-ID: <20260228174750.1542406-696-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit bf9cf80cab81e39701861a42877a28295ade266f ]

In commit 99537d5c476c ("net: macb: Relocate mog_init_rings() callback
from macb_mac_link_up() to macb_open()"), the mog_init_rings() callback
was moved from macb_mac_link_up() to macb_open() to resolve a deadlock
issue. However, this change introduced a tx/rx malfunction following
phy link down and up events. The issue arises from a mismatch between
the software queue->tx_head, queue->tx_tail, queue->rx_prepared_head,
and queue->rx_tail values and the hardware's internal tx/rx queue
pointers.

According to the Zynq UltraScale TRM [1], when tx/rx is disabled, the
internal tx queue pointer resets to the value in the tx queue base
address register, while the internal rx queue pointer remains unchanged.
The following is quoted from the Zynq UltraScale TRM:
  When transmit is disabled, with bit [3] of the network control register
  set low, the transmit-buffer queue pointer resets to point to the address
  indicated by the transmit-buffer queue base address register. Disabling
  receive does not have the same effect on the receive-buffer queue
  pointer.

Additionally, there is no need to reset the RBQP and TBQP registers in a
phy event callback. Therefore, move macb_init_buffers() to macb_open().
In a phy link up event, the only required action is to reset the tx
software head and tail pointers to align with the hardware's behavior.

[1] https://docs.amd.com/v/u/en-US/ug1085-zynq-ultrascale-trm

Fixes: 99537d5c476c ("net: macb: Relocate mog_init_rings() callback from macb_mac_link_up() to macb_open()")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260208-macb-init-ring-v1-1-939a32c14635@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 064fccdcf6994..90550055c71c1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -741,14 +741,12 @@ static void macb_mac_link_up(struct phylink_config *config,
 		if (rx_pause)
 			ctrl |= MACB_BIT(PAE);
 
-		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
-		 * cleared the pipeline and control registers.
-		 */
-		macb_init_buffers(bp);
-
-		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
+		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
+			queue->tx_head = 0;
+			queue->tx_tail = 0;
 			queue_writel(queue, IER,
 				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
+		}
 	}
 
 	macb_or_gem_writel(bp, NCFGR, ctrl);
@@ -2991,6 +2989,7 @@ static int macb_open(struct net_device *dev)
 	}
 
 	bp->macbgem_ops.mog_init_rings(bp);
+	macb_init_buffers(bp);
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		napi_enable(&queue->napi_rx);
-- 
2.51.0

