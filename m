Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDCF2584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02B0C433EF;
	Thu, 23 Feb 2023 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157782;
	bh=FqFJWUAzxIajb3kN1r86rt4j4/zmmP/0XqtS3nOLSfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaEgR0ZY2rBamgZcDCjUyJP4dsac/rX+GDMNSaVihbChm59zHowpCKalDJHYjtKhy
	 dNratAP1eTH1dIrD89k0e+bilO2ZMRu+FwNiVq+QDBNj1EQaZoX1coxJXamB/AjSMO
	 qajExMEuf4XbZCuQ8KO+tO9Q9wA+mBesq87KIrJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi xin Zhu <yzhu@maxlinear.com>,
	Rahul Tanwar <rtanwar@maxlinear.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/46] clk: mxl: Add option to override gate clks
Date: Thu, 23 Feb 2023 14:06:14 +0100
Message-Id: <20230223130431.879751620@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit a5d49bd369b8588c0ee9d4d0a2c0160558a3ab69 ]

In MxL's LGM SoC, gate clocks can be controlled either from CGU clk driver
i.e. this driver or directly from power management driver/daemon. It is
dependent on the power policy/profile requirements of the end product.

To support such use cases, provide option to override gate clks enable/disable
by adding a flag GATE_CLK_HW which controls if these gate clks are controlled
by HW i.e. this driver or overridden in order to allow it to be controlled
by power profiles instead.

Reviewed-by: Yi xin Zhu <yzhu@maxlinear.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/bdc9c89317b5d338a6c4f1d49386b696e947a672.1665642720.git.rtanwar@maxlinear.com
[sboyd@kernel.org: Add braces on many line if-else]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 106ef3bda210 ("clk: mxl: Fix a clk entry by adding relevant flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-cgu.c | 16 +++++++++++++++-
 drivers/clk/x86/clk-cgu.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 1f7e93de67bc0..4278a687076c9 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -354,8 +354,22 @@ int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			hw = lgm_clk_register_fixed_factor(ctx, list);
 			break;
 		case CLK_TYPE_GATE:
-			hw = lgm_clk_register_gate(ctx, list);
+			if (list->gate_flags & GATE_CLK_HW) {
+				hw = lgm_clk_register_gate(ctx, list);
+			} else {
+				/*
+				 * GATE_CLKs can be controlled either from
+				 * CGU clk driver i.e. this driver or directly
+				 * from power management driver/daemon. It is
+				 * dependent on the power policy/profile requirements
+				 * of the end product. To override control of gate
+				 * clks from this driver, provide NULL for this index
+				 * of gate clk provider.
+				 */
+				hw = NULL;
+			}
 			break;
+
 		default:
 			dev_err(ctx->dev, "invalid clk type\n");
 			return -EINVAL;
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 0aa0f35d63a0b..73ce84345f81e 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -197,6 +197,7 @@ struct lgm_clk_branch {
 /* clock flags definition */
 #define CLOCK_FLAG_VAL_INIT	BIT(16)
 #define MUX_CLK_SW		BIT(17)
+#define GATE_CLK_HW		BIT(18)
 
 #define LGM_MUX(_id, _name, _pdata, _f, _reg,		\
 		_shift, _width, _cf, _v)		\
-- 
2.39.0



