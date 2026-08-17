Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DEC3B9943;
	Mon, 17 Aug 2026 15:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979333; cv=none; b=X2uIPDJaITaAR9O7nuB/x6ACzD6PMZ2NEnH3GRGy5InkU/GLQuSvj2GzOnOMS2TN7dywt8bRIHGwIoHRyFPyfvuIxVektMgrfN+82Nq+zNSa+uh69zVritXoAU9AIsCb4nzwYfUZ1WX3SnHuuNMJM4OF0NbQtPsGD1e+ajciO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979333; c=relaxed/simple;
	bh=wuZySfYNsDn58PVxb8qIfYlO2i5KX4A9sAvHiJcaI2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc9OCVs74PwQItEEQre3vD+zene19XnwAIRUa0+A3Rp1l1YQ3uO3JPtSJnXm+zFAb0AaFi0AYubmQoPSohKt6Qd8RTs5g2FKHdNW1N2xsruVHyZQ2x7MhU08pUU268tQkgzikwm+sUtoQcpGzFCjpiRW1csPs3NMjwytL6Gd7pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIhsCWUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIhsCWUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1F71F00A3A;
	Mon, 17 Aug 2026 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979332;
	bh=q0HTLkyv2QMSu+budWU23X4LY+hgCreU8sM2OrUTvJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIhsCWUqRxNkIM8wR2ZuTYI8aniiNAGVHw3XyjbBn/ybIVp4wprNIvUHzd2H5R2NU
	 d+K/EPZRDSrjabsEehcm5M2j82orC5HXR6JRCmXULpormONSYPLBJq5aFd2EPZ+LNM
	 sNU/FU2ZinWlAuh9moAe8ZeIJtywQGGYP91Q/JjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 188/609] media: airspy: Return queued buffers on start_streaming() failure
Date: Mon, 17 Aug 2026 15:28:04 +0200
Message-ID: <20260817132550.374396266@linuxfoundation.org>
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

commit 04344d0b4929caa94c0df72f767752aa0935ef5d upstream.

The vb2 framework hands buffers to the driver via buf_queue() before
calling start_streaming().  If start_streaming() returns an error
without first returning those buffers via vb2_buffer_done(),
vb2_start_streaming() fires WARN_ON(owned_by_drv_count) and the queued
buffers leak.

airspy_start_streaming() returned -ENODEV early when the USB device had
been disconnected (s->udev == NULL) without returning any buffers that
buf_queue() had already accepted.  Take v4l2_lock first and jump to the
existing err_clear_bit label, which already drains s->queued_bufs via
vb2_buffer_done(..., VB2_BUF_STATE_QUEUED) before unlocking.

This mirrors the uvcvideo fix in commit 4cf3b6fd54eb ("media: uvcvideo:
Return queued buffers on start_streaming() failure").

Fixes: 634fe5033951 ("[media] airspy: AirSpy SDR driver")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/airspy/airspy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -521,11 +521,13 @@ static int airspy_start_streaming(struct
 
 	dev_dbg(s->dev, "\n");
 
-	if (!s->udev)
-		return -ENODEV;
-
 	mutex_lock(&s->v4l2_lock);
 
+	if (!s->udev) {
+		ret = -ENODEV;
+		goto err_clear_bit;
+	}
+
 	s->sequence = 0;
 
 	set_bit(POWER_ON, &s->flags);


