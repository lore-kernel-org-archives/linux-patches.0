Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB782E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EC1C433C9;
	Wed, 20 Sep 2023 12:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211785;
	bh=SlRzDM9tr9cJFQfxuyPO3RGfrFbHwaw3DMHgeKWNvc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0ij6K9H97o3yGTpJsd9DDbHMu9USRuxODWmE2TGiwYZ+dcsPYAg9m8N6KNJS3OM1
	 0jEpDakiLcWWkikgbk2NWe3pelmUfx7bR5KorxNOm/Z2vyb6mxPVxvGHi+iaoYS0um
	 10ZKD0zn4Z5ZUU6R8EpXpqeLa3UC7+LfOhQmbkVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Skomra <skomra@gmail.com>,
	Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 008/273] HID: wacom: remove the battery when the EKR is off
Date: Wed, 20 Sep 2023 13:27:28 +0200
Message-ID: <20230920112846.690909769@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>

commit 9ac6678b95b0dd9458a7a6869f46e51cd55a1d84 upstream.

Currently the EKR battery remains even after we stop getting information
from the device. This can lead to a stale battery persisting indefinitely
in userspace.

The remote sends a heartbeat every 10 seconds. Delete the battery if we
miss two heartbeats (after 21 seconds). Restore the battery once we see
a heartbeat again.

Signed-off-by: Aaron Skomra <skomra@gmail.com>
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Fixes: 9f1015d45f62 ("HID: wacom: EKR: attach the power_supply on first connection")
CC: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom.h     |    1 +
 drivers/hid/wacom_sys.c |   25 +++++++++++++++++++++----
 drivers/hid/wacom_wac.c |    1 +
 drivers/hid/wacom_wac.h |    1 +
 4 files changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -156,6 +156,7 @@ struct wacom_remote {
 		struct input_dev *input;
 		bool registered;
 		struct wacom_battery battery;
+		ktime_t active_time;
 	} remotes[WACOM_MAX_REMOTES];
 };
 
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2500,6 +2500,18 @@ fail:
 	return;
 }
 
+static void wacom_remote_destroy_battery(struct wacom *wacom, int index)
+{
+	struct wacom_remote *remote = wacom->remote;
+
+	if (remote->remotes[index].battery.battery) {
+		devres_release_group(&wacom->hdev->dev,
+				     &remote->remotes[index].battery.bat_desc);
+		remote->remotes[index].battery.battery = NULL;
+		remote->remotes[index].active_time = 0;
+	}
+}
+
 static void wacom_remote_destroy_one(struct wacom *wacom, unsigned int index)
 {
 	struct wacom_remote *remote = wacom->remote;
@@ -2514,9 +2526,7 @@ static void wacom_remote_destroy_one(str
 			remote->remotes[i].registered = false;
 			spin_unlock_irqrestore(&remote->remote_lock, flags);
 
-			if (remote->remotes[i].battery.battery)
-				devres_release_group(&wacom->hdev->dev,
-						     &remote->remotes[i].battery.bat_desc);
+			wacom_remote_destroy_battery(wacom, i);
 
 			if (remote->remotes[i].group.name)
 				devres_release_group(&wacom->hdev->dev,
@@ -2524,7 +2534,6 @@ static void wacom_remote_destroy_one(str
 
 			remote->remotes[i].serial = 0;
 			remote->remotes[i].group.name = NULL;
-			remote->remotes[i].battery.battery = NULL;
 			wacom->led.groups[i].select = WACOM_STATUS_UNKNOWN;
 		}
 	}
@@ -2609,6 +2618,9 @@ static int wacom_remote_attach_battery(s
 	if (remote->remotes[index].battery.battery)
 		return 0;
 
+	if (!remote->remotes[index].active_time)
+		return 0;
+
 	if (wacom->led.groups[index].select == WACOM_STATUS_UNKNOWN)
 		return 0;
 
@@ -2624,6 +2636,7 @@ static void wacom_remote_work(struct wor
 {
 	struct wacom *wacom = container_of(work, struct wacom, remote_work);
 	struct wacom_remote *remote = wacom->remote;
+	ktime_t kt = ktime_get();
 	struct wacom_remote_data data;
 	unsigned long flags;
 	unsigned int count;
@@ -2650,6 +2663,10 @@ static void wacom_remote_work(struct wor
 		serial = data.remote[i].serial;
 		if (data.remote[i].connected) {
 
+			if (kt - remote->remotes[i].active_time > WACOM_REMOTE_BATTERY_TIMEOUT
+			    && remote->remotes[i].active_time != 0)
+				wacom_remote_destroy_battery(wacom, i);
+
 			if (remote->remotes[i].serial == serial) {
 				wacom_remote_attach_battery(wacom, i);
 				continue;
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1077,6 +1077,7 @@ static int wacom_remote_irq(struct wacom
 	if (index < 0 || !remote->remotes[index].registered)
 		goto out;
 
+	remote->remotes[i].active_time = ktime_get();
 	input = remote->remotes[index].input;
 
 	input_report_key(input, BTN_0, (data[9] & 0x01));
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -19,6 +19,7 @@
 #define WACOM_NAME_MAX		64
 #define WACOM_MAX_REMOTES	5
 #define WACOM_STATUS_UNKNOWN	255
+#define WACOM_REMOTE_BATTERY_TIMEOUT	21000000000ll
 
 /* packet length for individual models */
 #define WACOM_PKGLEN_BBFUN	 9


