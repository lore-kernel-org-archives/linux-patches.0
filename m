Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D3C13EFFB;
	Tue, 27 Feb 2024 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041297; cv=none; b=GDLh/sCFdvVyoU0EGvgQA8viGUA0J1/IStbJG2zx62HlLNNQRNbaWkKU52ujHh+XPxh8Z3KK/xYLIEtndj6CkkY9Lfno8OL7ttpRstWC7+dWzHHBPC6EI3z/ylrAKzTuedjAbOJ/9MwkKd5Zcv/F7HQgAvc1uLn8LOcxbxaDASI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041297; c=relaxed/simple;
	bh=PML/+l9r/gOj46+gfbdqC965PvP3yXFQgZVxrvw+FiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y94chj7zCbucmhI+kYGTSankNQDb0Px+tOD3x/E89Zsmc72c1zGQbNCpj0I9A4e6R+0Y5DeEu0vVihqGy96M6qWdEepOKYTTjLTd1Y9S2znHKZF5dCtXR9178YYCwLqT8anmyvQ4j00i3iN92XH9kBOcljNR5kLalK7Vq23OaCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgfR2ucu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgfR2ucu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D2EC43399;
	Tue, 27 Feb 2024 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041297;
	bh=PML/+l9r/gOj46+gfbdqC965PvP3yXFQgZVxrvw+FiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgfR2ucuVgHtyf7IAtvdLai74eY366+5oHj/ua9kji5fN6uCdI7PN40JT63A9SGRq
	 UxLK/uYTmUEH/F/oiHCUgsXqAXph8SRIcDQtt3w6cDlyUFMlSKzARI65/PLgt8M8Ld
	 XpAXLrM9tel8xkaBIMzXgrvyRzOy48q+R4FYjfAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 290/334] iommu/vt-d: Track nested domains in parent
Date: Tue, 27 Feb 2024 14:22:28 +0100
Message-ID: <20240227131640.368001276@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 85ce8e1d6d73e8d54cb244d10dd4021771231746 ]

Today the parent domain (s2_domain) is unaware of which DID's are
used by and which devices are attached to nested domains (s1_domain)
nested on it. This leads to a problem that some operations (flush
iotlb/devtlb and enable dirty tracking) on parent domain only apply to
DID's and devices directly tracked in the parent domain hence are
incomplete.

This tracks the nested domains in list in parent domain. With this,
operations on parent domain can loop the nested domains and refer to
the devices and iommu_array to ensure the operations on parent domain
take effect on all the affected devices and iommus.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240208082307.15759-2-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: f1e1610950ea ("iommu/vt-d: Add missing dirty tracking set for parent domain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c  | 18 ++++++++++++++----
 drivers/iommu/intel/iommu.h  |  6 ++++++
 drivers/iommu/intel/nested.c | 12 +++++++++++-
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 0cc6e08e12c13..9f7954c4c26f8 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4069,6 +4069,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	bool nested_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
 	struct intel_iommu *iommu = info->iommu;
+	struct dmar_domain *dmar_domain;
 	struct iommu_domain *domain;
 
 	/* Must be NESTING domain */
@@ -4094,11 +4095,16 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	if (nested_parent)
-		to_dmar_domain(domain)->nested_parent = true;
+	dmar_domain = to_dmar_domain(domain);
+
+	if (nested_parent) {
+		dmar_domain->nested_parent = true;
+		INIT_LIST_HEAD(&dmar_domain->s1_domains);
+		spin_lock_init(&dmar_domain->s1_lock);
+	}
 
 	if (dirty_tracking) {
-		if (to_dmar_domain(domain)->use_first_level) {
+		if (dmar_domain->use_first_level) {
 			iommu_domain_free(domain);
 			return ERR_PTR(-EOPNOTSUPP);
 		}
@@ -4110,8 +4116,12 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 
 static void intel_iommu_domain_free(struct iommu_domain *domain)
 {
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	WARN_ON(dmar_domain->nested_parent &&
+		!list_empty(&dmar_domain->s1_domains));
 	if (domain != &si_domain->domain)
-		domain_exit(to_dmar_domain(domain));
+		domain_exit(dmar_domain);
 }
 
 int prepare_domain_attach_device(struct iommu_domain *domain,
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 70ac2b989127a..efc00d2b4527a 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -630,6 +630,10 @@ struct dmar_domain {
 			int		agaw;
 			/* maximum mapped address */
 			u64		max_addr;
+			/* Protect the s1_domains list */
+			spinlock_t	s1_lock;
+			/* Track s1_domains nested on this domain */
+			struct list_head s1_domains;
 		};
 
 		/* Nested user domain */
@@ -640,6 +644,8 @@ struct dmar_domain {
 			unsigned long s1_pgtbl;
 			/* page table attributes */
 			struct iommu_hwpt_vtd_s1 s1_cfg;
+			/* link to parent domain siblings */
+			struct list_head s2_link;
 		};
 	};
 
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 694c1c4223f66..92e82b33ea979 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -72,7 +72,13 @@ static int intel_nested_attach_dev(struct iommu_domain *domain,
 
 static void intel_nested_domain_free(struct iommu_domain *domain)
 {
-	kfree(to_dmar_domain(domain));
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct dmar_domain *s2_domain = dmar_domain->s2_domain;
+
+	spin_lock(&s2_domain->s1_lock);
+	list_del(&dmar_domain->s2_link);
+	spin_unlock(&s2_domain->s1_lock);
+	kfree(dmar_domain);
 }
 
 static const struct iommu_domain_ops intel_nested_domain_ops = {
@@ -115,5 +121,9 @@ struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
 	spin_lock_init(&domain->lock);
 	xa_init(&domain->iommu_array);
 
+	spin_lock(&s2_domain->s1_lock);
+	list_add(&domain->s2_link, &s2_domain->s1_domains);
+	spin_unlock(&s2_domain->s1_lock);
+
 	return &domain->domain;
 }
-- 
2.43.0



