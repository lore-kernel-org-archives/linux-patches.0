Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8068B633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEE5C433D6;
	Wed,  2 Nov 2022 03:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359965;
	bh=T+e0r3n7zNdg4082UbrEg3ntzv5SD+KG8RD2FFIxk9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMmv6ejv/3jFrjhI2reQsYtN8e8pQ0NElFIYAOfsFfNfGPG28vWBCoZGLNW87oPDA
	 ejgtXPiZDiSfPX5FEcEVEhGR+f6/wtwwHHGk43NyrAgM1mFYIU193P5jG/N4Fx9fhA
	 SjlFUR8Tgs8lh3+3dlmNPiKsl8jChjWPx1ADSEM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 64/78] media: vivid: s_fbuf: add more sanity checks
Date: Wed,  2 Nov 2022 03:34:49 +0100
Message-Id: <20221102022054.831223648@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit f8bcaf714abfc94818dff8c0db84d750433984f4 ]

VIDIOC_S_FBUF is by definition a scary ioctl, which is why only root
can use it. But at least check if the framebuffer parameters match that
of one of the framebuffer created by vivid, and reject anything else.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: ef834f7836ec ([media] vivid: add the video capture and output parts)
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-core.c    | 22 ++++++++++++++++++++
 drivers/media/platform/vivid/vivid-core.h    |  2 ++
 drivers/media/platform/vivid/vivid-vid-cap.c |  9 +++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index b603ca412387..e8cd189ec9ef 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -297,6 +297,28 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a
 	return vivid_vid_out_g_fbuf(file, fh, a);
 }
 
+/*
+ * Only support the framebuffer of one of the vivid instances.
+ * Anything else is rejected.
+ */
+bool vivid_validate_fb(const struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev;
+	int i;
+
+	for (i = 0; i < n_devs; i++) {
+		dev = vivid_devs[i];
+		if (!dev || !dev->video_pbase)
+			continue;
+		if ((unsigned long)a->base == dev->video_pbase &&
+		    a->fmt.width <= dev->display_width &&
+		    a->fmt.height <= dev->display_height &&
+		    a->fmt.bytesperline <= dev->display_byte_stride)
+			return true;
+	}
+	return false;
+}
+
 static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a)
 {
 	struct video_device *vdev = video_devdata(file);
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index cd4c8230563c..6ea4448dfb7c 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -551,4 +551,6 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
+bool vivid_validate_fb(const struct v4l2_framebuffer *a);
+
 #endif
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index c58ae489f39c..30d9106624b9 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1240,7 +1240,14 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	if (a->fmt.bytesperline < (a->fmt.width * fmt->bit_depth[0]) / 8)
 		return -EINVAL;
-	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+	if (a->fmt.bytesperline > a->fmt.sizeimage / a->fmt.height)
+		return -EINVAL;
+
+	/*
+	 * Only support the framebuffer of one of the vivid instances.
+	 * Anything else is rejected.
+	 */
+	if (!vivid_validate_fb(a))
 		return -EINVAL;
 
 	dev->fb_vbase_cap = phys_to_virt((unsigned long)a->base);
-- 
2.35.1



