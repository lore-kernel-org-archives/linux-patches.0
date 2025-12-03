Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF5F3502AC;
	Wed,  3 Dec 2025 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781207; cv=none; b=dmfDRmjLwEcTCZd4UIsm80TGFhwUhKdCdTO3+YpqJ0Nmq+dQT9FMmbrTLkWV628eI7cI828Aj3/+hgB3dx7AlmoDObYeEN+FwNslxRGX52ErBI/rmYrW5OYkDa+XA0XW0fzsl8k5XiUgroj9DCT8BfCLi3I2h6FJy5iBege0C20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781207; c=relaxed/simple;
	bh=Yi4JABfcsfQNuagwZM1txBq8J2KmMOek0H7UisARtlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7IVcKcdUkfnNnUHjlLFUvRHWP/CEKbRBoOYsjmspuiP5qVfjFOkk4yrggNEM+1seAxBlZVF26Hze6rELxkK+anp37BokPvNOTvZbPJ0pwp8mUUaSNijdQcZm8I068SHJb4ktUvAV+rmgEOtqG7Jw673xQD5Ts57/rgrWsdqdwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOEBhCQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOEBhCQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3991CC4CEF5;
	Wed,  3 Dec 2025 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781206;
	bh=Yi4JABfcsfQNuagwZM1txBq8J2KmMOek0H7UisARtlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOEBhCQWtEbCmU9gWKvv23Va9Mq5RoCAhB58teBvk7E3henzY9ZEDVCYK8Umn5SEL
	 9D4W9W6w/ZO8dO59SwfuicjEItg9jeTOc/Ir3d8gZjGCPtrWTPyy8UC+0D39ooLHUQ
	 vmtBCpZRsWggan4wOtybu0/kl8ZFYtd8unvnugDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jimmy Hu <hhhuuu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 82/93] usb: gadget: udc: fix use-after-free in usb_gadget_state_work
Date: Wed,  3 Dec 2025 16:30:15 +0100
Message-ID: <20251203152339.554726938@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jimmy Hu <hhhuuu@google.com>

[ Upstream commit baeb66fbd4201d1c4325074e78b1f557dff89b5b ]

A race condition during gadget teardown can lead to a use-after-free
in usb_gadget_state_work(), as reported by KASAN:

  BUG: KASAN: invalid-access in sysfs_notify+0x2c/0xd0
  Workqueue: events usb_gadget_state_work

The fundamental race occurs because a concurrent event (e.g., an
interrupt) can call usb_gadget_set_state() and schedule gadget->work
at any time during the cleanup process in usb_del_gadget().

Commit 399a45e5237c ("usb: gadget: core: flush gadget workqueue after
device removal") attempted to fix this by moving flush_work() to after
device_del(). However, this does not fully solve the race, as a new
work item can still be scheduled *after* flush_work() completes but
before the gadget's memory is freed, leading to the same use-after-free.

This patch fixes the race condition robustly by introducing a 'teardown'
flag and a 'state_lock' spinlock to the usb_gadget struct. The flag is
set during cleanup in usb_del_gadget() *before* calling flush_work() to
prevent any new work from being scheduled once cleanup has commenced.
The scheduling site, usb_gadget_set_state(), now checks this flag under
the lock before queueing the work, thus safely closing the race window.

Fixes: 5702f75375aa9 ("usb: gadget: udc-core: move sysfs_notify() to a workqueue")
Cc: stable <stable@kernel.org>
Signed-off-by: Jimmy Hu <hhhuuu@google.com>
Link: https://patch.msgid.link/20251023054945.233861-1-hhhuuu@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |   17 ++++++++++++++++-
 include/linux/usb/gadget.h    |    5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1121,8 +1121,13 @@ static void usb_gadget_state_work(struct
 void usb_gadget_set_state(struct usb_gadget *gadget,
 		enum usb_device_state state)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&gadget->state_lock, flags);
 	gadget->state = state;
-	schedule_work(&gadget->work);
+	if (!gadget->teardown)
+		schedule_work(&gadget->work);
+	spin_unlock_irqrestore(&gadget->state_lock, flags);
 	trace_usb_gadget_set_state(gadget, 0);
 }
 EXPORT_SYMBOL_GPL(usb_gadget_set_state);
@@ -1356,6 +1361,8 @@ static void usb_udc_nop_release(struct d
 void usb_initialize_gadget(struct device *parent, struct usb_gadget *gadget,
 		void (*release)(struct device *dev))
 {
+	spin_lock_init(&gadget->state_lock);
+	gadget->teardown = false;
 	INIT_WORK(&gadget->work, usb_gadget_state_work);
 	gadget->dev.parent = parent;
 
@@ -1530,6 +1537,7 @@ EXPORT_SYMBOL_GPL(usb_add_gadget_udc);
 void usb_del_gadget(struct usb_gadget *gadget)
 {
 	struct usb_udc *udc = gadget->udc;
+	unsigned long flags;
 
 	if (!udc)
 		return;
@@ -1543,6 +1551,13 @@ void usb_del_gadget(struct usb_gadget *g
 	kobject_uevent(&udc->dev.kobj, KOBJ_REMOVE);
 	sysfs_remove_link(&udc->dev.kobj, "gadget");
 	device_del(&gadget->dev);
+	/*
+	 * Set the teardown flag before flushing the work to prevent new work
+	 * from being scheduled while we are cleaning up.
+	 */
+	spin_lock_irqsave(&gadget->state_lock, flags);
+	gadget->teardown = true;
+	spin_unlock_irqrestore(&gadget->state_lock, flags);
 	flush_work(&gadget->work);
 	ida_free(&gadget_id_numbers, gadget->id_number);
 	cancel_work_sync(&udc->vbus_work);
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -374,6 +374,9 @@ struct usb_gadget_ops {
  *	can handle. The UDC must support this and all slower speeds and lower
  *	number of lanes.
  * @state: the state we are now (attached, suspended, configured, etc)
+ * @state_lock: Spinlock protecting the `state` and `teardown` members.
+ * @teardown: True if the device is undergoing teardown, used to prevent
+ *	new work from being scheduled during cleanup.
  * @name: Identifies the controller hardware type.  Used in diagnostics
  *	and sometimes configuration.
  * @dev: Driver model state for this abstract device.
@@ -449,6 +452,8 @@ struct usb_gadget {
 	enum usb_ssp_rate		max_ssp_rate;
 
 	enum usb_device_state		state;
+	spinlock_t			state_lock;
+	bool				teardown;
 	const char			*name;
 	struct device			dev;
 	unsigned			isoch_delay;


