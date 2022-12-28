Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054CA1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA03C433EF;
	Wed, 28 Dec 2022 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242094;
	bh=7X3EPHkrS1AJxEX5e9jWv5DSJfhPuqDUQ+9HC7IiKVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUVsCep0cJFB16a2QmAuLaYoV72nC08Cv685ggLod519Gw7H0RPUUCIZYthYcOUW/
	 nSlMIkyt95+c4mKXZxSKPqVr6cQ3l50wT6saZVPLWb6ZrCba0Lgv4tuwvVR+RppQ6P
	 ueUAH2WIUGoLqtx7zswIV9TfRJmKRVEh5Q5NeW48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 562/731] iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY
Date: Wed, 28 Dec 2022 15:41:09 +0100
Message-Id: <20221228144312.854540737@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit ef5bb8e7a7127218f826b9ccdf7508e7a339f4c2 ]

This driver treats IOMMU_DOMAIN_IDENTITY the same as UNMANAGED, which
cannot possibly be correct.

UNMANAGED domains are required to start out blocking all DMAs. This seems
to be what this driver does as it allocates a first level 'dt' for the IO
page table that is 0 filled.

Thus UNMANAGED looks like a working IO page table, and so IDENTITY must be
a mistake. Remove it.

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/0-v1-97f0adf27b5e+1f0-s50_identity_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index ece3d4b4d7ca..ed3574195599 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -602,7 +602,6 @@ static struct iommu_domain *sun50i_iommu_domain_alloc(unsigned type)
 	struct sun50i_iommu_domain *sun50i_domain;
 
 	if (type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY &&
 	    type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
-- 
2.35.1



