Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8251DF738;
	Wed, 19 Feb 2025 08:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954522; cv=none; b=FouzhIRZJVyvGAUnU14osVCyNulozga/Pon8V+/3mx9IBUcfhh9kh8pJ/N3knW3pHV4+ame2/Wol1bWTnZz3zbBWWitxffsGsVSSbswCbUSJfHcdeS8eEEJ+9if79pDto7+ONfkUCJnkPXp5X+j5sF+2iFcKXg8BqKg9ngMGGBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954522; c=relaxed/simple;
	bh=6azogLU2aGzD16+SRVNkx0ZU73mvDcV58p8yVgz6iLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcdCSTwoNs88Hdq1qitdZSArElNlXYKbewczLJ6CzSpRG4VjUpefWZFCKAZEieG0p6Dgh6pDINSoTnLsuoo9UXmSvB0HsNsDebKTSuqr27oJTsEL0H2k2lRfx/wN30a5Rk9m50mgAQLzntyGTXX02mctGosZdrcGSXBRb9qQeAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAESMyVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAESMyVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089AFC4CEE7;
	Wed, 19 Feb 2025 08:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954521;
	bh=6azogLU2aGzD16+SRVNkx0ZU73mvDcV58p8yVgz6iLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAESMyVzdt9S3xnTiMHjOm5yuDzqYACEBI8OI6r1uLB0nNmGt3e4whntpqU0hkOO7
	 RoGvM4iZj+sRlcC6mPyi2dmnxOxpbhkT9NWTZQdgbbiUq1Am8O31mAc3GiS7m4SWYO
	 yoAkJt797QtWtPHEjmlGgvUKYPTfRBdsehdv8KzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 228/274] HID: hid-steam: Move hidraw input (un)registering to work
Date: Wed, 19 Feb 2025 09:28:02 +0100
Message-ID: <20250219082618.500524536@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 79504249d7e27cad4a3eeb9afc6386e418728ce0 ]

Due to an interplay between locking in the input and hid transport subsystems,
attempting to register or deregister the relevant input devices during the
hidraw open/close events can lead to a lock ordering issue. Though this
shouldn't cause a deadlock, this commit moves the input device manipulation to
deferred work to sidestep the issue.

Fixes: 385a4886778f6 ("HID: steam: remove input device when a hid client is running.")
Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 48139ef80dc11..5f8518f6f5ac7 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -313,6 +313,7 @@ struct steam_device {
 	u16 rumble_left;
 	u16 rumble_right;
 	unsigned int sensor_timestamp_us;
+	struct work_struct unregister_work;
 };
 
 static int steam_recv_report(struct steam_device *steam,
@@ -1072,6 +1073,31 @@ static void steam_mode_switch_cb(struct work_struct *work)
 	}
 }
 
+static void steam_work_unregister_cb(struct work_struct *work)
+{
+	struct steam_device *steam = container_of(work, struct steam_device,
+							unregister_work);
+	unsigned long flags;
+	bool connected;
+	bool opened;
+
+	spin_lock_irqsave(&steam->lock, flags);
+	opened = steam->client_opened;
+	connected = steam->connected;
+	spin_unlock_irqrestore(&steam->lock, flags);
+
+	if (connected) {
+		if (opened) {
+			steam_sensors_unregister(steam);
+			steam_input_unregister(steam);
+		} else {
+			steam_set_lizard_mode(steam, lizard_mode);
+			steam_input_register(steam);
+			steam_sensors_register(steam);
+		}
+	}
+}
+
 static bool steam_is_valve_interface(struct hid_device *hdev)
 {
 	struct hid_report_enum *rep_enum;
@@ -1117,8 +1143,7 @@ static int steam_client_ll_open(struct hid_device *hdev)
 	steam->client_opened++;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
-	steam_sensors_unregister(steam);
-	steam_input_unregister(steam);
+	schedule_work(&steam->unregister_work);
 
 	return 0;
 }
@@ -1135,11 +1160,7 @@ static void steam_client_ll_close(struct hid_device *hdev)
 	connected = steam->connected && !steam->client_opened;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
-	if (connected) {
-		steam_set_lizard_mode(steam, lizard_mode);
-		steam_input_register(steam);
-		steam_sensors_register(steam);
-	}
+	schedule_work(&steam->unregister_work);
 }
 
 static int steam_client_ll_raw_request(struct hid_device *hdev,
@@ -1231,6 +1252,7 @@ static int steam_probe(struct hid_device *hdev,
 	INIT_LIST_HEAD(&steam->list);
 	INIT_WORK(&steam->rumble_work, steam_haptic_rumble_cb);
 	steam->sensor_timestamp_us = 0;
+	INIT_WORK(&steam->unregister_work, steam_work_unregister_cb);
 
 	/*
 	 * With the real steam controller interface, do not connect hidraw.
@@ -1291,6 +1313,7 @@ static int steam_probe(struct hid_device *hdev,
 	cancel_work_sync(&steam->work_connect);
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->rumble_work);
+	cancel_work_sync(&steam->unregister_work);
 
 	return ret;
 }
@@ -1307,6 +1330,7 @@ static void steam_remove(struct hid_device *hdev)
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
 	cancel_work_sync(&steam->rumble_work);
+	cancel_work_sync(&steam->unregister_work);
 	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
 	steam->client_opened = 0;
-- 
2.39.5



