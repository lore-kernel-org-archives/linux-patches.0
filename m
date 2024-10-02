Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7391CDFBC;
	Wed,  2 Oct 2024 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876647; cv=none; b=NRYTTXJM0nKmmdmGPPhTNV/enw1f+2R0G/0KGdN44uSrIR+6Pb7sQTkik+ZnDs6aziRuSSMuQK9pCoZrvNQ081C5WMOODFNkH62vefps/IuiGYnZcg46kFHgjCf5DKbKzedO5cfS2oUamDvlHbv8amfIIvpIMg2vdVaWambUGU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876647; c=relaxed/simple;
	bh=jWg6zA+pEyb72hjGGv3JIQPEwD/ymknyhJxYha+Mop8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HzYKtIs4/MRhm4fsOuouLhJNRP1NUmmNlyTBVn+kbUvAs4fzOagoGjzp4Gz+scJixwZhYmocB29TQFUIKKpraggtebSIxslEFkkhU8Y8ypfKs72huadPXIlRfe5p7vRpK2+nh1VgPFCNoMfUQTgBoGlk7tM78ysRgM8fmoJnuyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jESq/XTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jESq/XTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C94CC4CEC5;
	Wed,  2 Oct 2024 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876647;
	bh=jWg6zA+pEyb72hjGGv3JIQPEwD/ymknyhJxYha+Mop8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jESq/XTZFceSQOImy3d272HR+JweOv/P0ec+4o705kFK5M60o9iLYrU+wo3iA9zJO
	 C3zSMlszI1pANb5cfxgnu7Uw6UpqzHJ+l3cz/wVq53/ntLU1hir14PsCDB/rt1P8u5
	 u65OVPQxt8ihooeaQV/Iw/nlXFlHEPx0ZMWyhyaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.11 515/695] PCI: imx6: Fix missing call to phy_power_off() in error handling
Date: Wed,  2 Oct 2024 14:58:33 +0200
Message-ID: <20241002125843.039048847@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 5b04d44d5c74e4d8aab1678496b84700b4b343fe upstream.

Fix missing call to phy_power_off() in the error path of
imx6_pcie_host_init(). Remove unnecessary check for imx6_pcie->phy
as the PHY API already handles NULL pointers.

Fixes: cbcf8722b523 ("phy: freescale: imx8m-pcie: Fix the wrong order of phy_init() and phy_power_on()")
Link: https://lore.kernel.org/linux-pci/20240729-pci2_upstream-v8-3-b68ee5ef2b4d@nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -953,7 +953,7 @@ static int imx6_pcie_host_init(struct dw
 		ret = phy_power_on(imx6_pcie->phy);
 		if (ret) {
 			dev_err(dev, "waiting for PHY ready timeout!\n");
-			goto err_phy_off;
+			goto err_phy_exit;
 		}
 	}
 
@@ -968,8 +968,9 @@ static int imx6_pcie_host_init(struct dw
 	return 0;
 
 err_phy_off:
-	if (imx6_pcie->phy)
-		phy_exit(imx6_pcie->phy);
+	phy_power_off(imx6_pcie->phy);
+err_phy_exit:
+	phy_exit(imx6_pcie->phy);
 err_clk_disable:
 	imx6_pcie_clk_disable(imx6_pcie);
 err_reg_disable:


