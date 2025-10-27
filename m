Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F36320CCE;
	Mon, 27 Oct 2025 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591346; cv=none; b=ruzHMlVOAhGRKf8GipVs4Xv8ERw4QPW3AUdbzrgs9zP6l/2qQLncve1zCmYgBIFhrYzpxwkBgwdRK5S5hFNN9rWqGtCKZm4tTTT3HkGZ4zcYoSzDVC7HK/Brpr4f8OscNJ6bWj0C1TzyzRDCnHrACmkVPSyNvpoIye25WhXZ+jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591346; c=relaxed/simple;
	bh=eRdlfMcKrw/lOic62Cc+pRSuOXI18B9PK2VtP+uCrYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuuGwmFmRFfhvRUwkDa6VyHeRaPtPccspqxhnsJpNRhLhZXTCSq67u7/uTFNR4Xw37fN1+b98qfdlssfF7yA8jWw3bjbal0hpckN6N+yXPJ+2QHWuUMnzDfcTm5WjhEyvSR4IO0CthRVSWjih/Oj526XZNCZn5OrZP6E+hHv6o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzoSbnl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzoSbnl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7620CC4CEF1;
	Mon, 27 Oct 2025 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591345;
	bh=eRdlfMcKrw/lOic62Cc+pRSuOXI18B9PK2VtP+uCrYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzoSbnl1gwNZq2jMTMKyvFqt+XM2i7R8xNWn2UleyGlRGH6FDdikoD+i/kzJPJASi
	 SGE5pJ0mwZkPAZ40vNqISvicR4JDB14AM/cLI1NmJfUE7pyrs4zthqcQyazZaNNQVZ
	 XqLfCkdGim8BEkYTxo9+O16XKTO7xEgBOO/8csdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 5.10 162/332] PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()
Date: Mon, 27 Oct 2025 19:33:35 +0100
Message-ID: <20251027183528.905114048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1844,10 +1844,10 @@ static int tegra_pcie_ep_raise_legacy_ir
 
 static int tegra_pcie_ep_raise_msi_irq(struct tegra_pcie_dw *pcie, u16 irq)
 {
-	if (unlikely(irq > 31))
+	if (unlikely(irq > 32))
 		return -EINVAL;
 
-	appl_writel(pcie, BIT(irq), APPL_MSI_CTRL_1);
+	appl_writel(pcie, BIT(irq - 1), APPL_MSI_CTRL_1);
 
 	return 0;
 }


