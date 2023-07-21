Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90031F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB461C433CB;
	Fri, 21 Jul 2023 18:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965814;
	bh=kZDn3Va//mtWou/Bb/sdsIEn7L7sxuQsvevr1LCkYBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek/jzwr/tYXX6i4x0WH5mIkvANbd52yI/kK1SQWzmcgNA5FIhj2pGlPTlryYICcu8
	 S/GQ3FuTxssli6L2i8O5Ub8KTryQTiRVyrDJ8RvR9zw5EEhJo8IibNDfCOlPi3Np+9
	 tWwVsxiwgUqsrqFp01UdFyvw/D7sIgBg3veyhPcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/532] drm/msm/dsi: dont allow enabling 14nm VCO with unprogrammed rate
Date: Fri, 21 Jul 2023 18:00:27 +0200
Message-ID: <20230721160621.146102029@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1e0a97f84d73ea1182740f62069690c7f3271abb ]

If the dispcc uses CLK_OPS_PARENT_ENABLE (e.g. on QCM2290), CCF can try
enabling VCO before the rate has been programmed. This can cause clock
lockups and/or other boot issues. Program the VCO to the minimal PLL
rate if the read rate is 0 Hz.

Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reported-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reported-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Fixes: f079f6d999cb ("drm/msm/dsi: Add PHY/PLL for 8x96")
Patchwork: https://patchwork.freedesktop.org/patch/534813/
Link: https://lore.kernel.org/r/20230501011257.3460103-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index 6d3abcdc57bfb..66507eb713048 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -541,6 +541,9 @@ static int dsi_pll_14nm_vco_prepare(struct clk_hw *hw)
 	if (unlikely(pll_14nm->phy->pll_on))
 		return 0;
 
+	if (dsi_pll_14nm_vco_recalc_rate(hw, VCO_REF_CLK_RATE) == 0)
+		dsi_pll_14nm_vco_set_rate(hw, pll_14nm->phy->cfg->min_pll_rate, VCO_REF_CLK_RATE);
+
 	dsi_phy_write(base + REG_DSI_14nm_PHY_PLL_VREF_CFG1, 0x10);
 	dsi_phy_write(cmn_base + REG_DSI_14nm_PHY_CMN_PLL_CNTRL, 1);
 
-- 
2.39.2



