Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667F579FD;
	Thu, 11 Apr 2024 10:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832469; cv=none; b=aElYC9+zU9dLwiAZ18saCGz0dPl8NxNrY+nc40fXsJR/jwrwdS8k6JZ8yx442OlpUkunuqyHgMSmir38On8kBC2Q3BHsjCE0azrQARKXaW1AvdibFRcJVsa3wXoeAUoYTMDuXHZ+n/9skzAwasc8mr8jVMfjEuRgsLwwbblS4JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832469; c=relaxed/simple;
	bh=aMdDWEJvTwKaF/iM7i3sUhnci3wJ085lw6LADwIRkWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzmuPmw+Ig3+KoxiJo2qT2WBOyWW4t0z9ESJAv+s1KV8nTBh4R72PvfrFg8EhYqQXxO6Sd4nutuZq5nnNosR3GJHDmf0AaAlj+QB+azo34J+ijlQ8N4hPMGzbg0CSobc2Q+XtLpbsPDaWIQcQlq4suSAVPeIeQXebec8+4+bv6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSakvCos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSakvCos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38AEC433C7;
	Thu, 11 Apr 2024 10:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832469;
	bh=aMdDWEJvTwKaF/iM7i3sUhnci3wJ085lw6LADwIRkWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSakvCosnC6u7VDBwgOaGo0NLjmgjkQhleERqeNCf3Yr0o4+QVrvdmCiPDsEDBrO+
	 VkEZIN1GSuvotVEOO14nUYA1KwTovksv6ALxsfYdWGBIVSW1dgyylSPc3y51089LJU
	 yTUpuchQVRkQxwTT74TdLVfQP6nO19U+9qZExyYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/83] usb: gadget: uvc: mark incomplete frames with UVC_STREAM_ERR
Date: Thu, 11 Apr 2024 11:57:31 +0200
Message-ID: <20240411095414.461563859@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e81865978299c..be48d5ab17c7b 100644
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



