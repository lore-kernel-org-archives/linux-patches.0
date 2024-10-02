Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467AE1CF7D4;
	Wed,  2 Oct 2024 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878767; cv=none; b=u+CpZpCzkF45o2tIzGi4s76MOXvj6B4oHLU34rK3OmMc5D4IydJXJVLTueET7UlsdD2315woxQ1G9/JMIRhPueLlV/0oVaSR1v1rEXcNXuiJKr6jhbZzMfSWOfsrf/WH2vsBFmNQXHh4MYAQtx/qLamS25b4XdyScIH+LUf2Z3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878767; c=relaxed/simple;
	bh=YHv3TFC4qpVdrTs79ljA0nKbW5z+RyrpinTUITLVLp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No1Kf4w9j/4b1sRhf70jfI6FL2Z3jru+27T+01BL/Khh+k3HLXoWsyr+eNxjjjXIturXgFAN+6+SJyEKYa1HWs4BjlltXMwkvuxX6duWVit4rXK/z5wQ5iOq+X4slGn27WPKy2+Gl6AzjRwRVNpKChfAgxXk153B1UDR1a49sA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgSHJuwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgSHJuwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D71C4CEC2;
	Wed,  2 Oct 2024 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878767;
	bh=YHv3TFC4qpVdrTs79ljA0nKbW5z+RyrpinTUITLVLp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgSHJuwHVrfEZM6m8RwXQBvHkBv7AXqEATHDRCg10ZnxP5NJVK6ZisTwKlFlF0lef
	 Lrk31jGNfo8X/pXbIJyN/TC8lJdfBbpAigmlo0NGuTYsLOAHFJuJ2VEL/pdvTXwrGa
	 u5pdfMz9P+RtAQu5gvbTZSFVNGGyoQlYr9uLtfnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2388cdaeb6b10f0c13ac@syzkaller.appspotmail.com,
	syzbot+17ca2339e34a1d863aad@syzkaller.appspotmail.com,
	syzbot+c793a7eca38803212c61@syzkaller.appspotmail.com,
	syzbot+1e6e0b916b211bee1bd6@syzkaller.appspotmail.com,
	kernel test robot <oliver.sang@intel.com>,
	Marcello Sylvester Bauer <sylv@sylv.io>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	syzbot+edd9fe0d3a65b14588d5@syzkaller.appspotmail.com
Subject: [PATCH 6.10 525/634] usb: gadget: dummy_hcd: execute hrtimer callback in softirq context
Date: Wed,  2 Oct 2024 15:00:25 +0200
Message-ID: <20241002125831.827738540@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@gmail.com>

commit 9313d139aa25e572d860f6f673b73a20f32d7f93 upstream.

Commit a7f3813e589f ("usb: gadget: dummy_hcd: Switch to hrtimer transfer
scheduler") switched dummy_hcd to use hrtimer and made the timer's
callback be executed in the hardirq context.

With that change, __usb_hcd_giveback_urb now gets executed in the hardirq
context, which causes problems for KCOV and KMSAN.

One problem is that KCOV now is unable to collect coverage from
the USB code that gets executed from the dummy_hcd's timer callback,
as KCOV cannot collect coverage in the hardirq context.

Another problem is that the dummy_hcd hrtimer might get triggered in the
middle of a softirq with KCOV remote coverage collection enabled, and that
causes a WARNING in KCOV, as reported by syzbot. (I sent a separate patch
to shut down this WARNING, but that doesn't fix the other two issues.)

Finally, KMSAN appears to ignore tracking memory copying operations
that happen in the hardirq context, which causes false positive
kernel-infoleaks, as reported by syzbot.

Change the hrtimer in dummy_hcd to execute the callback in the softirq
context.

Reported-by: syzbot+2388cdaeb6b10f0c13ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2388cdaeb6b10f0c13ac
Reported-by: syzbot+17ca2339e34a1d863aad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=17ca2339e34a1d863aad
Reported-by: syzbot+c793a7eca38803212c61@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c793a7eca38803212c61
Reported-by: syzbot+1e6e0b916b211bee1bd6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1e6e0b916b211bee1bd6
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202406141323.413a90d2-lkp@intel.com
Fixes: a7f3813e589f ("usb: gadget: dummy_hcd: Switch to hrtimer transfer scheduler")
Cc: stable@vger.kernel.org
Acked-by: Marcello Sylvester Bauer <sylv@sylv.io>
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: syzbot+edd9fe0d3a65b14588d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=edd9fe0d3a65b14588d5
Link: https://lore.kernel.org/r/20240904013051.4409-1-andrey.konovalov@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index f37b0d8386c1..ff7bee78bcc4 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -1304,7 +1304,8 @@ static int dummy_urb_enqueue(
 
 	/* kick the scheduler, it'll do the rest */
 	if (!hrtimer_active(&dum_hcd->timer))
-		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS), HRTIMER_MODE_REL);
+		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS),
+				HRTIMER_MODE_REL_SOFT);
 
  done:
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
@@ -1325,7 +1326,7 @@ static int dummy_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	rc = usb_hcd_check_unlink_urb(hcd, urb, status);
 	if (!rc && dum_hcd->rh_state != DUMMY_RH_RUNNING &&
 			!list_empty(&dum_hcd->urbp_list))
-		hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
+		hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL_SOFT);
 
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
 	return rc;
@@ -1995,7 +1996,8 @@ static enum hrtimer_restart dummy_timer(struct hrtimer *t)
 		dum_hcd->udev = NULL;
 	} else if (dum_hcd->rh_state == DUMMY_RH_RUNNING) {
 		/* want a 1 msec delay here */
-		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS), HRTIMER_MODE_REL);
+		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS),
+				HRTIMER_MODE_REL_SOFT);
 	}
 
 	spin_unlock_irqrestore(&dum->lock, flags);
@@ -2389,7 +2391,7 @@ static int dummy_bus_resume(struct usb_hcd *hcd)
 		dum_hcd->rh_state = DUMMY_RH_RUNNING;
 		set_link_state(dum_hcd);
 		if (!list_empty(&dum_hcd->urbp_list))
-			hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
+			hrtimer_start(&dum_hcd->timer, ns_to_ktime(0), HRTIMER_MODE_REL_SOFT);
 		hcd->state = HC_STATE_RUNNING;
 	}
 	spin_unlock_irq(&dum_hcd->dum->lock);
@@ -2467,7 +2469,7 @@ static DEVICE_ATTR_RO(urbs);
 
 static int dummy_start_ss(struct dummy_hcd *dum_hcd)
 {
-	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	dum_hcd->timer.function = dummy_timer;
 	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 	dum_hcd->stream_en_ep = 0;
@@ -2497,7 +2499,7 @@ static int dummy_start(struct usb_hcd *hcd)
 		return dummy_start_ss(dum_hcd);
 
 	spin_lock_init(&dum_hcd->dum->lock);
-	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init(&dum_hcd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	dum_hcd->timer.function = dummy_timer;
 	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 
-- 
2.46.2



