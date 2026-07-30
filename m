Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4052232B116;
	Thu, 30 Jul 2026 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424582; cv=none; b=ItN/28yaV/yyP9BpUyeT1r503KSLQGSeiIuwB4EL7rWW+Qzlv1c4gNyDn05UFOZtedfyXvclvceAK+g20NKkSVARG8n4nfnsHBnUqpmuAQ8F6nqEhf3o1amZgV1Z+gYrDCR8NQhiEvAYIsscVG1e+7BcGY0I3+JObWycBSOiKI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424582; c=relaxed/simple;
	bh=bVE/2WsuSVYtCqWjjuegxnKjfCDuBQ5mHMwzKN5Hj/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n916f94F9aQ4oTUNkoAwnbJpFTUKR9gzUlQjtU4NXAbv7SH1D5quEZ/L9y9HO7n+Xy5PlTWYAudcdWeT962e1scWznK1V+PJ2mvYPBiN1UVbzwrI1FwwJyotxK9+0WRzOypdud5LHlJLrZJ5bsjR4QmnVuA0D17Ucpwk83kXZ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwIt4OTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwIt4OTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAD31F000E9;
	Thu, 30 Jul 2026 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424580;
	bh=3pDZzjVNZtWRVc3WGvZ/vzr+XYb04qmyDiu/o5qEpCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwIt4OTZH2NxNs3nTOFiEdaxZI4caGAFSPhku/9rexZKzhW0eRsTZWjorEP+Q+bx6
	 sF8UPw0rGW8aAB3ONPCTOZvXE33fS43WRU2OHV8WWp964AClIJQEkpWMEw0mlOLPdx
	 KjVM1sVd8qzJs7uVejE4ORROVt+8g/ilc3wA5e5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 443/675] media: vivid: add vivid_update_reduced_fps()
Date: Thu, 30 Jul 2026 16:12:53 +0200
Message-ID: <20260730141454.554916241@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

commit 1d793a29efb4260f90913f5287939bf95573b073 upstream.

Don't call vivid_update_format_cap() when switching to/from reduced fps
for HDMI inputs: that will also reset the format, which is overkill for
this.

Make a new vivid_update_reduced_fps() function that just updates the
dev->timeperframe_vid_cap.

Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: c79aa6aeadb0 ("[media] vivid-capture: add control for reduced frame rate")
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-ctrls.c   |    3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c |   32 +++++++++++++----------
 drivers/media/test-drivers/vivid/vivid-vid-cap.h |    1 
 3 files changed, 22 insertions(+), 14 deletions(-)

--- a/drivers/media/test-drivers/vivid/vivid-ctrls.c
+++ b/drivers/media/test-drivers/vivid/vivid-ctrls.c
@@ -609,7 +609,8 @@ static int vivid_vid_cap_s_ctrl(struct v
 		break;
 	case VIVID_CID_REDUCED_FPS:
 		dev->reduced_fps = ctrl->val;
-		vivid_update_format_cap(dev, true);
+		if (dev->input_type[dev->input] == HDMI)
+			vivid_update_reduced_fps(dev);
 		break;
 	case VIVID_CID_HAS_CROP_CAP:
 		dev->has_crop_cap = ctrl->val;
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -362,6 +362,24 @@ static enum tpg_pixel_aspect vivid_get_p
 	return TPG_PIXEL_ASPECT_SQUARE;
 }
 
+void vivid_update_reduced_fps(struct vivid_dev *dev)
+{
+	struct v4l2_bt_timings *bt = &dev->dv_timings_cap[dev->input].bt;
+	unsigned int size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+	u64 pixelclock;
+
+	if (dev->reduced_fps && can_reduce_fps(bt)) {
+		pixelclock = div_u64(bt->pixelclock * 1000, 1001);
+		bt->flags |= V4L2_DV_FL_REDUCED_FPS;
+	} else {
+		pixelclock = bt->pixelclock;
+		bt->flags &= ~V4L2_DV_FL_REDUCED_FPS;
+	}
+	dev->timeperframe_vid_cap = (struct v4l2_fract) {
+		size / 100, (u32)pixelclock / 100
+	};
+}
+
 /*
  * Called whenever the format has to be reset which can occur when
  * changing inputs, standard, timings, etc.
@@ -370,8 +388,6 @@ void vivid_update_format_cap(struct vivi
 {
 	struct v4l2_bt_timings *bt = &dev->dv_timings_cap[dev->input].bt;
 	u32 dims[V4L2_CTRL_MAX_DIMS] = {};
-	unsigned size;
-	u64 pixelclock;
 
 	switch (dev->input_type[dev->input]) {
 	case WEBCAM:
@@ -400,17 +416,7 @@ void vivid_update_format_cap(struct vivi
 	case HDMI:
 		dev->src_rect.width = bt->width;
 		dev->src_rect.height = bt->height;
-		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
-		if (dev->reduced_fps && can_reduce_fps(bt)) {
-			pixelclock = div_u64(bt->pixelclock * 1000, 1001);
-			bt->flags |= V4L2_DV_FL_REDUCED_FPS;
-		} else {
-			pixelclock = bt->pixelclock;
-			bt->flags &= ~V4L2_DV_FL_REDUCED_FPS;
-		}
-		dev->timeperframe_vid_cap = (struct v4l2_fract) {
-			size / 100, (u32)pixelclock / 100
-		};
+		vivid_update_reduced_fps(dev);
 		if (bt->interlaced)
 			dev->field_cap = V4L2_FIELD_ALTERNATE;
 		else
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.h
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.h
@@ -9,6 +9,7 @@
 #define _VIVID_VID_CAP_H_
 
 void vivid_update_quality(struct vivid_dev *dev);
+void vivid_update_reduced_fps(struct vivid_dev *dev);
 void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls);
 void vivid_update_outputs(struct vivid_dev *dev);
 void vivid_update_connected_outputs(struct vivid_dev *dev);


