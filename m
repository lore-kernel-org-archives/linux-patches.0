Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC55463B97;
	Mon, 31 Aug 2026 13:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183942; cv=none; b=CFciUC9bU2JPDS0uc4dKepTX8vGasbvAFu4EBSK/ilYiDvlHMuKSIY044IoGhK2zh7Tkr8XxHenXKR89hBClSKyqIAotduPuioFJ14v9HS8RF9TZfmJNMR8PI56BYhB4ahld7mKGXXTsASXMHme4xgS3nICoff2577wTFiyIXeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183942; c=relaxed/simple;
	bh=2R0nvoqJIn1F8ZgLjaKsAt83rsYix7TaWA0p6DYuaSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtMden0OdeGtpoPWIOZ2uZBlzRUqrM1XcnMhHNrQcPI4VwewjkltcqM4p0Nvvdpc1xz3zhLP7AYN1IvVN46TZhPrs5O9wK2HbSCcE7HiyQPRflXv+XOejiTgxnbQpnpSRf6OrhDuFUHj02aqt2AaGPvomU4/L1yohqddwMxiP0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVGQgvo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVGQgvo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2121F00ADB;
	Mon, 31 Aug 2026 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183939;
	bh=mY9PgslGPd50GSSR1c0+1dUPbPMhPQPl9yxiKRUmxgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVGQgvo3efOlV2StnaUCREyrVjG9nClzGirRHoMX46uXpZgQZPdgXr7mfcR+1sEFW
	 ff71F2tZyt8eHG0RYmGnU35NSdzQeDRxxT5S1S8GD3IH/pwgQgMJ7RqbKlhRDo0X4K
	 Jvzubn9HO35aocmmR1x5W0rg0davR3/3xLJsZu0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 18/83] veth: fix OOB txq access in veth_poll() with asymmetric queue counts
Date: Mon, 31 Aug 2026 15:33:54 +0200
Message-ID: <20260831133400.156430849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <hawk@kernel.org>

[ Upstream commit 08f566e8f83bb70f04ad5aba5be352c490a01c8a ]

XDP redirect into a veth device (via bpf_redirect()) calls
veth_xdp_xmit(), which enqueues frames into the peer's ptr_ring using
  smp_processor_id() % peer->real_num_rx_queues
as the ring index.  With an asymmetric veth pair where the peer has
fewer TX queues than RX queues, that index can exceed
peer->real_num_tx_queues.

veth_poll() then resolves peer_txq for the ring via:

  peer_txq = peer_dev ? netdev_get_tx_queue(peer_dev, queue_idx) : NULL;

where queue_idx = rq->xdp_rxq.queue_index.  When queue_idx exceeds
peer_dev->real_num_tx_queues this is an out-of-bounds (OOB) access
into the peer's netdev_queue array, triggering DEBUG_NET_WARN_ON_ONCE
in netdev_get_tx_queue().

The normal ndo_start_xmit path is not affected: the stack clamps
skb->queue_mapping via netdev_cap_txqueue() before invoking
ndo_start_xmit, so rxq in veth_xmit() never exceeds real_num_tx_queues.

Fix veth_poll() by clamping: only dereference peer_txq when queue_idx is
within bounds, otherwise set it to NULL.  The out-of-range rings are fed
exclusively via XDP redirect (veth_xdp_xmit), never via ndo_start_xmit
(veth_xmit), so the peer txq was never stopped and there is nothing to
wake; NULL is the correct fallback.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260502071828.616C3C19425@smtp.kernel.org/
Fixes: dc82a33297fc ("veth: apply qdisc backpressure on full ptr_ring to reduce TX drops")
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20260505132159.241305-2-hawk@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index df276a646c451..56519b646cacd 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -978,7 +978,8 @@ static int veth_poll(struct napi_struct *napi, int budget)
 
 	/* NAPI functions as RCU section */
 	peer_dev = rcu_dereference_check(priv->peer, rcu_read_lock_bh_held());
-	peer_txq = peer_dev ? netdev_get_tx_queue(peer_dev, queue_idx) : NULL;
+	peer_txq = (peer_dev && queue_idx < peer_dev->real_num_tx_queues) ?
+		   netdev_get_tx_queue(peer_dev, queue_idx) : NULL;
 
 	xdp_set_return_frame_no_direct();
 	done = veth_xdp_rcv(rq, budget, &bq, &stats);
-- 
2.53.0



