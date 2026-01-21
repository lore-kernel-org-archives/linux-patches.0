Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E37534A78C;
	Wed, 21 Jan 2026 18:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020306; cv=none; b=fDaeJh+nm17n0mFOLrm1aGFvT3gUqaQQkcy+IQDi2p0GoJsl5bql28vUxUBDdRA8DeuVU3IDpfPl62Xhj3da56EhvxxDlA8lnr0BOUM4UFsAgaLf+/XLWoU24/iahEE3QBV1R89XkJSdJrbgMjx0sEYmwcmRRzXES+aVj5ECUqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020306; c=relaxed/simple;
	bh=SFoHzmInKxet0o4A5mZz7cDXZL6TTfJELmcTvjw6IEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw4RC/z2BOiVHU3RGY5tI9rkObZZevQlYR07VVzmDZ9FFWXs2LbHnI8tA8HSqSGcikX5AiIUdXM/J6aMoUcuWkxoJqYm7NzJ9AGeb8TUbk0WaGemioO8r2tgAC24JyMJwfwSaZIuneou2+Yi0gkwKF7UGo7dNo1of6t2CNXbIYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTE/HgPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTE/HgPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8601C4CEF1;
	Wed, 21 Jan 2026 18:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020306;
	bh=SFoHzmInKxet0o4A5mZz7cDXZL6TTfJELmcTvjw6IEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTE/HgPiQQ1WbE3GyHs9SMKXw1LvdgKxXi42pjbhMSmCese81HqJRhHz3LAPiPsd+
	 GC204Cywhie53Pc5FXqdDHXosq3uOajIU3VCFwwSZpR8ryuHE9QjcbBF2BhNnpXfuy
	 TPcbQIyE+IVhab/EB1u2QCPcVq6lzgj9nTAJKgcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.18 119/198] usb: gadget: uvc: fix interval_duration calculation
Date: Wed, 21 Jan 2026 19:15:47 +0100
Message-ID: <20260121181422.834452972@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 010dc57cb5163e5f4a32430dd5091cc29efd0471 upstream.

According to USB specification:

  For full-/high-speed isochronous endpoints, the bInterval value is
  used as the exponent for a 2^(bInterval-1) value.

To correctly convert bInterval as interval_duration:
  interval_duration = 2^(bInterval-1) * frame_interval

Because the unit of video->interval is 100ns, add a comment info to
make it clear.

Fixes: 48dbe731171e ("usb: gadget: uvc: set req_size and n_requests based on the frame interval")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260113-uvc-gadget-fix-patch-v2-2-62950ef5bcb5@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc.h       |    2 +-
 drivers/usb/gadget/function/uvc_video.c |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -107,7 +107,7 @@ struct uvc_video {
 	unsigned int width;
 	unsigned int height;
 	unsigned int imagesize;
-	unsigned int interval;
+	unsigned int interval;	/* in 100ns units */
 	struct mutex mutex;	/* protects frame parameters */
 
 	unsigned int uvc_num_requests;
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -499,7 +499,7 @@ uvc_video_prep_requests(struct uvc_video
 {
 	struct uvc_device *uvc = container_of(video, struct uvc_device, video);
 	struct usb_composite_dev *cdev = uvc->func.config->cdev;
-	unsigned int interval_duration = video->ep->desc->bInterval * 1250;
+	unsigned int interval_duration;
 	unsigned int max_req_size, req_size, header_size;
 	unsigned int nreq;
 
@@ -515,8 +515,11 @@ uvc_video_prep_requests(struct uvc_video
 		return;
 	}
 
+	interval_duration = 2 << (video->ep->desc->bInterval - 1);
 	if (cdev->gadget->speed < USB_SPEED_HIGH)
-		interval_duration = video->ep->desc->bInterval * 10000;
+		interval_duration *= 10000;
+	else
+		interval_duration *= 1250;
 
 	nreq = DIV_ROUND_UP(video->interval, interval_duration);
 


