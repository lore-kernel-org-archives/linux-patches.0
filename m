Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C165114C585;
	Tue, 20 Feb 2024 20:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462739; cv=none; b=HvB62E4IpYM4RzmwqWn+0CRKrJGmur6J77hnCqgsiGwWm69e91IYUHVRDi3FvoxZTqiI6IA9k4u4WLXRHgJfoarN8y4x852PBq4tZnO/BWRMckaWm9ULcCY/q7pl2UuNs+cvWrhBZpOwzY3TJx6V1lf58SL8FXQyhtXL9I5ryRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462739; c=relaxed/simple;
	bh=4i+tChbwgG+hIITNBQwYewhR+sjKdyXsz8Wi+RmZRbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciYAq7vPSpXmLGDKAg7sKLZ3ZwZwXuBj1GMNoRdRYnmDmr6J6MuBp8apH6Hfv+mR1yCWEEBp6ALLyWDDRfALWAcpaexdMy4m4mD9fjqpYsR8RtULisxLclQm1tkklPcbWts4LCoELOTDvsc0Qr/68OUjfLM0S6sMRsBuE1alSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkuJi+Xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkuJi+Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEBBC43390;
	Tue, 20 Feb 2024 20:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462739;
	bh=4i+tChbwgG+hIITNBQwYewhR+sjKdyXsz8Wi+RmZRbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkuJi+XnM4sc0vY4z5uOxnKKn/gtQVNMIQTu3UWjgyF2xDQZlH0qVFJB+VdmXWKQN
	 tjY4oFcEoq1NsX2smInJdGXRvwyMvcAF/xBN5UuCVlq6xYGrHEdCzMjjmpd5TPCwax
	 jTxkw9gzlBT6zxnGo4bMTG2QSXx5g7l67UUTxp/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/197] tls: extract context alloc/initialization out of tls_set_sw_offload
Date: Tue, 20 Feb 2024 21:49:41 +0100
Message-ID: <20240220204841.745915203@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 615580cbc99af0da2d1c7226fab43a3d5003eb97 ]

Simplify tls_set_sw_offload a bit.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aec7961916f3 ("tls: fix race between async notify and socket close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 86 ++++++++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 35 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fbe6aab5f5b2..47ae429e50e3 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2587,6 +2587,48 @@ void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
 		tls_ctx->prot_info.version != TLS_1_3_VERSION;
 }
 
+static struct tls_sw_context_tx *init_ctx_tx(struct tls_context *ctx, struct sock *sk)
+{
+	struct tls_sw_context_tx *sw_ctx_tx;
+
+	if (!ctx->priv_ctx_tx) {
+		sw_ctx_tx = kzalloc(sizeof(*sw_ctx_tx), GFP_KERNEL);
+		if (!sw_ctx_tx)
+			return NULL;
+	} else {
+		sw_ctx_tx = ctx->priv_ctx_tx;
+	}
+
+	crypto_init_wait(&sw_ctx_tx->async_wait);
+	spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
+	INIT_LIST_HEAD(&sw_ctx_tx->tx_list);
+	INIT_DELAYED_WORK(&sw_ctx_tx->tx_work.work, tx_work_handler);
+	sw_ctx_tx->tx_work.sk = sk;
+
+	return sw_ctx_tx;
+}
+
+static struct tls_sw_context_rx *init_ctx_rx(struct tls_context *ctx)
+{
+	struct tls_sw_context_rx *sw_ctx_rx;
+
+	if (!ctx->priv_ctx_rx) {
+		sw_ctx_rx = kzalloc(sizeof(*sw_ctx_rx), GFP_KERNEL);
+		if (!sw_ctx_rx)
+			return NULL;
+	} else {
+		sw_ctx_rx = ctx->priv_ctx_rx;
+	}
+
+	crypto_init_wait(&sw_ctx_rx->async_wait);
+	spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
+	init_waitqueue_head(&sw_ctx_rx->wq);
+	skb_queue_head_init(&sw_ctx_rx->rx_list);
+	skb_queue_head_init(&sw_ctx_rx->async_hold);
+
+	return sw_ctx_rx;
+}
+
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -2608,48 +2650,22 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 	}
 
 	if (tx) {
-		if (!ctx->priv_ctx_tx) {
-			sw_ctx_tx = kzalloc(sizeof(*sw_ctx_tx), GFP_KERNEL);
-			if (!sw_ctx_tx) {
-				rc = -ENOMEM;
-				goto out;
-			}
-			ctx->priv_ctx_tx = sw_ctx_tx;
-		} else {
-			sw_ctx_tx =
-				(struct tls_sw_context_tx *)ctx->priv_ctx_tx;
-		}
-	} else {
-		if (!ctx->priv_ctx_rx) {
-			sw_ctx_rx = kzalloc(sizeof(*sw_ctx_rx), GFP_KERNEL);
-			if (!sw_ctx_rx) {
-				rc = -ENOMEM;
-				goto out;
-			}
-			ctx->priv_ctx_rx = sw_ctx_rx;
-		} else {
-			sw_ctx_rx =
-				(struct tls_sw_context_rx *)ctx->priv_ctx_rx;
-		}
-	}
+		ctx->priv_ctx_tx = init_ctx_tx(ctx, sk);
+		if (!ctx->priv_ctx_tx)
+			return -ENOMEM;
 
-	if (tx) {
-		crypto_init_wait(&sw_ctx_tx->async_wait);
-		spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
+		sw_ctx_tx = ctx->priv_ctx_tx;
 		crypto_info = &ctx->crypto_send.info;
 		cctx = &ctx->tx;
 		aead = &sw_ctx_tx->aead_send;
-		INIT_LIST_HEAD(&sw_ctx_tx->tx_list);
-		INIT_DELAYED_WORK(&sw_ctx_tx->tx_work.work, tx_work_handler);
-		sw_ctx_tx->tx_work.sk = sk;
 	} else {
-		crypto_init_wait(&sw_ctx_rx->async_wait);
-		spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
-		init_waitqueue_head(&sw_ctx_rx->wq);
+		ctx->priv_ctx_rx = init_ctx_rx(ctx);
+		if (!ctx->priv_ctx_rx)
+			return -ENOMEM;
+
+		sw_ctx_rx = ctx->priv_ctx_rx;
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
-		skb_queue_head_init(&sw_ctx_rx->rx_list);
-		skb_queue_head_init(&sw_ctx_rx->async_hold);
 		aead = &sw_ctx_rx->aead_recv;
 	}
 
-- 
2.43.0



