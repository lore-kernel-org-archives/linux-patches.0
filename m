Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136F32DF73;
	Mon,  8 Apr 2024 13:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581571; cv=none; b=BonHdCMYLSKqYVCvvkhX4v4/6E8bKdnDZnPTOUvfzjXTXeC9LUaD0JKuMBUiUM8ePRmsCNM58vAO4IzKbAa8MyrPxLyuYoaK8DEDwUsTvZQVadJQSWifYO02ebS/x8GifzLks35V+heST9GcoZuiDKFlvAq6x5svLkmX1t4t5W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581571; c=relaxed/simple;
	bh=mM7EzL/2UHZeOoLynJk4L/EIsXSSxmXR15n/EG1pa0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAnSBL1SGkgPVGeoAtuGWE8y7WGu0Bxl2rrgyHo+ma4jlPqZee1eK2wG9YidYjB3YH5/LtSAP2I6xXriyiBppvJjr3SpQ331OuidxRvBD2TofoKtKULA18x7vefKBZk/CVKTzVfpFJ7fsVo1hKj/s9ffUg9e76mEp23y4lxdO6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7rUyHa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7rUyHa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3B0C433C7;
	Mon,  8 Apr 2024 13:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581570;
	bh=mM7EzL/2UHZeOoLynJk4L/EIsXSSxmXR15n/EG1pa0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7rUyHa7zy01ZD+OaAYHWkaK3yppOi/HwPWyzwUIsKA48LnOYWf6pl9disnZ4IBDX
	 /kl1UXE5FNPOoHVbx9HF86sRjYSZJi7mwDBEWkP2qEdxrMRW9vIyu3xs1EPM6SUwlT
	 mr1vCYlXl/Xms3kW3mn4zIH4MKYMks+gZm0Li3C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/690] PCI/DPC: Quirk PIO log size for certain Intel Root Ports
Date: Mon,  8 Apr 2024 14:48:50 +0200
Message-ID: <20240408125401.829721419@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 5459c0b7046752e519a646e1c2404852bb628459 ]

Some Root Ports on Intel Tiger Lake and Alder Lake systems support the RP
Extensions for DPC and the RP PIO Log registers but incorrectly advertise
an RP PIO Log Size of zero.  This means the kernel complains that:

  DPC: RP PIO log size 0 is invalid

and if DPC is triggered, the DPC driver will not dump the RP PIO Log
registers when it should.

This is caused by a BIOS bug and should be fixed the BIOS for future CPUs.

Add a quirk to set the correct RP PIO Log size for the affected Root Ports.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=209943
Link: https://lore.kernel.org/r/20220816102042.69125-1-mika.westerberg@linux.intel.com
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Stable-dep-of: 627c6db20703 ("PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/dpc.c | 15 ++++++++++-----
 drivers/pci/quirks.c   | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index cf0d4ba2e157a..ab83f78f3eb1d 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -335,11 +335,16 @@ void pci_dpc_init(struct pci_dev *pdev)
 		return;
 
 	pdev->dpc_rp_extensions = true;
-	pdev->dpc_rp_log_size = (cap & PCI_EXP_DPC_RP_PIO_LOG_SIZE) >> 8;
-	if (pdev->dpc_rp_log_size < 4 || pdev->dpc_rp_log_size > 9) {
-		pci_err(pdev, "RP PIO log size %u is invalid\n",
-			pdev->dpc_rp_log_size);
-		pdev->dpc_rp_log_size = 0;
+
+	/* Quirks may set dpc_rp_log_size if device or firmware is buggy */
+	if (!pdev->dpc_rp_log_size) {
+		pdev->dpc_rp_log_size =
+			(cap & PCI_EXP_DPC_RP_PIO_LOG_SIZE) >> 8;
+		if (pdev->dpc_rp_log_size < 4 || pdev->dpc_rp_log_size > 9) {
+			pci_err(pdev, "RP PIO log size %u is invalid\n",
+				pdev->dpc_rp_log_size);
+			pdev->dpc_rp_log_size = 0;
+		}
 	}
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3217d4aaea598..59b3dd33092bf 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5950,3 +5950,39 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56b1, aspm_l1_acceptable_latency
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c0, aspm_l1_acceptable_latency);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c1, aspm_l1_acceptable_latency);
 #endif
+
+#ifdef CONFIG_PCIE_DPC
+/*
+ * Intel Tiger Lake and Alder Lake BIOS has a bug that clears the DPC
+ * RP PIO Log Size of the integrated Thunderbolt PCIe Root Ports.
+ */
+static void dpc_log_size(struct pci_dev *dev)
+{
+	u16 dpc, val;
+
+	dpc = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DPC);
+	if (!dpc)
+		return;
+
+	pci_read_config_word(dev, dpc + PCI_EXP_DPC_CAP, &val);
+	if (!(val & PCI_EXP_DPC_CAP_RP_EXT))
+		return;
+
+	if (!((val & PCI_EXP_DPC_RP_PIO_LOG_SIZE) >> 8)) {
+		pci_info(dev, "Overriding RP PIO Log Size to 4\n");
+		dev->dpc_rp_log_size = 4;
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x461f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x462f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x463f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x466e, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a23, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a25, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a27, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a29, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2b, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
+#endif
-- 
2.43.0



