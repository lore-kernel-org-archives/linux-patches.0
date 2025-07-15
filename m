Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B542E9EA7;
	Tue, 15 Jul 2025 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587931; cv=none; b=rSco4we24GbFfF6/RAC1bLm4PPKTOvbanVXfLDuU5LJ7Fcf2X+zeX/yGOMAgLHHoK1WCxGaEnb9c4RHRPxRZPYSsMESPL1ZwJR+l/DW5+SAoZxwo4p+4ZEbXtLtpbeKVITmG88E/EbFm8mOGW5XAw+yk79A50r0S9TO6Pqy3Qrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587931; c=relaxed/simple;
	bh=IarzkdPsTgvBsX3xSWrO58AB7yr3tO1d0RI2P4Y1iKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP65fu8bHShQbgJY265daX8UuBarb2wcmn/vvFUSE9a50BsAdn3HlSjs4bPONjKMKzHdiXCqNXJak8/MOuiDyEWTP4SDK6zVYOYCPB0evHDaP/st+I9gElrr8PI+qHwXD6A7oJ2WsL2RlDxkvP6eb/rfxNzWoqoDROCyAPEVGxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9caBsJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9caBsJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BB4C4CEF1;
	Tue, 15 Jul 2025 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587931;
	bh=IarzkdPsTgvBsX3xSWrO58AB7yr3tO1d0RI2P4Y1iKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9caBsJt1OTM8CDD3R5hMNn0dVSIcOKNe+qbT67WD6X8vkL4WjTNxKdaXHHa4jfBO
	 0xmdT1QVaZwXijyGJS506B3kKyqpfAMAPjeQzBy+CZHvrZiUiGjduAuTj7Dj0DQyDx
	 wwPjr6M5ymXfoV+VSJNa7vaQGVUzNqbh33Xk/A5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/208] atm: idt77252: Add missing `dma_map_error()`
Date: Tue, 15 Jul 2025 15:15:04 +0200
Message-ID: <20250715130818.756073617@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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
index 25fd73fafb371..89b0ed8e51430 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -852,6 +852,8 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 
 	IDT77252_PRV_PADDR(skb) = dma_map_single(&card->pcidev->dev, skb->data,
 						 skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&card->pcidev->dev, IDT77252_PRV_PADDR(skb)))
+		return -ENOMEM;
 
 	error = -EINVAL;
 
@@ -1863,6 +1865,8 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 		paddr = dma_map_single(&card->pcidev->dev, skb->data,
 				       skb_end_pointer(skb) - skb->data,
 				       DMA_FROM_DEVICE);
+		if (dma_mapping_error(&card->pcidev->dev, paddr))
+			goto outpoolrm;
 		IDT77252_PRV_PADDR(skb) = paddr;
 
 		if (push_rx_skb(card, skb, queue)) {
@@ -1877,6 +1881,7 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 	dma_unmap_single(&card->pcidev->dev, IDT77252_PRV_PADDR(skb),
 			 skb_end_pointer(skb) - skb->data, DMA_FROM_DEVICE);
 
+outpoolrm:
 	handle = IDT77252_PRV_POOL(skb);
 	card->sbpool[POOL_QUEUE(handle)].skb[POOL_INDEX(handle)] = NULL;
 
-- 
2.39.5



