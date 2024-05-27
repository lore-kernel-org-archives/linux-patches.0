Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C811EEF7;
	Mon, 27 May 2024 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838566; cv=none; b=bD1OkQDf9c3ao+xJQJ5suEgTzPbkRMaBuAsFF5ZWbBF731QgqMZ7GLvUkCrA4yWm/tDjUgXGlgM2zpwnjdYRwGejRPp78y8+LSVLoQ0ITkg8jC2xKiT4UtHiz+9sWLxvEiAiQstVz/g35Ug8dmpqEUYb4ZQ6JqMLElqtkPjUPlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838566; c=relaxed/simple;
	bh=KRJbYifaxF9mMEMDo+D5yP/K+u0+Yg1UoGzy23ExHd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkPROPfkrRlt2S5zy1kIzptthV/YbuQyrOUHNVOPFdJXkWkLV2Ta3NYW/wmvXwaTfvLG6ptMJ8aHzeWY3D13RE93sCtt3ce7JXlr3eSbA+pXIgJj8SsPp1/2g7Hbz6xyyO0oloo428OI0kTU98Owg6QG8HrMGEm4OsHdsE1Tq8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4wxEBZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4wxEBZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D869C2BBFC;
	Mon, 27 May 2024 19:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838565;
	bh=KRJbYifaxF9mMEMDo+D5yP/K+u0+Yg1UoGzy23ExHd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4wxEBZVHubfmzoa0XyDUPby621Fa4i/6o6Qu/oz83SrPk4TJ/FzMl7W3BySgYflx
	 kuat6FmeHA9olPMJgCWQPF5VwsxDWIoiyXjk2MD/eK+ZNrDK7Ae/kj/NsO7Sc+jzhP
	 LOby5kBmIlAovnX7SWEPuxiAWq3XqeEx7aKt0Tgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 392/493] platform/x86: xiaomi-wmi: Fix race condition when reporting key events
Date: Mon, 27 May 2024 20:56:34 +0200
Message-ID: <20240527185643.096458615@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



