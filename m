Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AC0243376;
	Wed, 25 Feb 2026 01:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983395; cv=none; b=Itba/n1OwOmqFt7CRvHn7Eo5Gw6ekvUM0inIm1X9o5yvhf4HtbJyiGHYTFyABhrvX8bJDjaTNZPqjHxOyH/VA6lZddXCcaBPzXsjIrORsb4v3YF0QY9CGr7nD1J5+q/dkOij5AGJOZw+ooxpkDLnFXhQHlipq1l1GuT1CMq7eKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983395; c=relaxed/simple;
	bh=/9MCQAAVaON6/E/xSKZY4YRItAZXriax4p58XmV/auw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEql++ZID/jllxQOg17LrAPLtcxNKTy0wJT1ZBdpvVNxh6iRNCnT7oYTY1h9Ch4lvT5lpqV6YEc3hE1V4q9rCo55nS9ZAJYcivsNvEcEGxg9rj8m8yM7dUuuvssCywgoa3a/FV5bQULpmt6FW/PKTdqt3kexkDXrt35mKWad13s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLULXZt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLULXZt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3640C116D0;
	Wed, 25 Feb 2026 01:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983395;
	bh=/9MCQAAVaON6/E/xSKZY4YRItAZXriax4p58XmV/auw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLULXZt5OFLnS3XZfURh4BSLrtzlW4+E9MBJ8dSSAujkc3kFqZxqaQRuxtrCEuzUx
	 KitIxnQJf+YpFwPxAmleTSonNVZ9g9uVYqi3eip6e/AXTPNYIqRGWY6jGJdjIRFwav
	 7/tLfovavjmKYn1/+OAvBaE1HDND/ij4FWKZtEx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 517/781] clk: meson: g12a: Limit the HDMI PLL OD to /4
Date: Tue, 24 Feb 2026 17:20:26 -0800
Message-ID: <20260225012412.484425358@linuxfoundation.org>
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

[ Upstream commit 7aa6c24697ef5db1402dd38743914493cd5b356d ]

GXBB has the HDMI PLL OD in the HHI_HDMI_PLL_CNTL2 register while for
G12A/G12B/SM1 the OD has moved to HHI_HDMI_PLL_CNTL0. At first glance
the rest of the OD setup seems identical.

However, looking at the downstream kernel sources as well as testing
shows that G12A/G12B/SM1 only supports three OD values:
- register value 0 means: divide by 1
- register value 1 means: divide by 2
- register value 2 means: divide by 4

Downstream sources are also only using OD register values 0, 1 and 2
for G12A/G12B/SM1 (while for GXBB the downstream kernel sources are also
using value 3 which means: divide by 8).

Add clk_div_table and have it replace the CLK_DIVIDER_POWER_OF_TWO flag
to make the kernel's view of this register match with how the hardware
actually works.

Fixes: 085a4ea93d54 ("clk: meson: g12a: add peripheral clock controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20260105204710.447779-3-martin.blumenstingl@googlemail.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/g12a.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/meson/g12a.c b/drivers/clk/meson/g12a.c
index 185b6348251db..d0d4c7b6dc827 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -777,12 +777,23 @@ static struct clk_regmap g12a_hdmi_pll_dco = {
 	},
 };
 
+/*
+ * G12/SM1 hdmi OD dividers are POWER_OF_TWO dividers but limited to /4.
+ * A divider value of 3 should map to /8 but instead map /4 so ignore it.
+ */
+static const struct clk_div_table g12a_hdmi_pll_od_div_table[] = {
+	{ .val = 0, .div = 1 },
+	{ .val = 1, .div = 2 },
+	{ .val = 2, .div = 4 },
+	{ /* sentinel */ }
+};
+
 static struct clk_regmap g12a_hdmi_pll_od = {
 	.data = &(struct clk_regmap_div_data){
 		.offset = HHI_HDMI_PLL_CNTL0,
 		.shift = 16,
 		.width = 2,
-		.flags = CLK_DIVIDER_POWER_OF_TWO,
+		.table = g12a_hdmi_pll_od_div_table,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "hdmi_pll_od",
@@ -800,7 +811,7 @@ static struct clk_regmap g12a_hdmi_pll_od2 = {
 		.offset = HHI_HDMI_PLL_CNTL0,
 		.shift = 18,
 		.width = 2,
-		.flags = CLK_DIVIDER_POWER_OF_TWO,
+		.table = g12a_hdmi_pll_od_div_table,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "hdmi_pll_od2",
@@ -818,7 +829,7 @@ static struct clk_regmap g12a_hdmi_pll = {
 		.offset = HHI_HDMI_PLL_CNTL0,
 		.shift = 20,
 		.width = 2,
-		.flags = CLK_DIVIDER_POWER_OF_TWO,
+		.table = g12a_hdmi_pll_od_div_table,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "hdmi_pll",
-- 
2.51.0



