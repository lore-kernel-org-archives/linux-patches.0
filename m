Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE0143CE46;
	Mon, 17 Aug 2026 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975075; cv=none; b=J7s5CSWIiggM0p+moeap4wsXPzzZ+bAXwNcisGzCJtjWtOx7780dWeabuRzpwDraPbbxI1wfpMG6K3NVAOTmlw9jbYUo7mPw4UJ9oSsZt0HzrJTsbLM5BlcSeaeucsl7iYaJvnEIprEV8zuotHx7pcPIzBwLWa93NNtt2G9B4X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975075; c=relaxed/simple;
	bh=Q5tQyFeKjw1+W4IrSl9dWSTTnlKateiUMAY2XKnGPWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8/DZcs6xuq4XgjheglYeFdwSmjXAZfiggkn+tuUjl1+3WjqLgr80o6O0iGsHFKQr+VjDuMm0RazLGDqwswI1yXrbcSo70OENoej7pjvVQ7DAR+Q5v0paKkm8GUqO76fkyd7berhB8rMEPmWNuqzS1AhJu+bqpA9p6KlT64roDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTlw3nC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTlw3nC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4B91F000E9;
	Mon, 17 Aug 2026 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975073;
	bh=ap1NftourXMY/kAmisuebk7B+kLwLAUjUXZiUd1fChE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTlw3nC9A9fovDKxAKBeIdkeYdy0spg74b/QechjOAIPyGwh4yKUhYcN/U1RpGzCI
	 UtpZVyc9brh8L9JbrzNJ9MxV7XigcjcOJ9E+lJFDxaes/hvLWXoscgIIylJhNtZHTV
	 RSdYppx09qL2BTIsgMCbecizxCkmnB6k8ZJhwzPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Almaroof <moh@anthropic.com>,
	Ben Cressey <ben@cressey.dev>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/250] iommu/vt-d: Gather the unmapped range before freeing its page tables
Date: Mon, 17 Aug 2026 15:31:52 +0200
Message-ID: <20260817132542.719183023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

In the 6.12 and 6.18 stable trees, when an unmapped range covers a
whole page table, intel_iommu_unmap() can free that table before the
range has been invalidated. The freed table goes on gather->freelist
before the range is added to the gather. If
iommu_iotlb_gather_add_page() syncs before adding it, that sync
flushes only the earlier ranges but frees the whole freelist, that
table included. The range itself is flushed later with an empty
freelist, which means the flush is sent with the invalidation hint set
and the IOMMU may keep its paging-structure cache entry for the freed
table. DMA to the next mapping at that IOVA is then translated through
whatever the freed page holds by then, which is usually a silent wrong
translation and sometimes a DMAR fault.

Under a userspace driver that maps and unmaps DMA buffers through VFIO
type1 continuously, this shows up as wrong data in device reads and
writes. An occasional DMAR fault on a mapped IOVA is the only thing in
the logs. With an Intel DSA engine assigned through vfio-pci, remapping
a 16 MiB buffer at a fixed IOVA and reading it through the device
returned data from the wrong pages in 280 of 400 iterations. With a
fresh IOVA per iteration it never did.

Add the range to the gather first and splice the freed tables into
gather->freelist afterwards, so that they are only freed by a sync that
also invalidates their range.

Mainline removed this code in v6.19 with commit d373449d8e97
("iommu/vt-d: Use the generic iommu page table") and is not affected.

Fixes: 2a2b8eaa5b25 ("iommu: Handle freelists when using deferred flushing in iommu drivers")
Cc: stable@vger.kernel.org # 6.12.y, 6.18.y
Reported-by: Mohammed Almaroof <moh@anthropic.com>
Reviewed-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index cee1851b69245..8b38c65f403b2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3620,6 +3620,7 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 				unsigned long iova, size_t size,
 				struct iommu_iotlb_gather *gather)
 {
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	unsigned long start_pfn, last_pfn;
 	int level = 0;
@@ -3636,7 +3637,7 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	start_pfn = iova >> VTD_PAGE_SHIFT;
 	last_pfn = (iova + size - 1) >> VTD_PAGE_SHIFT;
 
-	domain_unmap(dmar_domain, start_pfn, last_pfn, &gather->freelist);
+	domain_unmap(dmar_domain, start_pfn, last_pfn, &freelist);
 
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
@@ -3648,6 +3649,14 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	if (!iommu_iotlb_gather_queued(gather))
 		iommu_iotlb_gather_add_page(domain, gather, iova, size);
 
+	/*
+	 * iommu_iotlb_gather_add_page() may have synced, which frees
+	 * gather->freelist. Hand this range's page tables over only after
+	 * that call. A queued gather frees them from the flush queue
+	 * instead.
+	 */
+	iommu_pages_list_splice(&freelist, &gather->freelist);
+
 	return size;
 }
 
-- 
2.53.0



