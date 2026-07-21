Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2D23C1098;
	Tue, 21 Jul 2026 22:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671792; cv=none; b=iCJFq45xIEkGPxD96e5ajK5B2kLKrQkMjHcDtyTic3ibFCfPfVnChKrLyrE9Bqi85LnY0V+hg9lNUl+CwgtY6tmXYMA4SsMW87hBdSmECz/gCc6gF+X/qV6+JgJkoosoz2+gA68ugN10i82Kpi08Dzn33Vq3m2/HDM91qmAF/3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671792; c=relaxed/simple;
	bh=OwIr3IH2dEIo9inogmodJeJ3uOMsaH/BQrpQRtw/ZwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZnRzb02fe37O8pLKfCUfULG8upafOrdfWEatiEwtaU6Kie0/14EEoNaOQFTKswiVg8HGwChR+MrKailOgAoWhG+R9nu6bRV3Trv/4W4CfUK8igwabrvD0qH3D1wWlSaI+cjOGcgWvgi4uMdCZVUmPrehC52wuPYbHaN6f8x7eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuIVeiHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuIVeiHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A12E1F000E9;
	Tue, 21 Jul 2026 22:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671790;
	bh=3nZZYxQMzT9AbI2R4XeAIbamjqG0CL7jnlfHEbxPT7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuIVeiHu7pjDh8P2U2JLs7S/ovItAROpbiTwe+sRHHZqMoJpTWJ9+yvxLHCfBqhJK
	 ziwdjidBB6Htbeu0+F+oC6Yrgg8AQqlXcZvQnRCu5HeCFkyNs9COXMj2qdk/irNA+Q
	 sp7jRp+DexCuRXGfvRbL0G0Aa5j3d5FXYahyz/Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/843] staging: most: video: avoid double free on video register failure
Date: Tue, 21 Jul 2026 17:20:15 +0200
Message-ID: <20260721152414.586980329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b7858e47145fa1..24ea0d0b6d22d7 100644
--- a/drivers/staging/most/video/video.c
+++ b/drivers/staging/most/video/video.c
@@ -416,6 +416,7 @@ static int comp_register_videodev(struct most_video_dev *mdev)
 
 	/* Fill the video capture device struct */
 	*mdev->vdev = comp_videodev_template;
+	mdev->vdev->release = video_device_release_empty;
 	mdev->vdev->v4l2_dev = &mdev->v4l2_dev;
 	mdev->vdev->lock = &mdev->lock;
 	snprintf(mdev->vdev->name, sizeof(mdev->vdev->name), "MOST: %s",
@@ -428,9 +429,13 @@ static int comp_register_videodev(struct most_video_dev *mdev)
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



