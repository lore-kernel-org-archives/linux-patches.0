Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9753395266;
	Tue, 21 Jul 2026 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659317; cv=none; b=GCDjyeSKZKiBNHA9QVYywtX5yH5eSJPeKxNg00FVkRXeIl4FQ0aYsR8RImvGjynWY3DCADL3/GJj+wm1lVIObYf/IzzfT+0tw88L94d6ntREBSE1kKvHcshdMFakysi7XWCMNJ0m/o0j5ouvg6LIdckurN6jXDTXagwq64S6eJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659317; c=relaxed/simple;
	bh=QiqoKsT1NgGeprOdRqf/qinZKZvBZNaUxB67a/Q//uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6LrAunFlkPeE/F16kEWbA9DgPY/+lityl1+J3g2Om0kMAp0UPH16wz84LXkBZ75cJwlAW2qI5GKB5OpWDjpAHa5aoKTYcP9ap+Jmj/zsCCWKADic03pbM5rTI7gFSOqmP0I1FJxNwmvQsnaJhGucLdZ8MkJGopmu71Tjir8O/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFo47Gef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFo47Gef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B601F00A3A;
	Tue, 21 Jul 2026 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659316;
	bh=Ul8NmfwR2G69TvWSccLN0eFDDbBqPIcBpgqJcW1HRLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFo47GefQw3+kKaCF2wFSmVHKJfNO7ME0H4BexOUFOyzaBqLS+Ctz4xBJenzaOC5I
	 8AVwqRKKzdv0Adxw8MgP1FNblXLa1OPHx/rR5aFv352GlcIV4rCrWawEKYUxtBML+Z
	 RZbU9U1rxPXcI3/A30FATNST4SgCnOTGjHt3taQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1474/1611] pmdomain: imx: Fix i.MX8MP VC8000E power up sequence
Date: Tue, 21 Jul 2026 17:26:30 +0200
Message-ID: <20260721152548.599952328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


