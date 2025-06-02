Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA9A2405FD;
	Mon,  2 Jun 2025 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873005; cv=none; b=s2MvZGpHPmncQMofiBOH+f+VMDhxWt7a/TTF2Xxrf8tsd1wA9DqgYVlJWizheGpLQ2hv+LULxIvCEpPwr4/09pFj2RgdqX5mB2r6uKBPkRvMOI+VAL2YuEYZyNDyJ4VD+M5MoHdsFRiD0eVbHm2l2pREzWcyBLHZcfwo/HSD8KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873005; c=relaxed/simple;
	bh=vOYUuKrsMWUnySaIbniUcLC03MXf+tu0yitsV8yEZUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itYvea9A3EWZgf5AFguWn63Dltu6sM/KYQeA8ssPkaCFoyfVAn6WxMp2nrZ3DVxMcdoB/MJzn0V1KNWm12b+KvTcU2sVhE3kmTPN6DGxlHv58t2rj5uxPMZ2TCbzKo27bz71cJv0BAkpEz3AmU8wPRyUx/UbE+WbI3ybP+Ked4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgsHJoVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgsHJoVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C0CC4CEEB;
	Mon,  2 Jun 2025 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873005;
	bh=vOYUuKrsMWUnySaIbniUcLC03MXf+tu0yitsV8yEZUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgsHJoVzs+w8fIphs15EA10Uirbsxp4AjhXMGsupgW6dH7q+CKOFTx9h8FxXYMoYR
	 U+gVRCwffoF0Gpl7MdKUQFuyzCfsNdUPtyS/a+VOksBvVlHBKdT7guucFoUENRYqgh
	 UutfAzhxH9FtlEhEZmN5pzs1BL3O7M7LS6WEGvdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/444] gpio: pca953x: Split pca953x_restore_context() and pca953x_save_context()
Date: Mon,  2 Jun 2025 15:41:05 +0200
Message-ID: <20250602134340.970935606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index b882b26ab5007..fddf0cf031007 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1168,9 +1168,9 @@ static int pca953x_probe(struct i2c_client *client)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int pca953x_regcache_sync(struct device *dev)
+static int pca953x_regcache_sync(struct pca953x_chip *chip)
 {
-	struct pca953x_chip *chip = dev_get_drvdata(dev);
+	struct device *dev = &chip->client->dev;
 	int ret;
 	u8 regaddr;
 
@@ -1217,13 +1217,37 @@ static int pca953x_regcache_sync(struct device *dev)
 	return 0;
 }
 
-static int pca953x_suspend(struct device *dev)
+static int pca953x_restore_context(struct pca953x_chip *chip)
 {
-	struct pca953x_chip *chip = dev_get_drvdata(dev);
+	int ret;
+
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
@@ -1246,17 +1270,7 @@ static int pca953x_resume(struct device *dev)
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



