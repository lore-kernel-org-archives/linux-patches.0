Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C714F4418E4;
	Mon, 17 Aug 2026 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979368; cv=none; b=jCTneMOyLWiSdDamjP2eOKrbLlgLG/f6Y1WogyNxm3eVBdttm2fDgmsc1mnl1C7RWr3t4q1su81J20nc8Kt2Jamf6SNSxQYbZpqmCFz266yclREUqBrIW4n9j14Z4BL0I2kOoNNwC/LIz+EBwcnqtbPlR1N2Quvu+hg8S9B/fF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979368; c=relaxed/simple;
	bh=F32vg73URYTYnXvxAKn4UFfhNAb7GVIKgBS2cM0jtS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3CQRlw8PpNBgY5VCXAAeJNnEbPZulcLSw7hIM+XgoxGQ3nwP6xdj/33vifBDH3ZSa9CfzspI1CuPDxNQAMeK2v/FfKgp55tW6/Q1/VOb4t2JAXmrepNgQxm2D0fw/55KLSVnoe8rHIFEKGcedwb9HGq2yP+yXka3W9V8IFmu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVy5XIrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVy5XIrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD7B1F00A3A;
	Mon, 17 Aug 2026 15:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979363;
	bh=UluDCs3ZEp4fpdLtX/2mOWDpdAH0HOByHkMfy28c3js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVy5XIrTh7bTO1F9pJnsm2zYlshNK8XD94gINJuk3Akgt943ufPl6cwg6nsWv9pgL
	 6Y/IKz56XseY1TTeOFH29f563Zba0djqS7602BKIm3+GkbbGz2gsNbsivKyJPr17Ca
	 T4BZ+vzuhtPtjZxc7g0E7bLYCuajpUNGvd93dKOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 201/609] media: pwc: Return queued buffers on start_streaming() failure
Date: Mon, 17 Aug 2026 15:28:17 +0200
Message-ID: <20260817132550.829956671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


