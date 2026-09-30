Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98198523785;
	Wed, 30 Sep 2026 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790410; cv=none; b=FFCGAnH6IO6YAyM058XSalTSZlFy2BhFp/nMVXC2X2voTJGszxY/PNsxK4XPW3OETw1Nz9t+YTTZot4r+gfz/FGgi/EUrqvxNmNVReVq4DB6co3zvOnvd58I7eIKk/uj2v/U8CpqlYJ8kv1s+tq5kRB6gBTd2HpG3SGYNGFjJ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790410; c=relaxed/simple;
	bh=7BJhy+RE0YMaCfS6xBN3XBVczwCj3jItrGVb4K8gEH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f/Df6AlWrZwnLrdcVk6KpyeZV31GzX6W/REdzrhYn68Ew3iddexiMmfxl6hgXmsvl7WTQ285Y497oC9PXVAgoIwvvX2lvWsLT36DKaSv1UBaHc/GmldLCl4sdGKo/qfczAU7Qlrg1Zqkz7Crg+qjLjdlF32uxap8shB2OixSnks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATtMMBJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATtMMBJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53F11F000FF;
	Wed, 30 Sep 2026 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790409;
	bh=DoStgfNdEjHt0RHmxX6RQZGff7FZa9DaC0YJC4qb6/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATtMMBJZOzdgikWrp+J6FSwwxEtnX8Y5sRaL3Ha4CrolfIbClwf3YmJUJ9126+QD3
	 I0n9MrztRyddYIrISGwnLx1jtktYYGq0bFM2g90RfsgEL4UE4NI8kA19RlEMegL0yQ
	 ecuINObqXFkhJZUy0c2j/Jm6dLgOIfljyXb1SaO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 818/877] gpio: cdev: fix kernel stack leak to user-space in error path
Date: Wed, 30 Sep 2026 17:28:49 +0200
Message-ID: <20260930152432.378257231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 1feb5d39b05afd902ed9fc902ec5b15be03a4bdb ]

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
[ retained the two-argument gpio_desc_to_lineinfo() signature for Linux 6.12’s synchronous notifier. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2365,17 +2365,18 @@ static void gpio_v2_line_info_changed_to
 
 #endif /* CONFIG_GPIO_CDEV_V1 */
 
-static void gpio_desc_to_lineinfo(struct gpio_desc *desc,
-				  struct gpio_v2_line_info *info)
+static int gpio_desc_to_lineinfo(struct gpio_desc *desc,
+				 struct gpio_v2_line_info *info)
 {
 	unsigned long dflags;
 	const char *label;
 
+	memset(info, 0, sizeof(*info));
+
 	CLASS(gpio_chip_guard, guard)(desc);
 	if (!guard.gc)
-		return;
+		return -ENODEV;
 
-	memset(info, 0, sizeof(*info));
 	info->offset = gpio_chip_hwgpio(desc);
 
 	if (desc->name)
@@ -2440,6 +2441,8 @@ static void gpio_desc_to_lineinfo(struct
 		info->flags |= GPIO_V2_LINE_FLAG_EVENT_CLOCK_REALTIME;
 	else if (test_bit(FLAG_EVENT_CLOCK_HTE, &dflags))
 		info->flags |= GPIO_V2_LINE_FLAG_EVENT_CLOCK_HTE;
+
+	return 0;
 }
 
 struct gpio_chardev_data {
@@ -2490,6 +2493,7 @@ static int lineinfo_get_v1(struct gpio_c
 	struct gpio_desc *desc;
 	struct gpioline_info lineinfo;
 	struct gpio_v2_line_info lineinfo_v2;
+	int ret;
 
 	if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
 		return -EFAULT;
@@ -2507,7 +2511,10 @@ static int lineinfo_get_v1(struct gpio_c
 			return -EBUSY;
 	}
 
-	gpio_desc_to_lineinfo(desc, &lineinfo_v2);
+	ret = gpio_desc_to_lineinfo(desc, &lineinfo_v2);
+	if (ret)
+		return ret;
+
 	gpio_v2_line_info_to_v1(&lineinfo_v2, &lineinfo);
 
 	if (copy_to_user(ip, &lineinfo, sizeof(lineinfo))) {
@@ -2525,6 +2532,7 @@ static int lineinfo_get(struct gpio_char
 {
 	struct gpio_desc *desc;
 	struct gpio_v2_line_info lineinfo;
+	int ret;
 
 	if (copy_from_user(&lineinfo, ip, sizeof(lineinfo)))
 		return -EFAULT;
@@ -2544,7 +2552,11 @@ static int lineinfo_get(struct gpio_char
 		if (test_and_set_bit(lineinfo.offset, cdev->watched_lines))
 			return -EBUSY;
 	}
-	gpio_desc_to_lineinfo(desc, &lineinfo);
+
+	ret = gpio_desc_to_lineinfo(desc, &lineinfo);
+	if (ret)
+		return ret;
+
 	supinfo_to_lineinfo(desc, &lineinfo);
 
 	if (copy_to_user(ip, &lineinfo, sizeof(lineinfo))) {
@@ -2637,7 +2649,11 @@ static int lineinfo_changed_notify(struc
 	memset(&chg, 0, sizeof(chg));
 	chg.event_type = action;
 	chg.timestamp_ns = ktime_get_ns();
-	gpio_desc_to_lineinfo(desc, &chg.info);
+
+	ret = gpio_desc_to_lineinfo(desc, &chg.info);
+	if (ret)
+		return NOTIFY_DONE;
+
 	supinfo_to_lineinfo(desc, &chg.info);
 
 	ret = kfifo_in_spinlocked(&cdev->events, &chg, 1, &cdev->wait.lock);


