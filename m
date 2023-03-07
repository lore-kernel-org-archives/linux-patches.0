Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E296BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C84C4339B;
	Tue,  7 Mar 2023 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213375;
	bh=uiuwqNh7r+Y+RIApyKoiYe0jzBNeUpMiZxePsm/Xy2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgi0mlqkNVTdFqgtuTJTLCRFvc/px6RI+BJCYPVCjwEmot6weDzScGHJhVY9DfaTA
	 mkt6RCz1gjB8GlPENF+hUm5B0ees5188ey3HX9ubevvGElMQ0CV7caS1/Vgg8izRHU
	 Z3KpBn37RU4j9Byp1vaflxrQ61C++6YmodPsUhcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Kumar <sanjay.k.kumar@intel.com>,
	Tina Zhang <tina.zhang@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 488/885] iommu/vt-d: Allow to use flush-queue when first level is default
Date: Tue,  7 Mar 2023 17:57:02 +0100
Message-Id: <20230307170023.667383592@linuxfoundation.org>
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

From: Tina Zhang <tina.zhang@intel.com>

[ Upstream commit 257ec290741924f8df678927d0dfecb1deebb9c5 ]

Commit 29b32839725f ("iommu/vt-d: Do not use flush-queue when caching-mode
is on") forced default domains to be strict mode as long as IOMMU
caching-mode is flagged. The reason for doing this is that when vIOMMU
uses VT-d caching mode to synchronize shadowing page tables, the strict
mode shows better performance.

However, this optimization is orthogonal to the first-level page table
because the Intel VT-d architecture does not define the caching mode of
the first-level page table. Refer to VT-d spec, section 6.1, "When the
CM field is reported as Set, any software updates to remapping
structures other than first-stage mapping (including updates to not-
present entries or present entries whose programming resulted in
translation faults) requires explicit invalidation of the caches."
Exclude the first-level page table from this optimization.

Generally using first-stage translation in vIOMMU implies nested
translation enabled in the physical IOMMU. In this case the first-stage
page table is wholly captured by the guest. The vIOMMU only needs to
transfer the cache invalidations on vIOMMU to the physical IOMMU.
Forcing the default domain to strict mode will cause more frequent
cache invalidations, resulting in performance degradation. In a real
performance benchmark test measured by iperf receive, the performance
result on Sapphire Rapids 100Gb NIC shows:
w/ this fix ~51 Gbits/s, w/o this fix ~39.3 Gbits/s.

Theoretically a first-stage IOMMU page table can still be shadowed
in absence of the caching mode, e.g. with host write-protecting guest
IOMMU page table to synchronize changed PTEs with the physical
IOMMU page table. In this case the shadowing overhead is decoupled
from emulating IOTLB invalidation then the overhead of the latter part
is solely decided by the frequency of IOTLB invalidations. Hence
allowing guest default dma domain to be lazy can also benefit the
overall performance by reducing the total VM-exit numbers.

Fixes: 29b32839725f ("iommu/vt-d: Do not use flush-queue when caching-mode is on")
Reported-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Suggested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20230214025618.2292889-1-tina.zhang@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 494a872cbf9bd..82d18eb02266c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4051,7 +4051,8 @@ int __init intel_iommu_init(void)
 		 * is likely to be much lower than the overhead of synchronizing
 		 * the virtual and physical IOMMU page-tables.
 		 */
-		if (cap_caching_mode(iommu->cap)) {
+		if (cap_caching_mode(iommu->cap) &&
+		    !first_level_by_default(IOMMU_DOMAIN_DMA)) {
 			pr_info_once("IOMMU batching disallowed due to virtualization\n");
 			iommu_set_dma_strict();
 		}
-- 
2.39.2



