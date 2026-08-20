Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73B119E992;
	Thu, 20 Aug 2026 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247253; cv=none; b=tARpJprVbDznaOMkmEVoVlLaah9ozSoEVZ4GXTd+XoaxMI7Jj+s/IQMVII9fR6Ig9A8lv5cezT0PWwT+fgaCJGbvj0PcGlDYpPThrzns9mEn7sWOg5Fan34WL1I15p3Mz0u99O3fPNnt+TLUD7+AJ/HNJj0HqfKQMXDHUEezGZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247253; c=relaxed/simple;
	bh=Zx2dR90oR5KYRgfczhjXpXXK7N83NbitFF3im6YNeKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fheuvZ19n+lDB4TakKwgyDPpqioiXzu8OWYIDiE+jC/ecHYo7kavPue6ZWmKI++XVyXA/h/7+ZBjHkjCDXEapldpy4QVyeK3Wv7TEBzES6YgLLaidoG1Dtx7vdiRPSJEQacnvgym0Dk7zgCoHHxrAW7wQL1o4c30nVJllMFe5/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8uoyisg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8uoyisg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E181F000E9;
	Thu, 20 Aug 2026 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247252;
	bh=jHmk5sodHNeYkCJ2nXkS6PjOj/eW7g/ycBnanLGKJfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8uoyisgu2flUkU0k8O4t2l6N7po/o5h/yqpaDiVERenGGGa3LocDjba+Lh7uiMgp
	 rK6XeaIh2vnzNbdjSjhXCi4GXhTeXCw9xjId01wFi6jZz09SRDpBSz/gdfY827wnhQ
	 OVtvZ8jcHku4cZl1VVav5UuzWGAmCmQoCoqVLm6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/220] veth: fix queue index used to wake the peer txq in veth_poll
Date: Thu, 20 Aug 2026 16:56:32 +0200
Message-ID: <20260820145229.585901230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2feb694f58bb9..96e373d65897c 100644
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



