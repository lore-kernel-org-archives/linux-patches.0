Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB6412BF3C;
	Tue, 23 Jan 2024 00:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968923; cv=none; b=V6IpBzzWgd2mPJbEVGBODLH6DUQUi9/FZVqE3SU8De9CHoNWALEWH/8FpmiGBqfrIEP7b/OyXfVzRP1JmzFjH3DWNoFXNGBDQSmU2nE0LwNXIKXoJAKsuAyT4UnFIO41CZUU5EtFwdkx50yGtl5VpvCTIRPLxr+KMxQU5zh4qBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968923; c=relaxed/simple;
	bh=JKwamMGh5LzRdCjg2s6Fq4geAVQZmkFryJvnVvsIRWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NePUi2y8D9ZHyyNngs5UEW5oh7OaaXG+LwYImpe/+OWYV9PAsIwsPrpSFTmFNhGFwdwHH6VmLzgmzQgdAhCs1VLS4nrk41uVdE7WP4oN1Klrfw3qCwPe5RRvIOw2zcxFIU3YVHZV8f3pYha9ry6TxxjxwBe4nQ4X4gdDuIVuTBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuRaMeHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuRaMeHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B8CC433C7;
	Tue, 23 Jan 2024 00:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968923;
	bh=JKwamMGh5LzRdCjg2s6Fq4geAVQZmkFryJvnVvsIRWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuRaMeHzHELaHd6mxoBx+nil047t/7AIyeQHInOqHixZ2qh99ydrrQqcFQrtj/vpp
	 UDjWIrxD7InHfc5Zs7K4vdNVf12VeobK6JZw+3sOxoEvAmrCXn++J5b3MoVT1E2m3g
	 ifwVSXGORknNwtHsjUQaJfP/Url0OTJtvTu+/FEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/194] crypto: sahara - fix error handling in sahara_hw_descriptor_create()
Date: Mon, 22 Jan 2024 15:56:38 -0800
Message-ID: <20240122235722.125411525@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c62f9ce6adc0..e505c01b7a05 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -481,13 +481,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
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
@@ -535,9 +536,6 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 
 	return 0;
 
-unmap_out:
-	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_FROM_DEVICE);
 unmap_in:
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
-- 
2.43.0



