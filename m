Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5531B4F04;
	Mon, 14 Oct 2024 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919925; cv=none; b=HCmBYQkRyw28pX0KFrtRxYQ/toZC6UYzDrI//DrYzE7D5mgeb8cOLdeXGWTLu/nZ1/xZb2sFxmaINkavegqrkX+f9zlyPkE/jyi1AqwIdX11Pf2KUdixMlLYzvdps8M1H2kPRjhp5SCZ39zqcAwayqX8IUq9c82eE9i6nL3nUUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919925; c=relaxed/simple;
	bh=+RXIXf7b5VpBahR5KLXhAGJc/ClnLyBqM902rQ2N5tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0ecJsUH/QlZntjZ2p8ng29L6lx4tNY7LiEDncXzi+jpC9SIKdT687kOsotoEYceInl2W4kr3V3+9GpQUAFGAHdmyc2iwdNnczcV6yz7wM9kyLdv47jzWsOsuSC5KCvqdKheGnX7OQv48bI4TtuS1YSIJno4QYPSmzx+HBYRu+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4XUHhxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4XUHhxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F96DC4CECF;
	Mon, 14 Oct 2024 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919924;
	bh=+RXIXf7b5VpBahR5KLXhAGJc/ClnLyBqM902rQ2N5tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4XUHhxhDCso7FOXJCiN0ad1hOlQQQZG2SaIM7IXlqeH31//7PLM5PpKqhxBASlki
	 l23vmmsydTVQ0JPRftScKPcOe3veQahopc5HPCsq/lxJfFuyxhlDqG0IFQ/hVyBOJT
	 3uxX4qe+4QHxVNFzwu+XeKNwTmiAv4dgW72gcfW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 748/798] gpio: aspeed: Use devm_clk api to manage clock source
Date: Mon, 14 Oct 2024 16:21:42 +0200
Message-ID: <20241014141247.454490616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3cfb2c6103c6b..21deb228c7d7b 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1156,7 +1156,7 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 	if (!gpio_id)
 		return -EINVAL;
 
-	gpio->clk = of_clk_get(pdev->dev.of_node, 0);
+	gpio->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(gpio->clk)) {
 		dev_warn(&pdev->dev,
 				"Failed to get clock from devicetree, debouncing disabled\n");
-- 
2.43.0



