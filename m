Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6FB33438F;
	Thu, 30 Jul 2026 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426167; cv=none; b=iYq5jA0fdy7vspF8KlC7ccxoPyHqcVdPQpsNeYhNfvkEHZ/cc0WZQwKJk9H2NkZGMGlq2cZUFZVZR8f3DyWL8aPRknOhO205tEF5wSVyfWqavXz7fkQrFrL2twFpb0QMdXW5t+g+0JhucBzPjSUTnhZpeow3yvm17Gp0vvNdKRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426167; c=relaxed/simple;
	bh=RwwFM8tAIPABL6e3mX54oas0lW5kSsc6hHHS76mkgiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmecIdMMudbp3Kh/iF5ySqA1vB2FkBPr411XHsuXgNPGc76b8IHQJFH64iXGhy38L2BdY8iuyx1Ue796nQ/O0lMTt19CGP3PJ+R1UtG9M8Mw7dylAKUvB3nD/PicpM2OpTwIa9tK3+Er4DDdZ90TwayHQiBt31w7kNHH/+ggWds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkhtV2+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkhtV2+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316CF1F000E9;
	Thu, 30 Jul 2026 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426166;
	bh=em+NkrVvDWCM7N3vRG9qZcfb3tBlU9im7XEVT8ISZv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkhtV2+xKXcqtO8hFjZUETvHxjUDQmXzTF5/mF1KRa1vSMOtrz/UTeVWspTfcONW6
	 RTSXViq6LVeiCiBN8OnlFyZM9GdQrvJy05n3CpghnvA/Oq9Dm2TYcnN0XT60wFDj4h
	 VUN02LzRPYY5fUf+OMQFDarnX1XNprfUz3dWsEvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 322/602] media: pwc: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:11:54 +0200
Message-ID: <20260730141442.733523023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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


