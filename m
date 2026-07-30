Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8BB3C1D70;
	Thu, 30 Jul 2026 15:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424442; cv=none; b=VmEAHQV0TUchRAv1C2JDC9yyZVaWrxlu8jiRsOUkurQcSpLjaY+EVX9DobSgyC6mYvLJOTt6oOQ7Bj+yZ8/TraPBaJJJGBN65mhv4wXYpoSzAzIQTy+hyXU6m8cocozVrnJ5aYqsQpLMy6KQrFX6spUHLKBYUXizVSC18mp9i90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424442; c=relaxed/simple;
	bh=4MDKwNtEeTGff+SFX5pT4wiv00vBMZR5sYXUl95xDoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfcOj8JyRSB5f3nh+GhgPBMK0iCfurOVtad3Vgf+RkFpvscI+NhW1Mh6TARqkXl7gHODkWZLb+yiw/TugiuPH6CbnNo/i17H72hqwOujMhTS1MDxCBN1xx7Y9K4f/fQn4/nwUy3wjDta1yHoxF2ZSjd2BPC6gD5AkhkJoENHeuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mr/PNecJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mr/PNecJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34911F000E9;
	Thu, 30 Jul 2026 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424441;
	bh=v3ZSbJvn7JDvWo44t+M+2cgFrkEHm3BH1APLw+wF4s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mr/PNecJzozCt1w4jDmUD91Y8CLfRdp2puUfFRAhY2vVSqRBBuhlSH0PwCyVQ3Qfy
	 Ku9fofUwtCa8gLWqT8LuB0847Ut43lZy+ZeORUHdAsU/esngtF08FQHIFkLQ+VUj7f
	 mxFshAeP0SJwjXATGc6lCa1UpJkIhPD3REuhGu0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 394/675] media: airspy: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:12:04 +0200
Message-ID: <20260730141453.508014244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


