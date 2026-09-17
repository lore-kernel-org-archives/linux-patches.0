Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A45331EB0;
	Thu, 17 Sep 2026 15:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658799; cv=none; b=L9v7mEuhbjKN5/aquyHsJcbjNTJKUIYSTSGVlA7pyE0fl7Sh7+yma7alMN6yQt4x5bn8Pjgx3meUvNCtnvabvLaIx+4U54I1uLCelSp8R2J3hp5Isk3bxXzEQuP4iPpodzdr5PWJNen8nqUYreH1Uyv9trcVEKPQf1zwLMks7/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658799; c=relaxed/simple;
	bh=T0xHf8Z6Y1cn7OTfon8mfrvrFBTC1Drym+JBdFrdm0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A930B2HMsY7u7lp+eal8zW4OWt4UAmx3SzikNEMQWG5062ULAs1L2HP0fzrzuOHcGrKEiFXVc76IbOGNEV3O26N4XUme5+6X0VnaBB97PXCcJTCvAWrA0kZj4XmoQnDvTkcMM6PubPT+N96KJcEI3rsZqZQXnD6ER/a46tjmBY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8MR7kqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8MR7kqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9C51F000FF;
	Thu, 17 Sep 2026 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658790;
	bh=PAuuDW4yhLNfPs1RDyAMITjjZ8GdYBg6KoQ7fz7apMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8MR7kqk+zbC1VOh+zwim0xN6Njop5IDxKVmdNUfmSeKmCTseAnEqW7vrTKd5q9Ih
	 uhkChFfC/7BL8DCcG9VYNQcCT0m4M0s928LH9MTzS0QaJDv2ZXwkka8Htk6ZuXjPHo
	 hNq7OqtJbMYYwK1Co1OQdT5km1NMwsZLu1dD2JvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 010/733] EDAC/igen6: Fix Raptor Lake-P logged error address
Date: Thu, 17 Sep 2026 16:05:18 +0100
Message-ID: <20260917151350.900443927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 0361f576ec0dffca13edc94580c8666146a91e02 ]

Raptor Lake-P was treated as using a different IBECC (In-Band ECC) error
address format and therefore had a dedicated extraction path that shifted
the logged address.

However, Raptor Lake-P uses the same cache-line-granularity error address
format as other IBECC platforms. The special handling causes the logged
address to be decoded incorrectly.

Fix the issue by removing Raptor Lake-P specific extraction logic and using
the common path instead. This also allows reusing Alder Lake resource
configuration data.

Fixes: d23627a7688f ("EDAC/igen6: Add Intel Raptor Lake-P SoCs support")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260730024238.4096623-6-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index ea5628d780eba..12d718a50e1c9 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -175,8 +175,6 @@ static struct res_config {
 	/* Set imc->dimm_{l_size,s_size,l_map}[chan]. */
 	void (*set_dimm_params)(struct igen6_imc *imc, int chan);
 	bool (*ibecc_available)(struct pci_dev *pdev);
-	/* Extract error address logged in IBECC */
-	u64 (*err_addr)(u64 ecclog);
 	/* Convert error address logged in IBECC to system physical address */
 	u64 (*err_addr_to_sys_addr)(u64 eaddr, int mc);
 	/* Convert error address logged in IBECC to integrated memory controller address */
@@ -522,11 +520,6 @@ static u64 adl_err_addr_to_imc_addr(u64 eaddr, int mc)
 	return imc_addr;
 }
 
-static u64 rpl_p_err_addr(u64 ecclog)
-{
-	return field_get(res_cfg->reg_eccerrlog_addr_mask, ecclog);
-}
-
 static enum mem_type ptl_h_get_mem_type(struct igen6_imc *imc)
 {
 	u32 mtype, val;
@@ -716,22 +709,6 @@ static struct res_config adl_n_cfg = {
 	.err_addr_to_imc_addr	= adl_err_addr_to_imc_addr,
 };
 
-static struct res_config rpl_p_cfg = {
-	.machine_check		= true,
-	.num_imc		= 2,
-	.reg_mchbar_mask	= GENMASK_ULL(41, 17),
-	.reg_tom_mask		= GENMASK_ULL(41, 20),
-	.reg_touud_mask		= GENMASK_ULL(41, 20),
-	.reg_eccerrlog_addr_mask = GENMASK_ULL(45, 5),
-	.imc_base		= 0xd800,
-	.ibecc_base		= 0xd400,
-	.ibecc_error_log_offset	= 0x68,
-	.ibecc_available	= tgl_ibecc_available,
-	.err_addr		= rpl_p_err_addr,
-	.err_addr_to_sys_addr	= adl_err_addr_to_sys_addr,
-	.err_addr_to_imc_addr	= adl_err_addr_to_imc_addr,
-};
-
 static struct res_config mtl_ps_cfg = {
 	.machine_check				= true,
 	.num_imc				= 2,
@@ -877,11 +854,11 @@ static struct pci_device_id igen6_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, DID_ASL_SKU1), .driver_data = (kernel_ulong_t)&adl_n_cfg },
 	{ PCI_VDEVICE(INTEL, DID_ASL_SKU2), .driver_data = (kernel_ulong_t)&adl_n_cfg },
 	{ PCI_VDEVICE(INTEL, DID_ASL_SKU3), .driver_data = (kernel_ulong_t)&adl_n_cfg },
-	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU1), .driver_data = (kernel_ulong_t)&rpl_p_cfg },
-	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU2), .driver_data = (kernel_ulong_t)&rpl_p_cfg },
-	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU3), .driver_data = (kernel_ulong_t)&rpl_p_cfg },
-	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU4), .driver_data = (kernel_ulong_t)&rpl_p_cfg },
-	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU5), .driver_data = (kernel_ulong_t)&rpl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU1), .driver_data = (kernel_ulong_t)&adl_cfg },
+	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU2), .driver_data = (kernel_ulong_t)&adl_cfg },
+	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU3), .driver_data = (kernel_ulong_t)&adl_cfg },
+	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU4), .driver_data = (kernel_ulong_t)&adl_cfg },
+	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU5), .driver_data = (kernel_ulong_t)&adl_cfg },
 	{ PCI_VDEVICE(INTEL, DID_MTL_PS_SKU1), .driver_data = (kernel_ulong_t)&mtl_ps_cfg },
 	{ PCI_VDEVICE(INTEL, DID_MTL_PS_SKU2), .driver_data = (kernel_ulong_t)&mtl_ps_cfg },
 	{ PCI_VDEVICE(INTEL, DID_MTL_PS_SKU3), .driver_data = (kernel_ulong_t)&mtl_ps_cfg },
@@ -1237,11 +1214,7 @@ static void ecclog_work_cb(struct work_struct *work)
 
 	llist_for_each_entry_safe(node, tmp, head, llnode) {
 		memset(&res, 0, sizeof(res));
-		if (res_cfg->err_addr)
-			eaddr = res_cfg->err_addr(node->ecclog);
-		else
-			eaddr = node->ecclog & res_cfg->reg_eccerrlog_addr_mask;
-
+		eaddr	     = node->ecclog & res_cfg->reg_eccerrlog_addr_mask;
 		res.mc	     = node->mc;
 		res.sys_addr = res_cfg->err_addr_to_sys_addr(eaddr, res.mc);
 		res.imc_addr = res_cfg->err_addr_to_imc_addr(eaddr, res.mc);
-- 
2.53.0



