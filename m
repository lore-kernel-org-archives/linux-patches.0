Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF44B175A74;
	Tue, 21 Jul 2026 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655553; cv=none; b=A1OhbYDb0tpY4HYl49RPAt5wdA0qtSKHOKFb/r0tMVa1Y0StiLEqsxTBDykCElNQULonHP+oNLZmm0tTLoO/IYJ9BdLNxW0myq/vOrZlkRdDDQHT2WlPq+DFArOO03vvvQCr2sA8uUD1EmSYOOJtrkybZyi/AiNACKm6ha4XrNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655553; c=relaxed/simple;
	bh=HsbHC28rBbaQvtqyOujFzYMFVvctjgpvKLLX3nyH+yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPUVHYMnkjb1mDxSn7gbAw6z941K01sdsmRN/4O38C/ZemhnhCg+xUiNF+lp8pLeRXOpmA5HAiwA7cV1sxs4Wn+cBurh8znVkZiWpb4Z7CDTqzwCo1ymK0f1FR8euw+9nmeuKMVC01OGiRmXM2x39HkDtS65uu7kWqZbuYcWktA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKVMDjof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKVMDjof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6768D1F000E9;
	Tue, 21 Jul 2026 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655551;
	bh=QTQKXDy571mOPrMlUHFbKZQAbC0eJnADZnoM1C+3lJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKVMDjofBxgMCAnDA+hEszS5lCvoTZTReKwutU6aDFCdq3UdD08T4CryE6E0pONTT
	 d2qw6j2xNq+u4vDwl9C+YEW4Hrbh2KtkIo+pOQLXDljq8u/zJzmw2XE/l3DXQD8WWe
	 Xu7ZP2bHbatEGy3Hg/QLEMU/BhPO4QI+v7iHnpmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0010/1611] media: uvcvideo: Fix deadlock if uvc_status_stop is called from async_ctrl.work
Date: Tue, 21 Jul 2026 17:02:06 +0200
Message-ID: <20260721152515.016593096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 6d27f92c54ce28cfbd2a8a479a96d6f4a781b7d2 ]

If a UVC camera has an asynchronous control, uvc_status_stop may be
called from async_ctrl.work:

uvc_ctrl_status_event_work()
    uvc_ctrl_status_event()
        uvc_ctrl_clear_handle()
	    uvc_pm_put()
	        uvc_status_put()
		    uvc_status_stop()
		        cancel_work_sync()

This will cause a deadlock, since cancel_work_sync will wait for
uvc_ctrl_status_event_work to complete before returning.

Fix this by returning early from uvc_status_stop if we are currently in
the work function. flush_status now remains false until uvc_status_start
is called again, ensuring that uvc_ctrl_status_event_work won't resubmit
the URB.

Fixes: a32d9c41bdb8 ("media: uvcvideo: Make power management granular")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/6733bdfb-3e88-479f-8956-ab09c04c433e@linux.dev/
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20260316155823.1855434-1-sean.anderson@linux.dev
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Tested-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_status.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 231cfee8e7c2c4..7de074006c6a96 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -316,6 +316,16 @@ static int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 	if (!dev->int_urb)
 		return 0;
 
+	/*
+	 * If the previous uvc_status_stop() call was from the async work,
+	 * the work may still be running. Wait for it to finish before we submit
+	 * the urb.
+	 */
+	flush_work(&dev->async_ctrl.work);
+
+	/* Clear the flush status if we were previously stopped. */
+	smp_store_release(&dev->flush_status, false);
+
 	return usb_submit_urb(dev->int_urb, flags);
 }
 
@@ -336,6 +346,15 @@ static void uvc_status_stop(struct uvc_device *dev)
 	 */
 	smp_store_release(&dev->flush_status, true);
 
+	/*
+	 * If we are called from the event work function, the URB is guaranteed
+	 * to not be in flight as it has completed and has not been resubmitted.
+	 * There's no need to cancel the work (which would deadlock), or to kill
+	 * the URB.
+	 */
+	if (current_work() == &w->work)
+		return;
+
 	/*
 	 * Cancel any pending asynchronous work. If any status event was queued,
 	 * process it synchronously.
@@ -354,15 +373,6 @@ static void uvc_status_stop(struct uvc_device *dev)
 	 */
 	if (cancel_work_sync(&w->work))
 		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
-
-	/*
-	 * From this point, there are no events on the queue and the status URB
-	 * is dead. No events will be queued until uvc_status_start() is called.
-	 * The barrier is needed to make sure that flush_status is visible to
-	 * uvc_ctrl_status_event_work() when uvc_status_start() will be called
-	 * again.
-	 */
-	smp_store_release(&dev->flush_status, false);
 }
 
 int uvc_status_resume(struct uvc_device *dev)
-- 
2.53.0



