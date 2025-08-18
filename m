Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5972021B199;
	Mon, 18 Aug 2025 13:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522645; cv=none; b=WFk1FtqW8M3eggpivA5rdt0O+dSnmY3/mZNON3iKAxZEjssx2DwlNEPLSfF11dFXjZ7O6wPtlPJkstzmSjWB9xXcqjPoSCHRpQuCYURPEHdLjziet61T3xYUKlVsGw3z3WnwFZMicZI6PQpklJyxyi7/XDMYvKPK6Obo0qvT7VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522645; c=relaxed/simple;
	bh=KLDFNA61TmJAPasQsM1iX4E6KN02gsdhnz7GPfq5UVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6hl4JKQKOeklGSmqsTpT44OwQsYg/7V50JP9CaqZNP6Azmx1lq608myMZwmAbKPMWz92jvaPRuKrSEryOwVQ8jONkrSOI+i4hRNlkr8bBt05yZMc3D6Gcx0yN0URf6tamdqmJjn5xIcxRW4+8tBrU2fiT7/FNVojV0tA5WOE84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGYCu2cO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGYCu2cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D532BC4CEEB;
	Mon, 18 Aug 2025 13:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522645;
	bh=KLDFNA61TmJAPasQsM1iX4E6KN02gsdhnz7GPfq5UVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGYCu2cOqg5oYJaM6xmUZdx5wFfZ+OZg0FeIf5kEjs4MKWgIc1BzQ0GNSZyVRhBoz
	 CfXVMVL5/fbABiWlWTLdqbzMNt4uJA3g63jaVNcPa0HnBqRY/1Y/FhMxSoEh42lT2e
	 JN3vvkvUDE4QXloTLm1eBadTZpIyJxZ2t+XtEApI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 378/444] iommu/vt-d: Optimize iotlb_sync_map for non-caching/non-RWBF modes
Date: Mon, 18 Aug 2025 14:46:44 +0200
Message-ID: <20250818124503.060597017@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 12724ce3fe1a3d8f30d56e48b4f272d8860d1970 upstream.

The iotlb_sync_map iommu ops allows drivers to perform necessary cache
flushes when new mappings are established. For the Intel iommu driver,
this callback specifically serves two purposes:

- To flush caches when a second-stage page table is attached to a device
  whose iommu is operating in caching mode (CAP_REG.CM==1).
- To explicitly flush internal write buffers to ensure updates to memory-
  resident remapping structures are visible to hardware (CAP_REG.RWBF==1).

However, in scenarios where neither caching mode nor the RWBF flag is
active, the cache_tag_flush_range_np() helper, which is called in the
iotlb_sync_map path, effectively becomes a no-op.

Despite being a no-op, cache_tag_flush_range_np() involves iterating
through all cache tags of the iommu's attached to the domain, protected
by a spinlock. This unnecessary execution path introduces overhead,
leading to a measurable I/O performance regression. On systems with NVMes
under the same bridge, performance was observed to drop from approximately
~6150 MiB/s down to ~4985 MiB/s.

Introduce a flag in the dmar_domain structure. This flag will only be set
when iotlb_sync_map is required (i.e., when CM or RWBF is set). The
cache_tag_flush_range_np() is called only for domains where this flag is
set. This flag, once set, is immutable, given that there won't be mixed
configurations in real-world scenarios where some IOMMUs in a system
operate in caching mode while others do not. Theoretically, the
immutability of this flag does not impact functionality.

Reported-by: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2115738
Link: https://lore.kernel.org/r/20250701171154.52435-1-ioanna-maria.alifieraki@canonical.com
Fixes: 129dab6e1286 ("iommu/vt-d: Use cache_tag_flush_range_np() in iotlb_sync_map")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20250703031545.3378602-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20250714045028.958850-3-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |   19 ++++++++++++++++++-
 drivers/iommu/intel/iommu.h |    3 +++
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1957,6 +1957,18 @@ static bool dev_is_real_dma_subdevice(st
 	       pci_real_dma_dev(to_pci_dev(dev)) != to_pci_dev(dev);
 }
 
+static bool domain_need_iotlb_sync_map(struct dmar_domain *domain,
+				       struct intel_iommu *iommu)
+{
+	if (cap_caching_mode(iommu->cap) && !domain->use_first_level)
+		return true;
+
+	if (rwbf_quirk || cap_rwbf(iommu->cap))
+		return true;
+
+	return false;
+}
+
 static int dmar_domain_attach_device(struct dmar_domain *domain,
 				     struct device *dev)
 {
@@ -1994,6 +2006,8 @@ static int dmar_domain_attach_device(str
 	if (ret)
 		goto out_block_translation;
 
+	domain->iotlb_sync_map |= domain_need_iotlb_sync_map(domain, iommu);
+
 	return 0;
 
 out_block_translation:
@@ -4278,7 +4292,10 @@ static bool risky_device(struct pci_dev
 static int intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
 				      unsigned long iova, size_t size)
 {
-	cache_tag_flush_range_np(to_dmar_domain(domain), iova, iova + size - 1);
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	if (dmar_domain->iotlb_sync_map)
+		cache_tag_flush_range_np(dmar_domain, iova, iova + size - 1);
 
 	return 0;
 }
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -614,6 +614,9 @@ struct dmar_domain {
 	u8 has_mappings:1;		/* Has mappings configured through
 					 * iommu_map() interface.
 					 */
+	u8 iotlb_sync_map:1;		/* Need to flush IOTLB cache or write
+					 * buffer when creating mappings.
+					 */
 
 	spinlock_t lock;		/* Protect device tracking lists */
 	struct list_head devices;	/* all devices' list */


