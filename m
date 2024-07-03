Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C96181BAC;
	Wed,  3 Jul 2024 11:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004798; cv=none; b=psECArrlkOR0Llhqc3vgqlzGFtUlUZoLlK1MeOdTq+jqPG7X97yoE4fyEAMNqnMO0pY3aVDFQvRPdkovkJSf5pPHAJxWHSk0ZfmcgB8Jx49KpExWZBFvBDhyapM3MXmtVPvtIwhfT/7F2PPd+avVp2tckMyFUey2L9czjO+VZZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004798; c=relaxed/simple;
	bh=FTDiQ0v26DJto1mzqAoujB8E5ZRhVNb/TY11YE6nfWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2z2HTqDapd7mq21hvK7egCrBKgWtsG5kflT3nezhHsAWtCo9VZeS+ze1cN62uovYrGMLoJFkg6LwGQz1Vs3hdMY8Y/N1pfDMBUntCoRfHOe+PUs+GbXQWZqSvXMRL7vFyl9eJfiECu+9DoAqC+SZiL2bumJOHvJn0QeyZlsUW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4sweUDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4sweUDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21A6C2BD10;
	Wed,  3 Jul 2024 11:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004798;
	bh=FTDiQ0v26DJto1mzqAoujB8E5ZRhVNb/TY11YE6nfWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4sweUDGmj8loZfKP9R7CARkbUn5G6KeyBA1M1q0SGrVluiicnAJJ0KF5TsbgEBSb
	 8FfnBqqKd/tMAglRY8Y2YLJ5gpF6e20rRnt0ITLeHQE25lR1tHiUKT+wTfFEq6916j
	 9AzpnWx/vgMtpaWXjFLHtatFNMzbOkcDkIZUOgF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing@vivo.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/290] dmaengine: ioat: switch from pci_ to dma_ API
Date: Wed,  3 Jul 2024 12:38:56 +0200
Message-ID: <20240703102910.034480155@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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



