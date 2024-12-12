Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E775222D72;
	Thu, 12 Dec 2024 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021634; cv=none; b=B272GQ1SrXlKYJ3oEF5eFTr/2cAvdne5s27/kyIuBjxWPy+onReZ3wPgOx84yqGhbGy2dQdq1GKPidd7O2IcbZt3fHj+E6nNOoZGJpdNfX9XULChWFDHMONDi/hx4ir1GkEOqYd3xeYN4YupsvWWvxqXVeqLayH5B932AGsHn+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021634; c=relaxed/simple;
	bh=sM+NpPG3yJyA9PGZGgFOIWZemRk2CyBsr/cmKf8RQsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxlQNMfiXB+oDs1/4AuQHpWCk/7idSj1aU9gLGBSybXztRd61CLK8lYni8Snc58fVxRstWxmzU4SupM8duoWGKcTVCtm7CYyhWMfMgcRBlJHLOI8nry/qpmQJOyfBmzo5j+7TfWtz6tvExv5GNoYuHZ8f3+zoiLzOhpDvPcuVeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gs1DCG8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gs1DCG8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874A7C4CECE;
	Thu, 12 Dec 2024 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021633;
	bh=sM+NpPG3yJyA9PGZGgFOIWZemRk2CyBsr/cmKf8RQsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gs1DCG8YbOCXx62LzxJtJ4ta6xbhWsmgyMCPM8hGhCvWTyfk3u7LAoJqLfIN9B8OZ
	 mPckMUPcR1r4bG7dqgQuV2BTnqujSAoraSYK4drCZNB0p704b0m6gGzz6l/0UnNTIg
	 Vqe6UvnQXeA1NzSy9Y4s81pODDRD7yMld6hRdqtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 002/565] media: imx-jpeg: Set video drvdata before register video device
Date: Thu, 12 Dec 2024 15:53:17 +0100
Message-ID: <20241212144311.537114489@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/imx-jpeg/mxc-jpeg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -2155,6 +2155,7 @@ static int mxc_jpeg_probe(struct platfor
 	jpeg->dec_vdev->vfl_dir = VFL_DIR_M2M;
 	jpeg->dec_vdev->device_caps = V4L2_CAP_STREAMING |
 					V4L2_CAP_VIDEO_M2M_MPLANE;
+	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE) {
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_DECODER_CMD);
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_TRY_DECODER_CMD);
@@ -2167,7 +2168,6 @@ static int mxc_jpeg_probe(struct platfor
 		dev_err(dev, "failed to register video device\n");
 		goto err_vdev_register;
 	}
-	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE)
 		v4l2_info(&jpeg->v4l2_dev,
 			  "encoder device registered as /dev/video%d (%d,%d)\n",


