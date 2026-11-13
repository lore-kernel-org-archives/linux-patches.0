Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591102;
	b=sXCRwikIw6CoaPjlG9kLzbC4W79pGPjDsJa2uDGlTf/sNiBGWhMIboeuMwMkLpoVEqvu
	 z8bZbrWXcj9FpgWv95mAObd7sjg5bCIkCKrRI2piSgDGrmQT+FBDTEucdNmYJRv7d6JeA
	 Xx9HUlR9AppgllccS025spwT01PTt0NUw5iui4HTlHmJdpY6SE36OfS+Uaq2+qZLU+7pr
	 PDiXugSiYPDX9EXUwhDqSBU+bfY1HoPLQ/J8H1PSKQXsV01+WkyM0no7STt6k/jxWra+d
	 M9r5gZr4l0aUy39q+V90eEhYv63r5fVqa/dDQOarevUvPhY//W567qBYi8MFmEddKsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lgtcHzNYI85PyvhBNWcyWQ0RMu2ozQCrJi3IbJJa9Zo=;
	b=DEtUBAyNHVQXVuGib2Wi8GHlZA9C+P80eqRG0egoaWlXJxiPojuFvTP7oIORiw62ep4t
	 3NqK/WUuxuzzCQ6dDq/F28Xro6S2mTvnVOb7e/oZyDOdCTYyRnwdonhTPF2OzgrlkbeH/
	 EFCinKG7izvtt3W3hEkOer1T2Mj0GFw2EwJ20xlk78LRdB1GWA3CmtsUbjO98oo/rCpkj
	 zDvUQoxOaOtIbLcCXt/OMcWeJyQkTCRwlgdbf0UD7EIVEEQOlB6ZaKKRT6fl4iJVwnYPM
	 2ua8f/Th5NDszUSN+9n2LVOy4zyHv6yEJcPCnnJ+MOGNhzrruWzbgnnqJVNFT98XNMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/WJs7xm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5AF606B36D;
	Fri, 13 Nov 2026 17:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/WJs7xm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B76B1F000C4;
	Fri, 13 Nov 2026 17:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591102;
	bh=lgtcHzNYI85PyvhBNWcyWQ0RMu2ozQCrJi3IbJJa9Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/WJs7xm36ON4ExzKWCJCBtafRWAiXv/k+7ZcuZ3KMAhdZnMtyD7XIJzGkdZ2hZ4Z
	 BUAqWNB2H9ILfdw3wpX3q8qucQlc2okX0e1ZOe2uzwKztxb3jNNl+9DuZxhXLJf6nD
	 Wl/QECb51UxRUKadyZtTlpvC/zbBCaKF8ctt420M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/670] hwmon: (hp-wmi-sensors) Fix unbounded loops in scale_numeric_sensor()
Date: Fri, 13 Nov 2026 10:47:00 -0500
Message-ID: <20261113153820.508899680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff2b852056ec7..d2f8f93ee96dd 100644
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



