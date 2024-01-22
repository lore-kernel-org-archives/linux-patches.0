Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017354BD2;
	Tue, 23 Jan 2024 00:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970608; cv=none; b=TSET9aQD+IDDTzETI55VANTXvUliA0GSswcI5JxZsqHOW/RDKMlUDinuQBMT5JlWgqqaEKEiLdEap7OLxKiFGEokyQ7SiCySy0o2DMmirpgcUiMg3Cq0+vU8oPQODRQ/UfhQtkWdCcdYYbs4fytGMgVlJEtsbfoGar7ki7wGa98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970608; c=relaxed/simple;
	bh=G3BiIG52XVO5siNsVfY/WTlXx19nVFk35PVipeWs+50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITJbGvgmpf6ue7xaRAQ3i4+SJ+sYheiNXZ7Y0x4PnabF1wGot5sy4JILyOMAkMYe98Ia86mRuhcKWGImj8dCjzBxnV4s4c9Uk7zGoZjRo5VzlOhRpbI+3+famQtbOtXR/pR13NlaDjiJIdgJLXg7/MTeg8iAGG8Pr6m76Tn4EEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CroVjhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CroVjhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6C5C433F1;
	Tue, 23 Jan 2024 00:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970608;
	bh=G3BiIG52XVO5siNsVfY/WTlXx19nVFk35PVipeWs+50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CroVjhkOf4LoTIfNJ7nbOJ46gcgCRylaiS7wa7+4sCVjMMLY7me8JCjeRPxMtxtG
	 Hz2sXJtJZFw/V9O0c36BOWkqnXqCokGcj9Qr5b4MA8SmX0eyWWuwDw9z4Xy7hzv9JP
	 LRU4x6AA1bFPwqMhtaBAInGHDf4V1R6HDC07ULNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/417] crypto: sahara - fix wait_for_completion_timeout() error handling
Date: Mon, 22 Jan 2024 15:53:46 -0800
Message-ID: <20240122235753.715796088@linuxfoundation.org>
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

[ Upstream commit 2dba8e1d1a7957dcbe7888846268538847b471d1 ]

The sg lists are not unmapped in case of timeout errors. Fix this.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 6e87b108df19..e2b1880ddeb0 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -608,16 +608,17 @@ static int sahara_aes_process(struct skcipher_request *req)
 
 	timeout = wait_for_completion_timeout(&dev->dma_completion,
 				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
-	if (!timeout) {
-		dev_err(dev->device, "AES timeout\n");
-		return -ETIMEDOUT;
-	}
 
 	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
 		DMA_FROM_DEVICE);
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
 
+	if (!timeout) {
+		dev_err(dev->device, "AES timeout\n");
+		return -ETIMEDOUT;
+	}
+
 	if ((dev->flags & FLAGS_CBC) && req->iv)
 		sahara_aes_cbc_update_iv(req);
 
@@ -1008,15 +1009,16 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	timeout = wait_for_completion_timeout(&dev->dma_completion,
 				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
-	if (!timeout) {
-		dev_err(dev->device, "SHA timeout\n");
-		return -ETIMEDOUT;
-	}
 
 	if (rctx->sg_in_idx)
 		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 			     DMA_TO_DEVICE);
 
+	if (!timeout) {
+		dev_err(dev->device, "SHA timeout\n");
+		return -ETIMEDOUT;
+	}
+
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
 	if (req->result && rctx->last)
-- 
2.43.0



