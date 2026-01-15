Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FDB3D667D;
	Thu, 15 Jan 2026 17:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499763; cv=none; b=Pt4fatb3mfz1RhXvXt0Vq2u43067/QIfaJAWcja3HWwfH2TVTuw++MYUW5KyNxETyI7NunrgBPYaCowoBm8Z1m4fUrtsci2UMXaa2qVo0te563N6vWyTaCSwBqVMRCEfI6IcSO6rtuWe7M8Jw1XXEAibcWJg5k0Y1HSS+L+c4AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499763; c=relaxed/simple;
	bh=9Km+ZYVrgkIItC4AFjPngdUOnntc20LNHvU0Cjnjsr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTqp+CIJjTzaNDIKRgdqy/85ph4s74ndlXNpJEoyvBrQ9DBAVzEIVguaq9MSKGXPV4iR9zoCFO/qUX5fWy+mRHU8eJd1K3uShgj5sbOuec5y19UpwrM3T4YxYH10CMeaFSOL/4+8LOaKzM180UZfN8mB6zC0lol2aVU2G+YgaWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEQt8Mf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEQt8Mf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405EFC116D0;
	Thu, 15 Jan 2026 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499763;
	bh=9Km+ZYVrgkIItC4AFjPngdUOnntc20LNHvU0Cjnjsr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEQt8Mf/nTywxGWe0RkpPwyUUnJFF8rMLZWRrdPIHDNj2IaOZ7SdpmlplBJG9VIPq
	 W2xqOEpypWw+Hs5QzDM+0Gt8A3HircCpAs/ww8ArIDlXv0KASUP2/VojEm2Ae9UN94
	 gPVRR2EUgW/uYB+Ywx7HYMPKIxXfmdjNVwuyyVJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 308/451] HID: logitech-dj: Remove duplicate error logging
Date: Thu, 15 Jan 2026 17:48:29 +0100
Message-ID: <20260115164242.041166561@linuxfoundation.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit ca389a55d8b2d86a817433bf82e0602b68c4d541 upstream.

logi_dj_recv_query_paired_devices() and logi_dj_recv_switch_to_dj_mode()
both have 2 callers which all log an error if the function fails. Move
the error logging to inside these 2 functions to remove the duplicated
error logging in the callers.

While at it also move the logi_dj_recv_send_report() call error handling
in logi_dj_recv_switch_to_dj_mode() to directly after the call. That call
only fails if the report cannot be found and in that case it does nothing,
so the msleep() is not necessary on failures.

Fixes: 6f20d3261265 ("HID: logitech-dj: Fix error handling in logi_dj_recv_switch_to_dj_mode()")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-dj.c |   56 +++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -755,7 +755,6 @@ static void delayedwork_callback(struct
 	struct dj_workitem workitem;
 	unsigned long flags;
 	int count;
-	int retval;
 
 	dbg_hid("%s\n", __func__);
 
@@ -792,11 +791,7 @@ static void delayedwork_callback(struct
 		logi_dj_recv_destroy_djhid_device(djrcv_dev, &workitem);
 		break;
 	case WORKITEM_TYPE_UNKNOWN:
-		retval = logi_dj_recv_query_paired_devices(djrcv_dev);
-		if (retval) {
-			hid_err(djrcv_dev->hidpp, "%s: logi_dj_recv_query_paired_devices error: %d\n",
-				__func__, retval);
-		}
+		logi_dj_recv_query_paired_devices(djrcv_dev);
 		break;
 	case WORKITEM_TYPE_EMPTY:
 		dbg_hid("%s: device list is empty\n", __func__);
@@ -1173,8 +1168,10 @@ static int logi_dj_recv_query_paired_dev
 
 	djrcv_dev->last_query = jiffies;
 
-	if (djrcv_dev->type != recvr_type_dj)
-		return logi_dj_recv_query_hidpp_devices(djrcv_dev);
+	if (djrcv_dev->type != recvr_type_dj) {
+		retval = logi_dj_recv_query_hidpp_devices(djrcv_dev);
+		goto out;
+	}
 
 	dj_report = kzalloc(sizeof(struct dj_report), GFP_KERNEL);
 	if (!dj_report)
@@ -1184,6 +1181,10 @@ static int logi_dj_recv_query_paired_dev
 	dj_report->report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
 	retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
 	kfree(dj_report);
+out:
+	if (retval < 0)
+		hid_err(djrcv_dev->hidpp, "%s error:%d\n", __func__, retval);
+
 	return retval;
 }
 
@@ -1209,6 +1210,8 @@ static int logi_dj_recv_switch_to_dj_mod
 								(u8)timeout;
 
 		retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
+		if (retval)
+			goto out;
 
 		/*
 		 * Ugly sleep to work around a USB 3.0 bug when the receiver is
@@ -1217,11 +1220,6 @@ static int logi_dj_recv_switch_to_dj_mod
 		 * 50 msec should gives enough time to the receiver to be ready.
 		 */
 		msleep(50);
-
-		if (retval) {
-			kfree(dj_report);
-			return retval;
-		}
 	}
 
 	/*
@@ -1247,7 +1245,12 @@ static int logi_dj_recv_switch_to_dj_mod
 			HIDPP_REPORT_SHORT_LENGTH, HID_OUTPUT_REPORT,
 			HID_REQ_SET_REPORT);
 
+out:
 	kfree(dj_report);
+
+	if (retval < 0)
+		hid_err(hdev, "%s error:%d\n", __func__, retval);
+
 	return retval;
 }
 
@@ -1753,11 +1756,8 @@ static int logi_dj_probe(struct hid_devi
 
 	if (has_hidpp) {
 		retval = logi_dj_recv_switch_to_dj_mode(djrcv_dev, 0);
-		if (retval < 0) {
-			hid_err(hdev, "%s: logi_dj_recv_switch_to_dj_mode returned error:%d\n",
-				__func__, retval);
+		if (retval < 0)
 			goto switch_to_dj_mode_fail;
-		}
 	}
 
 	/* This is enabling the polling urb on the IN endpoint */
@@ -1775,15 +1775,11 @@ static int logi_dj_probe(struct hid_devi
 		spin_lock_irqsave(&djrcv_dev->lock, flags);
 		djrcv_dev->ready = true;
 		spin_unlock_irqrestore(&djrcv_dev->lock, flags);
-		retval = logi_dj_recv_query_paired_devices(djrcv_dev);
-		if (retval < 0) {
-			hid_err(hdev, "%s: logi_dj_recv_query_paired_devices error:%d\n",
-				__func__, retval);
-			/*
-			 * This can happen with a KVM, let the probe succeed,
-			 * logi_dj_recv_queue_unknown_work will retry later.
-			 */
-		}
+		/*
+		 * This can fail with a KVM. Ignore errors to let the probe
+		 * succeed, logi_dj_recv_queue_unknown_work will retry later.
+		 */
+		logi_dj_recv_query_paired_devices(djrcv_dev);
 	}
 
 	return 0;
@@ -1800,18 +1796,12 @@ hid_hw_start_fail:
 #ifdef CONFIG_PM
 static int logi_dj_reset_resume(struct hid_device *hdev)
 {
-	int retval;
 	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
 
 	if (!djrcv_dev || djrcv_dev->hidpp != hdev)
 		return 0;
 
-	retval = logi_dj_recv_switch_to_dj_mode(djrcv_dev, 0);
-	if (retval < 0) {
-		hid_err(hdev, "%s: logi_dj_recv_switch_to_dj_mode returned error:%d\n",
-			__func__, retval);
-	}
-
+	logi_dj_recv_switch_to_dj_mode(djrcv_dev, 0);
 	return 0;
 }
 #endif


