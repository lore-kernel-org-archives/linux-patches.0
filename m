Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0229F6E61F;
	Tue, 14 May 2024 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687097; cv=none; b=N/Zp+2MNIsvz7Yol1boQ2sn9iuHcXofC3P7zG1awKQUSzbSVTfnHMo+XLLcm0X5kVkheRQqlQ4ZwQAY+6D+SVydF7/QW0guwlXM6Eu79ZC00Ka6VNn3YMpWz23REXpHUWrn9NONCOeoZYPvzIGdks6GTEH2kzg8VMM7N+3xGzLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687097; c=relaxed/simple;
	bh=HeCskSFgTROokE5//YHBF8tMC5UO5zsDt83xuSWOJ64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZiBs4O1Ar0w1p0pXBleV+jWwtuOxNNNdtOiPhG6iZV3pTqqdqs3BdLDsf9yKgWrS4U+vjzFSypl+BNn3xOYtQXLQMq6rZYJd3l3LkgBV5eaIK1iepDyrGfOI+GZCl6uChtK0BOH2Ax7kLzWH4lAJlJpPfd5u+fiVfoKEoNYQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgbFXDq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgbFXDq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDC9C2BD10;
	Tue, 14 May 2024 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687096;
	bh=HeCskSFgTROokE5//YHBF8tMC5UO5zsDt83xuSWOJ64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgbFXDq3x5di3EP/KAVkNpj0KtWB3CkW2lu1wYun35HgQMzeH4hVePaIoe/2w7JqK
	 zMffQmWo7r8J+IABknNy7tYbIgpEIzwI9uzkvP20Wu3epgz+eZQ3tLm4gPtL927mz+
	 jhN1ASK/tkvIOZ2UOxasfxJgWsDUYOaBZWmxXDzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Wagner <wagnerch42@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/84] clk: sunxi-ng: h6: Reparent CPUX during PLL CPUX rate change
Date: Tue, 14 May 2024 12:19:43 +0200
Message-ID: <20240514100952.903499494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 7e91ed763dc07437777bd012af7a2bd4493731ff ]

While PLL CPUX clock rate change when CPU is running from it works in
vast majority of cases, now and then it causes instability. This leads
to system crashes and other undefined behaviour. After a lot of testing
(30+ hours) while also doing a lot of frequency switches, we can't
observe any instability issues anymore when doing reparenting to stable
clock like 24 MHz oscillator.

Fixes: 524353ea480b ("clk: sunxi-ng: add support for the Allwinner H6 CCU")
Reported-by: Chad Wagner <wagnerch42@gmail.com>
Link: https://forum.libreelec.tv/thread/27295-orange-pi-3-lts-freezes/
Tested-by: Chad Wagner <wagnerch42@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20231013181712.2128037-1-jernej.skrabec@gmail.com
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
@@ -1172,12 +1172,19 @@ static const u32 usb2_clk_regs[] = {
 	SUN50I_H6_USB3_CLK_REG,
 };
 
+static struct ccu_mux_nb sun50i_h6_cpu_nb = {
+	.common		= &cpux_clk.common,
+	.cm		= &cpux_clk.mux,
+	.delay_us       = 1,
+	.bypass_index   = 0, /* index of 24 MHz oscillator */
+};
+
 static int sun50i_h6_ccu_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	void __iomem *reg;
+	int i, ret;
 	u32 val;
-	int i;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg = devm_ioremap_resource(&pdev->dev, res);
@@ -1231,7 +1238,15 @@ static int sun50i_h6_ccu_probe(struct pl
 	val |= BIT(24);
 	writel(val, reg + SUN50I_H6_HDMI_CEC_CLK_REG);
 
-	return sunxi_ccu_probe(pdev->dev.of_node, reg, &sun50i_h6_ccu_desc);
+	ret = sunxi_ccu_probe(pdev->dev.of_node, reg, &sun50i_h6_ccu_desc);
+	if (ret)
+		return ret;
+
+	/* Reparent CPU during PLL CPUX rate changes */
+	ccu_mux_notifier_register(pll_cpux_clk.common.hw.clk,
+				  &sun50i_h6_cpu_nb);
+
+	return 0;
 }
 
 static const struct of_device_id sun50i_h6_ccu_ids[] = {


