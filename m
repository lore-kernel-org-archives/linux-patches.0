Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058821E5722;
	Mon, 21 Oct 2024 10:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506837; cv=none; b=FB31OoN44rCBDdczhstfWiAr1hZ1V/wGc3N9u6TWpNZEvfkSioGsI+DzLiw0Ba2bxdentIX+GxP/WYneUkXlZPnGlQqlJhN9xs9TgTDoLdSETqsSUaiK3OQ5TY4zWh3aGsQVSs7r21/fD0VRf51cHVb/uq80x5cZ5W4v1oEeJCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506837; c=relaxed/simple;
	bh=mtH7jSFRFrFmQ5X93f0e0UOY3HB6ohaHh/InaRCUhmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hl21rgFyrz77FOhlrIVw44W15b3A6qOA5ghRo/y9H+Ux2fYjetWjFqZxDOJEYmU9H4+XaLbgnawAMY8CNJ+uNDuPYN0hC4I5M0FGEfIgq4SKaq2Rl6vD+Hbp7fSwXRxHW0fxz9DbaHCDcDm8T/BhjF2W1iu+WsC/0MHuQR3NDKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T18SDIA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T18SDIA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733EDC4CEC3;
	Mon, 21 Oct 2024 10:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506836;
	bh=mtH7jSFRFrFmQ5X93f0e0UOY3HB6ohaHh/InaRCUhmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T18SDIA8/62F4eTWaS2G+dzMNfYJFDXt+1Wvix3vpu1jPW/LLnyUK/teGKgvUsSuT
	 pc/jlMf219FOIrcGLQyzFEij/gqb2ZeFlmTPj/JbAnMKgvQkZJjpgstI6e9au60qZ3
	 NOSvMM7ukHlPfticDzED2dnZTn/LwuqO+0+X5h5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f342ea16c9d06d80b585@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Marcello Sylvester Bauer <sylv@sylv.io>
Subject: [PATCH 6.11 106/135] USB: gadget: dummy-hcd: Fix "task hung" problem
Date: Mon, 21 Oct 2024 12:24:22 +0200
Message-ID: <20241021102303.474641178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 5189df7b8088268012882c220d6aca4e64981348 upstream.

The syzbot fuzzer has been encountering "task hung" problems ever
since the dummy-hcd driver was changed to use hrtimers instead of
regular timers.  It turns out that the problems are caused by a subtle
difference between the timer_pending() and hrtimer_active() APIs.

The changeover blindly replaced the first by the second.  However,
timer_pending() returns True when the timer is queued but not when its
callback is running, whereas hrtimer_active() returns True when the
hrtimer is queued _or_ its callback is running.  This difference
occasionally caused dummy_urb_enqueue() to think that the callback
routine had not yet started when in fact it was almost finished.  As a
result the hrtimer was not restarted, which made it impossible for the
driver to dequeue later the URB that was just enqueued.  This caused
usb_kill_urb() to hang, and things got worse from there.

Since hrtimers have no API for telling when they are queued and the
callback isn't running, the driver must keep track of this for itself.
That's what this patch does, adding a new "timer_pending" flag and
setting or clearing it at the appropriate times.

Reported-by: syzbot+f342ea16c9d06d80b585@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/6709234e.050a0220.3e960.0011.GAE@google.com/
Tested-by: syzbot+f342ea16c9d06d80b585@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: a7f3813e589f ("usb: gadget: dummy_hcd: Switch to hrtimer transfer scheduler")
Cc: Marcello Sylvester Bauer <sylv@sylv.io>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2dab644e-ef87-4de8-ac9a-26f100b2c609@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index 8820d9924448..081ac7683c0b 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -254,6 +254,7 @@ struct dummy_hcd {
 	u32				stream_en_ep;
 	u8				num_stream[30 / 2];
 
+	unsigned			timer_pending:1;
 	unsigned			active:1;
 	unsigned			old_active:1;
 	unsigned			resuming:1;
@@ -1303,9 +1304,11 @@ static int dummy_urb_enqueue(
 		urb->error_count = 1;		/* mark as a new urb */
 
 	/* kick the scheduler, it'll do the rest */
-	if (!hrtimer_active(&dum_hcd->timer))
+	if (!dum_hcd->timer_pending) {
+		dum_hcd->timer_pending = 1;
 		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS),
 				HRTIMER_MODE_REL_SOFT);
+	}
 
  done:
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
@@ -1324,9 +1327,10 @@ static int dummy_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	spin_lock_irqsave(&dum_hcd->dum->lock, flags);
 
 	rc = usb_hcd_check_unlink_urb(hcd, urb, status);
-	if (!rc && dum_hcd->rh_state != DUMMY_RH_RUNNING &&
-			!list_empty(&dum_hcd->urbp_list))
+	if (rc == 0 && !dum_hcd->timer_pending) {
+		dum_hcd->timer_pending = 1;
 		hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL_SOFT);
+	}
 
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 	return rc;
@@ -1813,6 +1817,7 @@ static enum hrtimer_restart dummy_timer(struct hrtimer *t)
 
 	/* look at each urb queued by the host side driver */
 	spin_lock_irqsave(&dum->lock, flags);
+	dum_hcd->timer_pending = 0;
 
 	if (!dum_hcd->udev) {
 		dev_err(dummy_dev(dum_hcd),
@@ -1994,8 +1999,10 @@ static enum hrtimer_restart dummy_timer(struct hrtimer *t)
 	if (list_empty(&dum_hcd->urbp_list)) {
 		usb_put_dev(dum_hcd->udev);
 		dum_hcd->udev = NULL;
-	} else if (dum_hcd->rh_state == DUMMY_RH_RUNNING) {
+	} else if (!dum_hcd->timer_pending &&
+			dum_hcd->rh_state == DUMMY_RH_RUNNING) {
 		/* want a 1 msec delay here */
+		dum_hcd->timer_pending = 1;
 		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS),
 				HRTIMER_MODE_REL_SOFT);
 	}
@@ -2390,8 +2397,10 @@ static int dummy_bus_resume(struct usb_hcd *hcd)
 	} else {
 		dum_hcd->rh_state = DUMMY_RH_RUNNING;
 		set_link_state(dum_hcd);
-		if (!list_empty(&dum_hcd->urbp_list))
+		if (!list_empty(&dum_hcd->urbp_list)) {
+			dum_hcd->timer_pending = 1;
 			hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL_SOFT);
+		}
 		hcd->state = HC_STATE_RUNNING;
 	}
 	spin_unlock_irq(&dum_hcd->dum->lock);
@@ -2522,6 +2531,7 @@ static void dummy_stop(struct usb_hcd *hcd)
 	struct dummy_hcd	*dum_hcd = hcd_to_dummy_hcd(hcd);
 
 	hrtimer_cancel(&dum_hcd->timer);
+	dum_hcd->timer_pending = 0;
 	device_remove_file(dummy_dev(dum_hcd), &dev_attr_urbs);
 	dev_info(dummy_dev(dum_hcd), "stopped\n");
 }
-- 
2.47.0



