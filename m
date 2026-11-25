Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619036;
	b=1Abl37Op0xSL4YPCbNcmX8XFN52yhLPyMg5oVNz4rZECbMDMW19TgUMrHkf5LODUD2be
	 5ov76BZux7QCPUikqce081XXZzdfRm8Z39fIMZQnogIuRv2OgpdrNNAwMUVJgViqJljO+
	 /7u1YrmzR2pLkxPmUWvGMhq1aYsQCNUgH+6SdvbG5ou/8lnnkSB5wQoUM41ILlRVyBYOV
	 Sjd1dDgn6Zugw0N0tLDHCJ21sToumnAS8PgzTmeZpOccAsTJZ8NxvqUUSsdDqb2fZZEBr
	 gZi4p1y058ju0EuOmYkPkCWt8e60wAg2zsyPNw16AZ3MBnMCVesHbgypr55JMQrZiyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hvQXIw5y/htP6VUtWuqMDP5z3ozddR8dyiKeLzMKQME=;
	b=04blfZqT/+H3yTzC/oak29wZE7L2bh2t1IUYVLNEkcvl+3C0O3ApjAmF/Q4HIwh3BqXW
	 Npmw5s4IhWrrOK0pwfTez1K5sKBNvFhMJXHLuIiq23IDaY4vNXlvTkt1SOTCrPD35JMPF
	 bR9L+R36PRCxhQxczmSkKDBIU1LtyMo7ZU2+EzWMDDwPwIUagzjFIrFXJ0j267zWiIi1T
	 2aT+eOu3qRkVXFS0RaXC8dImgrRx7x7/DymlS1qOy/aOkxfY/b2Ua46u5j9UppDf3SCCf
	 mHx0yTizHoTSV/cyXxquk2eOlOj02icaAPALSmYVJYZZvI0T/SXdQxzH3edgDVeKLWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSkjeSCs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD07606A321;
	Wed, 25 Nov 2026 15:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSkjeSCs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6869F1F000CA;
	Wed, 25 Nov 2026 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619035;
	bh=hvQXIw5y/htP6VUtWuqMDP5z3ozddR8dyiKeLzMKQME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSkjeSCsHp6sRHxRKNS1uqK2lFkht8hR7sWDYRFr54bNau2TwwjUSvRxKtzErw73V
	 p4boVwrwRX7kLMD5QKxCZG6V5cQ/UgkYjiOkJTqujOyXd9mvWfe7C91MnuJGxpxIOE
	 lux85J5XrUKyX/D03/6idE2DIAYjTpok+AZZLav8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0469/1005] net: mana: fix XDP_REDIRECT of pre-allocated RX buffers
Date: Wed, 25 Nov 2026 15:30:07 +0100
Message-ID: <20261125143832.732244223@linuxfoundation.org>
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

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit 67869597fab06abaa5b977cb7004532269fc960b ]

mana_pre_alloc_rxbufs() fills the RX rings with plain pages from
dev_alloc_pages() (from_pool == false), but the rxq is registered with
MEM_TYPE_PAGE_POOL and mana_run_xdp() builds every xdp_buff with that
rxq info. mana_rx_skb() frees a !from_pool buffer correctly on
XDP_PASS, XDP_TX and XDP_DROP, but a redirected buffer is freed through
its memory model: __xdp_return() hands the plain page to
page_pool_put_full_netmem(). This triggers the WARN in
include/net/page_pool/helpers.h, breaks the page refcount, RX refills
fail and the queue stops receiving.

The pre-allocated buffers fill the whole ring of every rxq created by
an MTU change, by ethtool -L / -G and, since
commit 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers
instead of full pages to improve memory efficiency."), by every XDP
attach and detach. So on current kernels the first ring of redirected
packets after attaching an XDP program always hits this.

Reproduced on 7.2.11, and on 6.12.113 after ethtool -L, on an Azure
MANA VF: an XDP program that redirects UDP to an XSKMAP with an AF_XDP
socket in copy mode gives WARNINGs at __xdp_return+0x249 (stack
__xsk_map_redirect, xdp_do_redirect, mana_run_xdp, mana_poll), then
the queue stops.

Give each rxq a second xdp_rxq_info registered with
MEM_TYPE_PAGE_SHARED, the model these buffers had before the page pool
was added, and use it for buffers that are not from the pool. Those
buffers are already DMA-unmapped by mana_refill_rx_oob() before XDP
runs, and page_frag_free() frees them whatever their order. Allocating
the pre-allocated buffers from the page pool instead would need the
pools to exist before the rxqs and to outlive them, a much larger
change.

Found, fixed and tested with an AI coding assistant (Claude Code).

Fixes: b1d13f7a3b53 ("net: mana: Add page pool for RX buffers")
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Link: https://patch.msgid.link/20261102064324.806414-1-orgads@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_bpf.c |  9 +++++++--
 drivers/net/ethernet/microsoft/mana/mana_en.c  | 11 ++++++++++-
 include/net/mana/mana.h                        |  5 ++++-
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index b27fd9b8c4f6d..3b6f756119445 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -78,7 +78,8 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 }
 
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
-		 struct xdp_buff *xdp, void *buf_va, uint pkt_len)
+		 struct xdp_buff *xdp, void *buf_va, bool from_pool,
+		 uint pkt_len)
 {
 	struct mana_stats_rx *rx_stats;
 	struct bpf_prog *prog;
@@ -90,7 +91,11 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 	if (!prog)
 		goto out;
 
-	xdp_init_buff(xdp, PAGE_SIZE, &rxq->xdp_rxq);
+	/* A redirected buffer is freed by its memory model, so a buffer not
+	 * from the page pool must not claim MEM_TYPE_PAGE_POOL.
+	 */
+	xdp_init_buff(xdp, PAGE_SIZE,
+		      from_pool ? &rxq->xdp_rxq : &rxq->xdp_rxq_shared);
 	xdp_prepare_buff(xdp, buf_va, rxq->headroom, pkt_len, true);
 
 	act = bpf_prog_run_xdp(prog, xdp);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 89af8bf6758b7..428e53d91f8db 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2126,7 +2126,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 		return;
 	}
 
-	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
+	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, from_pool, pkt_len);
 
 	if (act == XDP_REDIRECT && !rxq->xdp_rc)
 		return;
@@ -2919,6 +2919,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
+	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq_shared))
+		xdp_rxq_info_unreg(&rxq->xdp_rxq_shared);
+
 	if (rxq->rxobj != INVALID_MANA_HANDLE)
 		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
@@ -3203,6 +3206,12 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
 					   rxq->page_pool));
 
+	/* The pre-allocated buffers (mana_pre_alloc_rxbufs) are plain pages */
+	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq_shared, ndev, rxq_idx,
+				 cq->napi.napi_id));
+	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq_shared,
+					   MEM_TYPE_PAGE_SHARED, NULL));
+
 	/* Initialize the DIM work before enabling NAPI, so that a poll
 	 * cannot reach net_dim() with an uninitialized cq->dim.work.
 	 */
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index e46ba02529c29..6a761672bd5bb 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -421,6 +421,8 @@ struct mana_rxq {
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
+	/* For buffers not from the page pool (from_pool == false) */
+	struct xdp_rxq_info xdp_rxq_shared;
 	void *xdp_save_va; /* for reusing */
 	bool xdp_flush;
 	int xdp_rc; /* XDP redirect return code */
@@ -694,7 +696,8 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev);
 int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 		  u32 flags);
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
-		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
+		 struct xdp_buff *xdp, void *buf_va, bool from_pool,
+		 uint pkt_len);
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
 void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog);
 int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
-- 
2.53.0



