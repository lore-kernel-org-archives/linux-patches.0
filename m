Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA721DFF4;
	Mon,  1 Apr 2024 16:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990430; cv=none; b=afz6SFpqEvZjqs4tH0gWtJwqyMKAH/9RkE8MCnH4EPTVCkTQT/FoUnpEf93FafD5+XlDqoVuZqXjcXOtB7e0w4iKvBrbAf/WJwX+UvvbBgvn5i8XDvVR1DFTEleZKyYZ/HZSFcIZx7PHu35uhG8CwHQIYrofmqeyDB3JMBgi92E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990430; c=relaxed/simple;
	bh=RDnyKjXVB9gU8Qkxzb+V4S0f65ZDbl7ERoQZP7526oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPaPwMkAIbplkKIgwQuqSXARJh46RL8n5pm0s+RVjfVEQr1knB3sTHV/bYRkoLCwxRYAb2E0xhwMEuX3BnLAvcudFj3BFiQcBkswN4RmoYyrgiJVEGg16GQ9RPYcxoSvF5Y5xXGY3JgWQF6wx3tm+ju476HPXszSml9PJ3wPzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o92jCiK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o92jCiK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41F5C433C7;
	Mon,  1 Apr 2024 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990430;
	bh=RDnyKjXVB9gU8Qkxzb+V4S0f65ZDbl7ERoQZP7526oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o92jCiK20VB1V/Z6bQWX5uVTSVWGjizexkCtTwLzZ2wlH0SKAO+ly+H+dePjPuOu8
	 LWPp0RtIvEBhYbmoKPgWpZEw1+Py7TDvABhfgaNDW5n7kE+6W3xuC5xoAZ54UJ+0E3
	 vs0//ZwS0/lucu37F4g/nzBa+9I5/mJSZtlO9h6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Subject: [PATCH 6.6 351/396] USB: UAS: return ENODEV when submit urbs fail with device not attached
Date: Mon,  1 Apr 2024 17:46:40 +0200
Message-ID: <20240401152558.378554222@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Weitao Wang <WeitaoWang-oc@zhaoxin.com>

commit cd5432c712351a3d5f82512908f5febfca946ca6 upstream.

In the scenario of entering hibernation with udisk in the system, if the
udisk was gone or resume fail in the thaw phase of hibernation. Its state
will be set to NOTATTACHED. At this point, usb_hub_wq was already freezed
and can't not handle disconnect event. Next, in the poweroff phase of
hibernation, SYNCHRONIZE_CACHE SCSI command will be sent to this udisk
when poweroff this scsi device, which will cause uas_submit_urbs to be
called to submit URB for sense/data/cmd pipe. However, these URBs will
submit fail as device was set to NOTATTACHED state. Then, uas_submit_urbs
will return a value SCSI_MLQUEUE_DEVICE_BUSY to the caller. That will lead
the SCSI layer go into an ugly loop and system fail to go into hibernation.

On the other hand, when we specially check for -ENODEV in function
uas_queuecommand_lck, returning DID_ERROR to SCSI layer will cause device
poweroff fail and system shutdown instead of entering hibernation.

To fix this issue, let uas_submit_urbs to return original generic error
when submitting URB failed. At the same time, we need to translate -ENODEV
to DID_NOT_CONNECT for the SCSI layer.

Suggested-by: Oliver Neukum <oneukum@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Link: https://lore.kernel.org/r/20240306180814.4897-1-WeitaoWang-oc@zhaoxin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -533,7 +533,7 @@ static struct urb *uas_alloc_cmd_urb(str
  * daft to me.
  */
 
-static struct urb *uas_submit_sense_urb(struct scsi_cmnd *cmnd, gfp_t gfp)
+static int uas_submit_sense_urb(struct scsi_cmnd *cmnd, gfp_t gfp)
 {
 	struct uas_dev_info *devinfo = cmnd->device->hostdata;
 	struct urb *urb;
@@ -541,30 +541,28 @@ static struct urb *uas_submit_sense_urb(
 
 	urb = uas_alloc_sense_urb(devinfo, gfp, cmnd);
 	if (!urb)
-		return NULL;
+		return -ENOMEM;
 	usb_anchor_urb(urb, &devinfo->sense_urbs);
 	err = usb_submit_urb(urb, gfp);
 	if (err) {
 		usb_unanchor_urb(urb);
 		uas_log_cmd_state(cmnd, "sense submit err", err);
 		usb_free_urb(urb);
-		return NULL;
 	}
-	return urb;
+	return err;
 }
 
 static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 			   struct uas_dev_info *devinfo)
 {
 	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
-	struct urb *urb;
 	int err;
 
 	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
-		urb = uas_submit_sense_urb(cmnd, GFP_ATOMIC);
-		if (!urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+		err = uas_submit_sense_urb(cmnd, GFP_ATOMIC);
+		if (err)
+			return err;
 		cmdinfo->state &= ~SUBMIT_STATUS_URB;
 	}
 
@@ -572,7 +570,7 @@ static int uas_submit_urbs(struct scsi_c
 		cmdinfo->data_in_urb = uas_alloc_data_urb(devinfo, GFP_ATOMIC,
 							cmnd, DMA_FROM_DEVICE);
 		if (!cmdinfo->data_in_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return -ENOMEM;
 		cmdinfo->state &= ~ALLOC_DATA_IN_URB;
 	}
 
@@ -582,7 +580,7 @@ static int uas_submit_urbs(struct scsi_c
 		if (err) {
 			usb_unanchor_urb(cmdinfo->data_in_urb);
 			uas_log_cmd_state(cmnd, "data in submit err", err);
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return err;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_IN_URB;
 		cmdinfo->state |= DATA_IN_URB_INFLIGHT;
@@ -592,7 +590,7 @@ static int uas_submit_urbs(struct scsi_c
 		cmdinfo->data_out_urb = uas_alloc_data_urb(devinfo, GFP_ATOMIC,
 							cmnd, DMA_TO_DEVICE);
 		if (!cmdinfo->data_out_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return -ENOMEM;
 		cmdinfo->state &= ~ALLOC_DATA_OUT_URB;
 	}
 
@@ -602,7 +600,7 @@ static int uas_submit_urbs(struct scsi_c
 		if (err) {
 			usb_unanchor_urb(cmdinfo->data_out_urb);
 			uas_log_cmd_state(cmnd, "data out submit err", err);
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return err;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_OUT_URB;
 		cmdinfo->state |= DATA_OUT_URB_INFLIGHT;
@@ -611,7 +609,7 @@ static int uas_submit_urbs(struct scsi_c
 	if (cmdinfo->state & ALLOC_CMD_URB) {
 		cmdinfo->cmd_urb = uas_alloc_cmd_urb(devinfo, GFP_ATOMIC, cmnd);
 		if (!cmdinfo->cmd_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return -ENOMEM;
 		cmdinfo->state &= ~ALLOC_CMD_URB;
 	}
 
@@ -621,7 +619,7 @@ static int uas_submit_urbs(struct scsi_c
 		if (err) {
 			usb_unanchor_urb(cmdinfo->cmd_urb);
 			uas_log_cmd_state(cmnd, "cmd submit err", err);
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return err;
 		}
 		cmdinfo->cmd_urb = NULL;
 		cmdinfo->state &= ~SUBMIT_CMD_URB;
@@ -698,7 +696,7 @@ static int uas_queuecommand_lck(struct s
 	 * of queueing, no matter how fatal the error
 	 */
 	if (err == -ENODEV) {
-		set_host_byte(cmnd, DID_ERROR);
+		set_host_byte(cmnd, DID_NO_CONNECT);
 		scsi_done(cmnd);
 		goto zombie;
 	}


