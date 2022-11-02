Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91B87E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04323C433C1;
	Wed,  2 Nov 2022 02:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356560;
	bh=H8WTaE6qaiEwTfVdEF9Z9UZuRTV24SS+uNWkTwa4pPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD8cvt4KHHAVV8kRRD7EAmU6P8Aw9cS1mPy+tofTo0V/mc5oxbS7zn0XeAjk4uOVT
	 kS4VuewuH9Dm74XHYCu90HFkrYe25t742ayIg6kiX2MjHFZMi7uVrdjvWJ/aQsnXZp
	 cVzo/9+6ybOjRyCveUe+8V40UV1+o5vMySk+vzLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.0 020/240] Revert "usb: gadget: uvc: limit isoc_sg to super speed gadgets"
Date: Wed,  2 Nov 2022 03:29:55 +0100
Message-Id: <20221102022111.863652139@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 88c8e05ed5c0f05a637e654bbe4e49a1ebe7013c upstream.

This reverts commit 19905240aef0181d1e6944070eb85fce75f75bcd.

It was a new feature, and it doesn't even work properly yet, so revert
it from this branch as it is not needed for 6.1-final.

Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: stable <stable@kernel.org>
Fixes: 19905240aef0 ("usb: gadget: uvc: limit isoc_sg to super speed gadgets")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_queue.c |    9 ++++++---
 drivers/usb/gadget/function/uvc_video.c |    9 ++-------
 2 files changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -84,9 +84,12 @@ static int uvc_buffer_prepare(struct vb2
 		return -ENODEV;
 
 	buf->state = UVC_BUF_STATE_QUEUED;
-	buf->sgt = vb2_dma_sg_plane_desc(vb, 0);
-	buf->sg = buf->sgt->sgl;
-	buf->mem = vb2_plane_vaddr(vb, 0);
+	if (queue->use_sg) {
+		buf->sgt = vb2_dma_sg_plane_desc(vb, 0);
+		buf->sg = buf->sgt->sgl;
+	} else {
+		buf->mem = vb2_plane_vaddr(vb, 0);
+	}
 	buf->length = vb2_plane_size(vb, 0);
 	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -448,9 +448,6 @@ static void uvcg_video_pump(struct work_
  */
 int uvcg_video_enable(struct uvc_video *video, int enable)
 {
-	struct uvc_device *uvc = video->uvc;
-	struct usb_composite_dev *cdev = uvc->func.config->cdev;
-	struct usb_gadget *gadget = cdev->gadget;
 	unsigned int i;
 	int ret;
 
@@ -482,11 +479,9 @@ int uvcg_video_enable(struct uvc_video *
 	if (video->max_payload_size) {
 		video->encode = uvc_video_encode_bulk;
 		video->payload_size = 0;
-	} else {
-		video->encode = (video->queue.use_sg &&
-				 !(gadget->speed <= USB_SPEED_HIGH)) ?
+	} else
+		video->encode = video->queue.use_sg ?
 			uvc_video_encode_isoc_sg : uvc_video_encode_isoc;
-	}
 
 	video->req_int_count = 0;
 


