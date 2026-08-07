Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3129476CE1;
	Fri,  7 Aug 2026 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114827; cv=none; b=NVDC7d1XFso2fCgXOiY5+xkGp/TpYL9jOV2mjlEaElONJ9tIpn+1zAoxj82XWdkJeMTTKzyJFlKhhmOdTgwpsuUxrnd3DFo9L1rLpZ1qKYs/ga4tiFTVoI8JUMC0CEThprxL36hfm87ieG03FMOJPaa9SI+qIka8SEgxZ/dUKlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114827; c=relaxed/simple;
	bh=XOjq5jjhKAGsTfAR2SzfaUe+D08TbYsJ+dvZNHDOsbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc9ZNe8XpHibaxdhAX/01MiIpF7hDnQRBE6rJUE78hCje2EN50ZqqS6zknIu5Hywnr1gnCLSgnto84iRVLrYMYpBl88i2dQ9WH6pj3Izevo4cfBEXN3y9RgxVR3QRCWJDWmfg14rN4HBWXC7hcRyy0PXkmoywDsYhFsy3dlClSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+jVnJWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+jVnJWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1961F000E9;
	Fri,  7 Aug 2026 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114825;
	bh=01k1otC35+RqOIOsCaf3Jy3jjX/BytkBlTbdkelT6As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+jVnJWMWj9454iDmUmLYcDRUtqqK1b3Y12wJsJbFGnp+cJp5sfW3ztAIURrCTWkV
	 axREF06z175rqeC1vP0WKoRncczWO3gZCcqX1geOWN5aKGUEw0Is76gPNG4D2Og0yJ
	 jDQrjBiiJJLyBk3J6FzotT/1SdcyMNs7aYcbRrzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/396] xsk: drain continuation descs after overflow in xsk_build_skb()
Date: Fri,  7 Aug 2026 16:33:42 +0200
Message-ID: <20260807143425.610933134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h |  1 +
 net/xdp/xsk.c          | 45 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 7c2bc46c67050..8a0967af8f0c4 100644
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
index 72d83b671f844..70c57c5d8e1da 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -623,6 +623,19 @@ static void xsk_cq_submit_addr_locked(struct xsk_buff_pool *pool,
 	spin_unlock_irqrestore(&pool->cq_prod_lock, flags);
 }
 
+static void xsk_cq_submit_addr_single_locked(struct xsk_buff_pool *pool,
+					     struct xdp_desc *desc)
+{
+	unsigned long flags;
+	u32 idx;
+
+	spin_lock_irqsave(&pool->cq_prod_lock, flags);
+	idx = xskq_get_prod(pool->cq);
+	xskq_prod_write_addr(pool->cq, idx, desc->addr);
+	xskq_prod_submit_n(pool->cq, 1);
+	spin_unlock_irqrestore(&pool->cq_prod_lock, flags);
+}
+
 static void xsk_cq_cancel_locked(struct xsk_buff_pool *pool, u32 n)
 {
 	spin_lock(&pool->cq_cached_prod_lock);
@@ -913,13 +926,14 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 static int __xsk_generic_xmit(struct sock *sk)
 {
 	struct xdp_sock *xs = xdp_sk(sk);
-	bool sent_frame = false;
 	struct xdp_desc desc;
 	struct sk_buff *skb;
+	u32 cached_cons;
 	u32 max_batch;
 	int err = 0;
 
 	mutex_lock(&xs->mutex);
+	cached_cons = xs->tx->cached_cons;
 
 	/* Since we dropped the RCU read lock, the socket state might have changed. */
 	if (unlikely(!xsk_is_bound(xs))) {
@@ -948,11 +962,21 @@ static int __xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
+		if (unlikely(xs->drain_cont)) {
+			xsk_cq_submit_addr_single_locked(xs->pool, &desc);
+			xs->tx->invalid_descs++;
+			xskq_cons_release(xs->tx);
+			xs->drain_cont = xp_mb_desc(&desc);
+			continue;
+		}
+
 		skb = xsk_build_skb(xs, &desc);
 		if (IS_ERR(skb)) {
 			err = PTR_ERR(skb);
 			if (err != -EOVERFLOW)
 				goto out;
+			if (xp_mb_desc(&desc))
+				xs->drain_cont = true;
 			err = 0;
 			continue;
 		}
@@ -981,18 +1005,33 @@ static int __xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
-		sent_frame = true;
 		xs->skb = NULL;
 	}
 
 	if (xskq_has_descs(xs->tx)) {
+		bool drain = xs->skb || xs->drain_cont || xp_mb_desc(&desc);
+
+		err = xsk_cq_reserve_locked(xs->pool);
+		if (err) {
+			xs->tx->invalid_descs--;
+			if (xs->skb)
+				xsk_drop_skb(xs->skb);
+			xs->drain_cont = drain;
+			err = -EAGAIN;
+			goto out;
+		}
+
 		if (xs->skb)
 			xsk_drop_skb(xs->skb);
+
+		xsk_cq_submit_addr_single_locked(xs->pool, &desc);
+
 		xskq_cons_release(xs->tx);
+		xs->drain_cont = xp_mb_desc(&desc);
 	}
 
 out:
-	if (sent_frame)
+	if (xs->tx->cached_cons != cached_cons)
 		__xsk_tx_release(xs);
 
 	mutex_unlock(&xs->mutex);
-- 
2.53.0



