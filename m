Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD7B380FE3;
	Thu, 20 Aug 2026 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239210; cv=none; b=ZGlzLRgkqwLRj6hs89Ufc/r3ryq9mrzEHmO5aQWmELSXRmdk83EPN18ZCH9eO8rPYHP8ZQqQ56YZjqncv9CFJNsbw0SmkKgs1fjJSfmiLYY/aUQouG/ZVAof7TGbkQexdFRGMpcKLL6O19aQtpLPUTNW5cNK+LYrzyUQyLQUsSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239210; c=relaxed/simple;
	bh=H4oOlq4Q9PEz6Ou0oCiaN/JrTkOyL2FiPfMcXzn7qPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJtSuI+nWX11GdDCtm2VpUhQe35aW3yT34tGzJlmv2c63UHlgn0wnmYjOIUcKyr+n/gtRuzHKbLVcDJbxw31fE3jVnfeoHEuqmy1ngsLQdUu0+iDEiFHP06G/mtowTI0cy6hQIRVThn7l3QYumQZs+W9hL5vOfm7aETEsJtAB4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXk/5aQ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXk/5aQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09F21F000E9;
	Thu, 20 Aug 2026 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239208;
	bh=gomapTNNFVyjTPuAIDY6lkzbk5kydI0ky+9FxVqXwRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXk/5aQ32k1v9AnIDqintbrcNa5An3NHiLwqu+9TycynDR+z+5sYalPQhjeG+yX/+
	 6FKhoH96NGRjxI3s+hL11eOp00/mZocgVSA1PWYp7aRjBVtGKBjDk0CWQMcQPcztrs
	 /sruq/WWucOUBgBThU+rmJ98nXawz7EAr9LI4RUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/217] veth: fix queue index used to wake the peer txq in veth_poll
Date: Thu, 20 Aug 2026 16:55:55 +0200
Message-ID: <20260820145243.349828622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ffe05e331224c..df276a646c451 100644
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



