Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFB61891D3;
	Wed,  3 Jul 2024 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005826; cv=none; b=rO9p5WbrTFkjWwmGhV3AUstGgQnBnGJeI2tfmGe0HJXylmsKW8fNDn9s0QJTpIH/jwTn3AEXWNSWaFSUgdvQvaIx9gEV/mi4Znkiw1z96ZOxfYQ9GsV+57omA6pkHynVjKq2ZhrJfNzr8yU9dAuUboQapiIx0SoNT44dzTNyIM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005826; c=relaxed/simple;
	bh=AATsDLmpQocXyKr28EU40Pvy+vXNUXFFpyeqeoyjqoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnmEc9QTj4sF5hodiehkJZwJaJZJ5O46oth6LajvOLC5FXzU3AgNg60DmSBg9+uod1A33kzrEZZsMlT/R1NJ13PFx/IaI09uO06ApxRQXez7FuRMW1OSR2L8KcYdf8XRFM1FiQHSQVXLmMxFmndweLrpKTrYGOWauh1dY0cI9n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtDIGHpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtDIGHpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD0DC2BD10;
	Wed,  3 Jul 2024 11:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005826;
	bh=AATsDLmpQocXyKr28EU40Pvy+vXNUXFFpyeqeoyjqoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtDIGHpgwm3/Bd7ayQkvK6nrukLocTsRNSsjgggMAnbY35LYiMJN3B98ueCn9U2SH
	 CCRmHitFl17rPg4AlF/dG+mHPyAO7Xb5pZ0O3RK3+0/WqekbBHI3Ql53mlushX+e2V
	 SskWMfQ1v4R/KGJ9IAkQX553/Lpwx4BlJ6GROngs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing@vivo.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/356] dmaengine: ioat: switch from pci_ to dma_ API
Date: Wed,  3 Jul 2024 12:39:04 +0200
Message-ID: <20240703102920.976632978@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Qing Wang <wangqing@vivo.com>

[ Upstream commit 0c5afef7bf1fbda7e7883dc4b93f64f90003706f ]

The wrappers in include/linux/pci-dma-compat.h should go away.

pci_set_dma_mask()/pci_set_consistent_dma_mask() should be
replaced with dma_set_mask()/dma_set_coherent_mask(),
and use dma_set_mask_and_coherent() for both.

Signed-off-by: Qing Wang <wangqing@vivo.com>
Link: https://lore.kernel.org/r/1633663733-47199-3-git-send-email-wangqing@vivo.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 1b11b4ef6bd6 ("dmaengine: ioatdma: Fix leaking on version mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 191b592790073..373b8dac6c9ba 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1363,15 +1363,9 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!iomap)
 		return -ENOMEM;
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err)
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-	if (err)
-		return err;
-
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
 
-- 
2.43.0



