Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD901F790F;
	Tue, 26 Aug 2025 12:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212788; cv=none; b=M2TETudJ96AnLAGi+PW3j4ZlXuX5CjnXbfCqcfNT232YaOLWqbSRFZ4v3eM+3YYGQdtiyIPT7RqAUJlZKwL6cnVoleoLxFodeYzLViXnF9o8J1ccC9vG6Ly1sTAsQOtk5IlIAJEPPHqTG9x5zajO+Xr+o/1h7qHiB9S3pVzICwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212788; c=relaxed/simple;
	bh=5MMpT9YQIBMbxsP8ZHj6CQArDhWyyHFeCeAJIQP+51E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqifGuCmpAPfwyV9LOvK3U4/N2z/0ANYXjwM/Wk80DFfBpehn9oiu4lcOKNb+heAZ+iy0RaFDh7t2tmAM5wJefXKjBLMflteH5G8IJcSRYuBUR4PEmW9a2iTPknIyz2/cBFEeMsKxGJY/PY4fpd6KsQqbtQe2I6VTZzFGJJvtkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQPjpGig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQPjpGig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF070C4CEF1;
	Tue, 26 Aug 2025 12:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212788;
	bh=5MMpT9YQIBMbxsP8ZHj6CQArDhWyyHFeCeAJIQP+51E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQPjpGigZn3Evctf8ymbZXS3iS9FhV/HcZ/QLIvc24tHRY0ensbxnAkqlsKJqMWZR
	 rVdSSZfXvCMke+4vGV/hJMbs91En3YX3SVbYKUCje+O6VEz2s6faBbMMQddsovw9qg
	 yYcPFOtuogjeFpDx7qmzz2pGFYwNMNhNVquWBtwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/587] gpio: tps65912: check the return value of regmap_update_bits()
Date: Tue, 26 Aug 2025 13:04:12 +0200
Message-ID: <20250826110955.560291558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



