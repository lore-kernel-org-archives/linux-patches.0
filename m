Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B80F1FA8
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 08:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A75C433EF;
	Fri, 30 Dec 2022 08:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672388566;
	bh=xuLvn5VXetaoJQNLXRFKDPKG6AlhDaefnP0aYcDA9VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtzJowAtFjIKLtwp/gFbqWKCU3PC9vA8VA1GoVSoCBRa8TuAbJTNEtFgrun6yO9+Y
	 +T3Jz6/jJQaaT6zOpnyp0GmTApbJtXfliwzuglzySk+fwDlKVOEQ0aTnx/jOb6K1EW
	 Q/GhutFbJLGUz3LliT88agvShGshe6G+a9K6blTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0408/1146] media: sun6i-mipi-csi2: Register async subdev with no sensor attached
Date: Wed, 28 Dec 2022 15:32:27 +0100
Message-Id: <20221228144341.248143341@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 67182951f1dde5a88479cf8befee5f32ea014a49 ]

This allows the device to probe and register its async subdev without
a sensor attached.

The rationale is that the parent driver might otherwise wait for the
subdev to be registered when it should be available (from the fwnode
graph endpoint perspective). This is generally not problematic when
the MIPI CSI-2 bridge is the only device attached to the parent, but
in the case of a CSI controller that can feed from both MIPI CSI-2
and parallel, it would prevent using the parallel sensor due to the
parent waiting for the MIPI CSI-2 subdev to register.

Fixes: af54b4f4c17f ("media: sunxi: Add support for the A31 MIPI CSI-2 controller")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c     | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
index 340380a5f66f..484ac5f054d5 100644
--- a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
+++ b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
@@ -498,6 +498,7 @@ static int sun6i_mipi_csi2_bridge_setup(struct sun6i_mipi_csi2_device *csi2_dev)
 	struct v4l2_async_notifier *notifier = &bridge->notifier;
 	struct media_pad *pads = bridge->pads;
 	struct device *dev = csi2_dev->dev;
+	bool notifier_registered = false;
 	int ret;
 
 	mutex_init(&bridge->lock);
@@ -535,12 +536,17 @@ static int sun6i_mipi_csi2_bridge_setup(struct sun6i_mipi_csi2_device *csi2_dev)
 	notifier->ops = &sun6i_mipi_csi2_notifier_ops;
 
 	ret = sun6i_mipi_csi2_bridge_source_setup(csi2_dev);
-	if (ret)
+	if (ret && ret != -ENODEV)
 		goto error_v4l2_notifier_cleanup;
 
-	ret = v4l2_async_subdev_nf_register(subdev, notifier);
-	if (ret < 0)
-		goto error_v4l2_notifier_cleanup;
+	/* Only register the notifier when a sensor is connected. */
+	if (ret != -ENODEV) {
+		ret = v4l2_async_subdev_nf_register(subdev, notifier);
+		if (ret < 0)
+			goto error_v4l2_notifier_cleanup;
+
+		notifier_registered = true;
+	}
 
 	/* V4L2 Subdev */
 
@@ -551,7 +557,8 @@ static int sun6i_mipi_csi2_bridge_setup(struct sun6i_mipi_csi2_device *csi2_dev)
 	return 0;
 
 error_v4l2_notifier_unregister:
-	v4l2_async_nf_unregister(notifier);
+	if (notifier_registered)
+		v4l2_async_nf_unregister(notifier);
 
 error_v4l2_notifier_cleanup:
 	v4l2_async_nf_cleanup(notifier);
-- 
2.35.1



