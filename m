Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625EC47125D;
	Tue, 21 Jul 2026 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657932; cv=none; b=M5cToK5g/LGR/hL2Cta3P6tniaRm7tPGKW1b0OtKwEsbdaacxj40gVbtkVeVFu5jUa5fn18+85Auu47tkrDwg34fIKi0T1mF+GSHZ2soVB0gvqf16lMI5on+mJ9wa1BnKJ3NyuLGrj4T00hTQtl7jR116PpoFtfnEBpCWx8YEZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657932; c=relaxed/simple;
	bh=oYDAM0PmQDMw2odG+8bXYw48ywacQzeRXoplINjw0Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXXEjZDBqp7WaQmwCt58BvujM69RAipK9gpPxyyc/4V3loit+9q7d0Ga4MITU0NidvFa/S8smPyzR/iK4H+/QD9SnR9H5NtUVAxygBKzDELl33MQe2ogl8ifKeK5V8IyatryPoMTARdqi2dbOY4zLPHbuwZq8usmN/wrHujp/MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpUeMPBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpUeMPBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97F61F000E9;
	Tue, 21 Jul 2026 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657931;
	bh=dBIv3HUMSD1KpzefabY/dhhzbLtQQFP6XPDdKj9LaM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpUeMPBr+ylV2s4wu8oNo9rtvlW7yAFyYEHh3EBFB9rxKinKf969RzclxyYlZu6jR
	 0n416R0v6cSobn95vuYhK9RaEycxxnOyMR6Uyc3MX3CKcHi5c+XXeOztL/VUUWDmWB
	 w4SEJ5CJDu1x9BtA6ARGdBzFnmonTML6fWIDHivY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0952/1611] gpio: mvebu: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:17:48 +0200
Message-ID: <20260721152536.804604858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 479e91fc92416a4d54d2b3150aa1e4550d9cc759 ]

mvebu_gpio_probe() registers the GPIO chip with
devm_gpiochip_add_data() but ignores the return value. If registration
fails, probe continues and leaves later code operating on a GPIO chip
that was never published to gpiolib.

Return the registration error so the device fails probe cleanly.

Fixes: fefe7b092345 ("gpio: introduce gpio-mvebu driver for Marvell SoCs")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624131645.86884-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index a7018e8ed88b10..2b5112e3210ba3 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1222,7 +1222,10 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		BUG();
 	}
 
-	devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	err = devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	if (err)
+		return dev_err_probe(&pdev->dev, err,
+				     "failed to register gpiochip\n");
 
 	/* Some MVEBU SoCs have simple PWM support for GPIO lines */
 	if (IS_REACHABLE(CONFIG_PWM)) {
-- 
2.53.0



