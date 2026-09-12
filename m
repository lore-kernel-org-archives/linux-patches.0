Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D75E28B4FA;
	Sat, 12 Sep 2026 08:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203212; cv=none; b=cf1uLo6IyWD4fLHfc2swLhhRNgbsTn85k68WldOXqIWcuWczGiS606ssUnhF5Y6AmJ/3QAJRwLbDXrmCpGfb3mZ5uEjZpVKE0Q1p5b2CelBRtofpSJzf8unAGfoxj2LuilymHuVekdNkr78WvQFRcE696V5GN2rySxWH7rGX95c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203212; c=relaxed/simple;
	bh=uaDwE5aV3HLtK7MCDUuEqY9NZ1FdN5eNpkmBmBDOpXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE4Lo6NR4o9UhMuH1+G4gnvPG+IGJaQ7QiNS5Pm5NSsq835FT+SufKuKGfw/WrIJJDPvsnbSZrsDz5yJyhZ2MXC/mkQfJRz7/+G9uEosRUER2vvu1fc8rY0c5DXmI78PeZ4i53M2C6K4VRxnwMCAANAI5laGISM/SrrAaZyChbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTwx6rBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTwx6rBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219C61F000FF;
	Sat, 12 Sep 2026 08:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203211;
	bh=kc3ZtU4ywhScsYLUNWo+giwVXG0j3/5KFN0OgYHLIf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTwx6rBHJnBCCtGe+I75JphNnKXf267c23Hp3Db9Tb5PO/pMZoan/8PGPThWB95E1
	 Uys9K8PeaOjO0tV4dfEiOMYQdABD95tJ9DYKHg2P18TEACJr/JuvKlr1TygMQ3HV1+
	 haanYMDyvBAkdowrF1EIqEgTZeo3qqHmkhDFf/H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Diederik de Haas <diederik@cknow-tech.com>
Subject: [PATCH 7.2 1361/1815] phy: rockchip: samsung-hdptx: Prevent divide-by-zero when computing clk rate
Date: Sat, 12 Sep 2026 08:51:51 +0200
Message-ID: <20260912065720.979160970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit c4fe5a9f379055ce0ec930f6495ae62aad237b89 ]

Calculating 'sdm' fraction in rk_hdptx_phy_clk_calc_rate_from_pll_cfg()
could trigger a divide-by-zero, as it uses div_u64() with a denominator
read directly from hardware: the values ropll_hw.sdm_deno,
ropll_hw.sdc_deno, ropll_hw.sdc_n, and ropll_hw.sdc_num are populated
from PLL registers which, in theory, could be left by the bootloader
uninitialized/misconfigured.

Provide the necessary sanitization to avoid trusting the hardware state.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611-hdptx-clk-fixes-v3-0-67b1b0c00e16@collabora.com?part=1
Fixes: 3481fc04d969 ("phy: rockchip: samsung-hdptx: Compute clk rate from PLL config")
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # NanoPC-T6 LTS
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260811-hdptx-clk-fixes-v6-2-75bca0ee5753@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/rockchip/phy-rockchip-samsung-hdptx.c    | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 710603afff866..d67ced2bf7b2c 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -2270,10 +2270,20 @@ static u64 rk_hdptx_phy_clk_calc_rate_from_pll_cfg(struct rk_hdptx_phy *hdptx)
 
 	fout = PLL_REF_CLK * ropll_hw.pms_mdiv;
 	if (ropll_hw.sdm_en) {
+		val = 16U * ropll_hw.sdm_deno *
+		      (ropll_hw.sdc_deno * ropll_hw.sdc_n - ropll_hw.sdc_num);
+		if (!val) {
+			/*
+			 * The PLL config currently stored in hardware can't be
+			 * translated into a rate. The next .set_rate() should
+			 * program a valid configuration and help with recovery.
+			 */
+			dev_dbg(hdptx->dev, "Invalid ROPLL hw state: deno == 0\n");
+			return 0;
+		}
+
 		sdm = div_u64(PLL_REF_CLK * ropll_hw.sdc_deno *
-			      ropll_hw.pms_mdiv * ropll_hw.sdm_num,
-			      16 * ropll_hw.sdm_deno *
-			      (ropll_hw.sdc_deno * ropll_hw.sdc_n - ropll_hw.sdc_num));
+			      ropll_hw.pms_mdiv * ropll_hw.sdm_num, val);
 
 		if (ropll_hw.sdm_num_sign)
 			fout = fout - sdm;
-- 
2.53.0



