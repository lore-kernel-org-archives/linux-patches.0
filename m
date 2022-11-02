Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532E57E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5FBC433C1;
	Wed,  2 Nov 2022 02:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356549;
	bh=nSVIaQe21shosyRCzjpVGBj95sZznQ5k500tGbDQOZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0aLldgF84ed9FjG8s4BnAa5dXfElSFauWB2TJrDoCrfh7AtwdHnNgwup6JTYlPfd
	 u7cJgp3KOoiF7FmjJ/yu9jH80pBn8b4BLRcbfw48cbm6UIlVOyX/1VhbPGtC3pTok8
	 nlTv5pX0FwaLBPumaEXBszU8bIZJhtW9EP+RSFeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.0 019/240] usb: gadget: uvc: limit isoc_sg to super speed gadgets
Date: Wed,  2 Nov 2022 03:29:54 +0100
Message-Id: <20221102022111.841850778@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 19905240aef0181d1e6944070eb85fce75f75bcd upstream.

The overhead of preparing sg data is high for transfers with limited
payload. When transferring isoc over high-speed usb the maximum payload
is rather small which is a good argument no to use sg. This patch is
changing the uvc_video_encode_isoc_sg encode function only to be used
for super speed gadgets.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20221017221141.3134818-1-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_queue.c |    9 +++------
 drivers/usb/gadget/function/uvc_video.c |    9 +++++++--
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -84,12 +84,9 @@ static int uvc_buffer_prepare(struct vb2
 		return -ENODEV;
 
 	buf->state = UVC_BUF_STATE_QUEUED;
-	if (queue->use_sg) {
-		buf->sgt = vb2_dma_sg_plane_desc(vb, 0);
-		buf->sg = buf->sgt->sgl;
-	} else {
-		buf->mem = vb2_plane_vaddr(vb, 0);
-	}
+	buf->sgt = vb2_dma_sg_plane_desc(vb, 0);
+	buf->sg = buf->sgt->sgl;
+	buf->mem = vb2_plane_vaddr(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
 	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -448,6 +448,9 @@ static void uvcg_video_pump(struct work_
  */
 int uvcg_video_enable(struct uvc_video *video, int enable)
 {
+	struct uvc_device *uvc = video->uvc;
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+	struct usb_gadget *gadget = cdev->gadget;
 	unsigned int i;
 	int ret;
 
@@ -479,9 +482,11 @@ int uvcg_video_enable(struct uvc_video *
 	if (video->max_payload_size) {
 		video->encode = uvc_video_encode_bulk;
 		video->payload_size = 0;
-	} else
-		video->encode = video->queue.use_sg ?
+	} else {
+		video->encode = (video->queue.use_sg &&
+				 !(gadget->speed <= USB_SPEED_HIGH)) ?
 			uvc_video_encode_isoc_sg : uvc_video_encode_isoc;
+	}
 
 	video->req_int_count = 0;
 


