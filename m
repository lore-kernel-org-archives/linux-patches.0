Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEE63AD52E;
	Mon, 23 Mar 2026 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275169; cv=none; b=RtEOl1bbUZs5R1uxoCsj5Hgpyrgc3Rkm4lrxJe4ZEzbF1ItfFpc2Gm0SC9tPpxY5VlpnVMb9PSy9GFMFByL3XLkrO33u8SCmM++0TY4h9rLJn372z/k0Y/dPVe16D0ZcJtkUbt8kicl2DOzGVfOQtxZ3nw9m45UhybdNtCnbgxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275169; c=relaxed/simple;
	bh=qLBZx/6ddYHMikb0qf4ibJIJmiKKdlV0nJnj4EHwdbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkyfkQ0nrtwJLU7cuc63U1UUZOjc78vVxBHw2jxdTWJ2Z2q8om1zhplcljYyGv1x/ygrjh7xBy14jjnCoMW5U6P483QVtEKtVbbeFUVnWT4H3on6lXTLLxm2K+ycbo7in2XMIsWtwcHBBxIH14a92JLRCUhURXjT75o2/c5Cyu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIsHF6i7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIsHF6i7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33817C2BC9E;
	Mon, 23 Mar 2026 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275169;
	bh=qLBZx/6ddYHMikb0qf4ibJIJmiKKdlV0nJnj4EHwdbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIsHF6i7j45+hjaSQJI6coI/HVguiGyAqhrLp8No2mndk0zo1i1oxZHcDWhXMeZnJ
	 58EWoQuseCP/t6jnK2CsPauvoaKyfgphsEP3aKZouYTKB3d4WextQqrBzkghqraVqg
	 CiWKq5L3t3J1qm2N9bM75DBVTnfMh1OtslOV5l3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/481] scsi: lpfc: Properly set WC for DPP mapping
Date: Mon, 23 Mar 2026 14:39:47 +0100
Message-ID: <20260323134525.389298337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@grsecurity.net>

[ Upstream commit bffda93a51b40afd67c11bf558dc5aae83ca0943 ]

Using set_memory_wc() to enable write-combining for the DPP portion of
the MMIO mapping is wrong as set_memory_*() is meant to operate on RAM
only, not MMIO mappings. In fact, as used currently triggers a BUG_ON()
with enabled CONFIG_DEBUG_VIRTUAL.

Simply map the DPP region separately and in addition to the already
existing mappings, avoiding any possible negative side effects for
these.

Fixes: 1351e69fc6db ("scsi: lpfc: Add push-to-adapter support to sli4")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Reviewed-by: Mathias Krause <minipli@grsecurity.net>
Link: https://patch.msgid.link/20260212192327.141104-1-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 36 +++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli4.h |  3 +++
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6535474fe8a7f..12a362eab1cb2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12059,6 +12059,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		if (phba->sli4_hba.dpp_regs_memmap_p)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d5e21e74888a7..90213058b8356 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15910,6 +15910,32 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 	return NULL;
 }
 
+static __maybe_unused void __iomem *
+lpfc_dpp_wc_map(struct lpfc_hba *phba, uint8_t dpp_barset)
+{
+
+	/* DPP region is supposed to cover 64-bit BAR2 */
+	if (dpp_barset != WQ_PCI_BAR_4_AND_5) {
+		lpfc_log_msg(phba, KERN_WARNING, LOG_INIT,
+			     "3273 dpp_barset x%x != WQ_PCI_BAR_4_AND_5\n",
+			     dpp_barset);
+		return NULL;
+	}
+
+	if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
+		void __iomem *dpp_map;
+
+		dpp_map = ioremap_wc(phba->pci_bar2_map,
+				     pci_resource_len(phba->pcidev,
+						      PCI_64BIT_BAR4));
+
+		if (dpp_map)
+			phba->sli4_hba.dpp_regs_memmap_wc_p = dpp_map;
+	}
+
+	return phba->sli4_hba.dpp_regs_memmap_wc_p;
+}
+
 /**
  * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
  * @phba: HBA structure that EQs are on.
@@ -16819,9 +16845,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	uint8_t dpp_barset;
 	uint32_t dpp_offset;
 	uint8_t wq_create_version;
-#ifdef CONFIG_X86
-	unsigned long pg_addr;
-#endif
 
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -17007,14 +17030,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 
 #ifdef CONFIG_X86
 			/* Enable combined writes for DPP aperture */
-			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
-			rc = set_memory_wc(pg_addr, 1);
-			if (rc) {
+			bar_memmap_p = lpfc_dpp_wc_map(phba, dpp_barset);
+			if (!bar_memmap_p) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3272 Cannot setup Combined "
 					"Write on WQ[%d] - disable DPP\n",
 					wq->queue_id);
 				phba->cfg_enable_dpp = 0;
+			} else {
+				wq->dpp_regaddr = bar_memmap_p + dpp_offset;
 			}
 #else
 			phba->cfg_enable_dpp = 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index cbb1aa1cf025b..db6a42147c895 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -783,6 +783,9 @@ struct lpfc_sli4_hba {
 	void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
 					   * dpp registers
 					   */
+	void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address for
+					    * dpp registers with write combining
+					    */
 	union {
 		struct {
 			/* IF Type 0, BAR 0 PCI cfg space reg mem map */
-- 
2.51.0



