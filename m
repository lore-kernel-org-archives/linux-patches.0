Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB11E34AB12;
	Fri, 21 Nov 2025 13:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732742; cv=none; b=Zt1KCL/ZmlgoGZFQFJAP/+V3DCwU6FnpMs5fmPIpabVkJ233qfJqaQUtHzMHFRj9EOdgVHuHMnGUowBplfGDT5SS/EDfsu980m7giJvXvlRJxDwh3je+9p5P9JYPPb37TRmKwueTrJvtvNcMHHf8pOfy94MiQ5/Ibll5r6fw5JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732742; c=relaxed/simple;
	bh=TMfkTFAD24o8iX8ILLIt99/Y/FSF1BHSf+rO6aqdta8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIr8T6lgUYZCKyXdMczNpMrIfTiwfU4esxzUfTp6XNE1un93/g7H262OI5w1ItCYfw9gw7Kp1BZ6ShAuVZeFjTb3H0MUyVQwo7XPw4Q5fLH/NsjtuJzDaPsRJ7T/I+NoVzORUmYGscY5zYCxUVvjQD02crf4kNFZQILNvvtBK8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFTY40Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFTY40Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D03C4CEF1;
	Fri, 21 Nov 2025 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732742;
	bh=TMfkTFAD24o8iX8ILLIt99/Y/FSF1BHSf+rO6aqdta8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFTY40UvqiCEH4XpsxHP7+v18/xlAHf44fvBvHsFvVF6/h2dy4YKA0BDiV+39YC+n
	 fllIwfyxqxY+tkQFBEigHdE1840/+XcBoxfkTXQrS5knWOrgOJI6Cqw3P+JVRiq4/s
	 mxppdwuo7LcvEqu29WfbW1e4/H+RgczT8jlfp3ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/529] PCI: dwc: Verify the single eDMA IRQ in dw_pcie_edma_irq_verify()
Date: Fri, 21 Nov 2025 14:08:46 +0100
Message-ID: <20251121130239.095943381@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

[ Upstream commit 09fefb24ed5e15f3b112f6c04b21a90ea23eaf8b ]

dw_pcie_edma_irq_verify() is supposed to verify the eDMA IRQs in devicetree
by fetching them using either 'dma' or 'dmaX' IRQ names. Former is used
when the platform uses a single IRQ for all eDMA channels and latter is
used when the platform uses separate IRQ per channel. But currently,
dw_pcie_edma_irq_verify() bails out early if edma::nr_irqs is 1, i.e., when
a single IRQ is used. This gives an impression that the driver could work
with any single IRQ in devicetree, not necessarily with name 'dma'.

But dw_pcie_edma_irq_vector(), which actually requests the IRQ, does
require the single IRQ to be named as 'dma'. So this creates inconsistency
between dw_pcie_edma_irq_verify() and dw_pcie_edma_irq_vector().

Thus, to fix this inconsistency, make sure dw_pcie_edma_irq_verify() also
verifies the single IRQ name by removing the bail out code.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
[mani: reworded subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: fix typos]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250908165914.547002-3-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 717af1b757f0a..46b12e157bebe 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -927,9 +927,7 @@ static int dw_pcie_edma_irq_verify(struct dw_pcie *pci)
 	char name[6];
 	int ret;
 
-	if (pci->edma.nr_irqs == 1)
-		return 0;
-	else if (pci->edma.nr_irqs > 1)
+	if (pci->edma.nr_irqs > 1)
 		return pci->edma.nr_irqs != ch_cnt ? -EINVAL : 0;
 
 	ret = platform_get_irq_byname_optional(pdev, "dma");
-- 
2.51.0



