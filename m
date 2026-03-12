Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8958396582;
	Thu, 12 Mar 2026 20:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346329; cv=none; b=heV6xcS/3vcNAWPWDEw0XMxCossTG26+gXpOiJ2qr0rRTmBl5eYFuIrzxF6fM8mzfWfxA5P2pPyVweiqNQ7IauFf1dZFWMUExWw/o4Pv3mBMCeciMY3rbUievmy5BDMhLXv7JKZ/3VI2xPIDaPDn/N/g28C5H++AI48QnMZtK/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346329; c=relaxed/simple;
	bh=JL2y0H8kcH5GVjI3arkb/wTHMl0qiGKQmEoXEYEg5ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCUqCZ5hJoT5fvJo0rYjHHdJ1GHiJaSFc8/fJIREqadlvmu84rEkwxDcWmB4vjVI6+H+sYsZ0ioeHf3tPLmtGJCMlJvnWxmAf4iC8TYewDo4di96lT8mVRWtLwWG/qHWsJMqcSLPQPYBbXq9POFINdkKy6iyzZJ9vwFtSMU/HNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0/6WSby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0/6WSby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82F9C4CEF7;
	Thu, 12 Mar 2026 20:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346329;
	bh=JL2y0H8kcH5GVjI3arkb/wTHMl0qiGKQmEoXEYEg5ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0/6WSbyI63/3mIneKhwW4ow88D41E0Lc0NzGwnnMgPDGDBfcQjME2+1Zt1AfVVFb
	 YKiOrQ1kpWhXfKWher+2jAxFeJNZV0wZsgMIoCSSh5BAQ8AgVKmFB4WYwr5GYZTNxT
	 PnkbtCot1h/2OCiywM/OylQHu9hpzVSBIEBkAK3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/265] scsi: lpfc: Properly set WC for DPP mapping
Date: Thu, 12 Mar 2026 21:06:34 +0100
Message-ID: <20260312201018.417595450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
index 08e6b8ed601c4..5b9830a28c8db 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12044,6 +12044,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		if (phba->sli4_hba.dpp_regs_memmap_p)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2a1f2b2017159..7dba06fa82d85 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15916,6 +15916,32 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
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
@@ -16879,9 +16905,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	uint8_t dpp_barset;
 	uint32_t dpp_offset;
 	uint8_t wq_create_version;
-#ifdef CONFIG_X86
-	unsigned long pg_addr;
-#endif
 
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -17067,14 +17090,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 
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
index c1e9ec0243bac..9caada8cbe58f 100644
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



