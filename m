Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A493C81BE;
	Sat, 17 Oct 2026 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260534; cv=none; b=V/CbJvnhj3Bvgtdtlr1S76kcTXPjJy2b2GCpkSucKfpLbKb/9/WiPqArUmag2GrAjnD24hgNRMGHlUH1/VDEb9RLcH8BMmCSZQtLuw3e2/VTo0cY9WGAbpFQubMO34kI46z5VfTi1DGUpBQksPqYCytWemq4NZQnFX0prCrH/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260534; c=relaxed/simple;
	bh=RPkr/EWO8WZUMMSLEN27MCGUdQwHZPCE68ycMHH6vhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VatEEAtRApaLykmi0gKWX1rk6jQ1hSaGkX4E7HbfcAsJTEg7mGCvwiorSqD56bFKDz5nuJVZskV/HELT+PYz/ooHN0LZ+mDODbVrF5g7Fc1lhsvE5NXYUK9YHCnbkuA+kUN+fT6eUlmPGr1kARahZeasKsyQssiNJTN5ty5t+OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRki6s25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRki6s25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC411F000C4;
	Sat, 17 Oct 2026 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260532;
	bh=uIuqjFRz8ZblYWW4b0knEUKItqQWtfCLhB0I8DF6OYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRki6s2598KLCJLItFiLfM5OXijdyfKrvPdKGMUh4O/lJuByf1GTpaW2IIijOpmYB
	 O2zQdJhSqQACfJYqh31pgfgHJAUYY+eXO7Z4MOd3IFa+eN3iufJJDKWIZSau9RKjN3
	 pDDi4J3xnQh9K3ZR469y3o0a0rh5Xsz0uSBn1rkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1575/1674] iommu: Pass domain to remove_dev_pasid() op
Date: Sat, 17 Oct 2026 18:04:07 +0200
Message-ID: <20261017160511.524154672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit d2f85a263883b679f87ed8f911746105658e9c47 ]

Existing remove_dev_pasid() callbacks of the underlying iommu drivers
get the attached domain from the group->pasid_array. However, the domain
stored in group->pasid_array is not always correct in all scenarios.
A wrong domain may result in failure in remove_dev_pasid() callback.
To avoid such problems, it is more reliable to pass the domain to the
remove_dev_pasid() op.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240328122958.83332-3-yi.l.liu@intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 530f8f9c3546 ("iommu/sva: Set handle->dev before the SVA handle is visible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 ++-------
 drivers/iommu/intel/iommu.c                 | 11 +++--------
 drivers/iommu/iommu.c                       |  9 +++++----
 include/linux/iommu.h                       |  3 ++-
 4 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6f83556dda4d6..2c5e61786b368 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2864,14 +2864,9 @@ static int arm_smmu_def_domain_type(struct device *dev)
 	return 0;
 }
 
-static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
+static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+				      struct iommu_domain *domain)
 {
-	struct iommu_domain *domain;
-
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
-	if (WARN_ON(IS_ERR(domain)) || !domain)
-		return;
-
 	arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
 }
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 53a0ba5badc91..10257548dd7d8 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4722,18 +4722,14 @@ static void intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
 		__mapping_notify_one(info->iommu, dmar_domain, pfn, pages);
 }
 
-static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
+static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *domain)
 {
 	struct intel_iommu *iommu = device_to_iommu(dev, NULL, NULL);
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct dev_pasid_info *curr, *dev_pasid = NULL;
-	struct dmar_domain *dmar_domain;
-	struct iommu_domain *domain;
 	unsigned long flags;
 
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, 0);
-	if (WARN_ON_ONCE(!domain))
-		goto out_tear_down;
-
 	/*
 	 * The SVA implementation needs to handle its own stuffs like the mm
 	 * notification. Before consolidating that code into iommu core, let
@@ -4744,7 +4740,6 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 		goto out_tear_down;
 	}
 
-	dmar_domain = to_dmar_domain(domain);
 	spin_lock_irqsave(&dmar_domain->lock, flags);
 	list_for_each_entry(curr, &dmar_domain->dev_pasids, link_domain) {
 		if (curr->dev == dev && curr->pasid == pasid) {
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3fa5699b9ff19..1927869ddf490 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3407,20 +3407,21 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 
 		if (device == last_gdev)
 			break;
-		ops->remove_dev_pasid(device->dev, pasid);
+		ops->remove_dev_pasid(device->dev, pasid, domain);
 	}
 	return ret;
 }
 
 static void __iommu_remove_group_pasid(struct iommu_group *group,
-				       ioasid_t pasid)
+				       ioasid_t pasid,
+				       struct iommu_domain *domain)
 {
 	struct group_device *device;
 	const struct iommu_ops *ops;
 
 	for_each_group_device(group, device) {
 		ops = dev_iommu_ops(device->dev);
-		ops->remove_dev_pasid(device->dev, pasid);
+		ops->remove_dev_pasid(device->dev, pasid, domain);
 	}
 }
 
@@ -3479,7 +3480,7 @@ void iommu_detach_device_pasid(struct iommu_domain *domain, struct device *dev,
 	struct iommu_group *group = iommu_group_get(dev);
 
 	mutex_lock(&group->mutex);
-	__iommu_remove_group_pasid(group, pasid);
+	__iommu_remove_group_pasid(group, pasid, domain);
 	WARN_ON(xa_erase(&group->pasid_array, pasid) != domain);
 	mutex_unlock(&group->mutex);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b6ef263e85c06..6e5257bf9aeaf 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -289,7 +289,8 @@ struct iommu_ops {
 			     struct iommu_page_response *msg);
 
 	int (*def_domain_type)(struct device *dev);
-	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
+	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid,
+				 struct iommu_domain *domain);
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
-- 
2.53.0



