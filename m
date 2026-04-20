Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9D336896;
	Mon, 20 Apr 2026 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700338; cv=none; b=XI4Aw6OzVPZCA8rar3OyYzNxn3BqcwKPThKItSKla3kq++9F3rBBOC+w/YHVl4Y+o6trKOyqqUHZy+cxM4r65ZjvUq7jsaKAd9Blshgw0zfuVTF3JNS4gHBgqbwtY/SbMNRE52jBYOPsvmpWmwtYt6fPRtcjkg8mqH0SesMKQKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700338; c=relaxed/simple;
	bh=WjKyQQSgsnL/A2og7uvbod8ElFu4RMc7q4YyxMndFJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsqU9upod0MIbLAU5sHcM8ibWqn2xxn/NabN5hoBDnTqgNgm2klqmoOoG/GS86eGhJ0XgAnANnjhxMemjTgt6m2AGiEcwn3qe3+7b973JYJZHXKir5PRjO5FAAtVv0Bs+kznWc48wFN2qPJ1i+apfP+tCtuxdzvEDKf0Ta2DBKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjioCF75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjioCF75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC470C19425;
	Mon, 20 Apr 2026 15:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700338;
	bh=WjKyQQSgsnL/A2og7uvbod8ElFu4RMc7q4YyxMndFJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjioCF75CW2wux/ydOb+rhTnot5ajx55GhnD6eBw4BBvWnJFWa3uey1YKNFHIGgm6
	 n1kJODlTxfqyi9PceVs6Zq6jv8ACwxadfaSskk2dpQbT+jH3etXa9HYG7AfH/1FXSa
	 IZvq5fINSfR32MVE1O8P9cDgUxHh+Ucxp5xjVtjM=
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
Subject: [PATCH 6.19 133/220] crypto: af_alg - limit RX SG extraction by receive buffer budget
Date: Mon, 20 Apr 2026 17:41:14 +0200
Message-ID: <20260420153938.816129289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 crypto/algif_skcipher.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index bc78c915eabc4..7373f7dd8f417 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1229,6 +1229,8 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 
 		seglen = min_t(size_t, (maxsize - len),
 			       msg_data_left(msg));
+		/* Never pin more pages than the remaining RX accounting budget. */
+		seglen = min_t(size_t, seglen, af_alg_rcvbuf(sk));
 
 		if (list_empty(&areq->rsgl_list)) {
 			rsgl = &areq->first_rsgl;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 82735e51be108..ba0a17fd95aca 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -130,6 +130,11 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
+		if (len < bs) {
+			err = -EINVAL;
+			goto free;
+		}
+
 		len -= len % bs;
 		cflags |= CRYPTO_SKCIPHER_REQ_NOTFINAL;
 	}
-- 
2.53.0



