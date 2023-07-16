Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBE48F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10471C433C8;
	Sun, 16 Jul 2023 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539936;
	bh=fZI2YVi74VfGt0SxCK5DD5vr4P0BUefiWmPvogBF+dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4oW5yuO9T/hOVxZJKoDHWWxB/tNVdzAMB02aFhm/XTUw2l73G2VMF40wSO0Nvi0Q
	 Yta5Jc9NRbdgZHiUZRgd6fBjMwOEgDiKvxVihJ6fIvWza6Oxu12jEBJ6LW53X5FCQN
	 9eHqwohEMsXxmGAdKQ510HmCqiKLbWDA2TDdx/sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/591] drm/msm/dsi: dont allow enabling 14nm VCO with unprogrammed rate
Date: Sun, 16 Jul 2023 21:45:23 +0200
Message-ID: <20230716194928.626928394@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 0f8f4ca464291..f0780c40b379a 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -539,6 +539,9 @@ static int dsi_pll_14nm_vco_prepare(struct clk_hw *hw)
 	if (unlikely(pll_14nm->phy->pll_on))
 		return 0;
 
+	if (dsi_pll_14nm_vco_recalc_rate(hw, VCO_REF_CLK_RATE) == 0)
+		dsi_pll_14nm_vco_set_rate(hw, pll_14nm->phy->cfg->min_pll_rate, VCO_REF_CLK_RATE);
+
 	dsi_phy_write(base + REG_DSI_14nm_PHY_PLL_VREF_CFG1, 0x10);
 	dsi_phy_write(cmn_base + REG_DSI_14nm_PHY_CMN_PLL_CNTRL, 1);
 
-- 
2.39.2



