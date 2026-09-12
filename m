Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA3B2D0C94;
	Sat, 12 Sep 2026 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237747; cv=none; b=R6CyQHvZZH9W7cxybjnjUykxJvH7WqNUPsVkMJulgrfUpdOcH5EPAWYXzS9mBVUUgi6JT0I597ygjgQA1GjzG6rEfcaiXUt6b9j6SCeZQrfQbrIxi22I5NJseTlQQ0dkJx3cpjj1SUcd2NmrzC9ZVXxIC1aLxne5o0fZbOPGJ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237747; c=relaxed/simple;
	bh=tVrrL+8QUigpTasDd62vPzCf3erHdIqzSLbtFTpPn88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfVmpwjMTZV/YKjCO0Viq8MZCOmHD8JVcdgYrZR1Gm+CMFrvUZR7IfF5MX47EZlYjiOYwWEYXnC3TcD/VTurIjuQI0tIK5sfuFfhx6NrWAJcKNLjjGBI9loYBxmaB78Z3Oq66tjY/IEG1zzw3EwIjtiUoyHUy9qcdUUJJMqyPtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI702Byf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI702Byf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8278E1F000FF;
	Sat, 12 Sep 2026 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237745;
	bh=biXHhR3rtsyhiglZP+EfNuaav4o77GFEHtYLc1SFdW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XI702ByfazFS1KaBOMnac/L6u4DoTP1ygkHV/h4wI8JDDWYeulJJJfCxZ7DkANGIh
	 saiMTNUebUz6yni2V/pNPJKw+uCsFVLyz0xTBe924G7jHQDubDqyEaP4Ka+5prcHGN
	 Td3383Uk4CODRP9tGrHR4VNZ0pH/bWnHS2th0EJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Valery Borovsky <vebohr@gmail.com>
Subject: [PATCH 5.15 322/935] media: rtl2832_sdr: use vb2_video_unregister_device() on remove to fix DMA leak
Date: Sat, 12 Sep 2026 08:55:52 +0200
Message-ID: <20260912065534.189734874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

commit dabb047c62668f280998e29117c55e41aabac336 upstream.

rtl2832_sdr_remove() runs on USB disconnect and clears dev->udev to
NULL before any pending streaming teardown has run. When user space
later closes its file descriptor, vb2 calls rtl2832_sdr_stop_streaming()
which in turn calls rtl2832_sdr_free_stream_bufs(). That helper releases
each coherent buffer with:

    usb_free_coherent(dev->udev, dev->buf_size,
                      dev->buf_list[dev->buf_num],
                      dev->dma_addr[dev->buf_num]);

usb_free_coherent() returns immediately when its dev argument is NULL,
so every DMA stream buffer that was live at disconnect is silently
leaked. The URBs allocated in rtl2832_sdr_alloc_urbs() outlive the
device for the same reason.

The rtl2832_sdr driver uses vb2_fop_release() in its file_operations,
so replace video_unregister_device(&dev->vdev) with
vb2_video_unregister_device(&dev->vdev) and move it before clearing
dev->udev. vb2_video_unregister_device() releases the vb2 queue, which
synchronously runs rtl2832_sdr_stop_streaming() if streaming is active,
so URBs and coherent DMA stream buffers are freed while dev->udev is
still valid.

vb2_video_unregister_device() locks vdev->queue->lock (vb_queue_lock)
internally, and stop_streaming() locks v4l2_lock, so the previous outer
mutex_lock(&dev->vb_queue_lock) / mutex_lock(&dev->v4l2_lock) pair
around the unregister sequence would self-deadlock and has been removed.
A short v4l2_lock critical section around dev->udev = NULL remains so
any ioctl path that still holds the file descriptor sees coherent state.

Issue identified by automated review of the INV-003 series at
https://sashiko.dev/

Fixes: 771138920eaf ("[media] rtl2832_sdr: Realtek RTL2832 SDR driver module")
Cc: stable@vger.kernel.org
Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1475,14 +1475,22 @@ static int rtl2832_sdr_remove(struct pla
 
 	dev_dbg(&pdev->dev, "\n");
 
-	mutex_lock(&dev->vb_queue_lock);
+	/*
+	 * vb2_video_unregister_device() releases the vb2 queue, which
+	 * triggers rtl2832_sdr_stop_streaming() if streaming is active.
+	 * stop_streaming() uses dev->udev to free URBs and coherent DMA
+	 * stream buffers via usb_free_coherent(), so it must run before
+	 * dev->udev is cleared. vb2_video_unregister_device() locks
+	 * vb_queue_lock internally and stop_streaming() locks v4l2_lock,
+	 * so neither may be held by the caller.
+	 */
+	v4l2_device_disconnect(&dev->v4l2_dev);
+	vb2_video_unregister_device(&dev->vdev);
+
 	mutex_lock(&dev->v4l2_lock);
-	/* No need to keep the urbs around after disconnection */
 	dev->udev = NULL;
-	v4l2_device_disconnect(&dev->v4l2_dev);
-	video_unregister_device(&dev->vdev);
 	mutex_unlock(&dev->v4l2_lock);
-	mutex_unlock(&dev->vb_queue_lock);
+
 	v4l2_device_put(&dev->v4l2_dev);
 	module_put(pdev->dev.parent->driver->owner);
 


