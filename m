Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8FA3321C5;
	Fri, 17 Oct 2025 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715646; cv=none; b=EdOh++ZqoH6ssGJc7ZVXsGf9+Es8zRzcgY6fBPYwB9YZaj3UCe1gku72+Ta13khNRNycMJNnb4FDpVGTEfwz8w4M6qZJDg4mdfMICq11yz0tRc7ulP1q7IoIBgsjzz5bv8Rh12ukd60j4J1riTjvdHO+PvzqVPBFJldZJg+ujcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715646; c=relaxed/simple;
	bh=nfISmVc063pBvm9eoShwBRDyLVu00CbxGlTiUlzaRJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOnKJ4v2hvDxgJCBcy5mHthitIF64JSROZQVpDQzgicFTTAPR7hW84SHRqr1lnhzupsfHBc2fU8SITl/yC4TxGd8QwkWvYKyMfvsy7nvp1SRDIO14OeBMx94do5ySR491eK3iBf9dCqLk+A66NT6LXJjGxQE3M61Mm7FKdRwU7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+z4vlHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+z4vlHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2EFC4CEE7;
	Fri, 17 Oct 2025 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715645;
	bh=nfISmVc063pBvm9eoShwBRDyLVu00CbxGlTiUlzaRJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+z4vlHDhqP+SBJxjL0S82HyT0vErzb7Dtb+DQ0fcTGtv8hYtrr+o1wJQmhTJliyd
	 olss8wc3PkMs0E0mrMcWq7bZTY+4E4C/t4qMO3Hwu5F71UjHmS+EYlJseBDz8j8Lf/
	 ZkXhfEZaDEL2OEQdy3F0ZG9LUCJRJCzCWjEC8snY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.17 288/371] PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()
Date: Fri, 17 Oct 2025 16:54:23 +0200
Message-ID: <20251017145212.492875421@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1955,10 +1955,10 @@ static int tegra_pcie_ep_raise_intx_irq(
 
 static int tegra_pcie_ep_raise_msi_irq(struct tegra_pcie_dw *pcie, u16 irq)
 {
-	if (unlikely(irq > 31))
+	if (unlikely(irq > 32))
 		return -EINVAL;
 
-	appl_writel(pcie, BIT(irq), APPL_MSI_CTRL_1);
+	appl_writel(pcie, BIT(irq - 1), APPL_MSI_CTRL_1);
 
 	return 0;
 }


