Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457901509BC;
	Tue, 20 Feb 2024 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463425; cv=none; b=G5flGEYCORzUwy4CxBOGVwuC/Pv5CvgzcOE2S3ScgkliC0f9tFbkHsAWMucqPAYFkbOHWEfTJNgsdo0DPSUDu7/vroiePQUShaCM2cD+yOHcVTKgXYONsY1fhPViOlTuY3Bv08dAZJWw2BxDr5ULN5LBmxZHzzfVzZu5SQDACX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463425; c=relaxed/simple;
	bh=FrQ1ALmS+lwA93qv1EHtFEq0SV9CF/GZLgMGZGC1MhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZR3G4N28JuhdEBvE5472Dtq0yjpWJ3btTx2dFouMHw8fkJulUUFBI5L5FFaax//ynlc83DjVy+bd4M7XjORlYXLAFi4W6ivTmFfui9LOylY/KjyJF68TR2MMDMQZ8wuiQrWNHc+c7NxLZj1CsEr2NVHSq2AI5uqVslca0ln1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Swz1Ksov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Swz1Ksov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE2AC433F1;
	Tue, 20 Feb 2024 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463424;
	bh=FrQ1ALmS+lwA93qv1EHtFEq0SV9CF/GZLgMGZGC1MhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Swz1KsovBXdYLscJ2bbHcZf7nkM8MX9ma07Al3WyiGadNB0aR49ImX2RKhUmvdNTd
	 DAwCmCwwQWfa5JPIP6O0Yar7nn4h7Zbf/JnUvI+LzM4XQRS93Afuq5HEp8Ziq169Af
	 KeYfwBeZwvh1wTS9XbQKeeft6XEvz4rhU9QMRhxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/331] net: tls: factor out tls_*crypt_async_wait()
Date: Tue, 20 Feb 2024 21:52:36 +0100
Message-ID: <20240220205638.868626160@linuxfoundation.org>
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

[ Upstream commit c57ca512f3b68ddcd62bda9cc24a8f5584ab01b1 ]

Factor out waiting for async encrypt and decrypt to finish.
There are already multiple copies and a subsequent fix will
need more. No functional changes.

Note that crypto_wait_req() returns wait->err

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aec7961916f3 ("tls: fix race between async notify and socket close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 96 +++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 51 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 3c176776e912..12c3635c2b3e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -230,6 +230,20 @@ static void tls_decrypt_done(void *data, int err)
 	spin_unlock_bh(&ctx->decrypt_compl_lock);
 }
 
+static int tls_decrypt_async_wait(struct tls_sw_context_rx *ctx)
+{
+	int pending;
+
+	spin_lock_bh(&ctx->decrypt_compl_lock);
+	reinit_completion(&ctx->async_wait.completion);
+	pending = atomic_read(&ctx->decrypt_pending);
+	spin_unlock_bh(&ctx->decrypt_compl_lock);
+	if (pending)
+		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+
+	return ctx->async_wait.err;
+}
+
 static int tls_do_decryption(struct sock *sk,
 			     struct scatterlist *sgin,
 			     struct scatterlist *sgout,
@@ -495,6 +509,28 @@ static void tls_encrypt_done(void *data, int err)
 		schedule_delayed_work(&ctx->tx_work.work, 1);
 }
 
+static int tls_encrypt_async_wait(struct tls_sw_context_tx *ctx)
+{
+	int pending;
+
+	spin_lock_bh(&ctx->encrypt_compl_lock);
+	ctx->async_notify = true;
+
+	pending = atomic_read(&ctx->encrypt_pending);
+	spin_unlock_bh(&ctx->encrypt_compl_lock);
+	if (pending)
+		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+	else
+		reinit_completion(&ctx->async_wait.completion);
+
+	/* There can be no concurrent accesses, since we have no
+	 * pending encrypt operations
+	 */
+	WRITE_ONCE(ctx->async_notify, false);
+
+	return ctx->async_wait.err;
+}
+
 static int tls_do_encryption(struct sock *sk,
 			     struct tls_context *tls_ctx,
 			     struct tls_sw_context_tx *ctx,
@@ -984,7 +1020,6 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 	int num_zc = 0;
 	int orig_size;
 	int ret = 0;
-	int pending;
 
 	if (!eor && (msg->msg_flags & MSG_EOR))
 		return -EINVAL;
@@ -1163,24 +1198,12 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 	if (!num_async) {
 		goto send_end;
 	} else if (num_zc) {
-		/* Wait for pending encryptions to get completed */
-		spin_lock_bh(&ctx->encrypt_compl_lock);
-		ctx->async_notify = true;
-
-		pending = atomic_read(&ctx->encrypt_pending);
-		spin_unlock_bh(&ctx->encrypt_compl_lock);
-		if (pending)
-			crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
-		else
-			reinit_completion(&ctx->async_wait.completion);
-
-		/* There can be no concurrent accesses, since we have no
-		 * pending encrypt operations
-		 */
-		WRITE_ONCE(ctx->async_notify, false);
+		int err;
 
-		if (ctx->async_wait.err) {
-			ret = ctx->async_wait.err;
+		/* Wait for pending encryptions to get completed */
+		err = tls_encrypt_async_wait(ctx);
+		if (err) {
+			ret = err;
 			copied = 0;
 		}
 	}
@@ -1229,7 +1252,6 @@ void tls_sw_splice_eof(struct socket *sock)
 	ssize_t copied = 0;
 	bool retrying = false;
 	int ret = 0;
-	int pending;
 
 	if (!ctx->open_rec)
 		return;
@@ -1264,22 +1286,7 @@ void tls_sw_splice_eof(struct socket *sock)
 	}
 
 	/* Wait for pending encryptions to get completed */
-	spin_lock_bh(&ctx->encrypt_compl_lock);
-	ctx->async_notify = true;
-
-	pending = atomic_read(&ctx->encrypt_pending);
-	spin_unlock_bh(&ctx->encrypt_compl_lock);
-	if (pending)
-		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
-	else
-		reinit_completion(&ctx->async_wait.completion);
-
-	/* There can be no concurrent accesses, since we have no pending
-	 * encrypt operations
-	 */
-	WRITE_ONCE(ctx->async_notify, false);
-
-	if (ctx->async_wait.err)
+	if (tls_encrypt_async_wait(ctx))
 		goto unlock;
 
 	/* Transmit if any encryptions have completed */
@@ -2109,16 +2116,10 @@ int tls_sw_recvmsg(struct sock *sk,
 
 recv_end:
 	if (async) {
-		int ret, pending;
+		int ret;
 
 		/* Wait for all previously submitted records to be decrypted */
-		spin_lock_bh(&ctx->decrypt_compl_lock);
-		reinit_completion(&ctx->async_wait.completion);
-		pending = atomic_read(&ctx->decrypt_pending);
-		spin_unlock_bh(&ctx->decrypt_compl_lock);
-		ret = 0;
-		if (pending)
-			ret = crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+		ret = tls_decrypt_async_wait(ctx);
 		__skb_queue_purge(&ctx->async_hold);
 
 		if (ret) {
@@ -2435,16 +2436,9 @@ void tls_sw_release_resources_tx(struct sock *sk)
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
-	int pending;
 
 	/* Wait for any pending async encryptions to complete */
-	spin_lock_bh(&ctx->encrypt_compl_lock);
-	ctx->async_notify = true;
-	pending = atomic_read(&ctx->encrypt_pending);
-	spin_unlock_bh(&ctx->encrypt_compl_lock);
-
-	if (pending)
-		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+	tls_encrypt_async_wait(ctx);
 
 	tls_tx_records(sk, -1);
 
-- 
2.43.0



