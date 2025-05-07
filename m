Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DE42144CC;
	Wed,  7 May 2025 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643843; cv=none; b=iEBeo/E6o6xj0ZbstMQ8cm0SvxvGAsBHi6Xk1Rf897s2zAc/rU2WW/lBYCKGwfj0qnYvRT8h5C811lK9vepZ+mHEGYZmHdthedglTyDJOl/n0WzYIcLdXMMJvkc2IjK1zoutwuL3vE1umotpEKduEiOl3DYcwQ1kZgpK8OyuJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643843; c=relaxed/simple;
	bh=4Y3uVw4y0m88bOkG9eMeFudiV2/w0pdKT4+41tvvLPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heP2nf5TOTQI3tci15FK0x6zEcVhMODhKSqCIVM4GnvT9ey+ok0p7f5w2e2i4aGLz3zdbQ2aiVD97xivQWU9O4VvDXgEFTLDBlUJtglQOIBYlJ1QJ/T20qhH3bb/vFGuGx0rMs0Nd5i/pZDp71+z/fjCafLiLz7RF/jdThD1If8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7y/7UCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7y/7UCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6C1C4CEE2;
	Wed,  7 May 2025 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643843;
	bh=4Y3uVw4y0m88bOkG9eMeFudiV2/w0pdKT4+41tvvLPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7y/7UCj5diEXhsSnpS7EUEpPX3EQUhblTLEvnMcW8XuZQ0jCx50ourCUPuhfpElw
	 5V4TKOD/v5SHBDc8OvTgJgQevD8ucdap60XVFjWGN0N5DwPwZpZKWkiWUkU4Cni11C
	 3r/5mSXunDHC4+7M3wnSIoxuA55LO91MCNexCNiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 6.14 035/183] iommu/arm-smmu-v3: Fix pgsize_bit for sva domains
Date: Wed,  7 May 2025 20:38:00 +0200
Message-ID: <20250507183826.108652992@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balbir Singh <balbirs@nvidia.com>

commit 12f78021973ae422564b234136c702a305932d73 upstream.

UBSan caught a bug with IOMMU SVA domains, where the reported exponent
value in __arm_smmu_tlb_inv_range() was >= 64.
__arm_smmu_tlb_inv_range() uses the domain's pgsize_bitmap to compute
the number of pages to invalidate and the invalidation range. Currently
arm_smmu_sva_domain_alloc() does not setup the iommu domain's
pgsize_bitmap. This leads to __ffs() on the value returning 64 and that
leads to undefined behaviour w.r.t. shift operations

Fix this by initializing the iommu_domain's pgsize_bitmap to PAGE_SIZE.
Effectively the code needs to use the smallest page size for
invalidation

Cc: stable@vger.kernel.org
Fixes: eb6c97647be2 ("iommu/arm-smmu-v3: Avoid constructing invalid range commands")
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250412002354.3071449-1-balbirs@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -411,6 +411,12 @@ struct iommu_domain *arm_smmu_sva_domain
 		return ERR_CAST(smmu_domain);
 	smmu_domain->domain.type = IOMMU_DOMAIN_SVA;
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+
+	/*
+	 * Choose page_size as the leaf page size for invalidation when
+	 * ARM_SMMU_FEAT_RANGE_INV is present
+	 */
+	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
 	smmu_domain->smmu = smmu;
 
 	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,


