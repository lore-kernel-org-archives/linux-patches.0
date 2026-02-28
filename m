Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D8434252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301758; cv=none; b=tyUXeLzodiFTqCq/GD0GTVUu5lGvs5Jsg2XhCjGnIwLcvKHyBpHyYROfhWisFN5ykMAPRI0WrtAoz19k/u7wRG4INOzAtIEmxLExfzgOgUSLid5r6gGD/rvRfg21OvH9Yxx0CwDOE9IHDBRubImi/u0/BhU0zwghhoA4SEiS0y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301758; c=relaxed/simple;
	bh=QxmeruqaQavGizgv5l8Aeuj/VwoM9kHsPVFPlymMLTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2YLVMsu3DLz0/yd2zUE/aSY4LkMT1YT4kLtWcRA5OLYGloMsn8ME4Lmd83NDMHBydi2EvkXQ9RbsKp+1+V8HAFlaVeO+DsSOe+S7n1I7yfN9QRaypLFkG2vAPtx/fd+mtwi+NgwTkg5RD3fdp1vH8NiiDcC0+LlDQ3Px93sNgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knnfhiaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knnfhiaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6330AC19424;
	Sat, 28 Feb 2026 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301758;
	bh=QxmeruqaQavGizgv5l8Aeuj/VwoM9kHsPVFPlymMLTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knnfhiaU+Aj0L30EyQfuhfOKOBDM6qmeHvhFNJQ9XUUU1BQwCgxvaVK9p9to2fE5i
	 nEI+kG6WKgBGRkIbnwb4DhtTOFo6QOxjqyoG4GuMpOy5kKZ7PTtjhncVdXgqLldh9a
	 OzEoDofUTZ+ZGPABvQpUaV/z7xexVQQebCY3yQnFtgeLPMAJmUbsK9AT8amSOUOyam
	 RyaZsdSIE7Yt3zRkIY3K3y+PYdw4akwFveWgedJsYoxNoyLdUpxYDbvPHgV+yT+TGF
	 vHthy/MpBs9J5NrBJDTCXav6lum/NeyV+dvKFv3mKXxOw190RQxSjjo5aiOxMEAJ2O
	 +8VAy6c0XxyIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	Itay Chamiel <itay.chamiel@q.ai>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/385] media: uvcvideo: Fix allocation for small frame sizes
Date: Sat, 28 Feb 2026 12:56:24 -0500
Message-ID: <20260228180011.1568201-162-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 40d3ac25c11310bfaa50ed7614846ef75cb69a1e ]

If a frame has size of less or equal than one packet size
uvc_alloc_urb_buffers() is unable to allocate memory for it due to a
off-by-one error.

Fix the off-by-one-error and now that we are at it, make sure that
stream->urb_size has always a valid value when we return from the
function, even when an error happens.

Fixes: efdc8a9585ce ("V4L/DVB (10295): uvcvideo: Retry URB buffers allocation when the system is low on memory.")
Reported-by: Itay Chamiel <itay.chamiel@q.ai>
Closes: https://lore.kernel.org/linux-media/CANiDSCsSoZf2LsCCoWAUbCg6tJT-ypXR1B85aa6rAdMVYr2iBQ@mail.gmail.com/T/#t
Co-developed-by: Itay Chamiel <itay.chamiel@q.ai>
Signed-off-by: Itay Chamiel <itay.chamiel@q.ai>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Itay Chamiel <itay.chamiel@q.ai>
Link: https://patch.msgid.link/20260114-uvc-alloc-urb-v1-1-cedf3fb66711@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 57e6f9af536ff..57bccbf17f6dc 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1842,7 +1842,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 		npackets = UVC_MAX_PACKETS;
 
 	/* Retry allocations until one succeed. */
-	for (; npackets > 1; npackets /= 2) {
+	for (; npackets > 0; npackets /= 2) {
 		stream->urb_size = psize * npackets;
 
 		for (i = 0; i < UVC_URBS; ++i) {
@@ -1867,6 +1867,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	uvc_dbg(stream->dev, VIDEO,
 		"Failed to allocate URB buffers (%u bytes per packet)\n",
 		psize);
+	stream->urb_size = 0;
 	return 0;
 }
 
-- 
2.51.0

