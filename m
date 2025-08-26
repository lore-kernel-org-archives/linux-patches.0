Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C165834DCC0;
	Tue, 26 Aug 2025 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216551; cv=none; b=mejkiF/rz51JTfgu65OAdyu8WGb9gOenVLiBaGiy7lEc5y/mKuIUfQMVu4QYrX5K+0t6DFQIOQS34JNRSWs3hyHQj6w3FnrTzdnZwejxgoKIgQdm2faj/9NFrr3qUFuJ+3f6pjHnJM5wPDlovr9g+1FmFDqWJuBRkzRckrp0umw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216551; c=relaxed/simple;
	bh=zoRsgEOk9usi36a7Gb4fxUf3ByEKvaLi5cmxUNVC028=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNkmXP0yfnMDEOGQZqUyrPaAxwT7m5686IZqIZwlH/6FTmjWO2YeRexg2Pb7gZvqsuJjMZF0iRoilWZigtA4JbQXaGNq0W7oR9MnJmTq6SKOdpBIQiJxo1ntUFWXHPKvhW9rvR9fajGCd5sfUxmJaWRzFOGxVINAM5jeaPrvwCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZznz09Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZznz09Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0289AC4CEF1;
	Tue, 26 Aug 2025 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216551;
	bh=zoRsgEOk9usi36a7Gb4fxUf3ByEKvaLi5cmxUNVC028=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZznz09ZyFGUpwGzpfvl2iCqf0wtBctIbxi2oIxRZHyfSsp/EYDzBNRnjOmUgX/KY
	 qH1nqPKiBdiitO4l6ABtl9GkkikRLhg5UVZ8qkGCQDt0UTrGQrejq64LZEAGct9tEF
	 z0wH4RI2UBsjrMd6c+GpIi33bI+z/4opYvjA+yZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Lee <yjjuny.lee@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 453/644] media: uvcvideo: Fix 1-byte out-of-bounds read in uvc_parse_format()
Date: Tue, 26 Aug 2025 13:09:04 +0200
Message-ID: <20250826110957.701215614@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngjun Lee <yjjuny.lee@samsung.com>

commit 782b6a718651eda3478b1824b37a8b3185d2740c upstream.

The buffer length check before calling uvc_parse_format() only ensured
that the buffer has at least 3 bytes (buflen > 2), buf the function
accesses buffer[3], requiring at least 4 bytes.

This can lead to an out-of-bounds read if the buffer has exactly 3 bytes.

Fix it by checking that the buffer has at least 4 bytes in
uvc_parse_format().

Signed-off-by: Youngjun Lee <yjjuny.lee@samsung.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Cc: stable@vger.kernel.org
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20250610124107.37360-1-yjjuny.lee@samsung.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -512,6 +512,9 @@ static int uvc_parse_format(struct uvc_d
 	unsigned int i, n;
 	u8 ftype;
 
+	if (buflen < 4)
+		return -EINVAL;
+
 	format->type = buffer[2];
 	format->index = buffer[3];
 


