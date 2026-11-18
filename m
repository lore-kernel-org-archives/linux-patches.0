Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061083;
	b=W81dZAn/j4SJLU4W8flps1jkI2FLkykxRPgeDK4Fg6PKwdK9wo3x40mcWPt1IGbjliQX
	 cn18uFq9i782ndXKDje1dNMpXbenqqv0mXZN19TCNypmEcoRV7+FwZAnojWW6EwxHMa2m
	 SglJjX+wB7C32H/FF27o0qZZ3CwUtdQi5utDGC/947g5UJd7iGcMwytkRIIZeFf+hoKY1
	 DjdXKSKsicnmtV1fl/i0BJIEKzYpYVD9SxZQg5GR1SR/vara0PEhYQ4Ncumr2MKpD9HbI
	 rAsUFWHYADkpaWtXXVJrEfOMCRu+oDcCUYo+zmVX3kxc36vZ0cOvBdH35SO6MSZI0Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGtpv+DUplLPx0UqwL8vn1yHwyv7H9tfqkafldS0ShY=;
	b=tIVIb7qt8f60KyJXfxQ5z/P3YGczYChP18HgTR12iZQ1cYCh9Ab9U+jbS6YbeeiEAqwi
	 Nd0YY3K3qrf0i3e3DeK6YY6sFCbmQl7Dx9TvgduzAZYfN5yRQuAK54AxQIJCNN1gn9oUJ
	 hkK1f9fRGvg5JhDrGP3G4zNYO9TeQRS/hQd0oA9izmb/vTYyus8ZaWU5Iu9+VMbSWVD5P
	 dLI6/8eLOUHXTa5mvp5HiLv2HJo/j8JGq99EMLw5Lvl/jhyRS69lKGC3QmgmjlAhK3VrA
	 kW95XXdv/P6pBJvsZR7CwXVz/YwANIs4FzX5Vcgi7pYSWp0B9781Rq8cgvuv9LLuK2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2CNIOmj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E55B606A320;
	Thu, 19 Nov 2026 04:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2CNIOmj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0C61F000C5;
	Thu, 19 Nov 2026 04:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061083;
	bh=qGtpv+DUplLPx0UqwL8vn1yHwyv7H9tfqkafldS0ShY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2CNIOmjrhED/Gu45zDHOmmxlOHEUHxP7a61xakOowpR0QDzK7qwfW4k1o65GdLMi
	 fM0smzrXZTSeErJNzJ/gn/y1JjZ0u7f1V1SC4Xyx8mwC3u3tq20nKnRupRE6S3gSrY
	 4Toy/S4ieWhBTQmuAQEqZedd6ZDF/czaeaMU4Tsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1428/1848] crypto: atmel - handle authenc requests without plaintext
Date: Wed, 18 Nov 2026 15:57:46 +0100
Message-ID: <20261118150019.322316523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ccbd95b3efbc0580b6abde2a905823417ca56022 ]

Authenc permits a nonempty associated-data string with no plaintext.  The
Atmel driver accepts such a request, has SHA process the associated data,
and then unconditionally asks AES DMA to transfer zero bytes.  The Atmel
DMA engines reject the zero-length descriptor, so the valid request fails,
normally with -ENOMEM.

Skip the AES transfer when textlen is zero and proceed directly to SHA
finalization.

Once an HMAC transform has cached its inner and outer states, SHA can
complete this path synchronously.  The forced ahash completion callback
then invokes the AES finalizer through a void function and discards its
return value.  This loses -EBADMSG for a mismatched tag and reports
successful decryption.

For synchronous SHA completion, release the SHA device without invoking
the ahash callback and call the AES finalizer directly.  Its result then
propagates through the synchronous call chain.  Keep the existing callback
path for asynchronous completion.

On a SAM9X75, the unpatched driver failed valid AAD-only requests and
returned success for a bad tag after the transform had been used once. With
this change, bad tags return -EBADMSG for both fresh and reused transforms.

Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c |  2 ++
 drivers/crypto/atmel-sha.c | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 8f69245660a6d..3c4a5c93417c8 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1966,6 +1966,8 @@ static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
 		dd->is_async = true;
 	if (err)
 		return atmel_aes_complete(dd, err);
+	if (!rctx->textlen)
+		return atmel_aes_authenc_digest(dd);
 
 	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
 	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index df2c1a3d5bc2a..f69b770b80980 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2369,11 +2369,25 @@ static int atmel_sha_authenc_final_done(struct atmel_sha_dev *dd)
 {
 	struct ahash_request *req = dd->req;
 	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	atmel_aes_authenc_fn_t cb;
+	struct atmel_aes_dev *aes_dev;
 	size_t i, num_words = authctx->digestlen / sizeof(u32);
 
 	for (i = 0; i < num_words; ++i)
 		authctx->digest[i] = atmel_sha_read(dd, SHA_REG_DIGEST(i));
 
+	if (!dd->is_async) {
+		/*
+		 * Return the AES finalizer's status directly for synchronous requests.
+		 * The ahash callback cannot propagate it.
+		 */
+		cb = authctx->cb;
+		aes_dev = authctx->aes_dev;
+		dd->force_complete = false;
+		(void)atmel_sha_complete(dd, 0);
+		return cb(aes_dev, 0, false);
+	}
+
 	return atmel_sha_complete(dd, 0);
 }
 
-- 
2.53.0



