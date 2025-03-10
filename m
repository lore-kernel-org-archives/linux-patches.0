Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F13F232787;
	Mon, 10 Mar 2025 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629161; cv=none; b=qAay69IAihfFjSSB9sITgBGgRRrPA66K9QLvLoNkbQ4+u5En8vQwKrbDjA3h6AdpZLXLIn8c+2FvkK9hO02MyFOoLuLgLa7CLjaFn/r7dqKwF1qaLfttHjhrH8Ek/PODVeBQxNLV4g3fSWUkwWa3hUuuE0Plkm/q2rpyfe+YG/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629161; c=relaxed/simple;
	bh=ZYu1Bt05cYHGKtj89GC0Z5azX8dCOufncMDrUAGRoAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUkhipJBQEov1AkjWlvkna78z6IKRi2Q2rhays22TRywqJITuLlb/qc62zxX6FDrgn9Flv1wl7yvjr4o6bPlOXp7HvyZEiD5c3jh2+O3o4EdN5WgZ9qIKxQJUMS7dhFQXj1Uj4eiJAZhPbSDmSlybcmZSpMm/VF1OLAuB91LZWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3/57kQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3/57kQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5DEC4CEE5;
	Mon, 10 Mar 2025 17:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629160;
	bh=ZYu1Bt05cYHGKtj89GC0Z5azX8dCOufncMDrUAGRoAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3/57kQaZ4h/sC3OaMBy8Q5zogfVQlJRYhb/Cy9s0GE2AdOYZDlxPD/gAssrouOAW
	 VIK2Z+AnO2ng4Z8CclDgUOhDksU3/NcSsdpxgCSoM4eoc6b6cL0XphymHX2S4yTghs
	 rW0EXrpZejpEnWxXU9CC4ESQLru//CKV9Yd+0ve0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 198/620] media: uvcvideo: Fix double free in error path
Date: Mon, 10 Mar 2025 18:00:44 +0100
Message-ID: <20250310170553.443461801@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit c6ef3a7fa97ec823a1e1af9085cf13db9f7b3bac upstream.

If the uvc_status_init() function fails to allocate the int_urb, it will
free the dev->status pointer but doesn't reset the pointer to NULL. This
results in the kfree() call in uvc_status_cleanup() trying to
double-free the memory. Fix it by resetting the dev->status pointer to
NULL after freeing it.

Fixes: a31a4055473b ("V4L/DVB:usbvideo:don't use part of buffer for USB transfer #4")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241107235130.31372-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_status.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -268,6 +268,7 @@ int uvc_status_init(struct uvc_device *d
 	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (dev->int_urb == NULL) {
 		kfree(dev->status);
+		dev->status = NULL;
 		return -ENOMEM;
 	}
 


