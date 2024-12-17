Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE95514A4E7;
	Tue, 17 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456139; cv=none; b=a5DNX2+fgJn9LKUd9B0ccpZnV3aorMxYbapWEb+3fI9L52FB0eLnP9IgtJejNv2jYXfwTKBP5iYw11hDdHCyTwX4eEbG7LUpFgyXupEMs/119Yj8MZzCc8+wyzOKZTYp3W3oa0SyLP9pYNTxZ07F4TrBrAPMq3AcfWJCJhOVfGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456139; c=relaxed/simple;
	bh=AWQbQwR7RRuZimNouD2LDUBgl5juxLwQWN1uWiRHDzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0rRtPYfMGrRtRImwAvZQAPft6IYNjAuuI4CyipQWBwi/b4ulkh14DPsZa8PnCvOs+7/WkfZpxVRzYUhR6wXIrP2BoaorSdrP/cfmSa4qTD3/apclL4jobSG/3/CwewZeDrD3R+PTzkKb61dQZhjIaK0pZsWhPTGJgfeV2ku5Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NU4tQyHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NU4tQyHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3439EC4CED3;
	Tue, 17 Dec 2024 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456139;
	bh=AWQbQwR7RRuZimNouD2LDUBgl5juxLwQWN1uWiRHDzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NU4tQyHJ4fdAOD33VlR++Dyf9yX2lU5jSGMlaZASHyhtuPqgIn3gGwnGHBRLrAqHd
	 BlliKR+MpZKBL7oMon3Jd5HoU0fTRQWgzI6XaSiUVZDo4S7HCLtrJF9KZQtOGkR0iL
	 ssBoOEZPbIEi6GlCLog2TTVnkP1Xs2ECxBsXVrYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/109] net: renesas: rswitch: fix race window between tx start and complete
Date: Tue, 17 Dec 2024 18:07:58 +0100
Message-ID: <20241217170536.474291355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit 0c9547e6ccf40455b0574cf589be3b152a3edf5b ]

If hardware is already transmitting, it can start handling the
descriptor being written to immediately after it observes updated DT
field, before the queue is kicked by a write to GWTRC.

If the start_xmit() execution is preempted at unfortunate moment, this
transmission can complete, and interrupt handled, before gq->cur gets
updated. With the current implementation of completion, this will cause
the last entry not completed.

Fix that by changing completion loop to check DT values directly, instead
of depending on gq->cur.

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://patch.msgid.link/20241208095004.69468-3-nikita.yoush@cogentembedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 17be2479654a..13577fe2c7ec 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -793,13 +793,10 @@ static void rswitch_tx_free(struct net_device *ndev)
 	struct rswitch_ext_desc *desc;
 	struct sk_buff *skb;
 
-	for (; rswitch_get_num_cur_queues(gq) > 0;
-	     gq->dirty = rswitch_next_queue_index(gq, false, 1)) {
-		desc = &gq->tx_ring[gq->dirty];
-		if ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
-			break;
-
+	desc = &gq->tx_ring[gq->dirty];
+	while ((desc->desc.die_dt & DT_MASK) == DT_FEMPTY) {
 		dma_rmb();
+
 		skb = gq->skbs[gq->dirty];
 		if (skb) {
 			dma_unmap_single(ndev->dev.parent,
@@ -810,7 +807,10 @@ static void rswitch_tx_free(struct net_device *ndev)
 			rdev->ndev->stats.tx_packets++;
 			rdev->ndev->stats.tx_bytes += skb->len;
 		}
+
 		desc->desc.die_dt = DT_EEMPTY;
+		gq->dirty = rswitch_next_queue_index(gq, false, 1);
+		desc = &gq->tx_ring[gq->dirty];
 	}
 }
 
@@ -1613,6 +1613,8 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	gq->skbs[gq->cur] = skb;
 	gq->unmap_addrs[gq->cur] = dma_addr_orig;
 
+	dma_wmb();
+
 	/* DT_FSTART should be set at last. So, this is reverse order. */
 	for (i = nr_desc; i-- > 0; ) {
 		desc = &gq->tx_ring[rswitch_next_queue_index(gq, true, i)];
@@ -1623,8 +1625,6 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 			goto err_unmap;
 	}
 
-	wmb();	/* gq->cur must be incremented after die_dt was set */
-
 	gq->cur = rswitch_next_queue_index(gq, true, nr_desc);
 	rswitch_modify(rdev->addr, GWTRC(gq->index), 0, BIT(gq->index % 32));
 
-- 
2.39.5



