Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9D1205501;
	Thu, 12 Dec 2024 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020521; cv=none; b=WBTKy3QxJkXqy9rdtGn03Rn7/WlVQma8Fl2SATMMUlUVqBUTx1FqeeSg/WZhDR6lT2quK77d+F0IiaKikFLUMDoO1WyjgHva+UAdJaaSTmw3FZ9ky2b298JtHbhKOVPnkwb4tLNsVE9JmP5c9d+leiKixFg+gyneUzdxQLoSbnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020521; c=relaxed/simple;
	bh=yTtdragbncvIRJ+zN09+KkVoejArjbvcjRytYbBJKFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2ecf6Wx2DUXXEUPcfKeqDTOxcdTeB1/HAEJTv64GCDop+YYqe85hXL3ZvT3rbD+hquVFnj+E8lJ2wm8xLnEaZ/6+kI9WqbUDaeM+pfSxO3NuumSBE0z84yxzizupI0BXNYBb3Pzbrb3lh2ybG2vvByD7u1izMnCAiGkDfP8Z10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CA5w1kk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CA5w1kk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D45DC4CECE;
	Thu, 12 Dec 2024 16:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020521;
	bh=yTtdragbncvIRJ+zN09+KkVoejArjbvcjRytYbBJKFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CA5w1kk+az2A4lpq+V1Qeq2sAoLG16Qz5vJj+x9pMExpgvNT3lowcyMjHn2PeVfn5
	 TwN50mnkT7IYkP/KSRqKjZqMUboJtoK5a7JRTworjgLNEC2rLa5kNNrdZ4pOGLHPmP
	 Byq6ZRJeSCI89ShxqUFZlFmKAwISrYioofOL5w00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 458/772] media: imx-jpeg: Set video drvdata before register video device
Date: Thu, 12 Dec 2024 15:56:43 +0100
Message-ID: <20241212144408.852060942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
@@ -2252,6 +2252,7 @@ static int mxc_jpeg_probe(struct platfor
 	jpeg->dec_vdev->vfl_dir = VFL_DIR_M2M;
 	jpeg->dec_vdev->device_caps = V4L2_CAP_STREAMING |
 					V4L2_CAP_VIDEO_M2M_MPLANE;
+	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE) {
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_DECODER_CMD);
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_TRY_DECODER_CMD);
@@ -2264,7 +2265,6 @@ static int mxc_jpeg_probe(struct platfor
 		dev_err(dev, "failed to register video device\n");
 		goto err_vdev_register;
 	}
-	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE)
 		v4l2_info(&jpeg->v4l2_dev,
 			  "encoder device registered as /dev/video%d (%d,%d)\n",


