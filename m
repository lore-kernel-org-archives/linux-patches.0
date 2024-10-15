Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68FB1EABD2;
	Tue, 15 Oct 2024 12:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994223; cv=none; b=cy9qR+/nIv8OSweoYo+gfZJl2HEh0Dy319g7kG1eKxMGn6yPG/cUkX+OG8sLLep6rqXZFI15aogYu9NTv0WF4lOnsjYQZAXH6oxI2vCHP7Cl7nhp9xEsuogELxOs45fAGq+3PEYaaJVtWbd5IrmTJB0b7BKs0Mf/NPTw/frjLpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994223; c=relaxed/simple;
	bh=UPyDHCAxr+IknTWct2bsfTYSKcZQ+DocDQAnEQAF4Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW0x3aV//J6xn7Tg/eJheWPzoaleY7MITj3PMbtXpm4wOQh0BSX2aGuzreuDr8Ir3NQeErspknyb/mM0ujy/JNfV1AMi08lEwhxpaNasSh7iRfO09Q1UQ1osMhD4LjgncqPh/K7xgOfENorqynA5orX9NBgYbL5CNYfMyFIuaU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVE7W+jJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVE7W+jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4790AC4CECE;
	Tue, 15 Oct 2024 12:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994223;
	bh=UPyDHCAxr+IknTWct2bsfTYSKcZQ+DocDQAnEQAF4Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVE7W+jJ3rNYVjQ1kYp7ndiZTJZe5mBKv5Elq1kjBlQo+x0CzRAEdivmAtKeslURp
	 ZzZ/YSVJJ24euAxtuZyLfciWQMX0LZAhX/gXaVlkINBkeXvVwqgVtpE3r7TZy19ext
	 SA0hJ4DDYxPIle6Yg+grti4HN9yeoQ2KbnOC1zs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 642/691] gpio: aspeed: Use devm_clk api to manage clock source
Date: Tue, 15 Oct 2024 13:29:50 +0200
Message-ID: <20241015112505.808010400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



