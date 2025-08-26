Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51713570A2;
	Tue, 26 Aug 2025 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217511; cv=none; b=gM8bxurHYsWGzpObUqvK8xMyMeRKmsaxZx7K18DNH2FxHY4Pvy14CoBzAfSS+c9iD1Rx8alxNoGT58Raz5Qr631fQK9hKvFaAg59icqpClmjlouVi1F7+o903i1RInOCh1fA0wJg5IQq/UEAvVglAECiwAe6xqWINarBtlk25fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217511; c=relaxed/simple;
	bh=29d6AP3fseZSiC3APVUJRFeQnibEmFkzNwoC8sPTB2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqxAZOHuAmwjKFa8qHg08ASqnlTijS7eoePcPDiSvM1zHRNqW1euHKfCEdTW+T5fbTGcdoQ5e9LI9o+Ww17KzkP9oy7FkboRnwC0SARytI8bugt1VTl3O5x2JFpdtMCAAIgly2/1ciStj7e2kZMWYYIYopvca9k/+b0hIsLpkjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9IaVRcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9IaVRcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D85C4CEF1;
	Tue, 26 Aug 2025 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217510;
	bh=29d6AP3fseZSiC3APVUJRFeQnibEmFkzNwoC8sPTB2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9IaVRcG6PCAngjCjaujkLZlSGJzAa3nLyquaiyiTXsHXu2OrM5hzGupA7XEYDE9C
	 GqPpzQG0AyDCUkjESNbgcv3ldd4fqEDsXvlGdkZjxTtBmsmS3gqTtz/nLjKkjmW1Xx
	 sjQOWGamirUsd75K+LTlUDcqncx5iZ8WF/kgehkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/523] dmaengine: nbpfaxi: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:05:49 +0200
Message-ID: <20250826110927.928938337@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit c6ee78fc8f3e653bec427cfd06fec7877ee782bd ]

The DMA map functions can fail and should be tested for errors.
If the mapping fails, unmap and return an error.

Fixes: b45b262cefd5 ("dmaengine: add a driver for AMBA AXI NBPF DMAC IP cores")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250707075752.28674-2-fourier.thomas@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/nbpfaxi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index bbedf57e3612..94e7e3290691 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -712,6 +712,9 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
 		list_add_tail(&ldesc->node, &lhead);
 		ldesc->hwdesc_dma_addr = dma_map_single(dchan->device->dev,
 					hwdesc, sizeof(*hwdesc), DMA_TO_DEVICE);
+		if (dma_mapping_error(dchan->device->dev,
+				      ldesc->hwdesc_dma_addr))
+			goto unmap_error;
 
 		dev_dbg(dev, "%s(): mapped 0x%p to %pad\n", __func__,
 			hwdesc, &ldesc->hwdesc_dma_addr);
@@ -738,6 +741,16 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
 	spin_unlock_irq(&chan->lock);
 
 	return ARRAY_SIZE(dpage->desc);
+
+unmap_error:
+	while (i--) {
+		ldesc--; hwdesc--;
+
+		dma_unmap_single(dchan->device->dev, ldesc->hwdesc_dma_addr,
+				 sizeof(hwdesc), DMA_TO_DEVICE);
+	}
+
+	return -ENOMEM;
 }
 
 static void nbpf_desc_put(struct nbpf_desc *desc)
-- 
2.39.5



