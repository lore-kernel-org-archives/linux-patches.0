Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877039D6C9;
	Sat, 12 Sep 2026 08:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202875; cv=none; b=QJK4VncXVKr9nTBPmIeBBYcWZlK5BRAeOslUOWO3d7bwTCzDZMb+oHcT6a/Z2zoU93rS3eiPF3wQG4dtQFf0hSDMUvmi7JewvBjfPN8BaMryI9VKNss5xIiontTvVO769W4L2u8JKfKs7196E+tK/U+zyLotFTRE5W6ymUUNbYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202875; c=relaxed/simple;
	bh=hQFwuHrm/GEGMlieJIQ3kaNXO9yCXOYv0+iO7+S/wrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IGO4zYmSJHceuOgghrn9PrfASWVehVyTJgfMnpMePB25B4615vqMoqpTcaqbC5+sscg4Ly6kj/FRqnIXq5t9yL8a7UxWLNlLaZTbvlZ2C8UI4C+3N8B7MyKvWyOQH6C3TaDFteIeV0cqVDUaTv4mlNNc4Trk7S28QqvR6AExMzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHLp/Dg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHLp/Dg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E311F000FF;
	Sat, 12 Sep 2026 08:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202873;
	bh=XTeHASr8+TkJ8P7axkWCJo7Yvii15O1nmhG12TK0XfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHLp/Dg7JERUPN8iDN+6dWOUvl9M0n5YW0hNtRUqlsRw3gh7Gn9GIu2wc00V+Yvw+
	 fZsIWy3T56IMkbmcYn35ZpSgGjB7HkJq7G+jM6MFqacS+gP5HnndFIvWBQ6Hv77gB5
	 2t5L2dT8qiT6vO0eDsfBh6PU3n1Gx0elGPT12cnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1294/1815] iommu/vt-d: Flush context cache with correct SID when tearing down aliases
Date: Sat, 12 Sep 2026 08:50:44 +0200
Message-ID: <20260912065719.392628537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 79aaeb3d2b7f7..9a87ac1250d7b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1250,7 +1250,7 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_no_pasid(info, context, did);
+	intel_context_flush_no_pasid(info, context, did, PCI_DEVID(bus, devfn));
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 2cee36138d6e1..2df59d999715a 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1240,7 +1240,7 @@ void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 			      unsigned long end);
 
 void intel_context_flush_no_pasid(struct device_domain_info *info,
-				  struct context_entry *context, u16 did);
+				  struct context_entry *context, u16 did, u16 sid);
 
 int intel_iommu_enable_prq(struct intel_iommu *iommu);
 int intel_iommu_finish_prq(struct intel_iommu *iommu);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 81353fd46b37e..e4f24d3f19a61 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -751,7 +751,7 @@ static void device_pasid_table_teardown(struct device *dev, u8 bus, u8 devfn)
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_no_pasid(info, context, did);
+	intel_context_flush_no_pasid(info, context, did, PCI_DEVID(bus, devfn));
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
@@ -955,9 +955,12 @@ static void __context_flush_dev_iotlb(struct device_domain_info *info)
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
 
@@ -967,7 +970,7 @@ void intel_context_flush_no_pasid(struct device_domain_info *info,
 	 * when operating in scalable mode. Therefore the @did value doesn't
 	 * matter in scalable mode.
 	 */
-	iommu->flush.flush_context(iommu, did, PCI_DEVID(info->bus, info->devfn),
+	iommu->flush.flush_context(iommu, did, sid,
 				   DMA_CCMD_MASK_NOBIT, DMA_CCMD_DEVICE_INVL);
 
 	/*
-- 
2.53.0



