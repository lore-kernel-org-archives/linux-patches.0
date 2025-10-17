Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA630330B35;
	Fri, 17 Oct 2025 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716501; cv=none; b=lgH8pgoNHVur68qa0cjnHBrtglJZFSnypXj3dPXpHxbxvZTZW7Wh07cSUb5sGC/dHa0EPWrTjX72IkquMVxIIW0wgWuVpx6v209MhE4nXpWU5B/Zeyx1z+A+ath558V9oe935tBGSJ8ou8MQEFvRDc23z21KexTfIZUfTJjkuMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716501; c=relaxed/simple;
	bh=Kk2su6eOPOc5zW7fGpxymRAAgI6rVJOnja2uu82+DAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3nCDAzLGmdMVFURNOChIr8iqtihq7P18j+/PghgvR+elo0/y/t+hqFDXn+Zsfc9U5mUUAnHz5s33ze+xP5eIVKAeS/J7Qn7ULNYeGMwo5EWpMlRWYzrkPqUviPHKw1AZkXA4ArwI4EEdBil3dyOMcssopatCdDwkx58oYnwDkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eODKn5SZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eODKn5SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3751C4CEFE;
	Fri, 17 Oct 2025 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716501;
	bh=Kk2su6eOPOc5zW7fGpxymRAAgI6rVJOnja2uu82+DAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eODKn5SZAHh0drSoaGMW0zTDhV2znwck1K9/Lc8ivoZrMJ5nodKzadlExF7JQ4iV0
	 s5RXpexM+4dY+f4qQ7O5in5QYPa8DWiMVez/jrtsKxRnfMmQsStkizzsq9PLa/PY2Z
	 654Psdr5edn5SMLLfZaK4RsGBBb062MCjuzG0JII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 5.15 211/276] PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()
Date: Fri, 17 Oct 2025 16:55:04 +0200
Message-ID: <20251017145150.167269028@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1839,10 +1839,10 @@ static int tegra_pcie_ep_raise_legacy_ir
 
 static int tegra_pcie_ep_raise_msi_irq(struct tegra_pcie_dw *pcie, u16 irq)
 {
-	if (unlikely(irq > 31))
+	if (unlikely(irq > 32))
 		return -EINVAL;
 
-	appl_writel(pcie, BIT(irq), APPL_MSI_CTRL_1);
+	appl_writel(pcie, BIT(irq - 1), APPL_MSI_CTRL_1);
 
 	return 0;
 }


