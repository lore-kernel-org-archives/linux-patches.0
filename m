Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056733;
	b=GiqBFYsNgONniWtJSQHC9TLLq+iXYx8aguFUICd+Xz1X4uGJiUOAK+/kQPmtFXe4if0F
	 v8A7T9BBea+/mVCj9MALCppEJK3nuW0zNUOuJNbdrNq8r7SuJipoNcmK/Z/84AB1Wb377
	 fhPHn1YHp4jAn3AbGf2dphlZTyT0eFmYX18XZqZMr6cGeacV1SgZAMJWMwirD13GWfBsq
	 Raa+N/ZH5Z+rf30tEHUxDoVUlYH7nJnfF5BF/SHJkIS7kI4McCorSBXcQsTS3jkYaV7Ov
	 tpVQejfBdMr1RxkyWZDUW/pE0SBjZxx7oDXslUAD/TQ5oJGzWm7thkObnzopO19QsPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xByK70sz+NJRahhxyyP3X87sHXc1McxvT36w6lek+pk=;
	b=g8Idbn3B9JbyMcxE+pXacBOgev46CNQtUuNFNXWQX/pBvvPgAHJQbDk53JoVswzg6K2b
	 swybIz8fAt9TtLwa++/G1QDwxF1B1kWaqvIYuwKclDjummpF1hxiX/+Cml5lOjbvehDS5
	 KFyiJlMc6sJLPtlBh5G9JN5hotbZSK8HrHOJ3H2PQBvIgJATAWCjeVyKf9TZKibOLzmgz
	 btaq3TCEvUy23QOKZBcfKshwMqci+gi6mpI3kfvhHIqunj0I47AmQs9/48upCS0KLUtjw
	 ny83hSKQj99UAtc9RvqcNBYSzSfDGFotnNfac7TjbRqqTSgHEY7BH7rMUK+KYWlUvOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUSb8zjf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CB5606A31C;
	Thu, 19 Nov 2026 02:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUSb8zjf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E93A1F000C7;
	Thu, 19 Nov 2026 02:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056732;
	bh=xByK70sz+NJRahhxyyP3X87sHXc1McxvT36w6lek+pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUSb8zjfK0PrCRXBDcH6JdRlpPINpCf2MTnZpfGCA5m5d0GsJmm8bSXLytKiA1h13
	 1UnxJ6vw4hxzioVwJP/oUIoBc/Vent+zF0nMhqVYGRHuxOPTIEQ4rgIr8UfTaz8SR/
	 QZxxyMMscC71rnsK+lAwOuR/ctNSCaIPf8bKMqig=
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
Subject: [PATCH 5.15 2094/2214] veth: schedule the peers NAPI after XDP_TX when only GRO is enabled
Date: Wed, 18 Nov 2026 16:02:50 +0100
Message-ID: <20261118150134.422055804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 10a37c8c616f0..b6784043d348c 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -581,7 +581,7 @@ static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 	rcv_priv = netdev_priv(rcv);
 	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* xdp_ring is initialized on receive side? */
-	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
+	if (unlikely(!rcu_access_pointer(rcv_rq->napi)))
 		goto out;
 
 	__veth_xdp_flush(rcv_rq);
-- 
2.53.0



