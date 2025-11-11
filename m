Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805101C28E;
	Tue, 11 Nov 2025 01:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823925; cv=none; b=ucMHq7KOMYsJJIcOTmvIo/oIJH/7+WvjVOEm6UQS/7DW7PTcvJeW328bDnkdxtQ34wMHVZqvcVtKeLURW3fxjhH5/r9729E34WSbVff944D5qe4PrzH7ByuWAdEWO0ZgP3T5q2U7bjuvNgLxN+8E4o1NQTFgHGYX+xnQDafl83E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823925; c=relaxed/simple;
	bh=89ExhiIx9tzt+Km0iN4M29dkXD0F7Wt1qG1U5bW2xEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifWqQypaLgBiXNXIQurL9uM8ly5s3o8swfihgn4mbW9e3hNu5i10jQRzvce8SRtviz91QjJwDx2BgEnqem1iM5UnhWnXN+MFuxQHfqChTKb2wUOY0113UqlKcvu/hQL7FtVmTLXKt/TG9o3KnbtXeieVFf8dhzAinmW0pYnNEVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiCSnjTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiCSnjTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F259C4CEF5;
	Tue, 11 Nov 2025 01:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823925;
	bh=89ExhiIx9tzt+Km0iN4M29dkXD0F7Wt1qG1U5bW2xEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiCSnjTvLpreogYgpn22XzyH3ISZo4kF1FM8IKR0pGZFjC5i+RCwHq4cMC6UcZgB1
	 1sUhGZXUJmK4OEh/K+VwPg9bZL1j9IZZiOVAPmAjQ+UACk/dacuIB4xa22np2BlpBE
	 ubpawnCkcLzMPCkJvYadIO6SiKY7LzlvY/J4xR4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/565] PCI: dwc: Verify the single eDMA IRQ in dw_pcie_edma_irq_verify()
Date: Tue, 11 Nov 2025 09:43:27 +0900
Message-ID: <20251111004534.770233436@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f9473b8160778..f7d10cb788e0e 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -978,9 +978,7 @@ static int dw_pcie_edma_irq_verify(struct dw_pcie *pci)
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



