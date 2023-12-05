Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689F2A59;
	Tue,  5 Dec 2023 03:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Giahgqky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DD1C433C7;
	Tue,  5 Dec 2023 03:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747237;
	bh=OX2CFc6Rr92CXjiTGYN0G3iLXo9x0HtQhZshxTs0rl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiahgqkycKiMn0VK22SD96rmo88Lw1vO0/ThU0fpmCk+pIKSkpvo+1ZN7amp+A0ic
	 gWwroFSX1UpYo5kgM9VpWu8Rsz5nYsxyT9IHfdBNNilvo5nQ9PwGf0qRNMfoxyeV0n
	 p4NHKiHrFDwwpdKa1CxckpOiLddzAxE1VoebS9ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/107] iommu/vt-d: Add device_block_translation() helper
Date: Tue,  5 Dec 2023 12:17:07 +0900
Message-ID: <20231205031537.467953261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c7be17c2903d4acbf9aa372bfb6e2a418387fce0 ]

If domain attaching to device fails, the IOMMU driver should bring the
device to blocking DMA state. The upper layer is expected to recover it
by attaching a new domain. Use device_block_translation() in the error
path of dev_attach to make the behavior specific.

The difference between device_block_translation() and the previous
dmar_remove_one_dev_info() is that, in the scalable mode, it is the
RID2PASID entry instead of context entry being cleared. As a result,
enabling PCI capabilities is moved up.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20221118132451.114406-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: da37dddcf4ca ("iommu/vt-d: Disable PCI ATS in legacy passthrough mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 44 ++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3dbf86c61f073..de76272d0fb02 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -277,7 +277,7 @@ static LIST_HEAD(dmar_satc_units);
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
-static void dmar_remove_one_dev_info(struct device *dev);
+static void device_block_translation(struct device *dev);
 
 int dmar_disabled = !IS_ENABLED(CONFIG_INTEL_IOMMU_DEFAULT_ON);
 int intel_iommu_sm = IS_ENABLED(CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON);
@@ -1418,7 +1418,7 @@ static void iommu_enable_pci_caps(struct device_domain_info *info)
 {
 	struct pci_dev *pdev;
 
-	if (!info || !dev_is_pci(info->dev))
+	if (!dev_is_pci(info->dev))
 		return;
 
 	pdev = to_pci_dev(info->dev);
@@ -2064,7 +2064,6 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	} else {
 		iommu_flush_write_buffer(iommu);
 	}
-	iommu_enable_pci_caps(info);
 
 	ret = 0;
 
@@ -2506,7 +2505,7 @@ static int domain_add_dev_info(struct dmar_domain *domain, struct device *dev)
 					dev, PASID_RID2PASID);
 		if (ret) {
 			dev_err(dev, "Setup RID2PASID failed\n");
-			dmar_remove_one_dev_info(dev);
+			device_block_translation(dev);
 			return ret;
 		}
 	}
@@ -2514,10 +2513,12 @@ static int domain_add_dev_info(struct dmar_domain *domain, struct device *dev)
 	ret = domain_context_mapping(domain, dev);
 	if (ret) {
 		dev_err(dev, "Domain context map failed\n");
-		dmar_remove_one_dev_info(dev);
+		device_block_translation(dev);
 		return ret;
 	}
 
+	iommu_enable_pci_caps(info);
+
 	return 0;
 }
 
@@ -4115,6 +4116,37 @@ static void dmar_remove_one_dev_info(struct device *dev)
 	info->domain = NULL;
 }
 
+/*
+ * Clear the page table pointer in context or pasid table entries so that
+ * all DMA requests without PASID from the device are blocked. If the page
+ * table has been set, clean up the data structures.
+ */
+static void device_block_translation(struct device *dev)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct intel_iommu *iommu = info->iommu;
+	unsigned long flags;
+
+	iommu_disable_dev_iotlb(info);
+	if (!dev_is_real_dma_subdevice(dev)) {
+		if (sm_supported(iommu))
+			intel_pasid_tear_down_entry(iommu, dev,
+						    PASID_RID2PASID, false);
+		else
+			domain_context_clear(info);
+	}
+
+	if (!info->domain)
+		return;
+
+	spin_lock_irqsave(&info->domain->lock, flags);
+	list_del(&info->link);
+	spin_unlock_irqrestore(&info->domain->lock, flags);
+
+	domain_detach_iommu(info->domain, iommu);
+	info->domain = NULL;
+}
+
 static int md_domain_init(struct dmar_domain *domain, int guest_width)
 {
 	int adjust_width;
@@ -4238,7 +4270,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 		struct device_domain_info *info = dev_iommu_priv_get(dev);
 
 		if (info->domain)
-			dmar_remove_one_dev_info(dev);
+			device_block_translation(dev);
 	}
 
 	ret = prepare_domain_attach_device(domain, dev);
-- 
2.42.0



