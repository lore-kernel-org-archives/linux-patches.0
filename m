Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AB62D7DDB;
	Thu, 30 Jul 2026 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424562; cv=none; b=EF13Lo9gnhfUg3aNHTnuL/oeGdg1Usne02bLkwThEo8mG4OX2t4zIYep7vA4vtsX0ZGrvG++0t/IogmEbgtD5HwHgrxqcSG6XscssldO44RINOa3AqZZ/WvseaIvgjlPzd0+9jQjwxbRJSSodK9xHRUQtC1aMZ7/MlL15DM2q/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424562; c=relaxed/simple;
	bh=Mrmt1YECz+6XgoeL+xQwBEKwCC+Z+pqHQF4RCEBSAQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlUl8oShQ+Hc57eZyaD3Bg8SlPVISJmjhjE+6gi3PWwJbBcrNnTT6A7xhbf00kvowV7b+TZbxxS2JP1Wq3SEYGJkkkDl385kkNOofFcNAzbQFvsWBzKAMxGFdvXmTiTJ3k+cviliMrTZqqNpFRewkGMY46fxN6Xpvoh/2FuP+C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfzhyZ6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfzhyZ6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDA71F000E9;
	Thu, 30 Jul 2026 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424560;
	bh=dxXkaoMCGRuloYmAa8AsRMLEZsNA9EaOMPvs7tWt7XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfzhyZ6szai4+27d8vb2ESX712rBxLYqlC6ynaC0Lc8qAXDJznRhBalFVUMXJZcFr
	 211od1rQAb6Rlket3AdMNLlhXxDyuscMzJzHmFwsGLdB5hXWoDzCLPBAdVGryaOMo1
	 sy/huRvj5tYQPYhHu0VIjMQinriO6UmxuqrDTggE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 410/675] media: msi2500: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:12:20 +0200
Message-ID: <20260730141453.846690791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Valery Borovsky <vebohr@gmail.com>

commit 7201c17786a498497bca57752883b90914d405ac upstream.

The vb2 framework hands buffers to the driver via buf_queue() before
calling start_streaming().  If start_streaming() returns an error
without first returning those buffers via vb2_buffer_done(),
vb2_start_streaming() fires WARN_ON(owned_by_drv_count) and the queued
buffers leak.

msi2500_start_streaming() had five error paths that all hit this trap
and were further tangled by ret-overwriting between calls:

  - -ENODEV when the USB device was already disconnected
  - -ERESTARTSYS when mutex_lock_interruptible() was interrupted
  - msi2500_set_usb_adc() failure: ret was silently overwritten by
    the next call (msi2500_isoc_init), so the error was lost entirely
  - msi2500_isoc_init() failure: cleanup_queued_bufs was called, but
    the function then fell through to msi2500_ctrl_msg() and again
    masked the original error by overwriting ret
  - msi2500_ctrl_msg(CMD_START_STREAMING) failure: no cleanup at all,
    leaving isoc URBs submitted with no way for the driver to consume
    them

Consolidate the error paths into a small goto chain.  Every failure
now stops the function, drains the queued-buffer list, and returns
the real error code.  The ctrl_msg failure path also rolls back the
preceding msi2500_isoc_init() via msi2500_isoc_cleanup() before
unlocking and draining.

The cleanup helper takes a vb2_buffer_state argument so that the
start_streaming error paths can pass VB2_BUF_STATE_QUEUED (as
expected by userspace on start_streaming failure) while stop_streaming
keeps its existing VB2_BUF_STATE_ERROR semantics.

This mirrors the uvcvideo fix in commit 4cf3b6fd54eb ("media: uvcvideo:
Return queued buffers on start_streaming() failure").

Fixes: 977e444f59ad ("[media] Mirics MSi3101 SDR Dongle driver")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/msi2500/msi2500.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -541,7 +541,8 @@ static int msi2500_isoc_init(struct msi2
 }
 
 /* Must be called with vb_queue_lock hold */
-static void msi2500_cleanup_queued_bufs(struct msi2500_dev *dev)
+static void msi2500_cleanup_queued_bufs(struct msi2500_dev *dev,
+					enum vb2_buffer_state state)
 {
 	unsigned long flags;
 
@@ -554,7 +555,7 @@ static void msi2500_cleanup_queued_bufs(
 		buf = list_entry(dev->queued_bufs.next,
 				 struct msi2500_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -830,25 +831,40 @@ static int msi2500_start_streaming(struc
 
 	dev_dbg(dev->dev, "\n");
 
-	if (!dev->udev)
-		return -ENODEV;
+	if (!dev->udev) {
+		ret = -ENODEV;
+		goto err_cleanup;
+	}
 
-	if (mutex_lock_interruptible(&dev->v4l2_lock))
-		return -ERESTARTSYS;
+	if (mutex_lock_interruptible(&dev->v4l2_lock)) {
+		ret = -ERESTARTSYS;
+		goto err_cleanup;
+	}
 
 	/* wake-up tuner */
 	v4l2_subdev_call(dev->v4l2_subdev, core, s_power, 1);
 
 	ret = msi2500_set_usb_adc(dev);
+	if (ret)
+		goto err_unlock_cleanup;
 
 	ret = msi2500_isoc_init(dev);
 	if (ret)
-		msi2500_cleanup_queued_bufs(dev);
+		goto err_unlock_cleanup;
 
 	ret = msi2500_ctrl_msg(dev, CMD_START_STREAMING, 0);
+	if (ret)
+		goto err_isoc_cleanup;
 
 	mutex_unlock(&dev->v4l2_lock);
+	return 0;
 
+err_isoc_cleanup:
+	msi2500_isoc_cleanup(dev);
+err_unlock_cleanup:
+	mutex_unlock(&dev->v4l2_lock);
+err_cleanup:
+	msi2500_cleanup_queued_bufs(dev, VB2_BUF_STATE_QUEUED);
 	return ret;
 }
 
@@ -863,7 +879,7 @@ static void msi2500_stop_streaming(struc
 	if (dev->udev)
 		msi2500_isoc_cleanup(dev);
 
-	msi2500_cleanup_queued_bufs(dev);
+	msi2500_cleanup_queued_bufs(dev, VB2_BUF_STATE_ERROR);
 
 	/* according to tests, at least 700us delay is required  */
 	msleep(20);


