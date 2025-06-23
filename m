Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B254254873;
	Mon, 23 Jun 2025 13:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684844; cv=none; b=LwAPBdmLsox3WgodkW5eIrOshJ7BFd8W8/g044Oes8qhAaN+MKjUTf1FrjHmTRJ/TZozUynGdEZwFN6pqZ19NZt0dv+/BPLz8eYQul+HGBLW7TE4FAFfAX+/k9ENms/hVpEhLnVqBapj9snKX4GUkok/X8v4xwAUawrs7K4tNfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684844; c=relaxed/simple;
	bh=vLWFBitYx2i9Q5j3BiOAAScSADfrEQm+jRTSwUQalMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtiTPOMkgv2bzHd27Xg4skAUV0hBs20g5HjFKmcZ/j81nRa9TN66DRarpLejpr3hKJyeIH4oBiYNxMnMYD3KXA9hmgFseFUE6tJGxTElmzLE4s0qxBjtI0m2/NpC9Le3aCLBT3X2nL8/6vkPBjboi82WP/5pRTDvXfEHC7X6jfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vO7UwcmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vO7UwcmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD57C4CEEA;
	Mon, 23 Jun 2025 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684843;
	bh=vLWFBitYx2i9Q5j3BiOAAScSADfrEQm+jRTSwUQalMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vO7UwcmHb4Uoux77s7tyzc3Xgew/xpDEUVYyG3MQJpneLMDC1C+Hn0w7KBa+zacx7
	 18kq7dlgEF/nt+q/2Rxiy8kpE+IrdS5hrqb4ryBuIX2x9/iRNOrGRwG598rtp+BUEc
	 awPUwIGE1OSZjTTv3ilB/x/GVr76URgHmZ6OLBxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.15 182/592] PCI: Add ACS quirk for Loongson PCIe
Date: Mon, 23 Jun 2025 15:02:20 +0200
Message-ID: <20250623130704.610511584@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 1f3303aa92e15fa273779acac2d0023609de30f1 upstream.

Loongson PCIe Root Ports don't advertise an ACS capability, but they do not
allow peer-to-peer transactions between Root Ports. Add an ACS quirk so
each Root Port can be in a separate IOMMU group.

Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250403040756.720409-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4995,6 +4995,18 @@ static int pci_quirk_brcm_acs(struct pci
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+static int pci_quirk_loongson_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	/*
+	 * Loongson PCIe Root Ports don't advertise an ACS capability, but
+	 * they do not allow peer-to-peer transactions between Root Ports.
+	 * Allow each Root Port to be in a separate IOMMU group by masking
+	 * SV/RR/CR/UF bits.
+	 */
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+}
+
 /*
  * Wangxun 40G/25G/10G/1G NICs have no ACS capability, but on
  * multi-function devices, the hardware isolates the functions by
@@ -5128,6 +5140,17 @@ static const struct pci_dev_acs_enabled
 	{ PCI_VENDOR_ID_BROADCOM, 0x1762, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0x1763, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
+	/* Loongson PCIe Root Ports */
+	{ PCI_VENDOR_ID_LOONGSON, 0x3C09, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x3C19, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x3C29, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x7A09, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x7A19, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x7A29, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x7A39, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x7A49, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x7A59, pci_quirk_loongson_acs },
+	{ PCI_VENDOR_ID_LOONGSON, 0x7A69, pci_quirk_loongson_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
 	/* Zhaoxin multi-function devices */


