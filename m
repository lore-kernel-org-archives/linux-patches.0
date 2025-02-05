Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E40C14EC77;
	Wed,  5 Feb 2025 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764044; cv=none; b=BhEoIvj+IKgaUfFnqdK96Gf08g9xQhs4kE1b89CsDjxR3/2sf8B4tUXOnwRWXLJFshy57qHP4moYvTTL7/nyutMyIPGqwCYWIX4n9hFbPQr2vGhC3prTGX/Mq2vwps/syCZ5x399635IJCXU1VyZra0lqQ7ihsGs+TRtOuIq6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764044; c=relaxed/simple;
	bh=ZcPBC9c4xJdTJxSv5PbIFp54hpOx3s+Smk1Wplyd7RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoZycBxHAxlpctmqYL6Lhi6z3ahMzJl5U2DUzBXJdUZsuiXR6shmHM+o9NmIB7hIO7mujaaWWotbmX4tsgY/mJDJJqnfydw6JySDgQ/sN4/+gYdzchNecCR2mfzl0UqZfaU+LjR2lyPiju0zmTJa35ZRw75MQSQw5UKkCLV1jx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrZhtPVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrZhtPVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C78AC4CED1;
	Wed,  5 Feb 2025 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764043;
	bh=ZcPBC9c4xJdTJxSv5PbIFp54hpOx3s+Smk1Wplyd7RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrZhtPVXTLMnEpjeBMwX7tMG7YJs6xKSHI1jpxnRHwzi7jIm2hdck0FyGgid9qseC
	 Z+VfspwCSGq3QPJK3ZbP/++hH8ksqYPdSxkVworteS/P1QivLyLJ7mdRuVymxSWZCu
	 slLrGSStLf8JM+Ug/GY0MRw5o5powvHyUDHlgQGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 022/623] powerpc/pseries/iommu: IOMMU incorrectly marks MMIO range in DDW
Date: Wed,  5 Feb 2025 14:36:04 +0100
Message-ID: <20250205134457.076613314@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Batra <gbatra@linux.ibm.com>

[ Upstream commit 8f70caad82e9c088ed93b4fea48d941ab6441886 ]

Power Hypervisor can possibily allocate MMIO window intersecting with
Dynamic DMA Window (DDW) range, which is over 32-bit addressing.

These MMIO pages needs to be marked as reserved so that IOMMU doesn't map
DMA buffers in this range.

The current code is not marking these pages correctly which is resulting
in LPAR to OOPS while booting. The stack is at below

BUG: Unable to handle kernel data access on read at 0xc00800005cd40000
Faulting instruction address: 0xc00000000005cdac
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: af_packet rfkill ibmveth(X) lpfc(+) nvmet_fc nvmet nvme_keyring crct10dif_vpmsum nvme_fc nvme_fabrics nvme_core be2net(+) nvme_auth rtc_generic nfsd auth_rpcgss nfs_acl lockd grace sunrpc fuse configfs ip_tables x_tables xfs libcrc32c dm_service_time ibmvfc(X) scsi_transport_fc vmx_crypto gf128mul crc32c_vpmsum dm_mirror dm_region_hash dm_log dm_multipath dm_mod sd_mod scsi_dh_emc scsi_dh_rdac scsi_dh_alua t10_pi crc64_rocksoft_generic crc64_rocksoft sg crc64 scsi_mod
Supported: Yes, External
CPU: 8 PID: 241 Comm: kworker/8:1 Kdump: loaded Not tainted 6.4.0-150600.23.14-default #1 SLE15-SP6 b44ee71c81261b9e4bab5e0cde1f2ed891d5359b
Hardware name: IBM,9080-M9S POWER9 (raw) 0x4e2103 0xf000005 of:IBM,FW950.B0 (VH950_149) hv:phyp pSeries
Workqueue: events work_for_cpu_fn
NIP:  c00000000005cdac LR: c00000000005e830 CTR: 0000000000000000
REGS: c00001400c9ff770 TRAP: 0300   Not tainted  (6.4.0-150600.23.14-default)
MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24228448  XER: 00000001
CFAR: c00000000005cdd4 DAR: c00800005cd40000 DSISR: 40000000 IRQMASK: 0
GPR00: c00000000005e830 c00001400c9ffa10 c000000001987d00 c00001400c4fe800
GPR04: 0000080000000000 0000000000000001 0000000004000000 0000000000800000
GPR08: 0000000004000000 0000000000000001 c00800005cd40000 ffffffffffffffff
GPR12: 0000000084228882 c00000000a4c4f00 0000000000000010 0000080000000000
GPR16: c00001400c4fe800 0000000004000000 0800000000000000 c00000006088b800
GPR20: c00001401a7be980 c00001400eff3800 c000000002a2da68 000000000000002b
GPR24: c0000000026793a8 c000000002679368 000000000000002a c0000000026793c8
GPR28: 000008007effffff 0000080000000000 0000000000800000 c00001400c4fe800
NIP [c00000000005cdac] iommu_table_reserve_pages+0xac/0x100
LR [c00000000005e830] iommu_init_table+0x80/0x1e0
Call Trace:
[c00001400c9ffa10] [c00000000005e810] iommu_init_table+0x60/0x1e0 (unreliable)
[c00001400c9ffa90] [c00000000010356c] iommu_bypass_supported_pSeriesLP+0x9cc/0xe40
[c00001400c9ffc30] [c00000000005c300] dma_iommu_dma_supported+0xf0/0x230
[c00001400c9ffcb0] [c00000000024b0c4] dma_supported+0x44/0x90
[c00001400c9ffcd0] [c00000000024b14c] dma_set_mask+0x3c/0x80
[c00001400c9ffd00] [c0080000555b715c] be_probe+0xc4/0xb90 [be2net]
[c00001400c9ffdc0] [c000000000986f3c] local_pci_probe+0x6c/0x110
[c00001400c9ffe40] [c000000000188f28] work_for_cpu_fn+0x38/0x60
[c00001400c9ffe70] [c00000000018e454] process_one_work+0x314/0x620
[c00001400c9fff10] [c00000000018f280] worker_thread+0x2b0/0x620
[c00001400c9fff90] [c00000000019bb18] kthread+0x148/0x150
[c00001400c9fffe0] [c00000000000ded8] start_kernel_thread+0x14/0x18

There are 2 issues in the code

1. The index is "int" while the address is "unsigned long". This results in
   negative value when setting the bitmap.

2. The DMA offset is page shifted but the MMIO range is used as-is (64-bit
   address). MMIO address needs to be page shifted as well.

Fixes: 3c33066a2190 ("powerpc/kernel/iommu: Add new iommu_table_in_use() helper")

Signed-off-by: Gaurav Batra <gbatra@linux.ibm.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20241206210039.93172-1-gbatra@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c            | 2 +-
 arch/powerpc/platforms/pseries/iommu.c | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 76381e14e800c..0ebae6e4c19dd 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -687,7 +687,7 @@ void iommu_table_clear(struct iommu_table *tbl)
 void iommu_table_reserve_pages(struct iommu_table *tbl,
 		unsigned long res_start, unsigned long res_end)
 {
-	int i;
+	unsigned long i;
 
 	WARN_ON_ONCE(res_end < res_start);
 	/*
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 534cd159e9ab4..29f1a0cc59cd5 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1650,7 +1650,8 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 		iommu_table_setparms_common(newtbl, pci->phb->bus->number, create.liobn,
 					    dynamic_addr, dynamic_len, page_shift, NULL,
 					    &iommu_table_lpar_multi_ops);
-		iommu_init_table(newtbl, pci->phb->node, start, end);
+		iommu_init_table(newtbl, pci->phb->node,
+				 start >> page_shift, end >> page_shift);
 
 		pci->table_group->tables[default_win_removed ? 0 : 1] = newtbl;
 
@@ -2065,7 +2066,9 @@ static long spapr_tce_create_table(struct iommu_table_group *table_group, int nu
 							    offset, 1UL << window_shift,
 							    IOMMU_PAGE_SHIFT_4K, NULL,
 							    &iommu_table_lpar_multi_ops);
-				iommu_init_table(tbl, pci->phb->node, start, end);
+				iommu_init_table(tbl, pci->phb->node,
+						 start >> IOMMU_PAGE_SHIFT_4K,
+						 end >> IOMMU_PAGE_SHIFT_4K);
 
 				table_group->tables[0] = tbl;
 
@@ -2136,7 +2139,7 @@ static long spapr_tce_create_table(struct iommu_table_group *table_group, int nu
 	/* New table for using DDW instead of the default DMA window */
 	iommu_table_setparms_common(tbl, pci->phb->bus->number, create.liobn, win_addr,
 				    1UL << len, page_shift, NULL, &iommu_table_lpar_multi_ops);
-	iommu_init_table(tbl, pci->phb->node, start, end);
+	iommu_init_table(tbl, pci->phb->node, start >> page_shift, end >> page_shift);
 
 	pci->table_group->tables[num] = tbl;
 	set_iommu_table_base(&pdev->dev, tbl);
-- 
2.39.5



