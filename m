Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94231DFE35;
	Wed,  6 Nov 2024 13:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898207; cv=none; b=buydG5d1y8qW+3DU2GOmIqTFaNkunOZV4air4PQoQS7jkEXqAZ3jASLdlfzdmTQcFl2/VUnm6zCT3+gtnRzyp28Zw4Rs+/2E2iJRcCPLD6CAaEj92NGCVgxD4kO/WlNgVbZk9SVqFHLuQsQGe0EtxbywXXzGsMyYu4f+ZSC7NEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898207; c=relaxed/simple;
	bh=utq+vjg5mLzi+ACj82lcOi84MiySWgu53Rx2281Qha0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJxEWqi4UhI9QHypGRRbaq12ms+7rOWLYXSZy+n7qDS+qWozm5V+Ka3W3D3M14JKUlQMXif/RzJ50c2VuMSjAhqlx/V8mcd5Hs/FrjqAB7vvwjFsGN81gc9j5kE9OdXA7kHbVPgYdh7opaNQxdYjCPEkFwzxksarG6wv93BSc/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVNX/AX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVNX/AX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C9BC4CECD;
	Wed,  6 Nov 2024 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898206;
	bh=utq+vjg5mLzi+ACj82lcOi84MiySWgu53Rx2281Qha0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVNX/AX95auhN42L/kXYZf6SMGtGsRzrx1RIywYzoG7PMhlX337EQhCTZ5DxD+KbH
	 +jL59bMj2PaNIm6B5l96xDFSmc22DXB+/b5dpX8Gv1vRtg0bPARnZ+3hanKnI8RtnW
	 +mIOB3ur/0aJWDqKsEbOb32TTTQ4+aRfTEnMvrko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Rob Herring <robh@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/462] PCI: xilinx-nwl: Use irq_data_get_irq_chip_data()
Date: Wed,  6 Nov 2024 13:00:54 +0100
Message-ID: <20241106120335.500083967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit e56427068a8d796bb7b8e297f2b6e947380e383f ]

Going through a full irq descriptor lookup instead of just using the proper
helper function which provides direct access is suboptimal.

In fact it _is_ wrong because the chip callback needs to get the chip data
which is relevant for the chip while using the irq descriptor variant
returns the irq chip data of the top level chip of a hierarchy. It does not
matter in this case because the chip is the top level chip, but that
doesn't make it more correct.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20201210194044.364211860@linutronix.de
Stable-dep-of: 0199d2f2bd8c ("PCI: xilinx-nwl: Fix off-by-one in INTx IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-nwl.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx-nwl.c b/drivers/pci/controller/pcie-xilinx-nwl.c
index 539bf53beb654..eb23bb28221a8 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -384,13 +384,11 @@ static void nwl_pcie_msi_handler_low(struct irq_desc *desc)
 
 static void nwl_mask_leg_irq(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(data->irq);
-	struct nwl_pcie *pcie;
+	struct nwl_pcie *pcie = irq_data_get_irq_chip_data(data);
 	unsigned long flags;
 	u32 mask;
 	u32 val;
 
-	pcie = irq_desc_get_chip_data(desc);
 	mask = 1 << (data->hwirq - 1);
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
@@ -400,13 +398,11 @@ static void nwl_mask_leg_irq(struct irq_data *data)
 
 static void nwl_unmask_leg_irq(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(data->irq);
-	struct nwl_pcie *pcie;
+	struct nwl_pcie *pcie = irq_data_get_irq_chip_data(data);
 	unsigned long flags;
 	u32 mask;
 	u32 val;
 
-	pcie = irq_desc_get_chip_data(desc);
 	mask = 1 << (data->hwirq - 1);
 	raw_spin_lock_irqsave(&pcie->leg_mask_lock, flags);
 	val = nwl_bridge_readl(pcie, MSGF_LEG_MASK);
-- 
2.43.0



