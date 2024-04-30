Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C218801;
	Tue, 30 Apr 2024 11:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475633; cv=none; b=l2zAo8Dm29FW7wc65VPkIIPlL/Ib/vV8Isc/IjJMtCOlJGWOVxyvPamk4jiKrjafRkh0ngTDOkeznLnYCay6p8CN/8QjWvKrwOGsvOJEGz4Q/rB7TYl7ctoJMNZMMRjskDgA+zxSt/krE9ujVgGJFodXAbo1LTalvHoERSUxupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475633; c=relaxed/simple;
	bh=M/Ds26Z4aKvkQTGw6muPw+t2cIwLklUDqwxWc/fMbOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJWwSAOaJQKqi9ij1LQH9Ok2ta+j6L1p1emz58oi54GliN057SbD+OUK+KavV7BUYZyCYRqC/FZ5Bf1aylk5k5DGTwcQeWMJEpzpefLVguJGTzsOj260dSeaujVdfSOgPUw64oS0MduX4OXerwTqukHhoMzV1s+9Bzatclvs/hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbzG4nMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbzG4nMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C151C2BBFC;
	Tue, 30 Apr 2024 11:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475632;
	bh=M/Ds26Z4aKvkQTGw6muPw+t2cIwLklUDqwxWc/fMbOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbzG4nMMsTPzsHuXYwV8WS8r43f5cBZbElj9qHR9C8BHFeZNqJ2HFfes4EMufO4et
	 iAiJav7UJn+K7++Gz4394wWPcMpZJ0QKkHpt0940aMHJArXncgb4NIdoT15H0iLpRB
	 jiNj21wFSPJk6wSa1h0WTTIuhXzVmSIkC8/mwSEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 155/186] phy: qcom: qmp-combo: Fix VCO div offset on v3
Date: Tue, 30 Apr 2024 12:40:07 +0200
Message-ID: <20240430103102.534129531@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

commit 5abed58a8bde6d349bde364a160510b5bb904d18 upstream.

Commit ec17373aebd0 ("phy: qcom: qmp-combo: extract common function to
setup clocks") changed the offset that is used to write to
DP_PHY_VCO_DIV from QSERDES_V3_DP_PHY_VCO_DIV to
QSERDES_V4_DP_PHY_VCO_DIV. Unfortunately, this offset is different
between v3 and v4 phys:

 #define QSERDES_V3_DP_PHY_VCO_DIV                 0x064
 #define QSERDES_V4_DP_PHY_VCO_DIV                 0x070

meaning that we write the wrong register on v3 phys now. Add another
generic register to 'regs' and use it here instead of a version specific
define to fix this.

This was discovered after Abhinav looked over register dumps with me
from sc7180 Trogdor devices that started failing to light up the
external display with v6.6 based kernels. It turns out that some
monitors are very specific about their link clk frequency and if the
default power on reset value is still there the monitor will show a
blank screen or a garbled display. Other monitors are perfectly happy to
get a bad clock signal.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: ec17373aebd0 ("phy: qcom: qmp-combo: extract common function to setup clocks")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240404234345.1446300-1-swboyd@chromium.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -112,6 +112,7 @@ enum qphy_reg_layout {
 	QPHY_COM_BIAS_EN_CLKBUFLR_EN,
 
 	QPHY_DP_PHY_STATUS,
+	QPHY_DP_PHY_VCO_DIV,
 
 	QPHY_TX_TX_POL_INV,
 	QPHY_TX_TX_DRV_LVL,
@@ -137,6 +138,7 @@ static const unsigned int qmp_v3_usb3phy
 	[QPHY_COM_BIAS_EN_CLKBUFLR_EN]	= QSERDES_V3_COM_BIAS_EN_CLKBUFLR_EN,
 
 	[QPHY_DP_PHY_STATUS]		= QSERDES_V3_DP_PHY_STATUS,
+	[QPHY_DP_PHY_VCO_DIV]		= QSERDES_V3_DP_PHY_VCO_DIV,
 
 	[QPHY_TX_TX_POL_INV]		= QSERDES_V3_TX_TX_POL_INV,
 	[QPHY_TX_TX_DRV_LVL]		= QSERDES_V3_TX_TX_DRV_LVL,
@@ -161,6 +163,7 @@ static const unsigned int qmp_v45_usb3ph
 	[QPHY_COM_BIAS_EN_CLKBUFLR_EN]	= QSERDES_V4_COM_BIAS_EN_CLKBUFLR_EN,
 
 	[QPHY_DP_PHY_STATUS]		= QSERDES_V4_DP_PHY_STATUS,
+	[QPHY_DP_PHY_VCO_DIV]		= QSERDES_V4_DP_PHY_VCO_DIV,
 
 	[QPHY_TX_TX_POL_INV]		= QSERDES_V4_TX_TX_POL_INV,
 	[QPHY_TX_TX_DRV_LVL]		= QSERDES_V4_TX_TX_DRV_LVL,
@@ -2059,6 +2062,7 @@ static int qmp_combo_configure_dp_clocks
 	const struct phy_configure_opts_dp *dp_opts = &qmp->dp_opts;
 	u32 phy_vco_div;
 	unsigned long pixel_freq;
+	const struct qmp_phy_cfg *cfg = qmp->cfg;
 
 	switch (dp_opts->link_rate) {
 	case 1620:
@@ -2081,7 +2085,7 @@ static int qmp_combo_configure_dp_clocks
 		/* Other link rates aren't supported */
 		return -EINVAL;
 	}
-	writel(phy_vco_div, qmp->dp_dp_phy + QSERDES_V4_DP_PHY_VCO_DIV);
+	writel(phy_vco_div, qmp->dp_dp_phy + cfg->regs[QPHY_DP_PHY_VCO_DIV]);
 
 	clk_set_rate(qmp->dp_link_hw.clk, dp_opts->link_rate * 100000);
 	clk_set_rate(qmp->dp_pixel_hw.clk, pixel_freq);


