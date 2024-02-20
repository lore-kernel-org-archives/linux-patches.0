Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F96714A4E2;
	Tue, 20 Feb 2024 20:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462743; cv=none; b=Y0mqfhRgviIfSiiHh1cqTTRGfzc6CsO/EYa7RIph300QKDFwmfUWONv684Bo1tjzhiANVKdvQxaHO1xr4214mxWeVphFnsF0ZrdUXWrWrDYlUdlgfzujQAAQg7jB1F5p/9tnnUJeZpIzB5Oo5vWcwh0dJCBADkiuc/SYMvNZWPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462743; c=relaxed/simple;
	bh=OOA2/PfgVRi08CO1UMr/y2Z8zbv/r+9hBu/YU7CsPZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fil8U5bYe+q4JLfL0u88A2b5WeEryOBv52LKMkJM6CdMyCckGvMf4F0+L0ielSJACuEW5AL7ZtSNSEHNURCnNt7N9jmQKV0j7eOb/hG3RvVDCJ+3TpBsEtV/YHZZdP8Uk5Uy2urNOVIo4HK62fmX0/a7nowTEdnv2OTpvPeVrCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXtIAEhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXtIAEhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C75C433C7;
	Tue, 20 Feb 2024 20:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462742;
	bh=OOA2/PfgVRi08CO1UMr/y2Z8zbv/r+9hBu/YU7CsPZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXtIAEhEbIiyFXO/j1dnwHJCcjQgEFFFQH1WMuUTSKCUabfFiwFnxQaNnyJ6LzqNT
	 LXkxtE49jxnOUrzlhxdIUWXm8f+n4aXbdWT/OmOO4FmBrwQG/AlSVOZoXqI9jQnhAw
	 SmnOY2zbA5YhijJXK5/6Xdj+LV/yPlcJuIk8y5Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/197] net: tls: factor out tls_*crypt_async_wait()
Date: Tue, 20 Feb 2024 21:49:42 +0100
Message-ID: <20240220204841.774066836@linuxfoundation.org>
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
index 47ae429e50e3..b146be099a3f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -229,6 +229,20 @@ static void tls_decrypt_done(crypto_completion_data_t *data, int err)
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
@@ -496,6 +510,28 @@ static void tls_encrypt_done(crypto_completion_data_t *data, int err)
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
@@ -953,7 +989,6 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int num_zc = 0;
 	int orig_size;
 	int ret = 0;
-	int pending;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
 			       MSG_CMSG_COMPAT))
@@ -1122,24 +1157,12 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
@@ -1171,7 +1194,6 @@ void tls_sw_splice_eof(struct socket *sock)
 	ssize_t copied = 0;
 	bool retrying = false;
 	int ret = 0;
-	int pending;
 
 	if (!ctx->open_rec)
 		return;
@@ -1203,22 +1225,7 @@ void tls_sw_splice_eof(struct socket *sock)
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
@@ -2197,16 +2204,10 @@ int tls_sw_recvmsg(struct sock *sk,
 
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
@@ -2425,16 +2426,9 @@ void tls_sw_release_resources_tx(struct sock *sk)
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



