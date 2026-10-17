Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718F1387373;
	Sat, 17 Oct 2026 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255025; cv=none; b=m68F6H3zKphpLWIYUlvDrQpGMhs/zZoztQofRw3tslwqUY4VGFRd0IlpdEmXtp96CyPM+Ro0GsgYuou5oRx0o9GxfQLDa1QLJN09TCxczij7WpRwABWvJdGWDbQoSj7a5AgOEeI0OMOP7OJ3Yg1IXOoOELFikdZxoud3cR7bvbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255025; c=relaxed/simple;
	bh=uDafIHGVKJBVtZsbk2kqPxXhZrD038R/CQhWPtdP6bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oT59eRTYrnhlg6yjYDJSDsg8mphh9uXS6iQJDJLNKnBNNvBreXQ/1DXLJXqlgfhkpqDSS2mqFz/pp2Ttfl5yFL2o/oFQIvgf5Nl4HhY0jNxzf38fbnNVhg/LNZ/WBsnXLwpWUZeIbXIGo4iyW7+JQ74fxzn2pd4SCm5L/TSt06U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7u5yhGT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7u5yhGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42651F000C4;
	Sat, 17 Oct 2026 16:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255024;
	bh=SCK1CgGQWug2N/jG4npdZce3uZISfVA7xK1zmX83fH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7u5yhGTi/UTby7/T5g6gCL1FEUmQEKoky2hKkVlN0w/4YC0slM2JKFOZBhJkQc1S
	 58tDQj9E9pKhfSWyEgVbHhJHO0P+qB6JlNqPrKfcx7ND3IG0eB/AhKVSHO/V5ufl7h
	 BMEivCZ38XeCTeVmMnxiozDfuIWb0VGxr9MeMiB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 639/869] iommu/vt-d: Flush context cache with correct SID when tearing down aliases
Date: Sat, 17 Oct 2026 17:58:00 +0200
Message-ID: <20261017160053.403002877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c54e4ae971b98e8d650400137d332cee56c03f55 ]

domain_context_clear_one() and device_pasid_table_teardown() are both
invoked once per DMA alias of a device. Each function locates the context
entry using the bus/devfn pair provided by the pci_for_each_dma_alias()
callback, then calls intel_context_flush_no_pasid(), which constructs a
device-selective context-cache invalidation from info->bus and
info->devfn (that is, always the requester ID of the device itself).

As a result, for every alias other than the device’s own RID, the context
entry that was just cleared in memory is never invalidated in the context
cache. Hardware may continue using that stale cached entry. In the
scalable-mode teardown path, intel_pasid_free_table() can then free the
PASID directory still referenced by that stale entry, allowing the IOMMU
to walk freed memory.

Fix this by passing the source ID of the entry being torn down to
intel_context_flush_no_pasid(), instead of deriving it from @info.

Fixes: f90584f4beb84 ("iommu/vt-d: Add helper to flush caches for context change")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260602233426.357499-1-baolu.lu%40linux.intel.com
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 4 ++--
 drivers/iommu/intel/iommu.h | 2 +-
 drivers/iommu/intel/pasid.c | 9 ++++++---
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9da974068b828..94fd053816802 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1921,7 +1921,7 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_no_pasid(info, context, did);
+	intel_context_flush_no_pasid(info, context, did, PCI_DEVID(bus, devfn));
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
@@ -4164,7 +4164,7 @@ static int context_flip_pri(struct device_domain_info *info, bool enable)
 
 	if (!ecap_coherent(iommu->ecap))
 		clflush_cache_range(context, sizeof(*context));
-	intel_context_flush_no_pasid(info, context, did);
+	intel_context_flush_no_pasid(info, context, did, PCI_DEVID(bus, devfn));
 	spin_unlock(&iommu->lock);
 
 	return 0;
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index b8d09b00f3945..f94d739c2291e 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1297,7 +1297,7 @@ void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 			      unsigned long end);
 
 void intel_context_flush_no_pasid(struct device_domain_info *info,
-				  struct context_entry *context, u16 did);
+				  struct context_entry *context, u16 did, u16 sid);
 
 int intel_iommu_enable_prq(struct intel_iommu *iommu);
 int intel_iommu_finish_prq(struct intel_iommu *iommu);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 93e9b9243d5fd..dbf1e775fd806 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -717,7 +717,7 @@ static void device_pasid_table_teardown(struct device *dev, u8 bus, u8 devfn)
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_no_pasid(info, context, did);
+	intel_context_flush_no_pasid(info, context, did, PCI_DEVID(bus, devfn));
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
@@ -919,9 +919,12 @@ static void __context_flush_dev_iotlb(struct device_domain_info *info)
  * This helper can only be used when IOMMU is working in the legacy mode or
  * IOMMU is in scalable mode but all PASID table entries of the device are
  * non-present.
+ *
+ * @sid identifies the context entry that was modified, which may be a DMA
+ * alias of @info->dev rather than its own requester ID.
  */
 void intel_context_flush_no_pasid(struct device_domain_info *info,
-				  struct context_entry *context, u16 did)
+				  struct context_entry *context, u16 did, u16 sid)
 {
 	struct intel_iommu *iommu = info->iommu;
 
@@ -931,7 +934,7 @@ void intel_context_flush_no_pasid(struct device_domain_info *info,
 	 * when operating in scalable mode. Therefore the @did value doesn't
 	 * matter in scalable mode.
 	 */
-	iommu->flush.flush_context(iommu, did, PCI_DEVID(info->bus, info->devfn),
+	iommu->flush.flush_context(iommu, did, sid,
 				   DMA_CCMD_MASK_NOBIT, DMA_CCMD_DEVICE_INVL);
 
 	/*
-- 
2.53.0



