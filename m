Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8C234252D;
	Sat, 12 Sep 2026 07:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199367; cv=none; b=szCIdzmQSlaHKuCPTqvjjzwfe9B4tvwNOSDhLG9TUUCnGcaWJP2EhEgG7J89s2Djf8zBPwNDzA5idrelrBwSQqCf9dC/Kkt6jZkrtz2sMIxM3CHEt/ob51iaBjjmF04zLidBZHdJE/M5F1P9KB5WLhKb+04rVLCz25tIskLW/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199367; c=relaxed/simple;
	bh=bkBn/PgOG2u58rQEL/3TeDbmMcxdiTkGwwgGttsQrrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbFlPLZJOiziNT9KDoQeHowxNkoKqOmqg0sNZcBqbmGPd5Bi6pJpMjxKg+D1sD6e89smg0ZxGFCM6w1pM5pM+B+AOlxux8U0RPWX3h54kk3Ew33RawL/RHmUnwKDBubnpoWBxuY4xGbSu9gCK7MsVVBogStgB43kk+sXpREBrVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWPVfkxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWPVfkxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674031F000FF;
	Sat, 12 Sep 2026 07:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199366;
	bh=V7lS2IeK7Re4iX2hi4KZUCdsjMBLWkEB025fXzY1QHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWPVfkxvyNi/yoi6WZ4Or9mX6ElhbLGdD6CrE/fKuPwUax0strHpxrnnECzSBvKsC
	 6d0lrR3lTOl2RVe536RUh7QoOeW9SYYvcJnEWFdbWbLu1+L7rF/t0Ya7Oqdyq9mnW5
	 W5sxDzIWozAPVJ//OyTYgER165xmfqAAD8q5iGJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	golne tree <lrepper@outlook.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0570/1815] ACPI: battery: Adjust charging status validation check
Date: Sat, 12 Sep 2026 08:38:40 +0200
Message-ID: <20260912065702.262684486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 77ce4be0d8d53c528d1663ab62a14d93d5853f11 ]

Commit bb1256e0ddc7 ("ACPI: battery: fix incorrect charging status when
current is zero") added a charge rate check to validate the "charging"
status of the battery, but that check is reported to cause some systems
to misbehave [1].  Namely, it causes the "not charging" status to be
reported on them while the battery is in fact charging (and they were
correctly reporting the "charging" status in that case previously).

To address that, check if the battery is full in addition to checking
the charge rate when the "charging" status is reported by the platform
firmware and only change it to "not charging" if the battery is full and
its charge rate is zero or it is unknown.

Fixes: bb1256e0ddc7 ("ACPI: battery: fix incorrect charging status when current is zero")
Reported-by: golne tree <lrepper@outlook.de>
Tested-by: golne tree <lrepper@outlook.de>
Closes: https://lore.kernel.org/linux-acpi/AM9P193MB158895CFE0DDFA62FCD1DA5ED0F22@AM9P193MB1588.EURP193.PROD.OUTLOOK.COM/ [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/6286911.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index f8fa0d9a1f4c7..365626827d61c 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -153,27 +153,28 @@ static int acpi_battery_technology(struct acpi_battery *battery)
 
 static int acpi_battery_get_state(struct acpi_battery *battery);
 
-static int acpi_battery_is_charged(struct acpi_battery *battery)
+static bool acpi_battery_is_full(struct acpi_battery *battery)
 {
-	/* charging, discharging, critical low or charge limited */
-	if (battery->state != 0)
-		return 0;
-
 	/* battery not reporting charge */
 	if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN ||
 	    battery->capacity_now == 0)
-		return 0;
+		return false;
 
 	/* good batteries update full_charge as the batteries degrade */
 	if (battery->full_charge_capacity == battery->capacity_now)
-		return 1;
+		return true;
 
 	/* fallback to using design values for broken batteries */
-	if (battery->design_capacity <= battery->capacity_now)
-		return 1;
+	return battery->design_capacity <= battery->capacity_now;
+}
 
-	/* we don't do any sort of metric based on percentages */
-	return 0;
+static int acpi_battery_is_charged(struct acpi_battery *battery)
+{
+	/* charging, discharging, critical low or charge limited */
+	if (battery->state != 0)
+		return 0;
+
+	return acpi_battery_is_full(battery);
 }
 
 static bool acpi_battery_is_degraded(struct acpi_battery *battery)
@@ -226,13 +227,14 @@ static int acpi_battery_get_property(struct power_supply *psy,
 				return 0;
 			}
 		else if (battery->state & ACPI_BATTERY_STATE_CHARGING)
-			/* Validate the status by checking the current. */
-			if (battery->rate_now != ACPI_BATTERY_VALUE_UNKNOWN &&
-			    battery->rate_now == 0) {
-				/* On charge but no current (0W/0mA). */
-				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-			} else {
+			/* Check the rate and capacity to validate the status. */
+			if (!acpi_battery_is_full(battery) ||
+			    (battery->rate_now != ACPI_BATTERY_VALUE_UNKNOWN &&
+			     battery->rate_now > 0)) {
 				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+			} else {
+				/* Full and zero rate. */
+				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
 			}
 		else if (battery->state & ACPI_BATTERY_STATE_CHARGE_LIMITING)
 			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-- 
2.53.0



