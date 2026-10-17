Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960E338F233;
	Sat, 17 Oct 2026 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258573; cv=none; b=t9xSPyA+Zo9CqXRAFhuGoQK5rAynZ0gvOSTVDJPfFQ1brtDuhNBr4OJZn53dERFRwMdn5/zj1o7mVgOP+3LzckXA8nriB3ihqe7vD2T2Qskr5r1Li/YEBT6hb52LWLw20J0B7uOIvBixBAvhu9tUcVCt9PfJbNxfYveVcevEmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258573; c=relaxed/simple;
	bh=fc8MNgc4e4PM3X5Lad5qA7dzKQXupKFOk8AUdANDHBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP7mfhcRE6YOn8usKBpyFfGQijreCNjyCwxmUKXWnyHwyMW9efhIY1i5ptr3ChR91RISMlOEgYJtFzkvSBeIThvK4r2/juULUtvhxrblSfoCqXons5DRJj7mjr2CYdGe2vldvru/8nZZsVQy1TIchf3wO6FzTZpXo94uwlsYrss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6fcLwF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6fcLwF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0D41F000C4;
	Sat, 17 Oct 2026 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258572;
	bh=hmSdZiLxQVV8y+Sj4aTmnjOuKYXhDXxie0bmUw0eLA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6fcLwF11qxaj/BlnuZ0BGN62Ca8H9EUSA/DTxUx/atV/N+M3VPcSANzap0UyGHms
	 TUzvhGlkxi73jGuGRJMFT+CAxnoau0ExECFrLIIIFcQnFdtva0768nzgkzTqhzbtbj
	 YUc+geitqG7x2v2QaqAqvwSf+WXKjqls/mFPhSWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0888/1674] crypto: af_alg - limit RX SG extraction by receive buffer budget
Date: Sat, 17 Oct 2026 17:52:40 +0200
Message-ID: <20261017160453.911465417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Douya Le <ldy3087146292@gmail.com>

[ Upstream commit 8eceab19eba9dcbfd2a0daec72e1bf48aa100170 ]

Make af_alg_get_rsgl() limit each RX scatterlist extraction to the
remaining receive buffer budget.

af_alg_get_rsgl() currently uses af_alg_readable() only as a gate
before extracting data into the RX scatterlist. Limit each extraction
to the remaining af_alg_rcvbuf(sk) budget so that receive-side
accounting matches the amount of data attached to the request.

If skcipher cannot obtain enough RX space for at least one chunk while
more data remains to be processed, reject the recvmsg call instead of
rounding the request length down to zero.

Fixes: e870456d8e7c8d57c059ea479b5aadbb55ff4c3a ("crypto: algif_skcipher - overhaul memory management")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c         | 2 ++
 crypto/algif_skcipher.c | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index e7fea668473d9..e6e94b34e0afe 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1207,6 +1207,8 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 
 		seglen = min_t(size_t, (maxsize - len),
 			       msg_data_left(msg));
+		/* Never pin more pages than the remaining RX accounting budget. */
+		seglen = min_t(size_t, seglen, af_alg_rcvbuf(sk));
 
 		if (list_empty(&areq->rsgl_list)) {
 			rsgl = &areq->first_rsgl;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index b12df4544d0bb..8729ef268d9d8 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -82,8 +82,14 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * If more buffers are to be expected to be processed, process only
 	 * full block size buffers.
 	 */
-	if (ctx->more || len < ctx->used)
+	if (ctx->more || len < ctx->used) {
+		if (len < bs) {
+			err = -EINVAL;
+			goto free;
+		}
+
 		len -= len % bs;
+	}
 
 	/*
 	 * Create a per request TX SGL for this request which tracks the
-- 
2.53.0



