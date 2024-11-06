Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918A81EBA12;
	Wed,  6 Nov 2024 12:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897085; cv=none; b=pOjzRmVxpb4vyaUH7J5Nu149Jabavw/7Xza4lLe4w08FMHi+bOVxsEnS0oYAXgM+bPYc5p2dbYaEnMlahvuuNkdKEIw81vxU88syHJza3P3atwUQKVQPDCD9Op9yD0csyBTQZkXO/7bB5LPhUe05/usV+GNzzExQtNXZr69D5vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897085; c=relaxed/simple;
	bh=JjYP8P2LK93XZmkhj2Tro5GpKmTb9plLhVhZl+zprI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVNcOh9NxcCxoOrUC9bUvFpGFZkypTolOcJa0dMQ5MoEJb4Hu8t9xhe4O+6oZjwF7zkqbB7G5GmcKhuoHlyVJuzBWkVhNEecBjmSCir9tyaYSV0i2aWnhOZmGguAItxTsGnFdZmwpPsChiYw8AEbPX2/wjraDczAyluf+irfJz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoAxpadl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoAxpadl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18949C4CED5;
	Wed,  6 Nov 2024 12:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897085;
	bh=JjYP8P2LK93XZmkhj2Tro5GpKmTb9plLhVhZl+zprI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoAxpadlXZr2ip0GEcIPX+FQGf4Z8RZktLq0YH+KeOJs0kAeTn9Cv79lb7APsuBG5
	 UY7nQbembixtFi4JkS9YsAvbxTlkSLTEAi6bb3T40+HaLXRPKBTnW7d795QGE9W1Y1
	 ERWBON2hmsk8aLRkcwbJHzM5Aakxg5qq9oklfTfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcello Sylvester Bauer <marcello.bauer@9elements.com>,
	Marcello Sylvester Bauer <sylv@sylv.io>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/126] usb: gadget: dummy_hcd: Switch to hrtimer transfer scheduler
Date: Wed,  6 Nov 2024 13:04:22 +0100
Message-ID: <20241106120307.745307334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Marcello Sylvester Bauer <sylv@sylv.io>

[ Upstream commit a7f3813e589fd8e2834720829a47b5eb914a9afe ]

The dummy_hcd transfer scheduler assumes that the internal kernel timer
frequency is set to 1000Hz to give a polling interval of 1ms. Reducing
the timer frequency will result in an anti-proportional reduction in
transfer performance. Switch to a hrtimer to decouple this association.

Signed-off-by: Marcello Sylvester Bauer <marcello.bauer@9elements.com>
Signed-off-by: Marcello Sylvester Bauer <sylv@sylv.io>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/57a1c2180ff74661600e010c234d1dbaba1d0d46.1712843963.git.sylv@sylv.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 35 +++++++++++++++++-------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index 899ac9f9c2796..4f9c6e86456fe 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/timer.h>
+#include <linux/hrtimer.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -240,7 +240,7 @@ enum dummy_rh_state {
 struct dummy_hcd {
 	struct dummy			*dum;
 	enum dummy_rh_state		rh_state;
-	struct timer_list		timer;
+	struct hrtimer			timer;
 	u32				port_status;
 	u32				old_status;
 	unsigned long			re_timeout;
@@ -1302,8 +1302,8 @@ static int dummy_urb_enqueue(
 		urb->error_count = 1;		/* mark as a new urb */
 
 	/* kick the scheduler, it'll do the rest */
-	if (!timer_pending(&dum_hcd->timer))
-		mod_timer(&dum_hcd->timer, jiffies + 1);
+	if (!hrtimer_active(&dum_hcd->timer))
+		hrtimer_start(&dum_hcd->timer, ms_to_ktime(1), HRTIMER_MODE_REL);
 
  done:
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
@@ -1324,7 +1324,7 @@ static int dummy_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	rc = usb_hcd_check_unlink_urb(hcd, urb, status);
 	if (!rc && dum_hcd->rh_state != DUMMY_RH_RUNNING &&
 			!list_empty(&dum_hcd->urbp_list))
-		mod_timer(&dum_hcd->timer, jiffies);
+		hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
 
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 	return rc;
@@ -1778,7 +1778,7 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
  * drivers except that the callbacks are invoked from soft interrupt
  * context.
  */
-static void dummy_timer(struct timer_list *t)
+static enum hrtimer_restart dummy_timer(struct hrtimer *t)
 {
 	struct dummy_hcd	*dum_hcd = from_timer(dum_hcd, t, timer);
 	struct dummy		*dum = dum_hcd->dum;
@@ -1809,8 +1809,6 @@ static void dummy_timer(struct timer_list *t)
 		break;
 	}
 
-	/* FIXME if HZ != 1000 this will probably misbehave ... */
-
 	/* look at each urb queued by the host side driver */
 	spin_lock_irqsave(&dum->lock, flags);
 
@@ -1818,7 +1816,7 @@ static void dummy_timer(struct timer_list *t)
 		dev_err(dummy_dev(dum_hcd),
 				"timer fired with no URBs pending?\n");
 		spin_unlock_irqrestore(&dum->lock, flags);
-		return;
+		return HRTIMER_NORESTART;
 	}
 	dum_hcd->next_frame_urbp = NULL;
 
@@ -1996,10 +1994,12 @@ static void dummy_timer(struct timer_list *t)
 		dum_hcd->udev = NULL;
 	} else if (dum_hcd->rh_state == DUMMY_RH_RUNNING) {
 		/* want a 1 msec delay here */
-		mod_timer(&dum_hcd->timer, jiffies + msecs_to_jiffies(1));
+		hrtimer_start(&dum_hcd->timer, ms_to_ktime(1), HRTIMER_MODE_REL);
 	}
 
 	spin_unlock_irqrestore(&dum->lock, flags);
+
+	return HRTIMER_NORESTART;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -2388,7 +2388,7 @@ static int dummy_bus_resume(struct usb_hcd *hcd)
 		dum_hcd->rh_state = DUMMY_RH_RUNNING;
 		set_link_state(dum_hcd);
 		if (!list_empty(&dum_hcd->urbp_list))
-			mod_timer(&dum_hcd->timer, jiffies);
+			hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
 		hcd->state = HC_STATE_RUNNING;
 	}
 	spin_unlock_irq(&dum_hcd->dum->lock);
@@ -2466,7 +2466,8 @@ static DEVICE_ATTR_RO(urbs);
 
 static int dummy_start_ss(struct dummy_hcd *dum_hcd)
 {
-	timer_setup(&dum_hcd->timer, dummy_timer, 0);
+	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	dum_hcd->timer.function = dummy_timer;
 	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 	dum_hcd->stream_en_ep = 0;
 	INIT_LIST_HEAD(&dum_hcd->urbp_list);
@@ -2495,7 +2496,8 @@ static int dummy_start(struct usb_hcd *hcd)
 		return dummy_start_ss(dum_hcd);
 
 	spin_lock_init(&dum_hcd->dum->lock);
-	timer_setup(&dum_hcd->timer, dummy_timer, 0);
+	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	dum_hcd->timer.function = dummy_timer;
 	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 
 	INIT_LIST_HEAD(&dum_hcd->urbp_list);
@@ -2514,8 +2516,11 @@ static int dummy_start(struct usb_hcd *hcd)
 
 static void dummy_stop(struct usb_hcd *hcd)
 {
-	device_remove_file(dummy_dev(hcd_to_dummy_hcd(hcd)), &dev_attr_urbs);
-	dev_info(dummy_dev(hcd_to_dummy_hcd(hcd)), "stopped\n");
+	struct dummy_hcd	*dum_hcd = hcd_to_dummy_hcd(hcd);
+
+	hrtimer_cancel(&dum_hcd->timer);
+	device_remove_file(dummy_dev(dum_hcd), &dev_attr_urbs);
+	dev_info(dummy_dev(dum_hcd), "stopped\n");
 }
 
 /*-------------------------------------------------------------------------*/
-- 
2.43.0



