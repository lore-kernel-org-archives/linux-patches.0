Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FAA762D2;
	Thu, 15 Aug 2024 14:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731205; cv=none; b=d+NcSXOKkdoX2EQqS0JJELICyt2ygjjV5zPp3dGh+SGvdl1HVKzeG0RbDaFmMJzxsiKHjFT/I74+XR595NlfyrANaX0Mhi95cVOvg1Jn3fHth7Oekd/e18xx8KvDtFbRYGssSh99AcO3dzM8U3YZc2cZqiao90+TPkq1XQQ67T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731205; c=relaxed/simple;
	bh=UdCInjsp1FGBFSkKFcfC+G9+BUfp1gWVI6NtJHbofws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxKYOw+vVa7TS7N/cmz/IYe4089O8HOWFyHGWpjSQomgL2t8SCqNN7a+TWfTJKFjB2gr+DHNAOVywEmSNQpbnbnahytqH9JEV5+et6SWELIbFGT9k5hCWAKf4uWaJjJDFo4WnHJGgizsCqxrAQ7nQ7wBV4kVIwnuwzWZ7ovuswU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtZ9IzVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtZ9IzVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E38C32786;
	Thu, 15 Aug 2024 14:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731205;
	bh=UdCInjsp1FGBFSkKFcfC+G9+BUfp1gWVI6NtJHbofws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtZ9IzVZ00wHMc96Y6bPBIeKf/ROxbngUGn8SXhX+Gc9OC4upEWjdYv3JBV6RGMHu
	 j/ONBjl0QMSwA6b4ZwnLoyzeAQBpV3+B+lwLsxVBRupgWnmo6f8caST+j0RYZQHeGt
	 GEoF7EBoTtHvMyIqSl3tqhLncXiP47QS008kP7QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schaefer <dhs@frame.work>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/259] media: uvcvideo: Override default flags
Date: Thu, 15 Aug 2024 15:23:08 +0200
Message-ID: <20240815131904.936082043@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 13723fccb9000..c8d9f0df3f03d 100644
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



