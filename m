Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAA1F4190;
	Tue,  8 Jul 2025 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993707; cv=none; b=J4rLT9BhtKgdRC0IjsQ3Rn7H1CDK4ZJfw/fw7pPa8hiP/esNXXsDQ341D6X2AT+zTvyj3XsAWHFt0etfzWo7tBSgNQNyQnwKy7s7BYAFpvk3Ieh7MuCUkc+PbpqW2beurxdB3sd14UgHxsVu+hlTla2stsWwUc7Zp4DacNoypD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993707; c=relaxed/simple;
	bh=w+rewtdTbaKTM2kYqtRGB5NMQ7fAMG6BNTvFu2/pqxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRUfkkP0gL5Isk9O9l2W9U7Ve7yHbfChcRUNHYnCysibAOCDKb+nqQm1V2LB7MxP9mrlZ0N5lhZLvFpPaZDNuRUGyc/haWfbWnekpn22zLYnZT5qWv3SKk3MSBP3tAOzqE9zXB60KvgQ5IkFGTToH7KJVpAoKFPJGfTtpb0ajmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vG92nEuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vG92nEuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0D2C4CEED;
	Tue,  8 Jul 2025 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993707;
	bh=w+rewtdTbaKTM2kYqtRGB5NMQ7fAMG6BNTvFu2/pqxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vG92nEuJ9pVY7Kwm4Cxr0MmeS48gXijZzEdH2R4oGUb/Ktg5UZmWgdo9OTYUAqz6M
	 U/uvAR0viseXXEmGyV4F1YW0HMu5X92VwtnLy4x4gQOcb9lfxzW0CQKfvdOllj4SW2
	 rnq7HSu5f0vVauK+ZQPlgqOc1X7RHo3uKyVXrgBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.15 165/178] iommu/vt-d: Assign devtlb cache tag on ATS enablement
Date: Tue,  8 Jul 2025 18:23:22 +0200
Message-ID: <20250708162240.782926763@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 25b1b75bbaf96331750fb01302825069657b2ff8 upstream.

Commit <4f1492efb495> ("iommu/vt-d: Revert ATS timing change to fix boot
failure") placed the enabling of ATS in the probe_finalize callback. This
occurs after the default domain attachment, which is when the ATS cache
tag is assigned. Consequently, the device TLB cache tag is missed when the
domain is attached, leading to the device TLB not being invalidated in the
iommu_unmap paths.

Fix this by assigning the CACHE_TAG_DEVTLB cache tag when ATS is enabled.

Fixes: 4f1492efb495 ("iommu/vt-d: Revert ATS timing change to fix boot failure")
Cc: stable@vger.kernel.org
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20250625050135.3129955-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20250628100351.3198955-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/cache.c |    5 ++---
 drivers/iommu/intel/iommu.c |   11 ++++++++++-
 drivers/iommu/intel/iommu.h |    2 ++
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -40,9 +40,8 @@ static bool cache_tage_match(struct cach
 }
 
 /* Assign a cache tag with specified type to domain. */
-static int cache_tag_assign(struct dmar_domain *domain, u16 did,
-			    struct device *dev, ioasid_t pasid,
-			    enum cache_tag_type type)
+int cache_tag_assign(struct dmar_domain *domain, u16 did, struct device *dev,
+		     ioasid_t pasid, enum cache_tag_type type)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3819,8 +3819,17 @@ static void intel_iommu_probe_finalize(s
 	    !pci_enable_pasid(to_pci_dev(dev), info->pasid_supported & ~1))
 		info->pasid_enabled = 1;
 
-	if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev))
+	if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev)) {
 		iommu_enable_pci_ats(info);
+		/* Assign a DEVTLB cache tag to the default domain. */
+		if (info->ats_enabled && info->domain) {
+			u16 did = domain_id_iommu(info->domain, iommu);
+
+			if (cache_tag_assign(info->domain, did, dev,
+					     IOMMU_NO_PASID, CACHE_TAG_DEVTLB))
+				iommu_disable_pci_ats(info);
+		}
+	}
 	iommu_enable_pci_pri(info);
 }
 
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1277,6 +1277,8 @@ struct cache_tag {
 	unsigned int users;
 };
 
+int cache_tag_assign(struct dmar_domain *domain, u16 did, struct device *dev,
+		     ioasid_t pasid, enum cache_tag_type type);
 int cache_tag_assign_domain(struct dmar_domain *domain,
 			    struct device *dev, ioasid_t pasid);
 void cache_tag_unassign_domain(struct dmar_domain *domain,


