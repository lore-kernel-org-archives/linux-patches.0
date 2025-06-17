Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E672356CE;
	Tue, 17 Jun 2025 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177386; cv=none; b=jdIQnD1GfnswS3scqouIFAqRgiEfEQ00naIdiK/VCp+CIru1oALdh+i539x0MfaK+FAp8RtBCjSXXqrr2rBX2NdghVCXtobEgwYw/Wfo8XzpHr1LOl282e+RfGix484rYC5R/MSHufuW350rmAuGKGAlqwOTe4nhULeGI9H14wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177386; c=relaxed/simple;
	bh=ZtTzcofSORcby33XWrZwnfqB2imYuxFTCao7bUlLwmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KN+iKD3FwR+odfSqLmw7udlsrwz25WP3RF9kKTbTx3LabNP0AIuD8KkZsgGrHZHYUpPS/JndLuQim3Dk480hr0fJe3YQZcrnfmCC/F6OStYRX8xz5kLhymNQthCGsAqcCPlIJBO+NIbGwi4ybv7k+l08ywfL0+Put9yd5jvyC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slpcdey3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slpcdey3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CCBC4CEE3;
	Tue, 17 Jun 2025 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177386;
	bh=ZtTzcofSORcby33XWrZwnfqB2imYuxFTCao7bUlLwmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slpcdey3x4ImlJ5JKk5YHqwfx1fjZ8v/3feyIjewV4R/Ne5De0k77SyWZKJngoYUK
	 BDFMxT6DZlssLkbuKD7QZ0KVD6KC2CGuo7lGAsuSEAX5/u+7ejwQ7n03erPqhEGjeL
	 p1rQseGP7CEC7N3wWcZno44hhU6dA8d8iXlNcv7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/512] PCI/DPC: Log Error Source ID only when valid
Date: Tue, 17 Jun 2025 17:24:44 +0200
Message-ID: <20250617152432.498083609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit a0b62cc310239c7f1323fb20bd3789f21bdd8615 ]

DPC Error Source ID is only valid when the DPC Trigger Reason indicates
that DPC was triggered due to reception of an ERR_NONFATAL or ERR_FATAL
Message (PCIe r6.0, sec 7.9.14.5).

When DPC was triggered by ERR_NONFATAL (PCI_EXP_DPC_STATUS_TRIGGER_RSN_NFE)
or ERR_FATAL (PCI_EXP_DPC_STATUS_TRIGGER_RSN_FE) from a downstream device,
log the Error Source ID (decoded into domain/bus/device/function).  Don't
print the source otherwise, since it's not valid.

For DPC trigger due to reception of ERR_NONFATAL or ERR_FATAL, the dmesg
logging changes:

  - pci 0000:00:01.0: DPC: containment event, status:0x000d source:0x0200
  - pci 0000:00:01.0: DPC: ERR_FATAL detected
  + pci 0000:00:01.0: DPC: containment event, status:0x000d, ERR_FATAL received from 0000:02:00.0

and when DPC triggered for other reasons, where DPC Error Source ID is
undefined, e.g., unmasked uncorrectable error:

  - pci 0000:00:01.0: DPC: containment event, status:0x0009 source:0x0200
  - pci 0000:00:01.0: DPC: unmasked uncorrectable error detected
  + pci 0000:00:01.0: DPC: containment event, status:0x0009: unmasked uncorrectable error detected

Previously the "containment event" message was at KERN_INFO and the
"%s detected" message was at KERN_WARNING.  Now the single message is at
KERN_WARNING.

Fixes: 26e515713342 ("PCI: Add Downstream Port Containment driver")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20250522232339.1525671-3-helgaas@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/dpc.c | 66 +++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index 8096e4858553e..cdc54315d879f 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -263,37 +263,45 @@ void dpc_process_error(struct pci_dev *pdev)
 	struct aer_err_info info = {};
 
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_STATUS, &status);
-	pci_read_config_word(pdev, cap + PCI_EXP_DPC_SOURCE_ID, &source);
-
-	pci_info(pdev, "containment event, status:%#06x source:%#06x\n",
-		 status, source);
 
 	reason = status & PCI_EXP_DPC_STATUS_TRIGGER_RSN;
-	ext_reason = status & PCI_EXP_DPC_STATUS_TRIGGER_RSN_EXT;
-	pci_warn(pdev, "%s detected\n",
-		 (reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_UNCOR) ?
-		 "unmasked uncorrectable error" :
-		 (reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_NFE) ?
-		 "ERR_NONFATAL" :
-		 (reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_FE) ?
-		 "ERR_FATAL" :
-		 (ext_reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_RP_PIO) ?
-		 "RP PIO error" :
-		 (ext_reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_SW_TRIGGER) ?
-		 "software trigger" :
-		 "reserved error");
-
-	/* show RP PIO error detail information */
-	if (pdev->dpc_rp_extensions &&
-	    reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_IN_EXT &&
-	    ext_reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_RP_PIO)
-		dpc_process_rp_pio_error(pdev);
-	else if (reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_UNCOR &&
-		 dpc_get_aer_uncorrect_severity(pdev, &info) &&
-		 aer_get_device_error_info(pdev, &info)) {
-		aer_print_error(pdev, &info);
-		pci_aer_clear_nonfatal_status(pdev);
-		pci_aer_clear_fatal_status(pdev);
+
+	switch (reason) {
+	case PCI_EXP_DPC_STATUS_TRIGGER_RSN_UNCOR:
+		pci_warn(pdev, "containment event, status:%#06x: unmasked uncorrectable error detected\n",
+			 status);
+		if (dpc_get_aer_uncorrect_severity(pdev, &info) &&
+		    aer_get_device_error_info(pdev, &info)) {
+			aer_print_error(pdev, &info);
+			pci_aer_clear_nonfatal_status(pdev);
+			pci_aer_clear_fatal_status(pdev);
+		}
+		break;
+	case PCI_EXP_DPC_STATUS_TRIGGER_RSN_NFE:
+	case PCI_EXP_DPC_STATUS_TRIGGER_RSN_FE:
+		pci_read_config_word(pdev, cap + PCI_EXP_DPC_SOURCE_ID,
+				     &source);
+		pci_warn(pdev, "containment event, status:%#06x, %s received from %04x:%02x:%02x.%d\n",
+			 status,
+			 (reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_FE) ?
+				"ERR_FATAL" : "ERR_NONFATAL",
+			 pci_domain_nr(pdev->bus), PCI_BUS_NUM(source),
+			 PCI_SLOT(source), PCI_FUNC(source));
+		break;
+	case PCI_EXP_DPC_STATUS_TRIGGER_RSN_IN_EXT:
+		ext_reason = status & PCI_EXP_DPC_STATUS_TRIGGER_RSN_EXT;
+		pci_warn(pdev, "containment event, status:%#06x: %s detected\n",
+			 status,
+			 (ext_reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_RP_PIO) ?
+			 "RP PIO error" :
+			 (ext_reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_SW_TRIGGER) ?
+			 "software trigger" :
+			 "reserved error");
+		/* show RP PIO error detail information */
+		if (ext_reason == PCI_EXP_DPC_STATUS_TRIGGER_RSN_RP_PIO &&
+		    pdev->dpc_rp_extensions)
+			dpc_process_rp_pio_error(pdev);
+		break;
 	}
 }
 
-- 
2.39.5



