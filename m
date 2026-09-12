Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A883A41B8CC;
	Sat, 12 Sep 2026 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210627; cv=none; b=aAfyrNRCae2YFJGWT8Sc8I50ngJqRK3mAH9dlwjRgvGM21oeIhHBjusFgPZMv6to4neslIz2Uec+Jn+kyQvRsvsog4tQmcGP9ZixalN2EIjCunYAgywFEnGNt34Hx2DHUcmyHHAs9PD0jViQGreuIBw1g54q2dU5QZq8GyoDT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210627; c=relaxed/simple;
	bh=mx1BTFgTx4Cm8+oR7lgRO6QwAPXoVohziOXscIhKNeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XqaLL3x/TC15lDn1Heu+9tLDUFDraFQqIO+dkyy+HT6YU3iD1UjBJUKHu2uW2DQC8Zgca+0P0ZXAxUK4RGxjc5l8uzSJ5eKpM1gaFGdj50jQ02iPiOrVq0k0nWK9bh5SX/FlGFEeE798lUrsDuZBGJho1y1n2nOuwIB3ojG3FuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogCM7Xzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogCM7Xzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85681F000FF;
	Sat, 12 Sep 2026 10:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210626;
	bh=oXh+TYR5ByYrFkuHlCDRBWRYCcQ9mnEI1lLqqr0HLfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogCM7XzdY0LWH5vWaxOXDKoCw6oYnB264W+T7dnsnDPfh9Dg6TUnb/fVui8one4Yq
	 LsStXH/7joiTLFxPvm6B1g51+rUS8xnths422/QgIsAyJ8fPLPJzm+uR4stcrIfMMn
	 RCyaP158frJWXAENtEHoUIgSqOm/jtzeuVztnIdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1066/1518] iommu/vt-d: Flush context cache with correct SID when tearing down aliases
Date: Sat, 12 Sep 2026 08:53:55 +0200
Message-ID: <20260912065647.563645567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iommu/intel/iommu.c | 2 +-
 drivers/iommu/intel/iommu.h | 2 +-
 drivers/iommu/intel/pasid.c | 9 ++++++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 183310979ba0d..11ed18b1e7dfd 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1732,7 +1732,7 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_no_pasid(info, context, did);
+	intel_context_flush_no_pasid(info, context, did, PCI_DEVID(bus, devfn));
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 8e2df00e881c5..e696e019e9697 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1320,7 +1320,7 @@ void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 			      unsigned long end);
 
 void intel_context_flush_no_pasid(struct device_domain_info *info,
-				  struct context_entry *context, u16 did);
+				  struct context_entry *context, u16 did, u16 sid);
 
 int intel_iommu_enable_prq(struct intel_iommu *iommu);
 int intel_iommu_finish_prq(struct intel_iommu *iommu);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 85c3116e351c6..48e21743f2077 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -749,7 +749,7 @@ static void device_pasid_table_teardown(struct device *dev, u8 bus, u8 devfn)
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_no_pasid(info, context, did);
+	intel_context_flush_no_pasid(info, context, did, PCI_DEVID(bus, devfn));
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
@@ -953,9 +953,12 @@ static void __context_flush_dev_iotlb(struct device_domain_info *info)
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
 
@@ -965,7 +968,7 @@ void intel_context_flush_no_pasid(struct device_domain_info *info,
 	 * when operating in scalable mode. Therefore the @did value doesn't
 	 * matter in scalable mode.
 	 */
-	iommu->flush.flush_context(iommu, did, PCI_DEVID(info->bus, info->devfn),
+	iommu->flush.flush_context(iommu, did, sid,
 				   DMA_CCMD_MASK_NOBIT, DMA_CCMD_DEVICE_INVL);
 
 	/*
-- 
2.53.0



