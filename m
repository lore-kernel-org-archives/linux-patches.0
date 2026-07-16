Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1569423775;
	Thu, 16 Jul 2026 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209286; cv=none; b=JP0QUP0FF5XFoulCbUrFSDRkcFPCYX9hyr91uHNxz28mha36CHxr7QjsZTSuvScz/KsHCnJRy4MDYXWybBhUfUMZUYm9Ul4Klzn9WKzhYXrNjrHswxrHipD4V0l6tWmFNomXIahOaGCekBHw3MPjcXZjUJu7qapbxplBgEj7Z54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209286; c=relaxed/simple;
	bh=t77sGluvXpG+Wkj/OIah5ByYgJx4VUmHI8wINSFJZug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkDhNJfnZORTec9jEnToHsS2boPLw8s/ffQWm59oj403RpQk4LclPv/P8FzU0O29fviGVOG4A4NoCzmsMfQG4RX5cd7l+Glc6y+SezjUENj9YH8w7Hr2fKA+tOxEY05WEGuALlsYPeb5sQiZpEddp02j+doHD6ifymDzShYRjBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQa/gCR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQa/gCR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316FA1F00A3A;
	Thu, 16 Jul 2026 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209284;
	bh=/tpw+RZ2LeICIr+lMG28qzP6AVvXDdNNRFfZzKmwdpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQa/gCR6jWfLFueLDopDTxxW6Ac4mfM6ZZhYqgm3GOKnpY+YrjU0xDLD0qCLUlP9N
	 WNtC2q+SvFcGw9oXPduVuwXCsaldTWPb2av9M+qPgqnNDQc4LWXxazzc7xkegqwgmR
	 9A7be4YNFc8zbd6rhtEeGuF4VoDf6gjSc0+ZeRrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayden Meng <aydenmeng@yeah.net>,
	Mingcong Bai <jeffbai@aosc.io>,
	Ziyao Li <liziyao@uniontech.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lain Fearyncess Yang <fsf@live.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 128/518] PCI: loongson: Override PCIe bridge supported speeds for Loongson-3C6000 series
Date: Thu, 16 Jul 2026 15:26:36 +0200
Message-ID: <20260716133050.658633404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Ziyao Li <liziyao@uniontech.com>

commit e373c789bac0ad73b472d8b44714df3bd18a4edf upstream.

Older steppings of the Loongson-3C6000 series incorrectly report the
supported link speeds on their PCIe bridges (device IDs 0x3c19, 0x3c29)
as only 2.5 GT/s, despite the upstream bus supporting speeds from
2.5 GT/s up to 16 GT/s.

As a result, since commit 774c71c52aa4 ("PCI/bwctrl: Enable only if more
than one speed is supported"), bwctrl will be disabled if there's only
one 2.5 GT/s value in vector 'supported_speeds'.

Manually override the 'supported_speeds' field for affected PCIe bridges
with those found on the upstream bus to correctly reflect the supported
link speeds.  Updating the speeds to reflect what the hardware actually
supports avoids quirks in drivers consuming the speed information.

This commit was originally found from AOSC OS[1].

Fixes: cd89edda4002 ("PCI: loongson: Add ACPI init support")
Signed-off-by: Ayden Meng <aydenmeng@yeah.net>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
[Ziyao Li: move from drivers/pci/quirks.c to drivers/pci/controller/pci-loongson.c]
Signed-off-by: Ziyao Li <liziyao@uniontech.com>
[Xi Ruoyao: Fixed falling through logic, added debug log, Fixes tag and rebased to 7.0-rc7]
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log, https://lore.kernel.org/all/9d815df3b33a63223112b97440c01247935363c1.camel@xry111.site]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Lain Fearyncess Yang <fsf@live.com>
Tested-by: Ayden Meng <aydenmeng@yeah.net>
Tested-by: Mingcong Bai <jeffbai@aosc.io>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: stable@vger.kernel.org
Link: https://github.com/AOSC-Tracking/linux/commit/4392f441363abdf6fa0a0433d73175a17f493454
Link: https://github.com/AOSC-Tracking/linux/pull/2 #1
Link: https://patch.msgid.link/20260412101731.107059-1-xry111@xry111.site
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-loongson.c |   36 ++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -176,6 +176,42 @@ static void loongson_pci_msi_quirk(struc
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, DEV_LS7A_PCIE_PORT5, loongson_pci_msi_quirk);
 
+/*
+ * Older steppings of the Loongson-3C6000 series incorrectly report the
+ * supported link speeds on their PCIe bridges (device IDs 0x3c19,
+ * 0x3c29) as only 2.5 GT/s, despite the upstream bus supporting speeds
+ * from 2.5 GT/s up to 16 GT/s.
+ */
+static void loongson_pci_bridge_speed_quirk(struct pci_dev *pdev)
+{
+	u8 old_supported_speeds = pdev->supported_speeds;
+
+	switch (pdev->bus->max_bus_speed) {
+	case PCIE_SPEED_16_0GT:
+		pdev->supported_speeds |= PCI_EXP_LNKCAP2_SLS_16_0GB;
+		fallthrough;
+	case PCIE_SPEED_8_0GT:
+		pdev->supported_speeds |= PCI_EXP_LNKCAP2_SLS_8_0GB;
+		fallthrough;
+	case PCIE_SPEED_5_0GT:
+		pdev->supported_speeds |= PCI_EXP_LNKCAP2_SLS_5_0GB;
+		fallthrough;
+	case PCIE_SPEED_2_5GT:
+		pdev->supported_speeds |= PCI_EXP_LNKCAP2_SLS_2_5GB;
+		break;
+	default:
+		pci_warn(pdev, "unexpected max bus speed");
+
+		return;
+	}
+
+	if (pdev->supported_speeds != old_supported_speeds)
+		pci_info(pdev, "fixed up supported link speeds: 0x%x => 0x%x",
+			 old_supported_speeds, pdev->supported_speeds);
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_LOONGSON, 0x3c19, loongson_pci_bridge_speed_quirk);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_LOONGSON, 0x3c29, loongson_pci_bridge_speed_quirk);
+
 static struct loongson_pci *pci_bus_to_loongson_pci(struct pci_bus *bus)
 {
 	struct pci_config_window *cfg;


