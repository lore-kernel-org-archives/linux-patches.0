Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982293370FF;
	Fri, 17 Oct 2025 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713300; cv=none; b=g9UZFIOe4kqDtbR5lp3BRUIDXSTkoEHDi7/7eqxzJ/p1pu/6PI/IwR9uSLY3goeKc7V2SZXhro1rSxgI8oRPr18nFrsQUAHja2Drq/sWfY59b+/iey3zVEEDdsYCdEZJsg7zDlms3eqqzPt1npFJm2R+xSmMDyWdPygQNzl11Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713300; c=relaxed/simple;
	bh=EslSBIqLlzGKT+xeGGneK0+RPOmJvOoj6YHPa8MFRt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja6nWI6/FeOYucrgSwIwQpPCPo7MWSg+4H8FK7uaSVMQJXLvT2T76u90+kOhlnoPCcSMxGsVSTD3vIvzmuxZNz0saDSX35HvbHLLOlpfJcrI7TY6hgXYGjezdI2l6rfpuluEd1VgDmBzDoH5VX2d9B8z84dJfA0yQW6rdfPvtVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OT79YolG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT79YolG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6CBC4CEE7;
	Fri, 17 Oct 2025 15:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713300;
	bh=EslSBIqLlzGKT+xeGGneK0+RPOmJvOoj6YHPa8MFRt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT79YolGkM3G5FYuoA2AD6u7xJZT5fS4IA4s2C9TCIvKDXDTl9JBFV+tJcYv3sbpJ
	 mSdb/4vTyHtb2PpJDtx6F6NSJTCKmd5YTFgF1rnr/MDMT1yspwQNrVB6Tcnig06t26
	 pcAw7dQO0F0ICO3WcoNWpKLQFeJHKmpif3PyPenk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.1 117/168] PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()
Date: Fri, 17 Oct 2025 16:53:16 +0200
Message-ID: <20251017145133.334964269@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1949,10 +1949,10 @@ static int tegra_pcie_ep_raise_legacy_ir
 
 static int tegra_pcie_ep_raise_msi_irq(struct tegra_pcie_dw *pcie, u16 irq)
 {
-	if (unlikely(irq > 31))
+	if (unlikely(irq > 32))
 		return -EINVAL;
 
-	appl_writel(pcie, BIT(irq), APPL_MSI_CTRL_1);
+	appl_writel(pcie, BIT(irq - 1), APPL_MSI_CTRL_1);
 
 	return 0;
 }


