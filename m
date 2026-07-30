Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E243F0B0;
	Thu, 30 Jul 2026 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422654; cv=none; b=JoA+6byCSZcil2v89SO6m+PviPBWgJ/Y46n2HNXHlX7X99DbUVCf6iigWRX41MGjdqfUnJStCmPp2P5rfn27X1wH5IkCMcZHAg7E2EsG5yJvj8Rl8kl/tjNW8e3f+zsUN3mcz8t1QERkLv7ao2dsDK7gsg7aPFfDKo7fMq+Hmt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422654; c=relaxed/simple;
	bh=PZx3ldH4CQEOCCso6LAdw7JthbGhKupigerKeow1t6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYst2RYvQy9cuGPTzyVFEAmUSlEYK1xzqu6F+NlLbZNsM91t4VRstFKWt6kO4k5/YdbrjWeHY5sOyfTdchJaFlw8PYK+gTHp9UglPBMVFqRzEMKlaXGf4uVvU1iQfsF8Povc9TqDBL57CUx4cLI4A523j3lY7t4tPRQJxHwecTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4m2n8fK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4m2n8fK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A2A1F000E9;
	Thu, 30 Jul 2026 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422652;
	bh=fpuOhnbPPLqKbkac0nv+Q4aT4Ujxt+3+kFUyqtVBxw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4m2n8fKWC5fSza0ndtI5Mejn9VEhXSexO9psAkFSdmG78HfTwCB9+sEfs42BQFkW
	 MUrKneZxJkl8VOqul1tyNrBZt/fAldLck1LSstEWGUf7YSLJSb4EkeQMLHxqleeDqJ
	 f2qEtGUrlU5PsiokTZDK3ZSIlmthIEHftZL7X9LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 505/744] media: pwc: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:12:58 +0200
Message-ID: <20260730141455.015539975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
@@ -710,11 +710,15 @@ static int start_streaming(struct vb2_qu
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


