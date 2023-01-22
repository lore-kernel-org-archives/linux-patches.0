Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B0F2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD32C433EF;
	Sun, 22 Jan 2023 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401062;
	bh=MlQYjp4QBINGF+h3nPJyzdLvWl6RcXFS8j9Tlxlv3ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bG6uQdRCOKL6fVNuAf2/kcC2Mp4FbS9ejEQiVXm848AF4dnH0RDRu/kzz70nrGuP
	 fLPydfo9Fgoh8xz6z70dkGwob2GrctnAt3W4XpiUcLmgLmhfJSd+tmVLy07Hq4KAP9
	 2xmWP8Mn0Yn38mVhneacQxOUH1uiKrAtbjojPOpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 6.1 067/193] usb: misc: onboard_hub: Move attach work to the driver
Date: Sun, 22 Jan 2023 16:03:16 +0100
Message-Id: <20230122150249.423977392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthias Kaehlcke <mka@chromium.org>

commit cde37881e2e14590675d0acdfbad408300d9ca95 upstream.

Currently each onboard_hub platform device owns an 'attach' work,
which is scheduled when the device probes. With this deadlocks
have been reported on a Raspberry Pi 3 B+ [1], which has nested
onboard hubs.

The flow of the deadlock is something like this (with the onboard_hub
driver built as a module) [2]:

- USB root hub is instantiated
- core hub driver calls onboard_hub_create_pdevs(), which creates the
  'raw' platform device for the 1st level hub
- 1st level hub is probed by the core hub driver
- core hub driver calls onboard_hub_create_pdevs(), which creates
  the 'raw' platform device for the 2nd level hub

- onboard_hub platform driver is registered
- platform device for 1st level hub is probed
  - schedules 'attach' work
- platform device for 2nd level hub is probed
  - schedules 'attach' work

- onboard_hub USB driver is registered
- device (and parent) lock of hub is held while the device is
  re-probed with the onboard_hub driver

- 'attach' work (running in another thread) calls driver_attach(), which
   blocks on one of the hub device locks

- onboard_hub_destroy_pdevs() is called by the core hub driver when one
  of the hubs is detached
- destroying the pdevs invokes onboard_hub_remove(), which waits for the
  'attach' work to complete
  - waits forever, since the 'attach' work can't acquire the device lock

Use a single work struct for the driver instead of having a work struct
per onboard hub platform driver instance. With that it isn't necessary
to cancel the work in onboard_hub_remove(), which fixes the deadlock.
The work is only cancelled when the driver is unloaded.

[1] https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
[2] https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/

Cc: stable@vger.kernel.org
Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
Link: https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20230110172954.v2.2.I16b51f32db0c32f8a8532900bfe1c70c8572881a@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_hub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -27,7 +27,10 @@
 
 #include "onboard_usb_hub.h"
 
+static void onboard_hub_attach_usb_driver(struct work_struct *work);
+
 static struct usb_device_driver onboard_hub_usbdev_driver;
+static DECLARE_WORK(attach_usb_driver_work, onboard_hub_attach_usb_driver);
 
 /************************** Platform driver **************************/
 
@@ -45,7 +48,6 @@ struct onboard_hub {
 	bool is_powered_on;
 	bool going_away;
 	struct list_head udev_list;
-	struct work_struct attach_usb_driver_work;
 	struct mutex lock;
 };
 
@@ -271,8 +273,7 @@ static int onboard_hub_probe(struct plat
 	 * This needs to be done deferred to avoid self-deadlocks on systems
 	 * with nested onboard hubs.
 	 */
-	INIT_WORK(&hub->attach_usb_driver_work, onboard_hub_attach_usb_driver);
-	schedule_work(&hub->attach_usb_driver_work);
+	schedule_work(&attach_usb_driver_work);
 
 	return 0;
 }
@@ -285,9 +286,6 @@ static int onboard_hub_remove(struct pla
 
 	hub->going_away = true;
 
-	if (&hub->attach_usb_driver_work != current_work())
-		cancel_work_sync(&hub->attach_usb_driver_work);
-
 	mutex_lock(&hub->lock);
 
 	/* unbind the USB devices to avoid dangling references to this device */
@@ -447,6 +445,8 @@ static void __exit onboard_hub_exit(void
 {
 	usb_deregister_device_driver(&onboard_hub_usbdev_driver);
 	platform_driver_unregister(&onboard_hub_driver);
+
+	cancel_work_sync(&attach_usb_driver_work);
 }
 module_exit(onboard_hub_exit);
 


