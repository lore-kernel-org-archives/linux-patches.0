Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748C7335066;
	Thu,  2 Jul 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011534; cv=none; b=H1z3rC1VklIsoIqmuJ2famOMKKzcS3uVay/D7FvjpJa8hV2IYpF5E4ZyxfEroiDjMRuNbLcThuvgD7BzgKnHDcmsNdkJMjZnl0RnSxPCiMeXdeifNiEbcDdp0r2HYrJd0T6K90XyH3BLapdhsLCw8McpaMvuhbZW4/ibjBQJztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011534; c=relaxed/simple;
	bh=nKwxxXqUZM9mrsIRUAj0QHXstEGrGaZ+xKm91MTnN4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTczYHrmsXlXFiuNSc882/3U7R1YQ2Isdo2VLVq8GzEB8O9yhj9KV4OT+v/DtTjRYRQrCvfhbg8yD3EA2aRchQAOclHQUcEOBL8QqgXV0DTAhMPlXOXjtxw9sPwdS5VJ47CSieek8c/9ZBOnlsq9O5cnV4tZzU3NsYw6MQYcLEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNrhDMSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNrhDMSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09E61F00A3D;
	Thu,  2 Jul 2026 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011533;
	bh=h7i55j2QQwSY2TOX3bCJVgfvUbLG2u5fTJ7cmQYTVeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNrhDMSV/qj1Tibn++WjDQCbiXx8fc1tmZmgCkIGLqk6POckkJZ4ZF8S6GOrHMpvr
	 eSyvzqtg87i3NvS3s1JiBEotwbq47gicztfJTgtqWgf7BG+TiZJgeH+VRmXBgvqZov
	 jXF5lW+k1ZCtgO3BlYwROYP8v7xPibJ+/6rK1qCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 7.1 035/120] PCI/P2PDMA: Add Intel QAT, DSA, IAA devices to whitelist
Date: Thu,  2 Jul 2026 18:20:31 +0200
Message-ID: <20260702155113.687094335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 0ba76b19fd4c7256787eab0283c759b18eb76876 upstream.

The first device on a PCI root bus determines whether the host bridge is
whitelisted for P2PDMA.  All Intel Xeon chips since Ice Lake (ICX, 2021)
expose a device with ID 0x09a2 as first device.  It is loosely associated
with the IOMMU.  All these Xeon chips support P2PDMA, so since the addition
of the device with commit feaea1fe8b36 ("PCI/P2PDMA: Add Intel 3rd Gen
Intel Xeon Scalable Processors to whitelist"), P2PDMA has been allowed on
all new Xeons without the need to amend the whitelist:

Xeons with Performance Cores:
  Sapphire Rapids (SPR, 2023)
  Emerald Rapids (EMR, 2023)
  Granite Rapids (GNR, 2024)
  Diamond Rapids (DMR, 2026)

Xeons with Efficiency Cores:
  Sierra Forest (SRF, 2024)
  Clearwater Forest (CWF, 2026)

However these Xeons also expose accelerators as first device on a root bus
of its own:

  QuickAssist Technology (QAT, crypto & compression accelerator)
  Data Streaming Accelerator (DSA, dma engine)
  In-Memory Analytics Accelerator (IAA, compression accelerator)

Whitelist them for P2PDMA as well.  Move their Device ID macros from the
accelerator drivers to <linux/pci_ids.h> for reuse by P2PDMA code.

Unfortunately the Device IDs vary across Xeon generations as additional
features were added to the accelerators.  This currently necessitates an
amendment for each new Xeon chip.

For future chips, this need shall be avoided by an ongoing effort to extend
ACPI HMAT with PCIe P2PDMA characteristics (latency, bandwidth, ordering
constraints).  The PCI core will be able look up in this BIOS-provided ACPI
table whether P2PDMA is supported, instead of relying on a whitelist that
needs to be amended continuously.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com> # QAT
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/6aac4922b5fe7070b11874427a9285e42ddd05a4.1780585518.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h |    5 -----
 drivers/dma/idxd/registers.h                            |    3 ---
 drivers/pci/p2pdma.c                                    |   10 ++++++++++
 include/linux/pci_ids.h                                 |    8 ++++++++
 4 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -28,15 +28,10 @@
 #define ADF_4XXX_DEVICE_NAME "4xxx"
 #define ADF_420XX_DEVICE_NAME "420xx"
 #define ADF_6XXX_DEVICE_NAME "6xxx"
-#define PCI_DEVICE_ID_INTEL_QAT_4XXX 0x4940
 #define PCI_DEVICE_ID_INTEL_QAT_4XXXIOV 0x4941
-#define PCI_DEVICE_ID_INTEL_QAT_401XX 0x4942
 #define PCI_DEVICE_ID_INTEL_QAT_401XXIOV 0x4943
-#define PCI_DEVICE_ID_INTEL_QAT_402XX 0x4944
 #define PCI_DEVICE_ID_INTEL_QAT_402XXIOV 0x4945
-#define PCI_DEVICE_ID_INTEL_QAT_420XX 0x4946
 #define PCI_DEVICE_ID_INTEL_QAT_420XXIOV 0x4947
-#define PCI_DEVICE_ID_INTEL_QAT_6XXX 0x4948
 #define PCI_DEVICE_ID_INTEL_QAT_6XXX_IOV 0x4949
 
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -10,9 +10,6 @@
 #endif
 
 /* PCI Config */
-#define PCI_DEVICE_ID_INTEL_DSA_GNRD	0x11fb
-#define PCI_DEVICE_ID_INTEL_DSA_DMR	0x1212
-#define PCI_DEVICE_ID_INTEL_IAA_DMR	0x1216
 #define PCI_DEVICE_ID_INTEL_IAA_PTL	0xb02d
 #define PCI_DEVICE_ID_INTEL_IAA_WCL	0xfd2d
 
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -548,6 +548,16 @@ static const struct pci_p2pdma_whitelist
 	{PCI_VENDOR_ID_INTEL,	0x2033, 0},
 	{PCI_VENDOR_ID_INTEL,	0x2020, 0},
 	{PCI_VENDOR_ID_INTEL,	0x09a2, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_DSA_SPR0, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_IAX_SPR0, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_DSA_GNRD, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_DSA_DMR, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_IAA_DMR, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_QAT_4XXX, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_QAT_401XX, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_QAT_402XX, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_QAT_420XX, 0},
+	{PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_QAT_6XXX, 0},
 	/* Google SoCs. */
 	{PCI_VENDOR_ID_GOOGLE,	PCI_ANY_ID, 0},
 	{}
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2732,6 +2732,9 @@
 #define PCI_DEVICE_ID_INTEL_82815_MC	0x1130
 #define PCI_DEVICE_ID_INTEL_82815_CGC	0x1132
 #define PCI_DEVICE_ID_INTEL_SST_TNG	0x119a
+#define PCI_DEVICE_ID_INTEL_DSA_GNRD	0x11fb
+#define PCI_DEVICE_ID_INTEL_DSA_DMR	0x1212
+#define PCI_DEVICE_ID_INTEL_IAA_DMR	0x1216
 #define PCI_DEVICE_ID_INTEL_82092AA_0	0x1221
 #define PCI_DEVICE_ID_INTEL_82437	0x122d
 #define PCI_DEVICE_ID_INTEL_82371FB_0	0x122e
@@ -3052,6 +3055,11 @@
 #define PCI_DEVICE_ID_INTEL_5400_FBD1	0x4036
 #define PCI_DEVICE_ID_INTEL_HDA_TGL_H	0x43c8
 #define PCI_DEVICE_ID_INTEL_HDA_DG1	0x490d
+#define PCI_DEVICE_ID_INTEL_QAT_4XXX	0x4940
+#define PCI_DEVICE_ID_INTEL_QAT_401XX	0x4942
+#define PCI_DEVICE_ID_INTEL_QAT_402XX	0x4944
+#define PCI_DEVICE_ID_INTEL_QAT_420XX	0x4946
+#define PCI_DEVICE_ID_INTEL_QAT_6XXX	0x4948
 #define PCI_DEVICE_ID_INTEL_HDA_EHL_0	0x4b55
 #define PCI_DEVICE_ID_INTEL_HDA_EHL_3	0x4b58
 #define PCI_DEVICE_ID_INTEL_HDA_WCL	0x4d28


