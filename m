Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358F87C081;
	Mon,  4 Mar 2024 21:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587871; cv=none; b=o6lYu/U7lJl4wdeeB1scrkZLaAg4LkkUU6LOCZh9DqfogYOYYm2QUjL9iQc8+1Yc4OAM7TB0qrSzFWxDf1iOK40BVtp820FJGqkq9QoMF/y46SI46c73nKl+YZ0PWQeH4+qhz4SKgcJeSOYHnsuTmmc5OfgyWEEcLVmGm9rRbYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587871; c=relaxed/simple;
	bh=e/sDbBwnN/kvzg7RtasP2Pvq2iwQZzCeDVid1W691F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhZ7nh8zD140le8+lKrs/VBMXlrSIOXjZD1H9ECnwMoApwakpR5m7Wzc1DxF0g9eFwb9qCopRzcQL6UlR3cXnN7ez6z0wcAHp8FS3Jw2vt4ywZCcrSl3sJn8Q1nxPhaTrZ955ImsJDFNI0htjJ/bfUT9AP/CQZFlM/faSK9B72M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAHqwycE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAHqwycE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6D1C43390;
	Mon,  4 Mar 2024 21:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587870;
	bh=e/sDbBwnN/kvzg7RtasP2Pvq2iwQZzCeDVid1W691F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAHqwycEVjN0m1sdjYr+6xKIic66UYt2SGEvAGaDFMY2tFStCWbW7aJS9ZBRInwfN
	 6M9mSz8cxfF5KCTgusqoqiS4CpcxKexAjSP2oYQj1dCA0BOcml1Kucj7G5suoaZ8DG
	 UcGxJ1uf61EMGPRlLoOBYLZ+NBL+UmJOwVxjBxP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Tadeusz Struk <tstruk@gigaio.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.7 097/162] dmaengine: ptdma: use consistent DMA masks
Date: Mon,  4 Mar 2024 21:22:42 +0000
Message-ID: <20240304211554.942902966@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Tadeusz Struk <tstruk@gigaio.com>

commit df2515a17914ecfc2a0594509deaf7fcb8d191ac upstream.

The PTDMA driver sets DMA masks in two different places for the same
device inconsistently. First call is in pt_pci_probe(), where it uses
48bit mask. The second call is in pt_dmaengine_register(), where it
uses a 64bit mask. Using 64bit dma mask causes IO_PAGE_FAULT errors
on DMA transfers between main memory and other devices.
Without the extra call it works fine. Additionally the second call
doesn't check the return value so it can silently fail.
Remove the superfluous dma_set_mask() call and only use 48bit mask.

Cc: stable@vger.kernel.org
Fixes: b0b4a6b10577 ("dmaengine: ptdma: register PTDMA controller as a DMA resource")
Reviewed-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Tadeusz Struk <tstruk@gigaio.com>
Link: https://lore.kernel.org/r/20240222163053.13842-1-tstruk@gigaio.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ptdma/ptdma-dmaengine.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/dma/ptdma/ptdma-dmaengine.c
+++ b/drivers/dma/ptdma/ptdma-dmaengine.c
@@ -385,8 +385,6 @@ int pt_dmaengine_register(struct pt_devi
 	chan->vc.desc_free = pt_do_cleanup;
 	vchan_init(&chan->vc, dma_dev);
 
-	dma_set_mask_and_coherent(pt->dev, DMA_BIT_MASK(64));
-
 	ret = dma_async_device_register(dma_dev);
 	if (ret)
 		goto err_reg;


