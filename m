Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ADD3C07A;
	Mon, 23 Mar 2026 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275550; cv=none; b=R77hTS+2MF63JqwZdsdnbQxbqk3ZFktH6CY98T30ukt3sWtEAlVPau8zYE34dVjO0qvjvrl2rZFqGAVBC7S8w6PqwPhLIzdEQOfCmHgupZzZknqNLAM9Yp+xZQtbC0Eo3dEHlLl5UAWastMIFPIWNPAZlVdwHyFKi475IygpjTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275550; c=relaxed/simple;
	bh=/Eq6G0c4J5zaNDCyxYKvFKpbObPGq9RQE15pmKgCVA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoWT0T3jcWphKYbg35pNVx1BaQPk+jCI25K4hyxKhY8s+aESeJM8UcpnOTzzgGaGlAPDXJ7hHEuN+0T0LsspETyrUBf4+1r61Xq7BCOv/+sj7o90UaBulOkBJpTtCZiGAGCLcfyQ9Q0LFrPZvn89G4PkfVUnQ0lyO+CNB5wF4uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR/tRdYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR/tRdYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1D4C4CEF7;
	Mon, 23 Mar 2026 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275549;
	bh=/Eq6G0c4J5zaNDCyxYKvFKpbObPGq9RQE15pmKgCVA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR/tRdYRViwPSAUPiDM7T0QB5utGgtABBYHGUEyhZgKd+roz4V9Cfo8YF3L+wVNm/
	 q4L9+EaI0e6QLHjvqshM3XKr5VPpR+z5WGCEa0CYynUpqZcxfCCW67QRtXrJkq/scN
	 oZjifInApoZCoYRY5NrpyJ2wCENVPw02dNi8/v3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/460] scsi: hisi_sas: Fix NULL pointer exception during user_scan()
Date: Mon, 23 Mar 2026 14:42:14 +0100
Message-ID: <20260323134529.986044333@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 8ddc0c26916574395447ebf4cff684314f6873a9 ]

user_scan() invokes updated sas_user_scan() for channel 0, and if
successful, iteratively scans remaining channels (1 to shost->max_channel)
via scsi_scan_host_selected() in commit 37c4e72b0651 ("scsi: Fix
sas_user_scan() to handle wildcard and multi-channel scans"). However,
hisi_sas supports only one channel, and the current value of max_channel is
1. sas_user_scan() for channel 1 will trigger the following NULL pointer
exception:

[  441.554662] Unable to handle kernel NULL pointer dereference at virtual address 00000000000008b0
[  441.554699] Mem abort info:
[  441.554710]   ESR = 0x0000000096000004
[  441.554718]   EC = 0x25: DABT (current EL), IL = 32 bits
[  441.554723]   SET = 0, FnV = 0
[  441.554726]   EA = 0, S1PTW = 0
[  441.554730]   FSC = 0x04: level 0 translation fault
[  441.554735] Data abort info:
[  441.554737]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  441.554742]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  441.554747]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  441.554752] user pgtable: 4k pages, 48-bit VAs, pgdp=00000828377a6000
[  441.554757] [00000000000008b0] pgd=0000000000000000, p4d=0000000000000000
[  441.554769] Internal error: Oops: 0000000096000004 [#1]  SMP
[  441.629589] Modules linked in: arm_spe_pmu arm_smmuv3_pmu tpm_tis_spi hisi_uncore_sllc_pmu hisi_uncore_pa_pmu hisi_uncore_l3c_pmu hisi_uncore_hha_pmu hisi_uncore_ddrc_pmu hisi_uncore_cpa_pmu hns3_pmu hisi_ptt hisi_pcie_pmu tpm_tis_core spidev spi_hisi_sfc_v3xx hisi_uncore_pmu spi_dw_mmio fuse hclge hclge_common hisi_sec2 hisi_hpre hisi_zip hisi_qm hns3 hisi_sas_v3_hw sm3_ce sbsa_gwdt hnae3 hisi_sas_main uacce hisi_dma i2c_hisi dm_mirror dm_region_hash dm_log dm_mod
[  441.670819] CPU: 46 UID: 0 PID: 6994 Comm: bash Kdump: loaded Not tainted 7.0.0-rc2+ #84 PREEMPT
[  441.691327] pstate: 81400009 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[  441.698277] pc : sas_find_dev_by_rphy+0x44/0x118
[  441.702896] lr : sas_find_dev_by_rphy+0x3c/0x118
[  441.707502] sp : ffff80009abbba40
[  441.710805] x29: ffff80009abbba40 x28: ffff082819a40008 x27: ffff082810c37c08
[  441.717930] x26: ffff082810c37c28 x25: ffff082819a40290 x24: ffff082810c37c00
[  441.725054] x23: 0000000000000000 x22: 0000000000000001 x21: ffff082819a40000
[  441.732179] x20: ffff082819a40290 x19: 0000000000000000 x18: 0000000000000020
[  441.739304] x17: 0000000000000000 x16: ffffb5dad6bda690 x15: 00000000ffffffff
[  441.746428] x14: ffff082814c3b26c x13: 00000000ffffffff x12: ffff082814c3b26a
[  441.753553] x11: 00000000000000c0 x10: 000000000000003a x9 : ffffb5dad5ea94f4
[  441.760678] x8 : 000000000000003a x7 : ffff80009abbbab0 x6 : 0000000000000030
[  441.767802] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
[  441.774926] x2 : ffff08280f35a300 x1 : ffffb5dad7127180 x0 : 0000000000000000
[  441.782053] Call trace:
[  441.784488]  sas_find_dev_by_rphy+0x44/0x118 (P)
[  441.789095]  sas_target_alloc+0x24/0xb0
[  441.792920]  scsi_alloc_target+0x290/0x330
[  441.797010]  __scsi_scan_target+0x88/0x258
[  441.801096]  scsi_scan_channel+0x74/0xb8
[  441.805008]  scsi_scan_host_selected+0x170/0x188
[  441.809615]  sas_user_scan+0xfc/0x148
[  441.813267]  store_scan+0x10c/0x180
[  441.816743]  dev_attr_store+0x20/0x40
[  441.820398]  sysfs_kf_write+0x84/0xa8
[  441.824054]  kernfs_fop_write_iter+0x130/0x1c8
[  441.828487]  vfs_write+0x2c0/0x370
[  441.831880]  ksys_write+0x74/0x118
[  441.835271]  __arm64_sys_write+0x24/0x38
[  441.839182]  invoke_syscall+0x50/0x120
[  441.842919]  el0_svc_common.constprop.0+0xc8/0xf0
[  441.847611]  do_el0_svc+0x24/0x38
[  441.850913]  el0_svc+0x38/0x158
[  441.854043]  el0t_64_sync_handler+0xa0/0xe8
[  441.858214]  el0t_64_sync+0x1ac/0x1b0
[  441.861865] Code: aa1303e0 97ff70a8 34ffff80 d10a4273 (f9445a75)
[  441.867946] ---[ end trace 0000000000000000 ]---

Therefore, set max_channel to 0.

Fixes: e21fe3a52692 ("scsi: hisi_sas: add initialisation for v3 pci-based controller")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Link: https://patch.msgid.link/20260305064039.4096775-1-liyihang9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 71d12b94ba5be..236e23620f21d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2544,7 +2544,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 	shost->transportt = hisi_sas_stt;
 	shost->max_id = HISI_SAS_MAX_DEVICES;
 	shost->max_lun = ~0;
-	shost->max_channel = 1;
+	shost->max_channel = 0;
 	shost->max_cmd_len = HISI_SAS_MAX_CDB_LEN;
 	if (hisi_hba->hw->slot_index_alloc) {
 		shost->can_queue = HISI_SAS_MAX_COMMANDS;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index cf0df9b405b24..e958b588d078f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4959,7 +4959,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->transportt = hisi_sas_stt;
 	shost->max_id = HISI_SAS_MAX_DEVICES;
 	shost->max_lun = ~0;
-	shost->max_channel = 1;
+	shost->max_channel = 0;
 	shost->max_cmd_len = HISI_SAS_MAX_CDB_LEN;
 	shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
 	shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
-- 
2.51.0



