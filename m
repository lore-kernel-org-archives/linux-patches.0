Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A687B1DE4E0;
	Thu, 28 May 2026 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001049; cv=none; b=Yma4F7JO2xt1/Fp8UCOwyWAIOm/uDZIE3CTABu1Sj7TM8ApVR8LafaGlrWkoYms+SN1WV601aayzQZTL3Azl1hwcTbeL+/SLZVnQAZkLNrdcRqJm0knaBsXKDpbVoNUGWn3bCk6saGbyzc0QatwrSPA0eqZTBn4DiAVgkS95QIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001049; c=relaxed/simple;
	bh=ZJm23qJubAZunOh3yV6PCI3q7loFKeR39I3gOYGpgOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmxCNlhG9C6vYfwwje8EyDhdhGlt/fUnqPpBI/fyZyyckjrcjslYfYKeZ2WqKDzsEYW/xuX+B7G0fuO7mlYy3q8p2yYlmVvNVRyeKoyF78KxqjmXsODxayQvV3pTHl2zfJDNP4Bb2/1r0QaUiFVB55EGyRaUO5meXgiGbffYkvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYEEXzS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYEEXzS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116C91F000E9;
	Thu, 28 May 2026 20:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001048;
	bh=U1wVSxN5hB8oWkEu9QiVqllMg49hANtuP/mQRFZTSEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYEEXzS3Ymcp+qH96jQbzaFk706rrrnO9yGk1FSr+kctI9VJQd/HP6MMtrtmLmu7y
	 F5zk6p1c0YSJY4maz32w1vU58cowGhgqLa0YTJ3L8ohFZivpoUci1knAKGOXOrkPXj
	 8uga5rjGgu/qaxrtCMYUXBEKKr9B+CLb+x0DOVkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/272] gpiolib: cdev: use !mem_is_zero() instead of memchr_inv(s, 0, n)
Date: Thu, 28 May 2026 21:50:37 +0200
Message-ID: <20260528194636.452914526@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd2921ef29a14..d44a3e4c2a09c 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -16,7 +16,6 @@
 #include <linux/hte.h>
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
-#include <linux/kernel.h>
 #include <linux/kfifo.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -26,6 +25,7 @@
 #include <linux/rbtree.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/timekeeping.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
@@ -1331,7 +1331,7 @@ static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 	if (lc->num_attrs > GPIO_V2_LINE_NUM_ATTRS_MAX)
 		return -EINVAL;
 
-	if (memchr_inv(lc->padding, 0, sizeof(lc->padding)))
+	if (!mem_is_zero(lc->padding, sizeof(lc->padding)))
 		return -EINVAL;
 
 	for (i = 0; i < num_lines; i++) {
@@ -1746,7 +1746,7 @@ static int linereq_create(struct gpio_device *gdev, void __user *ip)
 	if ((ulr.num_lines == 0) || (ulr.num_lines > GPIO_V2_LINES_MAX))
 		return -EINVAL;
 
-	if (memchr_inv(ulr.padding, 0, sizeof(ulr.padding)))
+	if (!mem_is_zero(ulr.padding, sizeof(ulr.padding)))
 		return -EINVAL;
 
 	lc = &ulr.config;
@@ -2516,7 +2516,7 @@ static int lineinfo_get(struct gpio_chardev_data *cdev, void __user *ip,
 	if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
 		return -EFAULT;
 
-	if (memchr_inv(lineinfo.padding, 0, sizeof(lineinfo.padding)))
+	if (!mem_is_zero(lineinfo.padding, sizeof(lineinfo.padding)))
 		return -EINVAL;
 
 	desc = gpio_device_get_desc(cdev->gdev, lineinfo.offset);
-- 
2.53.0



