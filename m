Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFA71C4613;
	Tue,  8 Oct 2024 12:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391710; cv=none; b=UNk7cnCZgH5pv/2ESDBvk+FQIPLdH2BBfbp/CW/WBByHq+vi2LKmW7xd6TBuhZMc7sKLYAW1WUEOQ/42lR1+PAA9KEuAmif6cdo5/MW2L4vs39mtmYtvrdgB+sXZZr3qevCbfZxbadoV9yxuwH9VzMxNs7I9zXRt4odbHQikdCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391710; c=relaxed/simple;
	bh=80W4X3c5pJ1ZcEkz04XqagF8s65vfRafQ/8UpMnTfSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6yc1wkHXeHIWYAk05b2NFVAMY7g5SB4wAoGI4XS+V843YNooBUzRxh2UUeD72Vt7U9boPQqsHzLV9l2ATvqoerrXmnxzOeh+TjOiKorD7C5+TjThmQtHcDZ9jpqXZPHaqisUCg9E3yAsO7X8Hkq2Us8Lr1JqiI94ziLOA9ujss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8D1OnVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8D1OnVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F12C4CEC7;
	Tue,  8 Oct 2024 12:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391710;
	bh=80W4X3c5pJ1ZcEkz04XqagF8s65vfRafQ/8UpMnTfSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8D1OnVeuMaJrPbYdgTgv+N9QqoycfYLaCDbbgJL6gQ51yoJopa+aNDA2s3Im1SmF
	 mXxEGJVvYjbuRUDtPGQrr++1QUZ9jBh8Ed+v/ooczD9vXXSK1uadB4V1/GFqyEM+It
	 BrUgNTKqW82xrXEvFT/WiMMWuQ1bzn070zs8f11Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 199/558] iommu/vt-d: Unconditionally flush device TLB for pasid table updates
Date: Tue,  8 Oct 2024 14:03:49 +0200
Message-ID: <20241008115710.179551908@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 1f5e307ca16c0c19186cbd56ac460a687e6daba0 ]

The caching mode of an IOMMU is irrelevant to the behavior of the device
TLB. Previously, commit <304b3bde24b5> ("iommu/vt-d: Remove caching mode
check before device TLB flush") removed this redundant check in the
domain unmap path.

Checking the caching mode before flushing the device TLB after a pasid
table entry is updated is unnecessary and can lead to inconsistent
behavior.

Extends this consistency by removing the caching mode check in the pasid
table update path.

Suggested-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20240820030208.20020-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index b51fc268dc845..2e5fa0a232999 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -264,9 +264,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 	else
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
-	/* Device IOTLB doesn't need to be flushed in caching mode. */
-	if (!cap_caching_mode(iommu->cap))
-		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	devtlb_invalidation_with_pasid(iommu, dev, pasid);
 }
 
 /*
@@ -493,9 +491,7 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
 
 	iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
-	/* Device IOTLB doesn't need to be flushed in caching mode. */
-	if (!cap_caching_mode(iommu->cap))
-		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	devtlb_invalidation_with_pasid(iommu, dev, pasid);
 
 	return 0;
 }
@@ -572,9 +568,7 @@ void intel_pasid_setup_page_snoop_control(struct intel_iommu *iommu,
 	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
 	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
 
-	/* Device IOTLB doesn't need to be flushed in caching mode. */
-	if (!cap_caching_mode(iommu->cap))
-		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	devtlb_invalidation_with_pasid(iommu, dev, pasid);
 }
 
 /**
-- 
2.43.0



