Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC43B774F;
	Sat, 17 Oct 2026 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257781; cv=none; b=iFQte9YVjRMEBG4je9O79BRYPFw9nJkrHRPdrFTh0Y1nxQWP3IWQV+ntgDVk9HDJBGvwWQt4WVfgHk2fMiOFG2H/vrC/JB4W6+4A5RNHG5nh65K3ZlouuRh2+Z8dzt/AJRmHESnebphNR37g8mbdo+7rY4HN1eKwrFEeYnbl7SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257781; c=relaxed/simple;
	bh=SD0ALSKUFJ5IC/OjqDPweemGvJgv58DlMNELlYUkzp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehjmqP0HGUcN6of5WzReof+YPlEpoXhaoVpCmmjEmvwHaT2/6vmuF9BQ8lWNA1e9UnIxskSJjD/V6tZFMpnKB4SfNec+tBhIOBrMqlWpiqiMatOdtzatSq/alFhIIR5N/gGa7RVSV6epvJVdarFcD2BzhsoWSEINcZsTikXzbKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bishBzcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bishBzcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EDA1F000C5;
	Sat, 17 Oct 2026 17:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257780;
	bh=NVSR5z7zYds3Xc/Jo3A/Tz1Hwcyz+widYyqT1Y/Kw/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bishBzcAh++M/jlFmyQB1S385ktyMY5etT2IptJnm3xa8t30S+1NYrFWaOmNNfIQ7
	 AVecU4z5f/Rw5yualFfd55OIVyf6GVyi8rcYfxW36hqAwAcJF2jF/T1GyWfq2gf1Ho
	 BCICFwfhz7j38Y3i3e1GTDhwlHCrH0nSgYdE+RZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0669/1674] powerpc/iommu: Move pSeries specific functions to pseries/iommu.c
Date: Sat, 17 Oct 2026 17:49:01 +0200
Message-ID: <20261017160448.281572781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit b09c031d9433dda3186190e5845ba0d720212567 ]

The PowerNV specific table_group_ops are defined in powernv/pci-ioda.c.
The pSeries specific table_group_ops are sitting in the generic powerpc
file. Move it to where it actually belong(pseries/iommu.c).

The functions are currently defined even for CONFIG_PPC_POWERNV
which are unused on PowerNV.

Only code movement, no functional changes intended.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/171923269701.1397.15758640002786937132.stgit@linux.ibm.com
Stable-dep-of: 8f70caad82e9 ("powerpc/pseries/iommu: IOMMU incorrectly marks MMIO range in DDW")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/iommu.h       |   4 +-
 arch/powerpc/kernel/iommu.c            | 149 +------------------------
 arch/powerpc/platforms/pseries/iommu.c | 144 ++++++++++++++++++++++++
 3 files changed, 149 insertions(+), 148 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 0266959435505..744cc5fc22d3b 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -156,6 +156,9 @@ extern int iommu_tce_table_put(struct iommu_table *tbl);
 extern struct iommu_table *iommu_init_table(struct iommu_table *tbl,
 		int nid, unsigned long res_start, unsigned long res_end);
 bool iommu_table_in_use(struct iommu_table *tbl);
+extern void iommu_table_reserve_pages(struct iommu_table *tbl,
+		unsigned long res_start, unsigned long res_end);
+extern void iommu_table_clear(struct iommu_table *tbl);
 
 #define IOMMU_TABLE_GROUP_MAX_TABLES	2
 
@@ -218,7 +221,6 @@ extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
 extern void iommu_tce_kill(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
 
-extern struct iommu_table_group_ops spapr_tce_table_group_ops;
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
 					int pci_domain_number,
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 49f01f6b9346b..af306dcc9e400 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -642,7 +642,7 @@ void ppc_iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 		tbl->it_ops->flush(tbl);
 }
 
-static void iommu_table_clear(struct iommu_table *tbl)
+void iommu_table_clear(struct iommu_table *tbl)
 {
 	/*
 	 * In case of firmware assisted dump system goes through clean
@@ -683,7 +683,7 @@ static void iommu_table_clear(struct iommu_table *tbl)
 #endif
 }
 
-static void iommu_table_reserve_pages(struct iommu_table *tbl,
+void iommu_table_reserve_pages(struct iommu_table *tbl,
 		unsigned long res_start, unsigned long res_end)
 {
 	int i;
@@ -1101,59 +1101,6 @@ void iommu_tce_kill(struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_kill);
 
-#if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV)
-static int iommu_take_ownership(struct iommu_table *tbl)
-{
-	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
-	int ret = 0;
-
-	/*
-	 * VFIO does not control TCE entries allocation and the guest
-	 * can write new TCEs on top of existing ones so iommu_tce_build()
-	 * must be able to release old pages. This functionality
-	 * requires exchange() callback defined so if it is not
-	 * implemented, we disallow taking ownership over the table.
-	 */
-	if (!tbl->it_ops->xchg_no_kill)
-		return -EINVAL;
-
-	spin_lock_irqsave(&tbl->large_pool.lock, flags);
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
-
-	if (iommu_table_in_use(tbl)) {
-		pr_err("iommu_tce: it_map is not empty");
-		ret = -EBUSY;
-	} else {
-		memset(tbl->it_map, 0xff, sz);
-	}
-
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_unlock(&tbl->pools[i].lock);
-	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
-
-	return ret;
-}
-
-static void iommu_release_ownership(struct iommu_table *tbl)
-{
-	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
-
-	spin_lock_irqsave(&tbl->large_pool.lock, flags);
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
-
-	memset(tbl->it_map, 0, sz);
-
-	iommu_table_reserve_pages(tbl, tbl->it_reserved_start,
-			tbl->it_reserved_end);
-
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_unlock(&tbl->pools[i].lock);
-	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
-}
-#endif
-
 int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
 {
 	/*
@@ -1185,98 +1132,6 @@ int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
 EXPORT_SYMBOL_GPL(iommu_add_device);
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV)
-/*
- * A simple iommu_table_group_ops which only allows reusing the existing
- * iommu_table. This handles VFIO for POWER7 or the nested KVM.
- * The ops does not allow creating windows and only allows reusing the existing
- * one if it matches table_group->tce32_start/tce32_size/page_shift.
- */
-static unsigned long spapr_tce_get_table_size(__u32 page_shift,
-					      __u64 window_size, __u32 levels)
-{
-	unsigned long size;
-
-	if (levels > 1)
-		return ~0U;
-	size = window_size >> (page_shift - 3);
-	return size;
-}
-
-static long spapr_tce_create_table(struct iommu_table_group *table_group, int num,
-				   __u32 page_shift, __u64 window_size, __u32 levels,
-				   struct iommu_table **ptbl)
-{
-	struct iommu_table *tbl = table_group->tables[0];
-
-	if (num > 0)
-		return -EPERM;
-
-	if (tbl->it_page_shift != page_shift ||
-	    tbl->it_size != (window_size >> page_shift) ||
-	    tbl->it_indirect_levels != levels - 1)
-		return -EINVAL;
-
-	*ptbl = iommu_tce_table_get(tbl);
-	return 0;
-}
-
-static long spapr_tce_set_window(struct iommu_table_group *table_group,
-				 int num, struct iommu_table *tbl)
-{
-	return tbl == table_group->tables[num] ? 0 : -EPERM;
-}
-
-static long spapr_tce_unset_window(struct iommu_table_group *table_group, int num)
-{
-	return 0;
-}
-
-static long spapr_tce_take_ownership(struct iommu_table_group *table_group)
-{
-	int i, j, rc = 0;
-
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = table_group->tables[i];
-
-		if (!tbl || !tbl->it_map)
-			continue;
-
-		rc = iommu_take_ownership(tbl);
-		if (!rc)
-			continue;
-
-		for (j = 0; j < i; ++j)
-			iommu_release_ownership(table_group->tables[j]);
-		return rc;
-	}
-	return 0;
-}
-
-static void spapr_tce_release_ownership(struct iommu_table_group *table_group)
-{
-	int i;
-
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = table_group->tables[i];
-
-		if (!tbl)
-			continue;
-
-		iommu_table_clear(tbl);
-		if (tbl->it_map)
-			iommu_release_ownership(tbl);
-	}
-}
-
-struct iommu_table_group_ops spapr_tce_table_group_ops = {
-	.get_table_size = spapr_tce_get_table_size,
-	.create_table = spapr_tce_create_table,
-	.set_window = spapr_tce_set_window,
-	.unset_window = spapr_tce_unset_window,
-	.take_ownership = spapr_tce_take_ownership,
-	.release_ownership = spapr_tce_release_ownership,
-};
-
 /*
  * A simple iommu_ops to allow less cruft in generic VFIO code.
  */
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 54fd2a0d6604d..82d88389ec67b 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -54,6 +54,57 @@ enum {
 	DDW_EXT_QUERY_OUT_SIZE = 2
 };
 
+static int iommu_take_ownership(struct iommu_table *tbl)
+{
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+	int ret = 0;
+
+	/*
+	 * VFIO does not control TCE entries allocation and the guest
+	 * can write new TCEs on top of existing ones so iommu_tce_build()
+	 * must be able to release old pages. This functionality
+	 * requires exchange() callback defined so if it is not
+	 * implemented, we disallow taking ownership over the table.
+	 */
+	if (!tbl->it_ops->xchg_no_kill)
+		return -EINVAL;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
+
+	if (iommu_table_in_use(tbl)) {
+		pr_err("iommu_tce: it_map is not empty");
+		ret = -EBUSY;
+	} else {
+		memset(tbl->it_map, 0xff, sz);
+	}
+
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+
+	return ret;
+}
+
+static void iommu_release_ownership(struct iommu_table *tbl)
+{
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
+
+	memset(tbl->it_map, 0, sz);
+
+	iommu_table_reserve_pages(tbl, tbl->it_reserved_start,
+			tbl->it_reserved_end);
+
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+}
+
 static struct iommu_table *iommu_pseries_alloc_table(int node)
 {
 	struct iommu_table *tbl;
@@ -67,6 +118,8 @@ static struct iommu_table *iommu_pseries_alloc_table(int node)
 	return tbl;
 }
 
+static struct iommu_table_group_ops spapr_tce_table_group_ops;
+
 static struct iommu_table_group *iommu_pseries_alloc_group(int node)
 {
 	struct iommu_table_group *table_group;
@@ -1648,6 +1701,97 @@ static bool iommu_bypass_supported_pSeriesLP(struct pci_dev *pdev, u64 dma_mask)
 	return false;
 }
 
+/*
+ * A simple iommu_table_group_ops which only allows reusing the existing
+ * iommu_table. This handles VFIO for POWER7 or the nested KVM.
+ * The ops does not allow creating windows and only allows reusing the existing
+ * one if it matches table_group->tce32_start/tce32_size/page_shift.
+ */
+static unsigned long spapr_tce_get_table_size(__u32 page_shift,
+					      __u64 window_size, __u32 levels)
+{
+	unsigned long size;
+
+	if (levels > 1)
+		return ~0U;
+	size = window_size >> (page_shift - 3);
+	return size;
+}
+
+static long spapr_tce_create_table(struct iommu_table_group *table_group, int num,
+				   __u32 page_shift, __u64 window_size, __u32 levels,
+				   struct iommu_table **ptbl)
+{
+	struct iommu_table *tbl = table_group->tables[0];
+
+	if (num > 0)
+		return -EPERM;
+
+	if (tbl->it_page_shift != page_shift ||
+	    tbl->it_size != (window_size >> page_shift) ||
+	    tbl->it_indirect_levels != levels - 1)
+		return -EINVAL;
+
+	*ptbl = iommu_tce_table_get(tbl);
+	return 0;
+}
+
+static long spapr_tce_set_window(struct iommu_table_group *table_group,
+				 int num, struct iommu_table *tbl)
+{
+	return tbl == table_group->tables[num] ? 0 : -EPERM;
+}
+
+static long spapr_tce_unset_window(struct iommu_table_group *table_group, int num)
+{
+	return 0;
+}
+
+static long spapr_tce_take_ownership(struct iommu_table_group *table_group)
+{
+	int i, j, rc = 0;
+
+	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = table_group->tables[i];
+
+		if (!tbl || !tbl->it_map)
+			continue;
+
+		rc = iommu_take_ownership(tbl);
+		if (!rc)
+			continue;
+
+		for (j = 0; j < i; ++j)
+			iommu_release_ownership(table_group->tables[j]);
+		return rc;
+	}
+	return 0;
+}
+
+static void spapr_tce_release_ownership(struct iommu_table_group *table_group)
+{
+	int i;
+
+	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = table_group->tables[i];
+
+		if (!tbl)
+			continue;
+
+		if (tbl->it_map)
+			iommu_release_ownership(tbl);
+	}
+}
+
+static struct iommu_table_group_ops spapr_tce_table_group_ops = {
+	.get_table_size = spapr_tce_get_table_size,
+	.create_table = spapr_tce_create_table,
+	.set_window = spapr_tce_set_window,
+	.unset_window = spapr_tce_unset_window,
+	.take_ownership = spapr_tce_take_ownership,
+	.release_ownership = spapr_tce_release_ownership,
+};
+
 static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
 		void *data)
 {
-- 
2.53.0



