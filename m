Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F307522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9683FC433C8;
	Sun,  9 Jul 2023 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901979;
	bh=vronaeFrYtiLz/m9kXnMq07YP/0yhr3afYTjpxAZqOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTE7oO6n0xOoJceVofObivS50CWjlHvRu0e0X0Lc9UNX9C+v8yauShAP8xUcycQXz
	 QA90uq+bEY3r9KqTFlsWmfSCf5svENmpBUPwg4Ts7zVLTrphkrcHJeRtRcowgFcQLl
	 rE36jeSMLOyc4uFV1ISU7Zd74mNJ22h308Hch4r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Marek Vasut <marex@denx.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 184/431] clk: rs9: Add support for 9FGV0441
Date: Sun,  9 Jul 2023 13:12:12 +0200
Message-ID: <20230709111455.492472504@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit e44fdd114cc3c872aa5157c6b3a190bcf92a9ffb ]

This model is similar to 9FGV0241, but the DIFx bits start at bit 0.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20230310075535.3476580-4-alexander.stein@ew.tq-group.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: ad527ca87e4e ("clk: rs9: Fix .driver_data content in i2c_device_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index 0710362b2545b..10d31c222a1cb 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -6,6 +6,7 @@
  *   - 9FGV/9DBV/9DMV/9FGL/9DML/9QXL/9SQ
  * Currently supported:
  *   - 9FGV0241
+ *   - 9FGV0441
  *
  * Copyright (C) 2022 Marek Vasut <marex@denx.de>
  */
@@ -51,6 +52,7 @@
 /* Supported Renesas 9-series models. */
 enum rs9_model {
 	RENESAS_9FGV0241,
+	RENESAS_9FGV0441,
 };
 
 /* Structure to describe features of a particular 9-series model */
@@ -64,7 +66,7 @@ struct rs9_driver_data {
 	struct i2c_client	*client;
 	struct regmap		*regmap;
 	const struct rs9_chip_info *chip_info;
-	struct clk_hw		*clk_dif[2];
+	struct clk_hw		*clk_dif[4];
 	u8			pll_amplitude;
 	u8			pll_ssc;
 	u8			clk_dif_sr;
@@ -162,6 +164,8 @@ static u8 rs9_calc_dif(const struct rs9_driver_data *rs9, int idx)
 
 	if (model == RENESAS_9FGV0241)
 		return BIT(idx) + 1;
+	else if (model == RENESAS_9FGV0441)
+		return BIT(idx);
 
 	return 0;
 }
@@ -381,14 +385,22 @@ static const struct rs9_chip_info renesas_9fgv0241_info = {
 	.did		= RS9_REG_DID_TYPE_FGV | 0x02,
 };
 
+static const struct rs9_chip_info renesas_9fgv0441_info = {
+	.model		= RENESAS_9FGV0441,
+	.num_clks	= 4,
+	.did		= RS9_REG_DID_TYPE_FGV | 0x04,
+};
+
 static const struct i2c_device_id rs9_id[] = {
 	{ "9fgv0241", .driver_data = RENESAS_9FGV0241 },
+	{ "9fgv0441", .driver_data = RENESAS_9FGV0441 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, rs9_id);
 
 static const struct of_device_id clk_rs9_of_match[] = {
 	{ .compatible = "renesas,9fgv0241", .data = &renesas_9fgv0241_info },
+	{ .compatible = "renesas,9fgv0441", .data = &renesas_9fgv0441_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, clk_rs9_of_match);
-- 
2.39.2



