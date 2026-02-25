Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6039818DB2A;
	Wed, 25 Feb 2026 01:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983129; cv=none; b=gpBrLBJenwg/fcOI0vJm5oA+180kZDD47I/gTCQKUAA8QH1fFXDBTq6GhjMoXAfLMSLeo67kkOmGqM8DuGGs79lrYhZj1WZ3KL9bF1hXYq3BDRmOgRpCYsBH6tq+/o5berWpGuQZDqLLPI5wwf0lkly/SLBBQAqi77zNLhSomWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983129; c=relaxed/simple;
	bh=jqjpw33yq8kR+A2S+3WCeSY/4Guq7Kcmx7euwn/vhME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWZ0GLsFHtKSQjG/pyt+5cXKXjkN+OH4EpIHBGiCBibd9DqNZezMuWW5FdBzCY7OFsqJsyt/uIjhVyem7yuBEmClRwAQZcNbbh/MZitsSuhGCC/fCEc8VZ3YcCwnBbcLr1hiNngRYTxfB2QHGHwlH3vyp8mTEYY4kSIzsj4Il+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcFm9+NI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcFm9+NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C292BC116D0;
	Wed, 25 Feb 2026 01:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983128;
	bh=jqjpw33yq8kR+A2S+3WCeSY/4Guq7Kcmx7euwn/vhME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcFm9+NIK7oN7Pf61P6PDSLWmGkRw0N1RR8aHRxtmPEcueM6dYf5BHfKiS+oVwUNG
	 o9bRRoGeQ/EPW6EnYto4pQovuTnUZIcsC1PA07RgCfa8tEf+b0yJyep+qQa8r4Ezag
	 OYsQ/3wCpjmRO96S0LRdsRLML6iWd4gYIC86hj84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itay Chamiel <itay.chamiel@q.ai>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 286/781] media: uvcvideo: Fix allocation for small frame sizes
Date: Tue, 24 Feb 2026 17:16:35 -0800
Message-ID: <20260225012406.720481943@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 2094e059d7d39..ec76595f3c4be 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1812,7 +1812,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 		npackets = UVC_MAX_PACKETS;
 
 	/* Retry allocations until one succeed. */
-	for (; npackets > 1; npackets /= 2) {
+	for (; npackets > 0; npackets /= 2) {
 		stream->urb_size = psize * npackets;
 
 		for (i = 0; i < UVC_URBS; ++i) {
@@ -1837,6 +1837,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	uvc_dbg(stream->dev, VIDEO,
 		"Failed to allocate URB buffers (%u bytes per packet)\n",
 		psize);
+	stream->urb_size = 0;
 	return 0;
 }
 
-- 
2.51.0



