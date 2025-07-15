Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0413A1F4CB3;
	Tue, 15 Jul 2025 13:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586672; cv=none; b=NRp5frEm2hg7h8oAPiBscN/t2H0F+t8VxnbfEaXlJFIFy8dm8LS6JLJYcszlrenhoPbJ9LREJopg/V1oR+hEXwlTtyDqCrveD+h+oMradsxMTMiEyonxGa6Lr/PNObu8wvhg8koTDuurjRvdr0J/9wpRnlH+44dPPMmVaf+7Yxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586672; c=relaxed/simple;
	bh=Io9LV/YhLFiDmDy2T1FzTsJWff5OVt5wFeFUbem4lx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoPOnMJITyP8Wx2PAkTOUXo/AU1qA/pgKHm+JVpmRGuxT5PaH+vbLbPWJQZl0chBSFYSYm3bUunzvKW1X1LMmNbF6aelfB9Pny+hZUgA4CbzZItc9uLeDcx+DV2gfAMZ8ZmqsKrSVLCLp6WUoYiEs8952JcaC70BMJeZFu9N8XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJSAcEIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJSAcEIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0CDC4CEE3;
	Tue, 15 Jul 2025 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586671;
	bh=Io9LV/YhLFiDmDy2T1FzTsJWff5OVt5wFeFUbem4lx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJSAcEImTyZ+jrcEOWLgLYXhtc0jpPihRKPpqB7xQvrYUEV+fA6UETQhUBR4dcI6H
	 1gS5pUnAdEmrKTAfmgCAHluqorHPS2Fy0es4oqJ7qmI0rs0yD693C96Yr/qkKxurHk
	 qhL5TVCw8J9d00qsCMbvNbq03vmPtedhuGjhApE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/148] atm: idt77252: Add missing `dma_map_error()`
Date: Tue, 15 Jul 2025 15:14:23 +0200
Message-ID: <20250715130805.926892826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit c4890963350dcf4e9a909bae23665921fba4ad27 ]

The DMA map functions can fail and should be tested for errors.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250624064148.12815-3-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77252.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 06e2fea1ffa92..03b3b9c7c8b5c 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -849,6 +849,8 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 
 	IDT77252_PRV_PADDR(skb) = dma_map_single(&card->pcidev->dev, skb->data,
 						 skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&card->pcidev->dev, IDT77252_PRV_PADDR(skb)))
+		return -ENOMEM;
 
 	error = -EINVAL;
 
@@ -1862,6 +1864,8 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 		paddr = dma_map_single(&card->pcidev->dev, skb->data,
 				       skb_end_pointer(skb) - skb->data,
 				       DMA_FROM_DEVICE);
+		if (dma_mapping_error(&card->pcidev->dev, paddr))
+			goto outpoolrm;
 		IDT77252_PRV_PADDR(skb) = paddr;
 
 		if (push_rx_skb(card, skb, queue)) {
@@ -1876,6 +1880,7 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 	dma_unmap_single(&card->pcidev->dev, IDT77252_PRV_PADDR(skb),
 			 skb_end_pointer(skb) - skb->data, DMA_FROM_DEVICE);
 
+outpoolrm:
 	handle = IDT77252_PRV_POOL(skb);
 	card->sbpool[POOL_QUEUE(handle)].skb[POOL_INDEX(handle)] = NULL;
 
-- 
2.39.5



