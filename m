Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A601B392B;
	Mon, 23 Dec 2024 16:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970221; cv=none; b=oU6dL13RVQ65zbvCV/pggQKNQHzj3VM6iTmAKOrfAg6OtmLD8856QkSlxhvazbyiOQ3ayss8Iht/bI1huxOWhE/ZN/kaaNHhG7BFle5Mf4YkPT3Qx90p0YnE9KBvcLZifVt71O/leXoCPJpxNRFEueRkRDyE1F7g32ADjFlWbdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970221; c=relaxed/simple;
	bh=iKahr5qoQxN73DqM7VSADJj/irzMlTJ2TCE6HxuZoJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItVB3GkF9i06MigM9C2UvxMCN9Wv0Lx9SdYbjOzbSG64wzu/Eba2+rd88Z1/6p5Gl22GfXmy/z4mO0wLzOrViwiWMygo7pbUt4faYQAYKWI4ZVV8wzr+uU3cfjJU/7t5mj57MQEw1O0Khmbiafr4mlkM0DiwpdE/EoPN7S+MFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kyM9mSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kyM9mSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBB6C4CED3;
	Mon, 23 Dec 2024 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970221;
	bh=iKahr5qoQxN73DqM7VSADJj/irzMlTJ2TCE6HxuZoJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kyM9mSumKc2iLDP7tdpYApdYpa4Cy8tRJpH8IUoYtgKdQ+bYMRwRiDKeOVHHYp+R
	 tGpxgiqdAuX7NLj9v04bhNG81O0DtjYelu8uj8F7rylTCHOaYCSDDLhrzJFe3jxXkA
	 qdObiePUKwNZWRm75aXBYa/ngp2FWMOpbfTZHnWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hongchi <hongchi.peng@siengine.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/116] usb: dwc2: gadget: Dont write invalid mapped sg entries into dma_desc with iommu enabled
Date: Mon, 23 Dec 2024 16:57:52 +0100
Message-ID: <20241223155359.639122376@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Hongchi <hongchi.peng@siengine.com>

[ Upstream commit 1134289b6b93d73721340b66c310fd985385e8fa ]

When using dma_map_sg() to map the scatterlist with iommu enabled,
the entries in the scatterlist can be mergerd into less but longer
entries in the function __finalise_sg(). So that the number of
valid mapped entries is actually smaller than ureq->num_reqs,and
there are still some invalid entries in the scatterlist with
dma_addr=0xffffffff and len=0. Writing these invalid sg entries
into the dma_desc can cause a data transmission error.

The function dma_map_sg() returns the number of valid map entries
and the return value is assigned to usb_request::num_mapped_sgs in
function usb_gadget_map_request_by_dev(). So that just write valid
mapped entries into dma_desc according to the usb_request::num_mapped_sgs,
and set the IOC bit if it's the last valid mapped entry.

This patch poses no risk to no-iommu situation, cause
ureq->num_mapped_sgs equals ureq->num_sgs while using dma_direct_map_sg()
to map the scatterlist whith iommu disabled.

Signed-off-by: Peng Hongchi <hongchi.peng@siengine.com>
Link: https://lore.kernel.org/r/20240523100315.7226-1-hongchi.peng@siengine.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index b2f6da5b65cc..b26de09f6b6d 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -885,10 +885,10 @@ static void dwc2_gadget_config_nonisoc_xfer_ddma(struct dwc2_hsotg_ep *hs_ep,
 	}
 
 	/* DMA sg buffer */
-	for_each_sg(ureq->sg, sg, ureq->num_sgs, i) {
+	for_each_sg(ureq->sg, sg, ureq->num_mapped_sgs, i) {
 		dwc2_gadget_fill_nonisoc_xfer_ddma_one(hs_ep, &desc,
 			sg_dma_address(sg) + sg->offset, sg_dma_len(sg),
-			sg_is_last(sg));
+			(i == (ureq->num_mapped_sgs - 1)));
 		desc_count += hs_ep->desc_count;
 	}
 
-- 
2.39.5



