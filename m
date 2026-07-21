Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EB746EC8A;
	Tue, 21 Jul 2026 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659776; cv=none; b=qzYbCag5DhR+W5QxMr7J6gPLe4mUAIy2+r+EiD3BSkB1sH73E20xg1ZjD3PIKDNrSc8RB28shurs9a2dNEzsygNz2ND5EoQ5Hq7xmDK8TCRbZZIym4i5ZHZBVkWjKerihrnInTJkgRQYjnqd34WxKxJXKRFksV43G6jeN48HFPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659776; c=relaxed/simple;
	bh=rDLFkZ7+TUhXrw4KHTHEEhpRLhQLk+VlHmzj1T+c3mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQKB1EkPZMk1Fh2eG/NDupYrcJV/3CDg8Wb4TP80dsGr+4aRuBVyDguG1gW/RDDkHgX2RvRoSbwu6sKRIxAwxlHSLXu3vnv+5eWmVwU325Ffd2EOmuvLb34pSnQIbGKF+15DpgqWJMcTq3X9xhKilzrwmajtIA78gGVaj8SDFUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jmvr/WrV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmvr/WrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEE41F000E9;
	Tue, 21 Jul 2026 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659775;
	bh=+qnyMX8pfQk1wEfW/ZSrgBUIhJovHtO+sw0W0wRbVag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jmvr/WrVbSsMG2q1xJfZJzQi4EJ+x9a4OEDsdwrArSs+q2JfOPsyyP7JCbabCDsnE
	 Fxt+QK9YEeGMyzs7q8jZXLdKu8LPOdyHaeNHlU6nWWsZ2WEGSQlaDxVtRUTmZ89XQ0
	 y9Y5Zy4mwK+5v3py6putLISbSA2yIPfbALwXPyGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0727/2077] iommu/dma-iommu: Fix wrong scatterlist length assignment in P2PDMA path
Date: Tue, 21 Jul 2026 17:06:40 +0200
Message-ID: <20260721152609.946868587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit db50fb87015b955a5a0c155293b2dd40d63a3b9e ]

In iommu_dma_map_sg(), when handling PCI P2PDMA cases, the DMA length
of the current scatterlist segment `s` is incorrectly assigned from the
head entry `sg->length` instead of the current entry `s->length`.

This typo causes all P2PDMA segments in the scatterlist to inherit the
length of the first segment, leading to corrupted DMA lengths for multi-
segment scatterlists.

Fix this by using `s->length` instead of `sg->length`.

Fixes: a25e7962db ("PCI/P2PDMA: Refactor the p2pdma mapping helpers")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 381b60d9e7ceaf..3ca2c5da2843bf 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1465,7 +1465,7 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			 */
 			s->dma_address = pci_p2pdma_bus_addr_map(
 				p2pdma_state.mem, sg_phys(s));
-			sg_dma_len(s) = sg->length;
+			sg_dma_len(s) = s->length;
 			sg_dma_mark_bus_address(s);
 			continue;
 		default:
-- 
2.53.0



