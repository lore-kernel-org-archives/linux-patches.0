Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7F619ADAD;
	Thu,  6 Jun 2024 14:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683365; cv=none; b=GL93zAfghJ3xq+wmOpspfP7JRojyNsmzmXOkCKxDCb7Ff7LJS59OquMM7lz8as+UfDeTYVFaNUxXMG+F2X1K5p8F0703AimEIOtdj23y30ca5zv5Xux6U3cYXy4KMwVj0EQzE5zDiXOy8s2DWJAxQLTGq+bSGYsMB2rw30EUB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683365; c=relaxed/simple;
	bh=HUXHO+ree7SZuLXUaw8oDjOlzA8jMbu3jUadAkef824=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDIq4If001lfNMZ9LOiC+6WcsFyrN4YXo5MstAFn3G83Wa2CJe6gYPK5N/6B11zJ27cbuiPVP0xqUFcBTxWnCXwHPp7EFk+pwy9UG28TFIGJBW8jOUwzTEIOCT7QNDmdQBowXXiJ3OtKbUOhej5G1fwUxiief1vBhshxbNTw/1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ag+zCAYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ag+zCAYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC6EC2BD10;
	Thu,  6 Jun 2024 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683365;
	bh=HUXHO+ree7SZuLXUaw8oDjOlzA8jMbu3jUadAkef824=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ag+zCAYHwOkpKnBuDnGNgfY2gjs+TrlExAPxR/7b5TNyzrVP+n9a9Iyj8YQZfHjQI
	 TwlPpc+iOjbdIo/Kri/6h8jcZzEy0MQ/871uNg0VbdBh0aphaAc7hitHDkp71AtC/p
	 I3B7SHgyqOg+SQupBwY1zDZrshp27uFsQbmUVHlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/744] platform/x86: xiaomi-wmi: Fix race condition when reporting key events
Date: Thu,  6 Jun 2024 15:59:39 +0200
Message-ID: <20240606131742.234515336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 290680c2da8061e410bcaec4b21584ed951479af ]

Multiple WMI events can be received concurrently, so multiple instances
of xiaomi_wmi_notify() can be active at the same time. Since the input
device is shared between those handlers, the key input sequence can be
disturbed.

Fix this by protecting the key input sequence with a mutex.

Compile-tested only.

Fixes: edb73f4f0247 ("platform/x86: wmi: add Xiaomi WMI key driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20240402143059.8456-2-W_Armin@gmx.de
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/xiaomi-wmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/platform/x86/xiaomi-wmi.c b/drivers/platform/x86/xiaomi-wmi.c
index 54a2546bb93bf..be80f0bda9484 100644
--- a/drivers/platform/x86/xiaomi-wmi.c
+++ b/drivers/platform/x86/xiaomi-wmi.c
@@ -2,8 +2,10 @@
 /* WMI driver for Xiaomi Laptops */
 
 #include <linux/acpi.h>
+#include <linux/device.h>
 #include <linux/input.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/wmi.h>
 
 #include <uapi/linux/input-event-codes.h>
@@ -20,12 +22,21 @@
 
 struct xiaomi_wmi {
 	struct input_dev *input_dev;
+	struct mutex key_lock;	/* Protects the key event sequence */
 	unsigned int key_code;
 };
 
+static void xiaomi_mutex_destroy(void *data)
+{
+	struct mutex *lock = data;
+
+	mutex_destroy(lock);
+}
+
 static int xiaomi_wmi_probe(struct wmi_device *wdev, const void *context)
 {
 	struct xiaomi_wmi *data;
+	int ret;
 
 	if (wdev == NULL || context == NULL)
 		return -EINVAL;
@@ -35,6 +46,11 @@ static int xiaomi_wmi_probe(struct wmi_device *wdev, const void *context)
 		return -ENOMEM;
 	dev_set_drvdata(&wdev->dev, data);
 
+	mutex_init(&data->key_lock);
+	ret = devm_add_action_or_reset(&wdev->dev, xiaomi_mutex_destroy, &data->key_lock);
+	if (ret < 0)
+		return ret;
+
 	data->input_dev = devm_input_allocate_device(&wdev->dev);
 	if (data->input_dev == NULL)
 		return -ENOMEM;
@@ -59,10 +75,12 @@ static void xiaomi_wmi_notify(struct wmi_device *wdev, union acpi_object *dummy)
 	if (data == NULL)
 		return;
 
+	mutex_lock(&data->key_lock);
 	input_report_key(data->input_dev, data->key_code, 1);
 	input_sync(data->input_dev);
 	input_report_key(data->input_dev, data->key_code, 0);
 	input_sync(data->input_dev);
+	mutex_unlock(&data->key_lock);
 }
 
 static const struct wmi_device_id xiaomi_wmi_id_table[] = {
-- 
2.43.0



