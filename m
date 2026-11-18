Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021536;
	b=tLHZCNCkMLu4czwvxDpDREXJBA6oMr3D9H9I+lUbifoA68u+MKoDchCsDp3piaqaaRfx
	 IcsWlzlzlKkPVpw8uklCgO1uhtNZcYxSnsnCNvVaWv1xYja+OG+LfnljAE6/L1ytPewI3
	 3iFyzbFJckjNWp5v734Ib6bURh3XoSDQTeHQPlpPYY6Vl8IV4hvYmUhUig/lCd/nwsJK6
	 JvEFOUBbVgFf1XYUAZWnEDL4JIu/P94IGP7fwbwPhzMvywobcQlMyP5mCNgY0c2Hy7+TO
	 xN9bHIugiUsZkTjwc6vIHZRM9JN+eBH/ZnUD7gIg82MjKzX0Q94llaRjbrzExZULSrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ews8oUb3wZU9ptNqMUd7as8umAzKcC3xoXKYr/PQ9rY=;
	b=NdHuKFCrGa4+k7ziRdn26oRxNu7ffXaGRP6TtzY/6PrzoBrne5f+qoxKeSmbEK9b7sYt
	 o5HBENUl4Gq8LTlYwrIKHtIu2JYBfA3T65smYeVp9mLpiUGU+PB0nYbTVe6so67pdk0sF
	 74411CUpXQDzjpfHfQ9jAmnRjwJcSjY7/1BEuFJAv6gUpO7joKZ+Y2NU5wSySElg5ltX4
	 fNtAp+jWgBExhnQH25kZzjuXcl4YMcw4CfMXrLWjrnDrUz/HOySsDEHzvxJd5Ewr5BaaY
	 ec3VQt3Ks97mh3I27ObFkKqj9lYLA91i76POYJKOS/Te9JvkjAzJJtl5pl8XavGRIgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aee9gUZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ACE606A32A;
	Wed, 18 Nov 2026 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aee9gUZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41131F000C9;
	Wed, 18 Nov 2026 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021536;
	bh=ews8oUb3wZU9ptNqMUd7as8umAzKcC3xoXKYr/PQ9rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aee9gUZOQ9erQ/nl29NapOhgyKUn89in3gdLd0VUtaCCfQjlPMQnR5P4oBkvF2m/M
	 dl72JynufjLrQrFAX5S4TIOmCkLcOYj74kPbE3ajd4FY45tljyN7+/njLWLadP1uDm
	 nVrDEH0aqYGx5L7dfFamp4lqXZiY0CRqT18AkTZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Gao <tianyi@cloudflare.com>,
	Mohsin Bashir <hmohsin@meta.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2342/2651] veth: schedule the peers NAPI after XDP_TX when only GRO is enabled
Date: Wed, 18 Nov 2026 15:59:42 +0100
Message-ID: <20261118150409.400134091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyi Gao <tianyi@cloudflare.com>

[ Upstream commit f16b8c6a656e62bfa7bb6a3b876f9ccdaf53bd43 ]

veth_xdp_xmit() queues XDP_TX frames on the peer's ring if the peer has
NAPI. A peer with GRO enabled and no XDP program also has NAPI.

veth_xdp_flush() then schedules the peer's NAPI, but only if the peer's
xdp_prog is set, so for such a peer the frames are never processed.
Nothing else schedules that NAPI by default.

Once the ring is full, every XDP_TX frame is dropped, and so are the
skbs that veth_xmit() queues on the same ring.

Commit 0e672f306a28 ("veth: check for NAPI instead of xdp_prog before
xmit of XDP frame") changed the check in veth_xdp_xmit() but not the one
in veth_xdp_flush(). Make veth_xdp_flush() check the napi pointer
instead of xdp_prog, as veth_xdp_xmit() does.

Fixes: 0e672f306a28 ("veth: check for NAPI instead of xdp_prog before xmit of XDP frame")
Signed-off-by: Tianyi Gao <tianyi@cloudflare.com>
Reviewed-by: Mohsin Bashir <hmohsin@meta.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20261016214217.16942-2-tianyi@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8e61f67dc37c1..e5ea979005d2a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -617,7 +617,7 @@ static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 	rcv_priv = netdev_priv(rcv);
 	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* xdp_ring is initialized on receive side? */
-	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
+	if (unlikely(!rcu_access_pointer(rcv_rq->napi)))
 		goto out;
 
 	__veth_xdp_flush(rcv_rq);
-- 
2.53.0



