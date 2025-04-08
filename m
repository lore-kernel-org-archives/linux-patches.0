Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7222690FB;
	Tue,  8 Apr 2025 11:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113134; cv=none; b=dMBilaORGSUu0AueTvAAV899LfS6EL9oqdpfE3dKQSbjQTiesKCHpSv7mL2YDv3F1RP9Oo6dvU760W8uNrNv4kSTLqUH0s20BWTy15JfRmb9Ej83tEK6MJLzX+iVEQ5RhPumk8ez+PL/JwwXfpcEQCpQB5X+VEXWHMGhlF0Tgao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113134; c=relaxed/simple;
	bh=rocJ9+COYzXIw6/dD7ks8tKhSraSA5ZbPH2tTYAOqLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BBY/BLp8LVhiMoEXD//HNPB1jlJvlwjSBmrBxz9IQJSl5vKBp9/x/UjdP2kdzBPgGlgqJZIjVup/lROxdL0RIXWLb1gndG0FxFKFD8T3poTs/3AuNoeMYHgAyYFyu9MrJoV/Gine+qeloCkfXcNu1dNFkDoGgKsZ3X2VuYlEwq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqHrUTwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqHrUTwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA4EC4CEEB;
	Tue,  8 Apr 2025 11:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113134;
	bh=rocJ9+COYzXIw6/dD7ks8tKhSraSA5ZbPH2tTYAOqLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqHrUTwoqzJ+Oma6sLu/2zSgkY7HYqaXtBzI0Uf34lGauq2QCHl9IgQWdbxzhVesu
	 IuSMFLR10bpjauHEaCoJH5IQU1husMpgkiGAnSFVSQxODEvio+lt7PnKj/sISsPlce
	 MWBM04S5aVd3AD01nkZLsYoUlbF9IVbQ4mSh59IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/268] PCI: brcmstb: Use internal register to change link capability
Date: Tue,  8 Apr 2025 12:47:37 +0200
Message-ID: <20250408104829.745540813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e47a77f943b1e..54c440f09a7ab 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -378,10 +378,10 @@ static int brcm_pcie_set_ssc(struct brcm_pcie *pcie)
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



