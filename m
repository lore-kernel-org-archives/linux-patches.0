Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A4246EF65;
	Tue, 21 Jul 2026 19:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661387; cv=none; b=eP07Q0mXXyFabmF2MKNnQ5QOt9vvhHxad6ZeuJL+RR8xdobT8XuRejquQB9q7VtxcF9sEwDxIbiyv57neh1AEXaha2yuxX5BDnM9shy6eqC22vf/tDMa9jb5z2S/tv/CxhIuEEKujfIj7+eOC40/Ew2/3F6dWwmbw9MJpV0KePU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661387; c=relaxed/simple;
	bh=XHsuLtQP3rPW531rtMxYXThJ9mqkJJa7SYpNycjgu2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4gCgHKxjQDdLV+Ny3goOVHaUFC2aoJvD8fw1pLcKA1JuEH6JE0BLYg31Vu06rwu7e5q318CuFjkfboxZaX6lQjasqHB0FatDyX0/csEYvyGYUR1h4eA0RLaEdK1l4XDJ7UtDYPE29XOI6w5ABmul+fMaIM4zxeO3nBxFIc5UFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tK5ckFY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tK5ckFY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8532B1F000E9;
	Tue, 21 Jul 2026 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661386;
	bh=vTcZV8EFHoc+2zHj07W9laqAbofxr9zvm132oOsz6Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tK5ckFY0jGIsW7Ix7cbitD/7G5PMUmRRhOPY55oXmtd2yb4tWwiJgOH8DTf65SxuV
	 xU+3k+bvDDJ/ztxR3bTrj46OomGSUAgWWOG2Ov95pFSXPyHDnFCDTgupgDK6n8nB15
	 USDfVEvPKqClhMIXHD7xAOtSNWIxW3HoPSVi8t6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0011/1276] crypto: algif_skcipher - force synchronous processing
Date: Tue, 21 Jul 2026 17:07:34 +0200
Message-ID: <20260721152446.328006258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>

The AIO/async path in skcipher_recvmsg() passes the socket-wide ctx->iv
directly into the skcipher request. After io_submit() the socket lock is
dropped and the request is processed asynchronously by a worker (e.g.
cryptd), which dereferences ctx->iv only later.

A concurrent sendmsg(ALG_SET_IV) on the same socket can overwrite ctx->iv
inside this window, so the in-flight request runs under an
attacker-controlled IV. For CTR and other stream modes this causes
IV/keystream reuse and allows an unprivileged user to recover the
plaintext of a concurrent operation.

Snapshotting ctx->iv into per-request storage for the async path is not
sufficient here. For ciphers with statesize == 0 - which includes cbc
and ctr - skcipher_prepare_alg() installs skcipher_noimport()/
skcipher_noexport(), so ctx->state carries nothing and the MSG_MORE
inter-chunk IV chaining is carried solely by the in-place req->iv
writeback. A snapshot redirects that writeback into per-request memory
that af_alg_free_resources() releases on completion, so AIO + MSG_MORE
with cbc/ctr would silently produce wrong output. Writing the IV back
from the completion callback instead is not possible either: that would
require lock_sock() there, but the callback can run in softirq/atomic
context, so it must not sleep.

Make the operation synchronous instead. ctx->iv is then only ever
dereferenced under the socket lock held by recvmsg(), which removes the
race, and the req->iv writeback lands in ctx->iv as before, which keeps
MSG_MORE chaining intact for statesize == 0 ciphers. The ctx->state
import/export path is unchanged for ciphers that do have state.

This is equivalent to the upstream resolution: commit fcc77d33a34c
("net: Remove support for AIO on sockets") removed the AIO socket path
across net/ entirely, producing the same end state for this file -
algif_skcipher never processes an AIO request asynchronously. After this
patch, _skcipher_recvmsg() matches mainline's crypto/algif_skcipher.c as
it stands today, including the same now-dead -EIOCBQUEUED check. This
patch deviates from that commit deliberately: rather than removing AIO
socket support tree-wide, which would be far too invasive for stable, it
removes only the AIO branch in crypto/algif_skcipher.c. io_submit() now
completes synchronously, which is valid for the AIO interface; AF_ALG
async is rarely used in practice.

The -EIOCBQUEUED check in skcipher_recvmsg() is now dead but harmless,
and is left alone to keep the fix minimal.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: <stable@vger.kernel.org>
Reported-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Signed-off-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 75 +++++++++++++----------------------------
 1 file changed, 24 insertions(+), 51 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17fd95aca2..35ebc3e0201b04 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -79,20 +79,6 @@ static int algif_skcipher_export(struct sock *sk, struct skcipher_request *req)
 	return err;
 }
 
-static void algif_skcipher_done(void *data, int err)
-{
-	struct af_alg_async_req *areq = data;
-	struct sock *sk = areq->sk;
-
-	if (err)
-		goto out;
-
-	err = algif_skcipher_export(sk, &areq->cra_u.skcipher_req);
-
-out:
-	af_alg_async_cb(data, err);
-}
-
 static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t ignored, int flags)
 {
@@ -171,43 +157,30 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		cflags |= CRYPTO_SKCIPHER_REQ_CONT;
 	}
 
-	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
-		/* AIO operation */
-		sock_hold(sk);
-		areq->iocb = msg->msg_iocb;
-
-		/* Remember output size that will be generated. */
-		areq->outlen = len;
-
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      cflags |
-					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      algif_skcipher_done, areq);
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
-					      cflags |
-					      CRYPTO_TFM_REQ_MAY_SLEEP |
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
-					      crypto_req_done, &ctx->wait);
-		err = crypto_wait_req(ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
-						 &ctx->wait);
-
-		if (!err)
-			err = algif_skcipher_export(
-				sk, &areq->cra_u.skcipher_req);
-	}
+	/*
+	 * Force synchronous processing.  The async (AIO) path passed the
+	 * socket-wide ctx->iv into the request, which the worker
+	 * dereferenced after the socket lock had been dropped, letting a
+	 * concurrent sendmsg(ALG_SET_IV) inject an attacker IV.  Mainline
+	 * removed the AIO socket path in commit fcc77d33a34c ("net: Remove
+	 * support for AIO on sockets"); the minimal stable fix is to always
+	 * complete synchronously, so ctx->iv is only ever dereferenced under
+	 * the socket lock.  This also keeps the IV chaining intact: for
+	 * ciphers with statesize == 0 (e.g. ctr, cbc) the chained IV is
+	 * carried by the req->iv writeback into ctx->iv, which is only
+	 * consistent on the synchronous path.
+	 */
+	skcipher_request_set_callback(&areq->cra_u.skcipher_req,
+				      cflags |
+				      CRYPTO_TFM_REQ_MAY_SLEEP |
+				      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      crypto_req_done, &ctx->wait);
+	err = crypto_wait_req(ctx->enc ?
+		crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
+		crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
+				 &ctx->wait);
+	if (!err)
+		err = algif_skcipher_export(sk, &areq->cra_u.skcipher_req);
 
 free:
 	af_alg_free_resources(areq);
-- 
2.53.0



