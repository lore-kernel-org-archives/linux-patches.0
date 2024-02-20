Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D29152DF3;
	Tue, 20 Feb 2024 21:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463422; cv=none; b=j+LVqHA1mf8OQlH6TgLIZ0Om2C4L2BqEbFki40G6+1DcIHkz34mCnNKhjsk1zcnjT+318VFdJSqq2ZjsiUIfPPuZIl69VewF1Bz4ha8AmKTyFpT1bbMTupodxTXVqZA0v7gEoaLYFZbaPiYgjOcp+Y2A1eOciCdF53gRm7gJvVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463422; c=relaxed/simple;
	bh=2Kja8Ln0AzThNsDG/YRbs9dWEYcnPXC8buDHRMwax/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHqKVaO3O5DHo/mFJPmTa8vG5hm43ySzsXQudcA2ZITIzdZRHEO1V1LhN/xrfHpOOzaAilmqcaaKnnib5eNT0j1IChut3SeiJZTsdBmeZ+Flor+QwB/x7bxe2ygiJq5cAmud6g0gRyb7/v9+peQjkjI+TAwG89XS0mwbkNo/ErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WwWLAfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WwWLAfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A3AC433F1;
	Tue, 20 Feb 2024 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463421;
	bh=2Kja8Ln0AzThNsDG/YRbs9dWEYcnPXC8buDHRMwax/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WwWLAfJeGmwv7hOBEra4uWlWcycjzSnXxLpTlGk6g0AiH641m3F8TL+cx5CtqhoJ
	 kU39MigQWOLTf/IrSnfab5RE9YcldyK1IQvUU1305uJGPn9Ilw1U85BPxA0M6CjJ4/
	 EfHp/ciGiTjCyKj7Bz/jYVYMJ9RwYrwLdanDO6Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/331] tls: extract context alloc/initialization out of tls_set_sw_offload
Date: Tue, 20 Feb 2024 21:52:35 +0100
Message-ID: <20240220205638.834672115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dba523cdc73d..3c176776e912 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2597,6 +2597,48 @@ void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
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
@@ -2618,48 +2660,22 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
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



