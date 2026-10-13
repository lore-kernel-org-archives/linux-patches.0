Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F601A6803;
	Tue, 13 Oct 2026 12:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893802; cv=none; b=KexfdGunCEBfRbKH3qD8mJNjS566Bt3fY2bDmRFlRv7h7SRlbvtXSD15NZyKdW4wiyssRaLntbi8u88vcrkIaQjOLgF341FB8I8xCvpg/krsKSpnir9ggdJRc+jjbqlAt84F3eFbsJXbwRKe8idkV3SWkS7rr6OBo2aIK7bNTwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893802; c=relaxed/simple;
	bh=e0vZ2fA8z2m8h5p3d7ENILv4dKTVa9OBp5a+YnpFg6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWTpVFJXCfPcP0njKUg2k7WZJVk2awH4ZoSCz4taECYefvDMCMzT5a2ncQW4WKW4u6ZxX8iWkGrgDArc++O0GyW1JNM+ac+EmSK7J53Hwd1HYTY3P67XDIyIwoBTr9WFwfrAoOk0RpXzvFSRPgOeUGpxXhDnY2gyQ73SkoyXTCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoSwPWyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoSwPWyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D511F000FF;
	Tue, 13 Oct 2026 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893801;
	bh=fnJE59+E7FC7NoSfmPK7UkSC8Cx5fEJ76Jo4t+HSCUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoSwPWyPy0cx+NLhoYb5Z4Ijcd+NPRwvCW3Z6CUrBz8vtyLbNf5+ZXzD+PSpIYamX
	 J5kMg3x/W2V78oa3l4s53TAJ76DmE/WW+l0RFQ5HfmDQT05S6y/hRLx0+ZnYN8u+Kr
	 BY6vcoZcYq+XEjFqI1rt+xG1fmetKFcEyNgkHMII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 303/621] iommu/dma-iommu: Fix wrong scatterlist length assignment in P2PDMA path
Date: Tue, 13 Oct 2026 13:34:58 +0200
Message-ID: <20261013112928.043805516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 039e84a452d77..9da773ba550ba 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1441,7 +1441,7 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			 */
 			s->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
 						sg_phys(s));
-			sg_dma_len(s) = sg->length;
+			sg_dma_len(s) = s->length;
 			sg_dma_mark_bus_address(s);
 			continue;
 		default:
-- 
2.53.0



