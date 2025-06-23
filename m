Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715592F24;
	Mon, 23 Jun 2025 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684825; cv=none; b=T8S87l0TKjKRTBMhwna9wIDM3HEjQAbR206Sy8sTKGWG0FWWyvKIuOM1op8UscAdn99KCms4MQ1/H1s6xG9G35dNwzhCh2cwNr9j997lswvea5EdVem0ewBez8F1A3YppGpcpZ125eub+kaNRcNo3n8uZLDPpP+8tUCfvH6x/Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684825; c=relaxed/simple;
	bh=pbLut49AWNqItlqtWmEDnw4bHlSsuwuLW1lmRiL5TMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JhZHszNjeoqTLo2r+PjnP+cIpVlAuL5MC2BtO7WJMSliMzda56WRWdmECOjEsXVgxxzwzhEEXwRRWjGs8RGFT8t7OhYz8tXVDIVRgnTT7OFg+S9fPaoQtsiptw/WldmGrdAPW4I6cXIVGp8uDzGJvw3PtqNA1hquK+1D2w3/4iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdnNOzj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdnNOzj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03705C4CEEA;
	Mon, 23 Jun 2025 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684825;
	bh=pbLut49AWNqItlqtWmEDnw4bHlSsuwuLW1lmRiL5TMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zdnNOzj4DGmgTX63AWegnoagm6Z6v86CiA2WLsND/Z+rBX9f1VBZY+u3kJuAmN+DC
	 aP8LKgr0wJyPYtxkbHaSPIwtF9tdeBJik3iKyk6Yw1oE1B+zdaHplBKw+6+5Hf3K/2
	 XrshtFCpGBvMpYnVKt+m/9keNbv2oshjcU6rl1a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Trevor Gamblin <tgamblin@baylibre.com>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.15 165/592] pwm: axi-pwmgen: fix missing separate external clock
Date: Mon, 23 Jun 2025 15:02:03 +0200
Message-ID: <20250623130704.205863511@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit a8841dc3dfbf127a19c3612204bd336ee559b9a1 upstream.

Add proper support for external clock to the AXI PWM generator driver.

In most cases, the HDL for this IP block is compiled with the default
ASYNC_CLK_EN=1. With this option, there is a separate external clock
that drives the PWM output separate from the peripheral clock. So the
driver should be enabling the "axi" clock to power the peripheral and
the "ext" clock to drive the PWM output.

When ASYNC_CLK_EN=0, the "axi" clock is also used to drive the PWM
output and there is no "ext" clock.

Previously, if there was a separate external clock, users had to specify
only the external clock and (incorrectly) omit the AXI clock in order
to get the correct operating frequency for the PWM output.

The devicetree bindings are updated to fix this shortcoming and this
patch changes the driver to match the new bindings. To preserve
compatibility with any existing dtbs that specify only one clock, we
don't require the clock name on the first clock.

Fixes: 41814fe5c782 ("pwm: Add driver for AXI PWM generator")
Cc: stable@vger.kernel.org
Acked-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Trevor Gamblin <tgamblin@baylibre.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20250529-pwm-axi-pwmgen-add-external-clock-v3-3-5d8809a7da91@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-axi-pwmgen.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/pwm/pwm-axi-pwmgen.c
+++ b/drivers/pwm/pwm-axi-pwmgen.c
@@ -257,7 +257,7 @@ static int axi_pwmgen_probe(struct platf
 	struct regmap *regmap;
 	struct pwm_chip *chip;
 	struct axi_pwmgen_ddata *ddata;
-	struct clk *clk;
+	struct clk *axi_clk, *clk;
 	void __iomem *io_base;
 	int ret;
 
@@ -280,9 +280,26 @@ static int axi_pwmgen_probe(struct platf
 	ddata = pwmchip_get_drvdata(chip);
 	ddata->regmap = regmap;
 
-	clk = devm_clk_get_enabled(dev, NULL);
+	/*
+	 * Using NULL here instead of "axi" for backwards compatibility. There
+	 * are some dtbs that don't give clock-names and have the "ext" clock
+	 * as the one and only clock (due to mistake in the original bindings).
+	 */
+	axi_clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(axi_clk))
+		return dev_err_probe(dev, PTR_ERR(axi_clk), "failed to get axi clock\n");
+
+	clk = devm_clk_get_optional_enabled(dev, "ext");
 	if (IS_ERR(clk))
-		return dev_err_probe(dev, PTR_ERR(clk), "failed to get clock\n");
+		return dev_err_probe(dev, PTR_ERR(clk), "failed to get ext clock\n");
+
+	/*
+	 * If there is no "ext" clock, it means the HDL was compiled with
+	 * ASYNC_CLK_EN=0. In this case, the AXI clock is also used for the
+	 * PWM output clock.
+	 */
+	if (!clk)
+		clk = axi_clk;
 
 	ret = devm_clk_rate_exclusive_get(dev, clk);
 	if (ret)


