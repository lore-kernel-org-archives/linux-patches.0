Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DED321430;
	Mon, 18 Aug 2025 13:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524152; cv=none; b=r6aJiONtTk7iLY+Xi95rzZlRZZXzx5Q85rCePmw4NFu1ZPrWf3DCHRPZudhNXl0zLbin9G9GFvXo+VzO7ivvrnnIPFXNuNS+lIvjd6Kf+te3bxXU/XJ3kFviCmgBDSe+2EAWd2156zb6p5KVzOgEEyzfP4V0SRtfGwm9JXPD5HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524152; c=relaxed/simple;
	bh=oyFcJ1RD1SVrURkgFtwot3TDe0wy+xvqcsvMDWKT/OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXTv61jsqElrhs3WJ2YDBuFMJ7rKx7qJcBPtyIpqeUmw3PFwQtRvaWsh3dC/WM5RQHAbJbPHppA9BSqfbPO4k5Rw2agJGR0j53CYJyBcFjX05RWJj15y/qOrr8M2MJCE9xTerinBFUkhJjwwzUNPH5MO72OgBN7e57gcGzaqick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTpTKPBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTpTKPBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80A1C4CEF1;
	Mon, 18 Aug 2025 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524152;
	bh=oyFcJ1RD1SVrURkgFtwot3TDe0wy+xvqcsvMDWKT/OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTpTKPBYAA6vbq/LWSXl2N4f5BzIcsisqd0/QU0QCZIcVtxuU1CyziqAC6nEleL5J
	 77TsNHIJZwN3KFJkfj1U4PpL/2TFmeR0LyeSFRWyeovfmtqDEV79A+LfcPtSuLbjct
	 VgWmGuiC77iPhxroSOZ5coe4yVZDXQAKpDEtYlHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenchangcheng <chenchangcheng@kylinos.cn>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 383/515] media: uvcvideo: Fix bandwidth issue for Alcor camera
Date: Mon, 18 Aug 2025 14:46:09 +0200
Message-ID: <20250818124513.160686270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e3567aeb0007..11769a1832d2 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -262,6 +262,15 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 
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



