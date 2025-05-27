Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08723271476;
	Tue, 27 May 2025 17:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365575; cv=none; b=gWjeO36q6MGFJfQrmOZidNytWqT3HedsdBAvxmjOyJ011Sz2Aw51etkv9K7+0LIvuMSoVYsKVDZ9aP+5V6INsqPQV1j7nkd1uzHMJPo8SBjqoLmJc3TU0hzbu1X+h6hHHvj4Qm/BzcnQP7lgdpKz84XRwzFF28zKvjL/2DS/Ru4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365575; c=relaxed/simple;
	bh=xJq2MDG0FBFUfhjNwnrOfQHPqWCvJFYnC/z2xTWOsPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFfS4ADbIA2OFIlmw3iRhaLGI++EFGIprh81WlJcHPaqSQCOwnS2VdODdMtM6XEkOJ2DPmOgtKg8iGhxBG/0Nr5PvgNCCg1lgNNaPo6DSSDTTVl7JL52D0eadWLG+9EKyTw9I5MrMXBxfPAhsnPHn1eK65PCsblzKUAEtcMdwIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tye3Zyhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tye3Zyhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB6DC4CEE9;
	Tue, 27 May 2025 17:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365574;
	bh=xJq2MDG0FBFUfhjNwnrOfQHPqWCvJFYnC/z2xTWOsPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tye3ZyhvaV3vNje0QBBX06iCHpA5SsrA1LZv2JRHxrTNHZlHq3h+hFZ08AgaW+CTq
	 pU9bRc0v2h80pM+Skrx4eZKuy3L9z5HfL/yvuvXWQeQJmSWec6OTMsfgFK86lRC+h5
	 5sJWGg4AaLZsrsHfV1FhydSSKqMRhtZkERXea6pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/626] powerpc/pseries/iommu: create DDW for devices with DMA mask less than 64-bits
Date: Tue, 27 May 2025 18:25:14 +0200
Message-ID: <20250527162502.117333074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Batra <gbatra@linux.ibm.com>

[ Upstream commit 67dfc11982f7e3c37f0977e74671da2391b29181 ]

Starting with PAPR level 2.13, platform supports placing PHB in limited
address mode. Devices that support DMA masks less that 64-bit but greater
than 32-bits are placed in limited address mode. In this mode, the
starting DMA address returned by the DDW is 4GB.

When the device driver calls dma_supported, with mask less then 64-bit, the
PowerPC IOMMU driver places PHB in the Limited Addressing Mode before
creating DDW.

Signed-off-by: Gaurav Batra <gbatra@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250108164814.73250-1-gbatra@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 110 +++++++++++++++++++++----
 1 file changed, 94 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 8f32340960e21..d6ebc19fb99c5 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -52,7 +52,8 @@ enum {
 enum {
 	DDW_EXT_SIZE = 0,
 	DDW_EXT_RESET_DMA_WIN = 1,
-	DDW_EXT_QUERY_OUT_SIZE = 2
+	DDW_EXT_QUERY_OUT_SIZE = 2,
+	DDW_EXT_LIMITED_ADDR_MODE = 3
 };
 
 static struct iommu_table *iommu_pseries_alloc_table(int node)
@@ -1327,6 +1328,54 @@ static void reset_dma_window(struct pci_dev *dev, struct device_node *par_dn)
 			 ret);
 }
 
+/*
+ * Platforms support placing PHB in limited address mode starting with LoPAR
+ * level 2.13 implement. In this mode, the DMA address returned by DDW is over
+ * 4GB but, less than 64-bits. This benefits IO adapters that don't support
+ * 64-bits for DMA addresses.
+ */
+static int limited_dma_window(struct pci_dev *dev, struct device_node *par_dn)
+{
+	int ret;
+	u32 cfg_addr, reset_dma_win, las_supported;
+	u64 buid;
+	struct device_node *dn;
+	struct pci_dn *pdn;
+
+	ret = ddw_read_ext(par_dn, DDW_EXT_RESET_DMA_WIN, &reset_dma_win);
+	if (ret)
+		goto out;
+
+	ret = ddw_read_ext(par_dn, DDW_EXT_LIMITED_ADDR_MODE, &las_supported);
+
+	/* Limited Address Space extension available on the platform but DDW in
+	 * limited addressing mode not supported
+	 */
+	if (!ret && !las_supported)
+		ret = -EPROTO;
+
+	if (ret) {
+		dev_info(&dev->dev, "Limited Address Space for DDW not Supported, err: %d", ret);
+		goto out;
+	}
+
+	dn = pci_device_to_OF_node(dev);
+	pdn = PCI_DN(dn);
+	buid = pdn->phb->buid;
+	cfg_addr = (pdn->busno << 16) | (pdn->devfn << 8);
+
+	ret = rtas_call(reset_dma_win, 4, 1, NULL, cfg_addr, BUID_HI(buid),
+			BUID_LO(buid), 1);
+	if (ret)
+		dev_info(&dev->dev,
+			 "ibm,reset-pe-dma-windows(%x) for Limited Addr Support: %x %x %x returned %d ",
+			 reset_dma_win, cfg_addr, BUID_HI(buid), BUID_LO(buid),
+			 ret);
+
+out:
+	return ret;
+}
+
 /* Return largest page shift based on "IO Page Sizes" output of ibm,query-pe-dma-window. */
 static int iommu_get_page_shift(u32 query_page_size)
 {
@@ -1394,7 +1443,7 @@ static struct property *ddw_property_create(const char *propname, u32 liobn, u64
  *
  * returns true if can map all pages (direct mapping), false otherwise..
  */
-static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
+static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn, u64 dma_mask)
 {
 	int len = 0, ret;
 	int max_ram_len = order_base_2(ddw_memory_hotplug_max());
@@ -1413,6 +1462,9 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	bool pmem_present;
 	struct pci_dn *pci = PCI_DN(pdn);
 	struct property *default_win = NULL;
+	bool limited_addr_req = false, limited_addr_enabled = false;
+	int dev_max_ddw;
+	int ddw_sz;
 
 	dn = of_find_node_by_type(NULL, "ibm,pmemory");
 	pmem_present = dn != NULL;
@@ -1439,7 +1491,6 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	 * the ibm,ddw-applicable property holds the tokens for:
 	 * ibm,query-pe-dma-window
 	 * ibm,create-pe-dma-window
-	 * ibm,remove-pe-dma-window
 	 * for the given node in that order.
 	 * the property is actually in the parent, not the PE
 	 */
@@ -1459,6 +1510,20 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	if (ret != 0)
 		goto out_failed;
 
+	/* DMA Limited Addressing required? This is when the driver has
+	 * requested to create DDW but supports mask which is less than 64-bits
+	 */
+	limited_addr_req = (dma_mask != DMA_BIT_MASK(64));
+
+	/* place the PHB in Limited Addressing mode */
+	if (limited_addr_req) {
+		if (limited_dma_window(dev, pdn))
+			goto out_failed;
+
+		/* PHB is in Limited address mode */
+		limited_addr_enabled = true;
+	}
+
 	/*
 	 * If there is no window available, remove the default DMA window,
 	 * if it's present. This will make all the resources available to the
@@ -1505,6 +1570,15 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 		goto out_failed;
 	}
 
+	/* Maximum DMA window size that the device can address (in log2) */
+	dev_max_ddw = fls64(dma_mask);
+
+	/* If the device DMA mask is less than 64-bits, make sure the DMA window
+	 * size is not bigger than what the device can access
+	 */
+	ddw_sz = min(order_base_2(query.largest_available_block << page_shift),
+			dev_max_ddw);
+
 	/*
 	 * The "ibm,pmemory" can appear anywhere in the address space.
 	 * Assuming it is still backed by page structs, try MAX_PHYSMEM_BITS
@@ -1513,23 +1587,21 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	 */
 	len = max_ram_len;
 	if (pmem_present) {
-		if (query.largest_available_block >=
-		    (1ULL << (MAX_PHYSMEM_BITS - page_shift)))
+		if (ddw_sz >= MAX_PHYSMEM_BITS)
 			len = MAX_PHYSMEM_BITS;
 		else
 			dev_info(&dev->dev, "Skipping ibm,pmemory");
 	}
 
 	/* check if the available block * number of ptes will map everything */
-	if (query.largest_available_block < (1ULL << (len - page_shift))) {
+	if (ddw_sz < len) {
 		dev_dbg(&dev->dev,
 			"can't map partition max 0x%llx with %llu %llu-sized pages\n",
 			1ULL << len,
 			query.largest_available_block,
 			1ULL << page_shift);
 
-		len = order_base_2(query.largest_available_block << page_shift);
-
+		len = ddw_sz;
 		dynamic_mapping = true;
 	} else {
 		direct_mapping = !default_win_removed ||
@@ -1543,8 +1615,9 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 		 */
 		if (default_win_removed && pmem_present && !direct_mapping) {
 			/* DDW is big enough to be split */
-			if ((query.largest_available_block << page_shift) >=
-			     MIN_DDW_VPMEM_DMA_WINDOW + (1ULL << max_ram_len)) {
+			if ((1ULL << ddw_sz) >=
+			    MIN_DDW_VPMEM_DMA_WINDOW + (1ULL << max_ram_len)) {
+
 				direct_mapping = true;
 
 				/* offset of the Dynamic part of DDW */
@@ -1555,8 +1628,7 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 			dynamic_mapping = true;
 
 			/* create max size DDW possible */
-			len = order_base_2(query.largest_available_block
-							<< page_shift);
+			len = ddw_sz;
 		}
 	}
 
@@ -1685,7 +1757,7 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	__remove_dma_window(pdn, ddw_avail, create.liobn);
 
 out_failed:
-	if (default_win_removed)
+	if (default_win_removed || limited_addr_enabled)
 		reset_dma_window(dev, pdn);
 
 	fpdn = kzalloc(sizeof(*fpdn), GFP_KERNEL);
@@ -1704,6 +1776,9 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 		dev->dev.bus_dma_limit = dev->dev.archdata.dma_offset +
 						(1ULL << max_ram_len);
 
+	dev_info(&dev->dev, "lsa_required: %x, lsa_enabled: %x, direct mapping: %x\n",
+			limited_addr_req, limited_addr_enabled, direct_mapping);
+
 	return direct_mapping;
 }
 
@@ -1829,8 +1904,11 @@ static bool iommu_bypass_supported_pSeriesLP(struct pci_dev *pdev, u64 dma_mask)
 {
 	struct device_node *dn = pci_device_to_OF_node(pdev), *pdn;
 
-	/* only attempt to use a new window if 64-bit DMA is requested */
-	if (dma_mask < DMA_BIT_MASK(64))
+	/* For DDW, DMA mask should be more than 32-bits. For mask more then
+	 * 32-bits but less then 64-bits, DMA addressing is supported in
+	 * Limited Addressing mode.
+	 */
+	if (dma_mask <= DMA_BIT_MASK(32))
 		return false;
 
 	dev_dbg(&pdev->dev, "node is %pOF\n", dn);
@@ -1843,7 +1921,7 @@ static bool iommu_bypass_supported_pSeriesLP(struct pci_dev *pdev, u64 dma_mask)
 	 */
 	pdn = pci_dma_find(dn, NULL);
 	if (pdn && PCI_DN(pdn))
-		return enable_ddw(pdev, pdn);
+		return enable_ddw(pdev, pdn, dma_mask);
 
 	return false;
 }
-- 
2.39.5



