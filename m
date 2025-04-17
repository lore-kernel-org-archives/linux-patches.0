Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72B2256C63;
	Thu, 17 Apr 2025 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914966; cv=none; b=kvO1huEDiomA7aXrUrOQnlkV/DcrTf0zQRsgFNE1rcPlWPaHurCGoamR5SoU9Z/40n3nbyPoW1KmXgxL84K1hkHjF3iu6rdVTOkGhLKPDQykOlyMD3RJOHqfl9ZqysE/cmsaI97DN1FJLRbGA6EQRA5BiRGAugDCVNn4Fp5sEc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914966; c=relaxed/simple;
	bh=/3Ch5BgHX/VD/tAMhsRGzqrxgzgfnaSU5iHIkyvlz5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+aUoigetmWMOEcd4Nm7qHVDH7d7iRRPROuQqPHRkCocj1UKmDNiE1AFBXAdBVZ1vd2snU50AUtaGffnLpQYCOeKiYTrguYtiPeq4KhWIM7YexPKAJsTMl4f4eHKnge0Qkut146yp68dNfDKAtiWMw7DZFetwi/CiUejwl5fxNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py6Mp1Ud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py6Mp1Ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C4CC4CEE4;
	Thu, 17 Apr 2025 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914966;
	bh=/3Ch5BgHX/VD/tAMhsRGzqrxgzgfnaSU5iHIkyvlz5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=py6Mp1UdeS3BT8h2fTbaTGD5RN+0pqRkKjtG9CLC6zeyXAVTCYPDZTFqcj+7ENP7L
	 wN8LS0gVHmpxCLvOrE2+q5Q3pq9Qkzi4QkUw4DSSZ7HoXgVSgiA64ijpxfnYFYFpgd
	 pJF6CaZTZAfikgDYl+iUCsL0274qZ9ZijhxmmDJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.13 390/414] phy: freescale: imx8m-pcie: assert phy reset and perst in power off
Date: Thu, 17 Apr 2025 19:52:28 +0200
Message-ID: <20250417175127.173584676@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit aecb63e88c5e5fb9afb782a1577264c76f179af9 upstream.

Ensure the PHY reset and perst is asserted during power-off to
guarantee it is in a reset state upon repeated power-on calls. This
resolves an issue where the PHY may not properly initialize during
subsequent power-on cycles. Power-on will deassert the reset at the
appropriate time after tuning the PHY parameters.

During suspend/resume cycles, we observed that the PHY PLL failed to
lock during resume when the CPU temperature increased from 65C to 75C.
The observed errors were:
  phy phy-32f00000.pcie-phy.3: phy poweron failed --> -110
  imx6q-pcie 33800000.pcie: waiting for PHY ready timeout!
  imx6q-pcie 33800000.pcie: PM: dpm_run_callback(): genpd_resume_noirq+0x0/0x80 returns -110
  imx6q-pcie 33800000.pcie: PM: failed to resume noirq: error -110

This resulted in a complete CPU freeze, which is resolved by ensuring
the PHY is in reset during power-on, thus preventing PHY PLL failures.

Cc: stable@vger.kernel.org
Fixes: 1aa97b002258 ("phy: freescale: pcie: Initialize the imx8 pcie standalone phy driver")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250305144355.20364-3-eichest@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -162,6 +162,16 @@ static int imx8_pcie_phy_power_on(struct
 	return ret;
 }
 
+static int imx8_pcie_phy_power_off(struct phy *phy)
+{
+	struct imx8_pcie_phy *imx8_phy = phy_get_drvdata(phy);
+
+	reset_control_assert(imx8_phy->reset);
+	reset_control_assert(imx8_phy->perst);
+
+	return 0;
+}
+
 static int imx8_pcie_phy_init(struct phy *phy)
 {
 	struct imx8_pcie_phy *imx8_phy = phy_get_drvdata(phy);
@@ -182,6 +192,7 @@ static const struct phy_ops imx8_pcie_ph
 	.init		= imx8_pcie_phy_init,
 	.exit		= imx8_pcie_phy_exit,
 	.power_on	= imx8_pcie_phy_power_on,
+	.power_off	= imx8_pcie_phy_power_off,
 	.owner		= THIS_MODULE,
 };
 


