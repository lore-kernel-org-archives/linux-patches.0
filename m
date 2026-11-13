Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590293;
	b=NeFNUJILCwkezy2frrEZ3DoRmgG40TsoYOFrjss9wutVfQFouMic2Y5xRUbPaJGeUWbI
	 M64BwNwtoPLlTohKRRVFV5vIFMRW9fsrxnigfWaqMtBx3A45GqBJI5Dq0rCLR0qJUNaZo
	 SVlckM5tN88WBxPjnj9LCvzQ6FN+GlAokbKW4ARIqF9CwBrrZ0ADV2rtFP4Vg7bjCftK5
	 HoRWvrA5qeLqji2PR0bjshV7WhAESzfbplQOwQlwUi2Zi4wnrdmmxuksxJ3p2RTQydHVN
	 wTyjI3h+6ZZ1UgBwIxlxk8xi0TiM5Bs4H50UlXmqXjMI0ytgb+bcOT8u33GPtMrCVDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SKLY+4uY5q4zM0W8B745ApvcP6xsCzR8fRXxXnYDTeA=;
	b=vKbi7ODeO5iPV3kWc99r8W2Vo9ZsEzwOUsSVTgTglqW9AN0XyLdGs+ztz2z7aaw/12/i
	 5Od1FaoJvNIj0s5OYRrlG8S1KZTwQynVTuxUCnE8ZM3U+NjDleKFDNrkWtrFxRho9e+Rk
	 iBbtDw/QfM96WMY+8aKHK14nabLSZCJgysIym/vDp3/oRYbHHVEDyypYVRDaOZ8MLLs+2
	 RQLSGHuSGbZX5ClGXuxyOfnW9d1OkBNCy+QxwxmhDXUCBSGEF96bLzHfKhwZ7waE438XD
	 c2jGq13r4m64JfYw7iDBY7eMZAX0dyJaqWckmdSOVzQvYJ8tJSkxkFEvoBgwL7DO0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkyBcvCt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F0B607B586;
	Fri, 13 Nov 2026 17:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkyBcvCt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3CC1F000CA;
	Fri, 13 Nov 2026 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590293;
	bh=SKLY+4uY5q4zM0W8B745ApvcP6xsCzR8fRXxXnYDTeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkyBcvCtn+fT+C4aVza+NN8WSbuhYy9o7nTgA7PSQdkAWIuYVbc3jxqzKcjCdX/Qw
	 23AfDAxdhojlJCveAkw4OlO5W7xt06Q9YrHE8CF6H6tQZfoA11IipIHudy1TF/dg+C
	 uWWupj6fwmjhLnYlaCHsnxkinKT+CSc6F7QhALSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 282/686] hwmon: (hp-wmi-sensors) Fix unbounded loops in scale_numeric_sensor()
Date: Fri, 13 Nov 2026 10:46:55 -0500
Message-ID: <20261113153830.539561905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



