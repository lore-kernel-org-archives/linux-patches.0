Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A91F869D;
	Tue, 17 Dec 2024 17:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456421; cv=none; b=GoxMBCRpfOxu7uV9ya3xMAaslyHGHkeyka6dQ2Q6bmcM4/FHooQmlBQL9fi5Y1wC4pxAhELl4zSMDcpkQ0y3nZqQFC7ed8vloZwdskcvJoqmV92nwWUre0TWT/AnhKU56NwYpr925TFlLQcD7Ah9P8K+XGC6GZ9GLf8T74vSgMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456421; c=relaxed/simple;
	bh=4hoX+sbETs0Ai6bv5M3wEtbwtTbMjOFXeIrVifKLK/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4YpU18no9zB2b/x72sdmuuxQNsAO03Ey8K1DuRGrsAaNoS/g+TBO8gVoYKhFdoCwXo0z7Fr/fqMeT+TGQch/DWhQFCvOIsZ3yhsl7G164Hs4DGGnTfMGf1Iokiq3UtcZHcC5oeLegiJFFmrLyy35CsUpvFSKY8hyN7vTBfYAIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKEsxTvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKEsxTvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B78C4CED3;
	Tue, 17 Dec 2024 17:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456421;
	bh=4hoX+sbETs0Ai6bv5M3wEtbwtTbMjOFXeIrVifKLK/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKEsxTvkPZJ33d3RBoZP3NCNC4QjyaVLGaqnq6q8cJaogU8oM1tzKzf9JaHsdlt2K
	 FjWNdT4oYryfxeMeeuVGrcPpFYFs9yNKN8JxhoZsz66yFGocKLdNtwghRBhWJogBSZ
	 4TIQrVySxxRI4VAI6x6wOoo8oh7aTbJpfchhBErQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 055/172] iommu/vt-d: Fix qi_batch NULL pointer with nested parent domain
Date: Tue, 17 Dec 2024 18:06:51 +0100
Message-ID: <20241217170548.553090365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

commit 74536f91962d5f6af0a42414773ce61e653c10ee upstream.

The qi_batch is allocated when assigning cache tag for a domain. While
for nested parent domain, it is missed. Hence, when trying to map pages
to the nested parent, NULL dereference occurred. Also, there is potential
memleak since there is no lock around domain->qi_batch allocation.

To solve it, add a helper for qi_batch allocation, and call it in both
the __cache_tag_assign_domain() and __cache_tag_assign_parent_domain().

  BUG: kernel NULL pointer dereference, address: 0000000000000200
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 8104795067 P4D 0
  Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 223 UID: 0 PID: 4357 Comm: qemu-system-x86 Not tainted 6.13.0-rc1-00028-g4b50c3c3b998-dirty #2632
  Call Trace:
   ? __die+0x24/0x70
   ? page_fault_oops+0x80/0x150
   ? do_user_addr_fault+0x63/0x7b0
   ? exc_page_fault+0x7c/0x220
   ? asm_exc_page_fault+0x26/0x30
   ? cache_tag_flush_range_np+0x13c/0x260
   intel_iommu_iotlb_sync_map+0x1a/0x30
   iommu_map+0x61/0xf0
   batch_to_domain+0x188/0x250
   iopt_area_fill_domains+0x125/0x320
   ? rcu_is_watching+0x11/0x50
   iopt_map_pages+0x63/0x100
   iopt_map_common.isra.0+0xa7/0x190
   iopt_map_user_pages+0x6a/0x80
   iommufd_ioas_map+0xcd/0x1d0
   iommufd_fops_ioctl+0x118/0x1c0
   __x64_sys_ioctl+0x93/0xc0
   do_syscall_64+0x71/0x140
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 705c1cdf1e73 ("iommu/vt-d: Introduce batched cache invalidation")
Cc: stable@vger.kernel.org
Co-developed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20241210130322.17175-1-yi.l.liu@intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/cache.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index e5b89f728ad3..09694cca8752 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -105,12 +105,35 @@ static void cache_tag_unassign(struct dmar_domain *domain, u16 did,
 	spin_unlock_irqrestore(&domain->cache_lock, flags);
 }
 
+/* domain->qi_batch will be freed in iommu_free_domain() path. */
+static int domain_qi_batch_alloc(struct dmar_domain *domain)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&domain->cache_lock, flags);
+	if (domain->qi_batch)
+		goto out_unlock;
+
+	domain->qi_batch = kzalloc(sizeof(*domain->qi_batch), GFP_ATOMIC);
+	if (!domain->qi_batch)
+		ret = -ENOMEM;
+out_unlock:
+	spin_unlock_irqrestore(&domain->cache_lock, flags);
+
+	return ret;
+}
+
 static int __cache_tag_assign_domain(struct dmar_domain *domain, u16 did,
 				     struct device *dev, ioasid_t pasid)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	int ret;
 
+	ret = domain_qi_batch_alloc(domain);
+	if (ret)
+		return ret;
+
 	ret = cache_tag_assign(domain, did, dev, pasid, CACHE_TAG_IOTLB);
 	if (ret || !info->ats_enabled)
 		return ret;
@@ -139,6 +162,10 @@ static int __cache_tag_assign_parent_domain(struct dmar_domain *domain, u16 did,
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	int ret;
 
+	ret = domain_qi_batch_alloc(domain);
+	if (ret)
+		return ret;
+
 	ret = cache_tag_assign(domain, did, dev, pasid, CACHE_TAG_NESTING_IOTLB);
 	if (ret || !info->ats_enabled)
 		return ret;
@@ -190,13 +217,6 @@ int cache_tag_assign_domain(struct dmar_domain *domain,
 	u16 did = domain_get_id_for_dev(domain, dev);
 	int ret;
 
-	/* domain->qi_bach will be freed in iommu_free_domain() path. */
-	if (!domain->qi_batch) {
-		domain->qi_batch = kzalloc(sizeof(*domain->qi_batch), GFP_KERNEL);
-		if (!domain->qi_batch)
-			return -ENOMEM;
-	}
-
 	ret = __cache_tag_assign_domain(domain, did, dev, pasid);
 	if (ret || domain->domain.type != IOMMU_DOMAIN_NESTED)
 		return ret;
-- 
2.47.1



