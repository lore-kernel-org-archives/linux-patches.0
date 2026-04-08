Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121C347503;
	Wed,  8 Apr 2026 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671894; cv=none; b=GzsIUQeO1hZh9HCUAopY0VbRNC2FggaZrQ/MrBzb6nvnrRVH+iNW7+DGi2dWvmqA56K/QLPPmqaTQWXcb4GrXBNPXRUuqjKyuUZBwBYwSPHdMh7XtsjUfiTWtmzaDfFnPkCPMWrjeTFeIkBwJrbbcDcs8MBTs0uqmiYqNN1pBOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671894; c=relaxed/simple;
	bh=xbxF11FvUogAO/N0hxb6ws70HCb3za140qdYxklfVio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myYaN5xDjbBPDMnytF+Jx8aQlDTQXKcKgBGJM1pqanLL2PtU6eXSyjtYSdDkhg9V52mAYxmVmrmcbZzbbzDs632yB5/xJgDBvnWxf786TIMJOM1866D3fLzutjqD2/E6J6A0pFgM4PfoPTcBrgaRPTTZU5UsK+oRgkVJAkH1xaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ji9hyBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ji9hyBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65890C19421;
	Wed,  8 Apr 2026 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671894;
	bh=xbxF11FvUogAO/N0hxb6ws70HCb3za140qdYxklfVio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ji9hyBgeu9tI3a2uSY+IbooKKfDJoNkJM1zoZ4Dqr9iWyHSQf9ZmT+5NRChD2Jz5
	 P80JdhcQPx4y8YiJXhtsbQ6CybQ0Nmf6QpUaWJFVAdP/o7lu58unn1RdQBVN5DD36/
	 XMnE2NuEhUCFlGuUQH6ImACDvNE3LoiICJqermbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 109/312] LoongArch: Workaround LS2K/LS7A GPU DMA hang bug
Date: Wed,  8 Apr 2026 20:00:26 +0200
Message-ID: <20260408175937.834059847@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


