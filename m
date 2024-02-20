Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5676C9C;
	Tue, 20 Feb 2024 21:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463441; cv=none; b=BsdXUqy1dfnZg6gS+Hg3CxUkBPNCSlK7g3wEmcUoT8bCgj1NeFUpwoNrbmKBaGktm+7HWZts1jSJKxcH7h/t1khFJ/5pvCsrm4fHmRroSWZRPWfmZatGrur5BVIPcLcTmPxe1IUxAZw8gGWwagz5o/QmRJrLhiwi5sTjuYXxhEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463441; c=relaxed/simple;
	bh=h4qldOsU8rgMcmufj72MBxNuxfRjlvjEqmft738DEIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEl9QORmLNPmITknlLoVj0izSRw9De3kEcxk7O/Gwk360mFjzsnHQrx6B7q3q5JGS6peDLFdBS3Isym69y0GqZekgSS7exfq+kqmHaNiu8KOLQGu1BC5WzAJX1nj6mxqF9o0g/3E9aTuCUDG/E2okcPgT7I8VN5H8vbe2lT+YRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oy5hLYcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oy5hLYcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79140C43390;
	Tue, 20 Feb 2024 21:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463441;
	bh=h4qldOsU8rgMcmufj72MBxNuxfRjlvjEqmft738DEIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy5hLYcua2+TVRXsji0gxr18E24HABsW2SB0J8P+pZi9WvmnFUTXijmdOp/m1hOb6
	 XYLrJ03YwPjkA5qkul6ThFwHtxJwI3XXLN2FDE+ev7vxyDwh6iuHZo0Z8rFGkRYMUd
	 024uI0t5+dBu3EmpVt3OEhvec2yeG17c9Zo6mEfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/331] net: tls: fix use-after-free with partial reads and async decrypt
Date: Tue, 20 Feb 2024 21:52:40 +0100
Message-ID: <20240220205638.993712405@linuxfoundation.org>
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
index c32fce6f3563..2af8b0873da6 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -63,6 +63,7 @@ struct tls_decrypt_ctx {
 	u8 iv[MAX_IV_SIZE];
 	u8 aad[TLS_MAX_AAD_SIZE];
 	u8 tail;
+	bool free_sgout;
 	struct scatterlist sg[];
 };
 
@@ -187,7 +188,6 @@ static void tls_decrypt_done(void *data, int err)
 	struct aead_request *aead_req = data;
 	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
 	struct scatterlist *sgout = aead_req->dst;
-	struct scatterlist *sgin = aead_req->src;
 	struct tls_sw_context_rx *ctx;
 	struct tls_decrypt_ctx *dctx;
 	struct tls_context *tls_ctx;
@@ -224,7 +224,7 @@ static void tls_decrypt_done(void *data, int err)
 	}
 
 	/* Free the destination pages if skb was not decrypted inplace */
-	if (sgout != sgin) {
+	if (dctx->free_sgout) {
 		/* Skip the first S/G entry as it points to AAD */
 		for_each_sg(sg_next(sgout), sg, UINT_MAX, pages) {
 			if (!sg)
@@ -1583,6 +1583,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	} else if (out_sg) {
 		memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 	}
+	dctx->free_sgout = !!pages;
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, sgin, sgout, dctx->iv,
-- 
2.43.0



