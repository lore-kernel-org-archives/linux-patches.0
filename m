Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7986A6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB947C433F0;
	Mon, 19 Dec 2022 19:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671478050;
	bh=N9+LkSGPlH6aGfEeZIwERcCy2a7ct6Vo/K5d/4F4o08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDBpxTSYXv8AWIqsgE41j/ISeIPPoAWxQV6VY+La2Lbq/uOFwis9ngxRhmpsYHWBm
	 0DbyTYNuB4bPo/2mw7fKHPBs2lNaSLEGenLGQ9+5W2e3Mxn5pJ/iZeK8BR7E8Io/qq
	 RoG2/ceEiwCVcnBb/zlSJgM2GXwp3adDTkSfpz+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Szymon Heidrich <szymon.heidrich@gmail.com>
Subject: [PATCH 5.15 05/17] usb: gadget: uvc: Prevent buffer overflow in setup handler
Date: Mon, 19 Dec 2022 20:24:51 +0100
Message-Id: <20221219182940.902823319@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Szymon Heidrich <szymon.heidrich@gmail.com>

commit 4c92670b16727365699fe4b19ed32013bab2c107 upstream.

Setup function uvc_function_setup permits control transfer
requests with up to 64 bytes of payload (UVC_MAX_REQUEST_SIZE),
data stage handler for OUT transfer uses memcpy to copy req->actual
bytes to uvc_event->data.data array of size 60. This may result
in an overflow of 4 bytes.

Fixes: cdda479f15cd ("USB gadget: video class function driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Link: https://lore.kernel.org/r/20221206141301.51305-1-szymon.heidrich@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -213,8 +213,9 @@ uvc_function_ep0_complete(struct usb_ep
 
 		memset(&v4l2_event, 0, sizeof(v4l2_event));
 		v4l2_event.type = UVC_EVENT_DATA;
-		uvc_event->data.length = req->actual;
-		memcpy(&uvc_event->data.data, req->buf, req->actual);
+		uvc_event->data.length = min_t(unsigned int, req->actual,
+			sizeof(uvc_event->data.data));
+		memcpy(&uvc_event->data.data, req->buf, uvc_event->data.length);
 		v4l2_event_queue(&uvc->vdev, &v4l2_event);
 	}
 }


