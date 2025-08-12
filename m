Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D442F5E;
	Tue, 12 Aug 2025 18:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023909; cv=none; b=cRQpcGF39R8JlStL9Q1D536l6ArZJvVHRJjc/strnPte0d2/3YXn2z7TKNFInRLBCeNCIRzi+EsEE/NVP3FeP+IAUIKMcLB3TvSho4TSeeILqou/Yp6pl/zO1WjZNlN2U5aeDk667iXi6s+yQFlh8+rtfyN99FZR4pha0iFZJe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023909; c=relaxed/simple;
	bh=2SxhUKJ6DBVARi6ybYmk8pgckoLN+CCwTopYmnW3Zu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4Yow0VRW6PAG0oIk1alKbWT70eePTxyOPnOxcT+FhgXZxksRZXYS0dCrH/6UTfZX2HI12KHqWKIGPEif7P8R75m0wmfNmssVdBpCeuVNjLSqCTXfvhLmkLAnnRbCiSN/U31g6+oNheqO1rZcjM40vKEx4HZgV9muXoBbArGjBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSksD51/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSksD51/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D834C4CEF0;
	Tue, 12 Aug 2025 18:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023909;
	bh=2SxhUKJ6DBVARi6ybYmk8pgckoLN+CCwTopYmnW3Zu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSksD51/BYokFTe//C8zAuTuljSE0Mauq7IEZSTAzn4X3DuQzwTL/H4+fZOae+r4G
	 UeXYl6WRq8xXvnjnx3I2NNbXbKXJdY3cLRIq6kDsEjFTByg8D6sLI+KbR2M8sGR05m
	 UzSafMsaJlOWaE4gaZRO/Y6C3iHSiak3FLri8snU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Milon <ethan.milon@eviden.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 218/627] iommu/vt-d: Fix missing PASID in dev TLB flush with cache_tag_flush_all
Date: Tue, 12 Aug 2025 19:28:33 +0200
Message-ID: <20250812173427.575947955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Milon <ethan.milon@eviden.com>

[ Upstream commit 3141153816bf4f0257747bd4dda176d38f1a9a49 ]

The function cache_tag_flush_all() was originally implemented with
incorrect device TLB invalidation logic that does not handle PASID, in
commit c4d27ffaa8eb ("iommu/vt-d: Add cache tag invalidation helpers")

This causes regressions where full address space TLB invalidations occur
with a PASID attached, such as during transparent hugepage unmapping in
SVA configurations or when calling iommu_flush_iotlb_all(). In these
cases, the device receives a TLB invalidation that lacks PASID.

This incorrect logic was later extracted into
cache_tag_flush_devtlb_all(), in commit 3297d047cd7f ("iommu/vt-d:
Refactor IOTLB and Dev-IOTLB flush for batching")

The fix replaces the call to cache_tag_flush_devtlb_all() with
cache_tag_flush_devtlb_psi(), which properly handles PASID.

Fixes: 4f609dbff51b ("iommu/vt-d: Use cache helpers in arch_invalidate_secondary_tlbs")
Fixes: 4e589a53685c ("iommu/vt-d: Use cache_tag_flush_all() in flush_iotlb_all")
Signed-off-by: Ethan Milon <ethan.milon@eviden.com>
Link: https://lore.kernel.org/r/20250708214821.30967-1-ethan.milon@eviden.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20250714045028.958850-11-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/cache.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 47692cbfaabd..c8b79de84d3f 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -422,22 +422,6 @@ static void cache_tag_flush_devtlb_psi(struct dmar_domain *domain, struct cache_
 					     domain->qi_batch);
 }
 
-static void cache_tag_flush_devtlb_all(struct dmar_domain *domain, struct cache_tag *tag)
-{
-	struct intel_iommu *iommu = tag->iommu;
-	struct device_domain_info *info;
-	u16 sid;
-
-	info = dev_iommu_priv_get(tag->dev);
-	sid = PCI_DEVID(info->bus, info->devfn);
-
-	qi_batch_add_dev_iotlb(iommu, sid, info->pfsid, info->ats_qdep, 0,
-			       MAX_AGAW_PFN_WIDTH, domain->qi_batch);
-	if (info->dtlb_extra_inval)
-		qi_batch_add_dev_iotlb(iommu, sid, info->pfsid, info->ats_qdep, 0,
-				       MAX_AGAW_PFN_WIDTH, domain->qi_batch);
-}
-
 /*
  * Invalidates a range of IOVA from @start (inclusive) to @end (inclusive)
  * when the memory mappings in the target domain have been modified.
@@ -508,7 +492,7 @@ void cache_tag_flush_all(struct dmar_domain *domain)
 			break;
 		case CACHE_TAG_DEVTLB:
 		case CACHE_TAG_NESTING_DEVTLB:
-			cache_tag_flush_devtlb_all(domain, tag);
+			cache_tag_flush_devtlb_psi(domain, tag, 0, MAX_AGAW_PFN_WIDTH);
 			break;
 		}
 
-- 
2.39.5



