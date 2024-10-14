Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2734D20EB;
	Mon, 14 Oct 2024 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916219; cv=none; b=qrWa/kA/6bNLgpQJ+D/D7O4Dw8Z0pFVw3xkyd4yty5qrLJgK4dNEEzE5VEvKFoUtrLPYAYrJlhiXBmH1mTbPz99HUV7cnvtQmkJNsld+JeucFPDkH17rsqUnCN0xmEKTqohfyj6z9GuCB6LYzu4Xv9hZ2jFlGMqZcQeUE/12Qns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916219; c=relaxed/simple;
	bh=uBJ0oCBqhgxeN6zEJCGxk3pe/iTTfg0ngl8egsCQ8+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbiBBPXQzXOWJdqWOkHe6pYIxLUDtw9kXh3CoVGLPB+Zbw+CR5Ob3XUk5PBMhJY8DCYpNU3aNf0kCio5sTcZqJeQ+pAA50ba1JYl8S3of6H1sBVnXLyggwLTsAlGYLIPohCXYRnKt01yy7190w8eAWNipdswyWFivB8zI8ZdG3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqghlcFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqghlcFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B51AC4CEC3;
	Mon, 14 Oct 2024 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916219;
	bh=uBJ0oCBqhgxeN6zEJCGxk3pe/iTTfg0ngl8egsCQ8+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqghlcFKZtFR3H4YJZ5fTnn0SNrQJDaDD1MA20sYF25XgqeoNqX1KuJSMQiystUw1
	 PgfI+gUtoeNMe+S0TErdq+SRhWIMnq/BNRBKiVGt/H5jxJ/b+SjuZdTMUm9+yIMYvf
	 Q/tvXym4Cz5Ye1o9PiSNxEbAYOBXAeGMXv4oVbAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 117/214] gpio: aspeed: Use devm_clk api to manage clock source
Date: Mon, 14 Oct 2024 16:19:40 +0200
Message-ID: <20241014141049.558140089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 98551b7f6de2e..ea40ad43a79ba 100644
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



