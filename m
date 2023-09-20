Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E87B2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CF7C433C8;
	Wed, 20 Sep 2023 12:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211993;
	bh=qYEtc3nH/dlyeE1UH5eIxPGPEzKy+md/xR/RdM24CvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5V5V/cjtVclbKOG3MuZF+NI4LrwZscz5wNmQWPx1Ke2h19+NRZe0orNtxEG/Tg2Q
	 gke3CrXfx5MZdHmDVy5YpOHEsp3lhfEtpWgWVzkWi9ROeBXE/91EkiEFFMo+5mqH9J
	 XxYwlEDxiVJqpLm0FSisnsJU3eMZMCWtgtkTkP0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Keith Busch <keith.busch@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/273] PCI/ATS: Add pci_prg_resp_pasid_required() interface.
Date: Wed, 20 Sep 2023 13:29:11 +0200
Message-ID: <20230920112849.911782604@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit e5567f5f67621877726f99be040af9fbedda37dc ]

Return the PRG Response PASID Required bit in the Page Request
Status Register.

As per PCIe spec r4.0, sec 10.5.2.3, if this bit is Set, the device
expects a PASID TLP Prefix on PRG Response Messages when the
corresponding Page Requests had a PASID TLP Prefix. If Clear, the device
does not expect PASID TLP Prefixes on any PRG Response Message, and the
device behavior is undefined if the device receives a PRG Response Message
with a PASID TLP Prefix. Also the device behavior is undefined if this
bit is Set and the device receives a PRG Response Message with no PASID TLP
Prefix when the corresponding Page Requests had a PASID TLP Prefix.

This function will be used by drivers like IOMMU, if it is required to
check the status of the PRG Response PASID Required bit before enabling
the PASID support of the device.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Suggested-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: ce7d88110b9e ("drm/amdgpu: Use RMW accessors for changing LNKCTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/ats.c             | 30 ++++++++++++++++++++++++++++++
 include/linux/pci-ats.h       |  5 +++++
 include/uapi/linux/pci_regs.h |  1 +
 3 files changed, 36 insertions(+)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index 5b78f3b1b918a..420cd0a578d07 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -368,6 +368,36 @@ int pci_pasid_features(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pci_pasid_features);
 
+/**
+ * pci_prg_resp_pasid_required - Return PRG Response PASID Required bit
+ *				 status.
+ * @pdev: PCI device structure
+ *
+ * Returns 1 if PASID is required in PRG Response Message, 0 otherwise.
+ *
+ * Even though the PRG response PASID status is read from PRI Status
+ * Register, since this API will mainly be used by PASID users, this
+ * function is defined within #ifdef CONFIG_PCI_PASID instead of
+ * CONFIG_PCI_PRI.
+ */
+int pci_prg_resp_pasid_required(struct pci_dev *pdev)
+{
+	u16 status;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
+	if (!pos)
+		return 0;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS, &status);
+
+	if (status & PCI_PRI_STATUS_PASID)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_prg_resp_pasid_required);
+
 #define PASID_NUMBER_SHIFT	8
 #define PASID_NUMBER_MASK	(0x1f << PASID_NUMBER_SHIFT)
 /**
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index 7c4b8e27268c7..facfd6a18fe18 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -40,6 +40,7 @@ void pci_disable_pasid(struct pci_dev *pdev);
 void pci_restore_pasid_state(struct pci_dev *pdev);
 int pci_pasid_features(struct pci_dev *pdev);
 int pci_max_pasids(struct pci_dev *pdev);
+int pci_prg_resp_pasid_required(struct pci_dev *pdev);
 
 #else  /* CONFIG_PCI_PASID */
 
@@ -66,6 +67,10 @@ static inline int pci_max_pasids(struct pci_dev *pdev)
 	return -EINVAL;
 }
 
+static int pci_prg_resp_pasid_required(struct pci_dev *pdev)
+{
+	return 0;
+}
 #endif /* CONFIG_PCI_PASID */
 
 
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 8d2767140798b..4c7aa15b0e2ee 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -885,6 +885,7 @@
 #define  PCI_PRI_STATUS_RF	0x001	/* Response Failure */
 #define  PCI_PRI_STATUS_UPRGI	0x002	/* Unexpected PRG index */
 #define  PCI_PRI_STATUS_STOPPED	0x100	/* PRI Stopped */
+#define  PCI_PRI_STATUS_PASID	0x8000	/* PRG Response PASID Required */
 #define PCI_PRI_MAX_REQ		0x08	/* PRI max reqs supported */
 #define PCI_PRI_ALLOC_REQ	0x0c	/* PRI max reqs allowed */
 #define PCI_EXT_CAP_PRI_SIZEOF	16
-- 
2.40.1



