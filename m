Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DEB3A874B;
	Tue, 21 Jul 2026 19:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662379; cv=none; b=FpYOdEJW28YQQ/vfxctZPMmxMxb3x0Zi1ERfMIyXMJzFhUNPDzg/1eqHppX1YNicW54K5bvbMEqnI1KXP+5P5afGegM6SF/efGS+ajz/AsvWvjjXG2CrUKG5Q6STbkvpiB9eY4NcF8q5ZXNjXW/8q15fO2uo/cZarH/hqTXcHR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662379; c=relaxed/simple;
	bh=ZtW6FNuvAuJwCMCvzgHUjS5eI6gzcganS2F0E0Qc27I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcSzSsaddByQw5APnC3RPTCYlZu3otEh8kigBdHyJBmY1ewxTEg+svXgI6oNl+mZxKTgfp9ypu/tS+Rj83f1W8iRp4N6QiHKu3S9IH6QaqRpOlOKyH59T+CagSNh/pB2XQX4X7k51lCXBpwTKaxWzX3vxHsN8pt9xXXeAO4J4gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCzGAuMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCzGAuMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA981F000E9;
	Tue, 21 Jul 2026 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662378;
	bh=2TEkYyc42LuBTQIGxMFF+s6SUdF/a65prIrBXN8WHQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCzGAuMbpvHyV0uhDOLj90ugqq2a2fWdXDasyKJTqj9QP3o6CqZb30gpztMYqZNJG
	 qMsnfD0ccMVljHw80/w91d7Lkj51ZmUa0EwiMgjlpuqaUqLknkl/T3/BRvBHMDxfiH
	 oOat+DswkHlSWZiDRd0gt+fNRXO5QL0UkU1w4hU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Lain=20 Fearyncess =20Yang?= <i@lain.vg>,
	Rong Zhang <i@rong.moe>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0423/1276] PCI: loongson: Do not ignore downstream devices on external bridges
Date: Tue, 21 Jul 2026 17:14:26 +0200
Message-ID: <20260721152455.569393283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

[ Upstream commit 1389ab9bf9f627d4daed86f492091b00f110aa86 ]

Loongson PCI host controllers have a hardware quirk that requires
software to ignore downstream devices with device number > 0 on the
internal bridges. The current implementation applies the workaround to
all non-root buses, which breaks external bridges (e.g., PCIe switches)
with multiple downstream devices.

Fix it by only applying the workaround to internal bridges.

Tested on Loongson-LS3A4000-7A1000-NUC-SE, using AMD Promontory 21
chipset add-in card [1].

  $ lspci -tnnnvvv
  -[0000:00]-+-00.0  Loongson Technology LLC 7A1000 Chipset Hyper Transport Bridge Controller [0014:7a00]
             +-00.1  Loongson Technology LLC 7A2000 Chipset Hyper Transport Bridge Controller [0014:7a10]
             +-03.0  Loongson Technology LLC 2K1000/2000 / 7A1000 Chipset Gigabit Ethernet Controller [0014:7a03]
             +-04.0  Loongson Technology LLC 2K1000 / 7A1000/2000 Chipset USB OHCI Controller [0014:7a24]
             +-04.1  Loongson Technology LLC 2K1000 / 7A1000/2000 Chipset USB EHCI Controller [0014:7a14]
             +-05.0  Loongson Technology LLC 2K1000 / 7A1000/2000 Chipset USB OHCI Controller [0014:7a24]
             +-05.1  Loongson Technology LLC 2K1000 / 7A1000/2000 Chipset USB EHCI Controller [0014:7a14]
             +-06.0  Loongson Technology LLC 7A1000 Chipset Vivante GC1000 GPU [0014:7a15]
             +-06.1  Loongson Technology LLC 2K1000 / 7A1000 Chipset Display Controller [0014:7a06]
             +-07.0  Loongson Technology LLC 2K1000/2000/3000 / 3B6000M / 7A1000/2000 Chipset HD Audio Controller [0014:7a07]
             +-08.0  Loongson Technology LLC 2K1000 / 7A1000 Chipset 3Gb/s SATA AHCI Controller [0014:7a08]
             +-08.1  Loongson Technology LLC 2K1000 / 7A1000 Chipset 3Gb/s SATA AHCI Controller [0014:7a08]
             +-08.2  Loongson Technology LLC 2K1000 / 7A1000 Chipset 3Gb/s SATA AHCI Controller [0014:7a08]
             +-09.0-[01]----00.0  Qualcomm Technologies, Inc QCNFA765 Wireless Network Adapter [17cb:1103]
             +-0a.0-[02]----00.0  Etron Technology, Inc. EJ188/EJ198 USB 3.0 Host Controller [1b6f:7052]
             +-0f.0-[03-08]----00.0-[04-08]--+-00.0-[05]----00.0  Shenzhen Longsys Electronics Co., Ltd. FORESEE XP1000 / Lexar Professional CFexpress Type B Gold series, NM620 PCIe NVME SSD (DRAM-less) [1d97:5216]
             |                               +-08.0-[06]----00.0  MAXIO Technology (Hangzhou) Ltd. NVMe SSD Controller MAP1202 (DRAM-less) [1e4b:1202]
             |                               +-0c.0-[07]----00.0  Advanced Micro Devices, Inc. [AMD] 600 Series Chipset USB 3.2 Controller [1022:43f7]
             |                               \-0d.0-[08]----00.0  Advanced Micro Devices, Inc. [AMD] 600 Series Chipset SATA Controller [1022:43f6]
             \-16.0  Loongson Technology LLC 7A1000 Chipset SPI Controller [0014:7a0b]

Fixes: 2410e3301fcc ("PCI: loongson: Don't access non-existent devices")
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Co-developed-by: Lain "Fearyncess" Yang <i@lain.vg>
Signed-off-by: Lain "Fearyncess" Yang <i@lain.vg>
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://oshwhub.com/wesd/b650 [1]
Link: https://patch.msgid.link/20260501-ls7a-bridge-fixes-v2-1-69fa93683805@rong.moe
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-loongson.c | 31 ++++++++++++++-------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/controller/pci-loongson.c b/drivers/pci/controller/pci-loongson.c
index 9609e6f50b9816..d0c643996476f8 100644
--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -80,6 +80,18 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 			DEV_LS7A_LPC, system_bus_quirk);
 
+static const struct pci_device_id loongson_internal_bridge_devids[] = {
+	{ PCI_VDEVICE(LOONGSON, DEV_LS2K_PCIE_PORT0) },
+	{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT0) },
+	{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT1) },
+	{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT2) },
+	{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT3) },
+	{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT4) },
+	{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT5) },
+	{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT6) },
+	{ 0, },
+};
+
 /*
  * Some Loongson PCIe ports have hardware limitations on their Maximum Read
  * Request Size. They can't handle anything larger than this.  Sane
@@ -92,24 +104,13 @@ static void loongson_set_min_mrrs_quirk(struct pci_dev *pdev)
 {
 	struct pci_bus *bus = pdev->bus;
 	struct pci_dev *bridge;
-	static const struct pci_device_id bridge_devids[] = {
-		{ PCI_VDEVICE(LOONGSON, DEV_LS2K_PCIE_PORT0) },
-		{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT0) },
-		{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT1) },
-		{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT2) },
-		{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT3) },
-		{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT4) },
-		{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT5) },
-		{ PCI_VDEVICE(LOONGSON, DEV_LS7A_PCIE_PORT6) },
-		{ 0, },
-	};
 
 	/* look for the matching bridge */
 	while (!pci_is_root_bus(bus)) {
 		bridge = bus->self;
 		bus = bus->parent;
 
-		if (pci_match_id(bridge_devids, bridge)) {
+		if (pci_match_id(loongson_internal_bridge_devids, bridge)) {
 			if (pcie_get_readrq(pdev) > 256) {
 				pci_info(pdev, "limiting MRRS to 256\n");
 				pcie_set_readrq(pdev, 256);
@@ -266,11 +267,11 @@ static void __iomem *pci_loongson_map_bus(struct pci_bus *bus,
 	struct loongson_pci *priv = pci_bus_to_loongson_pci(bus);
 
 	/*
-	 * Do not read more than one device on the bus other than
-	 * the host bus.
+	 * Do not read more than one device on the internal bridges.
 	 */
 	if ((priv->data->flags & FLAG_DEV_FIX) && bus->self) {
-		if (!pci_is_root_bus(bus) && (device > 0))
+		if (!pci_is_root_bus(bus) && (device > 0) &&
+		    pci_match_id(loongson_internal_bridge_devids, bus->self))
 			return NULL;
 	}
 
-- 
2.53.0



