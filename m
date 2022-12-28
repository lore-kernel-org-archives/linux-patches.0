Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F51C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA87C433EF;
	Wed, 28 Dec 2022 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244724;
	bh=IyrntQKuf7TDG7H4RdY3zYDDX97jtif1m/HabaYSVMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMGtfrHuj/mosl/211GClinJxe0IKTCAkw5ZuUeeilGXUTNW9vTYLKT1Y/5BjJAPL
	 R/ynqQE73wrDgpeK+Zfi/X0GOUg6bYO7WN7oEtTgX8udAAPSrD6/IS1GN6ntm4ZXBI
	 igK/66DtIjfldkPeGxVHfFQ7N+Fa9g5l6+X/WDAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0763/1073] phy: qcom-qmp-pcie: drop bogus register update
Date: Wed, 28 Dec 2022 15:39:11 +0100
Message-Id: <20221228144348.738683356@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 2d93887cb4bac0a36ce9e146956f631ab7994680 ]

Since commit 0d58280cf1e6 ("phy: Update PHY power control sequence") the
PHY is powered on before configuring the registers and only the MSM8996
PCIe PHY, which includes the POWER_DOWN_CONTROL register in its PCS
initialisation table, may possibly require a second update afterwards.

To make things worse, the POWER_DOWN_CONTROL register lies at a
different offset on more recent SoCs so that the second update, which
still used a hard-coded offset, would write to an unrelated register
(e.g. a revision-id register on SC8280XP).

As the MSM8996 PCIe PHY is now handled by a separate driver, simply drop
the bogus register update.

Fixes: e4d8b05ad5f9 ("phy: qcom-qmp: Use proper PWRDOWN offset for sm8150 USB") added support
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> #RB3
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221017065013.19647-12-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 2d65e1f56bfc..6d790f2107f5 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -2077,12 +2077,6 @@ static int qcom_qmp_phy_pcie_power_on(struct phy *phy)
 		qcom_qmp_phy_pcie_configure(pcs_misc, cfg->regs, cfg->pcs_misc_tbl_sec,
 				       cfg->pcs_misc_tbl_num_sec);
 
-	/*
-	 * Pull out PHY from POWER DOWN state.
-	 * This is active low enable signal to power-down PHY.
-	 */
-	qphy_setbits(pcs, QPHY_V2_PCS_POWER_DOWN_CONTROL, cfg->pwrdn_ctrl);
-
 	if (cfg->has_pwrdn_delay)
 		usleep_range(cfg->pwrdn_delay_min, cfg->pwrdn_delay_max);
 
-- 
2.35.1



