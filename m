Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE18F178CC5;
	Tue,  8 Oct 2024 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390031; cv=none; b=kU9kin/iEYPDZitVca/lCQN4koH0FO9/MmCZEZ4CxOQcGpv9gmAU7MwVJ69/zpbK/PbjE374KE1+GfFzcNBLv2xMKI6KaTks7biC2Mme6HDVvW/fb1APatEAhmkjmt1lFrcMzCXd1S+xUrCKajGWbqF6jwWKrY3vxjflXVdtdRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390031; c=relaxed/simple;
	bh=5+QhFPf5/682L1trCFJx1jQlebBxiNkeThB5iIWDAHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi7c4Q5MZadxyJXsHNaomd4FCZUewTG28GwbDxyIYQUj/9QMn6Vrae/nuV07jKJmy/g1o0L0o0D3JU2FOcGlj/f2t9Sc3KEDSqqmetfPt9AhWI8RFKtjj0OqI/xnRPt81NpUnSv+Trig2fMt7DtGM3MNhh7Ht7AW9Yr7tcWDDbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQwouqTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQwouqTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58667C4CEC7;
	Tue,  8 Oct 2024 12:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390031;
	bh=5+QhFPf5/682L1trCFJx1jQlebBxiNkeThB5iIWDAHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQwouqTesfJcObOKQ4L/niuErxRVOjji1b57ePG36ooRQ0VRo5k03AJc+voLkbd3R
	 ugLdbM5v5s0zafamDD7B/r93UEoIeKMNJA+aVFGcwRDOVYc0UdRCdQVbIywC6Mo/ge
	 1XDjsqdZq0hoxBQSgKOn7HAHxvhNJ1s6wJ9Z3hSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 170/482] iommu/vt-d: Unconditionally flush device TLB for pasid table updates
Date: Tue,  8 Oct 2024 14:03:53 +0200
Message-ID: <20241008115654.996272091@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index aabcdf7565817..57dd3530f68d4 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -261,9 +261,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 	else
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
-	/* Device IOTLB doesn't need to be flushed in caching mode. */
-	if (!cap_caching_mode(iommu->cap))
-		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	devtlb_invalidation_with_pasid(iommu, dev, pasid);
 }
 
 /*
@@ -490,9 +488,7 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
 
 	iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
-	/* Device IOTLB doesn't need to be flushed in caching mode. */
-	if (!cap_caching_mode(iommu->cap))
-		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	devtlb_invalidation_with_pasid(iommu, dev, pasid);
 
 	return 0;
 }
@@ -569,9 +565,7 @@ void intel_pasid_setup_page_snoop_control(struct intel_iommu *iommu,
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



