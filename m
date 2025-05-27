Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54351D63EF;
	Tue, 27 May 2025 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367874; cv=none; b=IrTz77Ca70vaM3ptURRuE4v1jlPeOEJEWeGvsk2Mexmd2tE0INHsLKQKH5OlzXA+PifULw5/PmJBD+ydCX1oHtowoLbcspas2Z1B7b/auFQjFV2KA4vkOAb5i+DRzdvFd4Qxfe9j3Oa0Gg2Xg+P3E9wuX7NBYIIsJzgKsqBaatw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367874; c=relaxed/simple;
	bh=VwZnoAyCCRlaVrzJxxVl4vmwMB6o51FS/JfrSCvQPP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aks0mSE8YvlaEiMrMHwyqenTAdzRiRcyaOZTVi/ZoaGcH560d63cfQ9Gkm6Gx18F3ZirS8VMwIgQS6PYQIgGtIdyROIFEgx9sxS7n7D/p8j3e4+7lauKN0uyMznu4P4XAj+lXMBBjj05Yly749LfxcsrzR7zoxRfWpCbkP2si0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBD6WfCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBD6WfCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293C6C4CEE9;
	Tue, 27 May 2025 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367874;
	bh=VwZnoAyCCRlaVrzJxxVl4vmwMB6o51FS/JfrSCvQPP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBD6WfCDcDlXBrh1wFk8fEzmEkXOkOAj1PESWv3JJA9aXS2zP6KhETQ54Ye+W5KRz
	 Ig93JbSPl74eUOA+9dRd5kkSho8JfjBxAzPNw7ORsEanaT09Sw4o9tnCAwRjNFJ7+h
	 66d9FfvDhDuEbJsUxcvcH/5RN6RvHK5pleDVQfDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 527/783] powerpc/pseries/iommu: memory notifier incorrectly adds TCEs for pmemory
Date: Tue, 27 May 2025 18:25:24 +0200
Message-ID: <20250527162534.613676459@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Batra <gbatra@linux.ibm.com>

[ Upstream commit 6aa989ab2bd0d37540c812b4270006ff794662e7 ]

iommu_mem_notifier() is invoked when RAM is dynamically added/removed. This
notifier call is responsible to add/remove TCEs from the Dynamic DMA Window
(DDW) when TCEs are pre-mapped. TCEs are pre-mapped only for RAM and not
for persistent memory (pmemory). For DMA buffers in pmemory, TCEs are
dynamically mapped when the device driver instructs to do so.

The issue is 'daxctl' command is capable of adding pmemory as "System RAM"
after LPAR boot. The command to do so is -

daxctl reconfigure-device --mode=system-ram dax0.0 --force

This will dynamically add pmemory range to LPAR RAM eventually invoking
iommu_mem_notifier(). The address range of pmemory is way beyond the Max
RAM that the LPAR can have. Which means, this range is beyond the DDW
created for the device, at device initialization time.

As a result when TCEs are pre-mapped for the pmemory range, by
iommu_mem_notifier(), PHYP HCALL returns H_PARAMETER. This failed the
command, daxctl, to add pmemory as RAM.

The solution is to not pre-map TCEs for pmemory.

Signed-off-by: Gaurav Batra <gbatra@linux.ibm.com>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250130183854.92258-1-gbatra@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/mmzone.h      |  1 +
 arch/powerpc/mm/numa.c                 |  2 +-
 arch/powerpc/platforms/pseries/iommu.c | 29 ++++++++++++++------------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index d99863cd6cde4..049152f8d597a 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -29,6 +29,7 @@ extern cpumask_var_t node_to_cpumask_map[];
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern unsigned long max_pfn;
 u64 memory_hotplug_max(void);
+u64 hot_add_drconf_memory_max(void);
 #else
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 3c1da08304d03..603a0f652ba61 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1336,7 +1336,7 @@ int hot_add_scn_to_nid(unsigned long scn_addr)
 	return nid;
 }
 
-static u64 hot_add_drconf_memory_max(void)
+u64 hot_add_drconf_memory_max(void)
 {
 	struct device_node *memory = NULL;
 	struct device_node *dn = NULL;
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index ae6f7a235d8b2..8f32340960e21 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1284,17 +1284,13 @@ static LIST_HEAD(failed_ddw_pdn_list);
 
 static phys_addr_t ddw_memory_hotplug_max(void)
 {
-	resource_size_t max_addr = memory_hotplug_max();
-	struct device_node *memory;
+	resource_size_t max_addr;
 
-	for_each_node_by_type(memory, "memory") {
-		struct resource res;
-
-		if (of_address_to_resource(memory, 0, &res))
-			continue;
-
-		max_addr = max_t(resource_size_t, max_addr, res.end + 1);
-	}
+#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
+	max_addr = hot_add_drconf_memory_max();
+#else
+	max_addr = memblock_end_of_DRAM();
+#endif
 
 	return max_addr;
 }
@@ -1600,7 +1596,7 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 
 	if (direct_mapping) {
 		/* DDW maps the whole partition, so enable direct DMA mapping */
-		ret = walk_system_ram_range(0, memblock_end_of_DRAM() >> PAGE_SHIFT,
+		ret = walk_system_ram_range(0, ddw_memory_hotplug_max() >> PAGE_SHIFT,
 					    win64->value, tce_setrange_multi_pSeriesLP_walk);
 		if (ret) {
 			dev_info(&dev->dev, "failed to map DMA window for %pOF: %d\n",
@@ -2349,11 +2345,17 @@ static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
 	struct memory_notify *arg = data;
 	int ret = 0;
 
+	/* This notifier can get called when onlining persistent memory as well.
+	 * TCEs are not pre-mapped for persistent memory. Persistent memory will
+	 * always be above ddw_memory_hotplug_max()
+	 */
+
 	switch (action) {
 	case MEM_GOING_ONLINE:
 		spin_lock(&dma_win_list_lock);
 		list_for_each_entry(window, &dma_win_list, list) {
-			if (window->direct) {
+			if (window->direct && (arg->start_pfn << PAGE_SHIFT) <
+				ddw_memory_hotplug_max()) {
 				ret |= tce_setrange_multi_pSeriesLP(arg->start_pfn,
 						arg->nr_pages, window->prop);
 			}
@@ -2365,7 +2367,8 @@ static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
 	case MEM_OFFLINE:
 		spin_lock(&dma_win_list_lock);
 		list_for_each_entry(window, &dma_win_list, list) {
-			if (window->direct) {
+			if (window->direct && (arg->start_pfn << PAGE_SHIFT) <
+				ddw_memory_hotplug_max()) {
 				ret |= tce_clearrange_multi_pSeriesLP(arg->start_pfn,
 						arg->nr_pages, window->prop);
 			}
-- 
2.39.5



