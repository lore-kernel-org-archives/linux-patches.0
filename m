Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C635BDDB;
	Wed,  8 Apr 2026 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674817; cv=none; b=YEL817ARMeJkST5pnesIEcTORt8yx9tgP2k3WSGzbkvgmOrpppDgef2XxPOOtaoyqZ2hccIXb6xHEQbTJIkpPUOb4s6LiIVdzeuljFCfrI7a3H36RtMH9z48sFCsOTngCA/uIrMn5avYV6Ei8oyvErvnvKaN5rDBc+oSHAUKa6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674817; c=relaxed/simple;
	bh=QmTIiQJTpuYCcXTkdfL3kVLgBdCypttUP0QSbo3ZfbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBrauNz8Uu+llV/0m0oNv2TaXY/cP/WJ9tUaiWUiUhnipfAjq5HZCyEGllJt7GGnws3wG7I90HVr8LRZjEXVc3kvy6wOlg59g4hQLosfP/oOhQWC0lKBNcPO9IG8UhEjOsgIfflKjSG/dMbc5ZDRvp1Z0iKHmCIKtd0ncZnawLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pu8UKGV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pu8UKGV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B7BC19425;
	Wed,  8 Apr 2026 19:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674817;
	bh=QmTIiQJTpuYCcXTkdfL3kVLgBdCypttUP0QSbo3ZfbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pu8UKGV+pPRaYMNhW3wi7XGrEBc37CXeLs5QNuMfSm9zNPqblVqzrZW4OY/TxI44b
	 f0FqZUsFhS4l28eHnWMJmpSfpIWsqYp4ewFStPytuzgF8IyTEDcMb0bbL0k5ELgju1
	 SIzqW6yQseAau5+wEdVHsp3pTA2WHFkFJQxWSJvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Mitchell <mitchell.liam@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.19 212/311] Input: bcm5974 - recover from failed mode switch
Date: Wed,  8 Apr 2026 20:03:32 +0200
Message-ID: <20260408175947.319473593@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


