Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3436314B8F;
	Sat, 17 Oct 2026 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254599; cv=none; b=OMwTvwXaUTsdKVfIQV2XkXr3B2JT4cf03+EUcGhDr1WsJT0vw8rjJgbSbP+wPKhFYwkVIZWkvpSu2u5IIkHyi+K3XeJ6KWaZ0hOfuBI6+KowXxbS1vzMnIY1w5dZdVx/nFZUrc9IgZajeqlpvJvHzLMRAtzpCYj5IYQB6wRssP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254599; c=relaxed/simple;
	bh=47O4X7ZR7v9+nl9aUc17Lazvgfp751vxVnl68yf3/k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgW88zOD9KKufvp6I/5o8ZShi/r3U8r08SDlPFx/4YY7AoTAeN8tx++uoeCsKftkVwOKHC9/zz2iEmGpC3vjcf/bEWFdgrMDrbpyfiXrKCD02qIcj/VMVvMqcH+lc7uegMcDjpGhpsRhPkPeuTqEQi+ULTnajoo8YC3B8IZsLT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wUGa101; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wUGa101"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F351F000C4;
	Sat, 17 Oct 2026 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254597;
	bh=+bmJnYio5wp5TiygNzv035tcjwcn9UM0yM7L35Pq4mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wUGa101vPPwOm/syGlAU+FYeEkaNl2z98EjxzKJGJQrIL7XDfNM3D7EyNL66paVB
	 XjRD2uBdIJO5+jsyg61j1SEAp81KroxV09z0dMUQbtFhjvBeF6bcTpz3Tto5X2Qkqw
	 XM2DoqVxtQLmrVUx4dZ7Fv/Qhg48p/rAQceyDfuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 499/869] xsk: drain continuation descs after overflow in xsk_build_skb()
Date: Sat, 17 Oct 2026 17:55:40 +0200
Message-ID: <20261017160049.902813016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit bd44a6dcd4248883de90f5dad53ae80066e27096 ]

Fix generic xmit path multi-buffer logic when packets are either too big
(count of descriptors exceed MAX_SKB_FRAGS) or an invalid descriptor is
included in fragmented packet. Introduce xdp_sock::drain_cont and act
upon this flag - when it is set, keep on consuming descriptors from
AF_XDP Tx ring and put them directly onto Cq. Previously these
descriptors were silently lost and could never be reached again.

Fixes: cf24f5a5feea ("xsk: add support for AF_XDP multi-buffer on Tx path")
Closes: https://lore.kernel.org/all/20260425041726.85FB3C2BCB2@smtp.kernel.org/
Reviewed-by: Jason Xing <kernelxing@tencent.com>
Co-developed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com> # wrapped cq addr submission onto routine
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260719135609.147823-3-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 72f2b4516faf ("xsk: reclaim invalid Tx descriptors in ZC batch path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h |  1 +
 net/xdp/xsk.c          | 53 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 98491d774d826..02a0896f8525c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -80,6 +80,7 @@ struct xdp_sock {
 	 * call of __xsk_generic_xmit().
 	 */
 	struct sk_buff *skb;
+	bool drain_cont;
 
 	struct list_head map_list;
 	/* Protects map_list */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 36170e10deda4..7054f5fd7f03e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -600,6 +600,28 @@ static void xsk_cq_cancel_locked(struct xdp_sock *xs, u32 n)
 	spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 }
 
+static int xsk_cq_submit_addr_single_locked(struct xsk_buff_pool *pool,
+					    struct xdp_desc *desc)
+{
+	struct xsk_queue *cq = pool->cq;
+	unsigned long flags;
+	int err = -EAGAIN;
+
+	spin_lock_irqsave(&pool->cq_lock, flags);
+	/* Addresses are written at reserve time and publishing is positional,
+	 * so the entry can only be published if no earlier Tx is still in
+	 * flight in front of it. The caller retries later otherwise.
+	 */
+	if (cq->cached_prod == READ_ONCE(cq->ring->producer)) {
+		err = xskq_prod_reserve_addr(cq, desc->addr);
+		if (!err)
+			xskq_prod_submit_n(cq, 1);
+	}
+	spin_unlock_irqrestore(&pool->cq_lock, flags);
+
+	return err;
+}
+
 static u32 xsk_get_num_desc(struct sk_buff *skb)
 {
 	return skb ? (long)skb_shinfo(skb)->destructor_arg : 0;
@@ -822,12 +844,13 @@ static int __xsk_generic_xmit(struct sock *sk)
 {
 	struct xdp_sock *xs = xdp_sk(sk);
 	u32 max_batch = TX_BATCH_SIZE;
-	bool sent_frame = false;
 	struct xdp_desc desc;
 	struct sk_buff *skb;
+	u32 cached_cons;
 	int err = 0;
 
 	mutex_lock(&xs->mutex);
+	cached_cons = xs->tx->cached_cons;
 
 	/* Since we dropped the RCU read lock, the socket state might have changed. */
 	if (unlikely(!xsk_is_bound(xs))) {
@@ -844,6 +867,17 @@ static int __xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
+		if (unlikely(xs->drain_cont)) {
+			if (xsk_cq_submit_addr_single_locked(xs->pool, &desc)) {
+				err = -EAGAIN;
+				goto out;
+			}
+			xs->tx->invalid_descs++;
+			xskq_cons_release(xs->tx);
+			xs->drain_cont = xp_mb_desc(&desc);
+			continue;
+		}
+
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
@@ -857,6 +891,8 @@ static int __xsk_generic_xmit(struct sock *sk)
 			err = PTR_ERR(skb);
 			if (err != -EOVERFLOW)
 				goto out;
+			if (xp_mb_desc(&desc))
+				xs->drain_cont = true;
 			err = 0;
 			continue;
 		}
@@ -885,18 +921,29 @@ static int __xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
-		sent_frame = true;
 		xs->skb = NULL;
 	}
 
 	if (xskq_has_descs(xs->tx)) {
+		bool drain = xs->skb || xs->drain_cont || xp_mb_desc(&desc);
+
 		if (xs->skb)
 			xsk_drop_skb(xs->skb);
+
+		err = xsk_cq_submit_addr_single_locked(xs->pool, &desc);
+		if (err) {
+			xs->tx->invalid_descs--;
+			xs->drain_cont = drain;
+			err = -EAGAIN;
+			goto out;
+		}
+
 		xskq_cons_release(xs->tx);
+		xs->drain_cont = xp_mb_desc(&desc);
 	}
 
 out:
-	if (sent_frame)
+	if (xs->tx->cached_cons != cached_cons)
 		if (xsk_tx_writeable(xs))
 			sk->sk_write_space(sk);
 
-- 
2.53.0



