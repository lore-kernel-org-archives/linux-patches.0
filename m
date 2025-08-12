Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8102F8BE7;
	Tue, 12 Aug 2025 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021530; cv=none; b=QwQiZSP9tlyawClOeDxZOPpypsCWjKxkQj6KmpzUMWkEzAxrnNsAjmvP4hmmyoE/8tRsngu5kYEcUgD5M0psAr4Cpk/r8rg5d2BWKPnGOlCCps/r6ziEOwj0D3C7oyDRu1ce2EmlXkHAwPpt4tYcBIHjl84CrSavksFkJvBJ0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021530; c=relaxed/simple;
	bh=3kmqdrUTqw+UJ+cCmm+MZhfEQe4c0hUr4f9lsOzSVq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyFW+Ycqf4ToAlVaO8VvIe3s0IXgoBlMrT95ObQJf85OAdTvqMaco+s+nmXGMjtNdpB3AkdzOVT0u/eenAfDsrIgVYrEapUFHLV5CklR8T88UYx1gJNoBMNg99988d2o7MMGn451QBNxhdSQ8FN3xPXYrR3ZWY56JHnASCmnPLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBM4ZdTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBM4ZdTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D5EC4CEF1;
	Tue, 12 Aug 2025 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021529;
	bh=3kmqdrUTqw+UJ+cCmm+MZhfEQe4c0hUr4f9lsOzSVq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBM4ZdTIr9dTP6fg5rQYhHRgQKZUS8VHv1J/Pujuz5ZzQ2IPnlUPglc1qnUllb/mF
	 FHeQUcuKUETKn1Vxgcg0sj1be/3QjvOwLbrlbBz7s3D2R5wtCFnHkCGv0QA+lBCX4s
	 D7/Thh6R1XRHmSCDayeqq6Qp24RPOz+BWSWiEW54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/262] dmaengine: nbpfaxi: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:28:56 +0200
Message-ID: <20250812172959.400465380@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a361f8c29cd3..69c80d933903 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -711,6 +711,9 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
 		list_add_tail(&ldesc->node, &lhead);
 		ldesc->hwdesc_dma_addr = dma_map_single(dchan->device->dev,
 					hwdesc, sizeof(*hwdesc), DMA_TO_DEVICE);
+		if (dma_mapping_error(dchan->device->dev,
+				      ldesc->hwdesc_dma_addr))
+			goto unmap_error;
 
 		dev_dbg(dev, "%s(): mapped 0x%p to %pad\n", __func__,
 			hwdesc, &ldesc->hwdesc_dma_addr);
@@ -737,6 +740,16 @@ static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
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



