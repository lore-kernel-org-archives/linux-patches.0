Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514BB3DB95
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzJ4EXDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01269C433CA;
	Wed, 15 Nov 2023 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078442;
	bh=le7lGmXZRbaNeD5H7hfUQilQJV/Coth6+QR/OG++q3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzJ4EXDDxP3jYB0NaVmMQg29gX5MBxATGY3xoJkUuLGEDagEEc7KKy4aWgCtNpfAW
	 L/lj37DW19Rkp55f0ox8mZre2jQd3k+P/QJI0y8XkRQembHg06gwbnl1HwxewLwMFm
	 s+YqeGegyEcpNFw5qNtVMrIaHu6/08tUUr3P/DM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Katya Orlova <e.orlova@ispras.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 323/379] media: s3c-camif: Avoid inappropriate kfree()
Date: Wed, 15 Nov 2023 14:26:38 -0500
Message-ID: <20231115192704.259722876@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Katya Orlova <e.orlova@ispras.ru>

[ Upstream commit 61334819aca018c3416ee6c330a08a49c1524fc3 ]

s3c_camif_register_video_node() works with video_device structure stored
as a field of camif_vp, so it should not be kfreed.
But there is video_device_release() on error path that do it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
Signed-off-by: Katya Orlova <e.orlova@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/s3c-camif/camif-capture.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/samsung/s3c-camif/camif-capture.c b/drivers/media/platform/samsung/s3c-camif/camif-capture.c
index db106ebdf870a..bca3cae4dd8bb 100644
--- a/drivers/media/platform/samsung/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/samsung/s3c-camif/camif-capture.c
@@ -1132,12 +1132,12 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
 
 	ret = vb2_queue_init(q);
 	if (ret)
-		goto err_vd_rel;
+		return ret;
 
 	vp->pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_pads_init(&vfd->entity, 1, &vp->pad);
 	if (ret)
-		goto err_vd_rel;
+		return ret;
 
 	video_set_drvdata(vfd, vp);
 
@@ -1170,8 +1170,6 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
 	v4l2_ctrl_handler_free(&vp->ctrl_handler);
 err_me_cleanup:
 	media_entity_cleanup(&vfd->entity);
-err_vd_rel:
-	video_device_release(vfd);
 	return ret;
 }
 
-- 
2.42.0



