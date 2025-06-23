Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC7F4315A;
	Mon, 23 Jun 2025 21:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715029; cv=none; b=lZ6EatMwr+LkQuJMWn6WtGiN5nJsKl9IgVdAUXaKofZ8hezAon0KcnlJgq+dlT78vDnFAdcFf8zP3J5aW2jRMAOiE6RqXdKLxUKK0Yql/rysLneiFFQjNm+kbkrQjDAfkMCQEsvLR+maxZiAO9HBTsLySAJpXYQCk6YXzZ99awU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715029; c=relaxed/simple;
	bh=2ifTHBgjENEykLtvJjca10UgWjUAfWm5IreHYF1vGys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrjONKqd0XUC69k6Ji+mols9bnXPpNotywXVWdGWwk8sdNUWhLyZcE/DUfEQB9RQC5m4Z1GEv1UbRw2QTy3Aoei/K5sfCiOVnDjps6iXDEtmbUDq/UDgRhGLrhxBrfscjqoqH+L9i/LJtcTrO3HTl4h86YCyEQTZIaXEd0M41us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QL6VtYnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QL6VtYnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F70C4CEEA;
	Mon, 23 Jun 2025 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715028;
	bh=2ifTHBgjENEykLtvJjca10UgWjUAfWm5IreHYF1vGys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL6VtYnEVvDKJA0Ptn6T6HvPm8htr+UxaI6K7c1+oImpZvUFCZphKltSDvM12z8R0
	 vr0jatl+977ROzmOAwTWA1Kb0i3f4O+PBmXkYx3/4GyyCcxTbPm0zYmz/4p2WHXLUI
	 llkW0OyHXAEdbTM8Mpb+GxRWqPq4+LhnWLWx9SkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 151/414] PCI: dwc: ep: Correct PBA offset in .set_msix() callback
Date: Mon, 23 Jun 2025 15:04:48 +0200
Message-ID: <20250623130645.819398767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 810276362bad172d063d1f6be1cc2cb425b90103 upstream.

While dw_pcie_ep_set_msix() writes the Table Size field correctly (N-1),
the calculation of the PBA offset is wrong because it calculates space for
(N-1) entries instead of N.

This results in the following QEMU error when using PCI passthrough on a
device which relies on the PCI endpoint subsystem:

  failed to add PCI capability 0x11[0x50]@0xb0: table & pba overlap, or they don't fit in BARs, or don't align

Fix the calculation of PBA offset in the MSI-X capability.

[bhelgaas: more specific subject and commit log]

Fixes: 83153d9f36e2 ("PCI: endpoint: Fix ->set_msix() to take BIR and offset as arguments")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250514074313.283156-9-cassel@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -398,6 +398,7 @@ static int dw_pcie_ep_set_msix(struct pc
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 	struct dw_pcie_ep_func *ep_func;
 	u32 val, reg;
+	u16 actual_interrupts = interrupts + 1;
 
 	ep_func = dw_pcie_ep_get_func_from_ep(ep, func_no);
 	if (!ep_func || !ep_func->msix_cap)
@@ -408,7 +409,7 @@ static int dw_pcie_ep_set_msix(struct pc
 	reg = ep_func->msix_cap + PCI_MSIX_FLAGS;
 	val = dw_pcie_ep_readw_dbi(ep, func_no, reg);
 	val &= ~PCI_MSIX_FLAGS_QSIZE;
-	val |= interrupts;
+	val |= interrupts; /* 0's based value */
 	dw_pcie_writew_dbi(pci, reg, val);
 
 	reg = ep_func->msix_cap + PCI_MSIX_TABLE;
@@ -416,7 +417,7 @@ static int dw_pcie_ep_set_msix(struct pc
 	dw_pcie_ep_writel_dbi(ep, func_no, reg, val);
 
 	reg = ep_func->msix_cap + PCI_MSIX_PBA;
-	val = (offset + (interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
+	val = (offset + (actual_interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
 	dw_pcie_ep_writel_dbi(ep, func_no, reg, val);
 
 	dw_pcie_dbi_ro_wr_dis(pci);


