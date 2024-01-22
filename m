Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682933984D;
	Tue, 23 Jan 2024 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970514; cv=none; b=nYwMQB/PyLeLMPMJkUqR9SE72ZRhc0d5Av2QEla7puZOqbJy/Z8zn44qiZAv7rg8Ibl+VnvEMNCbeSggI0otBoQJSUz11qRfRKJN5DWYfybm/T52beRiQebDyPOFmROT9RJhR9Gu0QnWgaDGQ4eLlBjlhmoFsX8lTUMTmoddlnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970514; c=relaxed/simple;
	bh=nNh6/8KZNYPnJY6hZ0Wy2phbydG3/vI+Iak0J2kJl+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF7PbpzOlxy6EK9HFUiQ7ugmSEyZzTelyTkMxaZl70ydBB5c9vRdc5SwMIs2Ykn7zcfKak2Ex2eCXDKkDzpCA6R8uZKQhM6i5SybL/Qe50gbdrpj+ZIWfFMctbpy8vUKq/KGx+L+btgD+FVC7JxNVlDSOsa6Mi4xX7LQJIZly0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyUutT7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyUutT7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E271AC433C7;
	Tue, 23 Jan 2024 00:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970514;
	bh=nNh6/8KZNYPnJY6hZ0Wy2phbydG3/vI+Iak0J2kJl+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyUutT7YQLq1zTcxK0dW087zNmaoi9qMI+0RY2d/NKpBszOBK1uRNeGd4aTcrRknZ
	 AK5ZEbz5DhhMrxTVaufUQ+qGZ++EsSLZy9KNJdcv6BS90Aak8x30lu+YwSsVGrnoSX
	 1rUvR1BAlX3ksT0IvA4Z/Id3PWbAaK5aE9MAlH1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/417] crypto: sahara - fix cbc selftest failure
Date: Mon, 22 Jan 2024 15:53:28 -0800
Message-ID: <20240122235753.024968207@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 0e30d36b0a71..aa9c45ff0f5a 100644
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



