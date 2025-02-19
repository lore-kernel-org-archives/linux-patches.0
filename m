Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A138D1C701E;
	Wed, 19 Feb 2025 09:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955808; cv=none; b=kBHKONkfCK+M34VhpqlWFB0SUBJhWa3Er801Thqw0rCQX+RxnGcOHaCreJv/zUGisxz5+o3f1h+vARkrkSuKG/Obsgismitt3IzD3Wuv1vnsF3zzYOXX+tdWiotkxOFV45Qx2oZQu6zVSYFmLHtbwE9xZ08OPKjcwIOXUAqmuFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955808; c=relaxed/simple;
	bh=6LSsZ1nSBeAQEM1vB69kD6bZmwCCEMOkbbHEyiFxZUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnEE6bRMhSUoikCQl4w6qclnpLJ4r8C4FNCJsjcihHxcwTGwf+BVGbchYC5igsPPk/20HvU5SyI0G+UUTyW8e5V/pV7eZttVC4uY7wdVV1I4F9Aiz+3fnRixNDlAorZ0DlyoKR760lRUWjs/TY8n8dRsmUgdjZ5WqCKaiuJ/7t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jByYWBTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jByYWBTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22866C4CED1;
	Wed, 19 Feb 2025 09:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955808;
	bh=6LSsZ1nSBeAQEM1vB69kD6bZmwCCEMOkbbHEyiFxZUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jByYWBTbQJLcUt0f3rO/p4y2+h4H8RmwLL8CQ/o07fCoKaCQoL/iBfEGXF4cg9Q3b
	 Qeindrn2Le9AZ1w70PzbvBujmk2WD1N5suz0DZBSdZLKfnhn2z/J/Hzg0zNVK73Bh2
	 c1DF6TVXlSJFy2eNmMiO9idNtFiNeCyUfvdtDIKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/152] HID: hid-steam: Move hidraw input (un)registering to work
Date: Wed, 19 Feb 2025 09:28:53 +0100
Message-ID: <20250219082554.799664492@linuxfoundation.org>
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
index a25d0034dc1ea..ee3c27e133443 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -312,6 +312,7 @@ struct steam_device {
 	u16 rumble_left;
 	u16 rumble_right;
 	unsigned int sensor_timestamp_us;
+	struct work_struct unregister_work;
 };
 
 static int steam_recv_report(struct steam_device *steam,
@@ -1070,6 +1071,31 @@ static void steam_mode_switch_cb(struct work_struct *work)
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
@@ -1115,8 +1141,7 @@ static int steam_client_ll_open(struct hid_device *hdev)
 	steam->client_opened = true;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
-	steam_sensors_unregister(steam);
-	steam_input_unregister(steam);
+	schedule_work(&steam->unregister_work);
 
 	return 0;
 }
@@ -1133,11 +1158,7 @@ static void steam_client_ll_close(struct hid_device *hdev)
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
@@ -1229,6 +1250,7 @@ static int steam_probe(struct hid_device *hdev,
 	INIT_LIST_HEAD(&steam->list);
 	INIT_WORK(&steam->rumble_work, steam_haptic_rumble_cb);
 	steam->sensor_timestamp_us = 0;
+	INIT_WORK(&steam->unregister_work, steam_work_unregister_cb);
 
 	/*
 	 * With the real steam controller interface, do not connect hidraw.
@@ -1289,6 +1311,7 @@ static int steam_probe(struct hid_device *hdev,
 	cancel_work_sync(&steam->work_connect);
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->rumble_work);
+	cancel_work_sync(&steam->unregister_work);
 
 	return ret;
 }
@@ -1305,6 +1328,7 @@ static void steam_remove(struct hid_device *hdev)
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
 	cancel_work_sync(&steam->rumble_work);
+	cancel_work_sync(&steam->unregister_work);
 	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
 	steam->client_opened = false;
-- 
2.39.5



