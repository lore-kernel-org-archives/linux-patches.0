Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7862D23BC;
	Tue, 22 Jul 2025 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192548; cv=none; b=UQYD3/Vb/NtDr4s+Bc8/lRHzMwgX2THuU4tSBZ72P/2xP+b7VGJ3FA5igP8IE6ISO3UJv84fMeHfQozGr1EFBrDquPLW2CJv0QDRxCu8yQKASHCeMECf/h5Ge3JvybN1YldPGzdQFQAjVpjYdfDKPYcxQwOEklemuuPNqR339ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192548; c=relaxed/simple;
	bh=FA56Ix8wQN6usRn/JlJsJsWgiueBopEi8ZdAXkSb0ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhRb/3ZU8Dtf28F35ujOMgRRPNZgq+rmNmVDm6upAQxwRZA9V/iAmmswIz2NvKpTyrYyQ2GWY36uVHDIa9BuoOibPqQ1CufLxM26Nl+wVldCBkQioOGnb4RUnm+kXdorzS/3GdCmTMc0+NjShoAib33SYVkcvJUixjrED2ra06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvR9NMJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvR9NMJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A1CC4CEEB;
	Tue, 22 Jul 2025 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192548;
	bh=FA56Ix8wQN6usRn/JlJsJsWgiueBopEi8ZdAXkSb0ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvR9NMJdagGTlIo9BV0iTbSgE1W+x2r7KkUmztONQw+A8/OF9WoKXjyqesjh/TQ5V
	 i2UEYND5UeGuzjacSnWvTP0ZqijwNOU7T3r8pU0qz0XceqrF9URulTHly20LVYY3w4
	 X7Je/MjDETzZkhs/Mi7AUJRA3pKgx6zN3k3tl960=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 097/111] usb: hub: fix detection of high tier USB3 devices behind suspended hubs
Date: Tue, 22 Jul 2025 15:45:12 +0200
Message-ID: <20250722134337.030877535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 8f5b7e2bec1c36578fdaa74a6951833541103e27 upstream.

USB3 devices connected behind several external suspended hubs may not
be detected when plugged in due to aggressive hub runtime pm suspend.

The hub driver immediately runtime-suspends hubs if there are no
active children or port activity.

There is a delay between the wake signal causing hub resume, and driver
visible port activity on the hub downstream facing ports.
Most of the LFPS handshake, resume signaling and link training done
on the downstream ports is not visible to the hub driver until completed,
when device then will appear fully enabled and running on the port.

This delay between wake signal and detectable port change is even more
significant with chained suspended hubs where the wake signal will
propagate upstream first. Suspended hubs will only start resuming
downstream ports after upstream facing port resumes.

The hub driver may resume a USB3 hub, read status of all ports, not
yet see any activity, and runtime suspend back the hub before any
port activity is visible.

This exact case was seen when conncting USB3 devices to a suspended
Thunderbolt dock.

USB3 specification defines a 100ms tU3WakeupRetryDelay, indicating
USB3 devices expect to be resumed within 100ms after signaling wake.
if not then device will resend the wake signal.

Give the USB3 hubs twice this time (200ms) to detect any port
changes after resume, before allowing hub to runtime suspend again.

Cc: stable <stable@kernel.org>
Fixes: 2839f5bcfcfc ("USB: Turn on auto-suspend for USB 3.0 hubs.")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250611112441.2267883-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -66,6 +66,12 @@
  */
 #define USB_SHORT_SET_ADDRESS_REQ_TIMEOUT	500  /* ms */
 
+/*
+ * Give SS hubs 200ms time after wake to train downstream links before
+ * assuming no port activity and allowing hub to runtime suspend back.
+ */
+#define USB_SS_PORT_U0_WAKE_TIME	200  /* ms */
+
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
  * change to USB_STATE_NOTATTACHED even when the semaphore isn't held. */
@@ -1038,11 +1044,12 @@ int usb_remove_device(struct usb_device
 
 enum hub_activation_type {
 	HUB_INIT, HUB_INIT2, HUB_INIT3,		/* INITs must come first */
-	HUB_POST_RESET, HUB_RESUME, HUB_RESET_RESUME,
+	HUB_POST_RESET, HUB_RESUME, HUB_RESET_RESUME, HUB_POST_RESUME,
 };
 
 static void hub_init_func2(struct work_struct *ws);
 static void hub_init_func3(struct work_struct *ws);
+static void hub_post_resume(struct work_struct *ws);
 
 static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 {
@@ -1065,6 +1072,13 @@ static void hub_activate(struct usb_hub
 			goto init2;
 		goto init3;
 	}
+
+	if (type == HUB_POST_RESUME) {
+		usb_autopm_put_interface_async(to_usb_interface(hub->intfdev));
+		hub_put(hub);
+		return;
+	}
+
 	hub_get(hub);
 
 	/* The superspeed hub except for root hub has to use Hub Depth
@@ -1313,6 +1327,16 @@ static void hub_activate(struct usb_hub
 		device_unlock(&hdev->dev);
 	}
 
+	if (type == HUB_RESUME && hub_is_superspeed(hub->hdev)) {
+		/* give usb3 downstream links training time after hub resume */
+		INIT_DELAYED_WORK(&hub->init_work, hub_post_resume);
+		queue_delayed_work(system_power_efficient_wq, &hub->init_work,
+				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
+		usb_autopm_get_interface_no_resume(
+			to_usb_interface(hub->intfdev));
+		return;
+	}
+
 	hub_put(hub);
 }
 
@@ -1331,6 +1355,13 @@ static void hub_init_func3(struct work_s
 	hub_activate(hub, HUB_INIT3);
 }
 
+static void hub_post_resume(struct work_struct *ws)
+{
+	struct usb_hub *hub = container_of(ws, struct usb_hub, init_work.work);
+
+	hub_activate(hub, HUB_POST_RESUME);
+}
+
 enum hub_quiescing_type {
 	HUB_DISCONNECT, HUB_PRE_RESET, HUB_SUSPEND
 };


