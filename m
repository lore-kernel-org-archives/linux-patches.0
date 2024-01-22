Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B761339A8;
	Tue, 23 Jan 2024 01:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971895; cv=none; b=nKIaXxC8pSb3t4l8scKboK0AzMwnOQUwjxzZRgf3VrjWR7pWvL7yOLw0CQdOuQqpQjciGUd0VAd9uOgKm/jEdV1/2p2l8seqNCx9nfcnrI3UM3/9p4beOFBPbGnXY5gsVbKoL1G23UWhbJ9kIki491ZBTPqg7OSF5SX1BVza/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971895; c=relaxed/simple;
	bh=uazdqqdFf6P99vvG0NUiCBxsHVHK0jGy8nUM4I0VwN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kiu5vmEMZfwJWhLZmnBLYvL61+/zE9FF49qOD/7pGwz/R86E2iRWKi8QrhQAatMzJCSrW4/xruI9EHVrKP94wbrk5F/rXfdU2bd3NMQLdHruu3Y5wDM0+bQrQ99/7svugBfdYo/kXpViuWHf/Ta/nZKrbvfXUnkN7L8Oinz5v5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XiVYthK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XiVYthK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F53CC433C7;
	Tue, 23 Jan 2024 01:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971895;
	bh=uazdqqdFf6P99vvG0NUiCBxsHVHK0jGy8nUM4I0VwN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XiVYthKK5EIgMIktBSB/ln/mlCJ9q6TeUdpJI/w3Dp9B0yZesJrGu2MENks0dJVL
	 XlqJ+5VVjRLRj7UH85Q70cdl4pa/SYgXc6ejzZg0ktWEb397WQwBvIKlvP6qFbIQWd
	 a+VLWgD+0almnun2CWyBJL0LtMGnlH08L0J/9b+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/286] iio: adc: ad9467: Benefit from devm_clk_get_enabled() to simplify
Date: Mon, 22 Jan 2024 15:59:14 -0800
Message-ID: <20240122235741.623296657@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19a45dd43796..92837dcbc170 100644
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



