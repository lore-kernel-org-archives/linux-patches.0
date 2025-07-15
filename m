Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F67F2E6D00;
	Tue, 15 Jul 2025 13:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586581; cv=none; b=JsQ8PMgkj+xz+oUfNibFWqJOepxKFc41B9T/SJpyT3Bcx51OTYmtE8mtnBwxFTBDTdia9TNhVFo/Alx3yjLhwMdlM8qxvwZX4QNgxJi/ojJ3sZW5WtvXb4LUCBQVYZhKl3UWnwpg0Y1hry0ccXr3D1fuR8hvcR/7UnF6Nfug3+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586581; c=relaxed/simple;
	bh=hTv0fmezGX/yC51bRjlZc5fINWT7TlR1Q41AW19DTnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g90N5TpjTD+3rrZllpxLFiy3cZNxdj7MbRXL+1GFgS0MGF54dwnZHD6pu417f00f9+MBVUhkOB+Rk4TLRJB9sqRobPxCVOgnVua3SEK7K2ZtYIbNNj/ShndamODmKFio0PkdgJ7XzUPudU7beUGJh2GGtAuE+Lu0yiFus57Rijs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WD80Ka+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WD80Ka+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63BBC4CEE3;
	Tue, 15 Jul 2025 13:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586581;
	bh=hTv0fmezGX/yC51bRjlZc5fINWT7TlR1Q41AW19DTnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WD80Ka+GVvYMQA7UJ+FacTAroxjefpaqZlTfq+YHnLtPO+N+1vY7kgtnaJNvrd0Ci
	 ZnA9x1Wd9B6Ko/EaiVmAXRXEYQfSkzovXPR/e8XSIDPWKXmhbns3NhHGOX3XbhMCtM
	 m9hnOzzH7Gt7Jq6gKAg5mmRPhCguElS2gEbm15BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 102/148] media: uvcvideo: Return the number of processed controls
Date: Tue, 15 Jul 2025 15:13:44 +0200
Message-ID: <20250715130804.398905879@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

commit ba4fafb02ad6a4eb2e00f861893b5db42ba54369 upstream.

If we let know our callers that we have not done anything, they will be
able to optimize their decisions.

Cc: stable@kernel.org
Fixes: b4012002f3a3 ("[media] uvcvideo: Add support for control events")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250224-uvc-data-backup-v2-1-de993ed9823b@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1560,11 +1560,16 @@ int uvc_ctrl_begin(struct uvc_video_chai
 	return mutex_lock_interruptible(&chain->ctrl_mutex) ? -ERESTARTSYS : 0;
 }
 
+/*
+ * Returns the number of uvc controls that have been correctly set, or a
+ * negative number if there has been an error.
+ */
 static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 				  struct uvc_fh *handle,
 				  struct uvc_entity *entity,
 				  int rollback)
 {
+	unsigned int processed_ctrls = 0;
 	struct uvc_control *ctrl;
 	unsigned int i;
 	int ret;
@@ -1598,6 +1603,9 @@ static int uvc_ctrl_commit_entity(struct
 		else
 			ret = 0;
 
+		if (!ret)
+			processed_ctrls++;
+
 		if (rollback || ret < 0)
 			memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 			       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
@@ -1613,7 +1621,7 @@ static int uvc_ctrl_commit_entity(struct
 			uvc_ctrl_set_handle(handle, ctrl, handle);
 	}
 
-	return 0;
+	return processed_ctrls;
 }
 
 int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
@@ -1634,6 +1642,7 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 
 	if (!rollback)
 		uvc_ctrl_send_events(handle, xctrls, xctrls_count);
+	ret = 0;
 done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;


