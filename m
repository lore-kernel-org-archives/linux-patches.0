Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FCB3D6CA2;
	Wed,  8 Apr 2026 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673287; cv=none; b=SjUqF+qQ19fdoGJCiKEnAKa+uVxzGZRo6YJ89bqbMq0RaA8HbIs61qGf33z8BHrRLqErlpe+HuwnvND/GDchagQUKS1e6KYRSqjyAwJ44xHMLeX+Dc5eRg8RjHyJOhEijykYVEwhHxjJjh0jotzXXtjmQiy8ZtfaQsg/Yue3s5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673287; c=relaxed/simple;
	bh=SI164O9M4+moemikOMcCG7A3QefAKoJMFhsSKCr6ghU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQCkHN5mu7RMk4HdoaGFlSL/JryXY3TXc/cC9bxB0aox9m4RnsQde/pxZS6URvSMPv+RAp2GFVW66+aUJeVKXfp6KGvO+npCA11GvL80KUlavgTNy2mcbyGgeuB3pnxuhOSUgjS4iB7zVkU03K514asjTiKvf2zRFFIoPzRPOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsazPG+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsazPG+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EC0C19421;
	Wed,  8 Apr 2026 18:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673287;
	bh=SI164O9M4+moemikOMcCG7A3QefAKoJMFhsSKCr6ghU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsazPG+a5RNXRRg0JiAq9i+8CmKhjfP43LQ+6Uv72deRN1HZSyU3tgp3sMODYvW/O
	 4TwEJYFb+YHOP+8Kru6+L7MRXOlh3gOzeMqKDSwEdmRMXQYxQwVW0qI8YrJoAgf3AF
	 WtwukuLr/2qkTW7+qPL9f7lDdG4a0rPnh4VJn47U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Mitchell <mitchell.liam@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 173/277] Input: bcm5974 - recover from failed mode switch
Date: Wed,  8 Apr 2026 20:02:38 +0200
Message-ID: <20260408175940.326902050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Mitchell <mitchell.liam@gmail.com>

commit fc1e8a6f129d87c64ac8e58b50d9dfa66217cfda upstream.

Mode switches sent before control response are ignored. This results in
an unresponsive trackpad and "bcm5974: bad trackpad package, length: 8"
repeated in logs.

On receiving unknown 8-byte packets, assume that mode switch was ignored
and schedule an asynchronous mode reset. The reset will switch the
device to normal mode, wait, then switch back to wellspring mode.

Signed-off-by: Liam Mitchell <mitchell.liam@gmail.com>
Link: https://lore.kernel.org/linux-input/CAOQ1CL4+DP1TuLAGNsz5GdFBTHvnTg=5q=Dr2Z1OQc6RXydSYA@mail.gmail.com/
Acked-by: Henrik Rydberg <rydberg@bitmath.org>
Link: https://patch.msgid.link/20260213-bcm5974-reset-v2-1-1837851336b0@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/bcm5974.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -286,6 +286,8 @@ struct bcm5974 {
 	const struct tp_finger *index[MAX_FINGERS];	/* finger index data */
 	struct input_mt_pos pos[MAX_FINGERS];		/* position array */
 	int slots[MAX_FINGERS];				/* slot assignments */
+	struct work_struct mode_reset_work;
+	unsigned long last_mode_reset;
 };
 
 /* trackpad finger block data, le16-aligned */
@@ -696,6 +698,32 @@ static int bcm5974_wellspring_mode(struc
 	return retval;
 }
 
+/*
+ * Mode switches sent before the control response are ignored.
+ * Fixing this state requires switching to normal mode and waiting
+ * about 1ms before switching back to wellspring mode.
+ */
+static void bcm5974_mode_reset_work(struct work_struct *work)
+{
+	struct bcm5974 *dev = container_of(work, struct bcm5974, mode_reset_work);
+	int error;
+
+	guard(mutex)(&dev->pm_mutex);
+	dev->last_mode_reset = jiffies;
+
+	error = bcm5974_wellspring_mode(dev, false);
+	if (error) {
+		dev_err(&dev->intf->dev, "reset to normal mode failed\n");
+		return;
+	}
+
+	fsleep(1000);
+
+	error = bcm5974_wellspring_mode(dev, true);
+	if (error)
+		dev_err(&dev->intf->dev, "mode switch after reset failed\n");
+}
+
 static void bcm5974_irq_button(struct urb *urb)
 {
 	struct bcm5974 *dev = urb->context;
@@ -752,10 +780,20 @@ static void bcm5974_irq_trackpad(struct
 	if (dev->tp_urb->actual_length == 2)
 		goto exit;
 
-	if (report_tp_state(dev, dev->tp_urb->actual_length))
+	if (report_tp_state(dev, dev->tp_urb->actual_length)) {
 		dprintk(1, "bcm5974: bad trackpad package, length: %d\n",
 			dev->tp_urb->actual_length);
 
+		/*
+		 * Receiving a HID packet means we aren't in wellspring mode.
+		 * If we haven't tried a reset in the last second, try now.
+		 */
+		if (dev->tp_urb->actual_length == 8 &&
+		    time_after(jiffies, dev->last_mode_reset + msecs_to_jiffies(1000))) {
+			schedule_work(&dev->mode_reset_work);
+		}
+	}
+
 exit:
 	error = usb_submit_urb(dev->tp_urb, GFP_ATOMIC);
 	if (error)
@@ -906,6 +944,7 @@ static int bcm5974_probe(struct usb_inte
 	dev->intf = iface;
 	dev->input = input_dev;
 	dev->cfg = *cfg;
+	INIT_WORK(&dev->mode_reset_work, bcm5974_mode_reset_work);
 	mutex_init(&dev->pm_mutex);
 
 	/* setup urbs */
@@ -998,6 +1037,7 @@ static void bcm5974_disconnect(struct us
 {
 	struct bcm5974 *dev = usb_get_intfdata(iface);
 
+	disable_work_sync(&dev->mode_reset_work);
 	usb_set_intfdata(iface, NULL);
 
 	input_unregister_device(dev->input);


