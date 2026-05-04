Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352863DDDC1;
	Mon,  4 May 2026 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903069; cv=none; b=axkTlyu0jJT3GwtdlYrhKwYUwyJHG1QoldhEGGILB4gpSNhkD5Bhn8NChOhpWLlVQsXP1hQ91pXkZ+YzRIiQPqcH5tKeeWngSMV8xPWs24a/8wdfWH/tmZ1ACUEUX1dxeUm6uR1cCrqfqGfHs2bagQ3DIzPsOHkNj970xQGtqe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903069; c=relaxed/simple;
	bh=B2T/veBEy0ozUy+0kBCJd1IPlxnQGi1Y9ZRSTttDjqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV2bNxu7pSsMAFAcyZwJgOQJb2cNu7pmFcLWw724EeRewOgcQHhBFqutSmQOOMTTiPxkF7yOWt6m+VCsTbN1PCLoCfxUdaBZzXbRM8x+9ZUGF7ErY2OlcYHfItxsum32QCK4ZnOprIkuglXoHtiASjut+H0/ZeXuW+BeOQ1IXCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ABUa2Oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ABUa2Oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02CAC2BCB8;
	Mon,  4 May 2026 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903069;
	bh=B2T/veBEy0ozUy+0kBCJd1IPlxnQGi1Y9ZRSTttDjqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ABUa2Oa8UctSWWfzSwbmRZr5yHT5cXeUUYCU2BD8DMOf66VJ8oqipKjNoJYy1L3q
	 lW3UyQ7BP7ceAmsoeyFqpWBmIXNGJtSb1Rpyg8KGngO6GJClOBcdDi8yXkzgx0Xdgh
	 pMK2/1OJKhxwEmdfiRsdgL7ylO1uby1xtH0I/2Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Richard Zhu <hongxing.zhu@nxp.com>
Subject: [PATCH 7.0 091/307] PCI: imx6: Fix reference clock source selection for i.MX95
Date: Mon,  4 May 2026 15:49:36 +0200
Message-ID: <20260504135146.237563968@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Franz Schnyder <franz.schnyder@toradex.com>

commit 88cc4cbe08bba27bb58888d25d336774aa0ccab1 upstream.

In the PCIe PHY init for the i.MX95, the reference clock source selection
uses a conditional instead of always passing the mask. This currently
breaks functionality if the internal refclk is used.

To fix this issue, always pass IMX95_PCIE_REF_USE_PAD as the mask and clear
bit if external refclk is not used. This essentially swaps the parameters.

Fixes: d8574ce57d76 ("PCI: imx6: Add external reference clock input mode support")
Signed-off-by: Franz Schnyder <franz.schnyder@toradex.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260325093118.684142-1-fra.schnyder@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -268,8 +268,8 @@ static int imx95_pcie_init_phy(struct im
 			IMX95_PCIE_PHY_CR_PARA_SEL);
 
 	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_PHY_GEN_CTRL,
-			   ext ? IMX95_PCIE_REF_USE_PAD : 0,
-			   IMX95_PCIE_REF_USE_PAD);
+			   IMX95_PCIE_REF_USE_PAD,
+			   ext ? IMX95_PCIE_REF_USE_PAD : 0);
 	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_0,
 			   IMX95_PCIE_REF_CLKEN,
 			   ext ? 0 : IMX95_PCIE_REF_CLKEN);


