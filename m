Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2FD1F4628;
	Mon, 23 Jun 2025 21:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714033; cv=none; b=BorZ9J0eWuh8j3xj2V0IChG8PBeHGe9yYdD03IeBvpBQ/zNNI1c8bJLKBt379htHU6akMNILGJFQoYNkFG9o3m+C1ZXKfiMTdteK47IXEJn0Z0pf5ALpQdIx8GA9ZupqaYZbZyJQBlnzbrjxcG4Ug0EOC0NOufQCTqOZR2AVISk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714033; c=relaxed/simple;
	bh=qol30QfYAgNZ2AtU8L6o0gTL9m1JNnGrtsWQnkaFhic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rupInPZyj8azSLn/jTdPef0yVg3zpfxzyaFxsLIa/mkhWCmEdhLMaTh/iGN51NttebVwJgKrlOdfq/HsTi0SUFlHtyNMF2vfmcSc+Zr4rGSkSaWRw83MrdRLbPRgtDG3ADKogj19chLiN2OsdSRrIuCHRlqnox1mXwgz6FCngIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBDxEnkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBDxEnkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00C4C4CEEA;
	Mon, 23 Jun 2025 21:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714032;
	bh=qol30QfYAgNZ2AtU8L6o0gTL9m1JNnGrtsWQnkaFhic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBDxEnkdFgEdBGO69Chcl25sDugXDedilw0526Ztl36YSyB3AQl+dkWEPSBTXFBUA
	 hx4NG9SNLQU/4kTL9qo2AvFLstLVIwKDRfV36ie3MbeMhtgRl/bUeDcWRFIfNgGJ/K
	 LCjNhrUOgZxKYAHbRcIUt75x+tSNcvb/XWUW5rVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 109/290] PCI: Add ACS quirk for Loongson PCIe
Date: Mon, 23 Jun 2025 15:06:10 +0200
Message-ID: <20250623130630.232894131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4988,6 +4988,18 @@ static int pci_quirk_brcm_acs(struct pci
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
@@ -5121,6 +5133,17 @@ static const struct pci_dev_acs_enabled
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


