Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050386;
	b=QfKTcpx4gMhaetlZ3/Uj2dDzytdN5Cq/06WBwYiV7CdZ5/C4qjk5sCiKSACx/33LolMW
	 YdavgjupGPGpy79LCBGIDI9Y+WuASeCFXiaydLsUdO7aTaOiKyvGG54iE1r+YtMt4NseG
	 vPjdZ8N0euJCyPIyksWO2LC4Kx/5MfcYEzdX9g5MRaWjM7RjeuFeswcXuPxtW14857Qdc
	 ftoVSXOtr+tvsg7I+iy8k8wU+TAVw66RCD7D85e+VNdjdhnSmHsHbYQBJAsZdCaO0IG8E
	 biWVdscQ8tGf+7OE31uuo7goETe0ITxpvAofx1hQvBxWVX4fkgZuugp41kUl6q65NNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+3B5ZH4fYWdxXMq0ML9b0dEG85M8Rjv2SikDYo+hDFw=;
	b=YdnBFqKadp8Q8iUycXtNw1wT16hq+1yDnXNgbaz9bzdECQ32buPxwY31gf+cNoZHXmA4
	 MqXI1FOTExqTzl/SXRNSpDnjxJAWheWz4fyyz2IrYkDUCS48sFgUKwaihn6ODOYoDaw4D
	 ZGJjr3L7AVLkuTLGvdv6ntKrY/XG7rj2b/Jsk6w/ujp442gaE4DxmYxcztv27A8Z3r9iR
	 iza+OmeVecxFJAjLn2jvQKShtg0d2AUmqlZJTPK2wXiq0LvShIxyIPcUohw12AfrEvvVv
	 k7O0zQIT0sz41n/gHkZzegLujC1Vo40ze8sXUJac25opFupg/5LVHmDjyZkmvGncJ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xykeRvKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E4606A32C;
	Thu, 19 Nov 2026 01:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xykeRvKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D110C1F000C4;
	Thu, 19 Nov 2026 01:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050386;
	bh=+3B5ZH4fYWdxXMq0ML9b0dEG85M8Rjv2SikDYo+hDFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xykeRvKFq4ekeKvQvTashDJvQ2HCTKpY94lvcsqdlo7y9kuQ4998RYIfRSCTbGQqS
	 7Fjvcb26SO1OsiYL8Xh0SYU8/s7Izd34IRACxr03lKPF+GwD/37FIB5o8WEXZQ4F/x
	 mcbipJnDhpNq23fAjBiFQO8RsEKz6stNsWK7YQz0=
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
Subject: [PATCH 6.1 2689/2857] veth: schedule the peers NAPI after XDP_TX when only GRO is enabled
Date: Wed, 18 Nov 2026 16:02:03 +0100
Message-ID: <20261118150338.389629564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b8a2b3be2767e..b460c021c0ef5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -555,7 +555,7 @@ static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 	rcv_priv = netdev_priv(rcv);
 	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* xdp_ring is initialized on receive side? */
-	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
+	if (unlikely(!rcu_access_pointer(rcv_rq->napi)))
 		goto out;
 
 	__veth_xdp_flush(rcv_rq);
-- 
2.53.0



