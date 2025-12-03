Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7CB3246F4;
	Wed,  3 Dec 2025 15:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776911; cv=none; b=C6Uc2j8kbrC/RQPXWG5AoucRPFZSWLsw+iPjS6woRSoqwW+DscrFVoegHoeJh7yGeXpSdSxvZqHS/d+f5wKwQrqPj+sRmeiizZsTzzKXSX6XazH3FPFyj540n4ut3qdVqRg7QKAVSeZlFXGHeJqVsKZ7VJo/F4okMhcFDQRwFxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776911; c=relaxed/simple;
	bh=mwMz5SreB1TnCUuVsP4jnKjwPrDI1ur/jrF25jHN4qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+VT+uf/Jz/+HOX7KZkEx+MR+fGCUPoMyEXL4GBYrbUCgHttH54TWYoomH8MdX1Fef/rkPtBOb5s9Bplb84ZaMloFrtkwJzsH71K6GE2GdHtQIHTbA4Inv7kseKjq23VHuBAha01z38+MQZ6pq9g4xoJGU25sHxBagJohyD4p5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUgU6v8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUgU6v8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EC4C4CEF5;
	Wed,  3 Dec 2025 15:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776911;
	bh=mwMz5SreB1TnCUuVsP4jnKjwPrDI1ur/jrF25jHN4qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUgU6v8+nQlzO8oT6cO+C69vr4+PX0sA20L0Sc4Kc8R3tcxD+80S8n3P7BVIgTqKA
	 8UR3NPefxBKYaxR4Z4QevWtJBWrNS0b3SaCxzFuPjcvFiDYEHhp6xNDwZxOIaGj7rV
	 IKNzRrwuROp1DPuqUWbEhckRCky9YWBZmiEc0Dvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Shivaji Kant <shivajikant@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 024/146] dma-direct: Fix missing sg_dma_len assignment in P2PDMA bus mappings
Date: Wed,  3 Dec 2025 16:26:42 +0100
Message-ID: <20251203152347.352079093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Shrivastava <praan@google.com>

[ Upstream commit d0d08f4bd7f667dc7a65cd7133c0a94a6f02aca3 ]

Prior to commit a25e7962db0d7 ("PCI/P2PDMA: Refactor the p2pdma mapping
helpers"), P2P segments were mapped using the pci_p2pdma_map_segment()
helper. This helper was responsible for populating sg->dma_address,
marking the bus address, and also setting sg_dma_len(sg).

The refactor[1] removed this helper and moved the mapping logic directly
into the callers. While iommu_dma_map_sg() was correctly updated to set
the length in the new flow, it was missed in dma_direct_map_sg().

Thus, in dma_direct_map_sg(), the PCI_P2PDMA_MAP_BUS_ADDR case sets the
dma_address and marks the segment, but immediately executes 'continue',
which causes the loop to skip the standard assignment logic at the end:

    sg_dma_len(sg) = sg->length;

As a result, when CONFIG_NEED_SG_DMA_LENGTH is enabled, the dma_length
field remains uninitialized (zero) for P2P bus address mappings. This
breaks upper-layer drivers (for e.g. RDMA/IB) that rely on sg_dma_len()
to determine the transfer size.

Fix this by explicitly setting the DMA length in the
PCI_P2PDMA_MAP_BUS_ADDR case before continuing to the next scatterlist
entry.

Fixes: a25e7962db0d7 ("PCI/P2PDMA: Refactor the p2pdma mapping helpers")
Reported-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Pranjal Shrivastava <praan@google.com>

[1]
https://lore.kernel.org/all/ac14a0e94355bf898de65d023ccf8a2ad22a3ece.1746424934.git.leon@kernel.org/

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Shivaji Kant <shivajikant@google.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20251126114112.3694469-1-praan@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 24c359d9c8799..95f37028032df 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -486,6 +486,7 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 		case PCI_P2PDMA_MAP_BUS_ADDR:
 			sg->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
 					sg_phys(sg));
+			sg_dma_len(sg) = sg->length;
 			sg_dma_mark_bus_address(sg);
 			continue;
 		default:
-- 
2.51.0



