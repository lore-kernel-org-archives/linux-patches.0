Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4035836C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302209; cv=none; b=afAxyDUDc58bVaysHb7Mw1tb9oLVxMyR7hp/GzmNdOFvG92aKpIbcYwFHoGtaJko0UGhMSFM2Xnr8LVJtrVejZoLkJSXlV9Q0n6KagtFKW67ji88VFvdap2glfRFT+0Xrz24BlsJbZihUEfI82zJlaiw9db8ntVGvlK4Qeua6QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302209; c=relaxed/simple;
	bh=8tP0sQ4Y/HNSCtyminKQ8Am/e6P9UPmxKqO7sVyNIw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT+3MZzAeCadEm0m4im8aIvD9SDFOym+EFsmZ7rDJPn+QmxhYrS5AX0kaVzEg8fin4gYDY5lbcT6C744vL0cFliVFS5pDsppT4fjzvZimZHKZrxXVYGbYyhHp+P+1jwrOfRdXxkzQE/kQENQQ5c7I/cZeIWHOl4LQ+tgaICQWRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYEtTc91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYEtTc91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E01C116D0;
	Sat, 28 Feb 2026 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302209;
	bh=8tP0sQ4Y/HNSCtyminKQ8Am/e6P9UPmxKqO7sVyNIw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYEtTc91I77+YuCjMTQ77JZrU/8Bpt04VARQ5vhmeAyKokabZ6XTLv3CRXa7MtlKX
	 IaQt20JDBMBys+8K48WpYhQAoo7uV0KrXeZdMhJekcQ6yBpWJo2VmOm0VcZ/zWx5wC
	 eTFPvUP6i50cPTJLOXMhaGgy67ohVeUIaKA0xbCQIlju96ZL1JLw1izaS7fUjMbENb
	 I6aqbpo4CxkMdhZQTQtTH1GLZzPStpKFhN5WJJZGw4XZniKjmkN5D9Lc99/q0MVTuW
	 m491u5QUDyfh5rgAOE6PfcksXUvZwkomK0ungR1bEtchoIENL+8FbmAkLKR/kgCvta
	 ItIC1jFPCb7jQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/283] clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs
Date: Sat, 28 Feb 2026 13:05:57 -0500
Message-ID: <20260228180709.1583486-215-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index a133013356b64..00eaca92b388a 100644
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

