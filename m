Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EDB18A6DF;
	Tue, 10 Sep 2024 09:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960977; cv=none; b=bdxg630IHPO3DfjKxC5+zqmuFhS+NJif/3UX+HPq3M3kF7SF8vKdyegWSPBHRV/XBR6Wp4cKCzq9F0RZaKXL/wLOQTYvhw2SULsvaFRGV6PCNvgisCL84BY0yKEvuVWuzGSEz/yl3confshv5ynC/QxyTcFHcy5ewaY9E2mFMTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960977; c=relaxed/simple;
	bh=MuskqV41sBIoHxhI4Rfh0D6SzlJjKydpSZfvV6tMxZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+mA3Tv915b3t3p455MVD2igaM2/e41DX+k2ZrHSDaSYzqL2UkJAl1rq6RFU230zIqlFmClQdPiKQcYVknSx2awDc6h85P2PeL2+3rE3rjhnDl9mR80HbNaa5DlBw4NxcZzsB1Xibc0trNN6gZ2RVmx1guPrjaHfk5o7azwbDvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0gCMNbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0gCMNbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3A5C4CEC3;
	Tue, 10 Sep 2024 09:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725960977;
	bh=MuskqV41sBIoHxhI4Rfh0D6SzlJjKydpSZfvV6tMxZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0gCMNbETyXWjmvZFiCFncW22j82vV/4GCPBkkE2EssFzuwLsaf+jAxegI2kVyioz
	 Zml0qx+yXbERNs62fqBD+bkxaHSeXlIt5vB+hhIQA5rVOTMb5DtDpz63Kj4ZckP3Q6
	 L95Oh4fupuCx/gJgQSgT4C/yT+MSnIO8uGfvAo6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/96] media: uvcvideo: Enforce alignment of frame and interval
Date: Tue, 10 Sep 2024 11:31:14 +0200
Message-ID: <20240910092541.954827966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 775d67720648..6367ee9c0066 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -860,16 +860,26 @@ static int uvc_parse_streaming(struct uvc_device *dev,
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
 
 	streaming->format = format;
 	streaming->nformats = nformats;
-- 
2.43.0



