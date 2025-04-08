Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D35B25FA13;
	Tue,  8 Apr 2025 11:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112676; cv=none; b=FpkUvGuosByYIQQnvQdEFGI2PxSkj9rUtIqiDEQY3OA/8CyCCRbJRhV7HnCxpc5kO7zRirZVkBADCGjbkJLmOlO7urR/RTYZvI+jhPHo3Cj51lFNRcn+L6++mMbilyMQ8pKMDtvMMCoypLCZxrfDcNMH51E9G+QVeAM3PgW42RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112676; c=relaxed/simple;
	bh=iZg7VlALODa6FzUO3h3xjG7DOLXmlgW/L1FEDFEJ7aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mkPLn5QP/CAiD1Gk7x1DtnuK1eG4HMzrV3ix2dRwM6bKtHzYXJxpjxzrSAWOafzCXhOXUsaApDsRjDb1mq+4AT23ueA+71cER/dBMhKdAw196oxlGeBKbHbAE426XA4EQTI2G5jNekTedwXngxx4Mm4l1EfRbaq4MLQZ/toSDkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZ3nc4eJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZ3nc4eJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1FCC4CEE5;
	Tue,  8 Apr 2025 11:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112675;
	bh=iZg7VlALODa6FzUO3h3xjG7DOLXmlgW/L1FEDFEJ7aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZ3nc4eJYR4S6MMWS+5kjGpDV6yQ5S0dzk00rozPZ5F1f24BJhde2quMsyElc9yMw
	 3cR9hiyJnFbiytcbf4TAhAiwY/QP+paG6bnX/B3WHSZq9m33xO/DIdzJz5Hvxr+Wmp
	 JrX5J7dvJ9O9KEPURGcTKJESeww5CK9MhL9aZgF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/279] PCI: brcmstb: Use internal register to change link capability
Date: Tue,  8 Apr 2025 12:48:58 +0200
Message-ID: <20250408104830.521818915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Quinlan <james.quinlan@broadcom.com>

[ Upstream commit 0c97321e11e0e9e18546f828492758f6aaecec59 ]

The driver has been mistakenly writing to a read-only (RO)
configuration space register (PCI_EXP_LNKCAP) to change the
PCIe link capability.

Although harmless in this case, the proper write destination
is an internal register that is reflected by PCI_EXP_LNKCAP.

Thus, fix the brcm_pcie_set_gen() function to correctly update
the link capability.

Fixes: c0452137034b ("PCI: brcmstb: Add Broadcom STB PCIe host controller driver")
Signed-off-by: Jim Quinlan <james.quinlan@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250214173944.47506-3-james.quinlan@broadcom.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index cc30215f5a433..c3c1d700f519a 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -410,10 +410,10 @@ static int brcm_pcie_set_ssc(struct brcm_pcie *pcie)
 static void brcm_pcie_set_gen(struct brcm_pcie *pcie, int gen)
 {
 	u16 lnkctl2 = readw(pcie->base + BRCM_PCIE_CAP_REGS + PCI_EXP_LNKCTL2);
-	u32 lnkcap = readl(pcie->base + BRCM_PCIE_CAP_REGS + PCI_EXP_LNKCAP);
+	u32 lnkcap = readl(pcie->base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
 
 	lnkcap = (lnkcap & ~PCI_EXP_LNKCAP_SLS) | gen;
-	writel(lnkcap, pcie->base + BRCM_PCIE_CAP_REGS + PCI_EXP_LNKCAP);
+	writel(lnkcap, pcie->base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
 
 	lnkctl2 = (lnkctl2 & ~0xf) | gen;
 	writew(lnkctl2, pcie->base + BRCM_PCIE_CAP_REGS + PCI_EXP_LNKCTL2);
-- 
2.39.5



