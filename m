Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19D0334373;
	Thu, 27 Nov 2025 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255992; cv=none; b=eQIZLsT1EAajtxccn9ZCYENUNrgEKo2ybcjgUU22Bax4SOkc6KA4vkklqOLGJBiTgOMZSaGIGjLEg9An4fI4JiHEHLaUSroxe/cg3Z7Z5W6qJb8HIsHRd0cZH0AInzbqIh2eCUMU1SjBCZql4g9HpATg/+ccHwWUIrSktObnLsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255992; c=relaxed/simple;
	bh=F6P7YLQbny+/42W18yvh9mCYTLPqIWfOD7/9P1mIY/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcYdsJ6PsueyY+M1N99dVxQQovoP6GJ1QPC+zM2WxdQiiGroOX2brCzWETsnj0ZtdCmhm3lngNSCYZKpoWmmweC9j5jSvT3MjlO8Rf8gqTm83QW6hajDdZatkSN4SIiio+39NXaNdhPGHIlnZJDPnq9/X3CYUKvSlv2+SDY1/68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifloQxus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifloQxus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34285C19421;
	Thu, 27 Nov 2025 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255992;
	bh=F6P7YLQbny+/42W18yvh9mCYTLPqIWfOD7/9P1mIY/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifloQxusunOTFmVj+HUumaDgoanRu6QKWWnET+9WEX+MS4PkqgZFsPsAwwW5KBZlV
	 PRNsjUUlxJ10O7+pCgSBv6bqNFDKZ2k9V8GG8hQJmgtfbtMA615rsPg87brFqi6orC
	 VB68bjY8cFrYxgU1Zmgzn/SsjrFzJJuKEt1nU0H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/112] net: tls: Change async resync helpers argument
Date: Thu, 27 Nov 2025 15:46:30 +0100
Message-ID: <20251127144036.063143869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 34892cfec0c2d96787c4be7bda0d5f18d7dacf85 ]

Update tls_offload_rx_resync_async_request_start() and
tls_offload_rx_resync_async_request_end() to get a struct
tls_offload_resync_async parameter directly, rather than
extracting it from struct sock.

This change aligns the function signatures with the upcoming
tls_offload_rx_resync_async_request_cancel() helper, which
will be introduced in a subsequent patch.

Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1761508983-937977-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  9 ++++++--
 include/net/tls.h                             | 21 +++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 65ccb33edafb7..c0089c704c0cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -425,12 +425,14 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 {
 	struct mlx5e_ktls_rx_resync_buf *buf = wi->tls_get_params.buf;
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct tls_offload_context_rx *rx_ctx;
 	u8 tracker_state, auth_state, *ctx;
 	struct device *dev;
 	u32 hw_seq;
 
 	priv_rx = buf->priv_rx;
 	dev = mlx5_core_dma_dev(sq->channel->mdev);
+	rx_ctx = tls_offload_ctx_rx(tls_get_ctx(priv_rx->sk));
 	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
 		goto out;
 
@@ -447,7 +449,8 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 	}
 
 	hw_seq = MLX5_GET(tls_progress_params, ctx, hw_resync_tcp_sn);
-	tls_offload_rx_resync_async_request_end(priv_rx->sk, cpu_to_be32(hw_seq));
+	tls_offload_rx_resync_async_request_end(rx_ctx->resync_async,
+						cpu_to_be32(hw_seq));
 	priv_rx->rq_stats->tls_resync_req_end++;
 out:
 	mlx5e_ktls_priv_rx_put(priv_rx);
@@ -482,6 +485,7 @@ static bool resync_queue_get_psv(struct sock *sk)
 static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 {
 	struct ethhdr *eth = (struct ethhdr *)(skb->data);
+	struct tls_offload_resync_async *resync_async;
 	struct net_device *netdev = rq->netdev;
 	struct net *net = dev_net(netdev);
 	struct sock *sk = NULL;
@@ -528,7 +532,8 @@ static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 
 	seq = th->seq;
 	datalen = skb->len - depth;
-	tls_offload_rx_resync_async_request_start(sk, seq, datalen);
+	resync_async = tls_offload_ctx_rx(tls_get_ctx(sk))->resync_async;
+	tls_offload_rx_resync_async_request_start(resync_async, seq, datalen);
 	rq->stats->tls_resync_req_start++;
 
 unref:
diff --git a/include/net/tls.h b/include/net/tls.h
index 61fef28801140..181173e62a068 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -448,25 +448,20 @@ static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
 
 /* Log all TLS record header TCP sequences in [seq, seq+len] */
 static inline void
-tls_offload_rx_resync_async_request_start(struct sock *sk, __be32 seq, u16 len)
+tls_offload_rx_resync_async_request_start(struct tls_offload_resync_async *resync_async,
+					  __be32 seq, u16 len)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
-
-	atomic64_set(&rx_ctx->resync_async->req, ((u64)ntohl(seq) << 32) |
+	atomic64_set(&resync_async->req, ((u64)ntohl(seq) << 32) |
 		     ((u64)len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
-	rx_ctx->resync_async->loglen = 0;
-	rx_ctx->resync_async->rcd_delta = 0;
+	resync_async->loglen = 0;
+	resync_async->rcd_delta = 0;
 }
 
 static inline void
-tls_offload_rx_resync_async_request_end(struct sock *sk, __be32 seq)
+tls_offload_rx_resync_async_request_end(struct tls_offload_resync_async *resync_async,
+					__be32 seq)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
-
-	atomic64_set(&rx_ctx->resync_async->req,
-		     ((u64)ntohl(seq) << 32) | RESYNC_REQ);
+	atomic64_set(&resync_async->req, ((u64)ntohl(seq) << 32) | RESYNC_REQ);
 }
 
 static inline void
-- 
2.51.0



