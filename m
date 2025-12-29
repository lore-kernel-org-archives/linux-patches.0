Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569133123A;
	Mon, 29 Dec 2025 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025228; cv=none; b=IHmv56XeY+cdktO8LP3kRRqhkl1BDhgxUKQXp9Tw0YaJjThJ79XMWYIGZpAHyIb4wcpOloqVOeZJfDTzZkHb6SXMD50BYy2VeHxEhCATEaoW+LsApfcHmm2YSlk9yazxm51cXC3dtIe++Zvyjbn5dIRW/bSbP0Xe4CMR3uXYjiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025228; c=relaxed/simple;
	bh=Z++IWQpp5xHta4rJgND0/bIDQkn0OI6Tfl+/BqYR08Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx1euPoWZ3u+1H5msHptHnRI0rJM3jsNaC0zfV9Vst4C/F7iNt5SzsPI2IVh9rCO7XEMViJ+QY0cxvRmnIIpTUfSZeEa/zL6IdRlbOM6gBpeKCArKlDCfm/XeNIlC6krLPkDnc7dYc6qrGaZESm8R4Ycv4ssLknUD1EE2dw3EN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ag6qKycH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ag6qKycH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D713BC4CEF7;
	Mon, 29 Dec 2025 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025228;
	bh=Z++IWQpp5xHta4rJgND0/bIDQkn0OI6Tfl+/BqYR08Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ag6qKycHfduiewZbTduJri3GsKwrOQfb65obxUkTELCRAfeQfIU5M5WfRV8yAzS5B
	 OTfYmssEu4jbWZglBINxvnVcWC2x05R9pzNQc+rWMic2IaujfRnNzbfwms+lX68lLI
	 14B5Clj9Ht8kHIxWIt1VMAMCPZaz0GmZ2/2dU/W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/430] amd/iommu: Preserve domain ids inside the kdump kernel
Date: Mon, 29 Dec 2025 17:09:02 +0100
Message-ID: <20251229160729.515837413@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Sairaj Kodilkar <sarunkod@amd.com>

[ Upstream commit c2e8dc1222c2136e714d5d972dce7e64924e4ed8 ]

Currently AMD IOMMU driver does not reserve domain ids programmed in the
DTE while reusing the device table inside kdump kernel. This can cause
reallocation of these domain ids for newer domains that are created by
the kdump kernel, which can lead to potential IO_PAGE_FAULTs

Hence reserve these ids inside pdom_ids.

Fixes: 38e5f33ee359 ("iommu/amd: Reuse device table for kdump")
Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index f2991c11867c..14eb9de33ccb 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1136,9 +1136,13 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
 static bool __reuse_device_table(struct amd_iommu *iommu)
 {
 	struct amd_iommu_pci_seg *pci_seg = iommu->pci_seg;
-	u32 lo, hi, old_devtb_size;
+	struct dev_table_entry *old_dev_tbl_entry;
+	u32 lo, hi, old_devtb_size, devid;
 	phys_addr_t old_devtb_phys;
+	u16 dom_id;
+	bool dte_v;
 	u64 entry;
+	int ret;
 
 	/* Each IOMMU use separate device table with the same size */
 	lo = readl(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET);
@@ -1173,6 +1177,23 @@ static bool __reuse_device_table(struct amd_iommu *iommu)
 		return false;
 	}
 
+	for (devid = 0; devid <= pci_seg->last_bdf; devid++) {
+		old_dev_tbl_entry = &pci_seg->old_dev_tbl_cpy[devid];
+		dte_v = FIELD_GET(DTE_FLAG_V, old_dev_tbl_entry->data[0]);
+		dom_id = FIELD_GET(DEV_DOMID_MASK, old_dev_tbl_entry->data[1]);
+
+		if (!dte_v || !dom_id)
+			continue;
+		/*
+		 * ID reservation can fail with -ENOSPC when there
+		 * are multiple devices present in the same domain,
+		 * hence check only for -ENOMEM.
+		 */
+		ret = ida_alloc_range(&pdom_ids, dom_id, dom_id, GFP_KERNEL);
+		if (ret == -ENOMEM)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.51.0



