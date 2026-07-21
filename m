Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EED47253D;
	Tue, 21 Jul 2026 20:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664187; cv=none; b=hGWorlpwe0H39m1itkBHaemtYuk8onoIBFEm44b/n2eEaHBfdzR5q4QggV21BP3J4WM5GF2b3js1IJ1hs028Qn7t/9exUs+JQRdj3AmRRsU/wLuOYIwfbB/b0rVlgOV9mTTQijwuzwj14MSx0Ij9AGx6Fd/E5rqFXzGAp6rjo6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664187; c=relaxed/simple;
	bh=6TFztDX3pLpEo62caM7q6Uky6cmNFTgqmMciurHH0aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qngxfm7DQU/QkDCmmPmvT+zDJr+as5T8njG/Rl+7wGhALADABS5qmDuQgnUiYmLUgePxGyw2HCfTgiMgkqKGhMkKJ8MgAMScj9JtdFukb/BppyVLFNJZgTnp5MqWn10Rw9a+zxI1LCuHcolNsRXfhhRGRqvIn1zIc3sNDEf9Rhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypBv+xKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypBv+xKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4A51F000E9;
	Tue, 21 Jul 2026 20:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664186;
	bh=WQgSzUKnj4aXYXdtZJ2HOqF7Bpo5236na3GqZf0LGcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypBv+xKmrtlz9eZ1zMJE63KQaoPyFpBaxemtTiHxk3k2Pb0ymZPyXPGM9aEG4qKUz
	 mgLQIxs0A0H038FzhCarWBPzxmGhrzotE/x+qfnsKMBsJGFCwBhMZ7QI+fqIuDfTUB
	 dSugooQ0MQ8yhPDxYFMAJTzs+O+sCpzaNtHVZ4G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 1103/1276] pmdomain: imx: Fix i.MX8MP VC8000E power up sequence
Date: Tue, 21 Jul 2026 17:25:46 +0200
Message-ID: <20260721152510.674593117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

commit 25e252bcf1593b420b12a7231d9dd64b885a2ae2 upstream.

Per errata[1]:
ERR050531: VPU_NOC power down handshake may hang during VC8000E/VPUMIX
power up/down cycling.
Description: VC8000E reset de-assertion edge and AXI clock may have a
timing issue.
Workaround: Set bit2 (vc8000e_clk_en) of BLK_CLK_EN_CSR to 0 to gate off
both AXI clock and VC8000E clock sent to VC8000E and AXI clock sent to
VPU_NOC m_v_2 interface during VC8000E power up(VC8000E reset is
de-asserted by HW)

Add a bool variable is_errata_err050531 in
'struct imx8m_blk_ctrl_domain_data' to represent whether the workaround
is needed. If is_errata_err050531 is true, first clear the clk before
powering up gpc, then enable the clk after powering up gpc.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MP_1P33A

Fixes: a1a5f15f7f6cb ("soc: imx: imx8m-blk-ctrl: add i.MX8MP VPU blk ctrl")
Cc: stable@vger.kernel.org
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8m-blk-ctrl.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -54,6 +54,15 @@ struct imx8m_blk_ctrl_domain_data {
 	 * register.
 	 */
 	u32 mipi_phy_rst_mask;
+
+	/*
+	 * VC8000E reset de-assertion edge and AXI clock may have a timing issue.
+	 * Workaround: Set bit2 (vc8000e_clk_en) of BLK_CLK_EN_CSR to 0 to gate off
+	 * both AXI clock and VC8000E clock sent to VC8000E and AXI clock sent to
+	 * VPU_NOC m_v_2 interface during VC8000E power up(VC8000E reset is
+	 * de-asserted by HW)
+	 */
+	bool is_errata_err050531;
 };
 
 #define DOMAIN_MAX_CLKS 4
@@ -108,7 +117,11 @@ static int imx8m_blk_ctrl_power_on(struc
 		dev_err(bc->dev, "failed to enable clocks\n");
 		goto bus_put;
 	}
-	regmap_set_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
+
+	if (data->is_errata_err050531)
+		regmap_clear_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
+	else
+		regmap_set_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
 
 	/* power up upstream GPC domain */
 	ret = pm_runtime_get_sync(domain->power_dev);
@@ -117,6 +130,9 @@ static int imx8m_blk_ctrl_power_on(struc
 		goto clk_disable;
 	}
 
+	if (data->is_errata_err050531)
+		regmap_set_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
+
 	/* wait for reset to propagate */
 	udelay(5);
 
@@ -511,6 +527,7 @@ static const struct imx8m_blk_ctrl_domai
 		.clk_mask = BIT(2),
 		.path_names = (const char *[]){"vc8000e"},
 		.num_paths = 1,
+		.is_errata_err050531 = true,
 	},
 };
 


