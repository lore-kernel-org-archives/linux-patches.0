Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADB321B9C9;
	Mon, 23 Jun 2025 21:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713906; cv=none; b=SnwUZ7XBOBqa1BgqvnAB9UgGg3RwDeCKFKzqi6mOZJ7QQiKG2o24CjVjjCJuslFcMqpPjmOMW5BsNmBEKBZUbU4OsOoFyX/fH5v5qUQt+9H/8BExeiOKJ7BC5l35otv43y3nVxKskXiu61174BTIG8gnoCyQt8/6QlY3FBXpnVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713906; c=relaxed/simple;
	bh=u7axm2GOy8PWxKrTs5bGAx4xfCPpkzs1r0UUPBLMQgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXpoNEobe9xHqT98Rta5clQ+4jzf3kNYqCDhhFFlkdsSBpx22jgT8DP3akuAk4FUTcRE6GSpqj3mKhc+S50dMQBlZ48sojLgIVwH1VYFIofuTOzs96RcvjutxUtfP8yV9AVZwR/Na6Xqny/Ry3dCHbhqniwfkRtJX/yBJgu1iCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNpV/+A8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNpV/+A8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F32C4CEEA;
	Mon, 23 Jun 2025 21:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713906;
	bh=u7axm2GOy8PWxKrTs5bGAx4xfCPpkzs1r0UUPBLMQgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNpV/+A8JtuKVXJU4xPykNCp+QSRBXk500Pc24jAh4yhDBFqJa0ETLir7OJ1uuyW0
	 eFwbg2psljYJTy+Z4fteHNW38NXEt6sKDFzImeZCG2iedpk03BM5qjchXJO3xaNC+J
	 ymrTy6QlL6O22vRDRBTyV+mPfGaSIhBOusKM/+2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 070/414] media: uvcvideo: Send control events for partial succeeds
Date: Mon, 23 Jun 2025 15:03:27 +0200
Message-ID: <20250623130643.823315877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 5c791467aea6277430da5f089b9b6c2a9d8a4af7 upstream.

Today, when we are applying a change to entities A, B. If A succeeds and B
fails the events for A are not sent.

This change changes the code so the events for A are send right after
they happen.

Cc: stable@kernel.org
Fixes: b4012002f3a3 ("[media] uvcvideo: Add support for control events")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250224-uvc-data-backup-v2-2-de993ed9823b@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1689,7 +1689,9 @@ static bool uvc_ctrl_xctrls_has_control(
 }
 
 static void uvc_ctrl_send_events(struct uvc_fh *handle,
-	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
+				 struct uvc_entity *entity,
+				 const struct v4l2_ext_control *xctrls,
+				 unsigned int xctrls_count)
 {
 	struct uvc_control_mapping *mapping;
 	struct uvc_control *ctrl;
@@ -1700,6 +1702,9 @@ static void uvc_ctrl_send_events(struct
 		u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
 
 		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
+		if (ctrl->entity != entity)
+			continue;
+
 		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
 			/* Notification will be sent from an Interrupt event. */
 			continue;
@@ -1938,11 +1943,12 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 					uvc_ctrl_find_ctrl_idx(entity, ctrls,
 							       err_ctrl);
 			goto done;
+		} else if (ret > 0 && !rollback) {
+			uvc_ctrl_send_events(handle, entity,
+					     ctrls->controls, ctrls->count);
 		}
 	}
 
-	if (!rollback)
-		uvc_ctrl_send_events(handle, ctrls->controls, ctrls->count);
 	ret = 0;
 done:
 	mutex_unlock(&chain->ctrl_mutex);


