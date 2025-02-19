Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3CD1C7013;
	Wed, 19 Feb 2025 09:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955780; cv=none; b=BX9g1HyUX0pgpIekjB0rYKTcHun9lwq+r9wOXakfdOLgB4V5RBcWG1Q42MiWAqYnbzitItfWou6hX4o8/vpPY598PQzuh2MO2cnrEJUm1GDdGchmTfL6bQjwITw83KL6w6xd8zffkowjFB6amhnAemxqJ9Up52YEyIthTi+som0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955780; c=relaxed/simple;
	bh=L7Yg5VIo1ZP25EJoXakZlmtTnRG6QjBx0NmdVZ/pmAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMbf1OvaLe+hhFhZ140HIZrPoCHV5xplP4i30ZyGQAW3crAlvkYAAA0aVEfbjackBHAYavQbKp0xKHnRraPPR+mNTEqzsb6hr2FEYq2p2r0dOLoUCO8bFA8/HjUW0LwvWcDbfE7JKcF4B/+kSqFp69DFMKWa3u0CNY29ycmrjiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkuUDW70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkuUDW70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F5C4CED1;
	Wed, 19 Feb 2025 09:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955780;
	bh=L7Yg5VIo1ZP25EJoXakZlmtTnRG6QjBx0NmdVZ/pmAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkuUDW702lhIX/if/sCttnUwYRsMSCV3I1K1+vPB0zkWuMUGg2aqFtDHw4U1MujxQ
	 zibFNsPe6ox19NngRiX7/yggEszq8PBy5bVxgpwzRcuatSr9oj9NLfXvks8Fb1/hlh
	 WWhhg2lPPt7lW2tad+kN8filo16M8OXEWf6T9oe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/152] HID: hid-steam: Disable watchdog instead of using a heartbeat
Date: Wed, 19 Feb 2025 09:28:45 +0100
Message-ID: <20250219082554.487282044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 917972636e8271c5691710ce5dcd66c2d3bd04f2 ]

The Steam Deck has a setting that controls whether or not the watchdog is
enabled, so instead of using a heartbeat to keep the watchdog from triggering,
this commit changes the behavior to simply disable the watchdog instead.

Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 7aefd52e945a1..efd297e0ea8c2 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -101,6 +101,7 @@ static LIST_HEAD(steam_devices);
 #define STEAM_REG_GYRO_MODE		0x30
 #define STEAM_REG_LPAD_CLICK_PRESSURE	0x34
 #define STEAM_REG_RPAD_CLICK_PRESSURE	0x35
+#define STEAM_REG_WATCHDOG_ENABLE		0x47
 
 /* Raw event identifiers */
 #define STEAM_EV_INPUT_DATA		0x01
@@ -134,7 +135,6 @@ struct steam_device {
 	struct power_supply __rcu *battery;
 	u8 battery_charge;
 	u16 voltage;
-	struct delayed_work heartbeat;
 	struct work_struct rumble_work;
 	u16 rumble_left;
 	u16 rumble_right;
@@ -340,8 +340,6 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 		steam_send_report_byte(steam, STEAM_CMD_DEFAULT_MAPPINGS);
 		/* enable mouse */
 		steam_send_report_byte(steam, STEAM_CMD_DEFAULT_MOUSE);
-
-		cancel_delayed_work_sync(&steam->heartbeat);
 	} else {
 		/* disable esc, enter, cursor */
 		steam_send_report_byte(steam, STEAM_CMD_CLEAR_MAPPINGS);
@@ -352,13 +350,8 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 				STEAM_REG_RPAD_MODE, 0x07, /* disable mouse */
 				STEAM_REG_LPAD_CLICK_PRESSURE, 0xFFFF, /* disable clicky pad */
 				STEAM_REG_RPAD_CLICK_PRESSURE, 0xFFFF, /* disable clicky pad */
+				STEAM_REG_WATCHDOG_ENABLE, 0, /* disable watchdog that tests if Steam is active */
 				0);
-			/*
-			 * The Steam Deck has a watchdog that automatically enables
-			 * lizard mode if it doesn't see any traffic for too long
-			 */
-			if (!work_busy(&steam->heartbeat.work))
-				schedule_delayed_work(&steam->heartbeat, 5 * HZ);
 		} else {
 			steam_write_registers(steam,
 				STEAM_REG_LPAD_MODE, 0x07, /* disable mouse */
@@ -733,22 +726,6 @@ static bool steam_is_valve_interface(struct hid_device *hdev)
 	return !list_empty(&rep_enum->report_list);
 }
 
-static void steam_lizard_mode_heartbeat(struct work_struct *work)
-{
-	struct steam_device *steam = container_of(work, struct steam_device,
-							heartbeat.work);
-
-	mutex_lock(&steam->mutex);
-	if (!steam->client_opened && steam->client_hdev) {
-		steam_send_report_byte(steam, STEAM_CMD_CLEAR_MAPPINGS);
-		steam_write_registers(steam,
-			STEAM_REG_RPAD_MODE, 0x07, /* disable mouse */
-			0);
-		schedule_delayed_work(&steam->heartbeat, 5 * HZ);
-	}
-	mutex_unlock(&steam->mutex);
-}
-
 static int steam_client_ll_parse(struct hid_device *hdev)
 {
 	struct steam_device *steam = hdev->driver_data;
@@ -887,7 +864,6 @@ static int steam_probe(struct hid_device *hdev,
 	steam->quirks = id->driver_data;
 	INIT_WORK(&steam->work_connect, steam_work_connect_cb);
 	INIT_LIST_HEAD(&steam->list);
-	INIT_DEFERRABLE_WORK(&steam->heartbeat, steam_lizard_mode_heartbeat);
 	INIT_WORK(&steam->rumble_work, steam_haptic_rumble_cb);
 
 	steam->client_hdev = steam_create_client_hid(hdev);
@@ -944,7 +920,6 @@ static int steam_probe(struct hid_device *hdev,
 	hid_destroy_device(steam->client_hdev);
 client_hdev_fail:
 	cancel_work_sync(&steam->work_connect);
-	cancel_delayed_work_sync(&steam->heartbeat);
 	cancel_work_sync(&steam->rumble_work);
 steam_alloc_fail:
 	hid_err(hdev, "%s: failed with error %d\n",
@@ -965,7 +940,6 @@ static void steam_remove(struct hid_device *hdev)
 	mutex_lock(&steam->mutex);
 	steam->client_hdev = NULL;
 	steam->client_opened = false;
-	cancel_delayed_work_sync(&steam->heartbeat);
 	mutex_unlock(&steam->mutex);
 	cancel_work_sync(&steam->work_connect);
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
-- 
2.39.5



