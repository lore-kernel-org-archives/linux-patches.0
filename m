Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945B234B197;
	Tue, 10 Mar 2026 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140777; cv=none; b=GMqnZEZ/hznPuIY8JMhwQtPWySbXAydzi1EpBC+LX2zJaVlUoOvyP8JkNAFHXAUNSJAHtal8vooNx9xWHdXGmk2ZjK3bmmZRJWcUyO38pEdWpTmTsV0Mtcl7F4pHseBnnhVtSREwrgs2E/U2k2tACRajIUPoDQk8+JsO6r7cf2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140777; c=relaxed/simple;
	bh=50rTBhetAo4zRt8ABzTBW9A1cQQX6YPSlaZd8kktyUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld7Nu7SxweDdxN7fLLPMkjzudqx1I7Fyq0sEp9oLaymwQFs92mZavQG7UVMP19eABJmrd1Rs1R0nOHa4+fnqEFinN0Q7Wh2PAomstNga95fjFoEwCATxMoSXpTdrBryXOPIzGt+C4JgGAzmtNqfn4NvW6HV6JGmhuxDRrcuoNuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qi9gqawj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qi9gqawj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC326C19423;
	Tue, 10 Mar 2026 11:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140777;
	bh=50rTBhetAo4zRt8ABzTBW9A1cQQX6YPSlaZd8kktyUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi9gqawj8ik/RzNWcjCkdltfkX/rAHkmy+p5xpJs/FdcyFyRxfnF6ccwK//lFPM3c
	 ScAPWR+xnsmVVOm3dEbM/O0JRW/P6Hrp7QiYi8T43VqVbcOKyL/ht4yaAxVEqq2IiJ
	 KWk+3UYRRXLHcesLTJ/IXJ+XbDI68XiHO69wR8wmGSWzvYb+W+lRMPcZEMW6uGyVFk
	 5QVMsSVyjJaWNXm3xzd04kgXMKdl9TxZYQVpdefzLyGhURNbEnP+xuKljgEWpuvAVZ
	 zFNxMTXu7bFhpxdVpTvplmEdhTeu6eJ6ZtFal+E/4F5Wi1y2dldpxTAvN4alvLz/v8
	 LTuJmPnTkd58A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 011/311] scsi: lpfc: Properly set WC for DPP mapping
Date: Tue, 10 Mar 2026 07:00:58 -0400
Message-ID: <064c7e16a5b55db55b47bc4b442e835b4dc9ec3b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index b1460b16dd91d..c6bb45c3d4c4a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12034,6 +12034,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		if (phba->sli4_hba.dpp_regs_memmap_p)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 73d77cfab5f82..bddfc412b04b5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15981,6 +15981,32 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
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
@@ -16944,9 +16970,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	uint8_t dpp_barset;
 	uint32_t dpp_offset;
 	uint8_t wq_create_version;
-#ifdef CONFIG_X86
-	unsigned long pg_addr;
-#endif
 
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -17132,14 +17155,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 
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
index fd6dab1578872..40f313e2769fc 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
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

