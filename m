Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E5C31D393;
	Mon, 27 Oct 2025 19:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592829; cv=none; b=MidmEx8otSleB/Z3PByfOoI6GKJm/rRAMwdiTHytchn4TcSNBuEpPiXEbsiTlrPqSox53pe3HAyz6BmNd5HIsURZkno8j0r/lewd8da+4LXBMIMkyQ+AgGo7NEOqG8MoP6KjhVOAlauIBcgf+T0bBXnRJvqkzlKvGs9279uWEfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592829; c=relaxed/simple;
	bh=uLswryaAHFQmz0xuuQ985dmLUuSqOwmtr4B50F4Omqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFe1yzr+LMIJSgy6A3/YIaH7e6Z+FC3D10KyQkYuiRfE+yp5UIHsaiWGaync4c6eIRL0+vu+8ZNfErXIlmuHzhHPutPdsAuWZPXp/lfMA4p5rLn5tb25qn0cbpUnCruu3j/VnJHDKDpq6KD8gO08GfY3Gml+52WLcyQG2Ik7eqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RD6V+EZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RD6V+EZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FBBC4CEF1;
	Mon, 27 Oct 2025 19:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592828;
	bh=uLswryaAHFQmz0xuuQ985dmLUuSqOwmtr4B50F4Omqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RD6V+EZC/POR3u12Np8jL1ciYzsIEwhqzxJB2fVuzLvElLvRsZcXKUUdoj+FcdSw7
	 LCZHFRkqagMhL0rjFkntb+nPBeCaIj4jvdUMi2OnF0YzBLwJ48Td+nsiV4erjK3w+I
	 QDYoNggWt2Hc4ewzk96n0i/sYaUidSTbitpUdtiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/117] net: enetc: fix the deadlock of enetc_mdio_lock
Date: Mon, 27 Oct 2025 19:35:53 +0100
Message-ID: <20251027183454.700074878@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

[ Upstream commit 50bd33f6b3922a6b760aa30d409cae891cec8fb5 ]

After applying the workaround for err050089, the LS1028A platform
experiences RCU stalls on RT kernel. This issue is caused by the
recursive acquisition of the read lock enetc_mdio_lock. Here list some
of the call stacks identified under the enetc_poll path that may lead to
a deadlock:

enetc_poll
  -> enetc_lock_mdio
  -> enetc_clean_rx_ring OR napi_complete_done
     -> napi_gro_receive
        -> enetc_start_xmit
           -> enetc_lock_mdio
           -> enetc_map_tx_buffs
           -> enetc_unlock_mdio
  -> enetc_unlock_mdio

After enetc_poll acquires the read lock, a higher-priority writer attempts
to acquire the lock, causing preemption. The writer detects that a
read lock is already held and is scheduled out. However, readers under
enetc_poll cannot acquire the read lock again because a writer is already
waiting, leading to a thread hang.

Currently, the deadlock is avoided by adjusting enetc_lock_mdio to prevent
recursive lock acquisition.

Fixes: 6d36ecdbc441 ("net: enetc: take the MDIO lock only once per NAPI poll cycle")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Acked-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20251015021427.180757-1-jianpeng.chang.cn@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 25 ++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index d8272b7a55fcb..749b65aab14a9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1246,6 +1246,8 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 	/* next descriptor to process */
 	i = rx_ring->next_to_clean;
 
+	enetc_lock_mdio();
+
 	while (likely(rx_frm_cnt < work_limit)) {
 		union enetc_rx_bd *rxbd;
 		struct sk_buff *skb;
@@ -1281,7 +1283,9 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		rx_byte_cnt += skb->len + ETH_HLEN;
 		rx_frm_cnt++;
 
+		enetc_unlock_mdio();
 		napi_gro_receive(napi, skb);
+		enetc_lock_mdio();
 	}
 
 	rx_ring->next_to_clean = i;
@@ -1289,6 +1293,8 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 	rx_ring->stats.packets += rx_frm_cnt;
 	rx_ring->stats.bytes += rx_byte_cnt;
 
+	enetc_unlock_mdio();
+
 	return rx_frm_cnt;
 }
 
@@ -1598,6 +1604,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 	/* next descriptor to process */
 	i = rx_ring->next_to_clean;
 
+	enetc_lock_mdio();
+
 	while (likely(rx_frm_cnt < work_limit)) {
 		union enetc_rx_bd *rxbd, *orig_rxbd;
 		int orig_i, orig_cleaned_cnt;
@@ -1657,7 +1665,9 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 			if (unlikely(!skb))
 				goto out;
 
+			enetc_unlock_mdio();
 			napi_gro_receive(napi, skb);
+			enetc_lock_mdio();
 			break;
 		case XDP_TX:
 			tx_ring = priv->xdp_tx_ring[rx_ring->index];
@@ -1692,7 +1702,9 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 			}
 			break;
 		case XDP_REDIRECT:
+			enetc_unlock_mdio();
 			err = xdp_do_redirect(rx_ring->ndev, &xdp_buff, prog);
+			enetc_lock_mdio();
 			if (unlikely(err)) {
 				enetc_xdp_drop(rx_ring, orig_i, i);
 				rx_ring->stats.xdp_redirect_failures++;
@@ -1712,8 +1724,11 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 	rx_ring->stats.packets += rx_frm_cnt;
 	rx_ring->stats.bytes += rx_byte_cnt;
 
-	if (xdp_redirect_frm_cnt)
+	if (xdp_redirect_frm_cnt) {
+		enetc_unlock_mdio();
 		xdp_do_flush();
+		enetc_lock_mdio();
+	}
 
 	if (xdp_tx_frm_cnt)
 		enetc_update_tx_ring_tail(tx_ring);
@@ -1722,6 +1737,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring) -
 				     rx_ring->xdp.xdp_tx_in_flight);
 
+	enetc_unlock_mdio();
+
 	return rx_frm_cnt;
 }
 
@@ -1740,6 +1757,7 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	for (i = 0; i < v->count_tx_rings; i++)
 		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
 			complete = false;
+	enetc_unlock_mdio();
 
 	prog = rx_ring->xdp.prog;
 	if (prog)
@@ -1751,10 +1769,8 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	if (work_done)
 		v->rx_napi_work = true;
 
-	if (!complete) {
-		enetc_unlock_mdio();
+	if (!complete)
 		return budget;
-	}
 
 	napi_complete_done(napi, work_done);
 
@@ -1763,6 +1779,7 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 
 	v->rx_napi_work = false;
 
+	enetc_lock_mdio();
 	/* enable interrupts */
 	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
 
-- 
2.51.0



