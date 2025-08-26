Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DDD393DF2;
	Tue, 26 Aug 2025 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214620; cv=none; b=iLznqHAIG5V8uS7fm9u3e1iRtiYcmhh4vtSCvL9jMiFDZ1hBsDEhajCs8VeNwqAujlO8ljNEjBtYEQUy2s59VF3NpCEb4NVV4zS1KAiYdL1x8PHu909j2G9o1eWGI/rCNP3zWMu245uesuZa+EV/z63LTZv0jN4JyP3nCi9QIsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214620; c=relaxed/simple;
	bh=2fSK2hovzdtTbBXY4m+AIwwcB8BvMH5rikBKQDH86p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABH6zXlHaItIBbA38Yt9UPUBhZJXbbj8ZfOoRx2/34X5eZY1pQ2goqY9jcd26V475ptbkJj94jxDZFGv2pydD5UX+6KRrnrzXyc22W8W++BLZZjHOKcLB7an/Q5X/KmLcFd4k3+C1sWp3y8JfMS4wIYwjVsSEprck99zhJgwafk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hniNYROn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hniNYROn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED7DC4CEF1;
	Tue, 26 Aug 2025 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214620;
	bh=2fSK2hovzdtTbBXY4m+AIwwcB8BvMH5rikBKQDH86p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hniNYROnjx6u6dbFli6VrS2guwMjWHrpZV3yCMnCUScishJ7ksasHe5J1+3lchoj+
	 b3h9FX+zogd10lS/M8HqO6juZlHMO4SofkrW+agNQbm8O5daGIu1Q3yjtwPUXXYxQa
	 rWuycHYnci888VQcrAC1UfF5NXHWhgx9yIiqJSYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenchangcheng <chenchangcheng@kylinos.cn>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/482] media: uvcvideo: Fix bandwidth issue for Alcor camera
Date: Tue, 26 Aug 2025 13:07:39 +0200
Message-ID: <20250826110935.875169670@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chenchangcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 9764401bf6f8a20eb11c2e78470f20fee91a9ea7 ]

Some broken device return wrong dwMaxPayloadTransferSize fields as
follows:

[  218.632537] uvcvideo: Device requested 2752512 B/frame bandwidth.
[  218.632598] uvcvideo: No fast enough alt setting for requested bandwidth.

When dwMaxPayloadTransferSize is greater than maxpsize, it will prevent
the camera from starting. So use the bandwidth of maxpsize.

Signed-off-by: chenchangcheng <chenchangcheng@kylinos.cn>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20250510061803.811433-1-ccc194101@163.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index aa0a879a9c64..29efccd5aa09 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -234,6 +234,15 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 
 		ctrl->dwMaxPayloadTransferSize = bandwidth;
 	}
+
+	if (stream->intf->num_altsetting > 1 &&
+	    ctrl->dwMaxPayloadTransferSize > stream->maxpsize) {
+		dev_warn_ratelimited(&stream->intf->dev,
+				     "UVC non compliance: the max payload transmission size (%u) exceeds the size of the ep max packet (%u). Using the max size.\n",
+				     ctrl->dwMaxPayloadTransferSize,
+				     stream->maxpsize);
+		ctrl->dwMaxPayloadTransferSize = stream->maxpsize;
+	}
 }
 
 static size_t uvc_video_ctrl_size(struct uvc_streaming *stream)
-- 
2.39.5



