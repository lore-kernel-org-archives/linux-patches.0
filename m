Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1BE4611E1;
	Sat, 12 Sep 2026 15:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226266; cv=none; b=KO5gGm38Bk1YTU+xUtZ8LtYtsY/pb3En2mZ+7KPKPuBfADV5RSjIjhmiz6GTisP91oFgh7iYm+QrMkyLgRBX4o2clsAj+QZKsHxTP+k8nsr134rKlmojLPJyqYzRVGPhO5ayvizRVRFfSskRLpsx1AjGDBHz2hBHhuyg2rPYFOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226266; c=relaxed/simple;
	bh=+adFJ1I1/Ej/1jDNQ9zmevl4i24trQxbWCeewrdLL0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqMj/rL1GNyyKvEAYUeXVKwBpNnjJlcvAuaCFzP0JzbndsqiF0nQrUIo45WghDO4T5bNg68uGcJsROnVYuKR1wJzatnfvyuE3FaWTR+5bFRmOyck5lV7uPh5AQwaY3Yd6fmwgZNDCBf3s6AegcjKv+SSfXnZr565AicQeeciEQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRjaye0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRjaye0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A83E1F000FF;
	Sat, 12 Sep 2026 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226264;
	bh=7FA6Rp5DNbPdPQWzslR86fBxkTsBMX2BkFhKkocg8pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRjaye0zanFkbjCOw3JGbJfNVPK9UmP0wIXW1i7vumoNRIS3fyFe0lPh9Ey+54Chg
	 LQk8+RyJxGnLeC6785CvebGzB3ERFwueDhLc0asbwzzXX/VSoI0+Oxpv5Om2YnmaCJ
	 /755hToDrjVEJ3cLzIfsVwceEmj5KK26gnzN5q1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1325/1424] xsk: avoid double checking against rx queue being full
Date: Sat, 12 Sep 2026 09:02:37 +0200
Message-ID: <20260912065636.932374627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit f620af11c27b8ec9994a39fe968aa778112d1566 ]

Currently non-zc xsk rx path for multi-buffer case checks twice if xsk
rx queue has enough space for producing descriptors:
1.
	if (xskq_prod_nb_free(xs->rx, num_desc) < num_desc) {
		xs->rx_queue_full++;
		return -ENOBUFS;
	}
2.
	__xsk_rcv_zc(xs, xskb, copied - meta_len, rem ? XDP_PKT_CONTD : 0);
	-> err = xskq_prod_reserve_desc(xs->rx, addr, len, flags);
	  -> if (xskq_prod_is_full(q))

Second part is redundant as in 1. we already peeked onto rx queue and
checked that there is enough space to produce given amount of
descriptors.

Provide helper functions that will skip it and therefore optimize code.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://lore.kernel.org/r/20260218150000.301176-1-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e37b2abca804 ("xsk: fix NULL pointer dereference in __xsk_rcv()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c       | 14 +++++++++++++-
 net/xdp/xsk_queue.h | 16 +++++++++++-----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c10619ef2d3b0..96b66430bdf7f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -153,6 +153,17 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff_xsk *xskb, u32 len,
 	return 0;
 }
 
+static void __xsk_rcv_zc_safe(struct xdp_sock *xs, struct xdp_buff_xsk *xskb,
+			      u32 len, u32 flags)
+{
+	u64 addr;
+
+	addr = xp_get_handle(xskb, xskb->pool);
+	__xskq_prod_reserve_desc(xs->rx, addr, len, flags);
+
+	xp_release(xskb);
+}
+
 static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
@@ -291,7 +302,8 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		rem -= copied;
 
 		xskb = container_of(xsk_xdp, struct xdp_buff_xsk, xdp);
-		__xsk_rcv_zc(xs, xskb, copied - meta_len, rem ? XDP_PKT_CONTD : 0);
+		__xsk_rcv_zc_safe(xs, xskb, copied - meta_len,
+				  rem ? XDP_PKT_CONTD : 0);
 		meta_len = 0;
 	} while (rem);
 
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 13354a1e42801..811d3c739a3a7 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -405,20 +405,26 @@ static inline void xskq_prod_write_addr_batch(struct xsk_queue *q, struct xdp_de
 	q->cached_prod = cached_prod;
 }
 
-static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
-					 u64 addr, u32 len, u32 flags)
+static inline void __xskq_prod_reserve_desc(struct xsk_queue *q,
+					    u64 addr, u32 len, u32 flags)
 {
 	struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 	u32 idx;
 
-	if (xskq_prod_is_full(q))
-		return -ENOBUFS;
-
 	/* A, matches D */
 	idx = q->cached_prod++ & q->ring_mask;
 	ring->desc[idx].addr = addr;
 	ring->desc[idx].len = len;
 	ring->desc[idx].options = flags;
+}
+
+static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
+					 u64 addr, u32 len, u32 flags)
+{
+	if (xskq_prod_is_full(q))
+		return -ENOBUFS;
+
+	__xskq_prod_reserve_desc(q, addr, len, flags);
 
 	return 0;
 }
-- 
2.53.0



