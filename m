Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A8613B2B4;
	Tue, 27 Feb 2024 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041300; cv=none; b=jC/Q4z4Mzhl8qVszf6MOa5im1GZUYUc67BXFw3CskWqoO4qjWhzwrUDPBzTyV6TKGeFIFthqh93hl5g/kxtZm0ZVRMGK3l9MrI9aczy+CHkcBQz5o24I3ojt+hcVWm+RUI6xf/TQ8UaQ3CVGSc7r3LMJHo71fYTPKDERouJRTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041300; c=relaxed/simple;
	bh=UQPLE5+fnDC4H1drY5ZQpra3Y3fhdQJr7U9fo+lmf28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPdUaghon5HtqzoeZHEADbLsGOZZS884Rgx/a64iFIlDClz8sH8d/zmaGtJ12X4xsdMu7SsBUdaGq1PUnJ7Ifj7DmHXpo8pACOcw0tH063XuVGQ2Z9WnaKxwISWsAaMsEPLS+OtbOKDvvYXhLFNa+pHjbqBAdFjpnGRihGRf7ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FR0/kXsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FR0/kXsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7E4C433C7;
	Tue, 27 Feb 2024 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041300;
	bh=UQPLE5+fnDC4H1drY5ZQpra3Y3fhdQJr7U9fo+lmf28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FR0/kXswvtxcvmjTz6TUAonS0SjIjqVWnWyFmr1gSguyDwLyExJbZeGmx+rHUauX0
	 8OrlGUbEardgiOd9auxakmAb2xjPQlVxkIctkiPt7dlpH2cx05oFmiSB/gMpJGje5j
	 oSBSLCwwOGszW2Z1ptVVHtDYbSHkXxI7oQGe62Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 291/334] iommu/vt-d: Remove domain parameter for intel_pasid_setup_dirty_tracking()
Date: Tue, 27 Feb 2024 14:22:29 +0100
Message-ID: <20240227131640.412425750@linuxfoundation.org>
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

[ Upstream commit 56ecaf6c5834ace14941d7f13dceb48bc3327111 ]

The only usage of input @domain is to get the domain id (DID) to flush
cache after setting dirty tracking. However, DID can be obtained from
the pasid entry. So no need to pass in domain. This can make this helper
cleaner when adding the missing dirty tracking for the parent domain,
which needs to use the DID of nested domain.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240208082307.15759-7-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: f1e1610950ea ("iommu/vt-d: Add missing dirty tracking set for parent domain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 7 +++----
 drivers/iommu/intel/pasid.c | 3 +--
 drivers/iommu/intel/pasid.h | 1 -
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9f7954c4c26f8..88f9b4ffd5774 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4877,8 +4877,7 @@ static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
 		goto out_unlock;
 
 	list_for_each_entry(info, &dmar_domain->devices, link) {
-		ret = intel_pasid_setup_dirty_tracking(info->iommu,
-						       info->domain, info->dev,
+		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->dev,
 						       IOMMU_NO_PASID, enable);
 		if (ret)
 			goto err_unwind;
@@ -4892,8 +4891,8 @@ static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
 
 err_unwind:
 	list_for_each_entry(info, &dmar_domain->devices, link)
-		intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
-						 info->dev, IOMMU_NO_PASID,
+		intel_pasid_setup_dirty_tracking(info->iommu, info->dev,
+						 IOMMU_NO_PASID,
 						 dmar_domain->dirty_tracking);
 	spin_unlock(&dmar_domain->lock);
 	return ret;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 74e8e4c17e814..9f8f389ff255c 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -695,7 +695,6 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
  * Set up dirty tracking on a second only or nested translation type.
  */
 int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
-				     struct dmar_domain *domain,
 				     struct device *dev, u32 pasid,
 				     bool enabled)
 {
@@ -712,7 +711,7 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
-	did = domain_id_iommu(domain, iommu);
+	did = pasid_get_domain_id(pte);
 	pgtt = pasid_pte_get_pgtt(pte);
 	if (pgtt != PASID_ENTRY_PGTT_SL_ONLY &&
 	    pgtt != PASID_ENTRY_PGTT_NESTED) {
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index dd37611175cc1..3568adca1fd82 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -107,7 +107,6 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid);
 int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
-				     struct dmar_domain *domain,
 				     struct device *dev, u32 pasid,
 				     bool enabled);
 int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
-- 
2.43.0



