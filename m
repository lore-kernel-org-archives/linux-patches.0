Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E024595B;
	Mon, 14 Oct 2024 14:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917048; cv=none; b=iM7yIzN9ByUUL7E1KEnEcpltydkNRSvVS+AU34giuXAEGA2MLC6WX/8b8dB2Fr4DdkMN3Z/lVGwZWETabVbZCEQic2tvce7KneXrl7Zy17wDP7QFynKh+BjgWdGl9OmSI4dTN3NcI7sFij9OdM2tcvtTjTNKnLIar9/KvWDmraE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917048; c=relaxed/simple;
	bh=ZBud8ZaYaxWBKJ07NFb7s8K+xkNyYlzxcIhjX/cakFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMZIBJ/mKZdY//sXAQIISgsGtqzhBP9vpK5LGK/zMDH/IgGd1/T/ou8+STWcVz8g9K3skgn8NAfKnMQivYGOE8YAF2U83dQ4D9WoIIH5txtEfldsmzDHRWHX6ZCaZSFrCUu3waxU6j2WX58Cd+M2FBZN2rDgSER+vukjQaDQ1E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rC735S4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rC735S4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79801C4CEC3;
	Mon, 14 Oct 2024 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917048;
	bh=ZBud8ZaYaxWBKJ07NFb7s8K+xkNyYlzxcIhjX/cakFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rC735S4XR3OQvOBsXOdrr0l5BLXPR0vSt0VNcphwaoX0WFXm7IxYzXJ7Fl2VoMj4o
	 PgBq4NaLu3KCDm1HjM27nredLwlYSZMj56kuWpzAvc/49jt9K0dnZrLuUGqSV9z2xP
	 U/uJ/GdErZhPBc7Ab+rJJcZmNnitrMjvsptl4ycE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/213] gpio: aspeed: Use devm_clk api to manage clock source
Date: Mon, 14 Oct 2024 16:20:42 +0200
Message-ID: <20241014141048.279033394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit a6191a3d18119184237f4ee600039081ad992320 ]

Replace of_clk_get with devm_clk_get_enabled to manage the clock source.

Fixes: 5ae4cb94b313 ("gpio: aspeed: Add debounce support")
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20241008081450.1490955-3-billy_tsai@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index 017f083bc8c29..76468e6a2899a 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1193,7 +1193,7 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 	if (!gpio_id)
 		return -EINVAL;
 
-	gpio->clk = of_clk_get(pdev->dev.of_node, 0);
+	gpio->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(gpio->clk)) {
 		dev_warn(&pdev->dev,
 				"Failed to get clock from devicetree, debouncing disabled\n");
-- 
2.43.0



