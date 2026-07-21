Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392F83B83E0;
	Tue, 21 Jul 2026 21:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669353; cv=none; b=gB+5L7/7mOeR2K5GgM8TDgSqyGKGsSVdvm/2q34P8CkzP7YtZM9IoUUGhylCw7VN7FROHHU8LStwS8m2wS/qAXdYqgVfwLRWOms0f9NekCewYIOCdbP00uc4kn1b65wTcRPmHU5fNT9eQA34AV3xYD6eA/aSwXCPGKhNQSGiWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669353; c=relaxed/simple;
	bh=7DOVr7jcAJnJzseiT2vUYByzlSOhemxIdHvBKDxA8JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc4ldYsnJJH86muVEXUijFKftRD1VxFQ5eLk3I0vThZd+TmdED71yn3NhN+nF3tMvK+zPtX0deIIJz19UKQlpfWV4bbviYLwKqLuSHhkNOkvO8ccrAfFSBLU5MxzIG5/szjWM7pQW3mwg5N82m6zIKA8LZO2LLzp0LSSQh53ALU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPGEQQs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPGEQQs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792781F00A3D;
	Tue, 21 Jul 2026 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669348;
	bh=3a7T5sBDmDcOI78FxDWcPwQws69QesI2dGtMNLgNaN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPGEQQs1NrfyhjqpfgmFMmiAJerrUQLpqie3sf7Uu34ime2HBxxmz2274cP7EI+aU
	 UJJ1rAFC4nlzhTgvEJ6uRcIZdob7d8qJuznQ7nBtuVgrc6Y5s99ytwX96j6rLIF9OH
	 hKafBvYmjVwsbOHlaDZ+SoCuqIQUz4yss/LatMCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0477/1067] PCI: Check ROM header and data structure addr before accessing
Date: Tue, 21 Jul 2026 17:17:58 +0200
Message-ID: <20260721152435.284054582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 538796b807fcfb81b2ce40cc97a614fd8588feb5 ]

We meet a crash when running stress-ng on x86_64 machine:

  BUG: unable to handle page fault for address: ffa0000007f40000
  RIP: 0010:pci_get_rom_size+0x52/0x220
  Call Trace:
  <TASK>
    pci_map_rom+0x80/0x130
    pci_read_rom+0x4b/0xe0
    kernfs_file_read_iter+0x96/0x180
    vfs_read+0x1b1/0x300

Our analysis reveals that the ROM space's start address is
0xffa0000007f30000, and size is 0x10000. Because of broken ROM space,
before calling readl(pds), the pds's value is 0xffa0000007f3ffff, which is
already pointed to the ROM space end, invoking readl() would read 4 bytes
therefore cause an out-of-bounds access and trigger a crash.  Fix this by
adding image header and data structure checking.

We also found another crash on arm64 machine:

  Unable to handle kernel paging request at virtual address ffff8000dd1393ff
  Mem abort info:
  ESR = 0x0000000096000021
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x21: alignment fault

The call trace is the same with x86_64, but the crash reason is that the
data structure addr is not aligned with 4, and arm64 machine report
"alignment fault". Fix this by adding alignment checking.

Fixes: 47b975d234ea ("PCI: Avoid iterating through memory outside the resource window")
Suggested-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
[bhelgaas: shorten function names, wrap comments]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20260508082128.3344255-3-kanie@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/rom.c | 123 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 105 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index d4a141bd148b4b..f2105c6ceef524 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -6,9 +6,12 @@
  * (C) Copyright 2004 Silicon Graphics, Inc. Jesse Barnes <jbarnes@sgi.com>
  */
 
+#include <linux/align.h>
 #include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/io.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
@@ -27,6 +30,15 @@
 #define PCI_ROM_DATA_STRUCT_SIGNATURE		0x52494350
 #define PCI_ROM_DATA_STRUCT_LEN			0x0A
 
+/*
+ * Per PCI Firmware r3.3, sec 5.1.3, a conformant PCI Data Structure is at
+ * least 24 bytes (0x18), large enough to cover every fixed field this
+ * driver reads (up to the Indicator byte at offset 0x15).  Reject smaller
+ * device-claimed lengths so the follow-up readers in pci_get_rom_size()
+ * cannot escape the mapped ROM window.
+ */
+#define PCI_ROM_DATA_STRUCT_MIN_LEN		0x18
+
 /**
  * pci_enable_rom - enable ROM decoding for a PCI device
  * @pdev: PCI device to enable
@@ -84,6 +96,91 @@ void pci_disable_rom(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pci_disable_rom);
 
+static bool pci_rom_header_valid(struct pci_dev *pdev, void __iomem *image,
+				 void __iomem *rom, size_t size,
+				 bool expect_valid)
+{
+	unsigned long rom_end = (unsigned long)rom + size - 1;
+	unsigned long header_end;
+	u16 signature;
+
+	/*
+	 * Per PCI Firmware r3.3, sec 5.1, each image must start on a
+	 * 512-byte boundary and must contain the PCI Expansion ROM header.
+	 * Because @rom is page-aligned (returned by ioremap()), checking
+	 * 512-byte alignment of @image is equivalent to enforcing the
+	 * spec's sector-aligned layout within the ROM.  This also
+	 * satisfies the natural-alignment requirement of readw() on archs
+	 * such as arm64 that disallow unaligned IOMEM access.
+	 */
+	if (!IS_ALIGNED((unsigned long)image, PCI_ROM_IMAGE_SECTOR_SIZE))
+		return false;
+
+	if (check_add_overflow((unsigned long)image, PCI_ROM_HEADER_SIZE - 1,
+				&header_end))
+		return false;
+
+	if (image < rom || header_end > rom_end)
+		return false;
+
+	/* Standard PCI ROMs start out with these bytes 55 AA */
+	signature = readw(image);
+	if (signature != PCI_ROM_IMAGE_SIGNATURE) {
+		if (expect_valid) {
+			pci_info(pdev, "Invalid PCI ROM header signature: expecting %#06x, got %#06x\n",
+				 PCI_ROM_IMAGE_SIGNATURE, signature);
+		} else {
+			pci_info(pdev, "No more images in PCI ROM\n");
+		}
+		return false;
+	}
+
+	return true;
+}
+
+static bool pci_rom_data_struct_valid(struct pci_dev *pdev, void __iomem *pds,
+				      void __iomem *rom, size_t size)
+{
+	unsigned long rom_end = (unsigned long)rom + size - 1;
+	unsigned long end;
+	u32 signature;
+	u16 data_len;
+
+	/*
+	 * Some CPU architectures require IOMEM access addresses to be
+	 * aligned, for example arm64, so since we're about to call
+	 * readl(), check here for 4-byte alignment.
+	 */
+	if (!IS_ALIGNED((unsigned long)pds, 4))
+		return false;
+
+	if (check_add_overflow((unsigned long)pds, PCI_ROM_DATA_STRUCT_LEN + 1,
+				&end))
+		return false;
+
+	if (pds < rom || end > rom_end)
+		return false;
+
+	signature = readl(pds);
+	if (signature != PCI_ROM_DATA_STRUCT_SIGNATURE) {
+		pci_info(pdev, "Invalid PCI ROM data signature: expecting %#010x, got %#010x\n",
+			 PCI_ROM_DATA_STRUCT_SIGNATURE, signature);
+		return false;
+	}
+
+	data_len = readw(pds + PCI_ROM_DATA_STRUCT_LEN);
+	if (data_len < PCI_ROM_DATA_STRUCT_MIN_LEN || data_len == U16_MAX)
+		return false;
+
+	if (check_add_overflow((unsigned long)pds, data_len - 1, &end))
+		return false;
+
+	if (end > rom_end)
+		return false;
+
+	return true;
+}
+
 /**
  * pci_get_rom_size - obtain the actual size of the ROM image
  * @pdev: target PCI device
@@ -99,38 +196,28 @@ static size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom,
 			       size_t size)
 {
 	void __iomem *image;
-	int last_image;
 	unsigned int length;
+	bool last_image;
 
 	image = rom;
 	do {
 		void __iomem *pds;
-		/* Standard PCI ROMs start out with these bytes 55 AA */
-		if (readw(image) != PCI_ROM_IMAGE_SIGNATURE) {
-			pci_info(pdev, "Invalid PCI ROM header signature: expecting %#06x, got %#06x\n",
-				 PCI_ROM_IMAGE_SIGNATURE, readw(image));
+		if (!pci_rom_header_valid(pdev, image, rom, size, true))
 			break;
-		}
+
 		/* Get the PCI data structure and check its "PCIR" signature */
 		pds = image + readw(image + PCI_ROM_POINTER_TO_DATA_STRUCT);
-		if (readl(pds) != PCI_ROM_DATA_STRUCT_SIGNATURE) {
-			pci_info(pdev, "Invalid PCI ROM data signature: expecting %#010x, got %#010x\n",
-				 PCI_ROM_DATA_STRUCT_SIGNATURE, readl(pds));
+		if (!pci_rom_data_struct_valid(pdev, pds, rom, size))
 			break;
-		}
+
 		last_image = readb(pds + PCI_ROM_LAST_IMAGE_INDICATOR) &
 				   PCI_ROM_LAST_IMAGE_INDICATOR_BIT;
 		length = readw(pds + PCI_ROM_IMAGE_LEN);
 		image += length * PCI_ROM_IMAGE_SECTOR_SIZE;
-		/* Avoid iterating through memory outside the resource window */
-		if (image >= rom + size)
+
+		if (!last_image &&
+		    !pci_rom_header_valid(pdev, image, rom, size, false))
 			break;
-		if (!last_image) {
-			if (readw(image) != PCI_ROM_IMAGE_SIGNATURE) {
-				pci_info(pdev, "No more image in the PCI ROM\n");
-				break;
-			}
-		}
 	} while (length && !last_image);
 
 	/* never return a size larger than the PCI resource window */
-- 
2.53.0



