Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0504583ABB;
	Wed,  9 Sep 2026 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964131; cv=none; b=b18qcpz8LnS/FmHcXfzX/u01icYQCePCwSFgXQf9a//Upe0BQ/yT5W4uX/mBhboD6zu+EbGT3H/y++VAj9rUtqagZuPOjMocGmx9ezmv8e2Iw8lqMU50/fQ//XyA8t9m56j+Xv7aIMaRcyPi3g4JSUtFe1YgJ8FPZ14e17phN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964131; c=relaxed/simple;
	bh=H+fkDJMJAXNwzCtuP1bu/hfiSISeBs/pJyOeQ+C3YAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgSAOSRUfHt9L1iKSHiqDiGWd2Yc8VpVjOc1faKLkbujyIjFk29qcq5XgbNrJkfuJxLqcgP5TwxHUkkyHnv0V6cm5wKuQ8O0oPCkf+LnOTcw0MwmXTEV0Pf30lXjTZUKNrgeCMn7KlpZAcPyhWj1e77Zn4wHdw0rqXrqIb4JKgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nv/n/XaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nv/n/XaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99D61F00A3A;
	Wed,  9 Sep 2026 14:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964130;
	bh=cHJDtoSBCKGA8KNn3floBJH9mNIuU2T1mciZuHRbhyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nv/n/XaS0tCPVedc4ftEkXm3rcQWrWbcllerdinHxgF87s76dK+WXFl+rpCMhC4lj
	 AnN2CFNZXBkNilhQB+z1jvTk7hQubUqGehviIs3oXHakyQAXWdcvXt8Zp/aQd7SYjU
	 Bw+aZnm5+IV+u0yHjsNEXO+vAYU98CqJu5eTjwCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Valery Borovsky <vebohr@gmail.com>
Subject: [PATCH 6.18 274/583] media: airspy: use vb2_video_unregister_device() on disconnect to fix NULL deref
Date: Wed,  9 Sep 2026 15:39:19 +0200
Message-ID: <20260909134247.568940752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

commit 2f378dc45e685fc825d2dd08e7864666d6fcc009 upstream.

airspy_disconnect() clears s->udev under v4l2_lock, but
airspy_stop_streaming() unconditionally calls airspy_ctrl_msg() and
airspy_free_stream_bufs() afterwards. If a streaming user closes the
device after disconnect, stop_streaming() runs and dereferences the
NULL s->udev:

  airspy_stop_streaming()
    airspy_ctrl_msg(s, CMD_RECEIVER_MODE, 0, 0, NULL, 0)
      usb_sndctrlpipe(s->udev, 0)         /* NULL deref */
    airspy_free_stream_bufs(s)
      usb_free_coherent(s->udev, ...)     /* NULL deref */

The airspy driver uses vb2_fop_release() in its file_operations, so
replace video_unregister_device(&s->vdev) with
vb2_video_unregister_device(&s->vdev) and move it before clearing
s->udev. vb2_video_unregister_device() releases the vb2 queue, which
synchronously runs airspy_stop_streaming() if streaming is active, so
the URBs, coherent DMA stream buffers and the hardware stop control
message all execute while s->udev is still valid.

vb2_video_unregister_device() locks vdev->queue->lock (vb_queue_lock)
internally, and stop_streaming() locks v4l2_lock, so the previous outer
mutex_lock(&s->vb_queue_lock) / mutex_lock(&s->v4l2_lock) pair around
the unregister sequence would self-deadlock and has been removed. A
short v4l2_lock critical section around s->udev = NULL remains so any
ioctl path that still holds the file descriptor sees coherent state.

Issue identified by automated review of the INV-003 series at
https://sashiko.dev/

Fixes: 634fe5033951 ("[media] airspy: AirSpy SDR driver")
Cc: stable@vger.kernel.org
Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/airspy/airspy.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -464,14 +464,21 @@ static void airspy_disconnect(struct usb
 
 	dev_dbg(s->dev, "\n");
 
-	mutex_lock(&s->vb_queue_lock);
+	/*
+	 * vb2_video_unregister_device() releases the vb2 queue, which
+	 * triggers airspy_stop_streaming() if streaming is active.
+	 * stop_streaming() dereferences s->udev via airspy_ctrl_msg() and
+	 * airspy_free_stream_bufs(), so it must run before s->udev is
+	 * cleared. vb2_video_unregister_device() locks vb_queue_lock
+	 * internally and stop_streaming() locks v4l2_lock, so neither may
+	 * be held by the caller.
+	 */
+	v4l2_device_disconnect(&s->v4l2_dev);
+	vb2_video_unregister_device(&s->vdev);
+
 	mutex_lock(&s->v4l2_lock);
-	/* No need to keep the urbs around after disconnection */
 	s->udev = NULL;
-	v4l2_device_disconnect(&s->v4l2_dev);
-	video_unregister_device(&s->vdev);
 	mutex_unlock(&s->v4l2_lock);
-	mutex_unlock(&s->vb_queue_lock);
 
 	v4l2_device_put(&s->v4l2_dev);
 }


