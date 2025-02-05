Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C617A18A6D7;
	Wed,  5 Feb 2025 14:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767218; cv=none; b=t+A0QKDvnQtknNg5NJRN8wFtTip3qdMxZdr7n5DHdkZQ4Br/XnoM8aKSSnFpNmisOaT8pqwSU9W3w44ZmpBoabeBdAmeol/MdwEJ5qcIcV3l40oGeJ+PA1ieH15tW8k2q7MJ5vLPOWelEu17F2jNOmE017+vvXOgP9PKDhp3GLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767218; c=relaxed/simple;
	bh=YsXC8HeBKoCSW2sFQRZLbVgrrERjFQXk2WA+4CitRAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/BbuI3KH0Yy2MW7r/hREnaOPOxIND1Nw5i6ksRwQ75YlirmOP3JGWHGcuR3a6MU1ELMP1BedvQ0m1GY5PAog3x/dco08JtJq7/gPo0a0FJUhFyA6QYztBHDAZ9pQXfeB0CR8Ayhjd+WW9CxHrDtyUEq5R0jLvM0fhNl70dy+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTzAvdYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTzAvdYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354B4C4CED1;
	Wed,  5 Feb 2025 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767218;
	bh=YsXC8HeBKoCSW2sFQRZLbVgrrERjFQXk2WA+4CitRAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTzAvdYZt63kqgUgeVY9QiCZ/jaXJVnyMyxWUHiKYv4h5c6qEz5XQKYzz8WW95DoE
	 zmkEz/aYCLUSiATp6BgHAcboBgwHdpgcpxotFsopLzEik4O+qeJiPw886jtNJYSv1m
	 LLeSRX6C63ML8bmcLP3/LLtz9c62tfe5cz3GDvxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 425/590] PCI: imx6: Configure PHY based on Root Complex or Endpoint mode
Date: Wed,  5 Feb 2025 14:43:00 +0100
Message-ID: <20250205134511.525570410@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit de22e20589b79f35f92543119c33051f8179dba0 ]

Pass PHY_MODE_PCIE_EP if the PCI controller operates in Endpoint (EP) mode,
and fix the Root Complex (RC) mode being hardcoded using a drvdata mode
check.

Fixes: 8026f2d8e8a9 ("PCI: imx6: Call common PHY API to set mode, speed, and submode")
Link: https://lore.kernel.org/r/20241119-pci_fixup_addr-v8-6-c4bfa5193288@nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index c8d5c90aa4d45..9d61e7c472082 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -966,7 +966,9 @@ static int imx_pcie_host_init(struct dw_pcie_rp *pp)
 			goto err_clk_disable;
 		}
 
-		ret = phy_set_mode_ext(imx_pcie->phy, PHY_MODE_PCIE, PHY_MODE_PCIE_RC);
+		ret = phy_set_mode_ext(imx_pcie->phy, PHY_MODE_PCIE,
+				       imx_pcie->drvdata->mode == DW_PCIE_EP_TYPE ?
+						PHY_MODE_PCIE_EP : PHY_MODE_PCIE_RC);
 		if (ret) {
 			dev_err(dev, "unable to set PCIe PHY mode\n");
 			goto err_phy_exit;
-- 
2.39.5



