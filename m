Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7A37F46E;
	Mon,  8 Apr 2024 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584961; cv=none; b=dyYan3LbuUjA0sUJt3OkwOF086ea9uXs5onCm9iYQ4okmyokoFFGlR5HaWceNcKQ4WNLtlWQMeIncZdYyCK500HK0hN3Hvgnt/k+eAYExHY5AGP7pz2VWGaNPoqnLQ+36YIBGR6L9XjUY26Lg9m9xIY3FazPuPN8JK+V8xhAgG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584961; c=relaxed/simple;
	bh=V0T2h/maAa/2pRcg9Hl0i1g+HX3HZwBMqEK0qekDI4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJeHFH7cvcbHq6TUH5xnXh7988MhZAN0Q3rzYoIb+7sb/g5ejJR54+5RqvzRB4UJGedwqPJZj5adiKJxTlbabtpa0Qz6DZByU3gTPRU7STcQmJXxcKBynbgUtDV+1k8RqJa6V5VgYP1aRVSau7G2EyuUxssAzkCZcWChzHbyrlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxmy2epc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxmy2epc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDBDC433C7;
	Mon,  8 Apr 2024 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584961;
	bh=V0T2h/maAa/2pRcg9Hl0i1g+HX3HZwBMqEK0qekDI4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxmy2epcNb+jHwjkZZ4o1TomGHfQFRAMS7BavnZR8phct1X6cHf27oWZDjLXv/Iyq
	 BLcb+k8fh0OlUXQeps+oyyW0Jz6C/5i89IVa8otmm6ZAMvGDSFLHXLl4wwyU+6qrBN
	 FGmOF9WiltqWM+S64wRBUQwZ/VQbjXuc0C5g8rT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 585/690] USB: core: Add hub_get() and hub_put() routines
Date: Mon,  8 Apr 2024 14:57:31 +0200
Message-ID: <20240408125420.773800219@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,7 +116,6 @@ EXPORT_SYMBOL_GPL(ehci_cf_port_reset_rws
 #define HUB_DEBOUNCE_STEP	  25
 #define HUB_DEBOUNCE_STABLE	 100
 
-static void hub_release(struct kref *kref);
 static int usb_reset_and_verify_device(struct usb_device *udev);
 static int hub_port_disable(struct usb_hub *hub, int port1, int set_state);
 static bool hub_port_warm_reset_required(struct usb_hub *hub, int port1,
@@ -678,14 +677,14 @@ static void kick_hub_wq(struct usb_hub *
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
@@ -1053,7 +1052,7 @@ static void hub_activate(struct usb_hub
 			goto init2;
 		goto init3;
 	}
-	kref_get(&hub->kref);
+	hub_get(hub);
 
 	/* The superspeed hub except for root hub has to use Hub Depth
 	 * value as an offset into the route string to locate the bits
@@ -1301,7 +1300,7 @@ static void hub_activate(struct usb_hub
 		device_unlock(&hdev->dev);
 	}
 
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 }
 
 /* Implement the continuations for the delays above */
@@ -1717,6 +1716,16 @@ static void hub_release(struct kref *kre
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
@@ -1763,7 +1772,7 @@ static void hub_disconnect(struct usb_in
 	if (hub->quirk_disable_autosuspend)
 		usb_autopm_put_interface(intf);
 
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 }
 
 static bool hub_descriptor_is_sane(struct usb_host_interface *desc)
@@ -5853,7 +5862,7 @@ out_hdev_lock:
 
 	/* Balance the stuff in kick_hub_wq() and allow autosuspend */
 	usb_autopm_put_interface(intf);
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 
 	kcov_remote_stop();
 }
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -117,6 +117,8 @@ extern void usb_hub_remove_port_device(s
 extern int usb_hub_set_port_power(struct usb_device *hdev, struct usb_hub *hub,
 		int port1, bool set);
 extern struct usb_hub *usb_hub_to_struct_hub(struct usb_device *hdev);
+extern void hub_get(struct usb_hub *hub);
+extern void hub_put(struct usb_hub *hub);
 extern int hub_port_debounce(struct usb_hub *hub, int port1,
 		bool must_be_connected);
 extern int usb_clear_port_feature(struct usb_device *hdev,


