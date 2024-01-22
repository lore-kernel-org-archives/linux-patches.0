Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7382B56B68;
	Tue, 23 Jan 2024 00:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970053; cv=none; b=rUIiOEOUxq8rzL0PNQfp6hIOo9y/+tbzjkKtMDeydA8KtMCP5s2YzM2hSpEpZPxK+HW0hpytNRR7bsVDI/QPf9rFG1vUjpqUXMBEs4hvWhzIWexGAltzuk6IIPXh6WYx5d3QyX8ue5u2Gu5/givUR4mEbF2a31JnF102CLsmBog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970053; c=relaxed/simple;
	bh=oozTVBl4Xvohk9OoR96pyd5jcLIg3ErLQuRJXKbzRPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XceZ+tZnvjsapFcXyZB+jZxydCNRhR+m0ZthvpPAA/CU3oEztOMPqSAUhmPjUDDU+mfXwpZ0UdyKGR1gTT82bRTCNUzM7xQdCv0ue5MCNr1cyrfoFkLtzr3kQFgeyAxLm9e5hlBKtNBU35C9oK6SSTck+ypByO3xGynzEPoE9To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK/azANh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK/azANh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E31C433C7;
	Tue, 23 Jan 2024 00:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970053;
	bh=oozTVBl4Xvohk9OoR96pyd5jcLIg3ErLQuRJXKbzRPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK/azANhHplOm0XBhr39F7txhSl8AFC15R5f6JsNjcr15RF6t3G56qRV8mOME/mna
	 DSXp2/JKocjADUb9UacpAEVJCQJ8ySv5n6+RrSo9NXrkx3HMmcFJS3Xmd3BR7I6YJ4
	 GCS0MGC7azrWD0fGNgibK4299lpOakzlc1509W+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 573/641] PCI: xilinx-xdma: Fix uninitialized symbols in xilinx_pl_dma_pcie_setup_irq()
Date: Mon, 22 Jan 2024 15:57:57 -0800
Message-ID: <20240122235836.082296554@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 7aa5f8fcd6d95b713a39fe52c296a6892eda7f02 ]

The error paths that follow calls to the devm_request_irq() functions
within the xilinx_pl_dma_pcie_setup_irq() reference an uninitialized
symbol each that also so happens to be incorrect.

Thus, fix this omission and reference the correct variable when invoking
a given dev_err() function following an error.

This problem was found using smatch via the 0-DAY CI Kernel Test service:

  drivers/pci/controller/pcie-xilinx-dma-pl.c:638 xilinx_pl_dma_pcie_setup_irq() error: uninitialized symbol 'irq'.
  drivers/pci/controller/pcie-xilinx-dma-pl.c:645 xilinx_pl_dma_pcie_setup_irq() error: uninitialized symbol 'irq'.

Fixes: 8d786149d78c ("PCI: xilinx-xdma: Add Xilinx XDMA Root Port driver")
Link: https://lore.kernel.org/oe-kbuild/202312120248.5DblxkBp-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202312120248.5DblxkBp-lkp@intel.com/
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-dma-pl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx-dma-pl.c b/drivers/pci/controller/pcie-xilinx-dma-pl.c
index 2f7d676c683c..96aedc85802a 100644
--- a/drivers/pci/controller/pcie-xilinx-dma-pl.c
+++ b/drivers/pci/controller/pcie-xilinx-dma-pl.c
@@ -635,14 +635,14 @@ static int xilinx_pl_dma_pcie_setup_irq(struct pl_dma_pcie *port)
 	err = devm_request_irq(dev, port->intx_irq, xilinx_pl_dma_pcie_intx_flow,
 			       IRQF_SHARED | IRQF_NO_THREAD, NULL, port);
 	if (err) {
-		dev_err(dev, "Failed to request INTx IRQ %d\n", irq);
+		dev_err(dev, "Failed to request INTx IRQ %d\n", port->intx_irq);
 		return err;
 	}
 
 	err = devm_request_irq(dev, port->irq, xilinx_pl_dma_pcie_event_flow,
 			       IRQF_SHARED | IRQF_NO_THREAD, NULL, port);
 	if (err) {
-		dev_err(dev, "Failed to request event IRQ %d\n", irq);
+		dev_err(dev, "Failed to request event IRQ %d\n", port->irq);
 		return err;
 	}
 
-- 
2.43.0



