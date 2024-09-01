Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5043617DFFC;
	Sun,  1 Sep 2024 16:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208630; cv=none; b=cYAXOvfg2eFu+A+VB+KXsuSMpU+58cFWo8iLfQ9x61Gt0l4fhbg8RZ9eIwTpgXoz5E3lKwo9esC5PR2iMphyg0+W9bzdC9TpULU33lYjiQ7HeUm8V1RU09wS74JBuVhC/E1fgtBckpK24gFH5ww3qiK8hmQNZsARYd24bKA6IW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208630; c=relaxed/simple;
	bh=VXj/+QGGfc/L8E/U5B8MovI/JIbNfvXtP7cfUnOw0BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auIefYkwwTvI2J8992ffDLsXWuKns/uE/fd9vt3NeZGcojasd0QNy8lqKXkpbwMRxt099Gcw3QCz/hzCXLgU7KjODj+lxLaaN0znwKjIaa4wIa/U1LXWaIaiqALJteFFIgQcxRw7sGdaVetvUag+8XKU3X1WpGVKa5EmAMMe9Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoZw9UVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoZw9UVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E80C4CEC3;
	Sun,  1 Sep 2024 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208630;
	bh=VXj/+QGGfc/L8E/U5B8MovI/JIbNfvXtP7cfUnOw0BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoZw9UVwKgklt4xMFbdpQTO/BiwdDC/9qD/py4Xafm+D0fRQgOP5dSDWN57mB4vqp
	 Imi2VGO+m3cwIZ4iPZftuQfgFzxWljxbuHY6jtEH3mQhH0AurIV2b4SPzVoHHZeKRh
	 eXU0ZGNGJyk1vntT6AyZC4Y7xXaeViQJ7tfP23o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.10 124/149] usb: gadget: uvc: queue pump work in uvcg_video_enable()
Date: Sun,  1 Sep 2024 18:17:15 +0200
Message-ID: <20240901160822.116008218@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit b52a07e07dead777517af3cbda851bb2cc157c9d upstream.

Since commit "6acba0345b68 usb:gadget:uvc Do not use worker thread to pump
isoc usb requests", pump work could only be queued in uvc_video_complete()
and uvc_v4l2_qbuf(). If VIDIOC_QBUF is executed before VIDIOC_STREAMON,
we can only depend on uvc_video_complete() to queue pump work. However,
this requires some free requests in req_ready list. If req_ready list is
empty all the time, pump work will never be queued and video datas will
never be pumped to usb controller. Actually, this situation could happen
when run uvc-gadget with static image:

$ ./uvc-gadget -i 1080p.jpg uvc.0

When capture image from this device, the user app will always block there.

The issue is uvc driver has queued video buffer before streamon, but the
req_ready list is empty all the time after streamon. This will queue pump
work in uvcg_video_enable() to fill some request to req_ready list so the
uvc device could work properly.

Fixes: 6acba0345b68 ("usb:gadget:uvc Do not use worker thread to pump isoc usb requests")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240814112537.2608949-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -753,6 +753,7 @@ int uvcg_video_enable(struct uvc_video *
 	video->req_int_count = 0;
 
 	uvc_video_ep_queue_initial_requests(video);
+	queue_work(video->async_wq, &video->pump);
 
 	return ret;
 }


