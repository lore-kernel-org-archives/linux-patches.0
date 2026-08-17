Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D091541B8EB;
	Mon, 17 Aug 2026 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979361; cv=none; b=iRKLONR018nUBKiajfgCLL7Wj3t7ymR8RZcCeBq3L6lO9GTzLUL6YaOF/4d0kDvz11w+V0nryHgxKOG90TqHULlcHUMIqYzCoK87OPWy8rf5qpvC3l10c0vs9VClcB2J8LysCe4tCjJMgNCbdTe5LIqDGsw2n9frymX+OUYh2rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979361; c=relaxed/simple;
	bh=RRE445nuGdm4wUpl2zMSawawWGnG9xENQuJua4RIUdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edBrnYNnQJQo9fto8K4NImwvTjNU3mKWval6+dLYQBjX3H5K3CaXs2ycDYksXhXI9GDcyNSpZKSXiqoIi/p2q5fliEnpsSoprutTFgXDG8v9oArha/wFxVKsxRI9Rv+wOpNSaPgwjxhF67/sx1wL/SxoK8K2wnT/NAvROtUU/V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaP015fO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaP015fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727C51F00A3D;
	Mon, 17 Aug 2026 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979358;
	bh=jVzZ+VE/ZTGZUCRth5zO8pnxygLPw87abOjMDMrdA/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GaP015fOvnPUiEoZOHVszIxYcP9+n7PhVvdKgtikH1R39tJ9ssdyqNDC1nAXCbM1b
	 Dnvnyy9h//jm8L+tST7bAPMalHJ/R/5w//uDVMJKAuNa7lhGgWbo1brrGj3pAuImO7
	 CmidpwgDE/iz6UXFiyiU3vAETCfYwiMz5FHb8xT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 191/609] media: cedrus: clean up media device on probe failure
Date: Mon, 17 Aug 2026 15:28:07 +0200
Message-ID: <20260817132550.467733922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 2c869b6969f3061cbbdab587f4c0a88bd7fc3cc9 upstream.

cedrus_probe() initializes the media device before registering the video
device, the media controller, and the media device. If any of those later
steps fails, probe returns without calling media_device_cleanup(), so the
media device internals initialized by media_device_init() are left behind.

Add a media-device cleanup label to the probe unwind path and route video
registration failures through it as well.

Fixes: 50e761516f2b8c ("media: platform: Add Cedrus VPU decoder driver")
Cc: stable@vger.kernel.org
Reviewed-by: Paul Kocialkowski <paulk@sys-base.io>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -503,7 +503,7 @@ static int cedrus_probe(struct platform_
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto err_m2m;
+		goto err_media;
 	}
 
 	v4l2_info(&dev->v4l2_dev,
@@ -529,7 +529,8 @@ err_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
 err_video:
 	video_unregister_device(&dev->vfd);
-err_m2m:
+err_media:
+	media_device_cleanup(&dev->mdev);
 	v4l2_m2m_release(dev->m2m_dev);
 err_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);


