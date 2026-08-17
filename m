Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C3043C07E;
	Mon, 17 Aug 2026 14:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976976; cv=none; b=sw9X4ina5kngFwsOYOkj1u3ihcn6QaZMqB06bc5IMNgtvSp6N1AHNBVTf5O8JdzdAA4nh8eldQtuxFJJzHsaMSyIy0frvmbY8IARpdykgy5waWpGlG9UqSNFWN0ZJlsck4WC/KQgk6kwhzIGrynjqHxWSeXQ023w1nsEkHCY3qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976976; c=relaxed/simple;
	bh=0cvPVD8VC1dLJBQZcyrWeg6OGltu6vp5TUW7eTGrOOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQbVZs0fhxWTn1FxSzhT+HAg16YYKN9gBAHUsNkQl9IqmMsVLo9KAC1SHmdrPIUrAldZnV50hDAMJzL1+3VjC89mR+tlihAjqjM0ROhLkMayjclEQhxo2+CoTLRlcPOsNnuCQYFfkZiXUBooYj7avAzgeeJjdY9ZAoJgdnoHCwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1KLQr+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1KLQr+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7691F000E9;
	Mon, 17 Aug 2026 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976974;
	bh=sTZhuUUl12JLkPMHGfF/HPW5kNOUtOeaJxfEIBI8icY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1KLQr+B+tm9spPTaXtwqEsRiGKTD2iU6f5bTiG8icV5JPBkaPOYudw2tURShPv9W
	 nwGk+tJsKepXl5n2ANLXm7DGrqSnjxfdI7ql0SpaAabfG3KrVYW53g5ymoVRMUVZmB
	 pyrFyl0hooi4DeaOd3o4cM/+dLVTgKabnPo5dU48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 169/456] media: rtl2832_sdr: Return queued buffers on start_streaming() failure
Date: Mon, 17 Aug 2026 15:29:19 +0200
Message-ID: <20260817132546.719395980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valery Borovsky <vebohr@gmail.com>

commit 33ca0aab6f4bd90921fc1395478f38f72c4d19af upstream.

The vb2 framework hands buffers to the driver via buf_queue() before
calling start_streaming().  If start_streaming() returns an error
without first returning those buffers via vb2_buffer_done(),
vb2_start_streaming() fires WARN_ON(owned_by_drv_count) and the queued
buffers leak.

rtl2832_sdr_start_streaming() had multiple error paths that hit this
trap: two direct early returns (-ENODEV, -ERESTARTSYS), plus six
`goto err` paths covering subdev s_power, tuner setup, ADC setup,
stream-buffer allocation, urb allocation, and urb submission failures.
None of them returned the queued buffers.

The original function had no distinct success exit and fell straight
through into the err label, which previously only did mutex_unlock and
"return ret".  Adding queued-buffer cleanup at err must therefore be
paired with an explicit success return; otherwise every successful
start would also drain the buffer queue and kill streaming.  Add that
success return, then add rtl2832_sdr_cleanup_queued_bufs() at the err
label and before each early return.

The cleanup helper takes a vb2_buffer_state argument so that the
start_streaming error paths can pass VB2_BUF_STATE_QUEUED (as
expected by userspace on start_streaming failure) while stop_streaming
keeps its existing VB2_BUF_STATE_ERROR semantics.

This mirrors the uvcvideo fix in commit 4cf3b6fd54eb ("media: uvcvideo:
Return queued buffers on start_streaming() failure").

The err label still does not roll back power_ctrl(), frontend_ctrl(),
the POWER_ON flag, or stream/URB allocations that may have happened
before the failing step.  Those are pre-existing leaks of a different
class and are not addressed here.

Fixes: 771138920eaf ("[media] rtl2832_sdr: Realtek RTL2832 SDR driver module")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -396,7 +396,8 @@ static int rtl2832_sdr_alloc_urbs(struct
 }
 
 /* Must be called with vb_queue_lock hold */
-static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev)
+static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev,
+					    enum vb2_buffer_state state)
 {
 	struct platform_device *pdev = dev->pdev;
 	unsigned long flags;
@@ -410,7 +411,7 @@ static void rtl2832_sdr_cleanup_queued_b
 		buf = list_entry(dev->queued_bufs.next,
 				struct rtl2832_sdr_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -851,11 +852,15 @@ static int rtl2832_sdr_start_streaming(s
 
 	dev_dbg(&pdev->dev, "\n");
 
-	if (!dev->udev)
+	if (!dev->udev) {
+		rtl2832_sdr_cleanup_queued_bufs(dev, VB2_BUF_STATE_QUEUED);
 		return -ENODEV;
+	}
 
-	if (mutex_lock_interruptible(&dev->v4l2_lock))
+	if (mutex_lock_interruptible(&dev->v4l2_lock)) {
+		rtl2832_sdr_cleanup_queued_bufs(dev, VB2_BUF_STATE_QUEUED);
 		return -ERESTARTSYS;
+	}
 
 	if (d->props->power_ctrl)
 		d->props->power_ctrl(d, 1);
@@ -896,7 +901,11 @@ static int rtl2832_sdr_start_streaming(s
 	if (ret)
 		goto err;
 
+	mutex_unlock(&dev->v4l2_lock);
+	return 0;
+
 err:
+	rtl2832_sdr_cleanup_queued_bufs(dev, VB2_BUF_STATE_QUEUED);
 	mutex_unlock(&dev->v4l2_lock);
 
 	return ret;
@@ -916,7 +925,7 @@ static void rtl2832_sdr_stop_streaming(s
 	rtl2832_sdr_kill_urbs(dev);
 	rtl2832_sdr_free_urbs(dev);
 	rtl2832_sdr_free_stream_bufs(dev);
-	rtl2832_sdr_cleanup_queued_bufs(dev);
+	rtl2832_sdr_cleanup_queued_bufs(dev, VB2_BUF_STATE_ERROR);
 	rtl2832_sdr_unset_adc(dev);
 
 	/* sleep tuner */


