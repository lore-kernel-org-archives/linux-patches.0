Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A91481A6;
	Mon,  8 Apr 2024 13:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581562; cv=none; b=QnSCYcqzD/jsompNemNBxGu2Bjggxf4LzJyuUKLhftCdVXR3FHM2bdSvPqcs8HiEmM/661zbdkfeq1Fb2LpOX1qKDuF0Q/MOqzhiYkRdcvWPjIkqoCs1F1EyxBnMsAFvG0CXT8RM5ttRD7LZlsJx2bFDcCAn2ohCyYkCaiND2jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581562; c=relaxed/simple;
	bh=niA1h5RN8uoOOKtI+js8T74ZTl8Ewk4+IuG+ZSuZZyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhRaGqAxKnLulyKHfraP1ulDf+qxtCsIVtDRyWRUu4iJXWJ+/MFtsMLrYIu1khKo0SyMfiMsj65pbGYFZ/pT90RKoLUVsDYUA/AeUqTXzAUd3Fr7e3sRYbrhiF9/QfVtJhKEnqUUSbguwqxFiWiL0AcWrYiVU+QGwDxZ9BGHznU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7X3juo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7X3juo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2259C433C7;
	Mon,  8 Apr 2024 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581562;
	bh=niA1h5RN8uoOOKtI+js8T74ZTl8Ewk4+IuG+ZSuZZyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7X3juo06pUK7a0kEVl3hCfCTiFWNl51JYwlEbkipmMPSqca4S7/apz+fr5o+p5Jv
	 qhC9AetlpBL2tBDuwmRODShDvdwZuaZPN0ydTVmC1zDWxdY7Xc1yOdJE5IjfZmPgwb
	 qnagAewVQombIaPT4rztt0LKzo032WZPMNGjv7zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/690] PCI/ASPM: Make Intel DG2 L1 acceptable latency unlimited
Date: Mon,  8 Apr 2024 14:48:49 +0200
Message-ID: <20240408125401.797205403@linuxfoundation.org>
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

[ Upstream commit 03038d84ace72678a9944524508f218a00377dc0 ]

Intel DG2 discrete graphics PCIe endpoints advertise L1 acceptable exit
latency to be < 1us even though they can actually tolerate unlimited exit
latencies just fine. Quirk the L1 acceptable exit latency for these
endpoints to be unlimited so ASPM L1 can be enabled.

[bhelgaas: use FIELD_GET/FIELD_PREP, wordsmith comment & commit log]
Link: https://lore.kernel.org/r/20220405093810.76613-1-mika.westerberg@linux.intel.com
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 627c6db20703 ("PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 47 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 50501c10809d2..3217d4aaea598 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -12,6 +12,7 @@
  * file, where their drivers can use them.
  */
 
+#include <linux/bitfield.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
@@ -5903,3 +5904,49 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1533, rom_bar_overlap_defect);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1536, rom_bar_overlap_defect);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1537, rom_bar_overlap_defect);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1538, rom_bar_overlap_defect);
+
+#ifdef CONFIG_PCIEASPM
+/*
+ * Several Intel DG2 graphics devices advertise that they can only tolerate
+ * 1us latency when transitioning from L1 to L0, which may prevent ASPM L1
+ * from being enabled.  But in fact these devices can tolerate unlimited
+ * latency.  Override their Device Capabilities value to allow ASPM L1 to
+ * be enabled.
+ */
+static void aspm_l1_acceptable_latency(struct pci_dev *dev)
+{
+	u32 l1_lat = FIELD_GET(PCI_EXP_DEVCAP_L1, dev->devcap);
+
+	if (l1_lat < 7) {
+		dev->devcap |= FIELD_PREP(PCI_EXP_DEVCAP_L1, 7);
+		pci_info(dev, "ASPM: overriding L1 acceptable latency from %#x to 0x7\n",
+			 l1_lat);
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f80, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f81, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f82, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f83, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f84, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f85, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f86, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f87, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x4f88, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x5690, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x5691, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x5692, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x5693, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x5694, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x5695, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56a0, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56a1, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56a2, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56a3, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56a4, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56a5, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56a6, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56b0, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56b1, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c0, aspm_l1_acceptable_latency);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c1, aspm_l1_acceptable_latency);
+#endif
-- 
2.43.0



