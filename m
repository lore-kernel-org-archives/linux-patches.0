Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADB0331220;
	Wed, 20 May 2026 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300605; cv=none; b=YTYnYy+D0zy6oC9X2TdZGpNyW1Rv0be0QHigVGWcjRcz+Tb26+PYasfne+n3UBPDxlr7zF7udDe+IQ4ikBf2AVBrqSupb06HQFgXRxBSbBp0ZRgva4cIaJCVGGVzQA3ZphrqzerC/Aop2NqyZ24UvFIq6UvAYRy+zeLQQKEA5rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300605; c=relaxed/simple;
	bh=dmlDzF3RTWBrloxU+6BcZNYwKBam/ldq6LUKMT3qW0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp+crXWwekTd/R49fgw2JhFYE4hVRtMBf8d63EwiKhnsYaYzdwOLQkkPuHgbgZqgVazWt+lklL06L+gt6r16Ia285zhYVr+wO5wj9Wn/EI6oFYJJiCls031DwsARye+iL3OQeHm6kDYVhAbekEWoBMFjAEnS2DchJZbaOhtcyBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaxYnVzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaxYnVzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83F11F000E9;
	Wed, 20 May 2026 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300604;
	bh=TfoDkPBCG6DLaJxZ9jXCyNuOIxNBV+YUQ5wjgAuOuvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaxYnVzwb0/qjVWaWWaGIRJCOBnjqs5DvMqf6/7jzvY5xLlUhItBdEsnmqHVEc6Wq
	 Z/xNW2bdqw3mUzvxe6iSGvsbFrWGZqMJZ6ItGK7r7jxT6W9DGbVokZjn7DgyF/FxAo
	 kA+nQtujMYqMrPwyBjRcGHZaJMV5Jy2ObcVSrlUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/666] iommu/amd: Reduce domain lock scope in attach device path
Date: Wed, 20 May 2026 18:17:02 +0200
Message-ID: <20260520162115.778249205@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit d6b47dec368400a62d2b9d44c8e136fc15eac72c ]

Currently attach device path takes protection domain lock followed by
dev_data lock. Most of the operations in this function is specific to
device data except pdom_attach_iommu() where it updates protection
domain structure. Hence reduce the scope of protection domain lock.

Note that this changes the locking order. Now it takes device lock
before taking doamin lock (group->mutex -> dev_data->lock ->
pdom->lock). dev_data->lock is used only in device attachment path.
So changing order is fine. It will not create any issue.

Finally move numa node assignment to pdom_attach_iommu().

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-8-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: faad224fe0f0 ("iommu/amd: Fix clone_alias() to use the original device's devid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 52 ++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 799e1a1adfc32..3ac8f64a21475 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2057,16 +2057,23 @@ static int pdom_attach_iommu(struct amd_iommu *iommu,
 			     struct protection_domain *pdom)
 {
 	struct pdom_iommu_info *pdom_iommu_info, *curr;
+	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&pdom->lock, flags);
 
 	pdom_iommu_info = xa_load(&pdom->iommu_array, iommu->index);
 	if (pdom_iommu_info) {
 		pdom_iommu_info->refcnt++;
-		return 0;
+		goto out_unlock;
 	}
 
 	pdom_iommu_info = kzalloc(sizeof(*pdom_iommu_info), GFP_ATOMIC);
-	if (!pdom_iommu_info)
-		return -ENOMEM;
+	if (!pdom_iommu_info) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
 
 	pdom_iommu_info->iommu = iommu;
 	pdom_iommu_info->refcnt = 1;
@@ -2075,43 +2082,52 @@ static int pdom_attach_iommu(struct amd_iommu *iommu,
 			  NULL, pdom_iommu_info, GFP_ATOMIC);
 	if (curr) {
 		kfree(pdom_iommu_info);
-		return -ENOSPC;
+		ret = -ENOSPC;
+		goto out_unlock;
 	}
 
-	return 0;
+	/* Update NUMA Node ID */
+	if (cfg->amd.nid == NUMA_NO_NODE)
+		cfg->amd.nid = dev_to_node(&iommu->dev->dev);
+
+out_unlock:
+	spin_unlock_irqrestore(&pdom->lock, flags);
+	return ret;
 }
 
 static void pdom_detach_iommu(struct amd_iommu *iommu,
 			      struct protection_domain *pdom)
 {
 	struct pdom_iommu_info *pdom_iommu_info;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pdom->lock, flags);
 
 	pdom_iommu_info = xa_load(&pdom->iommu_array, iommu->index);
-	if (!pdom_iommu_info)
+	if (!pdom_iommu_info) {
+		spin_unlock_irqrestore(&pdom->lock, flags);
 		return;
+	}
 
 	pdom_iommu_info->refcnt--;
 	if (pdom_iommu_info->refcnt == 0) {
 		xa_erase(&pdom->iommu_array, iommu->index);
 		kfree(pdom_iommu_info);
 	}
+
+	spin_unlock_irqrestore(&pdom->lock, flags);
 }
 
 static int do_attach(struct iommu_dev_data *dev_data,
 		     struct protection_domain *domain)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
-	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	int ret = 0;
 
 	/* Update data structures */
 	dev_data->domain = domain;
 	list_add(&dev_data->list, &domain->dev_list);
 
-	/* Update NUMA Node ID */
-	if (cfg->amd.nid == NUMA_NO_NODE)
-		cfg->amd.nid = dev_to_node(dev_data->dev);
-
 	/* Do reference counting */
 	ret = pdom_attach_iommu(iommu, domain);
 	if (ret)
@@ -2133,12 +2149,15 @@ static void do_detach(struct iommu_dev_data *dev_data)
 {
 	struct protection_domain *domain = dev_data->domain;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
+	unsigned long flags;
 
 	/* Clear DTE and flush the entry */
 	dev_update_dte(dev_data, false);
 
 	/* Flush IOTLB and wait for the flushes to finish */
+	spin_lock_irqsave(&domain->lock, flags);
 	amd_iommu_domain_flush_all(domain);
+	spin_unlock_irqrestore(&domain->lock, flags);
 
 	/* Clear GCR3 table */
 	if (pdom_is_sva_capable(domain))
@@ -2160,11 +2179,8 @@ static int attach_device(struct device *dev,
 			 struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
-	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&domain->lock, flags);
-
 	dev_data = dev_iommu_priv_get(dev);
 
 	spin_lock(&dev_data->lock);
@@ -2179,8 +2195,6 @@ static int attach_device(struct device *dev,
 out:
 	spin_unlock(&dev_data->lock);
 
-	spin_unlock_irqrestore(&domain->lock, flags);
-
 	return ret;
 }
 
@@ -2190,13 +2204,9 @@ static int attach_device(struct device *dev,
 static void detach_device(struct device *dev)
 {
 	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
-	struct protection_domain *domain = dev_data->domain;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
-	unsigned long flags;
 	bool ppr = dev_data->ppr;
 
-	spin_lock_irqsave(&domain->lock, flags);
-
 	spin_lock(&dev_data->lock);
 
 	/*
@@ -2220,8 +2230,6 @@ static void detach_device(struct device *dev)
 out:
 	spin_unlock(&dev_data->lock);
 
-	spin_unlock_irqrestore(&domain->lock, flags);
-
 	/* Remove IOPF handler */
 	if (ppr)
 		amd_iommu_iopf_remove_device(iommu, dev_data);
-- 
2.53.0



