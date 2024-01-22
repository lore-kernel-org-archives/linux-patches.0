Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86D552F7C;
	Tue, 23 Jan 2024 00:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969935; cv=none; b=IaohGYrlybpl5IecJNRjaRpb12LgHEaKGlxUvFHzgKmGzh1kw9oe15wP09NwLONhs+GZK+J84fOPthvrJKMwrSRkwD31EN6eX4RVBc8mOt30JHFJtkk3c030fEtLS0gmVQWfIhCQLfvkS4Ya4mOJV6870Yx6MDpplYZdCyMuRew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969935; c=relaxed/simple;
	bh=0f+fNcUNF2wpEhC2AyMLwF7POsSjBgfw3hJ1zjnNrZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+A+dSP+g1qDocE3UJ0dJpURCf26VovF1rNrWWSMDKLGwKictAchKWmKLdsBQO+EhQTc8d7I3ZgFY1ggjLT+loAI98bqfveGvV8FJrBRvoYask2nP6vKJOjy1flGyDBi6h+zwthdBYMSef8zFnOFtAYWromjTH28Ny1fi3zvmYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlaLH+db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlaLH+db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62885C433F1;
	Tue, 23 Jan 2024 00:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969935;
	bh=0f+fNcUNF2wpEhC2AyMLwF7POsSjBgfw3hJ1zjnNrZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlaLH+dbo9aFy0D/UkrA3+5Rm3Eeb+KJWfL5kv4G0WCRdk0vGhemvGZ/l3ucR+eRW
	 2hkdPw+ZaV6z0bnxWBsSM5atYN3/x8dw9wCazbwm8PNN1UBpqQMbkz/+dPlRm3adUT
	 Xu7gvkEv5Y679vaNLPBtssC2yx+eaoZDHWrbKSuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Tudor <laurentiu.tudor@nxp.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 506/641] iommu: Map reserved memory as cacheable if device is coherent
Date: Mon, 22 Jan 2024 15:56:50 -0800
Message-ID: <20240122235833.902172301@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



