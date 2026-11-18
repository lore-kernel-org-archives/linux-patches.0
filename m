Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037617;
	b=Bwrh68AjeGvd0trcegxIeEhRAoyWwIoiM7oddO2ZMg7LcOCacQDhHxSIAvA0nWFy2OR0
	 4/ceMDbwXch6nj1dDUvf0wge+AVkv0P3a/yenWDu3QL6a2ndHc060ZOqz5XrV4boJRYIl
	 SZ51xBlUj8tAjyhZJLIwlEo+gsuh42+xXHPgyGSvcnmJ9BaYKOAjxsIW8r+rbuVu4Eysi
	 8eofwozYuvNQ09SIcf2Yq1XIYbWijw0PumX2wVrwxO8XdkJAvv/tNi1Ve++DZBaupCuW7
	 l8vaaTu+cMUj5oU9FLFXSt6MGiKTXV5pTU9sHrcQ5125hLvwRAmnxTJF9ZpzQ/qOKnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ieOWHz77n/ny6sYNVLw1XcqZJDuEiX0kGmRkeAoTAU=;
	b=MvHb1qvEYQ5azbmqdEoHZtG/kHKfTZO+sjUawEXlXZ+RD/ycTJjJxhJ5VSWdU8NMSPjW
	 ZsbPquM1wdngdxqJ8wwobNNEOzlxYbiLmvmFb/PzxNi+9ebsjbs+kjMWNoHjVNFzC3nXb
	 NCdMNVoFfuS+PNQo/UIf9ij9tCw/vdex1nctcKrBYJzrkRPFtsUm8P/vOVDHutakk87xG
	 Q5NjUEcmA3xdBOiQ0ckCAGOfVcA/dFSBZile9FpHXIteQ8o7d6n1X6BEJ5DPVvj1cmX2Y
	 6tYh8mELF7YOpvO93H8JieKeImMo18E4RiIT8he23DopUEG/9sFA32uMqt7PWp4zZDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbPQqzWw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93458606A325;
	Wed, 18 Nov 2026 21:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbPQqzWw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBE21F000C4;
	Wed, 18 Nov 2026 21:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037617;
	bh=0ieOWHz77n/ny6sYNVLw1XcqZJDuEiX0kGmRkeAoTAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbPQqzWw3fmPtBd5z6EMJeHeLtB+V/L3Qtm84xyTweY6jaNcSKHdq0BjJ+GDeOXgu
	 kdhPZ35t6zoJEWvfaFJAR9JMv8N7fM9GW0UVmAu9cQ9FucliaMuoDvu2LSfv6gy8eT
	 6iJOHyhW+U9RNKm9lEualuWbNKZJHdaGlvKNV1UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1459/3318] hwmon: (hp-wmi-sensors) Fix unbounded loops in scale_numeric_sensor()
Date: Wed, 18 Nov 2026 15:34:41 +0100
Message-ID: <20261118150404.664031046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f2f7d648c99e..208a6c306a75b 100644
--- a/drivers/hwmon/hp-wmi-sensors.c
+++ b/drivers/hwmon/hp-wmi-sensors.c
@@ -725,15 +725,21 @@ static long scale_numeric_sensor(const struct hp_wmi_numeric_sensor *nsensor)
 
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



