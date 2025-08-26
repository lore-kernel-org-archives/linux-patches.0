Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78AF352077;
	Tue, 26 Aug 2025 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219172; cv=none; b=ZzGEl7kojT1DW0Gxszz7ecJVQ3gGd1y8uzTljNZu+Mw05rM9uy+eSLtKtK43pRk98G5Dset+esqWGqegPaNX5TAnZSSHlWCX40fYRjwoAiABh5nxZRcmxZX/GPnsALp7U8E97CbpWJe9LuLXxfF/OGuaehyUv6FOYqbxJ304VRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219172; c=relaxed/simple;
	bh=j9FMROHGHB6iX2yAnLkcjepXW4Mx8E1JAb2nNjZ8QbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCN5PzrV94O5eEstAtwOuBcI0yDOumFy0Teso62JZBpp9JPnzjoDn1JmO+iK3MaTTncxoGT6YKCKVu0rfX3hF6EzIo5r08PsZ77RvjpKPv6nwZWpTVrUNXt8KXEDIxSLaOFvPGRhmIRBD98YXObMmLxmfiBAwDMZxPzmv9SUd1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7tnoob1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7tnoob1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BC2C4CEF1;
	Tue, 26 Aug 2025 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219172;
	bh=j9FMROHGHB6iX2yAnLkcjepXW4Mx8E1JAb2nNjZ8QbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7tnoob1HGMdQVNbpQMW80IurpO/x1pLUEP86UEkH2Tx0esCf6p2GTQz8Lo+gq+5B
	 dF+BaSwO7L3glyuveVQn6H+EINuhJVA/2uC07Ustf4Q7dvadDOuOlVwJQQxaqNVdKY
	 oIylBNTX9IUmEtNW2uVuOWuE9DI8drFbnUIbI4aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenchangcheng <chenchangcheng@kylinos.cn>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/403] media: uvcvideo: Fix bandwidth issue for Alcor camera
Date: Tue, 26 Aug 2025 13:09:39 +0200
Message-ID: <20250826110913.811142208@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e62afdee20db..d1510c1230d9 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -228,6 +228,15 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 
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



