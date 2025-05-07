Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8D28BA9F;
	Wed,  7 May 2025 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644423; cv=none; b=UafnYZm6NU1zx6q61MyawDoY4o7zCVDsSkG3dGerETIwfyHKbWAcRmiOsrbWptLoHfoL/o2J0kHyvqFiWHkYo+IVmXVosGzocnOyqop4sn5yML5X5bRFUK9hj0+PaS0BVtVdSA7IZZZkcBIfzOCCDIQx7x2/NiHCb3uza/HyyNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644423; c=relaxed/simple;
	bh=GKaQS/6YoWjYP/i75u5tYfrmzHzPhzckBxnvWUqQZpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWIQtlMXdu0KOGsrYDjmW4kMg/UJY/l93JGdu+DyRu3pB+bnJUPnhaDQy181JFtJzfZtDOO7NjCnVqBhyZ+EMP2aX8c+jb+zbvAbTTi2f84Sjd1Mhss+DBHgCE7mf21kyPARPQuBnwkUlW4Qeq5jqKJmtYTk4Di1aPSGdaKQpdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6upEQpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6upEQpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8B2C4CEEE;
	Wed,  7 May 2025 19:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644422;
	bh=GKaQS/6YoWjYP/i75u5tYfrmzHzPhzckBxnvWUqQZpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6upEQpKUlGF6GJggzzpcqzFcG2sqky1fA/gEIivcF6EBDAgcyFrB6VE3AR1GMjJx
	 LR5DSE3/A2jkBDxJxAUlMJtHr3OPXY3ERrijnKeWmND8sxeFYOOKkJZna/PS0cZQrU
	 ephewa48G91pzRh/FIgMkNranF2iPI1c15knn54c=
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
Subject: [PATCH 6.12 039/164] iommu/arm-smmu-v3: Fix pgsize_bit for sva domains
Date: Wed,  7 May 2025 20:38:44 +0200
Message-ID: <20250507183822.464893517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -397,6 +397,12 @@ struct iommu_domain *arm_smmu_sva_domain
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


