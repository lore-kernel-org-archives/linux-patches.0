Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEECC51C2B;
	Mon, 11 Dec 2023 18:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bzy1Z9W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61242C433C8;
	Mon, 11 Dec 2023 18:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319927;
	bh=Uf7tSV1CWer6F00OcpSAtDFi4de8VIZx/hq7dnppC/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bzy1Z9W5xRTLvIK+Y3IRyFo4CrcUGkbxg18S53ITZL2CzPWOAtssDobuVvp1RtE81
	 QRR7WAZ2OOiSvKmbIj/EgtCGr3xqXHDPLJQu9URF9r5EMeggFp+Gyv4V0hqaLKTB37
	 nB67PYrjNEKu69UwFk9FCo77pPi60BzAgURZJn38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	urbinek@gmail.com,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/97] hwmon: (acpi_power_meter) Fix 4.29 MW bug
Date: Mon, 11 Dec 2023 19:21:43 +0100
Message-ID: <20231211182021.451335265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 1fefca6c57fb928d2131ff365270cbf863d89c88 ]

The ACPI specification says:

"If an error occurs while obtaining the meter reading or if the value
is not available then an Integer with all bits set is returned"

Since the "integer" is 32 bits in case of the ACPI power meter,
userspace will get a power reading of 2^32 * 1000 miliwatts (~4.29 MW)
in case of such an error. This was discovered due to a lm_sensors
bugreport (https://github.com/lm-sensors/lm-sensors/issues/460).
Fix this by returning -ENODATA instead.

Tested-by: <urbinek@gmail.com>
Fixes: de584afa5e18 ("hwmon driver for ACPI 4.0 power meters")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20231124182747.13956-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index a270b975e90bb..5794d44538e9c 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -32,6 +32,7 @@ ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
 #define POWER_METER_CAN_NOTIFY	(1 << 3)
 #define POWER_METER_IS_BATTERY	(1 << 8)
 #define UNKNOWN_HYSTERESIS	0xFFFFFFFF
+#define UNKNOWN_POWER		0xFFFFFFFF
 
 #define METER_NOTIFY_CONFIG	0x80
 #define METER_NOTIFY_TRIP	0x81
@@ -343,6 +344,9 @@ static ssize_t show_power(struct device *dev,
 	update_meter(resource);
 	mutex_unlock(&resource->lock);
 
+	if (resource->power == UNKNOWN_POWER)
+		return -ENODATA;
+
 	return sprintf(buf, "%llu\n", resource->power * 1000);
 }
 
-- 
2.42.0



