Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0EA46DFE9;
	Tue, 21 Jul 2026 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656982; cv=none; b=ECZhRcnOWovGt0P90HT+Ms+/hm4bFt6dfcuYRfV2ZtCbpIDK1XFsFWIxwN2rKKsmH4rq5R5PlM4Fa8oHFDgeRZqoCR0T8Du92xbrl5aHYMIRNylNdDo2YsIN9shHUw7Yjx+W0KvwO9gHyvcxPBw3ezx4aZAR1d0jOoxlQxTi7qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656982; c=relaxed/simple;
	bh=faneA+NF/dbr9MWBHNExotMncFgD7wHRshGWGgdeVK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAs7JRY4fvcTdklud7YVr+PU3ShnqdqzCzvcYSqfmsk+MPBVZ6MaQiqetq0cY3YLKdBI8S7fOJlV7/1Pd3kvNWSB43Fg2L5xBWXy/FRlTw5eQD19sgd870RSPPnzHu9DR+rUqk9YQrM5CXyHSvS7sI+r86wJTbFU+ngmMOUueH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lb4hgDoI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lb4hgDoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28731F000E9;
	Tue, 21 Jul 2026 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656981;
	bh=tI1npYlzzi4XDueen9Gfx4WxDpDk6ESuRnf98U1cjhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lb4hgDoIqGmlQtTGd3jCGyhUKcJM33xk15VFj5BBxfTelJ+wBxc9Y4aGgLRE8rk4F
	 dgqTcSKHAeP+sp/Y1FRSccN7A6DbSMchG9fvYAAvIqhOUMqOnMbqqxQyhjzthDsNWz
	 vPbS5hwteJ7lMpa9AqIVNUFWGNNWmsz+yA2SOSRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Lain=20 Fearyncess =20Yang?= <i@lain.vg>,
	Rong Zhang <i@rong.moe>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0591/1611] PCI: loongson: Do not ignore downstream devices on external bridges
Date: Tue, 21 Jul 2026 17:11:47 +0200
Message-ID: <20260721152528.676029101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



