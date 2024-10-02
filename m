Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6890C1D0799;
	Wed,  2 Oct 2024 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878224; cv=none; b=k9+jw8VEQbOqoQq2kZ4TzRniKlK0sKRbJ32R8CqCLVbtADVBVwURrDSxNrler+o91M3APrqt1NCmS3VQsDX8vcJAcV9SapnohGqflnzdoi6AcqPwm5+t0ZOscQ4b7DXlGfrcB39fwEQT/vXExaEdzcNv6ekE5xtTakH8+bF1Bko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878224; c=relaxed/simple;
	bh=rYzOHMU4oTQBonYggbjrVSCEGSx9QWeo3dKzVxdbH7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIVJVBk54MMKDHADQjpcT/E+vLNyfUdKFpxMjaw86WksxeeukNu5pL24wK5gh5luGVL/VsOg688Pc+WyR0Q4KIHU1c0K75XHT2JIb18y+F2mwxXGwZtAaFsYcNYpmMgKUWcY1qIIyQ3sK4dxbQndPiFte5ADEkbOkupt3k5f3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NL0wFVia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NL0wFVia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FA0C4CEC2;
	Wed,  2 Oct 2024 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878224;
	bh=rYzOHMU4oTQBonYggbjrVSCEGSx9QWeo3dKzVxdbH7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NL0wFViaAUxzmWWKYF5x7LIWGbpH+IHkcb9SKY0vgPjWWDGyOrMd2tKW3K5CKy1PZ
	 Eqxk2S/CyVDzCJeW4BNidobwxEL9d+a9N7EcCy7oVaNBx7J70R0OWbuOB/XdxOxCQU
	 +zuK/5M9TI3KBxHM2jxBnU5pf6KiDhbqI5rRe7ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastien Laveze <slaveze@smartandconnective.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 309/634] clk: imx: imx6ul: fix default parent for enet*_ref_sel
Date: Wed,  2 Oct 2024 14:56:49 +0200
Message-ID: <20241002125823.304861111@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



