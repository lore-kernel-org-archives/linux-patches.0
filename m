Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048935;
	b=4xwD0aSN0rI9bgl8x2FUDGbV7g3FI0hh0mRzbZvBFAWDmvX9p4eWX47839zG5+M/0VBD
	 12EPGTpoDdMX/lrYiOxu6ufbafGUzsJuH1gcUptpy26bJbF2te4X4yQSgfiL5B/XcKGRC
	 Lit9ehsZ/JfJXRmad4d48p/BdIsU8P2Tl7KrQHE1jYXAMnhNYCus8maIMNeZs0nQmQQjx
	 WPjK0HQO8fywSCqKdT53qvEXJFocrK1WagSGSyCu48OE0IeWXR89EJWG7cykdnZv3Tzrz
	 zC2X1J3+YOQM5zNB6Dfzo9snCkbRWBkMxyk7JSoI2DLgT1KAWvqG98/bV6Bbipp+lDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZmTMWZMZ8uXmGCemVito1oH09V2TjSW7B4NePpnwZU=;
	b=bl9oXgvqLOz84wxZI3aTeX9rvuu+lBlVp/wpPH37C2GWRnBppVUJGNxny2FLTAwPb0fo
	 EHMtdFYv/k7JSQw+7gWascBxJMNi0Yxr0fy5jV4pu8pK6bKvxtwWVCKhBr4ih1ZlQjdkc
	 x/2UoqQesTeE42sF9APwgcs+VQlePxIxG+RX+tvFJ9iVpSQ/gQ1P47p55ig/XdYSo+JYN
	 M/IWPE7+46y8NAI6vY9BWJ+djfE6rFtkgZNJCjGcKG49ghkT7w21hDHwHFI4vb4op1pfH
	 ygUuYIUbapMTcCKioOxaKX1O/Yv6BOguEvYMZDMGpN8c4zAmdGbVRMcMTU+1Kfa9f3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YWr9Y1UY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB70606A320;
	Thu, 19 Nov 2026 00:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YWr9Y1UY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFF41F000C4;
	Thu, 19 Nov 2026 00:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048935;
	bh=eZmTMWZMZ8uXmGCemVito1oH09V2TjSW7B4NePpnwZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YWr9Y1UYZtVwMAxHN1nTu0oYllrhGCK9OFSGxpBtjHglXfUs+RDzfb31nrqeeumJp
	 ZAglmaEcMlHhNWEw8WTE3Xl5qzDQijttqwn4JKcLIuyay7pcK9kB44odz0uICSp1Qx
	 7i7dbzfORKeWqVZ/sgKH8g8V3c7+NmK9yqrzK8ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2173/2857] crypto: atmel - handle authenc requests without plaintext
Date: Wed, 18 Nov 2026 15:53:27 +0100
Message-ID: <20261118150319.643872323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c6be40e02d7bf..792030a7e16cd 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2029,6 +2029,8 @@ static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
 		dd->is_async = true;
 	if (err)
 		return atmel_aes_complete(dd, err);
+	if (!rctx->textlen)
+		return atmel_aes_authenc_digest(dd);
 
 	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
 	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 2596ec2dd2dbb..ed23389c6eeea 100644
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



