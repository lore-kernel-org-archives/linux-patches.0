Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F60A2D77FA;
	Wed, 25 Feb 2026 06:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002641; cv=none; b=szO/xfiFUZeESeWSXzPst/K6pISaVKhI00elfsKbMLjri0+cJsp0vALPoX1JTa8QaDKLwxSNcXA8m4UK3MbRU734hi5NPA5VC7hWqRlFga17I0oJP+di7xkt1Tk8khQDguid+cJYyVDl+x+I1+7OJYUrt3do520z8pABkpsq/UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002641; c=relaxed/simple;
	bh=TBbCa2K4XBjLTvm1b8NyhjO+YuavMpGA6xoyjTOxd/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/HkFNM1jL07Yh/k1RSbF4Xdenpv+zN+22ojO9tRWXiHNdoArrIp+g7eKMLgZHantJ/QZa9QRG+pfiWGe4eaRmiqO2SMG6hScuPSLysc539Y65R3SBZJvDcLJdM1CpAkVScwl8ArbDp9bHfIXx5wuwqvORdRmV7lGEqp3z0RPbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeRREQeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeRREQeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4689AC116D0;
	Wed, 25 Feb 2026 06:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002641;
	bh=TBbCa2K4XBjLTvm1b8NyhjO+YuavMpGA6xoyjTOxd/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeRREQeDVLb0ZsnjnE15sheR7JD5pg+5yYU51DWR+5Q8cYDyqNqP8yXcStiRMwri+
	 piJSsVM/vYFgUjY6qP4lJVT9a6+pd4SkQCIIMp0wTImhEZUj0HaAPW1SOKANIyco0n
	 nVKNDGzT4Ap3UWZQplcba9LumJ/EUytnJgbom/uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 408/641] clk: meson: g12a: Limit the HDMI PLL OD to /4
Date: Tue, 24 Feb 2026 17:22:14 -0800
Message-ID: <20260225012358.449201165@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



