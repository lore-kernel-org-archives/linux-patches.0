Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007FE26560B;
	Tue, 11 Nov 2025 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824587; cv=none; b=cano0+gMwA4/p7YedE7J+Do225rnIwkiwZrmu9R7hnD1dozXaNUcv2DsGZo6HMxw4An0/h7DQcF2CJzYhOt+nUCrtw5NFfK3nB/zbKHiLpKfFdUe+O29QsRb82WxhU2oca2tzGQ/dME0rAcKky/mQhvuAxyjWzFNh0rCdAnKqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824587; c=relaxed/simple;
	bh=PWJ5w7Wf77zbR+s/Hnd1GsyCcwZfael+QmtIWHgvjVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfQwXAz8SHXteAcDD5ynK8vkKSs5E1sp8EwG7+tebY9Gj+YoMzDCl9JhP3R2p2zqGbQANCH847qdRTWh2XQWtR2h1W0d9/DIKyZo54fhDNLQv04OKSRI4rVhWzA7ikjDYSp1PMpYqUo5uJzVP1tuhlG9gJU7rUMdn16n5YQPT8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0fJh/3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0fJh/3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95556C4CEF5;
	Tue, 11 Nov 2025 01:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824586;
	bh=PWJ5w7Wf77zbR+s/Hnd1GsyCcwZfael+QmtIWHgvjVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0fJh/3HxHhH1fSJuJCK8XVKoEQQGQBnGyHDDE4OHh4ejOy0y6B1eIaSy0pL7G24x
	 lNX7bEzvCQ8SuglZQb5yHkVOWj+Khb++nBJlubKXf/k2yYSNZYDbS0p4eBANl7J/wU
	 fNSmtPY6gswzyQwF0XzpdxuJRtTZ/Ht5tbcO8/OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 529/849] PCI: dwc: Verify the single eDMA IRQ in dw_pcie_edma_irq_verify()
Date: Tue, 11 Nov 2025 09:41:39 +0900
Message-ID: <20251111004549.206293706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 89aad5a08928c..c7a2cf5e886f3 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -1045,9 +1045,7 @@ static int dw_pcie_edma_irq_verify(struct dw_pcie *pci)
 	char name[15];
 	int ret;
 
-	if (pci->edma.nr_irqs == 1)
-		return 0;
-	else if (pci->edma.nr_irqs > 1)
+	if (pci->edma.nr_irqs > 1)
 		return pci->edma.nr_irqs != ch_cnt ? -EINVAL : 0;
 
 	ret = platform_get_irq_byname_optional(pdev, "dma");
-- 
2.51.0



