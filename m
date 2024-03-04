Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB268F58;
	Mon,  4 Mar 2024 21:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588266; cv=none; b=tvL+IncRwsgnnCQ4P9mF3DHeg7pTmJWYfaYMom3TxZ9z6AufE2MigukKjmzT66Et2936Gdnxk4gIcgAqFRt+2Kv7iodChhKFNx9ZUz7oDFHNbDi7cMUu45rf/1BBwbrcm6CZjnPibsCerN9w1ezEM+oW7zgekEesVtKUnx4A258=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588266; c=relaxed/simple;
	bh=pk2j765SDaf4GxYO43C8bOEnHVT7M1/VadZ3OWaytIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDMbCB53yU4v+6LgKUxKDxWSP4sV2gg0yytpojkPaUCvgPzVn5X3ZaG38OfNpYD/Jqn8FRIvGfPFFmLOQZ3EK8KrOCyseZbHfAcboWb4su0Iu0pG8Mq/RZUEfr8Ohe1YkHUutWYrpw6pAyTkJtZvS4mSXbOQPt1Oi4x/kX/Bvog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxUHKAP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxUHKAP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ECCC433F1;
	Mon,  4 Mar 2024 21:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588266;
	bh=pk2j765SDaf4GxYO43C8bOEnHVT7M1/VadZ3OWaytIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxUHKAP4HBRHeBXHe7kYzXCKXsRsuZjXVAh9NZ+FiZhGD7+v14EImmJOn1TaRxRLV
	 QLw1BLCrYsnpF6msRoyzKHR3Rc8k8yyBJGs9GqZx8kLsQacSJ6PSd1xML5Hi7CD2BW
	 Ahd1Wy53f3GWMngApGo3jxdHKXlZbzUAxTMhR04Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/143] tls: fix use-after-free on failed backlog decryption
Date: Mon,  4 Mar 2024 21:22:41 +0000
Message-ID: <20240304211551.250197983@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

[ Upstream commit 13114dc5543069f7b97991e3b79937b6da05f5b0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 733dbae9b057c..acf5bb74fd386 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -52,6 +52,7 @@ struct tls_decrypt_arg {
 	struct_group(inargs,
 	bool zc;
 	bool async;
+	bool async_done;
 	u8 tail;
 	);
 
@@ -286,15 +287,18 @@ static int tls_do_decryption(struct sock *sk,
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
+	if (ret == -EINPROGRESS)
+		return 0;
+
 	if (ret == -EBUSY) {
 		ret = tls_decrypt_async_wait(ctx);
-		ret = ret ?: -EINPROGRESS;
-	}
-	if (ret == -EINPROGRESS) {
-		return 0;
-	} else if (darg->async) {
-		atomic_dec(&ctx->decrypt_pending);
+		darg->async_done = true;
+		/* all completions have run, we're not doing async anymore */
+		darg->async = false;
+		return ret;
 	}
+
+	atomic_dec(&ctx->decrypt_pending);
 	darg->async = false;
 
 	return ret;
@@ -1593,8 +1597,11 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
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
@@ -1606,6 +1613,9 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 		return err;
 	}
 
+	if (unlikely(darg->async_done))
+		return 0;
+
 	if (prot->tail_size)
 		darg->tail = dctx->tail;
 
-- 
2.43.0



