Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D9B1FECB9;
	Wed,  5 Feb 2025 14:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767018; cv=none; b=YxGJnzKIzSIzzdXs3GmDmNcdSUHqgiclZMcfCeciV/UJFTNxSgkKfYykE63pXe/g3Mj1NZebJbNGZzPEtras64FQfcQTZO0NzSKZ0+uETO3quxqpWVujPXJnuYJ7OVXjuFzar+EYwV+1WQYCeUIh6+o3IbMz59In6cF+bIz5Ogw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767018; c=relaxed/simple;
	bh=YqeBScewC32V41dnUitZ36JQbiVbVX5Q0k9FUeP7y/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avh6U5lVI0cMQcOPLge/Ck2sx3RasCSwkhsrDFb+CwPAnqnTZH7XtGAOuy5cvMpf7+ZNBTHNeigiEvTe+fW8POLoKH+ckwlvZNXn5fxy50kU9mu5g6kvqNJpi5oxaKQP48X1Z53GAY7Y86XuopESlHbBc63sTE3scwGWRp6Z104=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQ8AL5AY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQ8AL5AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16F4C4CED1;
	Wed,  5 Feb 2025 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767017;
	bh=YqeBScewC32V41dnUitZ36JQbiVbVX5Q0k9FUeP7y/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQ8AL5AYSXnIHIBcfuiiyjTxpUdDhI8IYwjwg9iD7O3onyUG+WviPDRO7tTZabIaI
	 CqQBGCo6mL8clT4HAtCyhQ+5Zc0xaODchvUa1IW1F1t3eTsQV34AgWn7k2xv08Q1Kc
	 1TCeTEACg88CR6hluJN+/Eyzg4xJf7oZdwhAv94I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 319/623] iommu/amd: Fully decode all combinations of alloc_paging_flags
Date: Wed,  5 Feb 2025 14:41:01 +0100
Message-ID: <20250205134508.426471793@linuxfoundation.org>
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

[ Upstream commit 082f1bcae8d1b5f76e92e369091176b8d61120ec ]

Currently AMD does not support
 IOMMU_HWPT_ALLOC_PASID | IOMMU_HWPT_ALLOC_DIRTY_TRACKING

It should be rejected. Instead it creates a V1 domain without dirty
tracking support.

Use a switch to fully decode the flags.

Fixes: ce2cd175469f ("iommu/amd: Enhance amd_iommu_domain_alloc_user()")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/7-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e0c12dc44340c..80b2c9eb438f2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2379,24 +2379,24 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 	if ((flags & ~supported_flags) || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	/* Allocate domain with v2 page table if IOMMU supports PASID. */
-	if (flags & IOMMU_HWPT_ALLOC_PASID) {
+	switch (flags & supported_flags) {
+	case IOMMU_HWPT_ALLOC_DIRTY_TRACKING:
+		/* Allocate domain with v1 page table for dirty tracking */
+		if (!amd_iommu_hd_support(iommu))
+			break;
+		return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
+	case IOMMU_HWPT_ALLOC_PASID:
+		/* Allocate domain with v2 page table if IOMMU supports PASID. */
 		if (!amd_iommu_pasid_supported())
-			return ERR_PTR(-EOPNOTSUPP);
-
+			break;
 		return do_iommu_domain_alloc(dev, flags, PD_MODE_V2);
+	case 0:
+		/* If nothing specific is required use the kernel commandline default */
+		return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
+	default:
+		break;
 	}
-
-	/* Allocate domain with v1 page table for dirty tracking */
-	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
-		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
-
-		return ERR_PTR(-EOPNOTSUPP);
-	}
-
-	/* If nothing specific is required use the kernel commandline default */
-	return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
+	return ERR_PTR(-EOPNOTSUPP);
 }
 
 void amd_iommu_domain_free(struct iommu_domain *dom)
-- 
2.39.5



