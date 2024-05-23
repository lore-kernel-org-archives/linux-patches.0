Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9524E2AE94;
	Thu, 23 May 2024 13:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470294; cv=none; b=BjWNpyVFqLswEIPb7PC1nIvuFoklURBDNawKdIWkHyDWVax9zQCs01ndgohy1xVJdMM3cBJxHttFI6eUgQ8i1V2keS64aQk2Mo8Pgg62PCbofL/bAy2gffO+u/eEwT5PKou/En5SN+F4hdFv8PgalBMtnHkyCRgyFiprCfsj/fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470294; c=relaxed/simple;
	bh=clbvBLTGA/dWwceJit2jmVA4H1ec14yENQHlDGM+eMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INbs+bxHpHB/fJA0gXMAIfma6oe/j9GJdV4WOyhaJY3f4HYn8Vd4wYQ081jIA+E4d1dP7A7w4Fkqzlxk1uk/vkG5MOuENlaEh/FX56KRH22ZFS8DhOUNu2wTI1eS1tdA3C7M3NglFc9VKrVW04LIqhhO0b9TvjypkJ2pUXla34k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHwdI+XD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHwdI+XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D49EC2BD10;
	Thu, 23 May 2024 13:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470294;
	bh=clbvBLTGA/dWwceJit2jmVA4H1ec14yENQHlDGM+eMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHwdI+XDtL7G+hEV+zY4gpRLF0TtslO5b89Oao4Urm+filLbaUF9ulXX2xCnq9BCF
	 9eEFXkQOrAakVE7WKG6lg16YCC/nPjyh5ahm8YsWCxxsz5xiaDIGQMHiIPIaRTjf7E
	 /NVfqhDpSRIyXHGE4I7z4sSsZRwDsU/hltyN/TNU=
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
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 5.15 11/23] tls: fix race between async notify and socket close
Date: Thu, 23 May 2024 15:13:07 +0200
Message-ID: <20240523130328.380394341@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit aec7961916f3f9e88766e2688992da6980f11b8d upstream.

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
[v5.15: fixed contextual conflicts in struct tls_sw_context_rx and func
init_ctx_rx; replaced DEBUG_NET_WARN_ON_ONCE with BUILD_BUG_ON_INVALID
since they're equivalent when DEBUG_NET is not defined]
Cc: <stable@vger.kernel.org> # 5.15
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h |    5 -----
 net/tls/tls_sw.c  |   43 ++++++++++---------------------------------
 2 files changed, 10 insertions(+), 38 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -128,9 +128,6 @@ struct tls_sw_context_tx {
 	struct tls_rec *open_rec;
 	struct list_head tx_list;
 	atomic_t encrypt_pending;
-	/* protect crypto_wait with encrypt_pending */
-	spinlock_t encrypt_compl_lock;
-	int async_notify;
 	u8 async_capable:1;
 
 #define BIT_TX_SCHEDULED	0
@@ -148,8 +145,6 @@ struct tls_sw_context_rx {
 	struct sk_buff *recv_pkt;
 	u8 async_capable:1;
 	atomic_t decrypt_pending;
-	/* protect crypto_wait with decrypt_pending*/
-	spinlock_t decrypt_compl_lock;
 };
 
 struct tls_record_info {
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -220,22 +220,15 @@ static void tls_decrypt_done(struct cryp
 
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
@@ -271,6 +264,7 @@ static int tls_do_decryption(struct sock
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  tls_decrypt_done, skb);
+		BUILD_BUG_ON_INVALID(atomic_read(&ctx->decrypt_pending) < 1);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
 		aead_request_set_callback(aead_req,
@@ -460,7 +454,6 @@ static void tls_encrypt_done(struct cryp
 	struct sk_msg *msg_en;
 	struct tls_rec *rec;
 	bool ready = false;
-	int pending;
 
 	rec = container_of(aead_req, struct tls_rec, aead_req);
 	msg_en = &rec->msg_encrypted;
@@ -495,12 +488,8 @@ static void tls_encrypt_done(struct cryp
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
@@ -512,22 +501,9 @@ static void tls_encrypt_done(struct cryp
 
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
@@ -571,6 +547,7 @@ static int tls_do_encryption(struct sock
 
 	/* Add the record in tx_list */
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
+	BUILD_BUG_ON_INVALID(atomic_read(&ctx->encrypt_pending) < 1);
 	atomic_inc(&ctx->encrypt_pending);
 
 	rc = crypto_aead_encrypt(aead_req);
@@ -2312,7 +2289,7 @@ static struct tls_sw_context_tx *init_ct
 	}
 
 	crypto_init_wait(&sw_ctx_tx->async_wait);
-	spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
+	atomic_set(&sw_ctx_tx->encrypt_pending, 1);
 	INIT_LIST_HEAD(&sw_ctx_tx->tx_list);
 	INIT_DELAYED_WORK(&sw_ctx_tx->tx_work.work, tx_work_handler);
 	sw_ctx_tx->tx_work.sk = sk;
@@ -2333,7 +2310,7 @@ static struct tls_sw_context_rx *init_ct
 	}
 
 	crypto_init_wait(&sw_ctx_rx->async_wait);
-	spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
+	atomic_set(&sw_ctx_rx->decrypt_pending, 1);
 	skb_queue_head_init(&sw_ctx_rx->rx_list);
 
 	return sw_ctx_rx;


