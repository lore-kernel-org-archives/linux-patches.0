Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D4C14D29D;
	Fri,  6 Dec 2024 14:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495990; cv=none; b=o+Rgc4cm2TaQDWmqaioH+bDbwoJ6718ooK/LDX0tl8Tzi65MDmmxWdZlfzkIqO+jDQ2epsro9zgBQrXgYBD6LYI/8cJy0V5DnfuRsi/HQGewQSzQBq7EJTEPL+hThAM/BoTboxAmbwa8iOf1w+6BzcU5jXGUhVSPGQrxvv3rxBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495990; c=relaxed/simple;
	bh=i722dPi8l5s5O/2m2NTLZH543YHbmmB0cOqgDzFDtBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvM03ge8I3nvg/bbqNZyBjqzUB4z2v1ld/PdxmGCpn95O2atzQxrQq3BxMHId8iJa2zbFpgL4MKPgPlT4x+iy0szUKBwIbYQSPR8/peETB6TqrouBdNTBlTQyqqFZuzQJglZOudffzlQVpkZz5dVOhMpPRt1KDL6ciWex6cdPXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPv42w3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPv42w3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70B2C4CEDC;
	Fri,  6 Dec 2024 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495990;
	bh=i722dPi8l5s5O/2m2NTLZH543YHbmmB0cOqgDzFDtBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPv42w3aKVcE4vmvB/rOb7XwFb55nxelQywg/0L+ykNkkoMX3wSwn1cPLPRWUssPC
	 uvDQJNMSOjgQ5PfJUcfrjIgeG2MRBf6T16JWeii7zAaILW6wU7tJLkvIBLq6xeVPew
	 QiboXuCA64zhI2FqU0aUdBVz/8n67bxjFJANAvZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.12 021/146] media: imx-jpeg: Set video drvdata before register video device
Date: Fri,  6 Dec 2024 15:35:52 +0100
Message-ID: <20241206143528.482992590@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2842,6 +2842,7 @@ static int mxc_jpeg_probe(struct platfor
 	jpeg->dec_vdev->vfl_dir = VFL_DIR_M2M;
 	jpeg->dec_vdev->device_caps = V4L2_CAP_STREAMING |
 					V4L2_CAP_VIDEO_M2M_MPLANE;
+	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE) {
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_DECODER_CMD);
 		v4l2_disable_ioctl(jpeg->dec_vdev, VIDIOC_TRY_DECODER_CMD);
@@ -2854,7 +2855,6 @@ static int mxc_jpeg_probe(struct platfor
 		dev_err(dev, "failed to register video device\n");
 		goto err_vdev_register;
 	}
-	video_set_drvdata(jpeg->dec_vdev, jpeg);
 	if (mode == MXC_JPEG_ENCODE)
 		v4l2_info(&jpeg->v4l2_dev,
 			  "encoder device registered as /dev/video%d (%d,%d)\n",


