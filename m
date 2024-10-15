Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579CB1FAF01;
	Tue, 15 Oct 2024 13:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998475; cv=none; b=E+0R7tkNUrrFSNg0XRWl5Pb4roZJe8hXB5QDzkLJ8bdLsWYOd8MaoZESxz3FvLzQnsPyfsH1enYnnIB9d3YDcx/G5icO/QHH04r/9LhB/+/7vAOn8amMY2XpqhAnwxXvsr/Y9xXNgcBJRW9w3ab+RmART2tu8NxdQBNT1QSPY1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998475; c=relaxed/simple;
	bh=LKWvnb/SKCEaVx5LmNHfmSxTv7Kgh0kzLCCMJKXOrrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRRB14cnkindgDZM60PpJXlPI4xwBguaHWqccK1Sam78YDRAwJPvLqT8Bs8zVXC6df8O/r6EB+n8XPivPC2ZbASDyYf0wuKCfBmrX2JwDkYTiwWr/jZ76Zt2j9quRHKVGMvrr2PaWBVV2gAwvF16NHwUffIg+gFvOfYEMz6qmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlViMcMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlViMcMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F62C4CED0;
	Tue, 15 Oct 2024 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998475;
	bh=LKWvnb/SKCEaVx5LmNHfmSxTv7Kgh0kzLCCMJKXOrrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlViMcMv7DZWArvKwGWCt718tQYE/easdEMK50+JJOzbGNu/GsDfjhh+r0bgzfOfG
	 /BXPtoQH2O++ce3XYi+4fi7CNaHkm5NyZRfUk3U+xVmt899ZOmxYjleYFPGkvN8tJa
	 GXv0uuSLsHFZWNYucAyEEW0XsylPd3agZynXD2rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/518] gpio: aspeed: Use devm_clk api to manage clock source
Date: Tue, 15 Oct 2024 14:46:32 +0200
Message-ID: <20241015123935.833179826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 41e3f3b351cf6..a70c499c2a193 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1159,7 +1159,7 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 	if (!gpio_id)
 		return -EINVAL;
 
-	gpio->clk = of_clk_get(pdev->dev.of_node, 0);
+	gpio->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(gpio->clk)) {
 		dev_warn(&pdev->dev,
 				"Failed to get clock from devicetree, debouncing disabled\n");
-- 
2.43.0



