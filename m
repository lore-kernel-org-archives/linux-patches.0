Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6EE14C585;
	Tue, 20 Feb 2024 20:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462749; cv=none; b=PL3JfEXVKlXlA2FtQwIECWUa/jSaLqUeu9OJriGS9/doBWHRVkreXQgCU5RNj5+9uH7OjlvDwnJfJ2MUlmaN2RdIfG4KKGxQEYIVw/4q+Ob/tr0IKRiEW51/pZ2tz0Ed3xBcv+HmiiuwBgNkdhNHyeLEIuAqs8nGib8iJfR9+xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462749; c=relaxed/simple;
	bh=EGQRBkAYAEoPVdO9gJxcWDNIUn0NxHSO+j+D7x3D0hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRmRuJ5pX46pjkBvLuVk87CjC3j4gnECPDlf8fj+pCZ9BnfHaY2eksMUzZ50mOH4CK58IgsTkDvnlbiHxMLgXQ6ya/ia/wzF6xRUA8iXmwhuhOUIcpybsl90uRCfH0nXgkcw4qDohPuO8C+enO83Y/SR9gfME5AcHHQifEM4nhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rHUK5oP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rHUK5oP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F7C433F1;
	Tue, 20 Feb 2024 20:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462749;
	bh=EGQRBkAYAEoPVdO9gJxcWDNIUn0NxHSO+j+D7x3D0hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rHUK5oPmINYZntUx6sxz9P3o5XRn+8BUojZvvLtpRyBzVg3ML+CGMOnL2Oc0enhv
	 ISJPEOs0JNtgphiBHl3yMQhXGwdO9T2uGw+Ezk2kquYeAW+o1FbXYO5FO9WO7IL5s7
	 gzbM6RVy5Mp7JnytV5/p9hmV2kXTGP5fsBXUxxfA=
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
Subject: [PATCH 6.1 024/197] tls: fix race between async notify and socket close
Date: Tue, 20 Feb 2024 21:49:43 +0100
Message-ID: <20240220204841.802959077@linuxfoundation.org>
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
index c36bf4c50027..899c863aba02 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -108,9 +108,6 @@ struct tls_sw_context_tx {
 	struct tls_rec *open_rec;
 	struct list_head tx_list;
 	atomic_t encrypt_pending;
-	/* protect crypto_wait with encrypt_pending */
-	spinlock_t encrypt_compl_lock;
-	int async_notify;
 	u8 async_capable:1;
 
 #define BIT_TX_SCHEDULED	0
@@ -147,8 +144,6 @@ struct tls_sw_context_rx {
 	struct tls_strparser strp;
 
 	atomic_t decrypt_pending;
-	/* protect crypto_wait with decrypt_pending*/
-	spinlock_t decrypt_compl_lock;
 	struct sk_buff_head async_hold;
 	struct wait_queue_head wq;
 };
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index b146be099a3f..ee11932237c0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -223,22 +223,15 @@ static void tls_decrypt_done(crypto_completion_data_t *data, int err)
 
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
@@ -266,6 +259,7 @@ static int tls_do_decryption(struct sock *sk,
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  tls_decrypt_done, aead_req);
+		DEBUG_NET_WARN_ON_ONCE(atomic_read(&ctx->decrypt_pending) < 1);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
 		aead_request_set_callback(aead_req,
@@ -455,7 +449,6 @@ static void tls_encrypt_done(crypto_completion_data_t *data, int err)
 	struct tls_rec *rec;
 	bool ready = false;
 	struct sock *sk;
-	int pending;
 
 	rec = container_of(aead_req, struct tls_rec, aead_req);
 	msg_en = &rec->msg_encrypted;
@@ -495,12 +488,8 @@ static void tls_encrypt_done(crypto_completion_data_t *data, int err)
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
@@ -512,22 +501,9 @@ static void tls_encrypt_done(crypto_completion_data_t *data, int err)
 
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
@@ -578,6 +554,7 @@ static int tls_do_encryption(struct sock *sk,
 
 	/* Add the record in tx_list */
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
+	DEBUG_NET_WARN_ON_ONCE(atomic_read(&ctx->encrypt_pending) < 1);
 	atomic_inc(&ctx->encrypt_pending);
 
 	rc = crypto_aead_encrypt(aead_req);
@@ -2594,7 +2571,7 @@ static struct tls_sw_context_tx *init_ctx_tx(struct tls_context *ctx, struct soc
 	}
 
 	crypto_init_wait(&sw_ctx_tx->async_wait);
-	spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
+	atomic_set(&sw_ctx_tx->encrypt_pending, 1);
 	INIT_LIST_HEAD(&sw_ctx_tx->tx_list);
 	INIT_DELAYED_WORK(&sw_ctx_tx->tx_work.work, tx_work_handler);
 	sw_ctx_tx->tx_work.sk = sk;
@@ -2615,7 +2592,7 @@ static struct tls_sw_context_rx *init_ctx_rx(struct tls_context *ctx)
 	}
 
 	crypto_init_wait(&sw_ctx_rx->async_wait);
-	spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
+	atomic_set(&sw_ctx_rx->decrypt_pending, 1);
 	init_waitqueue_head(&sw_ctx_rx->wq);
 	skb_queue_head_init(&sw_ctx_rx->rx_list);
 	skb_queue_head_init(&sw_ctx_rx->async_hold);
-- 
2.43.0



