Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2D933C187;
	Mon, 20 Apr 2026 16:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701304; cv=none; b=I6G1XMgKqD0m2ZacVo7UExMMomctUQzNbf0Fj18CF1yg/ljw62c5H0pjFpse2HcVqLFaXw2UodlEn0VzcRW/eVifPWDEdLpyADFDS1p526/ObzD470ZuoyyYrUo2blmbufs/NiBVTr6i8EoXsRvSxn/PPu0mhy1z3GfmWBGIT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701304; c=relaxed/simple;
	bh=JvZBj2LR503o2i1fADjKEGyLCw06+1oTpw7v436wd4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X40Cw3cAi7SL5hEiylwBS9TPLJ+VfNemsdsSd+o0jURTNYBi/zi7gIUzclHKRPPu3N63vJYiJjGso6G+ZRTCLnOwCfDfUmXdGpF37CiTHqDsGodn+yaCIELkmNJTNwffP2YCIVhKBmsJIv/yigdXGs6Khvqv7vrfKoem+qOHc1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1iuhzqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1iuhzqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C2EC2BCC6;
	Mon, 20 Apr 2026 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701304;
	bh=JvZBj2LR503o2i1fADjKEGyLCw06+1oTpw7v436wd4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1iuhzqj0jgoIbwpoZIQcRvT9Tl2Zr59tykOkOnydva3aWJOg+d3PnX1myKZb9Dl6
	 pnDp2PUlc0MpT9D0mVijOgGmyHsCEEdJnkeAIxKxTmDGnUeJ7uQ9sVXSH+daFxAcSC
	 ba3u/UANNOexcm2krGhYblp7Dg+mniDE9PGEGYNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/162] xsk: respect tailroom for ZC setups
Date: Mon, 20 Apr 2026 17:41:34 +0200
Message-ID: <20260420153929.283881613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 997e28dd38963..075bc09046463 100644
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
index ed1aeaded9be7..da7e11e3bfad2 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -231,7 +231,7 @@ static u32 xsk_copy_xdp(void *to, void **from, u32 to_len,
 
 static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
-	u32 frame_size = xsk_pool_get_rx_frame_size(xs->pool);
+	u32 frame_size = __xsk_pool_get_rx_frame_size(xs->pool);
 	void *copy_from = xsk_copy_xdp_start(xdp), *copy_to;
 	u32 from_len, meta_len, rem, num_desc;
 	struct xdp_buff_xsk *xskb;
@@ -323,7 +323,7 @@ static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
-	if (len > xsk_pool_get_rx_frame_size(xs->pool) && !xs->sg) {
+	if (len > __xsk_pool_get_rx_frame_size(xs->pool) && !xs->sg) {
 		xs->rx_dropped++;
 		return -ENOSPC;
 	}
-- 
2.53.0



