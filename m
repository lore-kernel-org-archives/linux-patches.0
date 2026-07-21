Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F2046EC9B;
	Tue, 21 Jul 2026 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661300; cv=none; b=Mt8U7BOAgm4fkiOwW/DX+Js/Oj86JyA7HS/caLA657Nwp33kLC3lCMfY9DI0fd/1FgGaqiYEq8vHwfJpRm2Wir3TGXuEwbwsOjXymw/AngBkmcIZ0hSY1XIRNylxjREb8q9ph5X64IuE0noVqXx4DBwbvcqkUanXGTUhjKhYpXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661300; c=relaxed/simple;
	bh=OLhgzpsJm2K4sRAYVPlxnEvG4NCLLy+s59Ycgo/JYB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcaylSLno/ZSwWPhLpw1kierPYWtj3d0MYYwWAMo7pBhIx25NNhBebB2HrvHJ0sC96AJH4ZRxCpGhf0LN4xtANwVEHKVcgIsJ9yAYNM+3NC+NV93jfm3vPkiqja0dv5Eh5fnWYXX3DDUWIhcwBtYz/4IuhzkWa8eySXYYzl/VTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn0B0G5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn0B0G5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D54A1F000E9;
	Tue, 21 Jul 2026 19:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661298;
	bh=ZqlEk3vVRbqxAAhZhPxgqN60t6+DjF2e88cJ1SE0QX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn0B0G5JLzfqWfUKEhdQAQzynsMWtPBuzGA8kfyE4i2KAnC+jzC18RlM4F3X0aZZC
	 KL+9euTtNXzxLKgg9+XdZO2KqHt3swWoc+NkU5tjQQu0PpcruJ8CDcLyLr35zy0kTC
	 7FgoDZPnPytiVY+BKeo9iI5R92QxE6vpi73beF9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0015/1276] iommu/vt-d: Cleanup intel_context_flush_present()
Date: Tue, 21 Jul 2026 17:07:38 +0200
Message-ID: <20260721152446.420889570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 4c293add5874038dc82ef579663dd86744d8e872 ]

The intel_context_flush_present() is called in places where either the
scalable mode is disabled, or scalable mode is enabled but all PASID
entries are known to be non-present. In these cases, the flush_domains
path within intel_context_flush_present() will never execute. This dead
code is therefore removed.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://lore.kernel.org/r/20250228092631.3425464-7-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: f46452c3df7a ("iommu/vt-d: Clear Present bit before tearing down scalable-mode context entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c |  4 ++--
 drivers/iommu/intel/iommu.h |  5 ++---
 drivers/iommu/intel/pasid.c | 41 +++++++------------------------------
 3 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3455e75c59c4be..a1ec11c90a8b4c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1917,7 +1917,7 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_present(info, context, did, true);
+	intel_context_flush_no_pasid(info, context, did);
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
@@ -4153,7 +4153,7 @@ static int context_flip_pri(struct device_domain_info *info, bool enable)
 
 	if (!ecap_coherent(iommu->ecap))
 		clflush_cache_range(context, sizeof(*context));
-	intel_context_flush_present(info, context, did, true);
+	intel_context_flush_no_pasid(info, context, did);
 	spin_unlock(&iommu->lock);
 
 	return 0;
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index e46eb1d3fba29d..8a91a8d5661418 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1296,9 +1296,8 @@ void cache_tag_flush_all(struct dmar_domain *domain);
 void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 			      unsigned long end);
 
-void intel_context_flush_present(struct device_domain_info *info,
-				 struct context_entry *context,
-				 u16 did, bool affect_domains);
+void intel_context_flush_no_pasid(struct device_domain_info *info,
+				  struct context_entry *context, u16 did);
 
 int intel_iommu_enable_prq(struct intel_iommu *iommu);
 int intel_iommu_finish_prq(struct intel_iommu *iommu);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 5e63b5d4577f75..0e0c6cf2d3f4d3 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -717,7 +717,7 @@ static void device_pasid_table_teardown(struct device *dev, u8 bus, u8 devfn)
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
-	intel_context_flush_present(info, context, did, false);
+	intel_context_flush_no_pasid(info, context, did);
 }
 
 static int pci_pasid_table_teardown(struct pci_dev *pdev, u16 alias, void *data)
@@ -913,17 +913,15 @@ static void __context_flush_dev_iotlb(struct device_domain_info *info)
 
 /*
  * Cache invalidations after change in a context table entry that was present
- * according to the Spec 6.5.3.3 (Guidance to Software for Invalidations). If
- * IOMMU is in scalable mode and all PASID table entries of the device were
- * non-present, set flush_domains to false. Otherwise, true.
+ * according to the Spec 6.5.3.3 (Guidance to Software for Invalidations).
+ * This helper can only be used when IOMMU is working in the legacy mode or
+ * IOMMU is in scalable mode but all PASID table entries of the device are
+ * non-present.
  */
-void intel_context_flush_present(struct device_domain_info *info,
-				 struct context_entry *context,
-				 u16 did, bool flush_domains)
+void intel_context_flush_no_pasid(struct device_domain_info *info,
+				  struct context_entry *context, u16 did)
 {
 	struct intel_iommu *iommu = info->iommu;
-	struct pasid_entry *pte;
-	int i;
 
 	/*
 	 * Device-selective context-cache invalidation. The Domain-ID field
@@ -946,30 +944,5 @@ void intel_context_flush_present(struct device_domain_info *info,
 		return;
 	}
 
-	/*
-	 * For scalable mode:
-	 * - Domain-selective PASID-cache invalidation to affected domains
-	 * - Domain-selective IOTLB invalidation to affected domains
-	 * - Global Device-TLB invalidation to affected functions
-	 */
-	if (flush_domains) {
-		/*
-		 * If the IOMMU is running in scalable mode and there might
-		 * be potential PASID translations, the caller should hold
-		 * the lock to ensure that context changes and cache flushes
-		 * are atomic.
-		 */
-		assert_spin_locked(&iommu->lock);
-		for (i = 0; i < info->pasid_table->max_pasid; i++) {
-			pte = intel_pasid_get_entry(info->dev, i);
-			if (!pte || !pasid_pte_is_present(pte))
-				continue;
-
-			did = pasid_get_domain_id(pte);
-			qi_flush_pasid_cache(iommu, did, QI_PC_ALL_PASIDS, 0);
-			iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
-		}
-	}
-
 	__context_flush_dev_iotlb(info);
 }
-- 
2.53.0



