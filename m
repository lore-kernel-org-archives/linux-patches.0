Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4D6270545;
	Thu, 30 Jul 2026 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426096; cv=none; b=slBppdR/YVsB8EShc72EPTDKzeLJydoweAXEmH5cSZ1mbhIntiwbA3zrk1zVOjZ5Jn5cycg4XKFAPJT2kHsNdCP3BYavuBcVX7tPNly4R0oS1KiG6kej5MItP2+R5sSv0KuRaAcBpkrxMPiS+xj+pHJbn/AmJ1G5YIRUiCx2CU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426096; c=relaxed/simple;
	bh=w0PrTGcLbTb5Ls2eqr7Oy/G+QZkTWbOUyCigBHPyKI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uesWenw5AkASlPT/hJuCui9rKY3CY6OvtOidvlZ0GIsMeEE5Q+H49dQg7LnuSWCKqjV5znsnayyeSct+vGniGxXaqyVpwaWrLy/+RYKBzu0rFXi6OR4QXbiCDDiuPDZbX0GPC6ipOpbOF0eUSyPiRniEpUgY8XsYfeqW3lkgmcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKCsACvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKCsACvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D211F000E9;
	Thu, 30 Jul 2026 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426095;
	bh=FPGj/KnT8PpWE1CG1MlMssOavjFNTYq0G/PJDRceIxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKCsACvBX/s+NtRDIX/sUct2BhegPO73c93o+yJkEAc8JLwfGjOH5vqxhRjmPmfMU
	 Lc2m3RytqsGs8X7Jemw8BYD/KRDhmOVrCXNHGm7GlRIXMjWLOSTkZBkyd68MSoj1pY
	 KywzAqRt6OoLLUObJN2K2aPNKHK2xjGx1DtF4LwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 299/602] media: airspy: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:11:31 +0200
Message-ID: <20260730141442.253368082@linuxfoundation.org>
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
@@ -522,11 +522,13 @@ static int airspy_start_streaming(struct
 
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


