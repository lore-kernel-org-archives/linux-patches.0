Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E143B47E5;
	Tue, 21 Jul 2026 20:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666271; cv=none; b=athCRS1hwd0zlEN/FyWNzT4ldsxs/ki6NxGuZhSs2m8jc8agxKp4PYmDsfv9SWaWr/BFD1z78Rq/AkS3cBlLGZGNu+R8pRFMYPZH+ybpqOqm7EOchL/k2uAqtsAhj+VBL4EvoEAFn9YcVFfQ2pD/NNl/LvqDYpzRJN0lXo8U6a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666271; c=relaxed/simple;
	bh=F2/nKcmtk3Uk+PuHkqxRD96xTH0LB0aZH96Cd1wwOZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbobKdewx/DXlk4+FyhdgKwzrU/zE5l8B3WYkxkL56wXya92A5PyJOBMy69p6xEiqcywIoPPDWo5VY0gtf0tYnDBC45LGHrDUYNq8eOuKrI3XqvChSMwgrPYUkdV8D0rmdCbDvymH0x2mpD8t4wLRK8QHI0YoxhawQIVJ5vD5Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heVHuuC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heVHuuC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8301F000E9;
	Tue, 21 Jul 2026 20:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666266;
	bh=iAFO9lJoX7AcGbvKTQaIFUvODMbYkAOXxFP6Fl43emw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heVHuuC0ffPr8y5jt0QjJ2NMdJCAUAHcSjJ5vF8VoHp8ePkeHuQLHZqbxvYNP6XJj
	 awVMjP1ha/+mj00D06kcSmHc4Ix9aVqxSf5hiNf5cRwgOXheobspqoRqXwrh5lb0Fk
	 lZkvQWy2WnNGbfQiGXJ+W28g3Tl1fYxQufQH+kMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0618/1266] staging: most: video: avoid double free on video register failure
Date: Tue, 21 Jul 2026 17:17:35 +0200
Message-ID: <20260721152455.692077195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6254a5df2502fa..a2fd7681c2610b 100644
--- a/drivers/staging/most/video/video.c
+++ b/drivers/staging/most/video/video.c
@@ -415,6 +415,7 @@ static int comp_register_videodev(struct most_video_dev *mdev)
 
 	/* Fill the video capture device struct */
 	*mdev->vdev = comp_videodev_template;
+	mdev->vdev->release = video_device_release_empty;
 	mdev->vdev->v4l2_dev = &mdev->v4l2_dev;
 	mdev->vdev->lock = &mdev->lock;
 	snprintf(mdev->vdev->name, sizeof(mdev->vdev->name), "MOST: %s",
@@ -427,9 +428,13 @@ static int comp_register_videodev(struct most_video_dev *mdev)
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



