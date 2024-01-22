Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F764EB24;
	Tue, 23 Jan 2024 00:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970056; cv=none; b=jzqf/XT/AIg/aslpTKSfCBhEqIe6AWlM/xLKS8pmM+FhBrJ82hddfs02fDaazGvhfpovxfk16gCxiWmNM1Cg7f28R1QYViYiJ6Pt8ga4Wabfq93LI+sCctPK3bEQBAHZUHT3EFhFDgICzZ7ryyl1nSho5RDpvcOewBZxXkm1g7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970056; c=relaxed/simple;
	bh=DQCvZVPkgwnJ5LZkAEx+N7Wue1M6Lu5GIExTlvEMUGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8g5nPd4zWgazN7MD41HuU0OgK9W+26QDDqqjZOGuHMHtzNwYOHbJn/XgyKpWQbLH9T2mo0KHXFufWJ+nC6cTouGAJEVPc1Knbk4GHukp+WGRqtgLizcu8TWmja/YIGVJoVQamR/E0n1LGHJUupsbOveyEpee1vXmvvAE4/opA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhNH/dSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhNH/dSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39E8C433C7;
	Tue, 23 Jan 2024 00:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970056;
	bh=DQCvZVPkgwnJ5LZkAEx+N7Wue1M6Lu5GIExTlvEMUGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhNH/dSUJZ2bUMy2f1mTsvit4YRc5QBP9Yfki7p6m/qKoUiNadeijZ4wajn+HzT6a
	 O8pPpMZ/uHaAbNat6cObrQy05sdrHKTVtN5k4PJahh0eqDWa8rrmzSvWzwqizt3YD2
	 4/ECFs05vBpguBeQX3EPmVSXhwUnPv0bkOU27TN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 574/641] PCI: xilinx-xdma: Fix error code in xilinx_pl_dma_pcie_init_irq_domain()
Date: Mon, 22 Jan 2024 15:57:58 -0800
Message-ID: <20240122235836.114093072@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 2324be17b5e05ac682e7c81fcbfc7b36a9b1becb ]

Currently, if the function irq_domain_add_linear() fails to allocate
a new IRQ domain and returns NULL, we would then still return a success
from the xilinx_pl_dma_pcie_init_irq_domain() function regardless, as
the PTR_ERR(NULL) would return a value of zero.  This is not a desirable
outcome.

Thus, fix the incorrect error code and return the -ENOMEM error code if
the irq_domain_add_linear() fails to allocate a new IRQ domain.

[kwilczynski: commit log]
Link: https://lore.kernel.org/linux-pci/20231030072757.3236546-1-harshit.m.mogalapalli@oracle.com
Fixes: 8d786149d78c ("PCI: xilinx-xdma: Add Xilinx XDMA Root Port driver")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-dma-pl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-xilinx-dma-pl.c b/drivers/pci/controller/pcie-xilinx-dma-pl.c
index 96aedc85802a..3d7f280edade 100644
--- a/drivers/pci/controller/pcie-xilinx-dma-pl.c
+++ b/drivers/pci/controller/pcie-xilinx-dma-pl.c
@@ -576,7 +576,7 @@ static int xilinx_pl_dma_pcie_init_irq_domain(struct pl_dma_pcie *port)
 						  &intx_domain_ops, port);
 	if (!port->intx_domain) {
 		dev_err(dev, "Failed to get a INTx IRQ domain\n");
-		return PTR_ERR(port->intx_domain);
+		return -ENOMEM;
 	}
 
 	irq_domain_update_bus_token(port->intx_domain, DOMAIN_BUS_WIRED);
-- 
2.43.0



