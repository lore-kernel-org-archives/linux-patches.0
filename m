Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B37F2F619D;
	Thu, 15 Jan 2026 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496964; cv=none; b=tAWM1qxbhfLsPs/enug45zsJvzPD4pzbii0jsN+3Z/v6ABNy4rp38h/RiYsDV81AKqsmhdGAGzeq2rjtVIPTU/QqloYdJKrp2W63mZ4qazQqu65Yhqhct5pLeZZXRH8ejBkFfvISv7580mZJFXIKWLd5MldJjg7nfGZbKdQyi08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496964; c=relaxed/simple;
	bh=bp4tLl0qe3VeKvW3HMp/gpN5qHizZVd3e9vjZzMsdWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFqqtT3b/oC8XqzVSVnhdwtW4jP5JDQ+E8qnouoolbDk3qvk0cSRNG1nM2975xK/tGLJUhDMEAsSCE0VP37Z370+tYLiM0hssVy6TX/0k3NFMnkRh8e9OJSJU9ZqhiDy4Qv3G9dn2GWNzVgHfXH5fr9tqM/hLxJJxTso+ET9IHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMz2RJUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMz2RJUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882ADC116D0;
	Thu, 15 Jan 2026 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496963;
	bh=bp4tLl0qe3VeKvW3HMp/gpN5qHizZVd3e9vjZzMsdWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMz2RJUt2h9KVrpkUlmO1Wop67Q4ZqTzAjOpe8juIZ5mIQ4pnOO5WMdYnBsDaVX6I
	 dEmzgnSJ/+KSv9i2xJPkGeoCdqsezrL6+3oX6anvpe5w+nE2JvviVBOIIGwJ1Ptz9L
	 +bZjBvMyN9ZRS2+Ed8KT7XNyRJBVizja2kPu1PqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 44/88] gpio: pca953x: Utilise dev_err_probe() where it makes sense
Date: Thu, 15 Jan 2026 17:48:27 +0100
Message-ID: <20260115164147.904753069@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c47f7ff0fe61738a40b1b4fef3cd8317ec314079 ]

At least in pca953x_irq_setup() we may use dev_err_probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 014a17deb412 ("gpio: pca953x: handle short interrupt pulses on PCAL devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index faadbe66b23e7..3a0b999521e44 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -895,6 +895,7 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 {
 	struct i2c_client *client = chip->client;
+	struct device *dev = &client->dev;
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	DECLARE_BITMAP(irq_stat, MAX_LINE);
 	struct gpio_irq_chip *girq;
@@ -943,11 +944,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 					NULL, pca953x_irq_handler,
 					IRQF_ONESHOT | IRQF_SHARED,
 					dev_name(&client->dev), chip);
-	if (ret) {
-		dev_err(&client->dev, "failed to request irq %d\n",
-			client->irq);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, client->irq, "failed to request irq\n");
 
 	return 0;
 }
-- 
2.51.0



