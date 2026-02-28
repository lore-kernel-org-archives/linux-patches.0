Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2514343D64
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301877; cv=none; b=pXSqaXK+6B3IvIz5inuWcJk9tzucwOgUR7C1d1zUwvD3Sb9GJT9ihd7xOBsVikhUcbjzFUGIfDLtqVwHuqHKiBJgfW0jSjqrhdIVjgPPOJXuX3sKhTHoI0s4bZmWafS+f/qAyWKmR2vQhFiA+iF9BzQ7gA5v96pmRoRE+q9CSqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301877; c=relaxed/simple;
	bh=i4kG+f5ivndsEzVJdyw6M77JaHFuHRNdavFuDryfHFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utcWP3W5ObgGfAssdY6BWU3RyuIBlGv6DHd9y6TSrLgKdvuWA4xa6va+XICgPxWez0a8VRAPGqkV7Yti2f3VkZ7TitpFbpnaU+yvPkytsypzqbsKcQw5Q9lgOwEHd1fpvod6Nhk38w5fIurEaUFVb0F2S/TNyPkZdJ9B03wKCYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZsg/iKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZsg/iKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635E7C19423;
	Sat, 28 Feb 2026 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301876;
	bh=i4kG+f5ivndsEzVJdyw6M77JaHFuHRNdavFuDryfHFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZsg/iKMUEQ+Ho2uE6AevKtY5Mej7JvFcGmVae3kqTnSFITK9S72Yx1sNbo1WjE7Q
	 YgxTaf0dFrlE9OZfV/hTkv8IwYF6OmFjTTSJNlhMSqQ7qUxH2cso7W9OflYuUCx+ZE
	 kHpVykCHSnUgYpJvn1J+uaMNSlOMMtM54D0xmy++ioaTBHK+TRXB0YE0eagrnd/see
	 LP8aqc8NurJWyMkJk5d4ooeB/cYf8dscW3V5AxmM0ODBne6EqF0Q7JxlmD6mNBBssg
	 FTnRscxDDLWznPV5c4jbnU0/kQ/ePQAakxLE7RuiDd3z3tTmAijIB0NJBUr0A1Jx2G
	 N1/uAxbyRcB/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/385] clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs
Date: Sat, 28 Feb 2026 12:58:44 -0500
Message-ID: <20260228180011.1568201-302-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index d9529de200ae4..2bfb0ab9c93cc 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -318,12 +318,23 @@ static struct clk_regmap gxbb_hdmi_pll = {
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
@@ -341,7 +352,7 @@ static struct clk_regmap gxl_hdmi_pll_od2 = {
 		.offset = HHI_HDMI_PLL_CNTL + 8,
 		.shift = 23,
 		.width = 2,
-		.flags = CLK_DIVIDER_POWER_OF_TWO,
+		.table = gxl_hdmi_pll_od_div_table,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "hdmi_pll_od2",
@@ -359,7 +370,7 @@ static struct clk_regmap gxl_hdmi_pll = {
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

