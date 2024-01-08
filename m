Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3232853E02;
	Mon,  8 Jan 2024 15:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1tLPB0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE7BC433C8;
	Mon,  8 Jan 2024 15:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728610;
	bh=70afRcKj5OcUToJ7mO3vdR2day+BBBaxGaF58Wi30eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1tLPB0gRzAxCqjwgC+VLtFtrRsvKCp2MJycAq21u1KD90DRRdlfj6n//DBgfYOdC
	 N/6bnG19bhTxscT2bamCbGVn/TT9MZf/TlvmE2X5/YrXh+xijBwHnL3Nn/E5jovhyg
	 DgwHZP3QXb0FB4rgEzi6Zeu3+AiYKBpqPqRas6oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tobias Gruetzmacher <tobias-lists@23.gs>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.1 132/150] firewire: ohci: suppress unexpected system reboot in AMD Ryzen machines and ASM108x/VT630x PCIe cards
Date: Mon,  8 Jan 2024 16:36:23 +0100
Message-ID: <20240108153517.272859806@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit ac9184fbb8478dab4a0724b279f94956b69be827 upstream.

VIA VT6306/6307/6308 provides PCI interface compliant to 1394 OHCI. When
the hardware is combined with Asmedia ASM1083/1085 PCIe-to-PCI bus bridge,
it appears that accesses to its 'Isochronous Cycle Timer' register (offset
0xf0 on PCI memory space) often causes unexpected system reboot in any
type of AMD Ryzen machine (both 0x17 and 0x19 families). It does not
appears in the other type of machine (AMD pre-Ryzen machine, Intel
machine, at least), or in the other OHCI 1394 hardware (e.g. Texas
Instruments).

The issue explicitly appears at a commit dcadfd7f7c74 ("firewire: core:
use union for callback of transaction completion") added to v6.5 kernel.
It changed 1394 OHCI driver to access to the register every time to
dispatch local asynchronous transaction. However, the issue exists in
older version of kernel as long as it runs in AMD Ryzen machine, since
the access to the register is required to maintain bus time. It is not
hard to imagine that users experience the unexpected system reboot when
generating bus reset by plugging any devices in, or reading the register
by time-aware application programs; e.g. audio sample processing.

This commit suppresses the unexpected system reboot in the combination of
hardware. It avoids the access itself. As a result, the software stack can
not provide the hardware time anymore to unit drivers, userspace
applications, and nodes in the same IEEE 1394 bus. It brings apparent
disadvantage since time-aware application programs require it, while
time-unaware applications are available again; e.g. sbp2.

Cc: stable@vger.kernel.org
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1215436
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217994
Reported-by: Tobias Gruetzmacher <tobias-lists@23.gs>
Closes: https://sourceforge.net/p/linux1394/mailman/message/58711901/
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2240973
Closes: https://bugs.launchpad.net/linux/+bug/2043905
Link: https://lore.kernel.org/r/20240102110150.244475-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/ohci.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -279,6 +279,51 @@ static char ohci_driver_name[] = KBUILD_
 #define QUIRK_TI_SLLZ059		0x20
 #define QUIRK_IR_WAKE			0x40
 
+// On PCI Express Root Complex in any type of AMD Ryzen machine, VIA VT6306/6307/6308 with Asmedia
+// ASM1083/1085 brings an inconvenience that the read accesses to 'Isochronous Cycle Timer' register
+// (at offset 0xf0 in PCI I/O space) often causes unexpected system reboot. The mechanism is not
+// clear, since the read access to the other registers is enough safe; e.g. 'Node ID' register,
+// while it is probable due to detection of any type of PCIe error.
+#define QUIRK_REBOOT_BY_CYCLE_TIMER_READ	0x80000000
+
+#if IS_ENABLED(CONFIG_X86)
+
+static bool has_reboot_by_cycle_timer_read_quirk(const struct fw_ohci *ohci)
+{
+	return !!(ohci->quirks & QUIRK_REBOOT_BY_CYCLE_TIMER_READ);
+}
+
+#define PCI_DEVICE_ID_ASMEDIA_ASM108X	0x1080
+
+static bool detect_vt630x_with_asm1083_on_amd_ryzen_machine(const struct pci_dev *pdev)
+{
+	const struct pci_dev *pcie_to_pci_bridge;
+
+	// Detect any type of AMD Ryzen machine.
+	if (!static_cpu_has(X86_FEATURE_ZEN))
+		return false;
+
+	// Detect VIA VT6306/6307/6308.
+	if (pdev->vendor != PCI_VENDOR_ID_VIA)
+		return false;
+	if (pdev->device != PCI_DEVICE_ID_VIA_VT630X)
+		return false;
+
+	// Detect Asmedia ASM1083/1085.
+	pcie_to_pci_bridge = pdev->bus->self;
+	if (pcie_to_pci_bridge->vendor != PCI_VENDOR_ID_ASMEDIA)
+		return false;
+	if (pcie_to_pci_bridge->device != PCI_DEVICE_ID_ASMEDIA_ASM108X)
+		return false;
+
+	return true;
+}
+
+#else
+#define has_reboot_by_cycle_timer_read_quirk(ohci) false
+#define detect_vt630x_with_asm1083_on_amd_ryzen_machine(pdev)	false
+#endif
+
 /* In case of multiple matches in ohci_quirks[], only the first one is used. */
 static const struct {
 	unsigned short vendor, device, revision, flags;
@@ -1713,6 +1758,9 @@ static u32 get_cycle_time(struct fw_ohci
 	s32 diff01, diff12;
 	int i;
 
+	if (has_reboot_by_cycle_timer_read_quirk(ohci))
+		return 0;
+
 	c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 
 	if (ohci->quirks & QUIRK_CYCLE_TIMER) {
@@ -3615,6 +3663,9 @@ static int pci_probe(struct pci_dev *dev
 	if (param_quirks)
 		ohci->quirks = param_quirks;
 
+	if (detect_vt630x_with_asm1083_on_amd_ryzen_machine(dev))
+		ohci->quirks |= QUIRK_REBOOT_BY_CYCLE_TIMER_READ;
+
 	/*
 	 * Because dma_alloc_coherent() allocates at least one page,
 	 * we save space by using a common buffer for the AR request/


