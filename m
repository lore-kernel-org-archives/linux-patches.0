Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6806219AD46;
	Thu,  6 Jun 2024 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683331; cv=none; b=YWA1DRxD7WnV1Mq3OVV96POnJ2e55rbNUYUCSfdqQL5XEuWi0qjD4HmfSQtqhn3DQhOSF2G2W94nFr6yirxvvxIB5vjUdYDeVe6XNzGh3+RxxA/bXaBiJ8fNW9rlVdCQf9DoHPsVN5gaZd4dzM3woToDnFFx2F2E9EvRw17Wwgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683331; c=relaxed/simple;
	bh=SdXA4d8f7ZkjkIjMOsCfwk2Cw6Dv+RqMahcIuxAJr1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwy1VdBpH+0Lgul4RouLIGGUsu9vG3giIQBleQbigAvL0d+th8vCKjN2OaB8on6o8uRTaRdL6pWEjEdvaypZM4xfaVHx0ZmayaK1SkHZutFIE7QMC+jy7BUhUD4kRHn9DTKY/12UJgujPDfU7AhO0892akzvvwiMrSMyDdMobig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYmkNQq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYmkNQq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F58C2BD10;
	Thu,  6 Jun 2024 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683331;
	bh=SdXA4d8f7ZkjkIjMOsCfwk2Cw6Dv+RqMahcIuxAJr1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYmkNQq0XnW12QAEWi7LTmd7TPu3hponU0WErAsj70Q/NZXbTGuc/wPO61+giuSKA
	 DzVh4ct1AO/1JU7hTy/fvFPPxmkrGBZOTEuzqW1jO/tyVL7TxA+czRTlbe2EeP0XtY
	 qGvLd06ud2XAoZ2PMY2NGkImv20TD4bUthqcgVnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/473] platform/x86: xiaomi-wmi: Fix race condition when reporting key events
Date: Thu,  6 Jun 2024 16:02:22 +0200
Message-ID: <20240606131706.958934841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



