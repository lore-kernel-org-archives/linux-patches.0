Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF42A332ECC;
	Mon, 29 Dec 2025 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026011; cv=none; b=PjQHG6hGD/BzDw1nCxsByv8L+mG1Ashf8xSDTGAASYCFA1jFXqYrG4IuiGFWbXZDQ+jxQ86VoALL2OhWNTZDMW+sz8sTqUQ4DDUvkv8OvaVN5ROFve66ANRm0v4FBlbSAHFLVOLa6pWjHb+kTEiEmZSxMOIq8SKO/fsffPaGfhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026011; c=relaxed/simple;
	bh=O9bpsTyoiDQMyVsFe2okxWTAdAtz5ibEahAlnfilUt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8Y9qsGW0sDqHzbX/v/Xgp9d7LSkOwK+QDjXzWpq3wevQoEc9JAgkoNVQ7X5Pyv91KkpMiDM5iq/I8vxxuKrT5bwjJNvGHxJKB8cS3c4klR4RwGbu0P+FJC3Ffo52Aosd7+d337+n16tnyEHFGlEdZ/vTS/jjU4W3nNkM4xyTLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoxfsKwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoxfsKwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14462C4CEF7;
	Mon, 29 Dec 2025 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026010;
	bh=O9bpsTyoiDQMyVsFe2okxWTAdAtz5ibEahAlnfilUt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoxfsKwWG8TX9gHEhLCAnzRcNnF9Ltvk0WdLFkpG3kayAv2Y9Qzem2e4bEYN141hr
	 zQIA/1FEJZuag1matALK6VZIIxpoB3O81yzsMrVg9sVZEhjKs1ojK5FZg4PBjHiN98
	 G8rO1RLr3nQMOfT+fnF/929DK5hVoppN9lZKMvsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyl5933@chinaunicom.cn>,
	Wentao Guan <guanwentao@uniontech.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 382/430] gpio: regmap: Fix memleak in error path in gpio_regmap_register()
Date: Mon, 29 Dec 2025 17:13:04 +0100
Message-ID: <20251229160738.379850864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

commit 52721cfc78c76b09c66e092b52617006390ae96a upstream.

Call gpiochip_remove() to free the resources allocated by
gpiochip_add_data() in error path.

Fixes: 553b75d4bfe9 ("gpio: regmap: Allow to allocate regmap-irq device")
Fixes: ae495810cffe ("gpio: regmap: add the .fixed_direction_output configuration parameter")
CC: stable@vger.kernel.org
Co-developed-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20251204101303.30353-1-guanwentao@uniontech.com
[Bartosz: reworked the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -328,7 +328,7 @@ struct gpio_regmap *gpio_regmap_register
 						 config->regmap_irq_line, config->regmap_irq_flags,
 						 0, config->regmap_irq_chip, &gpio->irq_chip_data);
 		if (ret)
-			goto err_free_bitmap;
+			goto err_remove_gpiochip;
 
 		irq_domain = regmap_irq_get_domain(gpio->irq_chip_data);
 	} else


