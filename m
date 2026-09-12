Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F402D0C75;
	Sat, 12 Sep 2026 12:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215878; cv=none; b=goDlaxFkVERwAVEkc61WUtp2Lit27J568I7WojTJrBPRF/lO7vw928RTApneHOuG3MZjTU1lgNCSsvEOHiASZJ8hSi3obWQcCsOLBio0A9e+fjKBHJNWx133NEXYmLFyKK0X3buhj7MH9nmqL3KFrSbLPb2uW0+N5dz9OUnwgNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215878; c=relaxed/simple;
	bh=aQNByWW7IApjqkAmhgeNqRS5A+2804Ut1tcmYfTWeSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqUWgh+1qPLgzduU+xmoSnlX1cUpViN6k9CUoseDHhs5DhVOmXIUpidmjnJ2ahceY+jYK5MRczKYPURqBCczqvGUUsaA0z0HbxJ0Alq/VDi0DouLoUx+5cETSwxkTXefHaZYiDtRNTTTipQNqXHLwL3QSr7S5hl6DjPUcX3Xm1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whZ97Iob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whZ97Iob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B721F000FF;
	Sat, 12 Sep 2026 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215877;
	bh=PE3uHXnHEiRWh4nksZt2EiN3CBET1rV7BQJ45uxW6tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whZ97Iob4sVIFjJIL5JpMwSkL/D6YnUNc0DDqe4tHhrUbcBYybUADOvOsLdfquoeh
	 fyGzZq/7polugme+FkvevmWZHePDm0yf5fAheIZPV5tUxKuj1EF6Epf1lkMyGxJ1/P
	 hQAdw4aBpaLJGvmUjw0Pfdl5MZb+kSo0zb5x/jN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	golne tree <lrepper@outlook.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0623/1376] ACPI: battery: Adjust charging status validation check
Date: Sat, 12 Sep 2026 08:50:49 +0200
Message-ID: <20260912065621.428903611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index a33d60e625f81..c69970ba1843f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -151,27 +151,28 @@ static int acpi_battery_technology(struct acpi_battery *battery)
 
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
@@ -212,13 +213,14 @@ static int acpi_battery_get_property(struct power_supply *psy,
 		if (battery->state & ACPI_BATTERY_STATE_DISCHARGING)
 			val->intval = acpi_battery_handle_discharging(battery);
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



