Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4709C446050;
	Thu, 30 Jul 2026 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427745; cv=none; b=tdTN7nolajY/C773JKXPmOuUaYUn5rpnWR1CrvQKhs60uOvYUe6X5/Kcd0t1IVFOiJT3APj538YyihEDA6ocMmsMhoveHnfkIwkpRc9XK3MTYVF7DxKK3r28yrxiSYE9F/TT6Jipu8y6azuNmsJ4rFB1FXll7NdErT8pwIFhJPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427745; c=relaxed/simple;
	bh=ZrdOUj5jPFxBt74eElI54/IsWDzonDSIQ2mRnJ1TByY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfNJ50JPPQs9rhuM/UGcdIkat7OVYf2p9P2+NjwuDx+/k0dsmW78057BoychTtDkMNBPygciFdFqDq2uYhb3JSf9x5oVPsViDPk3oiSl9CtJ3cdmtojJUALotUXC3NcbC38krEWOCT5TNxu3nd0kW6NUqJCtjh4UGnGjQ02qt7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCnf/LQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCnf/LQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B971F000E9;
	Thu, 30 Jul 2026 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427744;
	bh=cALIrXJwFAL26I7GpzQxGcZdJG3RX6iZXVpv1L+9RNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCnf/LQsGZZE6DsNzjCT/mZ6SKB+8d5Rpzu8QawdEJbpHjgQWCZMOrimy3iqvXena
	 NhP4T6fe9E4erl1vQXngzSTjSRmYwoWK5P7lKB994drB7rO5u7jE/6E0YnLksWNvKJ
	 LObuXSdOZp6DIz8VQ+/bN4KmcnD6u/drX9wTVMMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 234/484] media: airspy: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:12:11 +0200
Message-ID: <20260730141428.561636655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


