Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2B876C9C;
	Tue, 20 Feb 2024 21:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463431; cv=none; b=JlxikULOSM8j6y1R14Kc8d6OFyFzdsi/+0pA4EEFa2S8gJ6YlGrXOwmVptXAmz8s2yJD+mZy/PonTjCsJswJcoiaZ3EbcW+/3FBLrvTZ8Wu2g+eCfzkRdCmas0iXToWqcjJWTUPhRDWv+OzcSh9aZwYZ0mfZmAfUoZ0Xq3ShZSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463431; c=relaxed/simple;
	bh=7Xdi6O3J9/icbMeQqU6nOFpqfNxnTZotk7EVTqWYMJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqUEe1FtxQJg3viAmPUqATAMdF2neqrmjS02ebJlAvgah9rsxXHTeponuPD0k4pSZiThuB/U8kckfV9m/2jvGk1ulQVIK7r4blrss2yizPBNKmoe7+ts39UMnw7F+KheQosh+eTRa1IvNkl3c1Y/mWBncmgdrVtOl9xPc+BLnl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBhY58Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBhY58Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56724C433F1;
	Tue, 20 Feb 2024 21:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463430;
	bh=7Xdi6O3J9/icbMeQqU6nOFpqfNxnTZotk7EVTqWYMJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBhY58UvO+YPjx6bmtdzaODRB2FSYrHRqMGFjmOip2XynE3tNJC+piffrjxGwaHTR
	 T0UGZueVAF9X6VmIGnf3fdjCJGKzdNaWN5FfkoDD80P0IwLnIVWF7tm9B1jsbyX0Wy
	 VzMTadG4IYRQhNGk/FdgP5N99gtAHskw9wHYB4HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/331] tls: fix race between async notify and socket close
Date: Tue, 20 Feb 2024 21:52:37 +0100
Message-ID: <20240220205638.906951425@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit aec7961916f3f9e88766e2688992da6980f11b8d ]

The submitting thread (one which called recvmsg/sendmsg)
may exit as soon as the async crypto handler calls complete()
so any code past that point risks touching already freed data.

Try to avoid the locking and extra flags altogether.
Have the main thread hold an extra reference, this way
we can depend solely on the atomic ref counter for
synchronization.

Don't futz with reiniting the completion, either, we are now
tightly controlling when completion fires.

Reported-by: valis <sec@valis.email>
Fixes: 0cada33241d9 ("net/tls: fix race condition causing kernel panic")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h |  5 -----
 net/tls/tls_sw.c  | 43 ++++++++++---------------------------------
 2 files changed, 10 insertions(+), 38 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index a2b44578dcb7..5fdd5dd251df 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -96,9 +96,6 @@ struct tls_sw_context_tx {
 	struct tls_rec *open_rec;
 	struct list_head tx_list;
 	atomic_t encrypt_pending;
-	/* protect crypto_wait with encrypt_pending */
-	spinlock_t encrypt_compl_lock;
-	int async_notify;
 	u8 async_capable:1;
 
 #define BIT_TX_SCHEDULED	0
@@ -135,8 +132,6 @@ struct tls_sw_context_rx {
 	struct tls_strparser strp;
 
 	atomic_t decrypt_pending;
-	/* protect crypto_wait with decrypt_pending*/
-	spinlock_t decrypt_compl_lock;
 	struct sk_buff_head async_hold;
 	struct wait_queue_head wq;
 };
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 12c3635c2b3e..650080d5fd72 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -224,22 +224,15 @@ static void tls_decrypt_done(void *data, int err)
 
 	kfree(aead_req);
 
-	spin_lock_bh(&ctx->decrypt_compl_lock);
-	if (!atomic_dec_return(&ctx->decrypt_pending))
+	if (atomic_dec_and_test(&ctx->decrypt_pending))
 		complete(&ctx->async_wait.completion);
-	spin_unlock_bh(&ctx->decrypt_compl_lock);
 }
 
 static int tls_decrypt_async_wait(struct tls_sw_context_rx *ctx)
 {
-	int pending;
-
-	spin_lock_bh(&ctx->decrypt_compl_lock);
-	reinit_completion(&ctx->async_wait.completion);
-	pending = atomic_read(&ctx->decrypt_pending);
-	spin_unlock_bh(&ctx->decrypt_compl_lock);
-	if (pending)
+	if (!atomic_dec_and_test(&ctx->decrypt_pending))
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+	atomic_inc(&ctx->decrypt_pending);
 
 	return ctx->async_wait.err;
 }
@@ -267,6 +260,7 @@ static int tls_do_decryption(struct sock *sk,
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  tls_decrypt_done, aead_req);
+		DEBUG_NET_WARN_ON_ONCE(atomic_read(&ctx->decrypt_pending) < 1);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
 		aead_request_set_callback(aead_req,
@@ -455,7 +449,6 @@ static void tls_encrypt_done(void *data, int err)
 	struct sk_msg *msg_en;
 	bool ready = false;
 	struct sock *sk;
-	int pending;
 
 	msg_en = &rec->msg_encrypted;
 
@@ -494,12 +487,8 @@ static void tls_encrypt_done(void *data, int err)
 			ready = true;
 	}
 
-	spin_lock_bh(&ctx->encrypt_compl_lock);
-	pending = atomic_dec_return(&ctx->encrypt_pending);
-
-	if (!pending && ctx->async_notify)
+	if (atomic_dec_and_test(&ctx->encrypt_pending))
 		complete(&ctx->async_wait.completion);
-	spin_unlock_bh(&ctx->encrypt_compl_lock);
 
 	if (!ready)
 		return;
@@ -511,22 +500,9 @@ static void tls_encrypt_done(void *data, int err)
 
 static int tls_encrypt_async_wait(struct tls_sw_context_tx *ctx)
 {
-	int pending;
-
-	spin_lock_bh(&ctx->encrypt_compl_lock);
-	ctx->async_notify = true;
-
-	pending = atomic_read(&ctx->encrypt_pending);
-	spin_unlock_bh(&ctx->encrypt_compl_lock);
-	if (pending)
+	if (!atomic_dec_and_test(&ctx->encrypt_pending))
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
-	else
-		reinit_completion(&ctx->async_wait.completion);
-
-	/* There can be no concurrent accesses, since we have no
-	 * pending encrypt operations
-	 */
-	WRITE_ONCE(ctx->async_notify, false);
+	atomic_inc(&ctx->encrypt_pending);
 
 	return ctx->async_wait.err;
 }
@@ -577,6 +553,7 @@ static int tls_do_encryption(struct sock *sk,
 
 	/* Add the record in tx_list */
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
+	DEBUG_NET_WARN_ON_ONCE(atomic_read(&ctx->encrypt_pending) < 1);
 	atomic_inc(&ctx->encrypt_pending);
 
 	rc = crypto_aead_encrypt(aead_req);
@@ -2604,7 +2581,7 @@ static struct tls_sw_context_tx *init_ctx_tx(struct tls_context *ctx, struct soc
 	}
 
 	crypto_init_wait(&sw_ctx_tx->async_wait);
-	spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
+	atomic_set(&sw_ctx_tx->encrypt_pending, 1);
 	INIT_LIST_HEAD(&sw_ctx_tx->tx_list);
 	INIT_DELAYED_WORK(&sw_ctx_tx->tx_work.work, tx_work_handler);
 	sw_ctx_tx->tx_work.sk = sk;
@@ -2625,7 +2602,7 @@ static struct tls_sw_context_rx *init_ctx_rx(struct tls_context *ctx)
 	}
 
 	crypto_init_wait(&sw_ctx_rx->async_wait);
-	spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
+	atomic_set(&sw_ctx_rx->decrypt_pending, 1);
 	init_waitqueue_head(&sw_ctx_rx->wq);
 	skb_queue_head_init(&sw_ctx_rx->rx_list);
 	skb_queue_head_init(&sw_ctx_rx->async_hold);
-- 
2.43.0



