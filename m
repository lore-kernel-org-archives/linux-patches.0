Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E257E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2638BC433C1;
	Wed,  2 Nov 2022 02:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357589;
	bh=EODslwQIf7jwAyXzWGFT5WByGSPUUFG2ES74JEytui0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMNFeaMoI8CGhaN+r8rL2hTbGFQ2/YNXmPJXA0EEHi3sthEPH8tX/SefWtRE5Z3f4
	 FgoskPU0ICsvf9t1CeAoVrbFfF+YQjoklyL3zDD06wz7eKOglXgh4VV+3Np66EMN6+
	 6hbQc2btq8081X4VaPxd+HwQKUxkgbHtOj1RxtME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 196/240] media: vivid: s_fbuf: add more sanity checks
Date: Wed,  2 Nov 2022 03:32:51 +0100
Message-Id: <20221102022115.828577171@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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
 drivers/media/test-drivers/vivid/vivid-core.c | 22 +++++++++++++++++++
 drivers/media/test-drivers/vivid/vivid-core.h |  2 ++
 .../media/test-drivers/vivid/vivid-vid-cap.c  |  9 +++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index 04b75666bad4..61d48fbc3d15 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -339,6 +339,28 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a
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
diff --git a/drivers/media/test-drivers/vivid/vivid-core.h b/drivers/media/test-drivers/vivid/vivid-core.h
index 176b72cb143b..5def9b2a359a 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.h
+++ b/drivers/media/test-drivers/vivid/vivid-core.h
@@ -610,4 +610,6 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
+bool vivid_validate_fb(const struct v4l2_framebuffer *a);
+
 #endif
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index b9caa4b26209..c9eb28b3a03d 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1272,7 +1272,14 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
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



