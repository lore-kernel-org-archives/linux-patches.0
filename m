Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02553282F5;
	Mon,  6 Jan 2025 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179058; cv=none; b=BAq8lQm9jKRijmJAGrRytXpETdhlZ5Z3C6jX2szckegsMk0O1L4ts/frf2XjDb/3yWwGH0Gclu2u7CNaZWRT26VTqtM9X+k9ntNBG9RtyKpxxAeF2ElEHvH3Fd2TckprXm/Uh+DhCGtQKryWe8BDN6XUeL6toLTiuzoNz+DxcRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179058; c=relaxed/simple;
	bh=ky+cj6IBdIBpCu8dQYcNuwZt56llx4Uh2ItAeszxMss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daeYC0720LQwTuyZhmZFQPmHlO98Q3eSrwvtiH9pW8j/gMJvIpg+pPc0jmQAzxx9kKjcIXz1NYD5lyScaC/HMSai9fmL/Sn4r4Tr20qyVljLhkgH88eoDBnnf6oMHRlfrYKUkoZL5o544lz7kXOfql7QulAkCJPYwmKvh6XYeWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptKTxCwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptKTxCwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074F6C4CED2;
	Mon,  6 Jan 2025 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179057;
	bh=ky+cj6IBdIBpCu8dQYcNuwZt56llx4Uh2ItAeszxMss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptKTxCwUeDKXFHTrT6LcCwk16WNo7HqEDgwTyZIdAmbUs6BKyM/Uizlq/ggLI8c9r
	 i1pAEuVBwF3Kp8Ib8a7ifdI5RzkEB4/4d0pGX4zwB//ZnO/es3dEuuYxbKaPbFQ7dE
	 VrPcaxLXlns59T9/1JmUzZO207SBYBbRz9iMVajQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hongchi <hongchi.peng@siengine.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/93] usb: dwc2: gadget: Dont write invalid mapped sg entries into dma_desc with iommu enabled
Date: Mon,  6 Jan 2025 16:16:38 +0100
Message-ID: <20250106151128.783815340@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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
index b341bbc9f1da..abc2271799e0 100644
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



