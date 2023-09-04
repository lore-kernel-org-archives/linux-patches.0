Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF357C145
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330A3C433C9;
	Mon,  4 Sep 2023 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852370;
	bh=/TBthkgy0UogWNb4IfOMDFb4TpXXazwygIov2QjPpmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDdN0oOvEqgDeyiaVtympDwlfaG5XE2mDH4f6Nq/l/CGTq3gevASVj9yFJDObusgA
	 pd82HNjS7sk8sZ2NXbkR0MhierHH1ok+aOJCPIZQrB+5yFypi3vTvzhSBdOMHAqg8e
	 4vR7/jfWwrJFykkUOgyR1ZbU+9YIgYX/w5GTSjHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Skomra <skomra@gmail.com>,
	Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.5 17/34] HID: wacom: remove the battery when the EKR is off
Date: Mon,  4 Sep 2023 19:30:04 +0100
Message-ID: <20230904182949.383267145@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,6 +150,7 @@ struct wacom_remote {
 		struct input_dev *input;
 		bool registered;
 		struct wacom_battery battery;
+		ktime_t active_time;
 	} remotes[WACOM_MAX_REMOTES];
 };
 
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2523,6 +2523,18 @@ fail:
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
@@ -2537,9 +2549,7 @@ static void wacom_remote_destroy_one(str
 			remote->remotes[i].registered = false;
 			spin_unlock_irqrestore(&remote->remote_lock, flags);
 
-			if (remote->remotes[i].battery.battery)
-				devres_release_group(&wacom->hdev->dev,
-						     &remote->remotes[i].battery.bat_desc);
+			wacom_remote_destroy_battery(wacom, i);
 
 			if (remote->remotes[i].group.name)
 				devres_release_group(&wacom->hdev->dev,
@@ -2547,7 +2557,6 @@ static void wacom_remote_destroy_one(str
 
 			remote->remotes[i].serial = 0;
 			remote->remotes[i].group.name = NULL;
-			remote->remotes[i].battery.battery = NULL;
 			wacom->led.groups[i].select = WACOM_STATUS_UNKNOWN;
 		}
 	}
@@ -2632,6 +2641,9 @@ static int wacom_remote_attach_battery(s
 	if (remote->remotes[index].battery.battery)
 		return 0;
 
+	if (!remote->remotes[index].active_time)
+		return 0;
+
 	if (wacom->led.groups[index].select == WACOM_STATUS_UNKNOWN)
 		return 0;
 
@@ -2647,6 +2659,7 @@ static void wacom_remote_work(struct wor
 {
 	struct wacom *wacom = container_of(work, struct wacom, remote_work);
 	struct wacom_remote *remote = wacom->remote;
+	ktime_t kt = ktime_get();
 	struct wacom_remote_data data;
 	unsigned long flags;
 	unsigned int count;
@@ -2673,6 +2686,10 @@ static void wacom_remote_work(struct wor
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
@@ -1134,6 +1134,7 @@ static int wacom_remote_irq(struct wacom
 	if (index < 0 || !remote->remotes[index].registered)
 		goto out;
 
+	remote->remotes[i].active_time = ktime_get();
 	input = remote->remotes[index].input;
 
 	input_report_key(input, BTN_0, (data[9] & 0x01));
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -13,6 +13,7 @@
 #define WACOM_NAME_MAX		64
 #define WACOM_MAX_REMOTES	5
 #define WACOM_STATUS_UNKNOWN	255
+#define WACOM_REMOTE_BATTERY_TIMEOUT	21000000000ll
 
 /* packet length for individual models */
 #define WACOM_PKGLEN_BBFUN	 9


