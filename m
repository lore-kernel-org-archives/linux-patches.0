Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50E83D3016;
	Thu, 15 Jan 2026 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499792; cv=none; b=il3Ezsamo1ptMm4VTghkq4nTGC6csnzDymw9qhv2xw0nUV07rLh+8dbRW0D+DEO4x3MjmIVysu2sc2OT4WNc3TpUeqv7tqEkdGUixjhEDf4Xh2Wd9nvbgu8KZSJcqHoZEraOQhhp4bPpHXRT447lOLhUsaBLDM/JMvfotTDJchs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499792; c=relaxed/simple;
	bh=M38oMJhnQ0h2It1Pg+OEfYAOZOugB8N+59PXrbfHQkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Of3Wpj9evZhQbNHV7xSqgtYXvZv/+jNnq8tRBQ+x6rN3NEJmIcMwhwQFOL8Isg/uZFTJEDivQtoz2KP0RsCTwn6dpH81IdX4GTPELnpP4ueX1IYGZMBuTBudCJtCHPpIbBzo5d6Pf4MjG/W+VGRC04pFVsx6VVUqBmV85ntu28Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5zjIeZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5zjIeZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C60C116D0;
	Thu, 15 Jan 2026 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499791;
	bh=M38oMJhnQ0h2It1Pg+OEfYAOZOugB8N+59PXrbfHQkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5zjIeZ+pJfGjGcVkO64CPMkxhzzSvX3fDtuKB8kL96v8oyLzV/9qYDBddvsuWUvS
	 6Qi7n8KyfYAfHL4r5WsEMGYRuWy9rmza4m7m+A2abVIA7ndwy9Vaj0aS40+elLsCcm
	 mJVmJ1qKOnaC+wzvfedeGIMihQijoga2YbRSfL/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jimmy Hu <hhhuuu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/451] usb: gadget: udc: fix use-after-free in usb_gadget_state_work
Date: Thu, 15 Jan 2026 17:49:13 +0100
Message-ID: <20260115164243.635182566@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |   17 ++++++++++++++++-
 include/linux/usb/gadget.h    |    5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1037,8 +1037,13 @@ static void usb_gadget_state_work(struct
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
 }
 EXPORT_SYMBOL_GPL(usb_gadget_set_state);
 
@@ -1199,6 +1204,8 @@ void usb_initialize_gadget(struct device
 		void (*release)(struct device *dev))
 {
 	dev_set_name(&gadget->dev, "gadget");
+	spin_lock_init(&gadget->state_lock);
+	gadget->teardown = false;
 	INIT_WORK(&gadget->work, usb_gadget_state_work);
 	gadget->dev.parent = parent;
 
@@ -1376,6 +1383,7 @@ static void usb_gadget_remove_driver(str
 void usb_del_gadget(struct usb_gadget *gadget)
 {
 	struct usb_udc *udc = gadget->udc;
+	unsigned long flags;
 
 	if (!udc)
 		return;
@@ -1394,6 +1402,13 @@ void usb_del_gadget(struct usb_gadget *g
 	mutex_unlock(&udc_lock);
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_REMOVE);
+	/*
+	 * Set the teardown flag before flushing the work to prevent new work
+	 * from being scheduled while we are cleaning up.
+	 */
+	spin_lock_irqsave(&gadget->state_lock, flags);
+	gadget->teardown = true;
+	spin_unlock_irqrestore(&gadget->state_lock, flags);
 	flush_work(&gadget->work);
 	device_unregister(&udc->dev);
 	device_del(&gadget->dev);
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -341,6 +341,9 @@ struct usb_gadget_ops {
  * @max_speed: Maximal speed the UDC can handle.  UDC must support this
  *      and all slower speeds.
  * @state: the state we are now (attached, suspended, configured, etc)
+ * @state_lock: Spinlock protecting the `state` and `teardown` members.
+ * @teardown: True if the device is undergoing teardown, used to prevent
+ *	new work from being scheduled during cleanup.
  * @name: Identifies the controller hardware type.  Used in diagnostics
  *	and sometimes configuration.
  * @dev: Driver model state for this abstract device.
@@ -408,6 +411,8 @@ struct usb_gadget {
 	enum usb_device_speed		speed;
 	enum usb_device_speed		max_speed;
 	enum usb_device_state		state;
+	spinlock_t			state_lock;
+	bool				teardown;
 	const char			*name;
 	struct device			dev;
 	unsigned			isoch_delay;


