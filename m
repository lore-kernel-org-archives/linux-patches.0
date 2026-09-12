Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907324BEE50;
	Sat, 12 Sep 2026 13:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218933; cv=none; b=uAFWus1dTEiUxtOsQkOKsDamS3XcFF7agQWFnUYgbz9s8Hp/6i4pqTFkHZnsYNglNcLiits8KeqtbngqUpc8Wcd2oBLvDFuFdWfdjpDrh2sesn1xcL2uz7dcHRtA1rfSN2R+TMdPB0C5qmSgHCtKbZceZi0xRvpeKd8+/kN+ALQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218933; c=relaxed/simple;
	bh=ipI2DmE/FUmoL4b2DMg554lJdHYtGXlwSGfVjdhQc5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkvPibMaP7r1hzSNL3TJr3QrErCj7LYGiQUvbMTzjFJsrWn9dPRCrl+CyKvYuivR/VmaIG7+zEEL2RnFXC0fbNosSRc8gjR8NpddnecqNQspAGMEWXKclYw1yClcyFpni8KOzozqUdpKNoxhn/gBZUbNhzI5v/7Q+eWXk1y2YU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZtj+xua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZtj+xua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBEB1F000FF;
	Sat, 12 Sep 2026 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218932;
	bh=P0ruEZjH6tKOvIUCEXqSSQkVJapbCkDq6S28BxE5qvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZtj+xuaubgYldnyOzbkw2Hs+UNxL741kLc05C4VcIqsLmS/sBoE6clVm+ZMvlDMh
	 OaGRklyo94SWVI7xyckvE/ecOIejAfH/ga3q4LUNGP1gz55GAAsC5GSa5EmrLindQc
	 KZzdlSMsKYhgwwV49YwDRqR06Dg7AtA17vPcrKBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1245/1376] xsk: avoid double checking against rx queue being full
Date: Sat, 12 Sep 2026 09:01:11 +0200
Message-ID: <20260912065635.293304228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index c070b6db26d82..6cc270ce455ce 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -152,6 +152,17 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff_xsk *xskb, u32 len,
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
@@ -290,7 +301,8 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		rem -= copied;
 
 		xskb = container_of(xsk_xdp, struct xdp_buff_xsk, xdp);
-		__xsk_rcv_zc(xs, xskb, copied - meta_len, rem ? XDP_PKT_CONTD : 0);
+		__xsk_rcv_zc_safe(xs, xskb, copied - meta_len,
+				  rem ? XDP_PKT_CONTD : 0);
 		meta_len = 0;
 	} while (rem);
 
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 9351e1298ef40..2ec64c185f8f7 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -428,20 +428,26 @@ static inline void xskq_prod_write_addr_batch(struct xsk_queue *q, struct xdp_de
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



