Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2911F2BE058;
	Tue, 26 Aug 2025 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214361; cv=none; b=uXsLIPYALJqUhs4KuC20OoxZNsfT7HHhO/k3cDzWl1O0BNSx0w+q/fTS2nYPpnYe1s6FFk3KqZx8/dHJ3l+K8lfQ67wCGzJZlvIsN1whDSNMqxm7n5sDC2EziSTKQ/gzf7/GmeDeZUo9hjFn+Z6CRywyvfGV/g5rJoeJXfO4BHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214361; c=relaxed/simple;
	bh=w3/dzM9tKMhtXkCE/J6z9MsZrJ+QQvjMc24FVxqzKns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtQFjF+VjhCQHJfnRzf0Rgq0UeZQz9igea84ksUAp3TmtQDlKZT71jALXc2Lpy0N9VqEyiZDFoRB3BoKWoezrOLi7TpthZ+YYj5qn+DOokS3RVYpNBwMaoAdYckQTU0Erznc8cQcpOJNBO1xsSnMrWYeEOkCdTejquIhvlRexxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khgP1SFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khgP1SFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C4BC4CEF1;
	Tue, 26 Aug 2025 13:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214360;
	bh=w3/dzM9tKMhtXkCE/J6z9MsZrJ+QQvjMc24FVxqzKns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khgP1SFCPsTMzL559dtRjqOONd7MXQ3d22Z5LIJT21zbFBoJbc45wR/3W+EaX8XRZ
	 i41Y8n5yQj+HR7L/WQ5UiQrxzCzacqCqWujiTkxghGanvE3yj2GaAQgHq9l9b/Ds00
	 oJ6JxZCXQc2davN51OHOTof6mWga6oyINoe8hp14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/482] gpio: tps65912: check the return value of regmap_update_bits()
Date: Tue, 26 Aug 2025 13:05:35 +0200
Message-ID: <20250826110932.857469904@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fab771cb6a87..bac757c191c2 100644
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



