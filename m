Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B45114A605;
	Thu, 13 Feb 2025 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460790; cv=none; b=XQIehoQaTujjbTAgetfU3zKchuaVVCe7RRI0ifZbyrsqDL5tLJa3m4ZqDlkGumVAHBzhgUkDjA3NaVGma7KPAVifJI+zmUdvqTYxBrqEpTq7x2iSy+y8giUPe0ke63CpmpdjUQS1xu+bclTbd8g9QplfpG19rHAPdwQcsVY728Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460790; c=relaxed/simple;
	bh=nHRkZadxVT+ieH4bI0VfRdu5UYxSerubTGv//g6kRiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXl0yX2f6II4SjExW288hDWLg7qcxZA/LpomFSLGCngECku/4i8acDMek/BhAmFm2m5rFurTWYjHBC5odh1ypVNUR8F9JLigjLl/mcJuh0ckdorM8bxqtoMZyS9v/LBMU2/MQ6TUzsaolUrOqiWJ3qfmYduOwUTzgBC2CmTAQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYhEXzIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYhEXzIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB71C4CEE4;
	Thu, 13 Feb 2025 15:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460790;
	bh=nHRkZadxVT+ieH4bI0VfRdu5UYxSerubTGv//g6kRiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYhEXzINe3BNpGXcf0SzvhvXm4p0FXkOi77Tld4DTFykNksJkbGd/EraXLp9bjqY4
	 Wo4JDt7xqfo4Dpc9puJofzDrQnALKmG7JgfWCM0mKR0yGafkVYXkglpV75b7DfBZGR
	 R6i+nDbW/gjj5mc8iFrHqg/CFDQuZOzkXdcxOYUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 214/273] media: uvcvideo: Fix event flags in uvc_ctrl_send_events
Date: Thu, 13 Feb 2025 15:29:46 +0100
Message-ID: <20250213142415.770802346@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ricardo Ribalda <ribalda@chromium.org>

commit c31cffd5ae2c3d7ef21d9008977a9d117ce7a64e upstream.

If there is an event that needs the V4L2_EVENT_CTRL_CH_FLAGS flag, all
the following events will have that flag, regardless if they need it or
not.

This is because we keep using the same variable all the time and we do
not reset its original value.

Cc: stable@vger.kernel.org
Fixes: 805e9b4a06bf ("[media] uvcvideo: Send control change events for slave ctrls when the master changes")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20241114-uvc-roi-v15-1-64cfeb56b6f8@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1626,13 +1626,13 @@ static void uvc_ctrl_send_events(struct
 {
 	struct uvc_control_mapping *mapping;
 	struct uvc_control *ctrl;
-	u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
 	unsigned int i;
 	unsigned int j;
 
 	for (i = 0; i < xctrls_count; ++i) {
-		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
+		u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
 
+		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
 		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
 			/* Notification will be sent from an Interrupt event. */
 			continue;


