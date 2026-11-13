Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585570;
	b=i27GZet78MmBAtFWwdhpDGkJXnKy3mrNMgy5Urrpm7BDYTGQrkYwBwM4TtbLlUvc8Y8N
	 aNuGKq9yYgz8uax9I0yJl6AownZLRhLwrERDAZWNNehxawAZfYx80Ayh5aKzC5OGWSeIE
	 CLgxtPzovaLL75GkbR/fjPGPtV9evkNzMJ5RVpR8SyT6kuTc8gawz963KNO67f7JSI8y2
	 JKcCxYqri1YtoW9cGUZbHFmUxYzpcLUgS06GvuT9Zqbdg6+pYd3zwKh83urZZIABZViSC
	 t32Wc/CYMNpBWGyd2GynTM/j9UfwRAep19GMwA7r46/4m7gjrUi8FIbVRpLDHDwTebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=adXHz5Brv9DLaWJ+Mw2ZSb35M+MoLHRfECHBhWtE074=;
	b=g8kigpXRE8s602DCvoVoMYhZCYAvg4b+1KidAuI6lHkdmvMhpRspU6FCQOu32VMEwUWe
	 bkBV1jK1lWdnOGdshwCYZqPBg9DNP1gIr6FW7dUk6MvkJ+AyYrXaQx7k6fwvUvMVaJvcV
	 Mzw7KjI6stMIjoVqMBVDJ/+lRnQP4LToQdBDSjQ/KYgg4fEkOhwESF5buANOn91KhCJrf
	 uFOCrGcW4GU85K5gKRg3/R3eJTB6xRrDT5FwLJ03Hsjw4n/Geb1ZhF+fYTfZFRdIGwzSV
	 K5566udRXmCLkBBH9tcyLI8A+pvk9NRX8y1qikGXCed5zUOShkrkV11/C0A5ykrOwKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evUO6n4d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A026606A891;
	Fri, 13 Nov 2026 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evUO6n4d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352431F000C4;
	Fri, 13 Nov 2026 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585570;
	bh=adXHz5Brv9DLaWJ+Mw2ZSb35M+MoLHRfECHBhWtE074=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evUO6n4dTz+ZJcjEG0O+ZnSIPrU6s4qw3OaKHh9Z8/WY51cubmGmPCRdO6nxZSujA
	 6Ke80WqCx8IynlaLCTT0adW7yVaUgEOx99kF5qG1wJVFPCP6exSmX+I5DljlQdGZT6
	 OpdEgTKzZKVZQQc+t3UNRlHSg/LeAEWU4URrMVew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 187/507] hwmon: (hp-wmi-sensors) Fix unbounded loops in scale_numeric_sensor()
Date: Fri, 13 Nov 2026 10:48:11 -0500
Message-ID: <20261113153800.862987889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 185039b1c0389b70ec52a6d3e3c1494e2d0e23da ]

In scale_numeric_sensor() in the hp-wmi-sensors hwmon driver, an unbounded
loop occurs if the ACPI WMI implementation provides a highly anomalous or
malformed UnitModifier value for a numeric sensor.
The UnitModifier property is extracted from a WMI ACPI object without
bounds checking and cast to a signed 32-bit integer. This value directly
controls the iteration count of two scaling loops. If the provided
unit_modifier is extremely negative (e.g., INT_MIN), the first loop
executes billions of times before reaching target_modifier. Conversely,
if unit_modifier is extremely large (e.g., INT_MAX) and the current
sensor reading (val) is exactly 0, the second loop's overflow safeguard
(val > LONG_MAX / 10) never evaluates to true, resulting in billions of
unnecessary iterations. This prolonged execution causes severe CPU stalls
and thread soft lockups during driver initialization or whenever a
user-space process reads the sensor attribute via sysfs, resulting in a
denial of service on the affected CPU core.

Fix the problem in the first loop by exiting it as soon as val is zero.
Fix the problem with the second loop by only entering it if val is not
zero. Also add a check for val < LONG_MIN / 10 and exit the loop if that
is the case.

Fixes: 23902f98f8d4 ("hwmon: add HP WMI Sensors driver")
Cc: stable@vger.kernel.org
Cc: James Seo <james@equiv.tech>
Acked-by: James Seo <james@equiv.tech>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hp-wmi-sensors.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/hp-wmi-sensors.c b/drivers/hwmon/hp-wmi-sensors.c
index dd1fa48314a54..12950666c9810 100644
--- a/drivers/hwmon/hp-wmi-sensors.c
+++ b/drivers/hwmon/hp-wmi-sensors.c
@@ -739,15 +739,21 @@ static long scale_numeric_sensor(const struct hp_wmi_numeric_sensor *nsensor)
 
 	val = current_reading;
 
-	for (; unit_modifier < target_modifier; unit_modifier++)
+	for (; val && unit_modifier < target_modifier; unit_modifier++)
 		val = DIV_ROUND_CLOSEST(val, 10);
 
-	for (; unit_modifier > target_modifier; unit_modifier--) {
-		if (val > LONG_MAX / 10) {
-			val = LONG_MAX;
-			break;
+	if (val) {
+		for (; unit_modifier > target_modifier; unit_modifier--) {
+			if (val > LONG_MAX / 10) {
+				val = LONG_MAX;
+				break;
+			}
+			if (val < LONG_MIN / 10) {
+				val = LONG_MIN;
+				break;
+			}
+			val *= 10;
 		}
-		val *= 10;
 	}
 
 	if (sensor_type == HP_WMI_TYPE_TEMPERATURE) {
-- 
2.53.0



