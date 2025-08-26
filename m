Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC162340DA4;
	Tue, 26 Aug 2025 13:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214766; cv=none; b=SWVGYpCpCjoG7faR9a5+7XCJOzIbPUGGrL4KRj/wqF8xypZpfNCpkJ4xvqPWqiekl1A8D4hOc9hYg0tdFFQ8GCsHxtUBNQTUNisgTE7yQhtY6GvnzoAj8N97Ui7iCxRmBvjdlFoa7ZlB3flWTiCSSKqlVWBQR1fBc9u2BbWppqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214766; c=relaxed/simple;
	bh=6eue9MCx4z80O9lJrJfV+h0xI5acUFb26cGoo1Vr4CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVtbl1k0wFP6ZJexkoXLfvJ+u6YKiZm8luo14n17JWDAsYBvW6PbILzXaz4y/P0jVYoLOfVJoDqN4fBY+mCCCdhdFMg1ZMFfkTTjbO5P6a2d9DXU3oDj/LR1CIXGkaUEV9yxhGoYvo07+CgNV++j5NDRBuclVV064uC5QQN0THM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QW5zVoOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QW5zVoOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF4FC4CEF1;
	Tue, 26 Aug 2025 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214766;
	bh=6eue9MCx4z80O9lJrJfV+h0xI5acUFb26cGoo1Vr4CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QW5zVoOjvmnq6te853aBdunYELnYJZoTymrTdx/nMWj9KXzDdy60gHdlo5u6sh95p
	 /JVA5EYX75oCl1lXnWfNc5k0e1m7FgZubcliBYHOaCosRQH9jbrKuOrqpMNbD+ON5w
	 uIkmQRBv5hJ4n391u01itR2z9iMW9OPfRByM/3HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Lee <yjjuny.lee@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 262/482] media: uvcvideo: Fix 1-byte out-of-bounds read in uvc_parse_format()
Date: Tue, 26 Aug 2025 13:08:35 +0200
Message-ID: <20250826110937.240474969@linuxfoundation.org>
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
@@ -233,6 +233,9 @@ static int uvc_parse_format(struct uvc_d
 	unsigned int i, n;
 	u8 ftype;
 
+	if (buflen < 4)
+		return -EINVAL;
+
 	format->type = buffer[2];
 	format->index = buffer[3];
 


