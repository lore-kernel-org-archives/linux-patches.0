Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDDA3BB687;
	Mon, 17 Aug 2026 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975737; cv=none; b=tL3LvRhfLhLlFwLL5DI5Pyl6TH8st2oXwRatbUZ/S26V8rubyKdyQ4feBVR3KdN2/r4mlmHgBTjTKGMabZutRP8FKDMQ4Iyg8DpVJoI4HIbp3pp9dQ4hbz2GAVK4uTa3uY4tw3j5t1w5PMx8f954BemPMjEo6X4RoClJ8neli30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975737; c=relaxed/simple;
	bh=lbQEj6LlGnGNkjT4t+Vl9Zf8h5Nd9eOLGY/TSyxZ5E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKJpK3cXhwOsRniz7fFjB9iLKln+6Fmu26a5j7a4TpGSkSLyI17HvEVPApTH+M22nqPnK2qN0yVocFjU+ZlbS3gsQ3AWnVWqUfa3m97lB40C10+pqglym8p0aB0jqUXEQNLoRoAMN6MTQp6NV36lJWHxjuYBFrGUCRU+t6iwkF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBHaBygh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBHaBygh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1FE1F000E9;
	Mon, 17 Aug 2026 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975736;
	bh=8y3xWz0B5UkH1JA4lRpSpquejCRVrHFJ7+VnOHV9Mks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBHaByghOm3TVi+axPtRN+rTvcbxpnkIvFBqUWjA2a27ytDjS1nJcqU9bLagvkIgO
	 v6zTiCVATM5zkttaFPIpEKzY6VqXaz0WdsrCaWeAkRyUy9XOXB3HNHWO/h1lBUwjBU
	 PK5Qo+CMmajTT51l/ff+dNnHtNlW4kp/O5UV+hH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 131/389] media: pwc: Return queued buffers on start_streaming() failure
Date: Mon, 17 Aug 2026 15:29:30 +0200
Message-ID: <20260817132544.268000053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Valery Borovsky <vebohr@gmail.com>

commit 975b2ee20e569d47821e4f6c9761b4664d48a6a4 upstream.

The vb2 framework hands buffers to the driver via buf_queue() before
calling start_streaming().  If start_streaming() returns an error
without first returning those buffers via vb2_buffer_done(),
vb2_start_streaming() fires WARN_ON(owned_by_drv_count) and the queued
buffers leak.

pwc's start_streaming() had two early returns that hit this trap:
-ENODEV when the USB device was already disconnected, and -ERESTARTSYS
when mutex_lock_interruptible() was interrupted by a signal.  Call the
existing pwc_cleanup_queued_bufs() helper with VB2_BUF_STATE_QUEUED
before returning (matching the state already used by the
pwc_isoc_init() error path in the same function).

This mirrors the uvcvideo fix in commit 4cf3b6fd54eb ("media: uvcvideo:
Return queued buffers on start_streaming() failure").

Fixes: ceede9fa8939 ("[media] pwc: Fix locking")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/pwc/pwc-if.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -711,11 +711,15 @@ static int start_streaming(struct vb2_qu
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
 	int r;
 
-	if (!pdev->udev)
+	if (!pdev->udev) {
+		pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_QUEUED);
 		return -ENODEV;
+	}
 
-	if (mutex_lock_interruptible(&pdev->v4l2_lock))
+	if (mutex_lock_interruptible(&pdev->v4l2_lock)) {
+		pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_QUEUED);
 		return -ERESTARTSYS;
+	}
 	/* Turn on camera and set LEDS on */
 	pwc_camera_power(pdev, 1);
 	pwc_set_leds(pdev, leds[0], leds[1]);


