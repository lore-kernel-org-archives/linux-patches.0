Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BB42566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E554BC433D2;
	Tue, 18 Apr 2023 12:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820828;
	bh=N+4i+yZYMRbWxZzRVTcYVu7G1SPVlXOuYNmOjLBduZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJTts8R1TOmk8H0eLvUpDoTvVr1/Af6EXQzcuChPGEK6QWoMJqxSo2+eJcDibaUSh
	 FlBIs52b598UVrIxsAyTEHe85tQX0P2s/fY3UcQHB67LMFfOqi1jEzdS+9z2Tfg7P1
	 LpSILOnl3D+4w4+9hSLVRTWLNjo2SN7GXZsGePEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Glanzmann <thomas@glanzmann.de>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 4.19 47/57] x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot
Date: Tue, 18 Apr 2023 14:21:47 +0200
Message-Id: <20230418120300.379462419@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit f195fc1e9715ba826c3b62d58038f760f66a4fe9 upstream.

The AMD [1022:15b8] USB controller loses some internal functional MSI-X
context when transitioning from D0 to D3hot. BIOS normally traps D0->D3hot
and D3hot->D0 transitions so it can save and restore that internal context,
but some firmware in the field can't do this because it fails to clear the
AMD_15B8_RCC_DEV2_EPF0_STRAP2 NO_SOFT_RESET bit.

Clear AMD_15B8_RCC_DEV2_EPF0_STRAP2 NO_SOFT_RESET bit before USB controller
initialization during boot.

Link: https://lore.kernel.org/linux-usb/Y%2Fz9GdHjPyF2rNG3@glanzmann.de/T/#u
Link: https://lore.kernel.org/r/20230329172859.699743-1-Basavaraj.Natikar@amd.com
Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Tested-by: Thomas Glanzmann <thomas@glanzmann.de>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/fixup.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -7,6 +7,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/vgaarb.h>
+#include <asm/amd_nb.h>
 #include <asm/hpet.h>
 #include <asm/pci_x86.h>
 
@@ -824,3 +825,23 @@ static void rs690_fix_64bit_dma(struct p
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7910, rs690_fix_64bit_dma);
 
 #endif
+
+#ifdef CONFIG_AMD_NB
+
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2                                  0x10136008
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK       0x00000080L
+
+static void quirk_clear_strap_no_soft_reset_dev2_f0(struct pci_dev *dev)
+{
+	u32 data;
+
+	if (!amd_smn_read(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, &data)) {
+		data &= ~AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK;
+		if (amd_smn_write(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, data))
+			pci_err(dev, "Failed to write data 0x%x\n", data);
+	} else {
+		pci_err(dev, "Failed to read data\n");
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15b8, quirk_clear_strap_no_soft_reset_dev2_f0);
+#endif


