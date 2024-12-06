Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35E253A7;
	Fri,  6 Dec 2024 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498525; cv=none; b=NXp5EGesOm7hodgJgB////24Jk5XvleASbTWFblolSbHKAmaNB5B0M5o+wf/PVvUUm1og3tHL68i1q9VjTLglQIutY9fl3KJ5/du9xxGRSBKcgSiGQq6U4rnaCnswC7ZZ0oqwmhn+qfj0L5TUuwa7JENKtmlicVAIwa99dzTT3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498525; c=relaxed/simple;
	bh=VCK6Js+KTQstFwdeAsjzAySp7h1OprLCdx8YobiQPIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOQmky4M4Y9k/EPxIFGVJHjt20EBEFfLygeNKhKZxuIVfh7i4H03b5+fyuROFGSz2IvHDFo5fZp5laQGGLQO8rTwK9oHkBOQxgJUE7elFtIE2/YizOdsDdJrrjbYpcvDNWsjPIrXFJe3n2VjGp/rtJnu9jAkmkL//3kJHm4ylyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChuQYZRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChuQYZRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1CAC4CED1;
	Fri,  6 Dec 2024 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498525;
	bh=VCK6Js+KTQstFwdeAsjzAySp7h1OprLCdx8YobiQPIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChuQYZRQhWhZELQFRXyM/qW/5lwtBRIoyixuuBHV/VWALcUs94AIjGf3OhQxINgSA
	 lUNgc1QTtrVEsz/dHpGGv5f8QIjf4wU/MpNLL9YOupAJtd0cDrhoTwAHWgljW4Nrxb
	 0uxq8vrEHa4GBQ4WSiWupQl40xWiIEjIMrM01KhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 610/676] media: imx-jpeg: Set video drvdata before register video device
Date: Fri,  6 Dec 2024 15:37:09 +0100
Message-ID: <20241206143717.200296973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

commit d2b7ecc26bd5406d5ba927be1748aa99c568696c upstream.

The video drvdata should be set before the video device is registered,
otherwise video_drvdata() may return NULL in the open() file ops, and led
to oops.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: TaoJiang <tao.jiang_2@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -2837,6 +2837,7 @@ static int mxc_jpeg_probe(struct platfor
 	jpeg->dec_vdev->vfl_dir = VFL_DIR_M2M;
 	jpeg->dec_vdev->device_caps = V4L2_CAP_STREAMING |
 					V4L2_CAP_VIDEO_M2M_MPLANE;
+	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE) {
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_DECODER_CMD);
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_TRY_DECODER_CMD);
@@ -2849,7 +2850,6 @@ static int mxc_jpeg_probe(struct platfor
 		dev_err(dev, "failed to register video device\n");
 		goto err_vdev_register;
 	}
-	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE)
 		v4l2_info(&jpeg->v4l2_dev,
 			  "encoder device registered as /dev/video%d (%d,%d)\n",


