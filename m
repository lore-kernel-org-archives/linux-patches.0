Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2980F28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2670C433C8;
	Wed, 20 Sep 2023 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210771;
	bh=0KcKR2nWfva1+fPAqOz8QR3Nb1EGM3rb4b0v1PER10Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6LigN4DJCGrrA8Vq8O0dA1nkbrpQ+J9MOqpWpphn58NvJAKDxJIakK2QGjQj2NAc
	 NAY0+MmHwS3WWUKeF/ZSqXw4mlGaRy3AqmoM3CSoL98jpWuaTf0eyepsbjHgL2jNHj
	 ZCRMn2It7VQ/eAZ+9Gs2bYDfC0kFsPK6PrKbFnPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 199/211] scsi: pm8001: Setup IRQs on resume
Date: Wed, 20 Sep 2023 13:30:43 +0200
Message-ID: <20230920112852.033838621@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit c91774818b041ed290df29fb1dc0725be9b12e83 upstream.

The function pm8001_pci_resume() only calls pm8001_request_irq() without
calling pm8001_setup_irq(). This causes the IRQ allocation to fail, which
leads all drives being removed from the system.

Fix this issue by integrating the code for pm8001_setup_irq() directly
inside pm8001_request_irq() so that MSI-X setup is performed both during
normal initialization and resume operations.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20230911232745.325149-2-dlemoal@kernel.org
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/pm8001/pm8001_init.c |   51 ++++++++++++--------------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -275,7 +275,6 @@ static irqreturn_t pm8001_interrupt_hand
 	return ret;
 }
 
-static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha);
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
 
 /**
@@ -296,13 +295,6 @@ static int pm8001_alloc(struct pm8001_hb
 	pm8001_dbg(pm8001_ha, INIT, "pm8001_alloc: PHY:%x\n",
 		   pm8001_ha->chip->n_phy);
 
-	/* Setup Interrupt */
-	rc = pm8001_setup_irq(pm8001_ha);
-	if (rc) {
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "pm8001_setup_irq failed [ret: %d]\n", rc);
-		goto err_out;
-	}
 	/* Request Interrupt */
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
@@ -1034,47 +1026,38 @@ static u32 pm8001_request_msix(struct pm
 }
 #endif
 
-static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha)
-{
-	struct pci_dev *pdev;
-
-	pdev = pm8001_ha->pdev;
-
-#ifdef PM8001_USE_MSIX
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
-		return pm8001_setup_msix(pm8001_ha);
-	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
-#endif
-	return 0;
-}
-
 /**
  * pm8001_request_irq - register interrupt
  * @pm8001_ha: our ha struct.
  */
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 {
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = pm8001_ha->pdev;
+#ifdef PM8001_USE_MSIX
 	int rc;
 
-	pdev = pm8001_ha->pdev;
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		rc = pm8001_setup_msix(pm8001_ha);
+		if (rc) {
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "pm8001_setup_irq failed [ret: %d]\n", rc);
+			return rc;
+		}
 
-#ifdef PM8001_USE_MSIX
-	if (pdev->msix_cap && pci_msi_enabled())
-		return pm8001_request_msix(pm8001_ha);
-	else {
-		pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
-		goto intx;
+		if (pdev->msix_cap && pci_msi_enabled())
+			return pm8001_request_msix(pm8001_ha);
 	}
+
+	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
 #endif
 
-intx:
 	/* initialize the INT-X interrupt */
 	pm8001_ha->irq_vector[0].irq_id = 0;
 	pm8001_ha->irq_vector[0].drv_inst = pm8001_ha;
-	rc = request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF_SHARED,
-		pm8001_ha->name, SHOST_TO_SAS_HA(pm8001_ha->shost));
-	return rc;
+
+	return request_irq(pdev->irq, pm8001_interrupt_handler_intx,
+			   IRQF_SHARED, pm8001_ha->name,
+			   SHOST_TO_SAS_HA(pm8001_ha->shost));
 }
 
 /**


