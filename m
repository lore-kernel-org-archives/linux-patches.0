Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607E619CD07;
	Tue, 27 May 2025 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366984; cv=none; b=kdQM6oEE3lV2ltU0zEp43EMzRiKRxt10KnTNFLxKTYjhJJcOdjRrdjGX3VJl8e4YUj76w/I/dvtmzmlIcYFBefo5TXPWbO3xWE9iTZ+n6iDarqn1mj6B4Vet2ZAsaReVyP5fpqDdUD1ngv/iWGdNS2HgOTS1N4oO7du7MAOij+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366984; c=relaxed/simple;
	bh=daGKeNi8mBWo6EYlRu2M+soDyy2T81AD7PagZIZ4oTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHl1CsrUEWlSPy23s2OSegSHCBzdYDt64LEQkrVeQqe9JsmE6x9MI5nF6gEm4lEykv+XRiPYRF4eyE/Cb22cU9UbRIQvaDxWsxFRfxI0nLb1WuL9mWSh9QuWMjnU8Uw8yE4Oa5aMoNuih0Gp/ds8EPsVyce9mXYIFx/Y+igyeJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpkYNdfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpkYNdfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9712C4CEE9;
	Tue, 27 May 2025 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366984;
	bh=daGKeNi8mBWo6EYlRu2M+soDyy2T81AD7PagZIZ4oTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpkYNdfLE+Ea3PLhkk9DS1DYny993XNOnXqQGAuLiPLOZJoMTjV0WpGWTElaPCJG0
	 qbuFq/f6j/Y0V4uF7PH4AGaBqTteA7jw7x+jQTSeQ72v2VkfU+7iPJeC68euwmtG+J
	 wHyTSqmzMxqKMWbpmq4vanZp6RRWCv3HQI5OWQWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 240/783] iommu/vt-d: Check if SVA is supported when attaching the SVA domain
Date: Tue, 27 May 2025 18:20:37 +0200
Message-ID: <20250527162522.887504454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 607ba1bb096110751f6aa4b46666e0ba024ab3c2 ]

Attach of a SVA domain should fail if SVA is not supported, move the check
for SVA support out of IOMMU_DEV_FEAT_SVA and into attach.

Also check when allocating a SVA domain to match other drivers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://lore.kernel.org/r/20250228092631.3425464-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c |   37 +------------------------------------
 drivers/iommu/intel/svm.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 36 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3863,41 +3863,6 @@ static struct iommu_group *intel_iommu_d
 	return generic_device_group(dev);
 }
 
-static int intel_iommu_enable_sva(struct device *dev)
-{
-	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	struct intel_iommu *iommu;
-
-	if (!info || dmar_disabled)
-		return -EINVAL;
-
-	iommu = info->iommu;
-	if (!iommu)
-		return -EINVAL;
-
-	if (!(iommu->flags & VTD_FLAG_SVM_CAPABLE))
-		return -ENODEV;
-
-	if (!info->pasid_enabled || !info->ats_enabled)
-		return -EINVAL;
-
-	/*
-	 * Devices having device-specific I/O fault handling should not
-	 * support PCI/PRI. The IOMMU side has no means to check the
-	 * capability of device-specific IOPF.  Therefore, IOMMU can only
-	 * default that if the device driver enables SVA on a non-PRI
-	 * device, it will handle IOPF in its own way.
-	 */
-	if (!info->pri_supported)
-		return 0;
-
-	/* Devices supporting PRI should have it enabled. */
-	if (!info->pri_enabled)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int context_flip_pri(struct device_domain_info *info, bool enable)
 {
 	struct intel_iommu *iommu = info->iommu;
@@ -4018,7 +3983,7 @@ intel_iommu_dev_enable_feat(struct devic
 		return intel_iommu_enable_iopf(dev);
 
 	case IOMMU_DEV_FEAT_SVA:
-		return intel_iommu_enable_sva(dev);
+		return 0;
 
 	default:
 		return -ENODEV;
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -110,6 +110,41 @@ static const struct mmu_notifier_ops int
 	.free_notifier = intel_mm_free_notifier,
 };
 
+static int intel_iommu_sva_supported(struct device *dev)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct intel_iommu *iommu;
+
+	if (!info || dmar_disabled)
+		return -EINVAL;
+
+	iommu = info->iommu;
+	if (!iommu)
+		return -EINVAL;
+
+	if (!(iommu->flags & VTD_FLAG_SVM_CAPABLE))
+		return -ENODEV;
+
+	if (!info->pasid_enabled || !info->ats_enabled)
+		return -EINVAL;
+
+	/*
+	 * Devices having device-specific I/O fault handling should not
+	 * support PCI/PRI. The IOMMU side has no means to check the
+	 * capability of device-specific IOPF.  Therefore, IOMMU can only
+	 * default that if the device driver enables SVA on a non-PRI
+	 * device, it will handle IOPF in its own way.
+	 */
+	if (!info->pri_supported)
+		return 0;
+
+	/* Devices supporting PRI should have it enabled. */
+	if (!info->pri_enabled)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t pasid,
 				   struct iommu_domain *old)
@@ -121,6 +156,10 @@ static int intel_svm_set_dev_pasid(struc
 	unsigned long sflags;
 	int ret = 0;
 
+	ret = intel_iommu_sva_supported(dev);
+	if (ret)
+		return ret;
+
 	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
 	if (IS_ERR(dev_pasid))
 		return PTR_ERR(dev_pasid);
@@ -161,6 +200,10 @@ struct iommu_domain *intel_svm_domain_al
 	struct dmar_domain *domain;
 	int ret;
 
+	ret = intel_iommu_sva_supported(dev);
+	if (ret)
+		return ERR_PTR(ret);
+
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
 		return ERR_PTR(-ENOMEM);


