Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95711A3024;
	Tue, 30 Jul 2024 16:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355929; cv=none; b=pBikgNNHRrquo7nyR527qQzTi5pnsBGz8KLeki5CHRWHWAlnQYb948QVlwtZIVURKza3OKg8WtnC8A8l9knWc5WK9bDgTQQrSJzSj1zxeKkEg4BY1E5S6RLwjvE+diajjze6iO8ZeRGC21+MTUWSlCRmVE3HQXm/ClZ129RxO+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355929; c=relaxed/simple;
	bh=e3maEF8aa/f4DgA1aHrFLBJ9Tju/W0/88hi0k1kpgkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMue/A0JLieCtEB4ZPSEDDXIL/EuJ7sCkUo3yrRoGlIkKP7gfo3NbSX1jJ/b7+HsiGkhL3wyW31aFyIDHaghor9hT4eG1vZwuUX6tlltTFby2PtjObFA/4bCiM/JjQCGWU/PPqf+nWqVO8NFiTi1upItgWRvipJjleNQ9vQ0hb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZVLs2O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZVLs2O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D092C32782;
	Tue, 30 Jul 2024 16:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355929;
	bh=e3maEF8aa/f4DgA1aHrFLBJ9Tju/W0/88hi0k1kpgkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZVLs2O4Q5j2PVMO/hdsOGwCG/v59NBZWvMdMJfyWU+XiS2msDj2kfJ1SRZ+b8P7v
	 7728ESfdkELol8aNTTEZSLYbGwOeFYQmHOEUBtXbdM+2D4nOma+NEBpBBbMbPHuWDD
	 tqJuqNWa4nJNs1K1IkoNu7Fcf2hnL/f0vzq1hZ0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schaefer <dhs@frame.work>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/440] media: uvcvideo: Override default flags
Date: Tue, 30 Jul 2024 17:46:18 +0200
Message-ID: <20240730151621.545617402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 6d7535efc09de..dffc9d03235c4 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1959,7 +1959,13 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
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
@@ -1968,6 +1974,7 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
 				UVC_CTRL_FLAG_AUTO_UPDATE : 0)
 			    |  (data[0] & UVC_CONTROL_CAP_ASYNCHRONOUS ?
 				UVC_CTRL_FLAG_ASYNCHRONOUS : 0);
+	}
 
 	kfree(data);
 	return ret;
-- 
2.43.0



