Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D41DFFB;
	Thu, 15 Aug 2024 14:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732249; cv=none; b=bllFxwH//yB7GZBI40ptwPpU00EcoQ7c1tvj+17DH6yklWQ1+OnGHCX+wVLZCvd/8cMtd8+lbaD0qZmxmRXRmoo7ATMhk40YlLa7pes7VERGImXjuZLYDALND4mstECtuvnERCqtg0bdJx29gvvP8hTypIknfLzDiFTy+6Q+t9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732249; c=relaxed/simple;
	bh=afGvrBZsAf451x4ICbCfcuR99HJjIVSPEp8++mbQLWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeIqxqVU7psxr+N4BR8s/v36P72P03UdHrwfumKdDi+OWeXGYxZWcT6OQt9qG/SVupF6nXyG1HitWrqpg3KsIpUcTMQQvBe52tjJ02JV60pBxRUlC3CAuv6stOJSj1xOXTBEoAn4z3kRFTfUtr0cfBEYI33+u58mfUOPdJ+JaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdKk67Br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdKk67Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06B8C32786;
	Thu, 15 Aug 2024 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732249;
	bh=afGvrBZsAf451x4ICbCfcuR99HJjIVSPEp8++mbQLWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdKk67Bryj/FqzHvKM5O1v2jrTr8TY075y80t72Su8HcCcYZqZs+kn1uXvsRxCYwl
	 wJANT22T9o8o9i1LhUG51UjWsElJtM512W0eF4vVYgR6GyRRM6tzD9wBSmoMepGsNO
	 7340+Rl88dTJ4GFEBRWffrv2VfaimMtM3tVzhbNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schaefer <dhs@frame.work>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/352] media: uvcvideo: Override default flags
Date: Thu, 15 Aug 2024 15:22:25 +0200
Message-ID: <20240815131922.298216682@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schaefer <dhs@frame.work>

[ Upstream commit 86419686e66da5b90a07fb8a40ab138fe97189b5 ]

When the UVC device has a control that is readonly it doesn't set the
SET_CUR flag. For example the privacy control has SET_CUR flag set in
the defaults in the `uvc_ctrls` variable. Even if the device does not
have it set, it's not cleared by uvc_ctrl_get_flags().

Originally written with assignment in commit 859086ae3636 ("media:
uvcvideo: Apply flags from device to actual properties"). But changed to
|= in commit 0dc68cabdb62 ("media: uvcvideo: Prevent setting unavailable
flags"). It would not clear the default flags.

With this patch applied the correct flags are reported to user space.
Tested with:

```
> v4l2-ctl --list-ctrls | grep privacy
privacy 0x009a0910 (bool)   : default=0 value=0 flags=read-only
```

Signed-off-by: Daniel Schaefer <dhs@frame.work>
Fixes: 0dc68cabdb62 ("media: uvcvideo: Prevent setting unavailable flags")
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240602065053.36850-1-dhs@frame.work
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index e1a98c95b7854..c89f582bd5320 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1734,7 +1734,13 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
 	else
 		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
 				     dev->intfnum, info->selector, data, 1);
-	if (!ret)
+
+	if (!ret) {
+		info->flags &= ~(UVC_CTRL_FLAG_GET_CUR |
+				 UVC_CTRL_FLAG_SET_CUR |
+				 UVC_CTRL_FLAG_AUTO_UPDATE |
+				 UVC_CTRL_FLAG_ASYNCHRONOUS);
+
 		info->flags |= (data[0] & UVC_CONTROL_CAP_GET ?
 				UVC_CTRL_FLAG_GET_CUR : 0)
 			    |  (data[0] & UVC_CONTROL_CAP_SET ?
@@ -1743,6 +1749,7 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
 				UVC_CTRL_FLAG_AUTO_UPDATE : 0)
 			    |  (data[0] & UVC_CONTROL_CAP_ASYNCHRONOUS ?
 				UVC_CTRL_FLAG_ASYNCHRONOUS : 0);
+	}
 
 	kfree(data);
 	return ret;
-- 
2.43.0



