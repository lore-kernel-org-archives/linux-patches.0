Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEA71C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF83C433D2;
	Wed, 28 Dec 2022 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245252;
	bh=W4IJTgpGPL7R83Cr9e/83msLC0nkUYBio7i30LOLwa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVJWLNsXcEYdu0cxJqvOYY9RSm6e+qCZgRVSYRP8kj4KMFS/nFqXrg5g1zpgaWOqo
	 bXjNNqslmRw+tmUCWx+UYGOT5X+QVWvyVOoo0k8NL/OREdzTk9laSU6LMqYX3sDP1X
	 EKC9tJprXOyTUoALQlprbDFqiM6jByz4BWHw4WHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0827/1146] phy: qcom-qmp-pcie: Fix high latency with 4x2 PHY when ASPM is enabled
Date: Wed, 28 Dec 2022 15:39:26 +0100
Message-Id: <20221228144352.621082628@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 9ddcd920f8edfe65c3670fbd0b49db00e1e562fe ]

The PCIe QMP 4x2 RC PHY generates high latency when ASPM is enabled. This
seem to be fixed by clearing the QPHY_V5_20_PCS_PCIE_PRESET_P10_POST
register of the pcs_misc register space.

Fixes: 2c91bf6bf290 ("phy: qcom-qmp: Add SM8450 PCIe1 PHY support")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20221102081835.41892-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           | 1 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 3c5c4a4412e0..5a17cda1a6b8 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1308,6 +1308,7 @@ static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_pcs_misc_tbl[] = {
 static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_rc_pcs_misc_tbl[] = {
 	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_PCIE_ENDPOINT_REFCLK_DRIVE, 0xc1),
 	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_PCIE_OSC_DTCT_ACTIONS, 0x00),
+	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_PCIE_PRESET_P10_POST, 0x00),
 };
 
 static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_ep_serdes_tbl[] = {
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h
index c9fa90b45475..3d9713d348fe 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h
@@ -11,6 +11,7 @@
 #define QPHY_V5_20_PCS_PCIE_OSC_DTCT_MODE2_CONFIG5	0x084
 #define QPHY_V5_20_PCS_PCIE_OSC_DTCT_ACTIONS		0x090
 #define QPHY_V5_20_PCS_PCIE_EQ_CONFIG1			0x0a0
+#define QPHY_V5_20_PCS_PCIE_PRESET_P10_POST		0x0e0
 #define QPHY_V5_20_PCS_PCIE_G4_EQ_CONFIG5		0x108
 #define QPHY_V5_20_PCS_PCIE_G4_PRE_GAIN			0x15c
 #define QPHY_V5_20_PCS_PCIE_RX_MARGINING_CONFIG3	0x184
-- 
2.35.1



