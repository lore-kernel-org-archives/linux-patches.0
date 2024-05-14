Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6BF12BF3D;
	Tue, 14 May 2024 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687280; cv=none; b=hfC1xXB748+wLM2DU+PkBpNbz+49bXS6MTtmOBEZMZVpPSDPSmD5+1xt9/ZPsLpRIUN010gz/o9YrNmJWh5CThGDXrzLSkCqbNLpMriXhEdd9A7+jcLIaVGOuNcTW021ApaEFAQIbfBMdCreLBIpO8bdgSKlrx8DmlvcfymRIu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687280; c=relaxed/simple;
	bh=95KUdqferHDA9puE8uaJ3JBME7rvHXEOd5ujeltmnfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa11dHSuKLrzuXpXUyAXti4OGxUAQ6JkntrlSKUC6jLvduB3ANWsHVHgmIVmXZC9XzBbSrnz3GdKV5q8o182rhyEK+dr9ZKkMjzOdMpo8hQ+tplXjVRWgSD8BRMnWJrwGXEAqq6k1n+YbVahUdsFkcQ1Bf1azRxiVckuv3DB3rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgt/j3dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgt/j3dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08367C2BD10;
	Tue, 14 May 2024 11:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687279;
	bh=95KUdqferHDA9puE8uaJ3JBME7rvHXEOd5ujeltmnfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgt/j3dqf3aNFM2EbzW9sLDpf+tSJdUOat26YX5aYFFp6SGD+4JRvC2Lia9bugqZb
	 CexVJB/jsGbJrr0xsORZBJ17eT2Zn+zEBNYN1bB0jsnldavbBGCsmyn9s1VTyV0VRd
	 sKNihdcjz1O5KplaaE4chkGkyKHUBDYK1sKDFQb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Wagner <wagnerch42@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/111] clk: sunxi-ng: h6: Reparent CPUX during PLL CPUX rate change
Date: Tue, 14 May 2024 12:19:39 +0200
Message-ID: <20240514100958.695786025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1181,12 +1181,19 @@ static const u32 usb2_clk_regs[] = {
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
@@ -1240,7 +1247,15 @@ static int sun50i_h6_ccu_probe(struct pl
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


