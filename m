Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7068B2236E3;
	Mon, 20 Apr 2026 16:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700862; cv=none; b=VM082Rrh2FbC/qI1m/rmxOsKNCASIQhIcamD3vR9/fkq8LFfw106p5FRBd7Xm9aMaz8opeRtBGvWvkO3I7wrpawJDW2mgfoxlpbVghTI3Po2bCVdXLVYDWyqPV/qfSGsuq15ciVYx9jVMbQhj/wAUt2dNz0seta6aC1oxk9B0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700862; c=relaxed/simple;
	bh=q8srtYSFzmuaLQiyQ9JGTGX2l9E64TyPfXBfYnCYgYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9mW/1qo00fgEb7svMCizCrObmk9MuzisJ2E878z24qg2LtqW8pWA+4oIwsL/sHO5klpZH2wK6nDT+d/DgawKsL9sa8D1EJ77gcWi5mZC5zgEXg4d+DS5xmg/tz5tQF2WBnPbWxjSfXDhRSU1AdmRMVfaiaQnJBt/68YcgYMKGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWdI0/bs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWdI0/bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25BCC19425;
	Mon, 20 Apr 2026 16:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700862;
	bh=q8srtYSFzmuaLQiyQ9JGTGX2l9E64TyPfXBfYnCYgYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWdI0/bsI4xaIc9ZbNWUaf2c1YmJum2e+AvQAjdiqmeNKQXjM8p4dZkDoFXaO+Uy4
	 /j7WuMjtsFZkZZZf6PGzmdBdtm+ksKiIpr92mGiRWPZmm0IyKkB26cjXDqzJBgC03/
	 7wvS5HNHNP5c/FSa5C1hmGJnKIjPpVcDKJ6EI6ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/198] xsk: respect tailroom for ZC setups
Date: Mon, 20 Apr 2026 17:41:08 +0200
Message-ID: <20260420153938.812060155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 1ee1605138fc94cc8f8f273321dd2471c64977f9 ]

Multi-buffer XDP stores information about frags in skb_shared_info that
sits at the tailroom of a packet. The storage space is reserved via
xdp_data_hard_end():

	((xdp)->data_hard_start + (xdp)->frame_sz -	\
	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

and then we refer to it via macro below:

static inline struct skb_shared_info *
xdp_get_shared_info_from_buff(const struct xdp_buff *xdp)
{
        return (struct skb_shared_info *)xdp_data_hard_end(xdp);
}

Currently we do not respect this tailroom space in multi-buffer AF_XDP
ZC scenario. To address this, introduce xsk_pool_get_tailroom() and use
it within xsk_pool_get_rx_frame_size() which is used in ZC drivers to
configure length of HW Rx buffer.

Typically drivers on Rx Hw buffers side work on 128 byte alignment so
let us align the value returned by xsk_pool_get_rx_frame_size() in order
to avoid addressing this on driver's side. This addresses the fact that
idpf uses mentioned function *before* pool->dev being set so we were at
risk that after subtracting tailroom we would not provide 128-byte
aligned value to HW.

Since xsk_pool_get_rx_frame_size() is actively used in xsk_rcv_check()
and __xsk_rcv(), add a variant of this routine that will not include 128
byte alignment and therefore old behavior is preserved.

Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20260402154958.562179-3-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 23 ++++++++++++++++++++++-
 net/xdp/xsk.c              |  4 ++--
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 33e072768de9d..dd1d3a6e1b780 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -37,16 +37,37 @@ static inline u32 xsk_pool_get_headroom(struct xsk_buff_pool *pool)
 	return XDP_PACKET_HEADROOM + pool->headroom;
 }
 
+static inline u32 xsk_pool_get_tailroom(bool mbuf)
+{
+	return mbuf ? SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) : 0;
+}
+
 static inline u32 xsk_pool_get_chunk_size(struct xsk_buff_pool *pool)
 {
 	return pool->chunk_size;
 }
 
-static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
+static inline u32 __xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
 {
 	return xsk_pool_get_chunk_size(pool) - xsk_pool_get_headroom(pool);
 }
 
+static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
+{
+	u32 frame_size =  __xsk_pool_get_rx_frame_size(pool);
+	struct xdp_umem *umem = pool->umem;
+	bool mbuf;
+
+	/* Reserve tailroom only for zero-copy pools that opted into
+	 * multi-buffer. The reserved area is used for skb_shared_info,
+	 * matching the XDP core's xdp_data_hard_end() layout.
+	 */
+	mbuf = pool->dev && (umem->flags & XDP_UMEM_SG_FLAG);
+	frame_size -= xsk_pool_get_tailroom(mbuf);
+
+	return ALIGN_DOWN(frame_size, 128);
+}
+
 static inline u32 xsk_pool_get_rx_frag_step(struct xsk_buff_pool *pool)
 {
 	return pool->unaligned ? 0 : xsk_pool_get_chunk_size(pool);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a78cdc3356937..259ad9a3abcc4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -239,7 +239,7 @@ static u32 xsk_copy_xdp(void *to, void **from, u32 to_len,
 
 static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
-	u32 frame_size = xsk_pool_get_rx_frame_size(xs->pool);
+	u32 frame_size = __xsk_pool_get_rx_frame_size(xs->pool);
 	void *copy_from = xsk_copy_xdp_start(xdp), *copy_to;
 	u32 from_len, meta_len, rem, num_desc;
 	struct xdp_buff_xsk *xskb;
@@ -338,7 +338,7 @@ static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
-	if (len > xsk_pool_get_rx_frame_size(xs->pool) && !xs->sg) {
+	if (len > __xsk_pool_get_rx_frame_size(xs->pool) && !xs->sg) {
 		xs->rx_dropped++;
 		return -ENOSPC;
 	}
-- 
2.53.0



