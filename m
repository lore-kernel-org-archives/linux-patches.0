Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1F7BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F224FC433EF;
	Tue,  7 Mar 2023 18:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214592;
	bh=v6aqi8yIjHOzZ1G5m6H5in+wgo6c9Wzy4oml/pd+O2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUq8UFzX3GSVrerPtRsIld3kIKLBSucO5OtPYZIJ+GOHCa31K+K4z1ToOAcM6em9n
	 oDbs3Km9IdKvyruNNd5BSiU1li3GsnZIzx5J0zBx9LQIekWqaA3EMH5zcuUqlUQhVa
	 smhWan/OK7o20Fz6dquBIEBdvenHrfuXOzF8cbcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sanjay Kumar <sanjay.k.kumar@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 872/885] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Date: Tue,  7 Mar 2023 18:03:26 +0100
Message-Id: <20230307170039.671009849@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

commit 16a75bbe480c3598b3af57a2504ea89b1e32c3ac upstream.

Intel IOMMU driver implements IOTLB flush queue with domain selective
or PASID selective invalidations. In this case there's no need to track
IOVA page range and sync IOTLBs, which may cause significant performance
hit.

This patch adds a check to avoid IOVA gather page and IOTLB sync for
the lazy path.

The performance difference on Sapphire Rapids 100Gb NIC is improved by
the following (as measured by iperf send):

w/o this fix~48 Gbits/s. with this fix ~54 Gbits/s

Cc: <stable@vger.kernel.org>
Fixes: 2a2b8eaa5b25 ("iommu: Handle freelists when using deferred flushing in iommu drivers")
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Link: https://lore.kernel.org/r/20230209175330.1783556-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4359,7 +4359,12 @@ static size_t intel_iommu_unmap(struct i
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
-	iommu_iotlb_gather_add_page(domain, gather, iova, size);
+	/*
+	 * We do not use page-selective IOTLB invalidation in flush queue,
+	 * so there is no need to track page and sync iotlb.
+	 */
+	if (!iommu_iotlb_gather_queued(gather))
+		iommu_iotlb_gather_add_page(domain, gather, iova, size);
 
 	return size;
 }


