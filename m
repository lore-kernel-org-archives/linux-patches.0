Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA137C;
	Tue, 23 Jan 2024 01:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972173; cv=none; b=JZR943ApM2/DzcVgt/jsV0hRuJWknRQYNYvylVxkrlwhQusaNvQkK99As1MfRUtNhxXpKr7b7bgwPvYkQHKbkLHh9H+RzrtrmdLYI1xsyi+ZwsyayaeYittfuq9PcFwYmX0mxCmRrGfAXXg/0ZeN/jJ1hCjlyEKvkaqLzTDc4Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972173; c=relaxed/simple;
	bh=W8wmht3V9dMWnPczh0LLvSUzlLk2yZ1VsvjSgP3X4vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP/KZvePe/ipFdVYCACuHes/ssC3HKaYmIiOqCKyi9a/i7wkAOIozKuEbO47uG1S3kFA5bUOrBe9Gd+I94jvVo4fjATbuaRRpBBJBqZyYrM7wIUGIr4OcSUV8edx8g2wO7XVscAGGbHAUkjcHBEZjZBscHo/pF7mr8EKR32nkCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoqOQSz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoqOQSz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7014BC433C7;
	Tue, 23 Jan 2024 01:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972173;
	bh=W8wmht3V9dMWnPczh0LLvSUzlLk2yZ1VsvjSgP3X4vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoqOQSz8SuZAZa6qP4NLTK+iOSlJqzSkksvSaEQlvTWDFblj4zVds2m2O6s3L/Rsx
	 porKGa0mIpfz17C/VMap6WaRuuJYMlTydMcu+1iQHUetPcZb0t81oA9MWCFqFJkZg1
	 L5CLf6kQzjshi3exdoHo6bEJFA/+gAZodu5Rhodg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/374] crypto: sahara - fix cbc selftest failure
Date: Mon, 22 Jan 2024 15:55:55 -0800
Message-ID: <20240122235748.039652603@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 9f10bc28c0fb676ae58aa3bfa358db8f5de124bb ]

The kernel crypto API requires that all CBC implementations update the IV
buffer to contain the last ciphertext block.

This fixes the following cbc selftest error:
alg: skcipher: sahara-cbc-aes encryption test failed (wrong output IV) on
test vector 0, cfg="in-place (one sglist)"

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 84a7c4de537a..1f41c8eeb8fc 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -149,6 +149,7 @@ struct sahara_ctx {
 
 struct sahara_aes_reqctx {
 	unsigned long mode;
+	u8 iv_out[AES_BLOCK_SIZE];
 	struct skcipher_request fallback_req;	// keep at the end
 };
 
@@ -542,8 +543,24 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	return -EINVAL;
 }
 
+static void sahara_aes_cbc_update_iv(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	/* Update IV buffer to contain the last ciphertext block */
+	if (rctx->mode & FLAGS_ENCRYPT) {
+		sg_pcopy_to_buffer(req->dst, sg_nents(req->dst), req->iv,
+				   ivsize, req->cryptlen - ivsize);
+	} else {
+		memcpy(req->iv, rctx->iv_out, ivsize);
+	}
+}
+
 static int sahara_aes_process(struct skcipher_request *req)
 {
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct sahara_dev *dev = dev_ptr;
 	struct sahara_ctx *ctx;
 	struct sahara_aes_reqctx *rctx;
@@ -565,8 +582,17 @@ static int sahara_aes_process(struct skcipher_request *req)
 	rctx->mode &= FLAGS_MODE_MASK;
 	dev->flags = (dev->flags & ~FLAGS_MODE_MASK) | rctx->mode;
 
-	if ((dev->flags & FLAGS_CBC) && req->iv)
-		memcpy(dev->iv_base, req->iv, AES_KEYSIZE_128);
+	if ((dev->flags & FLAGS_CBC) && req->iv) {
+		unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+		memcpy(dev->iv_base, req->iv, ivsize);
+
+		if (!(dev->flags & FLAGS_ENCRYPT)) {
+			sg_pcopy_to_buffer(req->src, sg_nents(req->src),
+					   rctx->iv_out, ivsize,
+					   req->cryptlen - ivsize);
+		}
+	}
 
 	/* assign new context to device */
 	dev->ctx = ctx;
@@ -589,6 +615,9 @@ static int sahara_aes_process(struct skcipher_request *req)
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
 
+	if ((dev->flags & FLAGS_CBC) && req->iv)
+		sahara_aes_cbc_update_iv(req);
+
 	return 0;
 }
 
-- 
2.43.0



