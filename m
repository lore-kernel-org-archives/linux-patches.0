Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D178A7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F38C433C1;
	Wed,  2 Nov 2022 02:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356566;
	bh=+aM3XzhPuRR3Bg58HgXFnIbPk9+29WFB4bWU1gqK3RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ8V836GVq1wxdnFo0buH83RBfvR2EMpUQldYg7/8U9g2sgWQqwNqA7ML+eNnkRGG
	 M9YyB4HBH7vsCo/ErWnE6zBfYLgKagxJwfTvNezz8U0uYkyNctvJukhICWA39/gV5t
	 DlRz2jKT7zkJEJLpDUU+f1/BSYeofxZYiLXitTHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Vacura <w36195@motorola.com>
Subject: [PATCH 6.0 021/240] usb: gadget: uvc: fix dropped frame after missed isoc
Date: Wed,  2 Nov 2022 03:29:56 +0100
Message-Id: <20221102022111.886107069@linuxfoundation.org>
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

From: Dan Vacura <w36195@motorola.com>

commit 8e8e923a49967b798e7d69f1ce9eff1dd2533547 upstream.

With the re-use of the previous completion status in 0d1c407b1a749
("usb: dwc3: gadget: Return proper request status") it could be possible
that the next frame would also get dropped if the current frame has a
missed isoc error. Ensure that an interrupt is requested for the start
of a new frame.

Fixes: fc78941d8169 ("usb: gadget: uvc: decrease the interrupt load to a quarter")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
Link: https://lore.kernel.org/r/20221018215044.765044-2-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -431,7 +431,8 @@ static void uvcg_video_pump(struct work_
 
 		/* Endpoint now owns the request */
 		req = NULL;
-		video->req_int_count++;
+		if (buf->state != UVC_BUF_STATE_DONE)
+			video->req_int_count++;
 	}
 
 	if (!req)


