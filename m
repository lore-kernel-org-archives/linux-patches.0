Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E35638DE5;
	Mon,  1 Apr 2024 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991483; cv=none; b=GFYWmcd2Buma0/TfyAIkYQrL9SdcI+0lwyd6pqkLbKxybKX6tP/m6avcPOyqLO/4qJqWUhKKt7qqN0+0GZwiXiTMH+YPumB1bnnEfGtBoHn5YzKVSjPIS8qInrgr3VMCEWbVA+/QT/UkJ5C9TPQnqfr6XJtEFQuEUdOXDj/8s+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991483; c=relaxed/simple;
	bh=L75n5ie3OYqBfc8gA+wpnlVSKEae3RkMj8K0NmL2J+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1cKq2m4KJs6amYZixzx7xTghrzf0DkLgb7wIwOYmpEXiNFPgFbCv02B0duEjmRPRNG5b2JnhPm8iKUY8gXtho2bNfIsHp7MtbdTx7DYB4VrFYB6XseZYeiy9IUatziXC4mUrVhcZ10n1GKCYQ9b4ejb4q6UUeQ9s6GJ+1JApN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7eFSBnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7eFSBnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A546AC433F1;
	Mon,  1 Apr 2024 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991483;
	bh=L75n5ie3OYqBfc8gA+wpnlVSKEae3RkMj8K0NmL2J+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7eFSBnE+kKoIt18PyBl13qBqmcJPWdRaYuWYzpQxj9PHIKGtVDdqy2ta+7fOFZez
	 yHPivBbfujoWIFEpi0dOESmRMtE9GT8pzwI3IvE8iEbl+CM6X1oMTNtpOyLlptxmia
	 FiUmWlOZXoeGq8pxt0SYpf95i+D8jnEy/mK/rSVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 240/272] USB: core: Add hub_get() and hub_put() routines
Date: Mon,  1 Apr 2024 17:47:10 +0200
Message-ID: <20240401152538.471002225@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit ee113b860aa169e9a4d2c167c95d0f1961c6e1b8 upstream.

Create hub_get() and hub_put() routines to encapsulate the kref_get()
and kref_put() calls in hub.c.  The new routines will be used by the
next patch in this series.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/604da420-ae8a-4a9e-91a4-2d511ff404fb@rowland.harvard.edu
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   23 ++++++++++++++++-------
 drivers/usb/core/hub.h |    2 ++
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -123,7 +123,6 @@ EXPORT_SYMBOL_GPL(ehci_cf_port_reset_rws
 #define HUB_DEBOUNCE_STEP	  25
 #define HUB_DEBOUNCE_STABLE	 100
 
-static void hub_release(struct kref *kref);
 static int usb_reset_and_verify_device(struct usb_device *udev);
 static int hub_port_disable(struct usb_hub *hub, int port1, int set_state);
 static bool hub_port_warm_reset_required(struct usb_hub *hub, int port1,
@@ -685,14 +684,14 @@ static void kick_hub_wq(struct usb_hub *
 	 */
 	intf = to_usb_interface(hub->intfdev);
 	usb_autopm_get_interface_no_resume(intf);
-	kref_get(&hub->kref);
+	hub_get(hub);
 
 	if (queue_work(hub_wq, &hub->events))
 		return;
 
 	/* the work has already been scheduled */
 	usb_autopm_put_interface_async(intf);
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 }
 
 void usb_kick_hub_wq(struct usb_device *hdev)
@@ -1060,7 +1059,7 @@ static void hub_activate(struct usb_hub
 			goto init2;
 		goto init3;
 	}
-	kref_get(&hub->kref);
+	hub_get(hub);
 
 	/* The superspeed hub except for root hub has to use Hub Depth
 	 * value as an offset into the route string to locate the bits
@@ -1308,7 +1307,7 @@ static void hub_activate(struct usb_hub
 		device_unlock(&hdev->dev);
 	}
 
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 }
 
 /* Implement the continuations for the delays above */
@@ -1724,6 +1723,16 @@ static void hub_release(struct kref *kre
 	kfree(hub);
 }
 
+void hub_get(struct usb_hub *hub)
+{
+	kref_get(&hub->kref);
+}
+
+void hub_put(struct usb_hub *hub)
+{
+	kref_put(&hub->kref, hub_release);
+}
+
 static unsigned highspeed_hubs;
 
 static void hub_disconnect(struct usb_interface *intf)
@@ -1772,7 +1781,7 @@ static void hub_disconnect(struct usb_in
 
 	onboard_hub_destroy_pdevs(&hub->onboard_hub_devs);
 
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 }
 
 static bool hub_descriptor_is_sane(struct usb_host_interface *desc)
@@ -5874,7 +5883,7 @@ out_hdev_lock:
 
 	/* Balance the stuff in kick_hub_wq() and allow autosuspend */
 	usb_autopm_put_interface(intf);
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 
 	kcov_remote_stop();
 }
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -118,6 +118,8 @@ extern void usb_hub_remove_port_device(s
 extern int usb_hub_set_port_power(struct usb_device *hdev, struct usb_hub *hub,
 		int port1, bool set);
 extern struct usb_hub *usb_hub_to_struct_hub(struct usb_device *hdev);
+extern void hub_get(struct usb_hub *hub);
+extern void hub_put(struct usb_hub *hub);
 extern int hub_port_debounce(struct usb_hub *hub, int port1,
 		bool must_be_connected);
 extern int usb_clear_port_feature(struct usb_device *hdev,


