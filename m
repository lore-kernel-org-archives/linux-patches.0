Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A451C57A3;
	Tue, 27 Aug 2024 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770043; cv=none; b=LeMz7gQKpeNEhXzA+ymPksbz2cGy8uxpSN89gdcnaaXdGeVZ4x8GjpIaODnBc/bOc2f9t3A6gtPKwrqELC/zgi48aEM9yxGBI6qwxlgSpLjkYXeaFTheQb3gTjBObogT4Jwosyebk5gAgoKC2m4NKLfk6/xmR7cTLtW2FvI5mXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770043; c=relaxed/simple;
	bh=8faUT/czwVRpYjx8Hme/2AhT+G70t82YbqlHm/XwWV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8nFgu2d/RMioggP3ZikNpQ3lhApX16PKgI+LiD14qVtHEosE6llms9iiAN9SsMvXaGmj1Y0EmhyZyNOAEc0fYZdh82SwjoJJnlZzCRex1ThHCA+MGwdMThdQf8cX7qDVothgKj9TzayCWMZQGuN1TZNUfKtKwbXkvIXzlXdDGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7bzD71v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7bzD71v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93F5C4AF11;
	Tue, 27 Aug 2024 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770043;
	bh=8faUT/czwVRpYjx8Hme/2AhT+G70t82YbqlHm/XwWV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7bzD71v5o9zi33dL293AfHypPrDJV72ph0UTQi3Pi7XDwYf40mTcqdO07M5EOWYT
	 EXAaO/i2VLUdzAohUX2hI+YXyI4U9B2WVAAI9S7C1Kx5t85bke9SUjiDFPhytFuNb5
	 uMIMbwfzSelYd+E9Ct2G8oiyoskjFWsQaILNCo/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/341] usb: gadget: uvc: cleanup request when not in correct state
Date: Tue, 27 Aug 2024 16:35:41 +0200
Message-ID: <20240827143847.597379131@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 52a39f2cf62bb5430ad1f54cd522dbfdab1d71ba ]

The uvc_video_enable function of the uvc-gadget driver is dequeing and
immediately deallocs all requests on its disable codepath. This is not
save since the dequeue function is async and does not ensure that the
requests are left unlinked in the controller driver.

By adding the ep_free_request into the completion path of the requests
we ensure that the request will be properly deallocated.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20230911140530.2995138-3-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 281e75027b344..678ed30ada2b7 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -259,6 +259,12 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 	struct uvc_device *uvc = video->uvc;
 	unsigned long flags;
 
+	if (uvc->state == UVC_STATE_CONNECTED) {
+		usb_ep_free_request(video->ep, ureq->req);
+		ureq->req = NULL;
+		return;
+	}
+
 	switch (req->status) {
 	case 0:
 		break;
-- 
2.43.0



