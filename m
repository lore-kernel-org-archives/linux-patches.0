Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C059256C6C;
	Wed, 25 Feb 2026 01:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983394; cv=none; b=eSP/dzKgB2BmfYKuW+8ym7orwaeDJ2RLFZx5m/Trd9KAuIqi1EUsi44+B2hCR555jD7gN9Z0Znv8wOgU0Gfb8matdF1QLaa1NhysxkkNn4taHmJ8F4MbUsN513VnVhYmIk4ZmLDz2fPpZB8IXkpvARh8H9uy4IvUIH3ufsB0OJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983394; c=relaxed/simple;
	bh=0P57qqbAfslKg/ZHYk+5ckkFS074O3sTwm143HKmGEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULqKgo9hrCca+E2fPMPOGfdMdIAg4MqgOhS1tiNnQE2J7+OD7F1Hhz+/vPfrvxxjnqrnTnHOLSucNgwTnxTBbgT9rMuGMd895mYJdwJuBZ7OkEVV9ZyKwO3v55+qE39VksBCfSRGBlJGmib85vQhpq+w2XCqgMoCGREwxMjEcMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjAqCCln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjAqCCln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9ADC116D0;
	Wed, 25 Feb 2026 01:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983394;
	bh=0P57qqbAfslKg/ZHYk+5ckkFS074O3sTwm143HKmGEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjAqCClnqBZMstawFIyh3voUPjhsK2TFlLqVj63825U7cHr+YItIAAHq/o0xq51Rr
	 vp5HdtCeLJu+wSHDVgx2CyzEbtBBKqrWQOymvLpHFB3KUkwXNcj+Y9ImvmCr6U/Utx
	 D51g+8xHOoK8ojSUGlBPuk/oSDpk08CDoQ3B6bb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 516/781] clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs
Date: Tue, 24 Feb 2026 17:20:25 -0800
Message-ID: <20260225012412.460359922@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 5b1a43950fd3162af0ce52b13c14a2d29b179d4f ]

GXBB has the HDMI PLL OD in the HHI_HDMI_PLL_CNTL2 register while for
GXL/GXM the OD has moved to HHI_HDMI_PLL_CNTL3. At first glance the rest
of the OD setup seems identical.

However, looking at the downstream kernel sources as well as testing
shows that GXL only supports three OD values:
- register value 0 means: divide by 1
- register value 1 means: divide by 2
- register value 2 means: divide by 4

Using register value 3 (which on GXBB means: divide by 8) still divides
by 4 as verified using meson-clk-measure. Downstream sources are also
only using OD register values 0, 1 and 2 for GXL (while for GXBB the
downstream kernel sources are also using value 3).

Add clk_div_table and have it replace the CLK_DIVIDER_POWER_OF_TWO flag
to make the kernel's view of this register match with how the hardware
actually works.

Fixes: 69d92293274b ("clk: meson: add the gxl hdmi pll")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20260105204710.447779-2-martin.blumenstingl@googlemail.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index 5a229c4ffae10..ec9a3414875ac 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -349,12 +349,23 @@ static struct clk_regmap gxbb_hdmi_pll = {
 	},
 };
 
+/*
+ * GXL hdmi OD dividers are POWER_OF_TWO dividers but limited to /4.
+ * A divider value of 3 should map to /8 but instead map /4 so ignore it.
+ */
+static const struct clk_div_table gxl_hdmi_pll_od_div_table[] = {
+	{ .val = 0, .div = 1 },
+	{ .val = 1, .div = 2 },
+	{ .val = 2, .div = 4 },
+	{ /* sentinel */ }
+};
+
 static struct clk_regmap gxl_hdmi_pll_od = {
 	.data = &(struct clk_regmap_div_data){
 		.offset = HHI_HDMI_PLL_CNTL + 8,
 		.shift = 21,
 		.width = 2,
-		.flags = CLK_DIVIDER_POWER_OF_TWO,
+		.table = gxl_hdmi_pll_od_div_table,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "hdmi_pll_od",
@@ -372,7 +383,7 @@ static struct clk_regmap gxl_hdmi_pll_od2 = {
 		.offset = HHI_HDMI_PLL_CNTL + 8,
 		.shift = 23,
 		.width = 2,
-		.flags = CLK_DIVIDER_POWER_OF_TWO,
+		.table = gxl_hdmi_pll_od_div_table,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "hdmi_pll_od2",
@@ -390,7 +401,7 @@ static struct clk_regmap gxl_hdmi_pll = {
 		.offset = HHI_HDMI_PLL_CNTL + 8,
 		.shift = 19,
 		.width = 2,
-		.flags = CLK_DIVIDER_POWER_OF_TWO,
+		.table = gxl_hdmi_pll_od_div_table,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "hdmi_pll",
-- 
2.51.0



