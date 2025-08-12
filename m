Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBCD6BB5B;
	Tue, 12 Aug 2025 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023906; cv=none; b=TmFNFTBXt2THUiJt1WxHN6foTnpahSYqncyDdB1CS15PMyecWs3GpzL6kAYq8IeuBQVDVNHjYeRr5a/QSAo55o5l+LCeKhUagiWHQGv4AmceB5ILh5UvNMusmQh2218/pOn/PwMENOVnF0n/9F9ssh/3yELP/bs7WF+owvjZO38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023906; c=relaxed/simple;
	bh=pq4T7sh73FaXRAONuUdebVbe/6MElSeFzZ6VtAzaVGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWOJsKmn9PSaz8opJ5drItm1abuiuqktwixaMzq5ZrMY8+qWDC9D/PSM7j4UZTocsK+dLU3YqRr4TcGjRc+0W7Hqn+IFothKziPfmF5t7OISNwNDsUvLswpnsmdPcLAh+xYQDg7ZyHhw1A+UTTUGgNB+9lBj2meEk0Fo68Qa14E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBs55obP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBs55obP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CEDC4CEF0;
	Tue, 12 Aug 2025 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023905;
	bh=pq4T7sh73FaXRAONuUdebVbe/6MElSeFzZ6VtAzaVGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBs55obPYPNN4eKv2fvoo+lPB632ob6Sx4F8pXwMLcNU75W4UDfewKuu9JwKFIoTX
	 6faOQ2/SNubC6hXJVaDk28ZOaW4036A2ZDT2CewREyuK0tweifPFiQb+9g6DURAXgw
	 4r4CFUlfFLjKmAU53ncZdFUvWZ3JDW9pgtU5vL3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 217/627] iommu/vt-d: Do not wipe out the page table NID when devices detach
Date: Tue, 12 Aug 2025 19:28:32 +0200
Message-ID: <20250812173427.540001818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 5c3687d5789cfff8d285a2c76bceb47f145bf01f ]

The NID is used to control which NUMA node memory for the page table is
allocated it from. It should be a permanent property of the page table
when it was allocated and not change during attach/detach of devices.

Reviewed-by: Wei Wang <wei.w.wang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/3-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Fixes: 7c204426b818 ("iommu/vt-d: Add domain_alloc_paging support")
Link: https://lore.kernel.org/r/20250714045028.958850-6-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 148b944143b8..72b477911fdb 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1391,7 +1391,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	if (--info->refcnt == 0) {
 		ida_free(&iommu->domain_ida, info->did);
 		xa_erase(&domain->iommu_array, iommu->seq_id);
-		domain->nid = NUMA_NO_NODE;
 		kfree(info);
 	}
 }
-- 
2.39.5



