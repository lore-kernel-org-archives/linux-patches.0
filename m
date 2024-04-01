Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493264776F;
	Mon,  1 Apr 2024 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987777; cv=none; b=mQtXSOykb5rnXbyfuHRLEF6L0YrC2VaucX9fmW9F2uk+Sb8nnOfnhmtvucqgRZiV1+AYyPB6deKNm9yTDWzFFb/P9sViUc9Q8iaqE8YBayoFnHB8p1PIJp0DGvD1MSrVwOqXeEOZMNWFki9bh/2zvENywCXJhtS27gFfe08vLqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987777; c=relaxed/simple;
	bh=OjM9EhUK0hGF6sTRQnSIBECrCL/pVQRdOI6vNumFn9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOzXMt5dn/QA1uS129b1L8kb62ELqgaymgvdMdrY9/o7BuVwS2hUfTY0KjZUChw0JobM1oe50QZ3d0MH57jxhKP3PtDW3J7zU09aeyOxlV14BTsEk3QPdEV5nx0VrkMcm+xVpTM0KJ0bu2zzJsKzqXHAIEXjG0kvfbWlwYt1dXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJ5S440p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJ5S440p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2D8C433F1;
	Mon,  1 Apr 2024 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987776;
	bh=OjM9EhUK0hGF6sTRQnSIBECrCL/pVQRdOI6vNumFn9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ5S440p7ZbMPWhKRsE+iooEsv3wh2/LeliVwnjlsq1KK9JyD5nrs3elQjoxjhEeb
	 a6t4RS/hLOKWUmLylFMMWyxq8l9ry+u8SpMYMGQsjvNkwDrt2JsFht4rPRnvGUaBRz
	 1hEDN41XTSNj1h+7l1BqYI5Gqbizdq6fbOba++ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.8 359/399] USB: core: Add hub_get() and hub_put() routines
Date: Mon,  1 Apr 2024 17:45:25 +0200
Message-ID: <20240401152559.886267223@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -129,7 +129,6 @@ EXPORT_SYMBOL_GPL(ehci_cf_port_reset_rws
 #define HUB_DEBOUNCE_STEP	  25
 #define HUB_DEBOUNCE_STABLE	 100
 
-static void hub_release(struct kref *kref);
 static int usb_reset_and_verify_device(struct usb_device *udev);
 static int hub_port_disable(struct usb_hub *hub, int port1, int set_state);
 static bool hub_port_warm_reset_required(struct usb_hub *hub, int port1,
@@ -691,14 +690,14 @@ static void kick_hub_wq(struct usb_hub *
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
@@ -1066,7 +1065,7 @@ static void hub_activate(struct usb_hub
 			goto init2;
 		goto init3;
 	}
-	kref_get(&hub->kref);
+	hub_get(hub);
 
 	/* The superspeed hub except for root hub has to use Hub Depth
 	 * value as an offset into the route string to locate the bits
@@ -1314,7 +1313,7 @@ static void hub_activate(struct usb_hub
 		device_unlock(&hdev->dev);
 	}
 
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 }
 
 /* Implement the continuations for the delays above */
@@ -1730,6 +1729,16 @@ static void hub_release(struct kref *kre
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
@@ -1778,7 +1787,7 @@ static void hub_disconnect(struct usb_in
 
 	onboard_hub_destroy_pdevs(&hub->onboard_hub_devs);
 
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 }
 
 static bool hub_descriptor_is_sane(struct usb_host_interface *desc)
@@ -5905,7 +5914,7 @@ out_hdev_lock:
 
 	/* Balance the stuff in kick_hub_wq() and allow autosuspend */
 	usb_autopm_put_interface(intf);
-	kref_put(&hub->kref, hub_release);
+	hub_put(hub);
 
 	kcov_remote_stop();
 }
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -129,6 +129,8 @@ extern void usb_hub_remove_port_device(s
 extern int usb_hub_set_port_power(struct usb_device *hdev, struct usb_hub *hub,
 		int port1, bool set);
 extern struct usb_hub *usb_hub_to_struct_hub(struct usb_device *hdev);
+extern void hub_get(struct usb_hub *hub);
+extern void hub_put(struct usb_hub *hub);
 extern int hub_port_debounce(struct usb_hub *hub, int port1,
 		bool must_be_connected);
 extern int usb_clear_port_feature(struct usb_device *hdev,


