Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506FD330B08;
	Fri, 17 Oct 2025 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715281; cv=none; b=AsFOB8UWigbUHD7sZrryk27NVxsEsBJG8akUofLtU5PCYwmC0bPMaBBKVUMyh5Ef+EB+Gn3P6ZwNotkBkQeX6ipvWUqRd47ICnMy6TQci4f7GdMdSOiG/5CiV/stSNDL8fSrIYcd+/leqd/nRjKf0QLRkRKrVQcUUaj15tzDQZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715281; c=relaxed/simple;
	bh=3v0iIOgjeLj6wXUIlaJP0Bo+PX8Kllf8I5EA1vQIJOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4feIi07hh8LBCQ1tV8AxnPjPGCeG58//fEdIOfigZkxRN2vWUAaiatjYgDjt0stAaLC7eanxi/W6RizLc+4jW/lzQkt6GY9TnGEldx88rpdMPVzGFv3mw4BBU/HGp5WVF3yAlkDl1vQkh2ThEURhGsKbe9xzIXDsJQ2QT2eKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFq+VefN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFq+VefN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED4DC4CEE7;
	Fri, 17 Oct 2025 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715281;
	bh=3v0iIOgjeLj6wXUIlaJP0Bo+PX8Kllf8I5EA1vQIJOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFq+VefNlpPbO4JNRT2kZzQkRGBYYeSKrziZspjcKmuL5b6AD8B6u+cMecAdx3t1N
	 PNfjrLcZxIucVg0+7vrI8Ik2lfZx38S45hRYJM8sLn76loT+6WW/hgdFUV3l9o/YAh
	 d8ZO99qzfR1JTUUOuJNTFPMj5w5UDcvRQV6YlmVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 128/371] gpio: wcd934x: mark the GPIO controller as sleeping
Date: Fri, 17 Oct 2025 16:51:43 +0200
Message-ID: <20251017145206.563184631@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit b5f8aa8d4bde0cf3e4595af5a536da337e5f1c78 ]

The slimbus regmap passed to the GPIO driver down from MFD does not use
fast_io. This means a mutex is used for locking and thus this GPIO chip
must not be used in atomic context. Change the can_sleep switch in
struct gpio_chip to true.

Fixes: 59c324683400 ("gpio: wcd934x: Add support to wcd934x gpio controller")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index 4af504c23e6ff..572b85e773700 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -103,7 +103,7 @@ static int wcd_gpio_probe(struct platform_device *pdev)
 	chip->base = -1;
 	chip->ngpio = WCD934X_NPINS;
 	chip->label = dev_name(dev);
-	chip->can_sleep = false;
+	chip->can_sleep = true;
 
 	return devm_gpiochip_add_data(dev, chip, data);
 }
-- 
2.51.0



