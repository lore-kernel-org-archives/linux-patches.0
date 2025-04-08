Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8528926AA8F;
	Tue,  8 Apr 2025 11:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110004; cv=none; b=q7UUXk3fOFipVii2AiEiW7xAup1wQ2W0ips//Q3G81Zq6sxUqsEOkE2dtoQz93n9EGjw+1ico3lFpUhDDeh0kjqy4ro6XdQ/36clPSHKEKySB+/ZIFOgJPRSr4F92pF2es96rzyn13qs8CLfMJYV0zJhL3LCxsMumfIVfwfcbJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110004; c=relaxed/simple;
	bh=VgrjrcNSofOiZlc6Iw0unphutOGlatRzTGK54KoSydU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOZFbt3255/yNyI7fYNSPtrESqd4XSugEm2wDmsfiIw5iYMYIT+vC0S6SBaUWKgJEUmk/uslOhQOHnKFkKVRRupG/fwNcijrTJKpImcNbptZIHScylN2R3hcL8G/K1qrWfXeGcEBbxZW6m+pXhmjREBfrmf1ZUaPFlU7mPASegg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lA9dsPVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lA9dsPVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15729C4CEEB;
	Tue,  8 Apr 2025 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110004;
	bh=VgrjrcNSofOiZlc6Iw0unphutOGlatRzTGK54KoSydU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lA9dsPVtVe9WFTPqQ60VZJj/jGRB6bjfLbAr7QmHmCjZXGztNrY4yjgH0umI7VeHW
	 buS5+aUE/lOYRDyh/ovmViYNEvW8bq23KGV/7EUK5W5wX6L/6l0CZ//5NH6zPdVnvd
	 1q+hScwpyIZK4kyLOn03XBqTPABnOVKaKUU9A6rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/227] PCI: brcmstb: Use internal register to change link capability
Date: Tue,  8 Apr 2025 12:48:32 +0200
Message-ID: <20250408104824.339157742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9c3d2982248d3..be6af5585dd6b 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -402,10 +402,10 @@ static int brcm_pcie_set_ssc(struct brcm_pcie *pcie)
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



