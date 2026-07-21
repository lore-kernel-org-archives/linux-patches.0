Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9545546D0B4;
	Tue, 21 Jul 2026 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657137; cv=none; b=tWBvc98bhrgIqPRhSFu0SxzrW4w7Ox8GEcJbBR/XcsCTlWGakgk6d5DQ915n7dHZli4If4ab1rWhj5yKSJpcBDDFW676GpJDz8w3fJemAL42LGRVB2PYAOXLjgk45HGQti+02859hABtjkuK6OLrzoyb76kp/oQnh7+hp9MpBVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657137; c=relaxed/simple;
	bh=Gba9E2vow9cviDtdylWA9dYN3TAIChw2+JTkAP3MJqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFfoj5aBgjABXTLUI0xTHjM3Yt+e6lgHf9XRoefROPxDfc5gfcOG3+4/TZPMGZrhEOwK5SawQ8LfO+fQaaA95lnuLZmP/uRjS9VShrcgmoH50Fz/XoHVog/Tpl7/JAHIcy+skwYFRcjCa14GIbgs5S1uD8TV4OSxMApNhJ13MvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJWVbZSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJWVbZSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081991F000E9;
	Tue, 21 Jul 2026 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657136;
	bh=KoKR4n/VK9n52jN16hBD+AWe5tCj3qx06ZZ+OvomcRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJWVbZScYgRwgeodkGzXqCtsn6junTNVuPnf9e7oMFiAaP9P9EUImzKRG9dRfgVR6
	 EU9bKUgX6YOXN9bj5sGI7gg2A231hgnld2vC7Pi6gnc2MJsHdg05vkVGJX2uWQ8l2x
	 1anygIMRKvktGtC5UVMfVI1VR8xSH0xAEi7Vni8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0608/1611] staging: most: video: avoid double free on video register failure
Date: Tue, 21 Jul 2026 17:12:04 +0200
Message-ID: <20260721152529.063257454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 7cb1c5b32a2bfde961fff8d5204526b609bcb30a ]

comp_register_videodev() allocates a video_device with
video_device_alloc() and releases it if video_register_device() fails.

This can double free the video_device when __video_register_device()
reaches device_register() and that call fails:

  video_register_device()
    -> __video_register_device()
       -> device_register() fails
          -> put_device(&vdev->dev)
             -> v4l2_device_release()
                -> vdev->release(vdev)
                   -> video_device_release(vdev)

  comp_register_videodev()
    -> video_device_release(mdev->vdev)

Use video_device_release_empty() while registering the device so that
registration failure paths do not free mdev->vdev through vdev->release().
comp_register_videodev() then releases mdev->vdev exactly once on failure.
Restore video_device_release() after successful registration so the
registered device keeps its normal lifetime handling.

This issue was found by a static analysis tool I am developing.

Fixes: eab231c0398a ("staging: most: v4l2-aim: remove unnecessary label err_vbi_dev")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260517111218.945796-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/video/video.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/most/video/video.c b/drivers/staging/most/video/video.c
index 32f71d9a9cf78a..221295d8cac28d 100644
--- a/drivers/staging/most/video/video.c
+++ b/drivers/staging/most/video/video.c
@@ -418,6 +418,7 @@ static int comp_register_videodev(struct most_video_dev *mdev)
 
 	/* Fill the video capture device struct */
 	*mdev->vdev = comp_videodev_template;
+	mdev->vdev->release = video_device_release_empty;
 	mdev->vdev->v4l2_dev = &mdev->v4l2_dev;
 	mdev->vdev->lock = &mdev->lock;
 	snprintf(mdev->vdev->name, sizeof(mdev->vdev->name), "MOST: %s",
@@ -430,9 +431,13 @@ static int comp_register_videodev(struct most_video_dev *mdev)
 		v4l2_err(&mdev->v4l2_dev, "video_register_device failed (%d)\n",
 			 ret);
 		video_device_release(mdev->vdev);
+		return ret;
 	}
 
-	return ret;
+	mdev->vdev->release = video_device_release;
+
+	return 0;
+
 }
 
 static void comp_unregister_videodev(struct most_video_dev *mdev)
-- 
2.53.0



