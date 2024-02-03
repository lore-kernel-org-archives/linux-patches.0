Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A537179BD;
	Sat,  3 Feb 2024 04:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933608; cv=none; b=OGXHfxNLXtZBTPdxEsOi6qn1Z4Z71/ar8r7/orPD7MAaqxOeEVYPVghBBMAkTxlxq91BfNDDHXWWHfNQVHgk0uQF6Hu77VhmTBXlJiYr/csJfiUBobuFFg3/hWd244ryE+gW4u5/dfYIAOz6CuFAIpyoRWCZJL37e73vMMyVqOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933608; c=relaxed/simple;
	bh=lT1RNi0ZiDZCdJDRYQOPGAHxeRjkgImxeIt73m6LzRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAVCXfQJITxBQEmqkphGzS2eFwedhkmjyNkBswXN5kA9ETV/jOI74aEHy2dFtMv+tyoZPziTqZSn0R9NtQbrAxSDjZqu2K3lVtOtoxvjTJu2rptdScIgpqcPzTmDQcfeR/Gdjx+TCQKaZbCnIMY152t2bnxwGFWNnHrDYVB0Sik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5SJFAQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5SJFAQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70B2C43399;
	Sat,  3 Feb 2024 04:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933608;
	bh=lT1RNi0ZiDZCdJDRYQOPGAHxeRjkgImxeIt73m6LzRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5SJFAQ7Uyc+uKIkp77ypDgOtO59oLoyAvq88avksyx7WhxYW6FQyuufx+5lQhiDK
	 cN39ekONXMbhatETFjPZ9nMRdfkDKiu0m+d1rO0OPmxkQat3bVLa5YhhN2qKPKlW5X
	 600FmLczr36hJgZN+Tj+PTl/6zw/8ndL4PU3Y900=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/322] media: uvcvideo: Fix power line control for a Chicony camera
Date: Fri,  2 Feb 2024 20:04:35 -0800
Message-ID: <20240203035405.004387727@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit dba3e701917a4cce92920f8ccb9fa4d4ee5ac07e ]

The device does not implement the control properly.

Fixes v4l2-compliance error:

info: checking control 'Power Line Frequency' (0x00980918)
fail: v4l2-test-controls.cpp(552): could not set valid menu item 3

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 08fcd2ffa727..4b5ea3501753 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2592,6 +2592,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_ctrl_power_line_limited },
+	/* Chicony Electronics Co., Ltd Integrated Camera */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x04f2,
+	  .idProduct		= 0xb67c,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= UVC_PC_PROTOCOL_15,
+	  .driver_info		= (kernel_ulong_t)&uvc_ctrl_power_line_uvc11 },
 	/* Chicony EasyCamera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.43.0



