Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5865E478E5D;
	Sat, 12 Sep 2026 11:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213848; cv=none; b=Vr5iMSBbX7gOB7xvwCUHcnrcoxmiJJKzp7WcMWBeMb0ua4yPqBghylDJgxYimTLVp6FfM9uWsoTd1mrz02eIsQjxMvag7ipUUTMd398rES3uOWLMOq9PNjKJk/cCJi8P2yxFngcIyokOezVqm1pCiGyI8Vj+dccWWJ3ELIKp7AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213848; c=relaxed/simple;
	bh=LK1N8wZWeTUb+7waJYi9RvZS5jD8Un1Fa0mDcIr9AuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnalYw4VSmylpWd6KYCdpJuZocnY67ctFt+SiJEg2C4jTG05G0UtHDk7/UxO7V1f+7BhupgvXjOW3zUEgUyHtIVfpGKTiQoomni/MMqRGPo3T8NRtJCSH7LGVX6qKQx54RrOW7YPnS4/CTr1MU4mPn3fzmGZPzYzAoTNRtEbJO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsNr1jpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsNr1jpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93011F00893;
	Sat, 12 Sep 2026 11:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213846;
	bh=Kp8wT7L/FX0b5UBoQreWjxRSvbFJZ2k19wrnTf1wWIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsNr1jpZA2Tl6Z/r4E2nl65wngbyMOv8brHjysu3QmifRgBtiZ7nKKmVLEni3BxQb
	 rJUNpV0RU1K63wI1cHO0wEV3wUhhk349IxuV61VFYIkhKhk0UPJMybt6zbSeTU/R4y
	 dDJXl4ml6sPaX0prr74nAPCXKcrQ9aMajZLtX38k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Valery Borovsky <vebohr@gmail.com>
Subject: [PATCH 6.12 0205/1376] media: rtl2832_sdr: use vb2_video_unregister_device() on remove to fix DMA leak
Date: Sat, 12 Sep 2026 08:43:51 +0200
Message-ID: <20260912065612.119192421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1479,14 +1479,22 @@ static void rtl2832_sdr_remove(struct pl
 
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
 }


