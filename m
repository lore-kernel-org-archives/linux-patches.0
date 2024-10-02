Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E3616F84F;
	Wed,  2 Oct 2024 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876843; cv=none; b=jYIDmEnlsx/1aKSPIMFNbLBW4fATTgDVnZtEGJ0WyHDiho4BIyc/K0aAvEUB9xxKhL2TRClfl6RVWmu/I8gi7YtL+1LQaX0Q66Ouhngkej8rvzlR6tM6FBcdKN28rGB1KghCrVWXksMk2ONByF8wZhgehS4PdXZWo3fpU4jeXRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876843; c=relaxed/simple;
	bh=ddFNt9QY2sTWiUAV21ynwUmSsJ5wuyRHsYiWYZxS+SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCkT5jpJGW+gkzwQnNSzfLot0TPQ3x4O9OlScJLAmfI9fOXqTcucvAwBgAuanUIcHYARkjPo4PXsMXCPqKjnAjYD46lmJ+voN0oMcvq9eeO2azbNOipPLVRMTqcvrenbWe0MOgzTtt0mgbdaKzUyveyckj5Xybr+eFO02XWF5ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glFIDAhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glFIDAhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705AFC4CEC2;
	Wed,  2 Oct 2024 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876842;
	bh=ddFNt9QY2sTWiUAV21ynwUmSsJ5wuyRHsYiWYZxS+SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glFIDAhGgwC/jjmYA5K0UpWjqgevtJ96JRB3ydN09LtS0xIAeihgG+OOwZFj5jxeE
	 gBxc6HutkRmWiVWCUUG1zJbsl9L9nFTH3pk3aPoD36pX2tW1oz1pGDwKJRBMuFOYUp
	 YXyOjUxb/lb3t1hEDSOmt7EfvmdCEmf5Cg0aqseA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.11 578/695] usbnet: fix cyclical race on disconnect with work queue
Date: Wed,  2 Oct 2024 14:59:36 +0200
Message-ID: <20241002125845.584354947@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 04e906839a053f092ef53f4fb2d610983412b904 upstream.

The work can submit URBs and the URBs can schedule the work.
This cycle needs to be broken, when a device is to be stopped.
Use a flag to do so.
This is a design issue as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/20240919123525.688065-1-oneukum@suse.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c   |   37 ++++++++++++++++++++++++++++---------
 include/linux/usb/usbnet.h |   15 +++++++++++++++
 2 files changed, 43 insertions(+), 9 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -464,10 +464,15 @@ static enum skb_state defer_bh(struct us
 void usbnet_defer_kevent (struct usbnet *dev, int work)
 {
 	set_bit (work, &dev->flags);
-	if (!schedule_work (&dev->kevent))
-		netdev_dbg(dev->net, "kevent %s may have been dropped\n", usbnet_event_names[work]);
-	else
-		netdev_dbg(dev->net, "kevent %s scheduled\n", usbnet_event_names[work]);
+	if (!usbnet_going_away(dev)) {
+		if (!schedule_work(&dev->kevent))
+			netdev_dbg(dev->net,
+				   "kevent %s may have been dropped\n",
+				   usbnet_event_names[work]);
+		else
+			netdev_dbg(dev->net,
+				   "kevent %s scheduled\n", usbnet_event_names[work]);
+	}
 }
 EXPORT_SYMBOL_GPL(usbnet_defer_kevent);
 
@@ -535,7 +540,8 @@ static int rx_submit (struct usbnet *dev
 			tasklet_schedule (&dev->bh);
 			break;
 		case 0:
-			__usbnet_queue_skb(&dev->rxq, skb, rx_start);
+			if (!usbnet_going_away(dev))
+				__usbnet_queue_skb(&dev->rxq, skb, rx_start);
 		}
 	} else {
 		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");
@@ -843,9 +849,18 @@ int usbnet_stop (struct net_device *net)
 
 	/* deferred work (timer, softirq, task) must also stop */
 	dev->flags = 0;
-	del_timer_sync (&dev->delay);
-	tasklet_kill (&dev->bh);
+	del_timer_sync(&dev->delay);
+	tasklet_kill(&dev->bh);
 	cancel_work_sync(&dev->kevent);
+
+	/* We have cyclic dependencies. Those calls are needed
+	 * to break a cycle. We cannot fall into the gaps because
+	 * we have a flag
+	 */
+	tasklet_kill(&dev->bh);
+	del_timer_sync(&dev->delay);
+	cancel_work_sync(&dev->kevent);
+
 	if (!pm)
 		usb_autopm_put_interface(dev->intf);
 
@@ -1171,7 +1186,8 @@ fail_halt:
 					   status);
 		} else {
 			clear_bit (EVENT_RX_HALT, &dev->flags);
-			tasklet_schedule (&dev->bh);
+			if (!usbnet_going_away(dev))
+				tasklet_schedule(&dev->bh);
 		}
 	}
 
@@ -1196,7 +1212,8 @@ fail_halt:
 			usb_autopm_put_interface(dev->intf);
 fail_lowmem:
 			if (resched)
-				tasklet_schedule (&dev->bh);
+				if (!usbnet_going_away(dev))
+					tasklet_schedule(&dev->bh);
 		}
 	}
 
@@ -1559,6 +1576,7 @@ static void usbnet_bh (struct timer_list
 	} else if (netif_running (dev->net) &&
 		   netif_device_present (dev->net) &&
 		   netif_carrier_ok(dev->net) &&
+		   !usbnet_going_away(dev) &&
 		   !timer_pending(&dev->delay) &&
 		   !test_bit(EVENT_RX_PAUSED, &dev->flags) &&
 		   !test_bit(EVENT_RX_HALT, &dev->flags)) {
@@ -1606,6 +1624,7 @@ void usbnet_disconnect (struct usb_inter
 	usb_set_intfdata(intf, NULL);
 	if (!dev)
 		return;
+	usbnet_mark_going_away(dev);
 
 	xdev = interface_to_usbdev (intf);
 
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -76,8 +76,23 @@ struct usbnet {
 #		define EVENT_LINK_CHANGE	11
 #		define EVENT_SET_RX_MODE	12
 #		define EVENT_NO_IP_ALIGN	13
+/* This one is special, as it indicates that the device is going away
+ * there are cyclic dependencies between tasklet, timer and bh
+ * that must be broken
+ */
+#		define EVENT_UNPLUG		31
 };
 
+static inline bool usbnet_going_away(struct usbnet *ubn)
+{
+	return test_bit(EVENT_UNPLUG, &ubn->flags);
+}
+
+static inline void usbnet_mark_going_away(struct usbnet *ubn)
+{
+	set_bit(EVENT_UNPLUG, &ubn->flags);
+}
+
 static inline struct usb_driver *driver_of(struct usb_interface *intf)
 {
 	return to_usb_driver(intf->dev.driver);


