Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8072A1D27BD;
	Wed,  2 Oct 2024 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879849; cv=none; b=XSmOHqO9OHT01o/Ic63q1vOpkwGuVzdFZuzueJMKRKhnCBOzUY7nuVZhAFlLnQl0YDkO9o7EtCYQ08ktPOWwyOXG3uRs3hbF3MXO0CVd0UqTOp/WJ8bSyPK6i5pHp2zEtkEWk8gID7ua8ey2IoUloU5AvxdFKumfgEziASZZWIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879849; c=relaxed/simple;
	bh=FyzSik51FE1MxkqFc/tVLykKIdvoY08INVWuC2GzOv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJYbzefIw97AJTpG1Q/8X0dV8XUM0tzLoc3rvZlc2RVSEh0KxzxS7PooVHnofoxBMJgnKHo3ymiKwtHNfcsuhl9udR7OpBw38syOSP8dUQ68D6Z40CkeMFgIoSfZQBGt4/wlLZipnZHhPpz1bcd+h3O6mmKouWX+eqpdfIwDMAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfPsldkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfPsldkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D98C4CEC2;
	Wed,  2 Oct 2024 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879849;
	bh=FyzSik51FE1MxkqFc/tVLykKIdvoY08INVWuC2GzOv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfPsldkxLalAaUoJSAwf2HTwh6mlG//sb4RoPf9V8aTd0JYLnQEkg1E771bXAWws9
	 qJuvUoS61PcnV4QQbPROflnX5+mr9vU30Pud2Mbtpz/YUH3hdmM3FRhvgH9cahQpJ1
	 WtXVAm0aq+3/SlBZoXDPDL4ullGRUO1tbrPipq+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastien Laveze <slaveze@smartandconnective.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/538] clk: imx: imx6ul: fix default parent for enet*_ref_sel
Date: Wed,  2 Oct 2024 14:58:17 +0200
Message-ID: <20241002125802.441338443@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Sebastien Laveze <slaveze@smartandconnective.com>

[ Upstream commit e52fd71333b4ed78fd5bb43094bdc46476614d25 ]

The clk_set_parent for "enet1_ref_sel" and  "enet2_ref_sel" are
incorrect, therefore the original requirements to have "enet_clk_ref" as
output sourced by iMX ENET PLL as a default config is not met.

Only "enet[1,2]_ref_125m" "enet[1,2]_ref_pad" are possible parents for
"enet1_ref_sel" and "enet2_ref_sel".

This was observed as a regression using a custom device tree which was
expecting this default config.

This can be fixed at the device tree level but having a default config
matching the original behavior (before refclock mux) will avoid breaking
existing configs.

Fixes: 4e197ee880c2 ("clk: imx6ul: add ethernet refclock mux support")
Link: https://lore.kernel.org/lkml/20230306020226.GC143566@dragon/T/
Signed-off-by: Sebastien Laveze <slaveze@smartandconnective.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20240528151434.227602-1-slaveze@smartandconnective.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6ul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
index f9394e94f69d7..05c7a82b751f3 100644
--- a/drivers/clk/imx/clk-imx6ul.c
+++ b/drivers/clk/imx/clk-imx6ul.c
@@ -542,8 +542,8 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 
 	clk_set_parent(hws[IMX6UL_CLK_ENFC_SEL]->clk, hws[IMX6UL_CLK_PLL2_PFD2]->clk);
 
-	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET_REF]->clk);
-	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF]->clk);
+	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET1_REF_125M]->clk);
+	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF_125M]->clk);
 
 	imx_register_uart_clocks();
 }
-- 
2.43.0



