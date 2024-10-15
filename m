Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EE71AF0A9;
	Tue, 15 Oct 2024 13:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997663; cv=none; b=tkF1FhgjwiNfyjGpsHd2yTlzGdPOVqrvFFAvDvMsyeQr+yjwsD3d08n04S5ftUhJ4v0wuQkhwLahFf0uqm3ixFNGMlU8vyGgyCqVtuVBq9ssb75VWCYUK1XiF9qcMURJuXArTagD1tP2q23qT902hcwyXyfryzeabXdrswFxweQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997663; c=relaxed/simple;
	bh=HUDusPxXCqPZmPUbh/HNm+EH1i3NwKH5+9W/Te3gKtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwGjSwVWHxp1wJBUoBfUY/tZikeVbbFBmiOPywkhWDfJIOEoqG16ndhks0YmAO2xnQ4c42Hbjn4OzMulx+r1nQ5cjsWZz/pQ83rDTkPa4/1G1DWllZTUK3JKpniVR+zwk2bOU8fKtsZDV0GI87gVnohZi6mIsr2UIADLUXSJvOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilqWTA0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilqWTA0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F52C4CEC6;
	Tue, 15 Oct 2024 13:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997663;
	bh=HUDusPxXCqPZmPUbh/HNm+EH1i3NwKH5+9W/Te3gKtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilqWTA0yPUls2gxKZFmOzSi9Gn4bivVxnIXwflhGWKnLgRCQ9g20Hkn9IbC5BdRS3
	 11kGPE7fS1NpEGLoGsWtZ3XXXr0/HYC0O5wDIciqugnb6u4bnYtR549TfY3myOO9hn
	 E0M4ElVVtaohkI4+6JHhhdxf8eoFMw8TMP7iZd28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Rob Herring <robh@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/518] PCI: xilinx-nwl: Use irq_data_get_irq_chip_data()
Date: Tue, 15 Oct 2024 14:42:33 +0200
Message-ID: <20241015123926.601305850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 396fa1ffe698c..c710f9c298786 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -381,13 +381,11 @@ static void nwl_pcie_msi_handler_low(struct irq_desc *desc)
 
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
@@ -397,13 +395,11 @@ static void nwl_mask_leg_irq(struct irq_data *data)
 
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



