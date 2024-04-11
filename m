Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2028144D34;
	Thu, 11 Apr 2024 10:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830340; cv=none; b=d68zjahrm1PD8s8z5fZ3brX90gf0e0uCe/PHkF8nECZVMsZW6PVilU12NjA7QYpNAYa0AjgBPcUtZhdDIVpcsi0iHAlk1mnBC6I1TgIjNun+gUiOpUXwprXWw34RZvqvPpYJ9LJsqWsYDlsJjubYL1u539wDCGQGNiRJHZzN5kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830340; c=relaxed/simple;
	bh=Z50bKTdULrExU/zyBidr3MU0mHm6AMkFhDbC4014Z88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC1fLEVuc5G6R0UWzWsJKFMj5LHY6IYtK9/HWdnd94E5oyVXTsLjs0KWa6ShZ51SoYzfA+0SZasOgYYvNvZJA45RbsFLSH6V+gOtvB7/1COG5RdCQi41XXBZQizllbu0GUvUMB19ceYRoTvowYl4vQ2B9DJi/AwM+0/NjeOmH84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCjemDFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCjemDFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E44C43394;
	Thu, 11 Apr 2024 10:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830339;
	bh=Z50bKTdULrExU/zyBidr3MU0mHm6AMkFhDbC4014Z88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCjemDFTR7ZtgrHZo1vorHgDHyO0J6Hcw8VFAHOVZFETBfU4cuWnYJW1C4rh8VZ0N
	 /4yncdJK3S7b8pepdmeSU+dRcbxDcDrfFi8zpzNBUt123SYmrE+ZwbMnCsCNzBn9bK
	 KGwp+r7qUq+RrMIKTM9dNXlppLIupde0e1h9qD0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 114/143] usb: gadget: uvc: mark incomplete frames with UVC_STREAM_ERR
Date: Thu, 11 Apr 2024 11:56:22 +0200
Message-ID: <20240411095424.338423640@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 2a3b7af120477d0571b815ccb8600cafd5ebf02f ]

If an frame was transmitted incomplete to the host, we set the
UVC_STREAM_ERR bit in the header for the last request that is going
to be queued. This way the host will know that it should drop the
frame instead of trying to display the corrupted content.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20240214-uvc-error-tag-v1-2-37659a3877fe@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index dbdd9033c1268..53e4cd81ea446 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -35,6 +35,9 @@ uvc_video_encode_header(struct uvc_video *video, struct uvc_buffer *buf,
 
 	data[1] = UVC_STREAM_EOH | video->fid;
 
+	if (video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE)
+		data[1] |= UVC_STREAM_ERR;
+
 	if (video->queue.buf_used == 0 && ts.tv_sec) {
 		/* dwClockFrequency is 48 MHz */
 		u32 pts = ((u64)ts.tv_sec * USEC_PER_SEC + ts.tv_nsec / NSEC_PER_USEC) * 48;
-- 
2.43.0



