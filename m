Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0558447A64;
	Mon,  1 Apr 2024 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991441; cv=none; b=m79I/hKiiinZ2mXjNaYnqOSH9+icOmZIeQ5593S/NloOhsFz2roDxOfSrfr27tWM5ZZYLdV44U+D3mYld2qrhFuXtAx7zil6GnYL/fKfJ0Y2IuZzwqbY8VfUfCIfMA0AUI7aVFhTw/4Yz1AQokHVVfojM1J0CZ60KvCip9svqrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991441; c=relaxed/simple;
	bh=9XVKOaSsz5cQWBOsqBmvZn+WKQtzFLjf5ElsGLr5xKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeWtJC5abyqAqLEPN8WTIwMKddrCjWmMLUioxA6+YU0AFx28KJcybzi94G3rlhgctXO1zZbpoTJ5uAd+MT4w0Nmjh+QsvTUNc0h4fxZXaGutNbCwmP82O84SO2NnuW4Bh9gZ38qJE1L4HhrqGta15ndGoUy0c3lnmspXUTMuIuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pD1U1l9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pD1U1l9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71442C433C7;
	Mon,  1 Apr 2024 17:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991440;
	bh=9XVKOaSsz5cQWBOsqBmvZn+WKQtzFLjf5ElsGLr5xKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD1U1l9+dLWYaw1c+BXTv5iuIixwKW4v3Ke40QZosMxIUWx8X4I75eGpfxgpJZHlk
	 zZCBnQrPtjc5eRXnYvnEvKZt+FmAXiRkpcnZANNwiixesak9JZCN0YeNFh5k4eSmT5
	 cbm3ufgPCQcZ1GroewXlqRMl7P//sFKiqr1gKPE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 265/272] tls: fix use-after-free on failed backlog decryption
Date: Mon,  1 Apr 2024 17:47:35 +0200
Message-ID: <20240401152539.325098710@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

commit 13114dc5543069f7b97991e3b79937b6da05f5b0 upstream.

When the decrypt request goes to the backlog and crypto_aead_decrypt
returns -EBUSY, tls_do_decryption will wait until all async
decryptions have completed. If one of them fails, tls_do_decryption
will return -EBADMSG and tls_decrypt_sg jumps to the error path,
releasing all the pages. But the pages have been passed to the async
callback, and have already been released by tls_decrypt_done.

The only true async case is when crypto_aead_decrypt returns
 -EINPROGRESS. With -EBUSY, we already waited so we can tell
tls_sw_recvmsg that the data is available for immediate copy, but we
need to notify tls_decrypt_sg (via the new ->async_done flag) that the
memory has already been released.

Fixes: 859054147318 ("net: tls: handle backlogging of crypto requests")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/4755dd8d9bebdefaa19ce1439b833d6199d4364c.1709132643.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -51,6 +51,7 @@ struct tls_decrypt_arg {
 	struct_group(inargs,
 	bool zc;
 	bool async;
+	bool async_done;
 	u8 tail;
 	);
 
@@ -279,18 +280,19 @@ static int tls_do_decryption(struct sock
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
+	if (ret == -EINPROGRESS)
+		return 0;
+
 	if (ret == -EBUSY) {
 		ret = tls_decrypt_async_wait(ctx);
+		darg->async_done = true;
+		/* all completions have run, we're not doing async anymore */
+		darg->async = false;
+		return ret;
 		ret = ret ?: -EINPROGRESS;
 	}
-	if (ret == -EINPROGRESS) {
-		if (darg->async)
-			return 0;
 
-		ret = crypto_wait_req(ret, &ctx->async_wait);
-	} else if (darg->async) {
-		atomic_dec(&ctx->decrypt_pending);
-	}
+	atomic_dec(&ctx->decrypt_pending);
 	darg->async = false;
 
 	return ret;
@@ -1681,8 +1683,11 @@ static int tls_decrypt_sg(struct sock *s
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, sgin, sgout, dctx->iv,
 				data_len + prot->tail_size, aead_req, darg);
-	if (err)
+	if (err) {
+		if (darg->async_done)
+			goto exit_free_skb;
 		goto exit_free_pages;
+	}
 
 	darg->skb = clear_skb ?: tls_strp_msg(ctx);
 	clear_skb = NULL;
@@ -1694,6 +1699,9 @@ static int tls_decrypt_sg(struct sock *s
 		return err;
 	}
 
+	if (unlikely(darg->async_done))
+		return 0;
+
 	if (prot->tail_size)
 		darg->tail = dctx->tail;
 


