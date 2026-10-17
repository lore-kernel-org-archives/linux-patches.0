Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AEE22F767;
	Sat, 17 Oct 2026 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253332; cv=none; b=NwzTDwpUDmlfw6efON6LgoZ7tOS5qlbDRSF0/GCqZGe/xohssAeXGHauI8fgWY+WZ0CvTGWTDSmMltVlPgJpy8upRnvtCcjsXjgEX2HuzTgC9NYwos1a5Ac3oBMmggEXng0tAyQ3An69ManfuQty/ltBYAQJQpBBNjmjyQPMTCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253332; c=relaxed/simple;
	bh=jLGhVz8Im11TajkSkRzo+mPULKT+VQqLwgxfzvYkpJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEoVRSF8yEL1S+I96h+6OA9ZYvUkHGyKQP9LklE5z/q2+qnUAmjUVSeQI08cURsmQIxsq5hr/xdLpDX9yuXswPM8qWzl7u/WXZ8a0+WKF0uBR5Os5FRM6DYD4OP9nErXLzOpMT+0gnDZliDmeA6/veU7SYpQT1hGvsyln4WH08Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCgcOR7c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCgcOR7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D78A1F000C4;
	Sat, 17 Oct 2026 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253330;
	bh=HvakykYoV8q5RPbXPvwvjIEVZPJbmElCBlKaidnsvrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCgcOR7cn9O4mzX78jiUbWGz0ymtubiMAjUc9ccIL6cC8JE7hd6iCDYfp3/8Nu6BI
	 NM/eodZqX3WnjLpVrExvs9T3DtDijC1sVC2nXWhis7z6HEhdPcdXHEY1pHTmhj1Psg
	 LJnirPITpN2pfCh+YRIo3kKcYQ9eBT6Agflo3L90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>
Subject: [PATCH 6.12 066/869] perf/dwc_pcie: Qualify RAS DES VSEC Capability by Vendor, Revision
Date: Sat, 17 Oct 2026 17:48:27 +0200
Message-ID: <20261017160038.717039085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit b34d605d120f09303cf8d9e25ad3e17a4997c3a1 ]

PCI Vendor-Specific (VSEC) Capabilities are defined by each vendor.
Devices from different vendors may advertise a VSEC Capability with the DWC
RAS DES functionality, but the vendors may assign different VSEC IDs.

Search for the DWC RAS DES Capability using the VSEC ID and VSEC Rev
chosen by the vendor.

This does not fix a current problem because Alibaba, Ampere, and Qualcomm
all assigned the same VSEC ID and VSEC Rev for the DWC RAS DES Capability.

The potential issue is that we may add support for a device from another
vendor, where the vendor has already assigned DWC_PCIE_VSEC_RAS_DES_ID
(0x02) for an unrelated VSEC.  In that event, dwc_pcie_des_cap() would find
the unrelated VSEC and mistakenly assume it was a DWC RAS DES Capability.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-and-tested-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Reviewed-and-tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241209222938.3219364-1-helgaas@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>

Keep the vendor table limited to the existing Alibaba and Qualcomm
devices. Omit the Ampere entry because its separate support change
is absent. Retain the capability lookup conversion and probe checks
needed by the device-registration fix.

Stable-dep-of: 7f35b429802a ("perf/dwc_pcie: fix duplicate pci_dev devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/dwc_pcie_pmu.c | 65 ++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index 7dbda36884c8d..9687083c42fbc 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -20,7 +20,6 @@
 #include <linux/sysfs.h>
 #include <linux/types.h>
 
-#define DWC_PCIE_VSEC_RAS_DES_ID		0x02
 #define DWC_PCIE_EVENT_CNT_CTL			0x8
 
 /*
@@ -101,13 +100,21 @@ struct dwc_pcie_dev_info {
 	struct list_head dev_node;
 };
 
-struct dwc_pcie_vendor_id {
-	int vendor_id;
+struct dwc_pcie_pmu_vsec_id {
+	u16 vendor_id;
+	u16 vsec_id;
+	u8 vsec_rev;
 };
 
-static const struct dwc_pcie_vendor_id dwc_pcie_vendor_ids[] = {
-	{.vendor_id = PCI_VENDOR_ID_ALIBABA },
-	{.vendor_id = PCI_VENDOR_ID_QCOM },
+/*
+ * VSEC IDs are allocated by the vendor, so a given ID may mean different
+ * things to different vendors.  See PCIe r6.0, sec 7.9.5.2.
+ */
+static const struct dwc_pcie_pmu_vsec_id dwc_pcie_pmu_vsec_ids[] = {
+	{ .vendor_id = PCI_VENDOR_ID_ALIBABA,
+	  .vsec_id = 0x02, .vsec_rev = 0x4 },
+	{ .vendor_id = PCI_VENDOR_ID_QCOM,
+	  .vsec_id = 0x02, .vsec_rev = 0x4 },
 	{} /* terminator */
 };
 
@@ -519,31 +526,28 @@ static void dwc_pcie_unregister_pmu(void *data)
 	perf_pmu_unregister(&pcie_pmu->pmu);
 }
 
-static bool dwc_pcie_match_des_cap(struct pci_dev *pdev)
+static u16 dwc_pcie_des_cap(struct pci_dev *pdev)
 {
-	const struct dwc_pcie_vendor_id *vid;
-	u16 vsec = 0;
+	const struct dwc_pcie_pmu_vsec_id *vid;
+	u16 vsec;
 	u32 val;
 
 	if (!pci_is_pcie(pdev) || !(pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT))
-		return false;
+		return 0;
 
-	for (vid = dwc_pcie_vendor_ids; vid->vendor_id; vid++) {
+	for (vid = dwc_pcie_pmu_vsec_ids; vid->vendor_id; vid++) {
 		vsec = pci_find_vsec_capability(pdev, vid->vendor_id,
-						DWC_PCIE_VSEC_RAS_DES_ID);
-		if (vsec)
-			break;
+						vid->vsec_id);
+		if (vsec) {
+			pci_read_config_dword(pdev, vsec + PCI_VNDR_HEADER,
+					      &val);
+			if (PCI_VNDR_HEADER_REV(val) == vid->vsec_rev) {
+				pci_dbg(pdev, "Detected PCIe Vendor-Specific Extended Capability RAS DES\n");
+				return vsec;
+			}
+		}
 	}
-	if (!vsec)
-		return false;
-
-	pci_read_config_dword(pdev, vsec + PCI_VNDR_HEADER, &val);
-	if (PCI_VNDR_HEADER_REV(val) != 0x04)
-		return false;
-
-	pci_dbg(pdev,
-		"Detected PCIe Vendor-Specific Extended Capability RAS DES\n");
-	return true;
+	return 0;
 }
 
 static void dwc_pcie_unregister_dev(struct dwc_pcie_dev_info *dev_info)
@@ -589,7 +593,7 @@ static int dwc_pcie_pmu_notifier(struct notifier_block *nb,
 
 	switch (action) {
 	case BUS_NOTIFY_ADD_DEVICE:
-		if (!dwc_pcie_match_des_cap(pdev))
+		if (!dwc_pcie_des_cap(pdev))
 			return NOTIFY_DONE;
 		if (dwc_pcie_register_dev(pdev))
 			return NOTIFY_BAD;
@@ -614,13 +618,14 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 	struct pci_dev *pdev = plat_dev->dev.platform_data;
 	struct dwc_pcie_pmu *pcie_pmu;
 	char *name;
-	u32 sbdf, val;
+	u32 sbdf;
 	u16 vsec;
 	int ret;
 
-	vsec = pci_find_vsec_capability(pdev, pdev->vendor,
-					DWC_PCIE_VSEC_RAS_DES_ID);
-	pci_read_config_dword(pdev, vsec + PCI_VNDR_HEADER, &val);
+	vsec = dwc_pcie_des_cap(pdev);
+	if (!vsec)
+		return -ENODEV;
+
 	sbdf = plat_dev->id;
 	name = devm_kasprintf(&plat_dev->dev, GFP_KERNEL, "dwc_rootport_%x", sbdf);
 	if (!name)
@@ -741,7 +746,7 @@ static int __init dwc_pcie_pmu_init(void)
 	int ret;
 
 	for_each_pci_dev(pdev) {
-		if (!dwc_pcie_match_des_cap(pdev))
+		if (!dwc_pcie_des_cap(pdev))
 			continue;
 
 		ret = dwc_pcie_register_dev(pdev);
-- 
2.53.0



