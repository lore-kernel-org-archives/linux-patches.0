Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1459F2EF2AF;
	Thu,  3 Jul 2025 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553979; cv=none; b=Y64xF8zPZtVX5vrp2/4M9WhdEdTVivCWL87z1CHQ1Dt6Xj7fSww3BiEwXfZ7t6G0r5ulJ/tFUVsyUsJ/e4dQ+IMgfHgx3WMsbeFqL5EF+JYVtMr7w+kuOR0N2eyfP4mCUsYYAfD44HufQ58JBYvYaaUNYjb35suBUylqbujgXWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553979; c=relaxed/simple;
	bh=y8A8ZjVKuaDCmyp5q3dnxmiJEzgrw1jvMGW7qXvIn/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V75pMJM7V5MShl8QLBe5LgseCta31JqoehqcLr3TNpAtqe46JrNhG5EmQaY9GYeQ4d1Nuv/RKMrTWoo+bImPoAU1fBqcmMuY23MWOSlqXTbhLfFAktwaUgjr6SGJf4epX/Mj6I1GUgxZFz112AyGFmKwQeja9zIMKthdIiV1v2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdpRzMOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdpRzMOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8EFC4CEE3;
	Thu,  3 Jul 2025 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553978;
	bh=y8A8ZjVKuaDCmyp5q3dnxmiJEzgrw1jvMGW7qXvIn/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdpRzMOF2G59e/uDeowk1Kc6GCLhS102TQyFA7bEh0U7aUTgLPSPt+R9vG80oOOaz
	 NU6i6Y0zx/FPsRZmkvlkfXdkC76kqopFhAtrup3YqYsESO9Dwp3X3Req8iJs9f5hDZ
	 DPM3aZGsqjL2OAMQ45b7Qt2gfFX3yH3i1u8luW8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/218] PCI: imx6: Add workaround for errata ERR051624
Date: Thu,  3 Jul 2025 16:39:33 +0200
Message-ID: <20250703143956.972343529@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit ce0c43e855c7f652b6351110aaaabf9b521debd7 ]

ERR051624: The Controller Without Vaux Cannot Exit L23 Ready Through Beacon
or PERST# De-assertion

When the auxiliary power is not available, the controller cannot exit from
L23 Ready with beacon or PERST# de-assertion when main power is not
removed. So the workaround is to set SS_RW_REG_1[SYS_AUX_PWR_DET] to 1.

This workaround is required irrespective of whether Vaux is supplied to the
link partner or not.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: subject and description rewording]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250416081314.3929794-5-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index ad3028b755d16..3b24fed3177de 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -48,6 +48,8 @@
 #define IMX95_PCIE_SS_RW_REG_0			0xf0
 #define IMX95_PCIE_REF_CLKEN			BIT(23)
 #define IMX95_PCIE_PHY_CR_PARA_SEL		BIT(9)
+#define IMX95_PCIE_SS_RW_REG_1			0xf4
+#define IMX95_PCIE_SYS_AUX_PWR_DET		BIT(31)
 
 #define IMX95_PE0_GEN_CTRL_1			0x1050
 #define IMX95_PCIE_DEVICE_TYPE			GENMASK(3, 0)
@@ -206,6 +208,19 @@ static unsigned int imx_pcie_grp_offset(const struct imx_pcie *imx_pcie)
 
 static int imx95_pcie_init_phy(struct imx_pcie *imx_pcie)
 {
+	/*
+	 * ERR051624: The Controller Without Vaux Cannot Exit L23 Ready
+	 * Through Beacon or PERST# De-assertion
+	 *
+	 * When the auxiliary power is not available, the controller
+	 * cannot exit from L23 Ready with beacon or PERST# de-assertion
+	 * when main power is not removed.
+	 *
+	 * Workaround: Set SS_RW_REG_1[SYS_AUX_PWR_DET] to 1.
+	 */
+	regmap_set_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_1,
+			IMX95_PCIE_SYS_AUX_PWR_DET);
+
 	regmap_update_bits(imx_pcie->iomuxc_gpr,
 			IMX95_PCIE_SS_RW_REG_0,
 			IMX95_PCIE_PHY_CR_PARA_SEL,
-- 
2.39.5



