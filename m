Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0551E504;
	Thu, 23 May 2024 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470328; cv=none; b=pUoi+jSlW7CO21oAE9Mre0lGRpkFwAzgzX1JokiXlJQCxvZUVyjGB6YS2jvCNU1Boya5IrKg/iIRzaThItljr0bX3atTwDkh+FgdrRL7xS98t9MTQVZrjoC4gPVaPW/H5Z3g4VI/cNAha69baRydEIAEXolGBGCvwJW0S39efiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470328; c=relaxed/simple;
	bh=LUtOI/8+H583S4AdL7+YtFDPL2d/+rJveiUGlbe9jGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF87a7Ixh+ZkOxG4CNClKw2MQJb/pPsOh7w88SPu/ADmhxjoxMyXAN4hyj1EI193BBTCdcsNYYCMd76ogM2LoL3qXtSqufqeRc6HXMu8b8p4hhOhfgdjG93admSsPMqpz/W2PGKG71xyp7cWn1W1R2xQIC36vXWwHyGOAKLDQ+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1N+Aj2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1N+Aj2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64009C2BD10;
	Thu, 23 May 2024 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470328;
	bh=LUtOI/8+H583S4AdL7+YtFDPL2d/+rJveiUGlbe9jGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1N+Aj2mtNE06W0YN/sY3VwF+wwa187adTmv/CuZGmot9viJuFX+3G+5YTZBjHAaM
	 59TCIFTGYpFSlxg879jzoc04Fy85oK0xChcqa+E74wlYW1zexXc6cRHboChapmbWKW
	 0snYO2ovq4syDHRugjr/gcIIIoOZR/UZ9vYZwpKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 5.15 09/23] tls: extract context alloc/initialization out of tls_set_sw_offload
Date: Thu, 23 May 2024 15:13:05 +0200
Message-ID: <20240523130328.305064226@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit 615580cbc99af0da2d1c7226fab43a3d5003eb97 upstream.

Simplify tls_set_sw_offload a bit.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aec7961916f3 ("tls: fix race between async notify and socket close")
[v5.15: fixed contextual conflicts from unavailable init_waitqueue_head and
skb_queue_head_init calls in tls_set_sw_offload and init_ctx_rx]
Cc: <stable@vger.kernel.org> # 5.15
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   82 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 33 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2291,6 +2291,46 @@ void tls_sw_strparser_arm(struct sock *s
 	strp_check_rcv(&rx_ctx->strp);
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
+	skb_queue_head_init(&sw_ctx_rx->rx_list);
+
+	return sw_ctx_rx;
+}
+
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -2317,46 +2357,22 @@ int tls_set_sw_offload(struct sock *sk,
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
+		ctx->priv_ctx_rx = init_ctx_rx(ctx);
+		if (!ctx->priv_ctx_rx)
+			return -ENOMEM;
+
+		sw_ctx_rx = ctx->priv_ctx_rx;
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
-		skb_queue_head_init(&sw_ctx_rx->rx_list);
 		aead = &sw_ctx_rx->aead_recv;
 	}
 


