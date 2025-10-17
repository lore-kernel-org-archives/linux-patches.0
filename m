Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170613370FB;
	Fri, 17 Oct 2025 15:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713605; cv=none; b=H8Gm0d2MtfAEGQ3C5is8iD8PeZINgBkRbtRW6kR8LXq13337mmM1zD4BOWDTThgG21HKuSR5Kh6jg80sZOLa4PZAXd6J5nu6LeKD++Me4+CBZX+kT/XA6cbEJEXkpU0xhd1sYvJcvsHw2WzIkd9CpuhziErDfvZtgcj0yePikdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713605; c=relaxed/simple;
	bh=1bIpEx+VM2WZHcty+75nxxHG7V/Xjd3QOfgOngFWpIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBOww4vospw4uGzdTVoARhmlN8S6OSTpD3xY52+u6UfToJjGs/g0ww7BwSedIHyFLCHf0ckxH4BRuAdIMEyao4Oh04CCgo4Q0YeexVsU9y2NP+ZBGgi116HEGcNfX8mCvFSlz6C8iDsgcHkfXFmK7s6MA1Umyst8TgUbfWbA33M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zt327b2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zt327b2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FB2C4CEE7;
	Fri, 17 Oct 2025 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713605;
	bh=1bIpEx+VM2WZHcty+75nxxHG7V/Xjd3QOfgOngFWpIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zt327b2UgKG5oKg20LNCkoWidVvQEzHypqA3hewQkoxYOMJeoZC2ZQLrS4jBH3Fx1
	 IvFLckeU4X+SNXVH3cm/5HMHtnZwgUZsCNH75yyowh+MuvmipWS/4HyWlEFe1bcdp0
	 /PUsw++Rdc2rC+3V2CplqBT/1mj9kXVfOsD1FF6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/201] gpio: wcd934x: mark the GPIO controller as sleeping
Date: Fri, 17 Oct 2025 16:51:57 +0200
Message-ID: <20251017145136.802412248@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cfa7b0a50c8e3..03b16b8f639ad 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -102,7 +102,7 @@ static int wcd_gpio_probe(struct platform_device *pdev)
 	chip->base = -1;
 	chip->ngpio = WCD934X_NPINS;
 	chip->label = dev_name(dev);
-	chip->can_sleep = false;
+	chip->can_sleep = true;
 
 	return devm_gpiochip_add_data(dev, chip, data);
 }
-- 
2.51.0



