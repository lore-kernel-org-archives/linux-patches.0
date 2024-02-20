Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A557F14C585;
	Tue, 20 Feb 2024 20:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462752; cv=none; b=e/pr0CYW9I2cjbrs7VgJc/q6N4bni9FZXO2zyQZqhALW5AUSVZggK8/aitVbH7oy2oMq64ftpU1S7yMsOywLghGPUPtaV1SSFbjiCx8vacmLzVA68hNIuM5kgOJFkNYia2RbmXQZypwMMXaOwPjOBHP76CI/FQR0b4whgOutCFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462752; c=relaxed/simple;
	bh=JXqddSkUOBHb7H278l1xwueJ0DyplxJSDimmOQEXetw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq86InYRRCI3/5x26BK3On9Ecgg86y8yDOoFHK6BMZkGty9i6LkHXQd5hvgiYx8WP5xw1YU02ORuqOX1NzieUDGeLwgFwwnNAjTRNFHZFkqGvBsj8ZhOi/O3II4JHUWLHNDNq0KUs6nUQbV7t3w2NL4HOAo6dWNwry32KT97NWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fych1yyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fych1yyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DCDC433F1;
	Tue, 20 Feb 2024 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462752;
	bh=JXqddSkUOBHb7H278l1xwueJ0DyplxJSDimmOQEXetw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fych1yyrOiXS4cXL6KixikaV5ezVl+cOB5OFpY98lrPc0Dv939liwydMpDod5u+FA
	 Qq9x0eKkyy2NqMCekdo0A7xZgLGlWcWvou/6N4hUlxKt83U4iJVljziFkN0XLJGyf1
	 l0IwtljIf82Hqqau9ar8IHaajfKjyhLAJbwTRmkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/197] net: tls: fix use-after-free with partial reads and async decrypt
Date: Tue, 20 Feb 2024 21:49:44 +0100
Message-ID: <20240220204841.833314773@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 32b55c5ff9103b8508c1e04bfa5a08c64e7a925f ]

tls_decrypt_sg doesn't take a reference on the pages from clear_skb,
so the put_page() in tls_decrypt_done releases them, and we trigger
a use-after-free in process_rx_list when we try to read from the
partially-read skb.

Fixes: fd31f3996af2 ("tls: rx: decrypt into a fresh skb")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ee11932237c0..d651c50746a8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -62,6 +62,7 @@ struct tls_decrypt_ctx {
 	u8 iv[MAX_IV_SIZE];
 	u8 aad[TLS_MAX_AAD_SIZE];
 	u8 tail;
+	bool free_sgout;
 	struct scatterlist sg[];
 };
 
@@ -186,7 +187,6 @@ static void tls_decrypt_done(crypto_completion_data_t *data, int err)
 	struct aead_request *aead_req = crypto_get_completion_data(data);
 	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
 	struct scatterlist *sgout = aead_req->dst;
-	struct scatterlist *sgin = aead_req->src;
 	struct tls_sw_context_rx *ctx;
 	struct tls_decrypt_ctx *dctx;
 	struct tls_context *tls_ctx;
@@ -212,7 +212,7 @@ static void tls_decrypt_done(crypto_completion_data_t *data, int err)
 	}
 
 	/* Free the destination pages if skb was not decrypted inplace */
-	if (sgout != sgin) {
+	if (dctx->free_sgout) {
 		/* Skip the first S/G entry as it points to AAD */
 		for_each_sg(sg_next(sgout), sg, UINT_MAX, pages) {
 			if (!sg)
@@ -1653,6 +1653,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	} else if (out_sg) {
 		memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 	}
+	dctx->free_sgout = !!pages;
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, sgin, sgout, dctx->iv,
-- 
2.43.0



