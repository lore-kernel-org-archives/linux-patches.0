Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86EB3F58D6;
	Wed, 20 May 2026 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300548; cv=none; b=oXHca/jHF9Zpnyzi6uX+JqJvqKCIh2VD2ZoYfIHWvLYeCaZjd32yG/E3xpB16h71a/DNwCcO8pdHvxIRqPO/yB08wRGpPMoMevbEUw4DOwx3w1oVYQImI94bARdvlmkKCRlgB2njKM+OHJv7VEIIk78atH0KiY7QjQ1IN+Dy6Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300548; c=relaxed/simple;
	bh=H7BhpQqReDgP+OLZsDU5LOxt/+umZGBIlyM9hyhUR4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTLwP6Mzf8uvJsSZdSsB5Kadx8nvXS9lT08a2kdqWupNk4KbwUPXxFj8uE94XUCkeMWgeQnutahozfJTkIK67OGkAzWnQavHxU6C8f4ftV2WbDiEKhC4e6MbGvbjMpaKUuhIQZuCoViTx8/y4MZ80Cimiep+lUUNrQ2qDWoxPSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+uLHBoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+uLHBoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031771F00893;
	Wed, 20 May 2026 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300546;
	bh=6z4tPKn0zEXwKcG3VF+ax3JdnjOl3IG6XW4wc6vatgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+uLHBoAhU6o3RgEQYM/Qmy5hqtCz4kEU+CNAA1pnRxlibzbo9bzHHt2TZCFAOfpI
	 XOQbSnzloxmMb3FzjKgN8Ga40nfm1KiZhTpeMR7+2UgumydhGLGPf6Ysn4yQaOd/IK
	 BwpyytUDJbXyKixh+O9SIWxOh5CF2vc9Mz8Akrs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/666] iommu/amd: xarray to track protection_domain->iommu list
Date: Wed, 20 May 2026 18:17:00 +0200
Message-ID: <20260520162115.734755864@linuxfoundation.org>
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

[ Upstream commit d16041124de1dea4389b5e6b330657f34f8c0492 ]

Use xarray to track IOMMU attached to protection domain instead of
static array of MAX_IOMMUS. Also add lockdep assertion.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-5-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: faad224fe0f0 ("iommu/amd: Fix clone_alias() to use the original device's devid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h |  8 ++-
 drivers/iommu/amd/iommu.c           | 89 +++++++++++++++++++++++------
 2 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index d5a689a4f4397..f99a4b1349287 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -567,6 +567,12 @@ struct pdom_dev_data {
 	struct list_head list;
 };
 
+/* Keeps track of the IOMMUs attached to protection domain */
+struct pdom_iommu_info {
+	struct amd_iommu *iommu; /* IOMMUs attach to protection domain */
+	u32 refcnt;	/* Count of attached dev/pasid per domain/IOMMU */
+};
+
 /*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
@@ -580,7 +586,7 @@ struct protection_domain {
 	u16 id;			/* the domain id written to the device table */
 	enum protection_domain_mode pd_mode; /* Track page table type */
 	bool dirty_tracking;	/* dirty tracking is enabled in the domain */
-	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
+	struct xarray iommu_array;	/* per-IOMMU reference count */
 
 	struct mmu_notifier mn;	/* mmu notifier for the SVA domain */
 	struct list_head dev_data_list; /* List of pdom_dev_data */
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index cf03fe0e8b083..d9b296e007cc7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1290,18 +1290,17 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 static void domain_flush_complete(struct protection_domain *domain)
 {
-	int i;
+	struct pdom_iommu_info *pdom_iommu_info;
+	unsigned long i;
 
-	for (i = 0; i < amd_iommu_get_num_iommus(); ++i) {
-		if (domain && !domain->dev_iommu[i])
-			continue;
+	lockdep_assert_held(&domain->lock);
 
-		/*
-		 * Devices of this domain are behind this IOMMU
-		 * We need to wait for completion of all commands.
-		 */
-		iommu_completion_wait(amd_iommus[i]);
-	}
+	/*
+	 * Devices of this domain are behind this IOMMU
+	 * We need to wait for completion of all commands.
+	 */
+	 xa_for_each(&domain->iommu_array, i, pdom_iommu_info)
+		iommu_completion_wait(pdom_iommu_info->iommu);
 }
 
 static int iommu_flush_dte(struct amd_iommu *iommu, u16 devid)
@@ -1483,21 +1482,22 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 static int domain_flush_pages_v1(struct protection_domain *pdom,
 				 u64 address, size_t size)
 {
+	struct pdom_iommu_info *pdom_iommu_info;
 	struct iommu_cmd cmd;
-	int ret = 0, i;
+	int ret = 0;
+	unsigned long i;
+
+	lockdep_assert_held(&pdom->lock);
 
 	build_inv_iommu_pages(&cmd, address, size,
 			      pdom->id, IOMMU_NO_PASID, false);
 
-	for (i = 0; i < amd_iommu_get_num_iommus(); ++i) {
-		if (!pdom->dev_iommu[i])
-			continue;
-
+	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
 		/*
 		 * Devices of this domain are behind this IOMMU
 		 * We need a TLB flush
 		 */
-		ret |= iommu_queue_command(amd_iommus[i], &cmd);
+		ret |= iommu_queue_command(pdom_iommu_info->iommu, &cmd);
 	}
 
 	return ret;
@@ -1536,6 +1536,8 @@ static void __domain_flush_pages(struct protection_domain *domain,
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size)
 {
+	lockdep_assert_held(&domain->lock);
+
 	if (likely(!amd_iommu_np_cache)) {
 		__domain_flush_pages(domain, address, size);
 
@@ -2051,6 +2053,50 @@ static void destroy_gcr3_table(struct iommu_dev_data *dev_data,
 	free_gcr3_table(gcr3_info);
 }
 
+static int pdom_attach_iommu(struct amd_iommu *iommu,
+			     struct protection_domain *pdom)
+{
+	struct pdom_iommu_info *pdom_iommu_info, *curr;
+
+	pdom_iommu_info = xa_load(&pdom->iommu_array, iommu->index);
+	if (pdom_iommu_info) {
+		pdom_iommu_info->refcnt++;
+		return 0;
+	}
+
+	pdom_iommu_info = kzalloc(sizeof(*pdom_iommu_info), GFP_ATOMIC);
+	if (!pdom_iommu_info)
+		return -ENOMEM;
+
+	pdom_iommu_info->iommu = iommu;
+	pdom_iommu_info->refcnt = 1;
+
+	curr = xa_cmpxchg(&pdom->iommu_array, iommu->index,
+			  NULL, pdom_iommu_info, GFP_ATOMIC);
+	if (curr) {
+		kfree(pdom_iommu_info);
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
+static void pdom_detach_iommu(struct amd_iommu *iommu,
+			      struct protection_domain *pdom)
+{
+	struct pdom_iommu_info *pdom_iommu_info;
+
+	pdom_iommu_info = xa_load(&pdom->iommu_array, iommu->index);
+	if (!pdom_iommu_info)
+		return;
+
+	pdom_iommu_info->refcnt--;
+	if (pdom_iommu_info->refcnt == 0) {
+		xa_erase(&pdom->iommu_array, iommu->index);
+		kfree(pdom_iommu_info);
+	}
+}
+
 static int do_attach(struct iommu_dev_data *dev_data,
 		     struct protection_domain *domain)
 {
@@ -2067,13 +2113,17 @@ static int do_attach(struct iommu_dev_data *dev_data,
 		cfg->amd.nid = dev_to_node(dev_data->dev);
 
 	/* Do reference counting */
-	domain->dev_iommu[iommu->index] += 1;
+	ret = pdom_attach_iommu(iommu, domain);
+	if (ret)
+		return ret;
 
 	/* Setup GCR3 table */
 	if (pdom_is_sva_capable(domain)) {
 		ret = init_gcr3_table(dev_data, domain);
-		if (ret)
+		if (ret) {
+			pdom_detach_iommu(iommu, domain);
 			return ret;
+		}
 	}
 
 	return ret;
@@ -2099,7 +2149,7 @@ static void do_detach(struct iommu_dev_data *dev_data)
 	list_del(&dev_data->list);
 
 	/* decrease reference counters - needs to happen after the flushes */
-	domain->dev_iommu[iommu->index] -= 1;
+	pdom_detach_iommu(iommu, domain);
 }
 
 /*
@@ -2307,6 +2357,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
 	INIT_LIST_HEAD(&domain->dev_data_list);
+	xa_init(&domain->iommu_array);
 	domain->iop.pgtbl.cfg.amd.nid = nid;
 
 	switch (type) {
-- 
2.53.0



