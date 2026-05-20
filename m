Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1B83EAC8F;
	Wed, 20 May 2026 16:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295370; cv=none; b=VUULFYiGpWWJe/lM2ngJYbHxtggRz07j0vPfQMHlRbmnBqOMisvKRE92ZUM4nlWnI3/bD4qjsJyEc8ax77rjaHLlBd9bCXW55/tiD4K4hKMdpKZqp4NjMB+gvL+yipzP/TvKgpXkCkghP5d/W6XWAmmUZIJa3I+o4Q6byMNDxys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295370; c=relaxed/simple;
	bh=rkNuixjv5aPNt1t1JPEV0+XqqFSw+docXWkTBuRkPWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCGbAxOjCe730QUz2OSU550LyTL+Y8UtSyYenKAbxZz2WhlK9vD2iJtifj4PRp/w+vFrwkX4IWyt7976ssZsgyWkVyWWlCf3ttICaRS5LvlfDz3Z7V1055/EGouWiu8TbeZluC4EHmYzo5PAJ8wRU+SXTjK/vcFNOK6ar7XNr5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqvg/V5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqvg/V5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33B21F000E9;
	Wed, 20 May 2026 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295369;
	bh=4BTFRhzuqm4YxqiYwi8mMFYxe7vQgw2xI/8Ta++Zb7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqvg/V5k70WKtUYKnlQTpHOs9Klb9hkwZeVNcpbh+veYnt51jiMuuIWIIoOe3HgZC
	 cR+CeqqSJf2e9xAG6DvxomxSsF45PdK4DCInyaEZdyiQtjzEM7bL3xIKrBMA96hQv0
	 7Ynz7GOMBRHfLiqsIoXSBSrWRz3nR1ioX7ijIEiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0394/1146] PCI: aspeed: Fix IRQ domain leak on platform_get_irq() failure
Date: Wed, 20 May 2026 18:10:44 +0200
Message-ID: <20260520162157.117222525@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit c54d5f5b33990f2649c20f35407f340bcadb8a53 ]

The aspeed_pcie_probe() function calls aspeed_pcie_init_irq_domain()
which allocates pcie->intx_domain and initializes MSI. However, if
platform_get_irq() fails afterwards, the cleanup action was not yet
registered via devm_add_action_or_reset(), causing the IRQ domain
resources to leak.

Fix this by registering the devm cleanup action immediately after
aspeed_pcie_init_irq_domain() succeeds, before calling
platform_get_irq(). This ensures proper cleanup on any subsequent
failure.

Fixes: 9aa0cb68fcc1 ("PCI: aspeed: Add ASPEED PCIe RC driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Jacky Chou <jacky_chou@aspeedtech.com>
Link: https://patch.msgid.link/20260324-aspeed-v1-1-354181624c00@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-aspeed.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pcie-aspeed.c b/drivers/pci/controller/pcie-aspeed.c
index 3e1a39d1e6484..6acfae7d026e4 100644
--- a/drivers/pci/controller/pcie-aspeed.c
+++ b/drivers/pci/controller/pcie-aspeed.c
@@ -1052,14 +1052,14 @@ static int aspeed_pcie_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
 	ret = devm_add_action_or_reset(dev, aspeed_pcie_irq_domain_free, pcie);
 	if (ret)
 		return ret;
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
 	ret = devm_request_irq(dev, irq, aspeed_pcie_intr_handler, IRQF_SHARED,
 			       dev_name(dev), pcie);
 	if (ret)
-- 
2.53.0



