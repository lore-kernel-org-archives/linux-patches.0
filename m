Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230BF2F6932;
	Fri, 17 Oct 2025 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713829; cv=none; b=jdOejBg33mpftZhS1QWBddNEGRy5yJeOdSgyS0MJ4mSxi4ArM3iDfGwrV8lXZqWgMq42/LUYDuAjbuEuH63MmYUf9moiEIbuY1vQDz58QK/a303DHe38pnZMrAA8ZdXrGHBQUdKc0QAXrTNKa/jwSCyNKEKeD3TA5LRlonUffXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713829; c=relaxed/simple;
	bh=GtHAm+yWoFSPTm2tsIvTzll27gCVqLTchPshyS94NXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz9g6BFBYfNjKAk5tLqoJrl57OCFo6zVAQonsa4lgj+ma6NlkqafHLxdgm952+2iRjmH3ewXDBEEJnh+W/W3cuLX13Q4bU98OGsIjUJnodaGUhFaXsTjq9LfyLmWi2mqB18e5RjVCarag8wtlq3qtrg/XZ5UVVk9VEE/evuNMr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAgLwoQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAgLwoQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED1CC4CEE7;
	Fri, 17 Oct 2025 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713829;
	bh=GtHAm+yWoFSPTm2tsIvTzll27gCVqLTchPshyS94NXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAgLwoQmMJtIUMTorv0Rp/uUJPaXYZnp3tNG4D6Jtq10CQI4WpjeCKJr/2OcFG9c4
	 LR95TECg4k+yA9FceocvTOcuxAN/Ma0oe9er/iiuudTfft8XF/Hnl943FOKoiSTxFY
	 TM8izm0owp3r6IuuxMWM3FcEIn17im1GRci0tGoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.6 134/201] PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()
Date: Fri, 17 Oct 2025 16:53:15 +0200
Message-ID: <20251017145139.661185447@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit b640d42a6ac9ba01abe65ec34f7c73aaf6758ab8 upstream.

The pci_epc_raise_irq() supplies a MSI or MSI-X interrupt number in range
(1-N), as per the pci_epc_raise_irq() kdoc, where N is 32 for MSI.

But tegra_pcie_ep_raise_msi_irq() incorrectly uses the interrupt number as
the MSI vector. This causes wrong MSI vector to be triggered, leading to
the failure of PCI endpoint Kselftest MSI_TEST test case.

To fix this issue, convert the interrupt number to MSI vector.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250922140822.519796-6-cassel@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1963,10 +1963,10 @@ static int tegra_pcie_ep_raise_legacy_ir
 
 static int tegra_pcie_ep_raise_msi_irq(struct tegra_pcie_dw *pcie, u16 irq)
 {
-	if (unlikely(irq > 31))
+	if (unlikely(irq > 32))
 		return -EINVAL;
 
-	appl_writel(pcie, BIT(irq), APPL_MSI_CTRL_1);
+	appl_writel(pcie, BIT(irq - 1), APPL_MSI_CTRL_1);
 
 	return 0;
 }


