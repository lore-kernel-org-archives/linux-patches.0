Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429FF1FB2;
	Tue, 23 Jan 2024 00:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968230; cv=none; b=DIux1Ph5dX5RJwTAcwOeaIrDnTVMpCT45kR4Pv/gjE5TorrsA2mXdZeS48LSVOt8bPRWkiN7u4S9LM3jnFdZdsYyHHCso4AAeVImn4ekEu0ncMmZyVuz5vuQPoV5KppPdGu4E+GY+//f561ES540OCewrh8J8rEMrKAe73VfEuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968230; c=relaxed/simple;
	bh=l5tgXypiQeI73omvvNTkhCxKkggUi7TV1DveBnybNA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGt2pVvQ+FTOiXZb7l+hZdRVNwrFz1U75pp/g/h5u64euumd8DcWFBe4rUiGQKN6R9wXN3kUyB2LwqWV5sg7lUo25C657pXGs9+0Vwj6socodx5IcbznhXV9dpNhAbAGQulOi8nBroRnQFasj9eMWDAlztjVFYDs3u68aRMOKJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLBKPNqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLBKPNqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EFFC43394;
	Tue, 23 Jan 2024 00:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968230;
	bh=l5tgXypiQeI73omvvNTkhCxKkggUi7TV1DveBnybNA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLBKPNqXbNn0vzCaXeEY5I79fH6rdB7TPhaviGnFhQi+Vb8MFj464TvASJFDU82B4
	 3Rt6H84b6bY18rcT+vSA1JafjsS0GTyZMfkJhpTxBZMBfyoKc6++59fTVNzjGrBdI5
	 FCs9lxVgcI3A/MshLncFWpCMXId+dQRUjLQLxRCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/148] crypto: sahara - fix error handling in sahara_hw_descriptor_create()
Date: Mon, 22 Jan 2024 15:56:47 -0800
Message-ID: <20240122235714.483313636@linuxfoundation.org>
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
index ef0912b4d28c..011789df3590 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -484,13 +484,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 			 DMA_TO_DEVICE);
 	if (ret != dev->nb_in_sg) {
 		dev_err(dev->device, "couldn't map in sg\n");
-		goto unmap_in;
+		return -EINVAL;
 	}
+
 	ret = dma_map_sg(dev->device, dev->out_sg, dev->nb_out_sg,
 			 DMA_FROM_DEVICE);
 	if (ret != dev->nb_out_sg) {
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



