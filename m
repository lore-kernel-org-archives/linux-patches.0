Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F004BD0F4;
	Mon, 31 Aug 2026 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184913; cv=none; b=F/nJtAeaPZEHBC2yp7GnrUCzcReZDPZIHy/hopyTcQzH4lICoYlMr2w2bsPPuCg8xg6uTBa4CjsGHpSpNIb7CG5bAIVVWWwZU1BXc+OBSQmue2Aav4UwyEyl3JZAzAEU3aQJmUoVRbu/t+Zhh4Msn2IXJ9mlavxzsyus8TSaumQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184913; c=relaxed/simple;
	bh=Pnp1ybZZaeyy5Q2zjf5ikT5dYuub3KEKaWxrpCYNwjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTdW154FpS9kNopU4aQVqBMK+wNu7PxO7v3kM3s7uohQcFSVQU1RQsgZFxM6hRUkC2UCanBVgWGycZKsgv9hwc+vm7woSjFpW1LiuyVjZt39NkAkk0wIPFpZgI/B02V76KtzW4ZH5JFb8Fw8xCQODuowmSSZv801AWglUUQNErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L92VvchJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L92VvchJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D361F00A3D;
	Mon, 31 Aug 2026 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184911;
	bh=kyCoe7kr0IHMKRi/TQ+T5H18LTaZH02w4UcUAr65bzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L92VvchJ8XkykEeoL09AZiIWyJd8BgYwTrQLyPJQUnYVzAnzVY0sdeSNBNXyCrjvH
	 pM/HN4ssZv/X2zcqrtX8tHuL1rgEUke1MQ6IbWL/318YPoVm5MKunY3YEAy1UKVLEn
	 8/wxHTH+XzTckYnQg/6Jld3z4GLA0gypxO5+ob/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Sadre Alam <md.alam@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 80/92] crypto: qce - fix CCM AAD buffer underallocation
Date: Mon, 31 Aug 2026 15:35:18 +0200
Message-ID: <20260831133403.692434242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Md Sadre Alam <md.alam@oss.qualcomm.com>

commit 7f2345f47dd189625f657cd72437179ab4170ee1 upstream.

The AAD buffer allocated in qce_aead_ccm_prepare_buf_assoclen()
can be smaller than the length later programmed into the DMA
scatterlist.

The allocation size is currently calculated as:

  ALIGN(assoclen, 16) + MAX_CCM_ADATA_HEADER_LEN

while the DMA length is set to:

  ALIGN(assoclen + adata_header_len, 16)

Since ALIGN() does not distribute over addition, the allocation
can be smaller than the DMA length. For example, when
assoclen = 32 and adata_header_len = 2:

  allocation = ALIGN(32, 16) + 6 = 38
  DMA length = ALIGN(32 + 2, 16) = 48

As a result, the QCE hardware can read beyond the allocated
buffer while computing the CBC-MAC over the associated data.
The extra bytes are folded into the authentication tag,
resulting in an incorrect tag and causing CCM self-test
failures such as:

  alg: aead: ccm-aes-qce encryption test failed (wrong result)
  on test vector 8

Fix the allocation by adding the maximum possible AAD header
length before alignment:

  ALIGN(assoclen + MAX_CCM_ADATA_HEADER_LEN, 16)

This guarantees that the allocated buffer is large enough
for the fully padded AAD data for all supported header sizes.

Cc: stable@vger.kernel.org
Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Signed-off-by: Md Sadre Alam <md.alam@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/aead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -203,7 +203,7 @@ qce_aead_ccm_prepare_buf_assoclen(struct
 	/* Get the msg */
 	msg_sg = scatterwalk_ffwd(__sg, req->src, req->assoclen);
 
-	rctx->adata = kzalloc((ALIGN(assoclen, 16) + MAX_CCM_ADATA_HEADER_LEN) *
+	rctx->adata = kzalloc(ALIGN(assoclen + MAX_CCM_ADATA_HEADER_LEN, 16) *
 			       sizeof(unsigned char), GFP_ATOMIC);
 	if (!rctx->adata)
 		return -ENOMEM;


