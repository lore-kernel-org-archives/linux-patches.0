Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BFD2E9EAF;
	Tue, 22 Jul 2025 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193697; cv=none; b=P9Qs+mm930Pwc/bOWpOr+PBC5v7yW8Bts1yrtjrl7idofw4yNxGNzBW0xnx7oQKl9UckQFGLgwyhzVpPtRlml6GwnNfOtTEirQI/2dN31s5wYx8r8ca+U2oEvOSLDAYvO5tBz5Zj0D/FPvdgZ4/pLZa6K/TXcXESVU5E0wzt/HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193697; c=relaxed/simple;
	bh=bp+I4vtT4efvxQhUdpyaIejy2nOvj2vb8+5O805dDh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd9zaiha7nrobMgCt61Q9TZXqCgr1pYaWcGE4N14s+8qpYhvA+AcnhBIxu1WD60m3G4XBBQ8e7jIxwNvPXt9f82D1G4zWllpPFhfhjvJbpk+v1sSItEYGQWuqWpf69+xsxaXzkveyO/dtEWYku4wf3LFYvr5TEIZFrqgmMWvKvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TaJmaPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TaJmaPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A32C4CEEB;
	Tue, 22 Jul 2025 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193697;
	bh=bp+I4vtT4efvxQhUdpyaIejy2nOvj2vb8+5O805dDh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TaJmaPn/EAXgLTdFVrSJc4YXTfUTiGqB819RzRLxLFowfidXgxrk8orAGs/tT9mM
	 mcjTwrxBlba4V3uz7J/w2+/aIars/sOLx0RY6/rAqc+/xkukW9vtr++4ZdBuE97OjP
	 hxjFlQgO3zcIodH+0hSIINhB45D7PiG9CuaJSc6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.15 169/187] usb: hub: Fix flushing of delayed work used for post resume purposes
Date: Tue, 22 Jul 2025 15:45:39 +0200
Message-ID: <20250722134352.061476955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 9bd9c8026341f75f25c53104eb7e656e357ca1a2 upstream.

Delayed work that prevents USB3 hubs from runtime-suspending too early
needed to be flushed in hub_quiesce() to resolve issues detected on
QC SC8280XP CRD board during suspend resume testing.

This flushing did however trigger new issues on Raspberry Pi 3B+, which
doesn't have USB3 ports, and doesn't queue any post resume delayed work.

The flushed 'hub->init_work' item is used for several purposes, and
is originally initialized with a 'NULL' work function. The work function
is also changed on the fly, which may contribute to the issue.

Solve this by creating a dedicated delayed work item for post resume work,
and flush that delayed work in hub_quiesce()

Cc: stable <stable@kernel.org>
Fixes: a49e1e2e785f ("usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/linux-usb/aF5rNp1l0LWITnEB@finisterre.sirena.org.uk
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # SC8280XP CRD
Tested-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250627164348.3982628-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   21 ++++++++-------------
 drivers/usb/core/hub.h |    1 +
 2 files changed, 9 insertions(+), 13 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1074,12 +1074,11 @@ int usb_remove_device(struct usb_device
 
 enum hub_activation_type {
 	HUB_INIT, HUB_INIT2, HUB_INIT3,		/* INITs must come first */
-	HUB_POST_RESET, HUB_RESUME, HUB_RESET_RESUME, HUB_POST_RESUME,
+	HUB_POST_RESET, HUB_RESUME, HUB_RESET_RESUME,
 };
 
 static void hub_init_func2(struct work_struct *ws);
 static void hub_init_func3(struct work_struct *ws);
-static void hub_post_resume(struct work_struct *ws);
 
 static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 {
@@ -1103,12 +1102,6 @@ static void hub_activate(struct usb_hub
 		goto init3;
 	}
 
-	if (type == HUB_POST_RESUME) {
-		usb_autopm_put_interface_async(to_usb_interface(hub->intfdev));
-		hub_put(hub);
-		return;
-	}
-
 	hub_get(hub);
 
 	/* The superspeed hub except for root hub has to use Hub Depth
@@ -1362,8 +1355,8 @@ static void hub_activate(struct usb_hub
 		usb_autopm_get_interface_no_resume(
 			to_usb_interface(hub->intfdev));
 
-		INIT_DELAYED_WORK(&hub->init_work, hub_post_resume);
-		queue_delayed_work(system_power_efficient_wq, &hub->init_work,
+		queue_delayed_work(system_power_efficient_wq,
+				   &hub->post_resume_work,
 				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
 		return;
 	}
@@ -1388,9 +1381,10 @@ static void hub_init_func3(struct work_s
 
 static void hub_post_resume(struct work_struct *ws)
 {
-	struct usb_hub *hub = container_of(ws, struct usb_hub, init_work.work);
+	struct usb_hub *hub = container_of(ws, struct usb_hub, post_resume_work.work);
 
-	hub_activate(hub, HUB_POST_RESUME);
+	usb_autopm_put_interface_async(to_usb_interface(hub->intfdev));
+	hub_put(hub);
 }
 
 enum hub_quiescing_type {
@@ -1418,7 +1412,7 @@ static void hub_quiesce(struct usb_hub *
 
 	/* Stop hub_wq and related activity */
 	timer_delete_sync(&hub->irq_urb_retry);
-	flush_delayed_work(&hub->init_work);
+	flush_delayed_work(&hub->post_resume_work);
 	usb_kill_urb(hub->urb);
 	if (hub->has_indicators)
 		cancel_delayed_work_sync(&hub->leds);
@@ -1977,6 +1971,7 @@ static int hub_probe(struct usb_interfac
 	hub->hdev = hdev;
 	INIT_DELAYED_WORK(&hub->leds, led_work);
 	INIT_DELAYED_WORK(&hub->init_work, NULL);
+	INIT_DELAYED_WORK(&hub->post_resume_work, hub_post_resume);
 	INIT_WORK(&hub->events, hub_event);
 	INIT_LIST_HEAD(&hub->onboard_devs);
 	spin_lock_init(&hub->irq_urb_lock);
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -70,6 +70,7 @@ struct usb_hub {
 	u8			indicator[USB_MAXCHILDREN];
 	struct delayed_work	leds;
 	struct delayed_work	init_work;
+	struct delayed_work	post_resume_work;
 	struct work_struct      events;
 	spinlock_t		irq_urb_lock;
 	struct timer_list	irq_urb_retry;


