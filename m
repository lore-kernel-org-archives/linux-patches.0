Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A6E3E49C4;
	Tue, 21 Jul 2026 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660418; cv=none; b=Str4gWeSv0Jj9mz7cTVCGYnznDWy4YAGQZdO+noz7h2FI4LerlrzpMABB3IHnTPLobEA/OWfSsgiiTgpQ/sTnpO1VPNSeDH89oVFsbCTipTkQJ0QCye64xGhd/6VE3FHPyZBtjka4b0Vkny3BJKrs/t1FQknNu924rEtiJux/U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660418; c=relaxed/simple;
	bh=SpbC6Ymxfn5AtbK2lKqOK1SKCxwPm0tJKyNxOPvG0oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxSqDPyO5YVUOavQH7x6tcrZGm73cxWGV1/jq0t/dIh1Y1TthL15Vq6JUjt/zx3K2tqoDHMWiR0Ts17n8TmvwxHXqBPooaq1ncdccyp60esOzt+ewDTnhDZ9aJyr39uMzJciDcxI/fdPd/Epb5mHvkHgFE5nAqBtJsEEjKUvbyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m488rfcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m488rfcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE151F000E9;
	Tue, 21 Jul 2026 19:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660417;
	bh=Cp62viXpvjpBtjI1tlNJp7IffVQXTeDSuKAUSpxLClo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m488rfcqHrap9mnXCwhjySEc8SzkunExwEat1Nvs4DCo9TFVx2eQAImnamUquU0U8
	 RPvcxfH6Ql2wkcbYUw3WswRAU0NPn0Kj7zdhcLy7hkPYh1Hn0zBuGDtcM3YRfgkxUo
	 LMdKpgiI/RcAvj+x4eczpPgNTlx2VVtYbgo4Ltt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0965/2077] xprtrdma: Use sendctx DMA state for Send signaling
Date: Tue, 21 Jul 2026 17:10:38 +0200
Message-ID: <20260721152615.585346801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2797ae7c929610fb2d2303a996a08173fa096730 ]

Send signaling matters only when the prepared Send has page
mappings to unmap. Today that test is expressed indirectly with
rl_kref, because the Send-side reference is taken only for Sends
with mapped SGEs.

Split the SGE DMA unmap loop into its own helper and use
sc_unmap_count directly for the signaling decision. This keeps the
current behavior but removes one dependency on the old rl_kref
semantics before the request lifetime rules are changed.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Stable-dep-of: e786233d2e0b ("xprtrdma: Decouple req recycling from RPC completion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |  2 +-
 net/sunrpc/xprtrdma/rpc_rdma.c | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 7f79a0a2601e65..e5c71cf705a33a 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -474,7 +474,7 @@ int frwr_send(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 		++num_wrs;
 	}
 
-	if ((kref_read(&req->rl_kref) > 1) || num_wrs > ep->re_send_count) {
+	if (req->rl_sendctx->sc_unmap_count || num_wrs > ep->re_send_count) {
 		send_wr->send_flags |= IB_SEND_SIGNALED;
 		ep->re_send_count = min_t(unsigned int, ep->re_send_batch,
 					  num_wrs - ep->re_send_count);
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 0e0f219747109f..16b9987858d683 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -477,19 +477,11 @@ static void rpcrdma_sendctx_done(struct kref *kref)
 	rep->rr_rxprt->rx_stats.reply_waits_for_send++;
 }
 
-/**
- * rpcrdma_sendctx_unmap - DMA-unmap Send buffer
- * @sc: sendctx containing SGEs to unmap
- *
- */
-void rpcrdma_sendctx_unmap(struct rpcrdma_sendctx *sc)
+static void rpcrdma_sendctx_dma_unmap(struct rpcrdma_sendctx *sc)
 {
 	struct rpcrdma_regbuf *rb = sc->sc_req->rl_sendbuf;
 	struct ib_sge *sge;
 
-	if (!sc->sc_unmap_count)
-		return;
-
 	/* The first two SGEs contain the transport header and
 	 * the inline buffer. These are always left mapped so
 	 * they can be cheaply re-used.
@@ -498,7 +490,19 @@ void rpcrdma_sendctx_unmap(struct rpcrdma_sendctx *sc)
 	     ++sge, --sc->sc_unmap_count)
 		ib_dma_unmap_page(rdmab_device(rb), sge->addr, sge->length,
 				  DMA_TO_DEVICE);
+}
+
+/**
+ * rpcrdma_sendctx_unmap - DMA-unmap Send buffer
+ * @sc: sendctx containing SGEs to unmap
+ *
+ */
+void rpcrdma_sendctx_unmap(struct rpcrdma_sendctx *sc)
+{
+	if (!sc->sc_unmap_count)
+		return;
 
+	rpcrdma_sendctx_dma_unmap(sc);
 	kref_put(&sc->sc_req->rl_kref, rpcrdma_sendctx_done);
 }
 
-- 
2.53.0



