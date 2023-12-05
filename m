Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583626AA0;
	Tue,  5 Dec 2023 03:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IppoI12G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FA9C433C8;
	Tue,  5 Dec 2023 03:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746491;
	bh=9t/7CfrZYK7+0OSQK1V2vPRObZ+ZCHxqVNZ4oyVTfD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IppoI12GlH96DQnJlJ6n8byFzimqSgmx2nS7lm00pb83dODP7j6TyL6Uh7nXW9Ie5
	 5x9T87lADrQpMJJiFn8DEXxpb8SpGbMMCnkusc/701TDdUJPukohxoQ2p7dL0XHb/d
	 FmPfBTHaMsFKVMoydedzwizct7biQEW0131O6+p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Ying <ying.huang@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Luo Yuzhang <yuzhang.luo@intel.com>,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH 6.6 043/134] iommu/vt-d: Fix incorrect cache invalidation for mm notification
Date: Tue,  5 Dec 2023 12:15:15 +0900
Message-ID: <20231205031538.277183835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit e7ad6c2a4b1aa710db94060b716f53c812cef565 upstream.

Commit 6bbd42e2df8f ("mmu_notifiers: call invalidate_range() when
invalidating TLBs") moved the secondary TLB invalidations into the TLB
invalidation functions to ensure that all secondary TLB invalidations
happen at the same time as the CPU invalidation and added a flush-all
type of secondary TLB invalidation for the batched mode, where a range
of [0, -1UL) is used to indicates that the range extends to the end of
the address space.

However, using an end address of -1UL caused an overflow in the Intel
IOMMU driver, where the end address was rounded up to the next page.
As a result, both the IOTLB and device ATC were not invalidated correctly.

Add a flush all helper function and call it when the invalidation range
is from 0 to -1UL, ensuring that the entire caches are invalidated
correctly.

Fixes: 6bbd42e2df8f ("mmu_notifiers: call invalidate_range() when invalidating TLBs")
Cc: stable@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Tested-by: Luo Yuzhang <yuzhang.luo@intel.com> # QAT
Tested-by: Tony Zhu <tony.zhu@intel.com> # DSA
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20231117090933.75267-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/svm.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 50a481c895b8..ac12f76c1212 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -216,6 +216,27 @@ static void intel_flush_svm_range(struct intel_svm *svm, unsigned long address,
 	rcu_read_unlock();
 }
 
+static void intel_flush_svm_all(struct intel_svm *svm)
+{
+	struct device_domain_info *info;
+	struct intel_svm_dev *sdev;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdev, &svm->devs, list) {
+		info = dev_iommu_priv_get(sdev->dev);
+
+		qi_flush_piotlb(sdev->iommu, sdev->did, svm->pasid, 0, -1UL, 0);
+		if (info->ats_enabled) {
+			qi_flush_dev_iotlb_pasid(sdev->iommu, sdev->sid, info->pfsid,
+						 svm->pasid, sdev->qdep,
+						 0, 64 - VTD_PAGE_SHIFT);
+			quirk_extra_dev_tlb_flush(info, 0, 64 - VTD_PAGE_SHIFT,
+						  svm->pasid, sdev->qdep);
+		}
+	}
+	rcu_read_unlock();
+}
+
 /* Pages have been freed at this point */
 static void intel_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 					struct mm_struct *mm,
@@ -223,6 +244,11 @@ static void intel_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct intel_svm *svm = container_of(mn, struct intel_svm, notifier);
 
+	if (start == 0 && end == -1UL) {
+		intel_flush_svm_all(svm);
+		return;
+	}
+
 	intel_flush_svm_range(svm, start,
 			      (end - start + PAGE_SIZE - 1) >> VTD_PAGE_SHIFT, 0);
 }
-- 
2.43.0



