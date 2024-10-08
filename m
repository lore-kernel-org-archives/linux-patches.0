Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517C21C2420;
	Tue,  8 Oct 2024 12:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391717; cv=none; b=VgRwbUvK2PNxJCZDnUAKH/to3djBJEbxRiEWAv6QCFA/ep75fUWM64N5jQW/JZ2mU6GfJRnWJdT4H2jjB0cZ6sSCzdM7aspOkS+sm5JeuNlfv+ewT/BLe9XQhoOlhCg9WCkuLh6s7UGyN1AlRMHyYdW1dBlaF6L0ImQ/rWqBrtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391717; c=relaxed/simple;
	bh=B2GmBiJfAOfwIPmGFwnTRN0tEWlmW8hvYQAqGbYxhl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwsIm8dry4C9RrOied2LO2Zad+Pcjqx1KqR+7bwpyKLIpuVTAGbG0YkHHfGqu6sZPbFcqt/Kp5PaFC63HehEru9fi7IjEyin3hrsINoyak6t7PvwO0QhUPlUasdwVGzRKrOeTsvj2R11RmcTmo6r7ZxDFjEHgav1nMTk1grvR9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15OQZYaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15OQZYaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC35C4CEC7;
	Tue,  8 Oct 2024 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391717;
	bh=B2GmBiJfAOfwIPmGFwnTRN0tEWlmW8hvYQAqGbYxhl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15OQZYafrvEzTnYZv1mqkmNnBczZLVmGSLyAtb7tJI58RmG/tyuRZeNWvSdre+4fy
	 dh3ZcUPSQNTzObgs1pRA6+o9L9fmwZrNde8+jyluRZCl1eK9iH64lUr2moAgXWjgrN
	 T3HVP+307ZEQxU+3BHz5ZkopMhdkWHKE/Ieoz9fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 200/558] iommu/arm-smmu-v3: Do not use devm for the cd table allocations
Date: Tue,  8 Oct 2024 14:03:50 +0200
Message-ID: <20241008115710.218531256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 47b2de35cab2b683f69d03515c2658c2d8515323 ]

The master->cd_table is entirely contained within the struct
arm_smmu_master which is guaranteed to be freed by the core code under
arm_smmu_release_device().

There is no reason to use devm here, arm_smmu_free_cd_tables() is reliably
called to free the CD related memory. Remove it and save some memory.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/5-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 +++++++++------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d271525fa3917..473eb772ea210 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1185,8 +1185,8 @@ static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
 {
 	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
 
-	l1_desc->l2ptr = dmam_alloc_coherent(smmu->dev, size,
-					     &l1_desc->l2ptr_dma, GFP_KERNEL);
+	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
+					    &l1_desc->l2ptr_dma, GFP_KERNEL);
 	if (!l1_desc->l2ptr) {
 		dev_warn(smmu->dev,
 			 "failed to allocate context descriptor table\n");
@@ -1400,17 +1400,17 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
 						  CTXDESC_L2_ENTRIES);
 
-		cd_table->l1_desc = devm_kcalloc(smmu->dev, cd_table->num_l1_ents,
-					      sizeof(*cd_table->l1_desc),
-					      GFP_KERNEL);
+		cd_table->l1_desc = kcalloc(cd_table->num_l1_ents,
+					    sizeof(*cd_table->l1_desc),
+					    GFP_KERNEL);
 		if (!cd_table->l1_desc)
 			return -ENOMEM;
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
 	}
 
-	cd_table->cdtab = dmam_alloc_coherent(smmu->dev, l1size, &cd_table->cdtab_dma,
-					   GFP_KERNEL);
+	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
+					     &cd_table->cdtab_dma, GFP_KERNEL);
 	if (!cd_table->cdtab) {
 		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
 		ret = -ENOMEM;
@@ -1421,7 +1421,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 
 err_free_l1:
 	if (cd_table->l1_desc) {
-		devm_kfree(smmu->dev, cd_table->l1_desc);
+		kfree(cd_table->l1_desc);
 		cd_table->l1_desc = NULL;
 	}
 	return ret;
@@ -1441,21 +1441,18 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 			if (!cd_table->l1_desc[i].l2ptr)
 				continue;
 
-			dmam_free_coherent(smmu->dev, size,
-					   cd_table->l1_desc[i].l2ptr,
-					   cd_table->l1_desc[i].l2ptr_dma);
+			dma_free_coherent(smmu->dev, size,
+					  cd_table->l1_desc[i].l2ptr,
+					  cd_table->l1_desc[i].l2ptr_dma);
 		}
-		devm_kfree(smmu->dev, cd_table->l1_desc);
-		cd_table->l1_desc = NULL;
+		kfree(cd_table->l1_desc);
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
 	} else {
 		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
 	}
 
-	dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
-	cd_table->cdtab_dma = 0;
-	cd_table->cdtab = NULL;
+	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
 }
 
 /* Stream table manipulation functions */
-- 
2.43.0



