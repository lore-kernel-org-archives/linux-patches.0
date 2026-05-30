Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F56233D9E;
	Sat, 30 May 2026 18:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165187; cv=none; b=Z9ptd8Lr3dfxcTGTLC8VKQ+KwJX36p/dv7VuNiJ6YNpYZPNaHuHMWJhDCj3J548knFZcDlpWfIsQcnzsq+Q/06mhjVR/DKgQCgJWJ3/veUlJsL7wTkL+KEb2vkrrVtDJFtsElvh5X4yIt9Vdq8p6v2HSec80aDeGnAQpX4q1A80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165187; c=relaxed/simple;
	bh=Fznl6wmStpQxn1muyX94fKXhDF0Ri09+gvmhI4Gsrwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOeWKDeRdtkQ3GlP+QoNsNgiVo8+vPwbcAzYecqkzFLLEkxAS7yqJuJOmT0adotyk4gisfdCc3QIxaRcWpYu6vgRLu6p1JGIAP4+GfRNBwiIBi+562ozZT3YM/lqNDHuPUbE5L5A9X4zqIHcGWbCuC75JByB8w7oB3L9XZb+j68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vUC7Drm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vUC7Drm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870E71F00893;
	Sat, 30 May 2026 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165186;
	bh=f4wWvhmGjyYqs9cIVa2TsgNARuLC/KTU3/sF9fezjaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vUC7DrmqMK4ECK2/dAuWnKUBYvMsMNGriYXmZJxomBahr0cr5rrExV6TqSUtkaOQ
	 WsjN5WewbELU24Ng4vj5ynfmHjUPURODQgfBoll8sqxLJ4pdxhe1L2QRDcNIA0whWX
	 gW8RX7rB6aaSpvSlimhXSUUMLgSpCPFsL/+ACFHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 774/776] gpiolib: cdev: use !mem_is_zero() instead of memchr_inv(s, 0, n)
Date: Sat, 30 May 2026 18:08:08 +0200
Message-ID: <20260530160259.706244750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit e106b1dd38e723ec2bb2bf57ea9b2aff464b9423 ]

Use the mem_is_zero() helper where possible.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20241110201706.16614-1-andy.shevchenko@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 3e6ccd790ed6 ("gpio: cdev: check if uAPI v2 config attributes are correctly zeroed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index d4b221c90bb20..58ad8328bedc2 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -14,13 +14,13 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
-#include <linux/kernel.h>
 #include <linux/kfifo.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/poll.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/timekeeping.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
@@ -1018,7 +1018,7 @@ static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 	if (lc->num_attrs > GPIO_V2_LINE_NUM_ATTRS_MAX)
 		return -EINVAL;
 
-	if (memchr_inv(lc->padding, 0, sizeof(lc->padding)))
+	if (!mem_is_zero(lc->padding, sizeof(lc->padding)))
 		return -EINVAL;
 
 	for (i = 0; i < num_lines; i++) {
@@ -1437,7 +1437,7 @@ static int linereq_create(struct gpio_device *gdev, void __user *ip)
 	if ((ulr.num_lines == 0) || (ulr.num_lines > GPIO_V2_LINES_MAX))
 		return -EINVAL;
 
-	if (memchr_inv(ulr.padding, 0, sizeof(ulr.padding)))
+	if (!mem_is_zero(ulr.padding, sizeof(ulr.padding)))
 		return -EINVAL;
 
 	lc = &ulr.config;
@@ -2202,7 +2202,7 @@ static int lineinfo_get(struct gpio_chardev_data *cdev, void __user *ip,
 	if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
 		return -EFAULT;
 
-	if (memchr_inv(lineinfo.padding, 0, sizeof(lineinfo.padding)))
+	if (!mem_is_zero(lineinfo.padding, sizeof(lineinfo.padding)))
 		return -EINVAL;
 
 	desc = gpiochip_get_desc(cdev->gdev->chip, lineinfo.offset);
-- 
2.53.0



