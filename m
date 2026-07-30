Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14021270545;
	Thu, 30 Jul 2026 15:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426105; cv=none; b=h2dT+p365HgRz2CWIEzkL3rfPnSKQKaLwS1+V6P4umma81TzABKVbuT7cB5AprJiu9hICWxtYS2VJoEC40VCNqdIhv+PqhD9NNG0acsC2GYt7T3zvQu8u/blrUHkQxpwXHjbo2dASf7H+Fq13uEIVOldjIR1W3u4NhKfIz1G1M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426105; c=relaxed/simple;
	bh=7LWTFW7ObY0XHjWnTo5yh9p8/0I4nKPNH4lhZ/FV/1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jloobw8fwVG3u3v/z8Sr/ZmeYmrOmTfqcgDrZGs8iAAkzWz4XoQpWwkgG9Jyf0kWiclqKp0140pgeEHrGKAHrYEeGz28GPKcrQvWxwzWP+kZQ7mYju8X2WxXAKufCJV/is4U/xv/CspM9AT3uJTjiRJEhtJkKGMsvoh3eZlJYkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbP9yQjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbP9yQjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECB21F000E9;
	Thu, 30 Jul 2026 15:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426104;
	bh=6t8eQv+FEtTzr3dJpxO4JhAmiEYwN2GnQeJ6W4hNmD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbP9yQjgTKZD7ioNiqVTq7nlaHdOO+TYGIvX02kUz3NEO4LNeSsSSYtYmpFX0G7Nv
	 gUrYxSK+6f6FQQSozx8hDgNKZhRS9kae0wA3Wm2xF7VWwYEJR79JytIetOSz1QR3M8
	 vf9Z9KyVs9lxHk3WIfntC9cEgUBqPElKBYeDP2mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 302/602] media: cedrus: clean up media device on probe failure
Date: Thu, 30 Jul 2026 16:11:34 +0200
Message-ID: <20260730141442.313965357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,7 +509,7 @@ static int cedrus_probe(struct platform_
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto err_m2m;
+		goto err_media;
 	}
 
 	v4l2_info(&dev->v4l2_dev,
@@ -535,7 +535,8 @@ err_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
 err_video:
 	video_unregister_device(&dev->vfd);
-err_m2m:
+err_media:
+	media_device_cleanup(&dev->mdev);
 	v4l2_m2m_release(dev->m2m_dev);
 err_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);


