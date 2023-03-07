Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050B4BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAE5C433D2;
	Tue,  7 Mar 2023 19:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215673;
	bh=eQb6M0Hlc4SIfS8Yncu5bRBCUs75bP3dS9q6Iv7Wwz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPhhxT28G2ncsUi11/LF1aojPaKTX7Q9TXlXZWNxLLSbLd7NmfB6VqeKvkmViDdKt
	 9bjqDpVH+pe6N76alaSY5qlTpwMp6w+dZj02GxaG2wv++24UotwdkZoOFiwo26Z1Ud
	 apw/HGf4ZjT1ppyhIlnzRWjXB8SyOlfhN0Iz1mtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/567] iommu/vt-d: Remove duplicate identity domain flag
Date: Tue,  7 Mar 2023 18:01:14 +0100
Message-Id: <20230307165920.520443531@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit b34380a6d767c54480a937951e6189a7f9699443 ]

The iommu_domain data structure already has the "type" field to keep the
type of a domain. It's unnecessary to have the DOMAIN_FLAG_STATIC_IDENTITY
flag in the vt-d implementation. This cleans it up with no functionality
change.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20210926114535.923263-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20211014053839.727419-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 257ec2907419 ("iommu/vt-d: Allow to use flush-queue when first level is default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 9 ++++-----
 include/linux/intel-iommu.h | 3 ---
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5a4163f71a933..6be0fb10cb8a9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -514,7 +514,7 @@ static inline void free_devinfo_mem(void *vaddr)
 
 static inline int domain_type_is_si(struct dmar_domain *domain)
 {
-	return domain->flags & DOMAIN_FLAG_STATIC_IDENTITY;
+	return domain->domain.type == IOMMU_DOMAIN_IDENTITY;
 }
 
 static inline bool domain_use_first_level(struct dmar_domain *domain)
@@ -1922,7 +1922,7 @@ static bool first_level_by_default(void)
 	return scalable_mode_support() && intel_cap_flts_sanity();
 }
 
-static struct dmar_domain *alloc_domain(int flags)
+static struct dmar_domain *alloc_domain(unsigned int type)
 {
 	struct dmar_domain *domain;
 
@@ -1932,7 +1932,6 @@ static struct dmar_domain *alloc_domain(int flags)
 
 	memset(domain, 0, sizeof(*domain));
 	domain->nid = NUMA_NO_NODE;
-	domain->flags = flags;
 	if (first_level_by_default())
 		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
 	domain->has_iotlb_device = false;
@@ -2753,7 +2752,7 @@ static int __init si_domain_init(int hw)
 	struct device *dev;
 	int i, nid, ret;
 
-	si_domain = alloc_domain(DOMAIN_FLAG_STATIC_IDENTITY);
+	si_domain = alloc_domain(IOMMU_DOMAIN_IDENTITY);
 	if (!si_domain)
 		return -EFAULT;
 
@@ -4555,7 +4554,7 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 	case IOMMU_DOMAIN_DMA:
 	case IOMMU_DOMAIN_DMA_FQ:
 	case IOMMU_DOMAIN_UNMANAGED:
-		dmar_domain = alloc_domain(0);
+		dmar_domain = alloc_domain(type);
 		if (!dmar_domain) {
 			pr_err("Can't allocate dmar_domain\n");
 			return NULL;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 81da7107e3bd0..0cf00786a164f 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -515,9 +515,6 @@ struct context_entry {
 	u64 hi;
 };
 
-/* si_domain contains mulitple devices */
-#define DOMAIN_FLAG_STATIC_IDENTITY		BIT(0)
-
 /*
  * When VT-d works in the scalable mode, it allows DMA translation to
  * happen through either first level or second level page table. This
-- 
2.39.2



