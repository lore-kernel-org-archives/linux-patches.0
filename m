Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A7B3914ED;
	Thu, 30 Jul 2026 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424453; cv=none; b=YJ0tpat8+ST799nH7HUqFD2Xi2AZZKswQ8XAAESml04wLz+D8pJzz2vJZpCeKNBLOzyW48JAghI23FO4b49SdgcPct6ohLmr+0/G3DbRx2zE0s/t1hjyR9MTTEbVVTkiqnbE7MXvY0PWIebeXwehCoYFhma7gg6Ou4qQxmU/zi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424453; c=relaxed/simple;
	bh=m8/kq07hwtlwHW043/N35PsOFLIEns+oI2xFhlebApw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZxyNn2k2mnDEt2dfvJg658ECLbLs+DwfpAhP4CdTiv/pak1DYUFclL5kQaoMAyl945ILMio2YcqtxfrXTLyPNuJzOLR/HsyBPtdD57XR6qp3sOcWc8KJeiCY/O4KtXEF4XVSNdxrW1xrC10zMWhzfNPZ8WNpLm57trN+Pe8bhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgJRleNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgJRleNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBB41F000E9;
	Thu, 30 Jul 2026 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424452;
	bh=VHlNQ1J3eW6Dp/NFDSYxQDxDmCv6Ka50wslOagKQBiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgJRleNS1h8/xOFpTp9fSR0h6WFYUG1mjjcKHgy+pV3fQXFNgyuHv3qJgm743C7uo
	 GbW5hfRvWnntImcaGtd06R6nNHl3qKAfgkSk/VHoeEFaZWdGA0HWmmQ5AEBOHH5I2Y
	 nHJHEhfXTEwkYC3lqxuTn2WXHuFkskV2oC2sNfRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 398/675] media: cedrus: clean up media device on probe failure
Date: Thu, 30 Jul 2026 16:12:08 +0200
Message-ID: <20260730141453.592988033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -507,7 +507,7 @@ static int cedrus_probe(struct platform_
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto err_m2m;
+		goto err_media;
 	}
 
 	v4l2_info(&dev->v4l2_dev,
@@ -533,7 +533,8 @@ err_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
 err_video:
 	video_unregister_device(&dev->vfd);
-err_m2m:
+err_media:
+	media_device_cleanup(&dev->mdev);
 	v4l2_m2m_release(dev->m2m_dev);
 err_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);


