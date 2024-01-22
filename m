Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C50177636;
	Tue, 23 Jan 2024 02:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975508; cv=none; b=dFNZ/51x8DJNyU+qi598FKlUORRF5bFFWy9FEwyHVIrr5Aci72GpY/m2uvDPyVKOIzEAfY/xk0I+9+d7Lk8EfZhVuLR/pgVA9PkPGmVtjHKsLUPhYiiAWBc+ihSsOakvJWXZ7wX+N9IYJekQfWdp6yzS7GCDRIMIEW06Cx47tzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975508; c=relaxed/simple;
	bh=NkQ6rsxyJgyWrVu5rIQ09PtfpS24h+fPdbiGZJvRruc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhpSQLWZHgKlZ0RiC9RYNJQ1w4jydSjTuwh9Jkr7CRI0wLMNpo9OCMDZV5HC6ktKyogInv+unlDVS84JnPRaJ8vw0Ir7lxkoH36huZvLVh19SWh8inlk7jEFA3TSIL+NZa4qfSUvolSzP1x/LCZ1m/HxvSewOCjgJnjKI0pxFDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V32LajgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V32LajgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A86C433C7;
	Tue, 23 Jan 2024 02:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975508;
	bh=NkQ6rsxyJgyWrVu5rIQ09PtfpS24h+fPdbiGZJvRruc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V32LajgIpfPIfk4zkxFzLXm3JRFK9AyLJNoNMYpi1fVhNDj2hf08ophEhro0ZNwPS
	 dC+j6L3Ewm/m0UJr8ymizl4tfSElU1OMYV5HDkyIsPOKEHEHsv6twqfUsJnZbBMINc
	 FXc0FVt30Ihr0KfNtInm/qz7D85GfynYAAfL6NkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Tudor <laurentiu.tudor@nxp.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 460/583] iommu: Map reserved memory as cacheable if device is coherent
Date: Mon, 22 Jan 2024 15:58:31 -0800
Message-ID: <20240122235826.055093138@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit f1aad9df93f39267e890836a28d22511f23474e1 ]

Check if the device is marked as DMA coherent in the DT and if so,
map its reserved memory as cacheable in the IOMMU.
This fixes the recently added IOMMU reserved memory support which
uses IOMMU_RESV_DIRECT without properly building the PROT for the
mapping.

Fixes: a5bf3cfce8cb ("iommu: Implement of_iommu_get_resv_regions()")
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20230926152600.8749-1-laurentiu.tudor@nxp.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/of_iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index 35ba090f3b5e..47302b637cc0 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -260,6 +260,9 @@ void of_iommu_get_resv_regions(struct device *dev, struct list_head *list)
 				phys_addr_t iova;
 				size_t length;
 
+				if (of_dma_is_coherent(dev->of_node))
+					prot |= IOMMU_CACHE;
+
 				maps = of_translate_dma_region(np, maps, &iova, &length);
 				type = iommu_resv_region_get_type(dev, &phys, iova, length);
 
-- 
2.43.0



