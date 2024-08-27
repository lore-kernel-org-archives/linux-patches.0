Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9E61C4EDE;
	Tue, 27 Aug 2024 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770238; cv=none; b=i5tcsQRM9+kQVXoV1Yqvs/COirz1yqaxer1KbZvUyh4b1eVOnXQ0MXzQ0QpzqmemHYs7qowEpKCYVzkcZSzWJVBP4+0k0d67oMSq4Ra+cmXK+jAVut9Z4YSECnZZiwQlq378bqaKoahxFMXUaevB+EprSA2n/rB+hYkor+3ghvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770238; c=relaxed/simple;
	bh=c5hnKTqsSnIDptF4oFiTFMe/03PI/uCySKEm7MCQBP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjYCPtL0sDKOZ3YJOZPSopkt8wwIEjszYGldjvinoK8vtmLHx1ph2ZxCq9oBDg0r91d66JaCvWAdilb1gPpfAAjLvO8f4+PTVFcjCka/pjNMeM7hyzfCc21mbRP6zrF1gHKaKMGsOZoPbTqQcxglmdn3/lah3wBS1Fk/1DltPQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ry6ZtAJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ry6ZtAJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C82C4DDFB;
	Tue, 27 Aug 2024 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770238;
	bh=c5hnKTqsSnIDptF4oFiTFMe/03PI/uCySKEm7MCQBP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ry6ZtAJw2GuymsDcNopRv73W11Ah8F9Vsm0/TsPk6w1756EjTvR3ajiePtcuxTQtZ
	 zmIaDskZVLEG+8yUf3Ux3+XhHfQtnrli3nxOWED56u7cyHPBYEWCFH5kmgeeuP0hW3
	 B5a+F34BcGt/nMfpp2y/aqgjeMKsGZhw4eDwutLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/341] gpio: sysfs: extend the critical section for unregistering sysfs devices
Date: Tue, 27 Aug 2024 16:36:40 +0200
Message-ID: <20240827143849.844521931@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 59cba4a0e6ca1058fbf88fec22530a4e2841802a ]

Checking the gdev->mockdev pointer for NULL must be part of the critical
section.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 12d853845bb80..6c27312c62788 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/init.h>
@@ -774,15 +775,15 @@ void gpiochip_sysfs_unregister(struct gpio_device *gdev)
 	struct gpio_desc *desc;
 	struct gpio_chip *chip = gdev->chip;
 
-	if (!gdev->mockdev)
-		return;
+	scoped_guard(mutex, &sysfs_lock) {
+		if (!gdev->mockdev)
+			return;
 
-	device_unregister(gdev->mockdev);
+		device_unregister(gdev->mockdev);
 
-	/* prevent further gpiod exports */
-	mutex_lock(&sysfs_lock);
-	gdev->mockdev = NULL;
-	mutex_unlock(&sysfs_lock);
+		/* prevent further gpiod exports */
+		gdev->mockdev = NULL;
+	}
 
 	/* unregister gpiod class devices owned by sysfs */
 	for_each_gpio_desc_with_flag(chip, desc, FLAG_SYSFS) {
-- 
2.43.0



