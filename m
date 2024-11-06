Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE5F1D416E;
	Wed,  6 Nov 2024 12:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895151; cv=none; b=N2VZ/hkeusexm5BowYqPSqBMr2ydkF0St7i7D+SexCdjzD8zHyIB+3S3f8cx9oj835zjs9LaJKb4WNtnYQyAmyef3SsfMSD4mQ2pg8WZe5GjqaZLCSNkqNHUI7xlXBAh+aVIZfmYEWuYhlx+x6WAOGGB327+ni0pNNVeVEmyI58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895151; c=relaxed/simple;
	bh=zFlr0xyTFQuQTLhfq86bYc2FvbBGHi6YE9FW5qmt7p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8Gnt5kiy1sBFfemjptyJTCvNdYfwD0fh6hCq4imJWfsA3r6Fg9EENII1uqrDh35STgvnuwISQuL5CRGAhyobFstKD0/E9qAEBY0qEcvFbHBoV7g2r+Tt+0Y42ShuBjuaE/FNyzPjzYVXPiReO5y3bpyW9ck8JEVqB55JKeK4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuOAAM+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuOAAM+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41505C4CED6;
	Wed,  6 Nov 2024 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895151;
	bh=zFlr0xyTFQuQTLhfq86bYc2FvbBGHi6YE9FW5qmt7p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuOAAM+0vP7Cv0iuumJqouP1Oq9xXBwqJQ+965OHxOQO/c1gSxQyCAn17r+f4dAWX
	 Fypse0XUh09LtQ8KaLARXJpEq2mu0CGq2jaqxZtnYXWMxiwCXYDb4tZzykfyjz/49t
	 6NxFdvgkluoKbUrH57FdV8SEI825vIHX9eFAnHQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Rob Herring <robh@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/350] PCI: xilinx-nwl: Use irq_data_get_irq_chip_data()
Date: Wed,  6 Nov 2024 13:00:49 +0100
Message-ID: <20241106120323.896257601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4b7b906967582..79d72ec8f5c36 100644
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



