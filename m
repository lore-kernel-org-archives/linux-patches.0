Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51668352FF0;
	Tue, 26 Aug 2025 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217785; cv=none; b=glBlJAlIOpFs0f6QKP/Gwz1hqls/CBvsc7eKEKXrBxGm2ACJ15+YBXvg+P+6UcM0Lns+zfvHQT0xnoi2FvmeiAWnwHUNtPUEPLk6rDcCTvDqHnxHPEDy5lYiDuPGIb56aGxYiPWUM33gi+Hy8/h849E7ZuAfWHbp4h9CCxmY77c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217785; c=relaxed/simple;
	bh=R49vnZEU+IGwaxg6G9CDgZIrFFfYl0WJXjm+d86axMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9UywKd/nNPB04rhteyxXaZc4lkRNaWJzz3yhrE/OlseRYryqfvYtMeMtj/BO2zz3/A/r8eLtCc6g8jeoIKulyGbmJsXI1RgC1kVY8Y/4gBs4ybzslMV0xqa4kZYRKq7a0+l9lJTb6NT/bxhqx8tMAPnQ3ZGiXWGZRiD+TU/Loc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIdDytpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIdDytpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D508EC4CEF1;
	Tue, 26 Aug 2025 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217785;
	bh=R49vnZEU+IGwaxg6G9CDgZIrFFfYl0WJXjm+d86axMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIdDytpfP62Lbrb2sgHK3JUi6hwsAILFjLgiLK2wV8VHtXJJapfDF84MxbY8zih9D
	 rORI+clCetEjkcrJBTnWOwZYhCVeOVCAGDwRUF+ArAa2GFUp5ikD23tnKbKjW34Nj3
	 v/QsuefzdKZ3QxjfH9bwCgDG6W4pPKAGoUUHV5p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/523] gpio: tps65912: check the return value of regmap_update_bits()
Date: Tue, 26 Aug 2025 13:07:23 +0200
Message-ID: <20250826110930.198125187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit a0b2a6bbff8c26aafdecd320f38f52c341d5cafa ]

regmap_update_bits() can fail, check its return value like we do
elsewhere in the driver.

Link: https://lore.kernel.org/r/20250707-gpiochip-set-rv-gpio-round4-v1-2-35668aaaf6d2@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tps65912.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-tps65912.c b/drivers/gpio/gpio-tps65912.c
index 510d9ed9fd2a..a8a2ad13e09e 100644
--- a/drivers/gpio/gpio-tps65912.c
+++ b/drivers/gpio/gpio-tps65912.c
@@ -49,10 +49,13 @@ static int tps65912_gpio_direction_output(struct gpio_chip *gc,
 					  unsigned offset, int value)
 {
 	struct tps65912_gpio *gpio = gpiochip_get_data(gc);
+	int ret;
 
 	/* Set the initial value */
-	regmap_update_bits(gpio->tps->regmap, TPS65912_GPIO1 + offset,
-			   GPIO_SET_MASK, value ? GPIO_SET_MASK : 0);
+	ret = regmap_update_bits(gpio->tps->regmap, TPS65912_GPIO1 + offset,
+				 GPIO_SET_MASK, value ? GPIO_SET_MASK : 0);
+	if (ret)
+		return ret;
 
 	return regmap_update_bits(gpio->tps->regmap, TPS65912_GPIO1 + offset,
 				  GPIO_CFG_MASK, GPIO_CFG_MASK);
-- 
2.39.5



