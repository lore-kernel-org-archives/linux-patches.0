Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C8A147C7E;
	Thu, 11 Apr 2024 10:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831483; cv=none; b=NnuhsP7YoCsnsb9ArQZTdTBqq0sV0jeovVZZ4uc/reaOlEmmFlaVOSWyfeujwx8xvmCY3CS512sZFChR+yH/MK4Mt2+E7/G4O+is5Wzk+8brQ0zRydMg9akJ5u/BNXXfk1X+hj+/sj2yNGhpgMnvH6fnRvp4gXYEEzcgXU4XuXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831483; c=relaxed/simple;
	bh=WTMRbtje6f2gSETP4j55+hCk36EzdjWZ/+VaBDXglAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDbXcLukEhK0VJIwBs80UKYybOxGf0cUrAGu6AYnUteYSQVRof/sMzFfsMBBV9F3BVQi34G3x3dp8DsgetXSmnOxsSQcDdopx0K26U7xDK/Fs13bln6mE9ojT35YbIJG7et0upSOwOvsJBfmNRpfiBh9Pmy4AUItC8M4guIdiHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAjtK6b7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAjtK6b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB25C433F1;
	Thu, 11 Apr 2024 10:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831483;
	bh=WTMRbtje6f2gSETP4j55+hCk36EzdjWZ/+VaBDXglAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAjtK6b7IGcIGW7SCnj09NQNl4OSRG27cRDZuxWoV9X84P8pEdDOI193YYMyfu/eK
	 qPMBOBS05BVjsTe6h17surxxdNZ0uLZzEwNZIHpd3z5ZyEsITvnxKCaIQFUVVjtugo
	 2wdK/91bmk1cbr3yrBKdCTKA44vAn84kNxtwGwGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hidenori Kobayashi <hidenorik@chromium.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/294] media: staging: ipu3-imgu: Set fields before media_entity_pads_init()
Date: Thu, 11 Apr 2024 11:52:51 +0200
Message-ID: <20240411095435.888602891@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidenori Kobayashi <hidenorik@chromium.org>

[ Upstream commit 87318b7092670d4086bfec115a0280a60c51c2dd ]

The imgu driver fails to probe with the following message because it
does not set the pad's flags before calling media_entity_pads_init().

[   14.596315] ipu3-imgu 0000:00:05.0: failed initialize subdev media entity (-22)
[   14.596322] ipu3-imgu 0000:00:05.0: failed to register subdev0 ret (-22)
[   14.596327] ipu3-imgu 0000:00:05.0: failed to register pipes (-22)
[   14.596331] ipu3-imgu 0000:00:05.0: failed to create V4L2 devices (-22)

Fix the initialization order so that the driver probe succeeds. The ops
initialization is also moved together for readability.

Fixes: a0ca1627b450 ("media: staging/intel-ipu3: Add v4l2 driver based on media framework")
Cc: <stable@vger.kernel.org> # 6.7
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Hidenori Kobayashi <hidenorik@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 103f84466f6fc..371117b511e21 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -1063,6 +1063,11 @@ static int imgu_v4l2_subdev_register(struct imgu_device *imgu,
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	/* Initialize subdev media entity */
+	imgu_sd->subdev.entity.ops = &imgu_media_ops;
+	for (i = 0; i < IMGU_NODE_NUM; i++) {
+		imgu_sd->subdev_pads[i].flags = imgu_pipe->nodes[i].output ?
+			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
+	}
 	r = media_entity_pads_init(&imgu_sd->subdev.entity, IMGU_NODE_NUM,
 				   imgu_sd->subdev_pads);
 	if (r) {
@@ -1070,11 +1075,6 @@ static int imgu_v4l2_subdev_register(struct imgu_device *imgu,
 			"failed initialize subdev media entity (%d)\n", r);
 		return r;
 	}
-	imgu_sd->subdev.entity.ops = &imgu_media_ops;
-	for (i = 0; i < IMGU_NODE_NUM; i++) {
-		imgu_sd->subdev_pads[i].flags = imgu_pipe->nodes[i].output ?
-			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
-	}
 
 	/* Initialize subdev */
 	v4l2_subdev_init(&imgu_sd->subdev, &imgu_subdev_ops);
@@ -1169,15 +1169,15 @@ static int imgu_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
 	}
 
 	/* Initialize media entities */
+	node->vdev_pad.flags = node->output ?
+		MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
+	vdev->entity.ops = NULL;
 	r = media_entity_pads_init(&vdev->entity, 1, &node->vdev_pad);
 	if (r) {
 		dev_err(dev, "failed initialize media entity (%d)\n", r);
 		mutex_destroy(&node->lock);
 		return r;
 	}
-	node->vdev_pad.flags = node->output ?
-		MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
-	vdev->entity.ops = NULL;
 
 	/* Initialize vbq */
 	vbq->type = node->vdev_fmt.type;
-- 
2.43.0



