Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7D846AA9E;
	Tue, 21 Jul 2026 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648022; cv=none; b=OF9XHJOGRN7GePRJ9k2Ood2+mPGYbg7wmc3WYcEZIXFPdqXVw6dHMwRYHWHBbArziNg1bFg7SRddfCmPsq2A73fGWA2/Z4nt41Jnt3FGl+owVjtYIozql8gUO5i7rsO8lmQIgMXL+qlpGnX2bH6BWG8YyazXXrZoCU1o/JMNXCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648022; c=relaxed/simple;
	bh=I4DTykokFs/8+13u/MkCXP2Bsp9r+it7V+w9uDfeEkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQ95pw36kr+SVtLN1euTKcgic8PpTjx5jyFFs9s2ehPJrLnu97sAyJH0p+nceJs/6XXkOm1AYDIPhN6V5A+5Ya39UfWKK4hTOTF2lix1I4E85d45xTOWpARahj+CrAFh27glJfH0Ht/aDZiSg/PzMNOheQNh4JjDhj/EHmh6TiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD/gJjGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD/gJjGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7F61F000E9;
	Tue, 21 Jul 2026 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648020;
	bh=nthtbsFAfFI3rUT3Yq5CHobEjtb9EEQjaN8DPMA/6sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OD/gJjGKWsLXZcySC0WK6hW+7vtE1sgvV1piemy39MSXtJ823cuqmwq7lPueJjOL9
	 OiOACFlf1RH3Chv0WT3L6xHB9VdF9nxLnSv67PiHccFdqw/Ok45bJVUm/B28/15VcT
	 V9y2+wT66+4SM7P48fNBj3kFtF3FWPP04YfvyAJs=
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
Subject: [PATCH 7.1 0004/2077] media: uvcvideo: Fix deadlock if uvc_status_stop is called from async_ctrl.work
Date: Tue, 21 Jul 2026 16:54:37 +0200
Message-ID: <20260721152552.765382316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 65f5356bebb399..b632cf5e3fe9b2 100644
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



