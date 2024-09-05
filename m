Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DAF19922D;
	Thu,  5 Sep 2024 09:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529908; cv=none; b=Du/OA58SL7eEhQdJidy7bkeM/D25i4W0MhTSWzM2lcKe2WDJt7Xm0+IyJ7vSgCPh+2awY+sejPRx/jGJtrayG9yYxp1tscslJDgllvMLFHuO+nYcCADFmM2XtU+eLdqndoFOHBsg+0MogSH18CpYj5pGWDdd/rw7xkIi5DCHY74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529908; c=relaxed/simple;
	bh=CxH+nQzC6iwKAeBH6cnDhQA8OLIAbbPJpUEaY9osKV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASu3o72sZkbtRBjvW4wQCwsjwLlH8YmVWt49jo4YoL4oE3WY8mTpGIgzx+bB8wPEXf86ozMtrY5yIXi9G+nkx9o+arAygA5Fn09SPU2wGTkBK8c4mBU4GdfOXLRdBQw3sozNIJSxaxLr/8XwfWu4SwBVloXkTk4EM2AYEPioZhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDpDOi0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDpDOi0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB6C4CEC3;
	Thu,  5 Sep 2024 09:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529908;
	bh=CxH+nQzC6iwKAeBH6cnDhQA8OLIAbbPJpUEaY9osKV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDpDOi0f0FX1Ibg7BWXAFZfuiBk8DlCJl6gYnYmkhUkxxrwRiuQUljQSQfGVTGBd5
	 YTEt1p4ywHIRWan2R7ZtwxMBupOt86D5BhrQ3oRMtPh5l+soB5cGnS5VwXc3inIciA
	 q7EcAPWK70Cvn/prFrzfEHul+dWrQ8YaICdUURPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 179/184] media: uvcvideo: Enforce alignment of frame and interval
Date: Thu,  5 Sep 2024 11:41:32 +0200
Message-ID: <20240905093739.319548766@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit c8931ef55bd325052ec496f242aea7f6de47dc9c ]

Struct uvc_frame and interval (u32*) are packaged together on
streaming->formats on a single contiguous allocation.

Right now they are allocated right after uvc_format, without taking into
consideration their required alignment.

This is working fine because both structures have a field with a
pointer, but it will stop working when the sizeof() of any of those
structs is not a multiple of the sizeof(void*).

Enforce that alignment during the allocation.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240404-uvc-align-v2-1-9e104b0ecfbd@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d435b6a6c295..13c2c11cfdf6 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -687,16 +687,26 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		goto error;
 	}
 
-	size = nformats * sizeof(*format) + nframes * sizeof(*frame)
+	/*
+	 * Allocate memory for the formats, the frames and the intervals,
+	 * plus any required padding to guarantee that everything has the
+	 * correct alignment.
+	 */
+	size = nformats * sizeof(*format);
+	size = ALIGN(size, __alignof__(*frame)) + nframes * sizeof(*frame);
+	size = ALIGN(size, __alignof__(*interval))
 	     + nintervals * sizeof(*interval);
+
 	format = kzalloc(size, GFP_KERNEL);
-	if (format == NULL) {
+	if (!format) {
 		ret = -ENOMEM;
 		goto error;
 	}
 
-	frame = (struct uvc_frame *)&format[nformats];
-	interval = (u32 *)&frame[nframes];
+	frame = (void *)format + nformats * sizeof(*format);
+	frame = PTR_ALIGN(frame, __alignof__(*frame));
+	interval = (void *)frame + nframes * sizeof(*frame);
+	interval = PTR_ALIGN(interval, __alignof__(*interval));
 
 	streaming->formats = format;
 	streaming->nformats = 0;
-- 
2.43.0



