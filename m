Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F96634F8;
	Tue, 23 Jan 2024 00:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971274; cv=none; b=L55pBTWFjXJFVHNeiSF47axWQu5er0LHafibrXR1KSoTdI+vgG2PJaBQP2TKNr//uB/98t706Hrttb8KNEa8pQHtn/dHGwZJtG+aitRkNQIdpqdvrd2L/c8Ql4USumaRth0oLQprk7OWQJkLq3PaPXd4YWcRTaKG3nGtvdjIulc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971274; c=relaxed/simple;
	bh=KN08VdIYh9MVXEY/7gcCxxx9MkUhI0jKCVATYPJBgxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgvaGq70834x8/eeP/+GasFKMcdG2xS5ToHrD5gZYCKjZSfX38U6dy+/uk+ws5rTkNQebhmtP7D5e6esIVoHiMY5QpKzFWXFwSBukT3Xky/rSuUTgRIgxLuKi7Vo/uUpGZgMKnyOSoC7aeUA9VOKMHPscWqtup0i61TRNaXF/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSPTS7RU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSPTS7RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC516C433F1;
	Tue, 23 Jan 2024 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971274;
	bh=KN08VdIYh9MVXEY/7gcCxxx9MkUhI0jKCVATYPJBgxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSPTS7RUACqFR1gDaQXRYAOVt+2hn6Zq2qWkMqdzEq9YG0ZJVFFXKKIQz0uOkXBEJ
	 ic6bGWn454NEW2c0q2+RnIgEaCLd2rwFOzrcy2H9BW7IKvTiX1fAtZG/+Ch9sULVse
	 AQImkoQ/9RILSknDaSLfbjscgkef6fWqDBTnj2s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/286] crypto: sahara - fix wait_for_completion_timeout() error handling
Date: Mon, 22 Jan 2024 15:56:47 -0800
Message-ID: <20240122235735.962486698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a97b1dadf6a4..67960acd786a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -607,16 +607,17 @@ static int sahara_aes_process(struct skcipher_request *req)
 
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
 
@@ -1007,15 +1008,16 @@ static int sahara_sha_process(struct ahash_request *req)
 
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



