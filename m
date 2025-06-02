Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A964223DE5;
	Mon,  2 Jun 2025 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876582; cv=none; b=ivWO8cSp6LFJrZA+Jc2YYSvV7xhAV43RtvTi67WvHuiJXHO9gxyuKNeovLOA6VfKnBrtuZHHexeh4+g9+LjA7UtVw3hU61t9IzOI5LmZGRgAkFzIsU1tX188hGyR8z6YAA9VniKtBJ2ccUrQ9330i8NrmxaMSo5sb/NTCoZ8IGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876582; c=relaxed/simple;
	bh=4rDZXCEMRd6V8JVQxm+vrREoZ01rLAHTQkq0gwidN94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPXEf2UvUiTh1eRWtvakGYSDQUh5w9iqKEr2eXs7kcTf0GIAZQkEYx89umfcJvEy7PA6A/Pi6eWAfp4iNfJfsJv+LEVCPWxP/zJN71mJQ32vvBQoi2X48LfkAsqXYuyuZqbmQNA9dBqfjydyYBAzplrBZNzV5Ve0/2Tdv5PplKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtkeKgls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtkeKgls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C512C4CEEB;
	Mon,  2 Jun 2025 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876582;
	bh=4rDZXCEMRd6V8JVQxm+vrREoZ01rLAHTQkq0gwidN94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtkeKglsx1foaYgrD0SYeaSmTmC4n4UG6wl+w6GVNFlCEd8gASHnd3b2Z7oUvaA5m
	 ct82duydzg1aikm7vmk8B4+IXhib4dEuYG8+M6zKejY7b5CTdr/YVXrOGpRrDYlsX/
	 eUYqH6teFy30/iyFz/C5KSuW1/uD1l5DSK2t5dT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/325] gpio: pca953x: Split pca953x_restore_context() and pca953x_save_context()
Date: Mon,  2 Jun 2025 15:44:38 +0200
Message-ID: <20250602134319.828797703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ec5bde62019b0a5300c67bd81b9864a8ea12274e ]

Split regcache handling to the respective helpers. It will allow to
have further refactoring with ease.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 3e38f946062b ("gpio: pca953x: fix IRQ storm on system wake up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 44 ++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index caf3bb6cb6b9f..db4a48558c676 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1200,9 +1200,9 @@ static void pca953x_remove(struct i2c_client *client)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int pca953x_regcache_sync(struct device *dev)
+static int pca953x_regcache_sync(struct pca953x_chip *chip)
 {
-	struct pca953x_chip *chip = dev_get_drvdata(dev);
+	struct device *dev = &chip->client->dev;
 	int ret;
 	u8 regaddr;
 
@@ -1249,13 +1249,37 @@ static int pca953x_regcache_sync(struct device *dev)
 	return 0;
 }
 
-static int pca953x_suspend(struct device *dev)
+static int pca953x_restore_context(struct pca953x_chip *chip)
 {
-	struct pca953x_chip *chip = dev_get_drvdata(dev);
+	int ret;
 
+	mutex_lock(&chip->i2c_lock);
+
+	regcache_cache_only(chip->regmap, false);
+	regcache_mark_dirty(chip->regmap);
+	ret = pca953x_regcache_sync(chip);
+	if (ret) {
+		mutex_unlock(&chip->i2c_lock);
+		return ret;
+	}
+
+	ret = regcache_sync(chip->regmap);
+	mutex_unlock(&chip->i2c_lock);
+	return ret;
+}
+
+static void pca953x_save_context(struct pca953x_chip *chip)
+{
 	mutex_lock(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, true);
 	mutex_unlock(&chip->i2c_lock);
+}
+
+static int pca953x_suspend(struct device *dev)
+{
+	struct pca953x_chip *chip = dev_get_drvdata(dev);
+
+	pca953x_save_context(chip);
 
 	if (atomic_read(&chip->wakeup_path))
 		device_set_wakeup_path(dev);
@@ -1278,17 +1302,7 @@ static int pca953x_resume(struct device *dev)
 		}
 	}
 
-	mutex_lock(&chip->i2c_lock);
-	regcache_cache_only(chip->regmap, false);
-	regcache_mark_dirty(chip->regmap);
-	ret = pca953x_regcache_sync(dev);
-	if (ret) {
-		mutex_unlock(&chip->i2c_lock);
-		return ret;
-	}
-
-	ret = regcache_sync(chip->regmap);
-	mutex_unlock(&chip->i2c_lock);
+	ret = pca953x_restore_context(chip);
 	if (ret) {
 		dev_err(dev, "Failed to restore register map: %d\n", ret);
 		return ret;
-- 
2.39.5



