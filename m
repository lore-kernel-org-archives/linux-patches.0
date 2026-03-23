Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6242387599;
	Mon, 23 Mar 2026 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277897; cv=none; b=Kne5EwcYjz3++5MbZWinS+QOe446qohJVoLmXPG4R4H9xpnTkQDrGergKWo6Bly9LxOzXFtjqcajbxCvYCNZwMkCEBvfP/5tittwXU8j4nZPnSOsa+pSSCDukDdod/QsSX2/8sE2Sz4fr0iA2XmLHb6nCZF4QH/H5VwvalLCfBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277897; c=relaxed/simple;
	bh=nnZXe9+1ZUqTPaNh94ybDLADSdn1w7yT84oeht62oQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOiR0CL89DLZZk7CbSAQyFJq1xGzAW7v8au8SVSJoXAZjhmgA+o+7/g8ASeF984k7xfolDJtdMVUOfaYWYT0SthosIhoaZ+FaoBFPXyy21WwYt697k7DmvYya6InfwaxcYibAdRmXodOseNqtaRWSvz90jllTB3EQXhS0y/iu8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fzecc3F7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fzecc3F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39518C2BC9E;
	Mon, 23 Mar 2026 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277897;
	bh=nnZXe9+1ZUqTPaNh94ybDLADSdn1w7yT84oeht62oQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fzecc3F7cyE7eQJwtC4jVvnF2IvOPtnvflQ0HwiMQYG3c2oFnIV1aay233+BeTx6f
	 xA8Tmg/tW5oMMuRWNiWEUFdeo57/9oyHvtPQJTBjykaaYpySnumhbnpu4EZs4D10w5
	 aS/zoxG9VFQo+6tPogl2TG0njwyViJSmf/Ph/8DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/567] xsk: Get rid of xdp_buff_xsk::xskb_list_node
Date: Mon, 23 Mar 2026 14:40:55 +0100
Message-ID: <20260323134537.146825678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

[ Upstream commit b692bf9a7543af7ad11a59d182a3757578f0ba53 ]

Let's bring xdp_buff_xsk back to occupying 2 cachelines by removing
xskb_list_node - for the purpose of gathering the xskb frags
free_list_node can be used, head of the list (xsk_buff_pool::xskb_list)
stays as-is, just reuse the node ptr.

It is safe to do as a single xdp_buff_xsk can never reside in two
pool's lists simultaneously.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20241007122458.282590-2-maciej.fijalkowski@intel.com
Stable-dep-of: f7387d6579d6 ("xsk: Fix zero-copy AF_XDP fragment drop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h  | 14 +++++++-------
 include/net/xsk_buff_pool.h |  1 -
 net/xdp/xsk.c               |  4 ++--
 net/xdp/xsk_buff_pool.c     |  1 -
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 5425f7ad5ebde..39b43eb2b799d 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -114,8 +114,8 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 	if (likely(!xdp_buff_has_frags(xdp)))
 		goto out;
 
-	list_for_each_entry_safe(pos, tmp, xskb_list, xskb_list_node) {
-		list_del(&pos->xskb_list_node);
+	list_for_each_entry_safe(pos, tmp, xskb_list, free_list_node) {
+		list_del(&pos->free_list_node);
 		xp_free(pos);
 	}
 
@@ -128,7 +128,7 @@ static inline void xsk_buff_add_frag(struct xdp_buff *xdp)
 {
 	struct xdp_buff_xsk *frag = container_of(xdp, struct xdp_buff_xsk, xdp);
 
-	list_add_tail(&frag->xskb_list_node, &frag->pool->xskb_list);
+	list_add_tail(&frag->free_list_node, &frag->pool->xskb_list);
 }
 
 static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
@@ -138,9 +138,9 @@ static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
 	struct xdp_buff_xsk *frag;
 
 	frag = list_first_entry_or_null(&xskb->pool->xskb_list,
-					struct xdp_buff_xsk, xskb_list_node);
+					struct xdp_buff_xsk, free_list_node);
 	if (frag) {
-		list_del(&frag->xskb_list_node);
+		list_del(&frag->free_list_node);
 		ret = &frag->xdp;
 	}
 
@@ -151,7 +151,7 @@ static inline void xsk_buff_del_tail(struct xdp_buff *tail)
 {
 	struct xdp_buff_xsk *xskb = container_of(tail, struct xdp_buff_xsk, xdp);
 
-	list_del(&xskb->xskb_list_node);
+	list_del(&xskb->free_list_node);
 }
 
 static inline struct xdp_buff *xsk_buff_get_tail(struct xdp_buff *first)
@@ -160,7 +160,7 @@ static inline struct xdp_buff *xsk_buff_get_tail(struct xdp_buff *first)
 	struct xdp_buff_xsk *frag;
 
 	frag = list_last_entry(&xskb->pool->xskb_list, struct xdp_buff_xsk,
-			       xskb_list_node);
+			       free_list_node);
 	return &frag->xdp;
 }
 
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index f0d6ce4bda7a2..d6cba1d4076ea 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -29,7 +29,6 @@ struct xdp_buff_xsk {
 	struct xsk_buff_pool *pool;
 	u64 orig_addr;
 	struct list_head free_list_node;
-	struct list_head xskb_list_node;
 };
 
 #define XSK_CHECK_PRIV_TYPE(t) BUILD_BUG_ON(sizeof(t) > offsetofend(struct xdp_buff_xsk, cb))
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 569d39f19c569..bb8f52c345868 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -172,14 +172,14 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		return 0;
 
 	xskb_list = &xskb->pool->xskb_list;
-	list_for_each_entry_safe(pos, tmp, xskb_list, xskb_list_node) {
+	list_for_each_entry_safe(pos, tmp, xskb_list, free_list_node) {
 		if (list_is_singular(xskb_list))
 			contd = 0;
 		len = pos->xdp.data_end - pos->xdp.data;
 		err = __xsk_rcv_zc(xs, pos, len, contd);
 		if (err)
 			goto err;
-		list_del(&pos->xskb_list_node);
+		list_del(&pos->free_list_node);
 	}
 
 	return 0;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 380b0b3f3d8d0..8bc7cdf4719c8 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -101,7 +101,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		xskb->pool = pool;
 		xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
 		INIT_LIST_HEAD(&xskb->free_list_node);
-		INIT_LIST_HEAD(&xskb->xskb_list_node);
 		if (pool->unaligned)
 			pool->free_heads[i] = xskb;
 		else
-- 
2.51.0



