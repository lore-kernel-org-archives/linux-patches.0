Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7A334CFC5;
	Tue, 16 Dec 2025 11:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885733; cv=none; b=XyBr3RdXPCSrL+xICEWFwSHEUTb5sjLunuKW9dGtSxyVn/ta3Esl5s2tG1aNgGgzJB6c6nNEDpM9FkEBukjvGz/hbUj7lBq7j5YPsTFsqqa5Y/numvoozoFFAR/TWdtOYDNYXi9AEIKyAgjrZF4pVF6cnWevHwjNqJ6iLKJkn5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885733; c=relaxed/simple;
	bh=0lQLKlH1extjS4bm+35XIjWmAywoLNqdDON39ElBRbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJaXLMuLLLagDqtwDDeMXM18G7s21nQDkH944HxDj9zpYWngKuPiIaNFGo8OwqNHiKSKDtPZZ4AeTABJk/TQM1bIFxHGlQuFx9TXcSxh80zT9rvXa3sPVKsrw+viwKmsMwMZx5Hy47dKHohYXpdgzpFOz4JzRw1BYPaeIH8X39g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUjGpOeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUjGpOeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E974C4CEF1;
	Tue, 16 Dec 2025 11:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885733;
	bh=0lQLKlH1extjS4bm+35XIjWmAywoLNqdDON39ElBRbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUjGpOeu1dGZVet0LlR/EIvRX81R8O9AQk6vXa//+vx7h90xhfqVIy7+GtLmWzE9y
	 WFdB7cPQ60LqIDsGeeweIS/1crIajk8aTUMK069dK4Ge54v20lInPPHExirX8hd8Vp
	 zlnvK4hiNvmC2TCyJbIr7ApBXK/lB05na8+ldth8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <Markus.Elfring@web.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 228/507] leds: netxbig: Fix GPIO descriptor leak in error paths
Date: Tue, 16 Dec 2025 12:11:09 +0100
Message-ID: <20251216111353.764800564@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 03865dd8af52eb16c38062df2ed30a91b604780e ]

The function netxbig_gpio_ext_get() acquires GPIO descriptors but
fails to release them when errors occur mid-way through initialization.
The cleanup callback registered by devm_add_action_or_reset() only
runs on success, leaving acquired GPIOs leaked on error paths.

Add goto-based error handling to release all acquired GPIOs before
returning errors.

Fixes: 9af512e81964 ("leds: netxbig: Convert to use GPIO descriptors")
Suggested-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251031021620.781-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-netxbig.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index e95287416ef87..99df46f2d9f52 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -364,6 +364,9 @@ static int netxbig_gpio_ext_get(struct device *dev,
 	if (!addr)
 		return -ENOMEM;
 
+	gpio_ext->addr = addr;
+	gpio_ext->num_addr = 0;
+
 	/*
 	 * We cannot use devm_ managed resources with these GPIO descriptors
 	 * since they are associated with the "GPIO extension device" which
@@ -375,45 +378,58 @@ static int netxbig_gpio_ext_get(struct device *dev,
 		gpiod = gpiod_get_index(gpio_ext_dev, "addr", i,
 					GPIOD_OUT_LOW);
 		if (IS_ERR(gpiod))
-			return PTR_ERR(gpiod);
+			goto err_set_code;
 		gpiod_set_consumer_name(gpiod, "GPIO extension addr");
 		addr[i] = gpiod;
+		gpio_ext->num_addr++;
 	}
-	gpio_ext->addr = addr;
-	gpio_ext->num_addr = num_addr;
 
 	ret = gpiod_count(gpio_ext_dev, "data");
 	if (ret < 0) {
 		dev_err(dev,
 			"Failed to count GPIOs in DT property data-gpios\n");
-		return ret;
+		goto err_free_addr;
 	}
 	num_data = ret;
 	data = devm_kcalloc(dev, num_data, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		ret = -ENOMEM;
+		goto err_free_addr;
+	}
+
+	gpio_ext->data = data;
+	gpio_ext->num_data = 0;
 
 	for (i = 0; i < num_data; i++) {
 		gpiod = gpiod_get_index(gpio_ext_dev, "data", i,
 					GPIOD_OUT_LOW);
 		if (IS_ERR(gpiod))
-			return PTR_ERR(gpiod);
+			goto err_free_data;
 		gpiod_set_consumer_name(gpiod, "GPIO extension data");
 		data[i] = gpiod;
+		gpio_ext->num_data++;
 	}
-	gpio_ext->data = data;
-	gpio_ext->num_data = num_data;
 
 	gpiod = gpiod_get(gpio_ext_dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod)) {
 		dev_err(dev,
 			"Failed to get GPIO from DT property enable-gpio\n");
-		return PTR_ERR(gpiod);
+		goto err_free_data;
 	}
 	gpiod_set_consumer_name(gpiod, "GPIO extension enable");
 	gpio_ext->enable = gpiod;
 
 	return devm_add_action_or_reset(dev, netxbig_gpio_ext_remove, gpio_ext);
+
+err_free_data:
+	for (i = 0; i < gpio_ext->num_data; i++)
+		gpiod_put(gpio_ext->data[i]);
+err_set_code:
+	ret = PTR_ERR(gpiod);
+err_free_addr:
+	for (i = 0; i < gpio_ext->num_addr; i++)
+		gpiod_put(gpio_ext->addr[i]);
+	return ret;
 }
 
 static int netxbig_leds_get_of_pdata(struct device *dev,
-- 
2.51.0



