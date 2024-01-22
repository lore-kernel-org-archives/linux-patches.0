Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B635D14901D;
	Tue, 23 Jan 2024 00:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969187; cv=none; b=taNwqbZWIcZbncDVHjpJFMOnmc+cciJ36F6Am/iV8imrByCCLo/kwsqgB3KFFfNUkm1UmOmrjD3sVN4jvVlTmb8e1xJ3lXW8Im76OleWf52UsD02DSreaG+XAV34YmBx3hHW+nUes8FI/EvLGvFTnJBpbdffUnMxeYy6KFJMiDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969187; c=relaxed/simple;
	bh=m343+3DhgM0X0cM5H1ma0syOfQhx0aJHz8NGvxu6OO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeyEr26JhN0nrskT5cywkcZu3X8VYLLPf/Fh+pPU5BsNy4pbrp8iiMSoBe6l1gMWyDqg0KQ5nDymAiVlNY5RX2j3wyjJt4ULXaOMjoS23ysGefp6qpgBqNckpdKHScqgQJ1js6jxcNZFA7ihKJ/ISfwu/ayaB9UDSWEgsFyCCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTRooFbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTRooFbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6FBC43399;
	Tue, 23 Jan 2024 00:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969187;
	bh=m343+3DhgM0X0cM5H1ma0syOfQhx0aJHz8NGvxu6OO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTRooFbKYC7Li7DYw/Zp0ZyIJYvmP8rQrQPAfnszlRmW5gPhvOiHfXwlwkZxD/pno
	 y8gt0DAmPEmeIWqnEK+Nv1kqfqeEKiSeAy4tUIpbI89HntmY+3AoT/3eoUrmMwJYLg
	 EAWzODztt4WP62VQrM4a3mPCCWTvHPsmA2FQC8zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 061/641] crypto: sahara - fix error handling in sahara_hw_descriptor_create()
Date: Mon, 22 Jan 2024 15:49:25 -0800
Message-ID: <20240122235819.972102515@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit ee6e6f0a7f5b39d50a5ef5fcc006f4f693db18a7 ]

Do not call dma_unmap_sg() for scatterlists that were not mapped
successfully.

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index cbb7153e4162..c4eb66d2e08d 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -483,13 +483,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 			 DMA_TO_DEVICE);
 	if (!ret) {
 		dev_err(dev->device, "couldn't map in sg\n");
-		goto unmap_in;
+		return -EINVAL;
 	}
+
 	ret = dma_map_sg(dev->device, dev->out_sg, dev->nb_out_sg,
 			 DMA_FROM_DEVICE);
 	if (!ret) {
 		dev_err(dev->device, "couldn't map out sg\n");
-		goto unmap_out;
+		goto unmap_in;
 	}
 
 	/* Create input links */
@@ -537,9 +538,6 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 
 	return 0;
 
-unmap_out:
-	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_FROM_DEVICE);
 unmap_in:
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
-- 
2.43.0



