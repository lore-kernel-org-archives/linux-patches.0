Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A7F346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302109; cv=none; b=IUtttYRZd6fTYHlbEL8kTHpKmvFHxB1n0caZmaqlNA2LExaNGhIjYnUQsPoia764knggabP8H959yIuowqEWAcDOAmLMuc4guIX9j71rTKfeBo53Dk4IGmYBK2Dh5wQC+8USUGXrLxEYSTNK44QyDRU4I8tJS64ZUMXOX8h6pj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302109; c=relaxed/simple;
	bh=Bg9eL10/RXYbckHBQv9/8xRyYumXuxwF3hpcFS/teuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z197oM9CI+BYMobvw+qhfiXZ4FgEJu0QljKsStYQfGETncNTMvHFwFLpfQze3qeE2870AW7mUz/vb/4321Sy3Om3t2bvtUuFgRF+fz/J4oDpHPlLKOZnJAVc+tO5YROq10ICgVIi1lRTHZwLXF+yNpHNVNNpsO1yqCYf8cFkCz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXAdKkYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXAdKkYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E59C19425;
	Sat, 28 Feb 2026 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302109;
	bh=Bg9eL10/RXYbckHBQv9/8xRyYumXuxwF3hpcFS/teuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXAdKkYnpjfXCbYo+JWzXLWyLS4QTSWiaP7NdXOl3lX0f0jkewseE5pqAKmLgdjYV
	 LafV4oTKLfBYj5hmUPy7ZGKJ1x6c4b1WEwNWupyGGWoNJFbh6DhG08f9ObnVNiEW0s
	 IfC+mpSCIX99cJ7lmCF8Y47zMo7WHgARPcOdR4dJamkJ3XtXyvMMhYDEIUGLX3zJKH
	 LGOikNjunMGxaQaV/B1i8WCpjB2R5m7qc2ZRJBMgQi13d9S86f3G8dY5q0usyk4/Tf
	 /2u4eb8oBsS371Iq6ifCYj3QzSwoUNfM44YM2J76QgnZZRHnq7WzP50Eub3ayooCwk
	 jVbbLS1Z0KV2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	Itay Chamiel <itay.chamiel@q.ai>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/283] media: uvcvideo: Fix allocation for small frame sizes
Date: Sat, 28 Feb 2026 13:03:59 -0500
Message-ID: <20260228180709.1583486-97-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index a9f880eb518ad..ea7d91b19079e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1819,7 +1819,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 		npackets = UVC_MAX_PACKETS;
 
 	/* Retry allocations until one succeed. */
-	for (; npackets > 1; npackets /= 2) {
+	for (; npackets > 0; npackets /= 2) {
 		stream->urb_size = psize * npackets;
 
 		for (i = 0; i < UVC_URBS; ++i) {
@@ -1844,6 +1844,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	uvc_dbg(stream->dev, VIDEO,
 		"Failed to allocate URB buffers (%u bytes per packet)\n",
 		psize);
+	stream->urb_size = 0;
 	return 0;
 }
 
-- 
2.51.0

