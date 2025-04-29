Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5F245007;
	Tue, 29 Apr 2025 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947338; cv=none; b=LD88wcOGBZpNu3LPAxvoFPGR99N9gpnbY6rzae/sKkH+5HDDi581nIPTknfN/pIfgc/JH6QTDomfGDx+wtPVdXsABVXm9CJLq32hazdT/eeGSg7qJOqMfnx5oACQuaQBbu/NrE5uu0sa55tmX9DYGdbHD/sau+1vNySCfvMbWBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947338; c=relaxed/simple;
	bh=KE3js3AIHj8QeuqLux10Sex/EPhZy/nwgW88blMNauU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxuk4s+c/YyZxjjrfCpYRdLo2WPMXm+XNzj/PBhaCRn67QopksGJk9pnAVS8VOWP3FkSUiPzidnbVwVYQdXKzzCGoBE4uW62fPlhOFaAyAPB2bVcDJ95C9wfvDjrDqwMkRlPqK7mA+7H6+pNjTdw+Qw9KIoyBCa/TmoWayfh+Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNNGdrGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNNGdrGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FF7C4CEE9;
	Tue, 29 Apr 2025 17:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947338;
	bh=KE3js3AIHj8QeuqLux10Sex/EPhZy/nwgW88blMNauU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNNGdrGu538GOjflibM6HiCdyj7CSBCdjpMv66sQjoZj/3Yr9bxw7JJY8yQCXzvPi
	 N5AfFWiOD+U7DlNQDHrHMBANvZwTRowPRV6ATxXVTAzjpTJEU90+aoxS7ZC2YTEGFW
	 Dd011MYnOYqA3aUn98bwkjJo+wVwilnNIfNJR22Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mingcong Bai <baimingcong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 5.10 248/286] USB: OHCI: Add quirk for LS7A OHCI controller (rev 0x02)
Date: Tue, 29 Apr 2025 18:42:32 +0200
Message-ID: <20250429161118.129506098@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit bcb60d438547355b8f9ad48645909139b64d3482 upstream.

The OHCI controller (rev 0x02) under LS7A PCI host has a hardware flaw.
MMIO register with offset 0x60/0x64 is treated as legacy PS2-compatible
keyboard/mouse interface, which confuse the OHCI controller. Since OHCI
only use a 4KB BAR resource indeed, the LS7A OHCI controller's 32KB BAR
is wrapped around (the second 4KB BAR space is the same as the first 4KB
internally). So we can add an 4KB offset (0x1000) to the OHCI registers
(from the PCI BAR resource) as a quirk.

Cc: stable <stable@kernel.org>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Mingcong Bai <baimingcong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20250328040059.3672979-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-pci.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -165,6 +165,25 @@ static int ohci_quirk_amd700(struct usb_
 	return 0;
 }
 
+static int ohci_quirk_loongson(struct usb_hcd *hcd)
+{
+	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
+
+	/*
+	 * Loongson's LS7A OHCI controller (rev 0x02) has a
+	 * flaw. MMIO register with offset 0x60/64 is treated
+	 * as legacy PS2-compatible keyboard/mouse interface.
+	 * Since OHCI only use 4KB BAR resource, LS7A OHCI's
+	 * 32KB BAR is wrapped around (the 2nd 4KB BAR space
+	 * is the same as the 1st 4KB internally). So add 4KB
+	 * offset (0x1000) to the OHCI registers as a quirk.
+	 */
+	if (pdev->revision == 0x2)
+		hcd->regs += SZ_4K;	/* SZ_4K = 0x1000 */
+
+	return 0;
+}
+
 static int ohci_quirk_qemu(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
@@ -225,6 +244,10 @@ static const struct pci_device_id ohci_p
 		.driver_data = (unsigned long)ohci_quirk_amd700,
 	},
 	{
+		PCI_DEVICE(PCI_VENDOR_ID_LOONGSON, 0x7a24),
+		.driver_data = (unsigned long)ohci_quirk_loongson,
+	},
+	{
 		.vendor		= PCI_VENDOR_ID_APPLE,
 		.device		= 0x003f,
 		.subvendor	= PCI_SUBVENDOR_ID_REDHAT_QUMRANET,


