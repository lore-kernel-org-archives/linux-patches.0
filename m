Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7803A9629;
	Fri,  4 Sep 2026 05:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500339; cv=none; b=KqmuqiZEkwspmFDputSnmTs2tjxzakZfnn9VG4fzUsfkoPX8C8/CWgcTuewkVJEs65+A8ZqKzGjHcMMVqMOZKtTLss2GNKn2bfKdd0hs03dA553tpB36Tkxvuvs32iDBl5OhhvnZLr3e5evRZnq0aYWL0OErNMkkfzVY4/5xUQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500339; c=relaxed/simple;
	bh=uvdrTnTS9GdCrBYef9pDBoLM/igMO8ftbqNnyEu5NA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgLTToem4F8thqlFIBJJCVlxpLM/OiByq4y92/gNyQBoa9ZHnLua52giuI03sgiABhJtRxWmcwg+4zTV32Us8dHhTJL08sFWntfJFxMYuS99RUKDkY1qCuzqavLPltIRb3qtuufA3r6n+CWgMKNzOBCjeGzP4mgiIIBthpXvNZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYt2er2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYt2er2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D51D1F00A3D;
	Fri,  4 Sep 2026 05:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500338;
	bh=TKA8Ipw4KwCdFq8iYj+9DsVQSQzGEXnGNAHFntYfeUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYt2er2MxHIqlcg3VC/KEfnDNoMG7hIg+yf1hMUfrQnwjdxQAzGvzMMJdj838gmhb
	 EE9JtdSfwwLfW9Y1vxbO7hz18gGB85yFYGYDkzaDBQjnhNygoDL3jqZjAm07B0jSI/
	 4H4nDqkEkAwT3nT3LXjDMHoXfWkSydeqi3MNzKP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 021/552] powerpc/pseries/iommu: switch to Default DMA window during kdump
Date: Fri,  4 Sep 2026 06:52:58 +0200
Message-ID: <20260904045748.306260580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Batra <gbatra@linux.ibm.com>

commit 1304643a1c20badbb91b86a5084dd76cb7620c05 upstream.

In PowerPC (pseries) a non-virtualized adapter will have 2 DMA windows -
2GB default and a larger Dynamic DMA Window (DDW). DDW is large enough to
map total RAM to a device.

During normal functioning of OS, since RAM is pre-mapped, 2GB default
window is not used. The only scenario it might get used is when buffers in
pmemory are mapped to the device for DMA.

As of today, during kdump, during early device discovery, pci_dma_find()
finds that the device has 2 DMA windows. It selects to use DDW. This is a
kdump path and DMA window is needed for IO to the device.

Although commit 09a3c1e46142 ("powerpc/pseries/iommu: IOMMU table is not
initialized for kdump over SR-IOV") fixed an issue during kdump with SR-IOV
case, but this also made the kdump prefer DDW over the default DMA window
when both are present (dedicated adapter case). Since the DDW is fully
mapped by the previous kernel, iommu_table_clear() can free only
KDUMP_MIN_TCE_ENTRIES (2048) TCEs for use by kdump kernel.

This is not enough when the dump device is NVMe over Fibre Channel.
Because nvme-fc driver DMA-maps the cmds and resp IUs of every
pre-allocated request and each such mapping consumes roughly:

    32 (IO queues, one per cpus = nr_cpus) *
    64 (queue_depth, blk-mq kdump limit) *
    2 (cmd+resp) = 4096

This is already double of what we have without counting admin queues and
lpfc driver's own allocations / mapping requirement. Hence this results
into iommu_alloc failures like -

lpfc 0153:70:00.0: iommu_alloc failed,
tbl 0000000034ebcf5e vaddr 00000000d814df0b npages 1
lpfc 0153:70:00.0: FCP Op failed - cmdiu dma mapping failed.
lpfc 0153:70:00.0: iommu_alloc failed,
tbl 0000000034ebcf5e vaddr 000000009779e4d2 npages 1
lpfc 0153:70:00.0: FCP Op failed - cmdiu dma mapping failed.

iommu_map_phys+0x1c4/0x1f0 (unreliable)
dma_iommu_map_phys+0x54/0xa0
dma_map_phys+0x3f8/0x590
__nvme_fc_init_request+0x110/0x300 [nvme_fc]
nvme_fc_init_request+0x60/0xb8 [nvme_fc]
blk_mq_alloc_map_and_rqs+0x388/0x510
blk_mq_alloc_tag_set+0x2a4/0x5f0
nvme_alloc_io_tag_set+0xe0/0x1e0 [nvme_core]
nvme_fc_connect_ctrl_work+0x85c/0xdac [nvme_fc]
process_one_work+0x1e4/0x5a0
worker_thread+0x1ec/0x3e0

Increasing the number of free TCE entries in iommu_table_clear() will
increase the probability of hitting EEH since there could still be some
active IOs from the previous life of the kernel.

Hence this patch partially reverts the previous fixes commit and
switches the kdump's default back to 2GB default DMA window instead of
DDW window. This window will mostly be empty. Or, could be slightly used
if buffers in pmemory were mapped for IO.

Fixes: 09a3c1e46142 ("powerpc/pseries/iommu: IOMMU table is not initialized for kdump over SR-IOV")
Cc: stable@vger.kernel.org
Signed-off-by: Gaurav Batra <gbatra@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260803224029.60538-1-gbatra@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/iommu.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -812,18 +812,11 @@ static struct device_node *pci_dma_find(
 
 	/* parse DMA window property. During normal system boot, only default
 	 * DMA window is passed in OF. But, for kdump, a dedicated adapter might
-	 * have both default and DDW in FDT. In this scenario, DDW takes precedence
-	 * over default window.
+	 * have both default and DDW in FDT. In this scenario, default window
+	 * takes precedence over DDW. For a dedicated adapter, default window will
+	 * potentially have more unused TCEs.
 	 */
-	if (ddw_win) {
-		struct dynamic_dma_window_prop *p;
-
-		p = (struct dynamic_dma_window_prop *)ddw_prop;
-		prop->liobn = p->liobn;
-		prop->dma_base = p->dma_base;
-		prop->tce_shift = p->tce_shift;
-		prop->window_shift = p->window_shift;
-	} else if (default_win) {
+	if (default_win) {
 		unsigned long offset, size, liobn;
 
 		of_parse_dma_window(rdn, default_prop, &liobn, &offset, &size);
@@ -832,6 +825,14 @@ static struct device_node *pci_dma_find(
 		prop->dma_base = cpu_to_be64(offset);
 		prop->tce_shift = cpu_to_be32(IOMMU_PAGE_SHIFT_4K);
 		prop->window_shift = cpu_to_be32(order_base_2(size));
+	} else {
+		struct dynamic_dma_window_prop *p;
+
+		p = (struct dynamic_dma_window_prop *)ddw_prop;
+		prop->liobn = p->liobn;
+		prop->dma_base = p->dma_base;
+		prop->tce_shift = p->tce_shift;
+		prop->window_shift = p->window_shift;
 	}
 
 	return rdn;


