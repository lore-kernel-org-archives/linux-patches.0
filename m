Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602D639768C;
	Tue, 21 Jul 2026 22:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673432; cv=none; b=oX1FN1egniuxtZyMjqV5T2kfuWc5EqxOrLl617OtNNa9alZFPG6bMpXYML/lopiYKbnNxkn5c94yg7OdQS1pnmuwmFdadDUU4bUfIqH0Qhj06HR3KFk7Udpx5gv2s3iPPhNz8VDswoEFhgqAs68LAdmN1aWKD+2EKR+DAe7ozpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673432; c=relaxed/simple;
	bh=cSLPt3Z9lPz8hrmCrlNxDISb7fyfdK2+3gLSgRyZUcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdFncdDhu0rDRodx48HFlVErUbpFUUSTqYhimGbE0Ac/op74mMf4BtZfpTIeeSwAymrVKqFKG4Akasj3TuD8nb8xJToiPxx26B0pqOjFMLs7YIhMeULcR7ZnkB4Tk/6haC5QTHC98AshnNNGfYG2aUK8GXnSdpnHM9dPKMbjbqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hM7gEsze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hM7gEsze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DDD1F00A3A;
	Tue, 21 Jul 2026 22:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673431;
	bh=uq112vTAiQoZpql56vPXOvthdLb6SBO6ibLkYYyJckk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hM7gEszeAvOvz0+gCT/Xi3pAeXmPz5kqEe9Xghl+539dUMdleJ5ekQvNGn8C+qYTV
	 AICUZjzTIn4j7pf0hCc/Z8d1iwxt8pvbkRIgJLGB9jM5sOFa9ZCpYCEstXg4HC3tSw
	 PJk9AWVPspkKMqeggLkCjVv+gHS0muQ5FO7ku5nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/699] crypto: algif_skcipher - force synchronous processing on trees without ctx->state
Date: Tue, 21 Jul 2026 17:18:38 +0200
Message-ID: <20260721152359.290665197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>

The AIO/async path in skcipher_recvmsg() passes the socket-wide ctx->iv
directly into the skcipher request. After io_submit() the socket lock is
dropped and the request is processed asynchronously, so a concurrent
sendmsg(ALG_SET_IV) can overwrite ctx->iv and make the in-flight request
run under an attacker-controlled IV. For CTR/stream modes this is
IV/keystream reuse and lets an unprivileged user recover the plaintext of
a concurrent operation.

Snapshotting ctx->iv into per-request storage for the async path is not
sufficient. For ciphers with statesize == 0 - which includes cbc and ctr -
the MSG_MORE inter-chunk IV chaining is carried solely by the in-place
req->iv writeback, which a snapshot redirects into per-request memory that
af_alg_free_resources() releases on completion, silently producing wrong
output. Writing the IV back from the completion callback instead is not
possible either: that would require lock_sock() there, but the callback can
run in softirq/atomic context, so it must not sleep.

Make the operation synchronous instead, which removes both the IV race and
any writeback race. This is equivalent to the upstream resolution, commit
fcc77d33a34c ("net: Remove support for AIO on sockets"), which removed the
AIO socket path across net/ entirely and so produces the same end state for
this file. This patch deviates from that commit deliberately: rather than
removing AIO socket support tree-wide, which would be far too invasive for
stable, it removes only the AIO branch in crypto/algif_skcipher.c.
io_submit() now completes synchronously; AF_ALG async is rarely used in
practice.

The -EIOCBQUEUED check in skcipher_recvmsg() is now dead but harmless,
and is left alone to keep the fix minimal.

Tested on 6.6.y: attacker IV injection dropped from 2296/200000 to 0/200000
after the change; MSG_MORE chunked CTR output bit-identical to single-shot.

Reported-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: <stable@vger.kernel.org>
Signed-off-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 49 +++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 8b314260929fbb..6a1a71284fe823 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -107,37 +107,24 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
 				   areq->first_rsgl.sgl.sg, len, ctx->iv);
 
-	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
-		/* AIO operation */
-		sock_hold(sk);
-		areq->iocb = msg->msg_iocb;
-
-		/* Remember output size that will be generated. */
-		areq->outlen = len;
-
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      af_alg_async_cb, areq);
-		err = ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
-
-		/* AIO operation in progress */
-		if (err == -EINPROGRESS)
-			return -EIOCBQUEUED;
-
-		sock_put(sk);
-	} else {
-		/* Synchronous operation */
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      CRYPTO_TFM_REQ_MAY_SLEEP |
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
-					      crypto_req_done, &ctx->wait);
-		err = crypto_wait_req(ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
-						 &ctx->wait);
-	}
+	/*
+	 * Force synchronous processing.  The async (AIO) path passed the
+	 * socket-wide ctx->iv into the request, which the worker
+	 * dereferenced after the socket lock was dropped, letting a
+	 * concurrent sendmsg(ALG_SET_IV) inject an attacker IV.  Mainline
+	 * removed the AIO socket path in commit fcc77d33a34c ("net: Remove
+	 * support for AIO on sockets"); these stable trees lack the
+	 * per-request ctx->state used by newer kernels, so the minimal safe
+	 * fix is to always complete synchronously.
+	 */
+	skcipher_request_set_callback(&areq->cra_u.skcipher_req,
+				      CRYPTO_TFM_REQ_MAY_SLEEP |
+				      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      crypto_req_done, &ctx->wait);
+	err = crypto_wait_req(ctx->enc ?
+		crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
+		crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
+				      &ctx->wait);
 
 
 free:
-- 
2.53.0



