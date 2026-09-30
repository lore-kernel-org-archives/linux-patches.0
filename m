Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9555503918;
	Wed, 30 Sep 2026 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787552; cv=none; b=UesD/szk/gTyBF+qUOVkBzFV10va1cbKDbM7k4L2arTj6/g+m+zX1GWynRMYmoPPpYbSIYbpVklFk3nVxPgAaOJEJB7B7/VYCmga/Wbm/ote/Jt9FLWXpMhECr3ue/EdDlIuJWh0Y931fMLranPeMYiuygvvW0H+OEewfIrA2m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787552; c=relaxed/simple;
	bh=zcqgolWs4xyXUgkgopUy4vnYQHfyBHokicjf0m/rcWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyeN6jh/EfkifyzZreSA2x4JlVGyZVueQEOTJEOFSYF6q6uzV1kOr94IawVkBp5HoxNax0oAHj4RWCBZJqIYg20xE3l7hUJRoED95ub+Ck3U6mQ4+2z+vOjUiZt58OPhWvoY1UsfxpIvjnYnsWxEMgiRb0C/52cq+I5AM+xna0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDhTa8Sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDhTa8Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CFF1F000FF;
	Wed, 30 Sep 2026 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787550;
	bh=dd2HQrqRA1KUMK3beK7E2VwgwQH2U9uBGoI0UuTvUcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDhTa8Sw0hLOnWX6ZEn1hcEEXGsUJ6G3Zx8Q4im0YsfiCvpjL98nugWUxebCGYjL7
	 4b98NyFqeGfa6ZIonrYik/r3BOUqd5kpC4Co6XMMZGnRVHnGWzFdx4+kxe/wbQeRQJ
	 8KKzXrbkx3FPc1LPSpyRTHDHESM99qfRIdiDZXR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 270/457] gpio: cdev: fix kernel stack leak to user-space in error path
Date: Wed, 30 Sep 2026 17:26:15 +0200
Message-ID: <20260930152351.868340830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 1feb5d39b05afd902ed9fc902ec5b15be03a4bdb upstream.

If we fail to acquire the GPIO chip guard in gpio_desc_to_lineinfo(), we
return immediately before zeroing the info struct we'll end up passing
to the user-space later in lineinfo_get_v1(). This may leak the kernel
stack contents. Make gpio_desc_to_lineinfo() return int so that the
-ENODEV returned on failure to acquire the guard can be propagated to
the callers.

While not strictly necessary: move the memset() before trying to acquire
the SRCU read lock too for good measure.

Fixes: d83cee3d2bb1 ("gpio: protect the pointer to gpio_chip in gpio_device with SRCU")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260912123529.7951-1-tzungbi%40kernel.org?part=3
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Link: https://patch.msgid.link/20260922-gpio-cdev-stack-leak-fixes-v3-1-7a0c7a4299d5@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2172,18 +2172,19 @@ static void gpio_v2_line_info_changed_to
 
 #endif /* CONFIG_GPIO_CDEV_V1 */
 
-static void gpio_desc_to_lineinfo(struct gpio_desc *desc,
-				  struct gpio_v2_line_info *info, bool atomic)
+static int gpio_desc_to_lineinfo(struct gpio_desc *desc,
+				 struct gpio_v2_line_info *info, bool atomic)
 {
 	u32 debounce_period_us;
 	unsigned long dflags;
 	const char *label;
 
+	memset(info, 0, sizeof(*info));
+
 	CLASS(gpio_chip_guard, guard)(desc);
 	if (!guard.gc)
-		return;
+		return -ENODEV;
 
-	memset(info, 0, sizeof(*info));
 	info->offset = gpiod_hwgpio(desc);
 
 	if (desc->name)
@@ -2258,6 +2259,8 @@ static void gpio_desc_to_lineinfo(struct
 							debounce_period_us;
 		info->num_attrs++;
 	}
+
+	return 0;
 }
 
 struct gpio_chardev_data {
@@ -2309,6 +2312,7 @@ static int lineinfo_get_v1(struct gpio_c
 	struct gpio_desc *desc;
 	struct gpioline_info lineinfo;
 	struct gpio_v2_line_info lineinfo_v2;
+	int ret;
 
 	if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
 		return -EFAULT;
@@ -2326,7 +2330,10 @@ static int lineinfo_get_v1(struct gpio_c
 			return -EBUSY;
 	}
 
-	gpio_desc_to_lineinfo(desc, &lineinfo_v2, false);
+	ret = gpio_desc_to_lineinfo(desc, &lineinfo_v2, false);
+	if (ret)
+		return ret;
+
 	gpio_v2_line_info_to_v1(&lineinfo_v2, &lineinfo);
 
 	if (copy_to_user(ip, &lineinfo, sizeof(lineinfo))) {
@@ -2344,6 +2351,7 @@ static int lineinfo_get(struct gpio_char
 {
 	struct gpio_desc *desc;
 	struct gpio_v2_line_info lineinfo;
+	int ret;
 
 	if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
 		return -EFAULT;
@@ -2363,7 +2371,10 @@ static int lineinfo_get(struct gpio_char
 		if (test_and_set_bit(lineinfo.offset, cdev->watched_lines))
 			return -EBUSY;
 	}
-	gpio_desc_to_lineinfo(desc, &lineinfo, false);
+
+	ret = gpio_desc_to_lineinfo(desc, &lineinfo, false);
+	if (ret)
+		return ret;
 
 	if (copy_to_user(ip, &lineinfo, sizeof(lineinfo))) {
 		if (watch)
@@ -2489,6 +2500,7 @@ static int lineinfo_changed_notify(struc
 	struct lineinfo_changed_ctx *ctx;
 	struct gpio_desc *desc = data;
 	struct file *fp;
+	int ret;
 
 	if (!test_bit(gpiod_hwgpio(desc), cdev->watched_lines))
 		return NOTIFY_DONE;
@@ -2519,7 +2531,13 @@ static int lineinfo_changed_notify(struc
 
 	ctx->chg.event_type = action;
 	ctx->chg.timestamp_ns = ktime_get_ns();
-	gpio_desc_to_lineinfo(desc, &ctx->chg.info, true);
+
+	ret = gpio_desc_to_lineinfo(desc, &ctx->chg.info, true);
+	if (ret) {
+		fput(fp);
+		return NOTIFY_DONE;
+	}
+
 	/* Keep the GPIO device alive until we emit the event. */
 	ctx->gdev = gpio_device_get(desc->gdev);
 	ctx->cdev = cdev;


