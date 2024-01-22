Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5B3D7A;
	Tue, 23 Jan 2024 00:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968244; cv=none; b=G1t2yTMSm7eWlD9ogoiWncYThMwgq+1MWMRCdb29wasXY803bnrYLA0fnGyGpMUeVUmogjKz9OVjrnr/uvm4xMzls9vQaqV40KCbZLZn04oaQvOUV96nB+wh+SXnXZm8awRH5phBc55al+py6pgkWFmAdOwerpHqNDB/vIVaY/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968244; c=relaxed/simple;
	bh=WH9MsZWF+eJoEoqtxP1dCpMpQVxCsd+gbd0hD0UlZP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaCpSoX4Ifn69pOMqywCzOGWTLDKJ/9ffiVjhKtPCthu9FB1dt0F+S1tj/GBtjbspcze46JmAteZUbIpdT0B8HHblvqkdWf7lIm5YerEphCO+pw6jpz7IpTV5+kjeRFSY1Nt4QKnB01Jq9cODLehTjPqAPpHN1ZYX/j68/bFL2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeMD4qEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeMD4qEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142C0C433C7;
	Tue, 23 Jan 2024 00:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968244;
	bh=WH9MsZWF+eJoEoqtxP1dCpMpQVxCsd+gbd0hD0UlZP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeMD4qEyojD57m2kYgRsolqqeF9zgO9Izq4PZu7WOVMa3tfmEzz3cnRku+1yOTAp/
	 DWRWpJ63jehTKT7iIG0Fx5Z61p5IJH7XfSt5x3pMjwTB8hv2XH1Bf/osOFhftUA22N
	 29VeI85HKt3d0ukvvQjL/4ExGKr6SyOhhzmtk1jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/148] crypto: sahara - fix wait_for_completion_timeout() error handling
Date: Mon, 22 Jan 2024 15:56:51 -0800
Message-ID: <20240122235714.640359941@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a9359b0ed045..96cb77abbabb 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -583,16 +583,17 @@ static int sahara_aes_process(struct ablkcipher_request *req)
 
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
 	return 0;
 }
 
@@ -1027,15 +1028,16 @@ static int sahara_sha_process(struct ahash_request *req)
 
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



