Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C164C97;
	Tue, 11 Nov 2025 00:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822484; cv=none; b=mQqGBeVCcegsW0ZSuiESg+QJO2ocoW01ZTS3cyle9Vc7tqz+iBYY42eL6aRCvenO9mPZHZ9m76wkJurGYykU7z3iWvHFs552iDE/DCpNmnFeCQ5ZCKL7I5hpbPU0ZgL1tHDidwNTuQb6RIQjaOGTrcUZBAETJhY2uggcqfv6f8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822484; c=relaxed/simple;
	bh=z7tYf2OyuhvxXuAUsLSUDa2sJfNZa7ZElDTh5gkqHrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPt6l4/RmW0kG7VOTWyS2du7IKAtkaS7mA7narg9ABXUcpDeHboAvjUiGlqIqI6s9Z/pHcb0yzg0Itozz6IsuGjmuoiS8BAUf1FyZYmlbwCfZ2QSSxmBuxFXf90zHywhVoy+WBeavDCvsNeS4RA0/uvS1rhdJVGLBxQUIAb68iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3FmS08p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3FmS08p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0E1C16AAE;
	Tue, 11 Nov 2025 00:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822483;
	bh=z7tYf2OyuhvxXuAUsLSUDa2sJfNZa7ZElDTh5gkqHrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3FmS08pBHZfaNVeHObMaHIVkSjbwLgB10WvCQ3lz9xFA79pQ6lwlRxtahenAugPj
	 AOFaOVD3wWmyOiuRYwio9NPst8ZZ8SuNOxbK5GiKzHm4D5+ylnUkwd/MMKdmlFkn8E
	 jTMhXJ86enjysls9YlvPUCeyVs6edBEVMFWdZk7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 059/565] ACPI: fan: Use ACPI handle when retrieving _FST
Date: Tue, 11 Nov 2025 09:38:35 +0900
Message-ID: <20251111004528.250225549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
@@ -47,6 +47,7 @@ struct acpi_fan_fst {
 };
 
 struct acpi_fan {
+	acpi_handle handle;
 	bool acpi4;
 	struct acpi_fan_fif fif;
 	struct acpi_fan_fps *fps;
@@ -56,7 +57,7 @@ struct acpi_fan {
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
 
@@ -319,11 +324,16 @@ static int acpi_fan_probe(struct platfor
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
@@ -85,13 +85,12 @@ static umode_t acpi_fan_hwmon_is_visible
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
 


