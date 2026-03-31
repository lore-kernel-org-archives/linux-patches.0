Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59840423A79;
	Tue, 31 Mar 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974542; cv=none; b=QuHyqWnVjxRp3MGBxcZh8RhFaD94kNDRc3mglkHACvLQi3tuS8k7AoApMV0yJAai8bl1Yo0AgXjiKjoznjvEfjo6C5Uka6IV+Lp3jqZUPCoqRA00de2plPdCgUCgSr0nob/Kzbtyvxr69/p5N2soZ4Fp06vMEL1JKxYrAByUT9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974542; c=relaxed/simple;
	bh=lF+zLlZGrIQzvhLEGAwtt0tNqQSRaVPWTfjv1D8FQNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqXNAtr5agoDRH2nXcsHWQ9HgFiMZXNye3JkhBRvOmHpNqekt53SMMhJceLnqPnh8Dmn3Ba3XTDRVw5JeMusxqPbRHWz6swaD/GtQcff6Q9l4b6xTURgnz6kAy56S1SQLUOSqXzHjeQyEj9+Gkcdk0ewuS3zDNTiIYgkzWI8vAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AasWTXMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AasWTXMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34B1C19423;
	Tue, 31 Mar 2026 16:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974542;
	bh=lF+zLlZGrIQzvhLEGAwtt0tNqQSRaVPWTfjv1D8FQNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AasWTXMg1fIWoyc5PN+szPUe7hhTU7rAblGXih3tbJ/zeIF2BiopZrtAkAO+0XVAv
	 b5ecNR9HYIGusrJpnUpQ2TZLq3h6nZSM4uiToy9oPNZKY6zPFx3g4nWDrUy6pmHz10
	 D3lKJCSNaOPpcgKDX1rYz75e13T/73MsNbb2HzV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 126/175] LoongArch: Workaround LS2K/LS7A GPU DMA hang bug
Date: Tue, 31 Mar 2026 18:21:50 +0200
Message-ID: <20260331161734.410640998@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 95db0c9f526d583634cddb2e5914718570fbac87 upstream.

1. Hardware limitation: GPU, DC and VPU are typically PCI device 06.0,
06.1 and 06.2. They share some hardware resources, so when configure the
PCI 06.0 device BAR1, DMA memory access cannot be performed through this
BAR, otherwise it will cause hardware abnormalities.

2. In typical scenarios of reboot or S3/S4, DC access to memory through
BAR is not prohibited, resulting in GPU DMA hangs.

3. Workaround method: When configuring the 06.0 device BAR1, turn off
the memory access of DC, GPU and VPU (via DC's CRTC registers).

Cc: stable@vger.kernel.org
Signed-off-by: Qianhai Wu <wuqianhai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/pci/pci.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

--- a/arch/loongarch/pci/pci.c
+++ b/arch/loongarch/pci/pci.c
@@ -6,9 +6,11 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
+#include <linux/delay.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <asm/cacheflush.h>
 #include <asm/loongson.h>
 
@@ -16,6 +18,9 @@
 #define PCI_DEVICE_ID_LOONGSON_DC1      0x7a06
 #define PCI_DEVICE_ID_LOONGSON_DC2      0x7a36
 #define PCI_DEVICE_ID_LOONGSON_DC3      0x7a46
+#define PCI_DEVICE_ID_LOONGSON_GPU1     0x7a15
+#define PCI_DEVICE_ID_LOONGSON_GPU2     0x7a25
+#define PCI_DEVICE_ID_LOONGSON_GPU3     0x7a35
 
 int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val)
@@ -100,3 +105,78 @@ static void pci_fixup_vgadev(struct pci_
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC1, pci_fixup_vgadev);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC2, pci_fixup_vgadev);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC3, pci_fixup_vgadev);
+
+#define CRTC_NUM_MAX		2
+#define CRTC_OUTPUT_ENABLE	0x100
+
+static void loongson_gpu_fixup_dma_hang(struct pci_dev *pdev, bool on)
+{
+	u32 i, val, count, crtc_offset, device;
+	void __iomem *crtc_reg, *base, *regbase;
+	static u32 crtc_status[CRTC_NUM_MAX] = { 0 };
+
+	base = pdev->bus->ops->map_bus(pdev->bus, pdev->devfn + 1, 0);
+	device = readw(base + PCI_DEVICE_ID);
+
+	regbase = ioremap(readq(base + PCI_BASE_ADDRESS_0) & ~0xffull, SZ_64K);
+	if (!regbase) {
+		pci_err(pdev, "Failed to ioremap()\n");
+		return;
+	}
+
+	switch (device) {
+	case PCI_DEVICE_ID_LOONGSON_DC2:
+		crtc_reg = regbase + 0x1240;
+		crtc_offset = 0x10;
+		break;
+	case PCI_DEVICE_ID_LOONGSON_DC3:
+		crtc_reg = regbase;
+		crtc_offset = 0x400;
+		break;
+	}
+
+	for (i = 0; i < CRTC_NUM_MAX; i++, crtc_reg += crtc_offset) {
+		val = readl(crtc_reg);
+
+		if (!on)
+			crtc_status[i] = val;
+
+		/* No need to fixup if the status is off at startup. */
+		if (!(crtc_status[i] & CRTC_OUTPUT_ENABLE))
+			continue;
+
+		if (on)
+			val |= CRTC_OUTPUT_ENABLE;
+		else
+			val &= ~CRTC_OUTPUT_ENABLE;
+
+		mb();
+		writel(val, crtc_reg);
+
+		for (count = 0; count < 40; count++) {
+			val = readl(crtc_reg) & CRTC_OUTPUT_ENABLE;
+			if ((on && val) || (!on && !val))
+				break;
+			udelay(1000);
+		}
+
+		pci_info(pdev, "DMA hang fixup at reg[0x%lx]: 0x%x\n",
+				(unsigned long)crtc_reg & 0xffff, readl(crtc_reg));
+	}
+
+	iounmap(regbase);
+}
+
+static void pci_fixup_dma_hang_early(struct pci_dev *pdev)
+{
+	loongson_gpu_fixup_dma_hang(pdev, false);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_GPU2, pci_fixup_dma_hang_early);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_GPU3, pci_fixup_dma_hang_early);
+
+static void pci_fixup_dma_hang_final(struct pci_dev *pdev)
+{
+	loongson_gpu_fixup_dma_hang(pdev, true);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_GPU2, pci_fixup_dma_hang_final);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_GPU3, pci_fixup_dma_hang_final);


