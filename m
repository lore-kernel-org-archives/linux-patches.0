Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BAB8487
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE412C433D6;
	Thu, 27 Oct 2022 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890112;
	bh=BpsUq086YwlcqpLJaY2Yh5CW23OUtJb/oB2yJp+jf1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NF+9ws5Yf2QEmpKbLMzUFXUicoAfjsb2ERJ1Og/Qwy+Nobw13aSjJe/nGvj0HWJv
	 X7W0/zSGrYssunkQySgtXruzq7PO9sVQntxey7cpvtEfF7eZkEdmT/hx9RreDv2kxH
	 P7RwW727Q/Jh6Yny2mglPbQF8m2edhgS9nD1ZAyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.15 07/79] usb: gadget: uvc: improve sg exit condition
Date: Thu, 27 Oct 2022 18:55:05 +0200
Message-Id: <20221027165055.195793913@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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

commit aef11279888c00e1841a3533a35d279285af3a51 upstream.

The exit condition to quit iterating over the sg_list, while encoding
the sg entries, has to consider the case that the dma_len of the entry
could be zero. This patch takes this condition to account.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220402232744.3622565-4-m.grzeschik@pengutronix.de
Cc: Dan Vacura <w36195@motorola.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -126,7 +126,7 @@ uvc_video_encode_isoc_sg(struct usb_requ
 	sg = sg_next(sg);
 
 	for_each_sg(sg, iter, ureq->sgt.nents - 1, i) {
-		if (!len || !buf->sg)
+		if (!len || !buf->sg || !sg_dma_len(buf->sg))
 			break;
 
 		sg_left = sg_dma_len(buf->sg) - buf->offset;


