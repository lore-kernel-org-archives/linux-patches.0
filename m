Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB7A1DF721;
	Wed,  6 Nov 2024 12:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895552; cv=none; b=g4W84UyX+/4sxiQc6VwqHIgRKzn+KW3q6anccXXa9hY1VUw3BZieQXiQ2HKBp2jB2kIhX9aqA6L+LuGLCT0f6mHzYk5fO8+CGNXBp4e1Cn8KXrgh3fPEvlxF6L9sJia0i3B0TdcY6YoXBVuNbC9YjpuzBFUdV96dDCVMDbTpKeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895552; c=relaxed/simple;
	bh=yWzjQjS5YNTSJuT/+R8V/Vr9fr3X/2qi4cpsNkk3gJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxBTKw6Qci2DoI8nawixFNJzfyBlKfF/cGfXz/jctVmXPh4lx4i08WTxDJRaQU8vtAS9fqm8ENpx7EJDujCeE5oLNKafyj9cxK0JjoT3o62aw9+s1dfbA93Q2g+rRJq7rQsDkIM8e6523UeePb8Ow3a7ShYtz1rq5jALS5Uu3CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKmccZ3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKmccZ3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DE8C4CECD;
	Wed,  6 Nov 2024 12:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895552;
	bh=yWzjQjS5YNTSJuT/+R8V/Vr9fr3X/2qi4cpsNkk3gJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKmccZ3qhAaj8UZ+EAV8WGLjbkX8dOLMLzJFreIcFIuAWBqIIlEcTBvXAA1/eUUD8
	 /DsI6f76cAFgT9i8maYUzLYzR/4WrUYUdwa5zoBHKfMHfJfn/HHzpuP13Y9edIRuMY
	 JrYCzpCOYebhJ48hXUAlFSiSmW/e56ZaVw7Sj5Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 257/350] gpio: aspeed: Use devm_clk api to manage clock source
Date: Wed,  6 Nov 2024 13:03:05 +0100
Message-ID: <20241106120327.259205812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5cc80678ac352..cab3d9a4018ab 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1176,7 +1176,7 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 	if (!gpio_id)
 		return -EINVAL;
 
-	gpio->clk = of_clk_get(pdev->dev.of_node, 0);
+	gpio->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(gpio->clk)) {
 		dev_warn(&pdev->dev,
 				"Failed to get clock from devicetree, debouncing disabled\n");
-- 
2.43.0



