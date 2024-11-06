Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194401F4FB9;
	Wed,  6 Nov 2024 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897631; cv=none; b=O4soqNe9GkwIRt7G7hSpvWJEI3b7kEQvDUJVmdgwCp+/waoRwlyJ75YuB/KnYMo/Br4TLYdKWnHqn6NkHbw6MH7aZBcYDcORurcQb84V5Z4gGAnhZX3KOHoL/0SFAIIh/RXHByqD4cUNbb0ikW1aLtIFxFdE/J9zMajgKWo0EkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897631; c=relaxed/simple;
	bh=9fmGBx9B4+fNTG3piPE0Ip+23s8eGt4gio+RHAthawc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdZ6cb8zQ6gEEeoz39QiOwuHO45PSp68Imqr1juG62DADp/+3/OSyqygusicF+NVWmUpdaUix+7/LNGf6N1nBXl6hR1U3PnuITAeL3j+xJ5rOoHRYAB4CWCSOispPUx++Sr4UCnGeetjpaFBSQNxIldE+ylij0VqUlZy1We1CVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMdGOzEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMdGOzEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9B1C4CECD;
	Wed,  6 Nov 2024 12:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897630;
	bh=9fmGBx9B4+fNTG3piPE0Ip+23s8eGt4gio+RHAthawc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMdGOzEJN2158SFffzTZpsap4oaz2m+MAOPpb7AEoxtnXPIAHr+yV70QEyihCWCNo
	 lDGn41kYkfDGvOgp2ztgYmOJNl5rgPadtmqKk5n+RzmywnnFde/xrQ6jRI92YIHMMN
	 UyBSEe5EAgRpgxrK3R2qaGghr+j+R5JdYDY4Po9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcello Sylvester Bauer <marcello.bauer@9elements.com>,
	Marcello Sylvester Bauer <sylv@sylv.io>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/151] usb: gadget: dummy_hcd: Switch to hrtimer transfer scheduler
Date: Wed,  6 Nov 2024 13:04:20 +0100
Message-ID: <20241106120310.828708884@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0953e1b5c0300..dab559d8ee8ca 100644
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
@@ -1301,8 +1301,8 @@ static int dummy_urb_enqueue(
 		urb->error_count = 1;		/* mark as a new urb */
 
 	/* kick the scheduler, it'll do the rest */
-	if (!timer_pending(&dum_hcd->timer))
-		mod_timer(&dum_hcd->timer, jiffies + 1);
+	if (!hrtimer_active(&dum_hcd->timer))
+		hrtimer_start(&dum_hcd->timer, ms_to_ktime(1), HRTIMER_MODE_REL);
 
  done:
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
@@ -1323,7 +1323,7 @@ static int dummy_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	rc = usb_hcd_check_unlink_urb(hcd, urb, status);
 	if (!rc && dum_hcd->rh_state != DUMMY_RH_RUNNING &&
 			!list_empty(&dum_hcd->urbp_list))
-		mod_timer(&dum_hcd->timer, jiffies);
+		hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
 
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 	return rc;
@@ -1777,7 +1777,7 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
  * drivers except that the callbacks are invoked from soft interrupt
  * context.
  */
-static void dummy_timer(struct timer_list *t)
+static enum hrtimer_restart dummy_timer(struct hrtimer *t)
 {
 	struct dummy_hcd	*dum_hcd = from_timer(dum_hcd, t, timer);
 	struct dummy		*dum = dum_hcd->dum;
@@ -1808,8 +1808,6 @@ static void dummy_timer(struct timer_list *t)
 		break;
 	}
 
-	/* FIXME if HZ != 1000 this will probably misbehave ... */
-
 	/* look at each urb queued by the host side driver */
 	spin_lock_irqsave(&dum->lock, flags);
 
@@ -1817,7 +1815,7 @@ static void dummy_timer(struct timer_list *t)
 		dev_err(dummy_dev(dum_hcd),
 				"timer fired with no URBs pending?\n");
 		spin_unlock_irqrestore(&dum->lock, flags);
-		return;
+		return HRTIMER_NORESTART;
 	}
 	dum_hcd->next_frame_urbp = NULL;
 
@@ -1995,10 +1993,12 @@ static void dummy_timer(struct timer_list *t)
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
@@ -2387,7 +2387,7 @@ static int dummy_bus_resume(struct usb_hcd *hcd)
 		dum_hcd->rh_state = DUMMY_RH_RUNNING;
 		set_link_state(dum_hcd);
 		if (!list_empty(&dum_hcd->urbp_list))
-			mod_timer(&dum_hcd->timer, jiffies);
+			hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
 		hcd->state = HC_STATE_RUNNING;
 	}
 	spin_unlock_irq(&dum_hcd->dum->lock);
@@ -2465,7 +2465,8 @@ static DEVICE_ATTR_RO(urbs);
 
 static int dummy_start_ss(struct dummy_hcd *dum_hcd)
 {
-	timer_setup(&dum_hcd->timer, dummy_timer, 0);
+	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	dum_hcd->timer.function = dummy_timer;
 	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 	dum_hcd->stream_en_ep = 0;
 	INIT_LIST_HEAD(&dum_hcd->urbp_list);
@@ -2494,7 +2495,8 @@ static int dummy_start(struct usb_hcd *hcd)
 		return dummy_start_ss(dum_hcd);
 
 	spin_lock_init(&dum_hcd->dum->lock);
-	timer_setup(&dum_hcd->timer, dummy_timer, 0);
+	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	dum_hcd->timer.function = dummy_timer;
 	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 
 	INIT_LIST_HEAD(&dum_hcd->urbp_list);
@@ -2513,8 +2515,11 @@ static int dummy_start(struct usb_hcd *hcd)
 
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



