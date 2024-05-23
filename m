Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAD614B083;
	Thu, 23 May 2024 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470326; cv=none; b=s839EvFTM1RxwLy6exL1jfySaWW2GGW5EhazrbjVmU0iWpVyyVS9+RAB2sxj+pH+NkW+0RV2phL5mNcIjU4uPIFciEaSxd2gE+nSRF5blnDUT0tYO5E4yuZnDbdFZIVgQVeIPzbZmeJVNZdCz/JlKPdQZ5y/GERWNEL4Rp2hb98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470326; c=relaxed/simple;
	bh=gH//Nd+UlS+e4EDPhwTPdsUIF5hBHBLdZp2JgyKolaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE11uRukHQauBLeSr9OjvFpj+eZtl+JBiCq1vAjLyG4KPjRi17KlkA1nz/qdFjLDwxAv354e8KOmoZ2aqV9LcxZQS4RfLAsWpsHiQtO8QJyINpYFl/zRsEKQgUfKp2V1Gw+eopn7b940yDaxC0mVHybJoqWJXx6lzg5jIr5RbYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWE8l/rA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWE8l/rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A12C3277B;
	Thu, 23 May 2024 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470325;
	bh=gH//Nd+UlS+e4EDPhwTPdsUIF5hBHBLdZp2JgyKolaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWE8l/rAffe50mPTwR7LFeOPb8kEwSwAA5zNHnYL166Yr2ezd3D50uGUgKMW5Q2Qi
	 K8w71nPGUu2YTqQKqx45cxdlHKsHaqudwJ+FUBfZCCdL1V0EQe1VaoP5X2G84nMTWj
	 tWrv9XSaalNdUVQGGsLQJNLQzFr2ZmI+jhVuUTXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 5.15 08/23] tls: rx: simplify async wait
Date: Thu, 23 May 2024 15:13:04 +0200
Message-ID: <20240523130328.268096025@linuxfoundation.org>
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

commit 37943f047bfb88ba4dfc7a522563f57c86d088a0 upstream.

Since we are protected from async completions by decrypt_compl_lock
we can drop the async_notify and reinit the completion before we
start waiting.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aec7961916f3 ("tls: fix race between async notify and socket close")
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h |    1 -
 net/tls/tls_sw.c  |   14 ++------------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -150,7 +150,6 @@ struct tls_sw_context_rx {
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
-	bool async_notify;
 };
 
 struct tls_record_info {
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -174,7 +174,6 @@ static void tls_decrypt_done(struct cryp
 	struct scatterlist *sg;
 	struct sk_buff *skb;
 	unsigned int pages;
-	int pending;
 
 	skb = (struct sk_buff *)req->data;
 	tls_ctx = tls_get_ctx(skb->sk);
@@ -222,9 +221,7 @@ static void tls_decrypt_done(struct cryp
 	kfree(aead_req);
 
 	spin_lock_bh(&ctx->decrypt_compl_lock);
-	pending = atomic_dec_return(&ctx->decrypt_pending);
-
-	if (!pending && ctx->async_notify)
+	if (!atomic_dec_return(&ctx->decrypt_pending))
 		complete(&ctx->async_wait.completion);
 	spin_unlock_bh(&ctx->decrypt_compl_lock);
 }
@@ -1917,7 +1914,7 @@ recv_end:
 
 		/* Wait for all previously submitted records to be decrypted */
 		spin_lock_bh(&ctx->decrypt_compl_lock);
-		ctx->async_notify = true;
+		reinit_completion(&ctx->async_wait.completion);
 		pending = atomic_read(&ctx->decrypt_pending);
 		spin_unlock_bh(&ctx->decrypt_compl_lock);
 		if (pending) {
@@ -1929,15 +1926,8 @@ recv_end:
 				decrypted = 0;
 				goto end;
 			}
-		} else {
-			reinit_completion(&ctx->async_wait.completion);
 		}
 
-		/* There can be no concurrent accesses, since we have no
-		 * pending decrypt operations
-		 */
-		WRITE_ONCE(ctx->async_notify, false);
-
 		/* Drain records from the rx_list & copy if required */
 		if (is_peek || is_kvec)
 			err = process_rx_list(ctx, msg, &control, copied,


