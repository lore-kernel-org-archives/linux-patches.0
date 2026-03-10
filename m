Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6403806B8;
	Tue, 10 Mar 2026 11:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141645; cv=none; b=A2G0HjXddbSHyhFFU5QK30jeHF1Qum7UwYH4CEgsso/V77U3lR5BGwhdczAPVM2jSnKxQ5aeEYUINGAM/rwwt9OpkrDLe7+aWKO0MGAVSZaHnAq5NuFsgjurLJQHpts1/ARJyyjNa/4Rig7Toy18IVtmoKhTAPIJdbw2uh77vc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141645; c=relaxed/simple;
	bh=qBP+ycVcc176JYNwNFrtx5kIxj15mUcmt34f8hM+NtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqmAy/UtrEfFOZ/+mSQl5kpD6SMDl7K3i97UvA3UUf4YEv/XZvlcADLquG/ilMNoBEeLEutHLN66Nhgv8ZYl+vo0+uzTOMQ1jsVSlxUONYaw31ieW7AHC/ugY1f0hjTCa2IKSr55gtXwfr/OEGtsh+Mm/u3WpQeaIyv702+3nNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOvzVuj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOvzVuj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E38C2BC9E;
	Tue, 10 Mar 2026 11:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141645;
	bh=qBP+ycVcc176JYNwNFrtx5kIxj15mUcmt34f8hM+NtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOvzVuj4bNHpFL1NhyDDbQKEn7pYku21Nm02aXjNWhUhlX5FlnLhAq+MUo93cVVcC
	 3dh25wHUvmwSrTj0R4coKEq5yFTtHAXTRFPqXWBy861grK0isPuQvEOFAPihdcv+Gv
	 CXRHMOZIVXF1NeAI3uOT5cFUkXQc1X8mnqQAGJH7qWYZcGlNpnK3LIEevyXhUv0ij5
	 UVaMVVxatCyaV/g8LQyS5rhJTkOA/N4xV27fZpBhmWPd7XXRhqG3DZ8h6PSvgmIc3t
	 nPdj0UzlX6Q+OpBJsAeDE+JZ8/aRCUlZjOGhvztfT4XVd9Ng/zykoSf0krv4Y+WHNE
	 xsSoANcU9jUXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/314] scsi: lpfc: Properly set WC for DPP mapping
Date: Tue, 10 Mar 2026 07:14:30 -0400
Message-ID: <450c82e8081241da191263cd94be4391b0b8f217.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 065eb91de9c0f..adc0beaf5468f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12040,6 +12040,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		if (phba->sli4_hba.dpp_regs_memmap_p)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7ea7c4245c691..7b765719f4f6b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15911,6 +15911,32 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
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
@@ -16874,9 +16900,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	uint8_t dpp_barset;
 	uint32_t dpp_offset;
 	uint8_t wq_create_version;
-#ifdef CONFIG_X86
-	unsigned long pg_addr;
-#endif
 
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -17062,14 +17085,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 
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

