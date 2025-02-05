Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0425818E377;
	Wed,  5 Feb 2025 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767027; cv=none; b=CBJAtHdcMEv/vMarbKsf53j4Rf8ouXzClnIelLeDYfvXC/19/G1xkFUsBzJ+wZ/JArnJhsmmsnr38CyAGo+XR/1e8S9aA7EkL5HhJeNAtN++jcmKHaK9yuJmLvudeIqyMoNMt1Z8GvjUqcjU4StK8G37g20p7GknbM5Q82cFUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767027; c=relaxed/simple;
	bh=7st6haTkXdW/YMMY2xolQbnx80c5i2eoqAYxZd2BXqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbUezwM7mUsyFSfNgWnKaeFYZJn3M+UZLcqsHAKmo7JMMPxqWF8r8Sm5LPhTHrIiEW/cDBOr2yEJ1UjesDdAK3BEBIjcWiaVh1pn5/fStcgoBxC4uAGSNFI75fumlh1Jz2F5n9yoiuwh8CLh0EoFr09itpKt/OgeRevVnuZABwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVTf525G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVTf525G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76960C4CED1;
	Wed,  5 Feb 2025 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767026;
	bh=7st6haTkXdW/YMMY2xolQbnx80c5i2eoqAYxZd2BXqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVTf525G01oqOtcmBG/vVBFCwPbepMadrLOuijfW3D1aI30ne4Fv/CX64lrMVo8Q4
	 TGampONn6xhEQ9ve6bKNofloOgPdNrJ6E1KJJjqop5VL+Kjp8utecks33uZOX542Nq
	 D+9RAaU4lrrc/eugnFm8byjBlgEPF+oow9VGKVlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 315/623] iommu/amd: Remove domain_alloc()
Date: Wed,  5 Feb 2025 14:40:57 +0100
Message-ID: <20250205134508.273837220@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f9b80f941e0e68c3347c5d22a17a0f636a064e2c ]

IOMMU drivers should not be sensitive to the domain type, a paging domain
should be created based only on the flags passed in, the same for all
callers.

AMD was using the domain_alloc() path to force VFIO into a v1 domain type,
because v1 gives higher performance. However now that
IOMMU_HWPT_ALLOC_PASID is present, and a NULL device is not possible,
domain_alloc_paging_flags() will do the right thing for VFIO.

When invoked from VFIO flags will be 0 and the amd_iommu_pgtable type of
domain will be selected. This is v1 by default unless the kernel command
line has overridden it to v2.

If the admin is forcing v2 assume they know what they are doing so force
it everywhere, including for VFIO.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/2-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 082f1bcae8d1 ("iommu/amd: Fully decode all combinations of alloc_paging_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 7e7246c49006a..96d87406f8946 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2386,25 +2386,6 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	return &domain->domain;
 }
 
-static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
-{
-	struct iommu_domain *domain;
-	int pgtable = amd_iommu_pgtable;
-
-	/*
-	 * Force IOMMU v1 page table when allocating
-	 * domain for pass-through devices.
-	 */
-	if (type == IOMMU_DOMAIN_UNMANAGED)
-		pgtable = AMD_IOMMU_V1;
-
-	domain = do_iommu_domain_alloc(type, NULL, 0, pgtable);
-	if (IS_ERR(domain))
-		return NULL;
-
-	return domain;
-}
-
 static struct iommu_domain *
 amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 				    const struct iommu_user_data *user_data)
@@ -2881,7 +2862,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.blocked_domain = &blocked_domain,
 	.release_domain = &release_domain,
 	.identity_domain = &identity_domain.domain,
-	.domain_alloc = amd_iommu_domain_alloc,
 	.domain_alloc_paging_flags = amd_iommu_domain_alloc_paging_flags,
 	.domain_alloc_sva = amd_iommu_domain_alloc_sva,
 	.probe_device = amd_iommu_probe_device,
-- 
2.39.5



