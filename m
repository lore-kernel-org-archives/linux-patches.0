Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C498632C306;
	Mon, 29 Dec 2025 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024885; cv=none; b=EFbIHWV0/c0TJg0m744y/3lmj871SIIr6cpeUJmqlqFv50uUJd/r+0/WKKlfCXSJ0QmmJQAuumHuI7Sf8UOiu4JlR0vajHyCRNCMR7dh7SY6dafxxZj/HKMB3LnmnvztJNSCo2xuWQOPH/Yn1VoHr3KIzLS5fWT1jwSsYllSUGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024885; c=relaxed/simple;
	bh=QdMURHq+zHB+f/SdZf+ZJ2oMQFq88Hme4V7IsPP9/+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws57OEfknodAr5aZV3Lh84aZvVMHukuCqF2VHP+gMyCxCMo36InIi5XCafFyd8N9JVJRCiM7/GQrr6muh9LoSzhCj7sXevFsBVYYC8XVPvG1Did1PKn02SzBQZ6+rLCpNjb2bM228wxIGWPRseqS0/MwTKex0LyLEN5PDQkP0M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQXMe1zq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQXMe1zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CE6C4CEF7;
	Mon, 29 Dec 2025 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024885;
	bh=QdMURHq+zHB+f/SdZf+ZJ2oMQFq88Hme4V7IsPP9/+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQXMe1zqrQaAqS+ejE68v/bTKgkkuPFnRijZuainIgyn8ZGGfE8Fb21caaDAgJvju
	 uDLtNZWYryR3dccj4fmn6CMGCKdDYVdMVJAC1p0RjPddIQ3NTqiOAr0QSfJi22reED
	 UIrZS9UVATJdHgZsTSOuRQ38ID/KgG8fDHC6zyDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/430] ACPI: fan: Workaround for 64-bit firmware bug
Date: Mon, 29 Dec 2025 17:07:01 +0100
Message-ID: <20251229160724.861870298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 2e00f7a4bb0ac25ec7477b55fe482da39fb4dce8 ]

Some firmware implementations use the "Ones" ASL opcode to produce
an integer with all bits set in order to indicate missing speed or
power readings. This however only works when using 32-bit integers,
as the ACPI spec requires a 32-bit integer (0xFFFFFFFF) to be
returned for missing speed/power readings. With 64-bit integers the
"Ones" opcode produces a 64-bit integer with all bits set, violating
the ACPI spec regarding the placeholder value for missing readings.

Work around such buggy firmware implementation by also checking for
64-bit integers with all bits set when reading _FST.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Typo fix in the changelog ]
Link: https://patch.msgid.link/20251007234149.2769-3-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/fan.h       | 33 +++++++++++++++++++++++++++++++++
 drivers/acpi/fan_hwmon.c | 10 +++-------
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/fan.h b/drivers/acpi/fan.h
index bedbab0e8e4e9..0d73433c38892 100644
--- a/drivers/acpi/fan.h
+++ b/drivers/acpi/fan.h
@@ -11,6 +11,7 @@
 #define _ACPI_FAN_H_
 
 #include <linux/kconfig.h>
+#include <linux/limits.h>
 
 #define ACPI_FAN_DEVICE_IDS	\
 	{"INT3404", }, /* Fan */ \
@@ -60,6 +61,38 @@ struct acpi_fan {
 	struct device_attribute fine_grain_control;
 };
 
+/**
+ * acpi_fan_speed_valid - Check if fan speed value is valid
+ * @speeed: Speed value returned by the ACPI firmware
+ *
+ * Check if the fan speed value returned by the ACPI firmware is valid. This function is
+ * necessary as ACPI firmware implementations can return 0xFFFFFFFF to signal that the
+ * ACPI fan does not support speed reporting. Additionally, some buggy ACPI firmware
+ * implementations return a value larger than the 32-bit integer value defined by
+ * the ACPI specification when using placeholder values. Such invalid values are also
+ * detected by this function.
+ *
+ * Returns: True if the fan speed value is valid, false otherwise.
+ */
+static inline bool acpi_fan_speed_valid(u64 speed)
+{
+	return speed < U32_MAX;
+}
+
+/**
+ * acpi_fan_power_valid - Check if fan power value is valid
+ * @power: Power value returned by the ACPI firmware
+ *
+ * Check if the fan power value returned by the ACPI firmware is valid.
+ * See acpi_fan_speed_valid() for details.
+ *
+ * Returns: True if the fan power value is valid, false otherwise.
+ */
+static inline bool acpi_fan_power_valid(u64 power)
+{
+	return power < U32_MAX;
+}
+
 int acpi_fan_get_fst(acpi_handle handle, struct acpi_fan_fst *fst);
 int acpi_fan_create_attributes(struct acpi_device *device);
 void acpi_fan_delete_attributes(struct acpi_device *device);
diff --git a/drivers/acpi/fan_hwmon.c b/drivers/acpi/fan_hwmon.c
index 4b2c2007f2d7f..47a02ef5a6067 100644
--- a/drivers/acpi/fan_hwmon.c
+++ b/drivers/acpi/fan_hwmon.c
@@ -15,10 +15,6 @@
 
 #include "fan.h"
 
-/* Returned when the ACPI fan does not support speed reporting */
-#define FAN_SPEED_UNAVAILABLE	U32_MAX
-#define FAN_POWER_UNAVAILABLE	U32_MAX
-
 static struct acpi_fan_fps *acpi_fan_get_current_fps(struct acpi_fan *fan, u64 control)
 {
 	unsigned int i;
@@ -77,7 +73,7 @@ static umode_t acpi_fan_hwmon_is_visible(const void *drvdata, enum hwmon_sensor_
 			 * when the associated attribute should not be created.
 			 */
 			for (i = 0; i < fan->fps_count; i++) {
-				if (fan->fps[i].power != FAN_POWER_UNAVAILABLE)
+				if (acpi_fan_power_valid(fan->fps[i].power))
 					return 0444;
 			}
 
@@ -106,7 +102,7 @@ static int acpi_fan_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 	case hwmon_fan:
 		switch (attr) {
 		case hwmon_fan_input:
-			if (fst.speed == FAN_SPEED_UNAVAILABLE)
+			if (!acpi_fan_speed_valid(fst.speed))
 				return -ENODEV;
 
 			if (fst.speed > LONG_MAX)
@@ -134,7 +130,7 @@ static int acpi_fan_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			if (!fps)
 				return -EIO;
 
-			if (fps->power == FAN_POWER_UNAVAILABLE)
+			if (!acpi_fan_power_valid(fps->power))
 				return -ENODEV;
 
 			if (fps->power > LONG_MAX / MICROWATT_PER_MILLIWATT)
-- 
2.51.0



