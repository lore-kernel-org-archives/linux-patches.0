Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC06375AC3;
	Thu, 30 Jul 2026 14:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422724; cv=none; b=f7Xjo+23l2AYqMzuoNwdE8/80JuVffCse3pi5sIyijKTL9PbZLvQzKaNa7WLjxHsQmRf75h+RMl3KBReuf4ZBjpVU/KVH9Rta6cizz9IOh/+mHZxsQ7IkfENbwIM81xAYc3cRF6ZZE52hh/YnjWDQgpLpXmXp4A3FrPLtp70128=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422724; c=relaxed/simple;
	bh=OoQWniEk1o/3dMh4iRX4wh9/VSEzn5WAvCdLF6wOQlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFBXCIRcLyArfzwLHcfd7VEiMKYMRdUnJ/dq3R5V324+dhZXjl886KlM10qdhj4CXziFBX232qKcMlpcrdboGWnceMbOeJ8T/R+1ZEMTMCt3zsqpUhtFvGNlNvPocnEVAjLHmTJZUHf60S98BBwNC5IZOvDVQNH1iASxYmd7GDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YaayjBbG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaayjBbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53591F000E9;
	Thu, 30 Jul 2026 14:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422723;
	bh=K8eEqsoaz7s/YFBeRqjBqL7cKj0B29lsUfB37m5LI9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaayjBbG3yDNRg8cYlA+CwL1lajiIOtBiKuJc4AFyj3hK5j6Tq/IoRPHzYDDd/gsU
	 o1WnVGHEv7yKHkJY0l0n5+P7ZoBnhIDYa4TdxC6T4/IbEMve0xyTslb29hqN6KNbLI
	 BmWfKSC0Xb6ZHU6I7le/H0kyA3cv0RpZwGKIpseg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 534/744] media: vivid: add vivid_update_reduced_fps()
Date: Thu, 30 Jul 2026 16:13:27 +0200
Message-ID: <20260730141455.622516524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -364,6 +364,24 @@ static enum tpg_pixel_aspect vivid_get_p
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
@@ -372,8 +390,6 @@ void vivid_update_format_cap(struct vivi
 {
 	struct v4l2_bt_timings *bt = &dev->dv_timings_cap[dev->input].bt;
 	u32 dims[V4L2_CTRL_MAX_DIMS] = {};
-	unsigned size;
-	u64 pixelclock;
 
 	switch (dev->input_type[dev->input]) {
 	case WEBCAM:
@@ -402,17 +418,7 @@ void vivid_update_format_cap(struct vivi
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


