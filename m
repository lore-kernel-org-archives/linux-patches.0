Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E6E762D2;
	Thu, 15 Aug 2024 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731202; cv=none; b=uKMaUZacBJ92MrrlY+bXi7Q/xO4dF6pzd7/RoU8qmSPwu+URiGJdbSvNgvxujbdPxlpobfX7DqXzq5uTEFXoL3ZqQlDIclmSRFX05peY1U26C4etvmTk5qTQseGdeuRvg8gZam5ToQ8OlJQSGfMFXvdJ2dlllKKHFS3GYz2x6SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731202; c=relaxed/simple;
	bh=7dUvPe+tN6riJuw+Ar7vQpWvt9Fzdd6PJRsotdcqlZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLIaE8amhYKUqBcgTtb926m+iO0ElZ6i6ZvBeaQP12HBgNk+6AkLraIP7B/BHfECSwGZXKvjgHDuzxvv1eTdhRunpHwDfsP1YHanP6kPyJMFk/+sEhhF6tDzZwUfhMsXgvaznAs7MLuVMZQYmf/XHFlPGLRd+s6DqBL5jEpx2cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJZ0kSHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJZ0kSHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8110BC32786;
	Thu, 15 Aug 2024 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731202;
	bh=7dUvPe+tN6riJuw+Ar7vQpWvt9Fzdd6PJRsotdcqlZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJZ0kSHzh09h6FhuzgXo4c9bGm64Cpkxyw6Ro/3BaC4952ezJe9NnBYTqTPDOlWmh
	 4klogsopYPMYDmjHrPsZXsu/5wu8tkbwnSeMOD9tVSmvsB/6g95T+sJ3LrQOKt3q5u
	 YFzD4RbW/TaxR/U0/o0aMCWKi7ghTrqpy2OlJsIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/259] media: uvcvideo: Allow entity-defined get_info and get_cur
Date: Thu, 15 Aug 2024 15:23:07 +0200
Message-ID: <20240815131904.896837568@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 65900c581d014499f0f8ceabfc02c652e9a88771 ]

Allows controls to get their properties and current value
from an entity-defined function instead of via a query to the USB
device.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 86419686e66d ("media: uvcvideo: Override default flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 22 ++++++++++++++++++----
 drivers/media/usb/uvc/uvcvideo.h |  5 +++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index e0d894c61f4b7..13723fccb9000 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1002,10 +1002,20 @@ static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 		return -EACCES;
 
 	if (!ctrl->loaded) {
-		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, ctrl->entity->id,
-				chain->dev->intfnum, ctrl->info.selector,
+		if (ctrl->entity->get_cur) {
+			ret = ctrl->entity->get_cur(chain->dev,
+				ctrl->entity,
+				ctrl->info.selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				ctrl->info.size);
+		} else {
+			ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
+				ctrl->entity->id,
+				chain->dev->intfnum,
+				ctrl->info.selector,
+				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+				ctrl->info.size);
+		}
 		if (ret < 0)
 			return ret;
 
@@ -1718,8 +1728,12 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
 	if (data == NULL)
 		return -ENOMEM;
 
-	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
-			     info->selector, data, 1);
+	if (ctrl->entity->get_info)
+		ret = ctrl->entity->get_info(dev, ctrl->entity,
+					     ctrl->info.selector, data);
+	else
+		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
+				     dev->intfnum, info->selector, data, 1);
 	if (!ret)
 		info->flags |= (data[0] & UVC_CONTROL_CAP_GET ?
 				UVC_CTRL_FLAG_GET_CUR : 0)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9f5b9601eadcf..97817b350f988 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -350,6 +350,11 @@ struct uvc_entity {
 	u8 bNrInPins;
 	u8 *baSourceID;
 
+	int (*get_info)(struct uvc_device *dev, struct uvc_entity *entity,
+			u8 cs, u8 *caps);
+	int (*get_cur)(struct uvc_device *dev, struct uvc_entity *entity,
+		       u8 cs, void *data, u16 size);
+
 	unsigned int ncontrols;
 	struct uvc_control *controls;
 };
-- 
2.43.0



