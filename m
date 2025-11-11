Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747354C97;
	Tue, 11 Nov 2025 00:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822332; cv=none; b=Pe02qpwsXZb4NGUPuRzQP/P6kbXoPJHcMypbmZiaeOgPY261dPoE/rCl0enM/T1eDB4CL9EAGmwNbmu+8XLYgJhbIzvhDcGrVIIFMdFyvXrEeiFVyE+RILnhcMPYYqlZFCLvp+Qp/ncL8VD9LIH6ir0hs6QG2UFjJEwCODVuPmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822332; c=relaxed/simple;
	bh=nhNlTd1QuvA51RE/z5Ro631ByquBag0LXWedjsk0SKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4sb2DM51YbLdufkbqX325wL86KItYoO7YfMeIdOWRvUKx57WCus+Ex4jnRTea3NTHhSflvoGJn35tGxwRj+RIE3Z8YMjk1EKQroJxFWe1ewPX6s4KYzQx+8gUFTTudHtj9q5+d23rvdhDdllxGXJNGVk/lYgyd1Q8tSo2rUYhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q1jbLlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q1jbLlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAC5C16AAE;
	Tue, 11 Nov 2025 00:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822332;
	bh=nhNlTd1QuvA51RE/z5Ro631ByquBag0LXWedjsk0SKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q1jbLlZ/RGYcdicnZoQYDn/q8QaFsF06VRFjVKEKz9rWXqfwXWztK4Jw99yZnHuk
	 p+u5PfjYuosBuYyqZz4NG60w22nH5IIQwNFjFpSpncd6yOe9hCf7ps8VKCB7RyTEIa
	 GU2DnFF5J6fU+W/g7YsS5YbateiapCbu3ABljaZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 087/849] ACPI: fan: Use ACPI handle when retrieving _FST
Date: Tue, 11 Nov 2025 09:34:17 +0900
Message-ID: <20251111004538.522247429@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit 58764259ebe0c9efd569194444629f6b26f86583 upstream.

Usage of the ACPI device should be phased out in the future, as
the driver itself is now using the platform bus.

Replace any usage of struct acpi_device in acpi_fan_get_fst() to
allow users to drop usage of struct acpi_device.

Also extend the integer check to all three package elements.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251007234149.2769-2-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/fan.h       |    3 ++-
 drivers/acpi/fan_attr.c  |    2 +-
 drivers/acpi/fan_core.c  |   34 ++++++++++++++++++++++------------
 drivers/acpi/fan_hwmon.c |    3 +--
 4 files changed, 26 insertions(+), 16 deletions(-)

--- a/drivers/acpi/fan.h
+++ b/drivers/acpi/fan.h
@@ -49,6 +49,7 @@ struct acpi_fan_fst {
 };
 
 struct acpi_fan {
+	acpi_handle handle;
 	bool acpi4;
 	bool has_fst;
 	struct acpi_fan_fif fif;
@@ -59,7 +60,7 @@ struct acpi_fan {
 	struct device_attribute fine_grain_control;
 };
 
-int acpi_fan_get_fst(struct acpi_device *device, struct acpi_fan_fst *fst);
+int acpi_fan_get_fst(acpi_handle handle, struct acpi_fan_fst *fst);
 int acpi_fan_create_attributes(struct acpi_device *device);
 void acpi_fan_delete_attributes(struct acpi_device *device);
 
--- a/drivers/acpi/fan_attr.c
+++ b/drivers/acpi/fan_attr.c
@@ -55,7 +55,7 @@ static ssize_t show_fan_speed(struct dev
 	struct acpi_fan_fst fst;
 	int status;
 
-	status = acpi_fan_get_fst(acpi_dev, &fst);
+	status = acpi_fan_get_fst(acpi_dev->handle, &fst);
 	if (status)
 		return status;
 
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -44,25 +44,30 @@ static int fan_get_max_state(struct ther
 	return 0;
 }
 
-int acpi_fan_get_fst(struct acpi_device *device, struct acpi_fan_fst *fst)
+int acpi_fan_get_fst(acpi_handle handle, struct acpi_fan_fst *fst)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	acpi_status status;
 	int ret = 0;
 
-	status = acpi_evaluate_object(device->handle, "_FST", NULL, &buffer);
-	if (ACPI_FAILURE(status)) {
-		dev_err(&device->dev, "Get fan state failed\n");
-		return -ENODEV;
-	}
+	status = acpi_evaluate_object(handle, "_FST", NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		return -EIO;
 
 	obj = buffer.pointer;
-	if (!obj || obj->type != ACPI_TYPE_PACKAGE ||
-	    obj->package.count != 3 ||
-	    obj->package.elements[1].type != ACPI_TYPE_INTEGER) {
-		dev_err(&device->dev, "Invalid _FST data\n");
-		ret = -EINVAL;
+	if (!obj)
+		return -ENODATA;
+
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count != 3) {
+		ret = -EPROTO;
+		goto err;
+	}
+
+	if (obj->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    obj->package.elements[1].type != ACPI_TYPE_INTEGER ||
+	    obj->package.elements[2].type != ACPI_TYPE_INTEGER) {
+		ret = -EPROTO;
 		goto err;
 	}
 
@@ -81,7 +86,7 @@ static int fan_get_state_acpi4(struct ac
 	struct acpi_fan_fst fst;
 	int status, i;
 
-	status = acpi_fan_get_fst(device, &fst);
+	status = acpi_fan_get_fst(device->handle, &fst);
 	if (status)
 		return status;
 
@@ -323,11 +328,16 @@ static int acpi_fan_probe(struct platfor
 	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 	char *name;
 
+	if (!device)
+		return -ENODEV;
+
 	fan = devm_kzalloc(&pdev->dev, sizeof(*fan), GFP_KERNEL);
 	if (!fan) {
 		dev_err(&device->dev, "No memory for fan\n");
 		return -ENOMEM;
 	}
+
+	fan->handle = device->handle;
 	device->driver_data = fan;
 	platform_set_drvdata(pdev, fan);
 
--- a/drivers/acpi/fan_hwmon.c
+++ b/drivers/acpi/fan_hwmon.c
@@ -93,13 +93,12 @@ static umode_t acpi_fan_hwmon_is_visible
 static int acpi_fan_hwmon_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 			       int channel, long *val)
 {
-	struct acpi_device *adev = to_acpi_device(dev->parent);
 	struct acpi_fan *fan = dev_get_drvdata(dev);
 	struct acpi_fan_fps *fps;
 	struct acpi_fan_fst fst;
 	int ret;
 
-	ret = acpi_fan_get_fst(adev, &fst);
+	ret = acpi_fan_get_fst(fan->handle, &fst);
 	if (ret < 0)
 		return ret;
 


