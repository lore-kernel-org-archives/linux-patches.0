Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD25168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F9AC433D2;
	Mon,  8 May 2023 10:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542799;
	bh=Nwaio/23MqfKrZO9fQsnLuwnbQdnJwY5dXcd/I5cMGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjZRzqi+iPBkQ+58RghXVbF3PSRBi8lwo7Zlq7oq0mEHpetJWtM8Qf/qRmjU3hsn+
	 sfDD57DoP+kauENZtqefzASjSns5T32cX0JzEbhBl9o+rHZiY8woi4bZ6IjuPDSV7y
	 0MkjTy83VahntA4hQBTQ8tqEn5p2hRh+THerLpGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 551/663] clk: imx: fracn-gppll: disable hardware select control
Date: Mon,  8 May 2023 11:46:17 +0200
Message-Id: <20230508094446.946245764@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 4435467b15b069e5a6f50ca9a9260e86b74dbc13 ]

When programming PLL, should disable Hardware control select to make PLL
controlled by register, not hardware inputs through OSCPLL.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230403095300.3386988-3-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index ec50c41e2a4c9..f6674110a88e0 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -15,6 +15,7 @@
 #include "clk.h"
 
 #define PLL_CTRL		0x0
+#define HW_CTRL_SEL		BIT(16)
 #define CLKMUX_BYPASS		BIT(2)
 #define CLKMUX_EN		BIT(1)
 #define POWERUP_MASK		BIT(0)
@@ -193,6 +194,11 @@ static int clk_fracn_gppll_set_rate(struct clk_hw *hw, unsigned long drate,
 
 	rate = imx_get_pll_settings(pll, drate);
 
+	/* Hardware control select disable. PLL is control by register */
+	tmp = readl_relaxed(pll->base + PLL_CTRL);
+	tmp &= ~HW_CTRL_SEL;
+	writel_relaxed(tmp, pll->base + PLL_CTRL);
+
 	/* Disable output */
 	tmp = readl_relaxed(pll->base + PLL_CTRL);
 	tmp &= ~CLKMUX_EN;
-- 
2.39.2



