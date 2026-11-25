Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618546;
	b=kc+eE279GHyi7aQp4MROiX6zyDs0ssMJNiZI9ubl6HYy0xWtoveW9PA4hqsdYC1sgYgd
	 2lvRT4ylIgerpyNYlF5Hj/nUfO2DqCam5TrHuZ+TLBtLzAjcW6Zx1IDN1Udmq2VTxTyRA
	 eUYyGwM+V+Fb27kYuS15Q/oK+nh1J+zFTq9sRvXaS/gY6KptemBOxgDfEBXii4XaYFo4i
	 FmmRlW2tGOR3FuwL+3M9h8aViGuYTnBM7by59H/zF+vG6IU9xetA+xEFz5os3Ec8S5puV
	 4yxq85u3qCiDpGcdU+Hfwa5Z/0bBbJAOcY2jYSDf3C7hKOssM2n30xa/w3drSuvy4og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PTB3ey1toU443RMnxmKLBIRUCJMMtj4DyJs62boGtu4=;
	b=tZFGgKjk269sE2934mQlnx2fjN2JGcFeiQZTJuoS5GvFgqohlJRg/PArDyjaGYjdvaNz
	 iKem4yGhQv2H5W34b5e63K0u31tWhmiN0Rka4rPXC22AUhNbCBbEbg9xznqbw2+7ms7EL
	 4m3LFBgV/IACGBWD/zUuIHga8VBKEwYRbzSZk3KV+2qOohIHX6iX/0QKduZbZ+BhRQXQR
	 E6Mf/589U31Dg8D0OdA73z3qoSGzZ3i1a7V9vEcde7slQpiUgdDJZrajGXovQyeAWXqd9
	 h2joA44YLyq2u6GJO3jQ79TW7IOIptCJs7H3C/DV7SQYuwAmHMTftIDzVJv/bzL6tOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooDCq4vD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BC606A326;
	Wed, 25 Nov 2026 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooDCq4vD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA06E1F000CF;
	Wed, 25 Nov 2026 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618546;
	bh=PTB3ey1toU443RMnxmKLBIRUCJMMtj4DyJs62boGtu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooDCq4vDPVsSRTtiE5mwfUPmpeyJO/BlpPGWMxy6Bfj4v9aYOfTVF+7WLzk9zYewt
	 upK1shc7T8ZeX1qEA7NBTT+Dh+l0isKcVp1MDF/HfDXFiJg6ZMo/vHa9Lut60gBZLf
	 8HVrKzVZvxozOlb4905Chr+dZM4weRSQHkyYRmFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Kain <jkain@nuro.ai>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0269/1005] net: stop defer_count outliving the deferred-free list
Date: Wed, 25 Nov 2026 15:26:47 +0100
Message-ID: <20261125143828.040187828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Joseph Kain <jkain@nuro.ai>

[ Upstream commit 241dec6f9ab74d8c3ef246764f3611666b96b9e1 ]

After the llist conversion, rejected frees retain their counter
increments. A producer racing the counter reset and list detach can
also leave a count for an skb already drained. Deferred freeing can
then remain disabled while the list is empty.

Undo rejected reservations and subtract only the number of skbs
drained. Allow admission up to the configured limit. Retain the
halfway notification and also notify when the reserved count reaches
the limit, covering reservations published after an earlier purge.

Fixes: 844c9db7f7f5 ("net: use llist for sd->defer_list")
Signed-off-by: Joseph Kain <jkain@nuro.ai>
Assisted-by: LLM
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c    |  8 +++++++-
 net/core/skbuff.c | 17 ++++++++++++++---
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6ebba16aff1c8..cc95d271a3ec8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6967,16 +6967,22 @@ static void __skb_defer_free_flush(struct skb_defer_node *sdn, int budget)
 {
 	struct llist_node *free_list;
 	struct sk_buff *skb, *next;
+	long n = 0;
 
 	if (llist_empty(&sdn->defer_list))
 		return;
-	atomic_long_set(&sdn->defer_count, 0);
 	free_list = llist_del_all(&sdn->defer_list);
 
 	llist_for_each_entry_safe(skb, next, free_list, ll_node) {
 		prefetch(next);
 		napi_consume_skb(skb, budget);
+		n++;
 	}
+	/* Subtract exactly what was drained. Never store an absolute value:
+	 * mixing one with the relative updates in skb_attempt_defer_free()
+	 * lets the counter go negative, and it is read as unsigned there.
+	 */
+	atomic_long_sub(n, &sdn->defer_count);
 }
 
 void skb_defer_node_flush(struct skb_defer_node *sdn)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 512eddc0fc3d6..54a76d6723fb7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -7408,8 +7408,14 @@ nodefer:	kfree_skb_napi_cache(skb);
 	defer_max = READ_ONCE(net_hotdata.sysctl_skb_defer_max);
 	defer_count = atomic_long_inc_return(&sdn->defer_count);
 
-	if (defer_count >= defer_max)
+	if (defer_count > defer_max) {
+		/* Undo the reservation. An llist_add() does not release one --
+		 * the skb stays charged until a flush subtracts the batch that
+		 * contains it -- so a rejected free must undo its own.
+		 */
+		atomic_long_dec(&sdn->defer_count);
 		goto nodefer;
+	}
 
 	llist_add(&skb->ll_node, &sdn->defer_list);
 
@@ -7418,8 +7424,13 @@ nodefer:	kfree_skb_napi_cache(skb);
 		return;
 	}
 
-	/* Send an IPI every time queue reaches half capacity. */
-	kick = (defer_count - 1) == (defer_max >> 1);
+	/* Half capacity, plus the skb that fills the queue. Equality alone can
+	 * be consumed early -- if the producer holding the kick value publishes
+	 * first, its purge drains only that skb and the reservations published
+	 * after it match nothing -- which would leave a full queue with nothing
+	 * pending.
+	 */
+	kick = (defer_count - 1) == (defer_max >> 1) || defer_count == defer_max;
 
 	/* Make sure to trigger NET_RX_SOFTIRQ on the remote CPU
 	 * if we are unlucky enough (this seems very unlikely).
-- 
2.53.0



