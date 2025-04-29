Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C173253B71;
	Tue, 29 Apr 2025 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949721; cv=none; b=N/mniytqIzgJbR+XKKUJjJWNZb7t42dNBd8520wFfkVmCaAATwNrgVhUp7AGuagbtvrwyxq9b4DI0VaCGzSPz263673WhAqmHcmQmll1eVbCwURys8tBNYl7r8F9CBjdDrGDfMq0XxyurFx9pyzD2NuMVq/Tj34DcYkIVbqTfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949721; c=relaxed/simple;
	bh=IG5/Xj7eoZ1fqtnJ9q/4sVJq209VpgVgSO1Ctwx9JWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBr3VD7jx4WZZAVxh6hPzouHvnwunjfwimNYuzWPyNfE44v/Zm87eq3bduqiSPDKyDY+oV2FZi+7FL9UJIs4ZNgeV1oG6j1TjHS2FjqoaA6P63RyEL1MPh7SLIRqhEGR92cxDZJ2MboJnncLjs2GQU2Bh4NllwD4SPXERamQvXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGORGjrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGORGjrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8A8C4CEE3;
	Tue, 29 Apr 2025 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949721;
	bh=IG5/Xj7eoZ1fqtnJ9q/4sVJq209VpgVgSO1Ctwx9JWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGORGjrNsXMGT8enXP0Slez/hG+O1ol+U8Q5rFRLoe1z0vZqS9yeBoXDamIO6OwWs
	 AFAPw8Qw6Cmwrx5hnHwf0qM9zR+OwjXkg47DO7snnxNU41IMzC032zYttCUAyGwYbh
	 qjb5v+lC5g5j2jO2SzoII9jcv/GYB/fxpwlrpjVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/167] phy: freescale: imx8m-pcie: assert phy reset and perst in power off
Date: Tue, 29 Apr 2025 18:42:24 +0200
Message-ID: <20250429161053.216708523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

[ Upstream commit aecb63e88c5e5fb9afb782a1577264c76f179af9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
index 0082de17cf4de..8f9db654019e9 100644
--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -165,6 +165,16 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
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
@@ -185,6 +195,7 @@ static const struct phy_ops imx8_pcie_phy_ops = {
 	.init		= imx8_pcie_phy_init,
 	.exit		= imx8_pcie_phy_exit,
 	.power_on	= imx8_pcie_phy_power_on,
+	.power_off	= imx8_pcie_phy_power_off,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.39.5



