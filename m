Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F807082A;
	Mon,  6 Jan 2025 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178156; cv=none; b=rKH730TWEV1RVAMfXt+iAbIXSheqPkKJyB5s+E7BXqqVzJ7rLyWgNDmlPdiZ5LPZSpl+my8ShJ3xNbu9SJNEM3cixsjEBwQS/AhR3W2ANrTuI1Bs4nrHaJNpQE0g6R2M+PN435auz3K0kO8vXcrHn+5TFeWRhSqo4aTUtvH7PjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178156; c=relaxed/simple;
	bh=tX6NjFJ+IBsbk+BC+ZX9Mjk7W5Ac28QP7I92BwMXU58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JA0dQbfdN2SbbbYBwK4ZXVJQa7H3Megi6AsJ0MuaNgaDgYRtr6N0ic+7NvVObXj4AMNlyj0Pe3RyNYf1CubSoB6VXVpuudrbTI1PPYLKlv6nNirMCtTwH48vL7iMLWTj5WO/pwRw6FJKD+j9t5q9sCpgC533UgIynV+zQCcctJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxB6WHh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxB6WHh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FB6C4CED2;
	Mon,  6 Jan 2025 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178156;
	bh=tX6NjFJ+IBsbk+BC+ZX9Mjk7W5Ac28QP7I92BwMXU58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxB6WHh4Se4J3aYV8FVCoM0yTv7ai/3GGYbNU4ydmVwxpTQhI4gmO61u+NplYxdke
	 cMAMohXhgQqZsMJniL177j9o4T7nHqnGkUKEQ8AXwW0bSHkSSYqYmTl4VmQDGTO4QQ
	 i46M2ulzyZmnBPoulIVr/FMLZb6nTaT8a4Mh/MIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hongchi <hongchi.peng@siengine.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/138] usb: dwc2: gadget: Dont write invalid mapped sg entries into dma_desc with iommu enabled
Date: Mon,  6 Jan 2025 16:15:32 +0100
Message-ID: <20250106151133.532746864@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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
index d8b83665581f..af8a0bb5c508 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -886,10 +886,10 @@ static void dwc2_gadget_config_nonisoc_xfer_ddma(struct dwc2_hsotg_ep *hs_ep,
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



