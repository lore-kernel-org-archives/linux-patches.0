Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD28F37F330;
	Thu, 20 Aug 2026 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238585; cv=none; b=mB+lfRBLbbJhtVUNc1El0EMDdfRxXoA9MXpVTHd6tx+zAN5wOuIEx5QWljwhrVHUWJlYOTj69CPy6LvIWpwARC1fDBPpXdo9vkVP3z15eLPVQu8TQlPczZWzzGX235H9WAbiApr1LvwVuzweCmQ8HL8bvuxdcRswRwUA9/+b6XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238585; c=relaxed/simple;
	bh=815H0/57Xzc5XPElxOEJ93Q3I2Cfb3J3auvTJipQxSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBBTUVYhE45nh3eSli2vKdS+k1M7bcoGPSYOcMHHrC0ir4qOAMYbQvQDyuohI2qU1wt/lpuT5gWgORGzRQTnTKyFXnDQBMtZ5PXupkBwikUdsc5Zi8qiC2wsensM3N6xjx3GVbviMq1Nyc6baRis5gf9YlpJWdUbqi8gEI+26IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbS+ULNK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbS+ULNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2221B1F000E9;
	Thu, 20 Aug 2026 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238583;
	bh=YLzOwfAvbIjr3i4Qf08Avai99ufhAkc/F3qSJ298sbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbS+ULNKbTtvQoFLGwaEKy1XAhJOKPJ4+cK/FqY1oCFrB1IjWs5EWnBXbdRpJYjyp
	 by6dt0ApFLdvT/MEDPCjKKSK70Labx3oVMXH5WlkfUrpDcMcWcFn4FVzrbMKm3BY5e
	 NgXUA4dQYxvYuChZhktjico1SxejKsO72zo/TzL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 199/228] veth: fix queue index used to wake the peer txq in veth_poll
Date: Thu, 20 Aug 2026 16:55:41 +0200
Message-ID: <20260820145251.084156751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Köppeler <j.koeppeler@tu-berlin.de>

[ Upstream commit 60db47f02bfa2aa688938aa199117ec4f8e31d23 ]

veth_poll() derives the index of the peer TX queue to wake from
rq->xdp_rxq.queue_index. That field is only initialized by
xdp_rxq_info_reg() in veth_enable_xdp_range(), which runs only when an
XDP program is attached. On the plain GRO/NAPI path
(veth_napi_enable_range()) xdp_rxq_info_reg() is never called, so
queue_index stays 0 for every queue, as priv->rq is zero-allocated.

So in a multi-queue setup with GRO enabled and no XDP program attached,
every NAPI instance looks at the peer's TX queue 0. If veth_xmit() stops
peer TX queue 1 because the ptr_ring is full (NETDEV_TX_BUSY), nothing
ever wakes it again: the poller draining queue 1 wakes queue 0 instead.
veth implements no ndo_tx_timeout, so the netdev watchdog does not kick
in either, and the queue stays stopped indefinitely.

Derive the index from the position of the rq within priv->rq instead,
which is correct regardless of whether XDP was ever enabled.

Scripts to reproduce the stall are available at
https://github.com/netoptimizer/veth-backpressure-performance-testing

Fixes: dc82a33297fc ("veth: apply qdisc backpressure on full ptr_ring to reduce TX drops")
Signed-off-by: Jonas Köppeler <j.koeppeler@tu-berlin.de>
Tested-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20260806-veth-fix-poll-queue-idx-v1-1-c5357fb7573d@tu-berlin.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f80f6584a6ff9..6ab84c837a332 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -967,7 +967,7 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	struct veth_rq *rq =
 		container_of(napi, struct veth_rq, xdp_napi);
 	struct veth_priv *priv = netdev_priv(rq->dev);
-	int queue_idx = rq->xdp_rxq.queue_index;
+	int queue_idx = rq - priv->rq;
 	struct netdev_queue *peer_txq;
 	struct veth_stats stats = {};
 	struct net_device *peer_dev;
-- 
2.53.0



