Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF45125D8EB;
	Tue, 11 Mar 2025 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705816; cv=none; b=XMhNog/k/g+91LLo4Km2XdmzcZcxHnTltn+dF26VdIKmVi68AMa1PJCKCT7YwJzVbj/86Obxifq3E8onrU8Rnuaw6JyBS97pVjF4izLcDbzBSIlDoASckCrgKychNUXwvgbrP2U7XgDi2WaBMvDWQtOgCv2lU08/WSTu0m14UcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705816; c=relaxed/simple;
	bh=5A8DjUzRA2L5uxeDf0neXh1lv8xoQTI1udVko8Bjh7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI5OJyUMOGZnbc0yZ3sMoVwrgMODFl6UXTQkcYJWv1sDmvZj8YOMYHl0QPuXRFe/XyTDf12NicbBqjaLa7023G8CqJQ4/UWMi94zs4U3lbV38CObuNqgUyHIGsqCn3rUyR9dnGpeWkEY+J2IB7NA4IOhCZPykjOw6osWxGb+1IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCctN/7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCctN/7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D3DC4CEEA;
	Tue, 11 Mar 2025 15:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705816;
	bh=5A8DjUzRA2L5uxeDf0neXh1lv8xoQTI1udVko8Bjh7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCctN/7m7xtEEEZBEVe4iX5ZU8cZtHoEOS1vkgupw4ENKDFIU5SHVFmKNZTdM5gFG
	 MyZF1daFJJeb8tRZTl3KyKY1AMxE60XAUU/laWml+i7IUn4nweQYOura/1oqmRJUf+
	 5XTlI0KN4nwEOQ2qUeK4UHJWX/jZLwIkZvjvH2qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 146/328] media: uvcvideo: Fix event flags in uvc_ctrl_send_events
Date: Tue, 11 Mar 2025 15:58:36 +0100
Message-ID: <20250311145720.709774618@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1400,13 +1400,13 @@ static void uvc_ctrl_send_events(struct
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


