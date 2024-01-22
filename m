Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF5856773;
	Tue, 23 Jan 2024 00:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970526; cv=none; b=hFNKyTP+M2jZ4xfCc5k7jeErLqHaJ4h75JTB10dNySLjvUf065eRmDwgEXRAL3w6LTig2GXFP+ukndPEqv1G/MCvcWzFsMZ5JGdRcHRgDp92uiqgZ7XUKh+eIGR5fetMX9Ukrpr4dchoZm9mkwCS7pQknoQwGZPbUxASw2E795A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970526; c=relaxed/simple;
	bh=8znq1RDz5wcuFpGNo49SGyiEIEaa7vmDk408a9/JLo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGwz0tq3hfkWvwMvcPXmqC9aLRchiBJyZP4Y4vmQOjT44WYsH2u1GPfy9HL2QFSf8fjWFQmx0T7O/kcgL2r/h1/M8EslWNlpweoiU1yCQI29aBxQVH0kSFVfRgv9SjhrDx6uy5SgdMck6IfHWKu0aPA+RpWKZfs0Q1ELbUK0YK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQ0hN65t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQ0hN65t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DC1C43390;
	Tue, 23 Jan 2024 00:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970526;
	bh=8znq1RDz5wcuFpGNo49SGyiEIEaa7vmDk408a9/JLo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQ0hN65t9zGmHnb9E0pA4ZoaJ2bLg/3S1ZJQ7Hz0UWUP6tZdSLYLD6hRrzB1tVylf
	 W9SosiBGRmqwfo+gpmi+sgiSFyRxGXhzNhdmqxiBvorXIDiws5iE35naqUoA+VvEWm
	 +r/szl/tRxgRrLeiYiDVwjG3R4Eoil4YI17eYw3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/417] crypto: sahara - fix error handling in sahara_hw_descriptor_create()
Date: Mon, 22 Jan 2024 15:53:31 -0800
Message-ID: <20240122235753.142058735@linuxfoundation.org>
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
index e25636904aca..0b7a95dae9fe 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -484,13 +484,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
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
@@ -538,9 +539,6 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 
 	return 0;
 
-unmap_out:
-	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_FROM_DEVICE);
 unmap_in:
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
-- 
2.43.0



