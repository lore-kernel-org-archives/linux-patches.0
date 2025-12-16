Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0022736CE11;
	Tue, 16 Dec 2025 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888013; cv=none; b=q5YRZd0MKwylnATgaFbKln5lGF7kcum469KdSNFZpfIYftAPhWOZLhwQqtzXWSwXrLOujby5c8lkmPAFuJvWnc7p5Ir1czjWURHY3MeSrQPFUFxeXsQ5D6XbnJzIEFGmSx1/IV/uyflTFCGEQbCF0l1/kxOSEolKWqRrdBTgeyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888013; c=relaxed/simple;
	bh=Ubo7/g7X4eajzUPDdDHFr7y1aW082a34vUEFokxf6Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7DTHjxCSgdjCRwdnmv9DPUFGG1IADwXJnvPIkZutdh/cZALYNwlVKnn0rcfx3Fo5mALY9MhBJ4pdTFvOCboaTpXzLYepIhJovxkgy6DBGZRfFWg000jZzQXaxOxkCE4CLGaDglYg6b4Qd8yO1qWBRAfkjuaD6FhOXju/6Ikj04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdedDTtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdedDTtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6302CC4CEF1;
	Tue, 16 Dec 2025 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888012;
	bh=Ubo7/g7X4eajzUPDdDHFr7y1aW082a34vUEFokxf6Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdedDTtB02AAdKpiLQT7pFMhdwIKoHnxhME+2zvHTH3yr+B01dskKuQMcLyK1Vfx+
	 LnQ7h+D895wRLZBaVvnDbc+ElQec/9V3fpP3wpq+U185ISKp4zug6qV5vi9B4Se8WD
	 7jTLrNv1zhQosw/56oFru8DRWiWB9Y3DMbg4Hs8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mentz <danielmentz@google.com>,
	Ryan Huang <tzukui@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 405/614] iommu/arm-smmu-v3: Fix error check in arm_smmu_alloc_cd_tables
Date: Tue, 16 Dec 2025 12:12:52 +0100
Message-ID: <20251216111416.048846092@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Ryan Huang <tzukui@google.com>

[ Upstream commit 5941f0e0c1e0be03ebc15b461f64208f5250d3d9 ]

In arm_smmu_alloc_cd_tables(), the error check following the
dma_alloc_coherent() for cd_table->l2.l1tab incorrectly tests
cd_table->l2.l2ptrs.

This means an allocation failure for l1tab goes undetected, causing
the function to return 0 (success) erroneously.

Correct the check to test cd_table->l2.l1tab.

Fixes: e3b1be2e73db ("iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg")
Signed-off-by: Daniel Mentz <danielmentz@google.com>
Signed-off-by: Ryan Huang <tzukui@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2a8b46b948f05..9780f40ba3e65 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1464,7 +1464,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->l2.l1tab = dma_alloc_coherent(smmu->dev, l1size,
 							&cd_table->cdtab_dma,
 							GFP_KERNEL);
-		if (!cd_table->l2.l2ptrs) {
+		if (!cd_table->l2.l1tab) {
 			ret = -ENOMEM;
 			goto err_free_l2ptrs;
 		}
-- 
2.51.0



