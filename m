Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5AE145B13;
	Thu, 11 Apr 2024 10:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831275; cv=none; b=iZrLw9QR3v/xFQerld9RP1h2th0joiI07974XfASbX/x5TJWPmI3CHgRn12ZPlMljK13GVCPDqK2wKGoIZ2Y3YzONBuNdewS4yp1gofP6TTQBob+7vbdnazstfsQQZfAqhlcXuUFIsi5FK2Jqx4ngxhEr78TkVLxSchkyGcArsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831275; c=relaxed/simple;
	bh=mLzgJ/hSiBeLvycz507W4oJMqI8te5leEhYvIbDFZ9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghcRTshdo8xULpHpvPUF/iuqLHFm28JLRkYyR7iLBwzuRyQLACSz+XYo2r84bG2VqemokFzCFp8f4pCqAYKtQ07cfNOy4aWl6IgemmMfprFVlhnxwR11SEQw5wue/+/yWiQxb6LtfIIvEWHNoxOJHn6wdfYM5K2rcUiQakJiQoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYWp7yUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYWp7yUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C6AC433C7;
	Thu, 11 Apr 2024 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831275;
	bh=mLzgJ/hSiBeLvycz507W4oJMqI8te5leEhYvIbDFZ9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYWp7yUElTecAgM6wh1RfsU7eVk1UsP4erTH9V5lTPSa6YfQazJTHnxMHB+WYRIbr
	 i+MbOnZLcm2ZSAPQOXIb/jX6x2niFVegyd0KOKosgfGhTzZ8vddu6WooB9C0mlWhwe
	 w0fp1x97YVLLy7xCO+HezCSkrsxw+6k+ohBj2Xhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/114] ACPI: x86: Move acpi_quirk_skip_serdev_enumeration() out of CONFIG_X86_ANDROID_TABLETS
Date: Thu, 11 Apr 2024 11:55:55 +0200
Message-ID: <20240411095417.719713595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7c86e17455de1a442ec906d3449148b5e9a218a4 ]

Some recent(ish) Dell AIO devices have a backlight controller board
connected to an UART.

This UART has a DELL0501 HID with CID set to PNP0501 so that the UART is
still handled by 8250_pnp.c. Unfortunately there is no separate ACPI device
with an UartSerialBusV2() resource to model the backlight-controller.

The next patch in this series will use acpi_quirk_skip_serdev_enumeration()
to still create a serdev for this for a backlight driver to bind to
instead of creating a /dev/ttyS0.

This new acpi_quirk_skip_serdev_enumeration() use is not limited to Android
X86 tablets, so move it out of the ifdef CONFIG_X86_ANDROID_TABLETS block.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 18 ++++++++++++++----
 include/acpi/acpi_bus.h  | 14 +++++++-------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 63d834dd38112..c708524576df4 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -429,7 +429,7 @@ bool acpi_quirk_skip_i2c_client_enumeration(struct acpi_device *adev)
 }
 EXPORT_SYMBOL_GPL(acpi_quirk_skip_i2c_client_enumeration);
 
-int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
+static int acpi_dmi_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
 {
 	struct acpi_device *adev = ACPI_COMPANION(controller_parent);
 	const struct dmi_system_id *dmi_id;
@@ -437,8 +437,6 @@ int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *s
 	u64 uid;
 	int ret;
 
-	*skip = false;
-
 	ret = acpi_dev_uid_to_integer(adev, &uid);
 	if (ret)
 		return 0;
@@ -464,7 +462,6 @@ int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *s
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(acpi_quirk_skip_serdev_enumeration);
 
 bool acpi_quirk_skip_gpio_event_handlers(void)
 {
@@ -479,8 +476,21 @@ bool acpi_quirk_skip_gpio_event_handlers(void)
 	return (quirks & ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS);
 }
 EXPORT_SYMBOL_GPL(acpi_quirk_skip_gpio_event_handlers);
+#else
+static int acpi_dmi_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
+{
+	return 0;
+}
 #endif
 
+int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
+{
+	*skip = false;
+
+	return acpi_dmi_skip_serdev_enumeration(controller_parent, skip);
+}
+EXPORT_SYMBOL_GPL(acpi_quirk_skip_serdev_enumeration);
+
 /* Lists of PMIC ACPI HIDs with an (often better) native charger driver */
 static const struct {
 	const char *hid;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 0b7eab0ef7d7f..d9c20ae23b632 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -652,6 +652,7 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
 bool acpi_quirk_skip_acpi_ac_and_battery(void);
 int acpi_install_cmos_rtc_space_handler(acpi_handle handle);
 void acpi_remove_cmos_rtc_space_handler(acpi_handle handle);
+int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip);
 #else
 static inline bool acpi_device_override_status(struct acpi_device *adev,
 					       unsigned long long *status)
@@ -669,23 +670,22 @@ static inline int acpi_install_cmos_rtc_space_handler(acpi_handle handle)
 static inline void acpi_remove_cmos_rtc_space_handler(acpi_handle handle)
 {
 }
+static inline int
+acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
+{
+	*skip = false;
+	return 0;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_X86_ANDROID_TABLETS)
 bool acpi_quirk_skip_i2c_client_enumeration(struct acpi_device *adev);
-int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip);
 bool acpi_quirk_skip_gpio_event_handlers(void);
 #else
 static inline bool acpi_quirk_skip_i2c_client_enumeration(struct acpi_device *adev)
 {
 	return false;
 }
-static inline int
-acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
-{
-	*skip = false;
-	return 0;
-}
 static inline bool acpi_quirk_skip_gpio_event_handlers(void)
 {
 	return false;
-- 
2.43.0



