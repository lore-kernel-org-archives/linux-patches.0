Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3331448C8;
	Thu, 11 Apr 2024 10:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831718; cv=none; b=cWtVjUomyLCcAsIYk3ezl7poNHw3a2TDGdwo/Jb601fQdP6DLdZ4RG4yk1EuI9eQj+TvAjyjEjQW3bR1lE0xRrRlFURJuEWgPtYmDL0J40k9W2JaL92Z9yyqPrqgJT2Kr+x/hwH9KLiUQ4GzAIKdz+YdiY0e6kWbef/qGdKwdsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831718; c=relaxed/simple;
	bh=Gue8tFRW43URzCjs7SdV40/kI+cgw61FVF0ipsg4nv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI7FJrTgg9QMogruIhRqU+3rP47qDxchyoNHOIGXwiDOtsnGWwx1FuEEuPCG8dUACetb97nNK+/s5Ups850N+anA3S8FtI54DVDdmWCkG8WzcNMnRvGZIdvSsWn9Ws3XEVgrbaPSdXtBu/3KuX6MCa1SXGCtNfAbyyyLcKzoVC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKIYUwd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKIYUwd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CD2C433F1;
	Thu, 11 Apr 2024 10:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831718;
	bh=Gue8tFRW43URzCjs7SdV40/kI+cgw61FVF0ipsg4nv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKIYUwd0gzUPmd3XOL9IKkfvkpz0rrVoNGwhV6RfE8W0yGPnafVwUm3YhfilYu6dF
	 T3Vz1sV60tWJ53kRjLp+ZN2E2jZo+o+caOhdxKmxxzaw2olnx7xny4U9Nu88lEe+VW
	 8ZNz2OBOE6UhGMsNEv8mA5Pl29ExjYXLgTpy3jk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/294] PCI/DPC: Quirk PIO log size for certain Intel Root Ports
Date: Thu, 11 Apr 2024 11:53:48 +0200
Message-ID: <20240411095437.646850413@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3f494d6653284..a467e3ce6fb10 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5909,3 +5909,39 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56b1, aspm_l1_acceptable_latency
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



