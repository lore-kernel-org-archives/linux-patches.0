Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DCF8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD367C433C7;
	Sun, 16 Jul 2023 20:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538237;
	bh=+O83bj+OgGfJNcvFRWT3rtQQoG1STKcRYVTC0J7wuKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJznwIYiQhGgh/S+8FmxEvnPvdzCiHy6YBjTo2FIl820EK5Q3mnP/l1IrsA310ONw
	 bxT/COS5/a4bYfWmKFV1vj2ce5CLzbgt69Noo8tukeafFBDV/P364bphGWxc9H3aGt
	 NBVexJccSpFYrS5h1nw3Q3HDF3JdSLKHVx4oCaec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Fabio Estevam <festevam@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 378/800] clk: imx: composite-8m: Add imx8m_divider_determine_rate
Date: Sun, 16 Jul 2023 21:43:51 +0200
Message-ID: <20230716194957.854868113@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 8208181fe536bba3b411508f81c4426fc9c71d9a ]

Currently, certain clocks are derrived as a divider from their
parent clock.  For some clocks, even when CLK_SET_RATE_PARENT
is set, the parent clock is not properly set which can lead
to some relatively inaccurate clock values.

Unlike imx/clk-composite-93 and imx/clk-divider-gate, it
cannot rely on calling a standard determine_rate function,
because the 8m composite clocks have a pre-divider and
post-divider. Because of this, a custom determine_rate
function is necessary to determine the maximum clock
division which is equivalent to pre-divider * the
post-divider.

With this added, the system can attempt to adjust the parent rate
when the proper flags are set which can lead to a more precise clock
value.

On the imx8mplus, no clock changes are present.
On the Mini and Nano, this can help achieve more accurate
lcdif clocks. When trying to get a pixel clock of 31.500MHz
on an imx8m Nano, the clocks divided the 594MHz down, but
left the parent rate untouched which caused a calulation error.

Before:
video_pll              594000000
  video_pll_bypass     594000000
    video_pll_out      594000000
      disp_pixel       31263158
        disp_pixel_clk 31263158

Variance = -236842 Hz

After this patch:
video_pll               31500000
  video_pll_bypass      31500000
    video_pll_out       31500000
      disp_pixel        31500000
        disp_pixel_clk  31500000

Variance = 0 Hz

All other clocks rates and parent were the same.
Similar results on imx8mm were found.

Fixes: 690dccc4a0bf ("Revert "clk: imx: composite-8m: Add support to determine_rate"")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20230506195325.876871-1-aford173@gmail.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-8m.c | 31 ++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/clk/imx/clk-composite-8m.c b/drivers/clk/imx/clk-composite-8m.c
index cbf0d7955a00a..7a6e3ce97133b 100644
--- a/drivers/clk/imx/clk-composite-8m.c
+++ b/drivers/clk/imx/clk-composite-8m.c
@@ -119,10 +119,41 @@ static int imx8m_clk_composite_divider_set_rate(struct clk_hw *hw,
 	return ret;
 }
 
+static int imx8m_divider_determine_rate(struct clk_hw *hw,
+				      struct clk_rate_request *req)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	int prediv_value;
+	int div_value;
+
+	/* if read only, just return current value */
+	if (divider->flags & CLK_DIVIDER_READ_ONLY) {
+		u32 val;
+
+		val = readl(divider->reg);
+		prediv_value = val >> divider->shift;
+		prediv_value &= clk_div_mask(divider->width);
+		prediv_value++;
+
+		div_value = val >> PCG_DIV_SHIFT;
+		div_value &= clk_div_mask(PCG_DIV_WIDTH);
+		div_value++;
+
+		return divider_ro_determine_rate(hw, req, divider->table,
+						 PCG_PREDIV_WIDTH + PCG_DIV_WIDTH,
+						 divider->flags, prediv_value * div_value);
+	}
+
+	return divider_determine_rate(hw, req, divider->table,
+				      PCG_PREDIV_WIDTH + PCG_DIV_WIDTH,
+				      divider->flags);
+}
+
 static const struct clk_ops imx8m_clk_composite_divider_ops = {
 	.recalc_rate = imx8m_clk_composite_divider_recalc_rate,
 	.round_rate = imx8m_clk_composite_divider_round_rate,
 	.set_rate = imx8m_clk_composite_divider_set_rate,
+	.determine_rate = imx8m_divider_determine_rate,
 };
 
 static u8 imx8m_clk_composite_mux_get_parent(struct clk_hw *hw)
-- 
2.39.2



