Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039A71E0E13;
	Wed,  6 Nov 2024 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897750; cv=none; b=GePGBLvxxgcHKjiAz6Go5KOmDuAO9RVPdhZwvRMvqxhn/NkvBfzoFDREGZPtsJ6PDbZ5M3fkYyVTulO7zVyrVnmhdiA+9eOKALLbl2LgeNvAbkA8aoZPjISpU/120QJclies7Cm4zSaH7RM9dFXNg5fB0j+KaFTvATwxCm1lASk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897750; c=relaxed/simple;
	bh=OQ3q+FKfHM6ecbavXnHAn6isvT1kHWVnieuyf+hry7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6KPEWDNvSOx7wKnaEXLJXOz4VtWYB0eWROrvXKbbt1F62pKiB6T6430fYceoqdoXv9BjlQZoCRAowGL3AX8xMfgZQaQsokfhTpKs6nbbytBF1xtDrSy7POjPQBFIs0NI8e/bG4mPgr6B9Tbv6/KNOvsti8llOjc1onrpjERmSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCsKG79p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCsKG79p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE4EC4CECD;
	Wed,  6 Nov 2024 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897749;
	bh=OQ3q+FKfHM6ecbavXnHAn6isvT1kHWVnieuyf+hry7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCsKG79pU3nFSHnoMMv57WzP1wMsRrKwIdEbcWOQdISCo8pmTFnjUbNNHha7r3pE9
	 WJyYtcl/aP2E2ML9iBRS2wC3Pe1EZEk6p7Irv5u41jzaGuDvBGOmk0hPlPCe2aMZz3
	 14rXEEQO1Bo9tsVYeuiYOQrBxmXRVVRpCh9q1NN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/151] phy: freescale: imx8m-pcie: Do CMN_RST just before PHY PLL lock check
Date: Wed,  6 Nov 2024 13:04:59 +0100
Message-ID: <20241106120311.923588789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit f89263b69731e0144d275fff777ee0dd92069200 ]

When enable initcall_debug together with higher debug level below.
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=9
CONFIG_CONSOLE_LOGLEVEL_QUIET=9
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=7

The initialization of i.MX8MP PCIe PHY might be timeout failed randomly.
To fix this issue, adjust the sequence of the resets refer to the power
up sequence listed below.

i.MX8MP PCIe PHY power up sequence:
                          /---------------------------------------------
1.8v supply     ---------/
                    /---------------------------------------------------
0.8v supply     ---/

                ---\ /--------------------------------------------------
                    X        REFCLK Valid
Reference Clock ---/ \--------------------------------------------------
                             -------------------------------------------
                             |
i_init_restn    --------------
                                    ------------------------------------
                                    |
i_cmn_rstn      ---------------------
                                         -------------------------------
                                         |
o_pll_lock_done --------------------------

Logs:
imx6q-pcie 33800000.pcie: host bridge /soc@0/pcie@33800000 ranges:
imx6q-pcie 33800000.pcie:       IO 0x001ff80000..0x001ff8ffff -> 0x0000000000
imx6q-pcie 33800000.pcie:      MEM 0x0018000000..0x001fefffff -> 0x0018000000
probe of clk_imx8mp_audiomix.reset.0 returned 0 after 1052 usecs
probe of 30e20000.clock-controller returned 0 after 32971 usecs
phy phy-32f00000.pcie-phy.4: phy poweron failed --> -110
probe of 30e10000.dma-controller returned 0 after 10235 usecs
imx6q-pcie 33800000.pcie: waiting for PHY ready timeout!
dwhdmi-imx 32fd8000.hdmi: Detected HDMI TX controller v2.13a with HDCP (samsung_dw_hdmi_phy2)
imx6q-pcie 33800000.pcie: probe with driver imx6q-pcie failed with error -110

Fixes: dce9edff16ee ("phy: freescale: imx8m-pcie: Add i.MX8MP PCIe PHY support")
Cc: stable@vger.kernel.org
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>

v2 changes:
- Rebase to latest fixes branch of linux-phy git repo.
- Richard's environment have problem and can't sent out patch. So I help
post this fix patch.

Link: https://lore.kernel.org/r/20241021155241.943665-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
index 11fcb1867118c..e98361dcdeadf 100644
--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -141,11 +141,6 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 			   IMX8MM_GPR_PCIE_REF_CLK_PLL);
 	usleep_range(100, 200);
 
-	/* Do the PHY common block reset */
-	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
-			   IMX8MM_GPR_PCIE_CMN_RST,
-			   IMX8MM_GPR_PCIE_CMN_RST);
-
 	switch (imx8_phy->drvdata->variant) {
 	case IMX8MP:
 		reset_control_deassert(imx8_phy->perst);
@@ -156,6 +151,11 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 		break;
 	}
 
+	/* Do the PHY common block reset */
+	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
+			   IMX8MM_GPR_PCIE_CMN_RST,
+			   IMX8MM_GPR_PCIE_CMN_RST);
+
 	/* Polling to check the phy is ready or not. */
 	ret = readl_poll_timeout(imx8_phy->base + IMX8MM_PCIE_PHY_CMN_REG075,
 				 val, val == ANA_PLL_DONE, 10, 20000);
-- 
2.43.0



