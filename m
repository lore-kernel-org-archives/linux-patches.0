Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2545F1C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFcV15nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F55CC433C8;
	Wed,  4 Oct 2023 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444566;
	bh=z0Qgn7IIcJygusKnuVTU7SuyDU2OyGxo+EhYH9QDVWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFcV15nj84ro+f3wOlvGtCWqh+K1u0IyyUqDZ13g/FJY4TO12ZpcAcI5KyheuEIl7
	 /mCSW/ZD5UTurmW5u84Ir1dREK0L7Uw6xMQUXPqDa8g0Onrn2HJRdYBN/300bmfx60
	 n1KuexDpGn0nSxIL/AdJHRtSBNMrY40xnNqOeijM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zubin Mithra <zsm@chromium.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.5 295/321] media: uvcvideo: Fix OOB read
Date: Wed,  4 Oct 2023 19:57:20 +0200
Message-ID: <20231004175242.966021937@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 41ebaa5e0eebea4c3bac96b72f9f8ae0d77c0bdb upstream.

If the index provided by the user is bigger than the mask size, we might do
an out of bound read.

CC: stable@kernel.org
Fixes: 40140eda661e ("media: uvcvideo: Implement mask for V4L2_CTRL_TYPE_MENU")
Reported-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1402,6 +1402,9 @@ int uvc_query_v4l2_menu(struct uvc_video
 	query_menu->id = id;
 	query_menu->index = index;
 
+	if (index >= BITS_PER_TYPE(mapping->menu_mask))
+		return -EINVAL;
+
 	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
 	if (ret < 0)
 		return -ERESTARTSYS;


