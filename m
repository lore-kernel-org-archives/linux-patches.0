Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853A242640B;
	Mon, 31 Aug 2026 13:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184098; cv=none; b=bSv1lXZl896emFKIKVeg1Nsvz3xJSFhK8B7Qr6vTlFfgKUxRjYIt4KdR0ZBPNjbjShDVqmrKlHRWImZabEeGG6o2UHAsX7ty5fCUDfjUn88lF1UfqmgMxZXCBTayNXwn/Ho5DWzUE13BzgQ5zbMK3udQcUQFUrgGH05kCeCMpz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184098; c=relaxed/simple;
	bh=2AVYrpBcMIgRdub7a8Z7bpCNI6odCrKgQQc7O3+PYpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjwDgDnYb/Lr3reqSmHPFmtCrdVt+GtVh9CAyiUIZsz25pukuUTof7iTa2SgTjrQ0Fd8iu6bePq3EpN0Yi79kIyNGX+piF3JTauYAMzLWhiXM8pv5najG9o6OiIy0x8796E9k0J1pVAiDuy2BIq8TKOijlW3+iryNUGIKoRgLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtmjMyc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtmjMyc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D141F00ACA;
	Mon, 31 Aug 2026 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184096;
	bh=BK2wmyE8cS3t8EwloHW6tDzH8Iju5hCJwmAHYA0Ep5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtmjMyc9vcEW2bLVmzaqL7q/etg7oO3Bsr9Akiw0W8wcGRlhj23DWcL+DUgQqV/9H
	 pgScQHjP4eABL1yyhrMIudTsDFlxvLK4LxKZ+1lPH8NTog8gQZzKljv5/ecKRUYXDX
	 iAhFxc5R+EYoPJ1GidBsViDSyswYMd35QPrgyKHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Sadre Alam <md.alam@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 71/83] crypto: qce - fix CCM AAD buffer underallocation
Date: Mon, 31 Aug 2026 15:34:47 +0200
Message-ID: <20260831133403.095056373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


