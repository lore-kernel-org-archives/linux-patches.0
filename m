Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAB16310D;
	Tue, 23 Jan 2024 01:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974991; cv=none; b=uln8Hi8pte/Qo1dqCEYmXtDh+4BMzpbuq6cAK2eD1EOCWCuumiyufONdWQX2wS6Eq1rd074nQ5E52ahzB3YxTCpOF9CEKbMKUIh0BSUBNrvREPnEHXcslNzi+ixYNCWoFp7NWo/HhYK4Pg47DaWy9TxiRELEwYkuu4Q50hkowB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974991; c=relaxed/simple;
	bh=vZu2+7t5a3zobaLrnT6+RkAuQOf5oo1RWizYItctOM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxtR0goxKY0bl9wlEBBQTWb5qKaBzLs9dTsr5V1aQspPdJL9YFwcgPnTJfZ17tiynQXO+HupVm4SnhWtESm/8Iepsq2EFKOe4gW30sOSPNs16RpKCYAHjy4SKrXpiX8q7JjwoI7XHA6k2lUfzKJIySO1g318tjrDtasfJFaigi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dz+1pOoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dz+1pOoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422FBC43390;
	Tue, 23 Jan 2024 01:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974991;
	bh=vZu2+7t5a3zobaLrnT6+RkAuQOf5oo1RWizYItctOM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dz+1pOohBSebe4DX+3hbUhXkzbYXutHkShrQBiNO9lfO6dVhnhH4aj3+o+RRTNiCQ
	 MQLZ51g9LwRqWu4tKfz9GLT80dPbkdn7t3FpsHSYBj4InW8hT1TtwRs7FFa27o4rfp
	 iy/A9U3y5puMff6nGrSHFTLgIA3HTY8Bgt7y+rIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/374] iio: adc: ad9467: Benefit from devm_clk_get_enabled() to simplify
Date: Mon, 22 Jan 2024 15:59:27 -0800
Message-ID: <20240122235755.695590436@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit cdd07b3ab94a020570132558442a26e74b70bc42 ]

Make use of devm_clk_get_enabled() to replace some code that effectively
open codes this new function.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220808204740.307667-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 76f028539cf3 ("iio: adc: ad9467: fix reset gpio handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad9467.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/iio/adc/ad9467.c b/drivers/iio/adc/ad9467.c
index dbfc8517cb8a..a07df0fd3329 100644
--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -378,13 +378,6 @@ static int ad9467_preenable_setup(struct adi_axi_adc_conv *conv)
 	return ad9467_outputmode_set(st->spi, st->output_mode);
 }
 
-static void ad9467_clk_disable(void *data)
-{
-	struct ad9467_state *st = data;
-
-	clk_disable_unprepare(st->clk);
-}
-
 static int ad9467_probe(struct spi_device *spi)
 {
 	const struct ad9467_chip_info *info;
@@ -404,18 +397,10 @@ static int ad9467_probe(struct spi_device *spi)
 	st = adi_axi_adc_conv_priv(conv);
 	st->spi = spi;
 
-	st->clk = devm_clk_get(&spi->dev, "adc-clk");
+	st->clk = devm_clk_get_enabled(&spi->dev, "adc-clk");
 	if (IS_ERR(st->clk))
 		return PTR_ERR(st->clk);
 
-	ret = clk_prepare_enable(st->clk);
-	if (ret < 0)
-		return ret;
-
-	ret = devm_add_action_or_reset(&spi->dev, ad9467_clk_disable, st);
-	if (ret)
-		return ret;
-
 	st->pwrdown_gpio = devm_gpiod_get_optional(&spi->dev, "powerdown",
 						   GPIOD_OUT_LOW);
 	if (IS_ERR(st->pwrdown_gpio))
-- 
2.43.0



