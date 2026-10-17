Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC8138F658;
	Sat, 17 Oct 2026 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254254; cv=none; b=Klt3JTBaDB6nFJ+3aLTJgC1vyMLD7lk0hiLfTPOtxGxs0+Qqgp3mGE6VJF64lZhbWIOr1SphpYG/ghvsyXVITe3N/B9f2V2tsTBQtemH9GX7Ps2EHc1Dc6Hb08cKSnSM7CBqdpAXsQQps2j/nu8JkjwJ5vj6f7n1trVn2rDBkhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254254; c=relaxed/simple;
	bh=4Q76f446N/dOyE1DrRiLIH2Gq4FG+Q/TuwMf4FxcGvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/8EZtbq6Mk/49LiqgD2ZeGJBiEvZFf++c4w8Q14NT0rjd7Q2LbkO7TwmISnO6VO1C8d4OtkH6LakLxpO7IZ8ARpeq87z+G1eQNaEw4f8V2fQMpCVelci9qkOJwT+Js0m0aqtdhBadmUF00uViAuTQufI4wcqOel+IiGFyANYok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7p2b3Y0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7p2b3Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0691F000C4;
	Sat, 17 Oct 2026 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254253;
	bh=8MhnSoX3ivITsgsuCRjQEwyMLxONcRGdT4fNqzPrSos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7p2b3Y0cSNfXPBnl9qgK2yREiMxKA7ac3rh6d9AI4cjq1yfn3BFH9+RMMLpMD2Tq
	 ZZudfvidBTQbl5dRY6M1RptIT2jGc0sjoOpXHdEuCIxOfobA9B9dUOvUI4Ohm98V9C
	 qwnWlHgwvd5ZT97Opi9LYbmBWRsP8melL3U2Uslo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/869] media: stm32: dcmipp: replace s_stream with enable/disable_streams
Date: Sat, 17 Oct 2026 17:53:40 +0200
Message-ID: <20261017160046.832659527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit b0f3cc70893289d0d74a1523e26d60346f747ebe ]

Replace s_stream ops with enable_streams and disable_streams.
At the same time, use v4l2_subdev_enable_streams and
v4l2_subdev_disable_streams functions instead of
direct s_stream calls.

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: ffc8eec06378 ("media: stm32-dcmipp: Return queued buffers on start_streaming() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../st/stm32/stm32-dcmipp/dcmipp-bytecap.c    |  49 ++++----
 .../st/stm32/stm32-dcmipp/dcmipp-byteproc.c   |  98 +++++++++-------
 .../st/stm32/stm32-dcmipp/dcmipp-parallel.c   | 107 ++++++++++--------
 3 files changed, 139 insertions(+), 115 deletions(-)

diff --git a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
index b461d86bed540..2b323dd6cf6bf 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
@@ -112,6 +112,7 @@ struct dcmipp_bytecap_device {
 	u32 sequence;
 	struct media_pipeline pipe;
 	struct v4l2_subdev *s_subdev;
+	u32 s_subdev_pad_nb;
 
 	enum dcmipp_state state;
 
@@ -337,33 +338,6 @@ static const struct v4l2_ioctl_ops dcmipp_bytecap_ioctl_ops = {
 	.vidioc_streamoff = vb2_ioctl_streamoff,
 };
 
-static int dcmipp_pipeline_s_stream(struct dcmipp_bytecap_device *vcap,
-				    int state)
-{
-	struct media_pad *pad;
-	int ret;
-
-	/*
-	 * Get source subdev - since link is IMMUTABLE, pointer is cached
-	 * within the dcmipp_bytecap_device structure
-	 */
-	if (!vcap->s_subdev) {
-		pad = media_pad_remote_pad_first(&vcap->vdev.entity.pads[0]);
-		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
-			return -EINVAL;
-		vcap->s_subdev = media_entity_to_v4l2_subdev(pad->entity);
-	}
-
-	ret = v4l2_subdev_call(vcap->s_subdev, video, s_stream, state);
-	if (ret < 0) {
-		dev_err(vcap->dev, "failed to %s streaming (%d)\n",
-			state ? "start" : "stop", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
 static void dcmipp_start_capture(struct dcmipp_bytecap_device *vcap,
 				 struct dcmipp_buf *buf)
 {
@@ -395,11 +369,24 @@ static int dcmipp_bytecap_start_streaming(struct vb2_queue *vq,
 	struct dcmipp_bytecap_device *vcap = vb2_get_drv_priv(vq);
 	struct media_entity *entity = &vcap->vdev.entity;
 	struct dcmipp_buf *buf;
+	struct media_pad *pad;
 	int ret;
 
 	vcap->sequence = 0;
 	memset(&vcap->count, 0, sizeof(vcap->count));
 
+	/*
+	 * Get source subdev - since link is IMMUTABLE, pointer is cached
+	 * within the dcmipp_bytecap_device structure
+	 */
+	if (!vcap->s_subdev) {
+		pad = media_pad_remote_pad_first(&vcap->vdev.entity.pads[0]);
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			return -EINVAL;
+		vcap->s_subdev = media_entity_to_v4l2_subdev(pad->entity);
+		vcap->s_subdev_pad_nb = pad->index;
+	}
+
 	ret = pm_runtime_resume_and_get(vcap->dev);
 	if (ret < 0) {
 		dev_err(vcap->dev, "%s: Failed to start streaming, cannot get sync (%d)\n",
@@ -414,7 +401,8 @@ static int dcmipp_bytecap_start_streaming(struct vb2_queue *vq,
 		goto err_pm_put;
 	}
 
-	ret = dcmipp_pipeline_s_stream(vcap, 1);
+	ret = v4l2_subdev_enable_streams(vcap->s_subdev,
+					 vcap->s_subdev_pad_nb, BIT_ULL(0));
 	if (ret)
 		goto err_media_pipeline_stop;
 
@@ -482,7 +470,10 @@ static void dcmipp_bytecap_stop_streaming(struct vb2_queue *vq)
 	int ret;
 	u32 status;
 
-	dcmipp_pipeline_s_stream(vcap, 0);
+	ret = v4l2_subdev_disable_streams(vcap->s_subdev,
+					  vcap->s_subdev_pad_nb, BIT_ULL(0));
+	if (ret)
+		dev_warn(vcap->dev, "Failed to disable stream\n");
 
 	/* Stop the media pipeline */
 	media_pipeline_stop(vcap->vdev.entity.pads);
diff --git a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-byteproc.c b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-byteproc.c
index 50500112eab9a..a19c8235af565 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-byteproc.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-byteproc.c
@@ -380,30 +380,19 @@ static int dcmipp_byteproc_set_selection(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static const struct v4l2_subdev_pad_ops dcmipp_byteproc_pad_ops = {
-	.enum_mbus_code		= dcmipp_byteproc_enum_mbus_code,
-	.enum_frame_size	= dcmipp_byteproc_enum_frame_size,
-	.get_fmt		= v4l2_subdev_get_fmt,
-	.set_fmt		= dcmipp_byteproc_set_fmt,
-	.get_selection		= dcmipp_byteproc_get_selection,
-	.set_selection		= dcmipp_byteproc_set_selection,
-};
-
 static int dcmipp_byteproc_configure_scale_crop
-			(struct dcmipp_byteproc_device *byteproc)
+			(struct dcmipp_byteproc_device *byteproc,
+			 struct v4l2_subdev_state *state)
 {
 	const struct dcmipp_byteproc_pix_map *vpix;
-	struct v4l2_subdev_state *state;
 	struct v4l2_mbus_framefmt *sink_fmt;
 	u32 hprediv, vprediv;
 	struct v4l2_rect *compose, *crop;
 	u32 val = 0;
 
-	state = v4l2_subdev_lock_and_get_active_state(&byteproc->sd);
 	sink_fmt = v4l2_subdev_state_get_format(state, 0);
 	compose = v4l2_subdev_state_get_compose(state, 0);
 	crop = v4l2_subdev_state_get_crop(state, 1);
-	v4l2_subdev_unlock_state(state);
 
 	/* find output format bpp */
 	vpix = dcmipp_byteproc_pix_map_by_code(sink_fmt->code);
@@ -458,46 +447,73 @@ static int dcmipp_byteproc_configure_scale_crop
 	return 0;
 }
 
-static int dcmipp_byteproc_s_stream(struct v4l2_subdev *sd, int enable)
+static int dcmipp_byteproc_enable_streams(struct v4l2_subdev *sd,
+					  struct v4l2_subdev_state *state,
+					  u32 pad, u64 streams_mask)
 {
 	struct dcmipp_byteproc_device *byteproc = v4l2_get_subdevdata(sd);
 	struct v4l2_subdev *s_subdev;
-	struct media_pad *pad;
-	int ret = 0;
+	struct media_pad *s_pad;
+	int ret;
 
 	/* Get source subdev */
-	pad = media_pad_remote_pad_first(&sd->entity.pads[0]);
-	if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+	s_pad = media_pad_remote_pad_first(&sd->entity.pads[0]);
+	if (!s_pad || !is_media_entity_v4l2_subdev(s_pad->entity))
 		return -EINVAL;
-	s_subdev = media_entity_to_v4l2_subdev(pad->entity);
-
-	if (enable) {
-		ret = dcmipp_byteproc_configure_scale_crop(byteproc);
-		if (ret)
-			return ret;
-
-		ret = v4l2_subdev_call(s_subdev, video, s_stream, enable);
-		if (ret < 0) {
-			dev_err(byteproc->dev,
-				"failed to start source subdev streaming (%d)\n",
-				ret);
-			return ret;
-		}
-	} else {
-		ret = v4l2_subdev_call(s_subdev, video, s_stream, enable);
-		if (ret < 0) {
-			dev_err(byteproc->dev,
-				"failed to stop source subdev streaming (%d)\n",
-				ret);
-			return ret;
-		}
+	s_subdev = media_entity_to_v4l2_subdev(s_pad->entity);
+
+	ret = dcmipp_byteproc_configure_scale_crop(byteproc, state);
+	if (ret)
+		return ret;
+
+	ret = v4l2_subdev_enable_streams(s_subdev, s_pad->index, BIT_ULL(0));
+	if (ret < 0) {
+		dev_err(byteproc->dev,
+			"failed to start source subdev streaming (%d)\n", ret);
+		return ret;
 	}
 
 	return 0;
 }
 
+static int dcmipp_byteproc_disable_streams(struct v4l2_subdev *sd,
+					   struct v4l2_subdev_state *state,
+					   u32 pad, u64 streams_mask)
+{
+	struct dcmipp_byteproc_device *byteproc = v4l2_get_subdevdata(sd);
+	struct v4l2_subdev *s_subdev;
+	struct media_pad *s_pad;
+	int ret;
+
+	/* Get source subdev */
+	s_pad = media_pad_remote_pad_first(&sd->entity.pads[0]);
+	if (!s_pad || !is_media_entity_v4l2_subdev(s_pad->entity))
+		return -EINVAL;
+	s_subdev = media_entity_to_v4l2_subdev(s_pad->entity);
+
+	ret = v4l2_subdev_disable_streams(s_subdev, s_pad->index, BIT_ULL(0));
+	if (ret < 0) {
+		dev_err(byteproc->dev,
+			"failed to start source subdev streaming (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops dcmipp_byteproc_pad_ops = {
+	.enum_mbus_code		= dcmipp_byteproc_enum_mbus_code,
+	.enum_frame_size	= dcmipp_byteproc_enum_frame_size,
+	.get_fmt		= v4l2_subdev_get_fmt,
+	.set_fmt		= dcmipp_byteproc_set_fmt,
+	.get_selection		= dcmipp_byteproc_get_selection,
+	.set_selection		= dcmipp_byteproc_set_selection,
+	.enable_streams		= dcmipp_byteproc_enable_streams,
+	.disable_streams	= dcmipp_byteproc_disable_streams,
+};
+
 static const struct v4l2_subdev_video_ops dcmipp_byteproc_video_ops = {
-	.s_stream = dcmipp_byteproc_s_stream,
+	.s_stream = v4l2_subdev_s_stream_helper,
 };
 
 static const struct v4l2_subdev_ops dcmipp_byteproc_ops = {
diff --git a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-parallel.c b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-parallel.c
index 05e8897ae37a4..823c9da336a7f 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-parallel.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-parallel.c
@@ -260,18 +260,11 @@ static int dcmipp_par_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static const struct v4l2_subdev_pad_ops dcmipp_par_pad_ops = {
-	.enum_mbus_code		= dcmipp_par_enum_mbus_code,
-	.enum_frame_size	= dcmipp_par_enum_frame_size,
-	.get_fmt		= v4l2_subdev_get_fmt,
-	.set_fmt		= dcmipp_par_set_fmt,
-};
-
-static int dcmipp_par_configure(struct dcmipp_par_device *par)
+static int dcmipp_par_configure(struct dcmipp_par_device *par,
+				struct v4l2_subdev_state *state)
 {
 	u32 val = 0;
 	const struct dcmipp_par_pix_map *vpix;
-	struct v4l2_subdev_state *state;
 	struct v4l2_mbus_framefmt *sink_fmt;
 	struct v4l2_mbus_framefmt *src_fmt;
 
@@ -305,10 +298,8 @@ static int dcmipp_par_configure(struct dcmipp_par_device *par)
 	}
 
 	/* Set format */
-	state = v4l2_subdev_lock_and_get_active_state(&par->sd);
 	sink_fmt = v4l2_subdev_state_get_format(state, 0);
 	src_fmt = v4l2_subdev_state_get_format(state, 1);
-	v4l2_subdev_unlock_state(state);
 
 	vpix = dcmipp_par_pix_map_by_code(sink_fmt->code, src_fmt->code);
 	if (!vpix) {
@@ -327,53 +318,79 @@ static int dcmipp_par_configure(struct dcmipp_par_device *par)
 	return 0;
 }
 
-static int dcmipp_par_s_stream(struct v4l2_subdev *sd, int enable)
+static int dcmipp_par_enable_streams(struct v4l2_subdev *sd,
+				     struct v4l2_subdev_state *state,
+				     u32 pad, u64 streams_mask)
 {
 	struct dcmipp_par_device *par =
 				container_of(sd, struct dcmipp_par_device, sd);
 	struct v4l2_subdev *s_subdev;
-	struct media_pad *pad;
-	int ret = 0;
+	struct media_pad *s_pad;
+	int ret;
 
 	/* Get source subdev */
-	pad = media_pad_remote_pad_first(&sd->entity.pads[0]);
-	if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+	s_pad = media_pad_remote_pad_first(&sd->entity.pads[0]);
+	if (!s_pad || !is_media_entity_v4l2_subdev(s_pad->entity))
 		return -EINVAL;
-	s_subdev = media_entity_to_v4l2_subdev(pad->entity);
-
-	if (enable) {
-		ret = dcmipp_par_configure(par);
-		if (ret)
-			return ret;
-
-		/* Enable parallel interface */
-		reg_set(par, DCMIPP_PRCR, DCMIPP_PRCR_ENABLE);
-
-		ret = v4l2_subdev_call(s_subdev, video, s_stream, enable);
-		if (ret < 0) {
-			dev_err(par->dev,
-				"failed to start source subdev streaming (%d)\n",
-				ret);
-			return ret;
-		}
-	} else {
-		ret = v4l2_subdev_call(s_subdev, video, s_stream, enable);
-		if (ret < 0) {
-			dev_err(par->dev,
-				"failed to stop source subdev streaming (%d)\n",
-				ret);
-			return ret;
-		}
+	s_subdev = media_entity_to_v4l2_subdev(s_pad->entity);
+
+	ret = dcmipp_par_configure(par, state);
+	if (ret)
+		return ret;
+
+	/* Enable parallel interface */
+	reg_set(par, DCMIPP_PRCR, DCMIPP_PRCR_ENABLE);
 
-		/* Disable parallel interface */
-		reg_clear(par, DCMIPP_PRCR, DCMIPP_PRCR_ENABLE);
+	ret = v4l2_subdev_enable_streams(s_subdev, s_pad->index, BIT_ULL(0));
+	if (ret < 0) {
+		dev_err(par->dev,
+			"failed to start source subdev streaming (%d)\n", ret);
+		return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
+static int dcmipp_par_disable_streams(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_state *state,
+				      u32 pad, u64 streams_mask)
+{
+	struct dcmipp_par_device *par =
+				container_of(sd, struct dcmipp_par_device, sd);
+	struct v4l2_subdev *s_subdev;
+	struct media_pad *s_pad;
+	int ret;
+
+	/* Get source subdev */
+	s_pad = media_pad_remote_pad_first(&sd->entity.pads[0]);
+	if (!s_pad || !is_media_entity_v4l2_subdev(s_pad->entity))
+		return -EINVAL;
+	s_subdev = media_entity_to_v4l2_subdev(s_pad->entity);
+
+	ret = v4l2_subdev_disable_streams(s_subdev, s_pad->index, BIT_ULL(0));
+	if (ret < 0) {
+		dev_err(par->dev,
+			"failed to stop source subdev streaming (%d)\n", ret);
+		return ret;
+	}
+
+	/* Disable parallel interface */
+	reg_clear(par, DCMIPP_PRCR, DCMIPP_PRCR_ENABLE);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops dcmipp_par_pad_ops = {
+	.enum_mbus_code		= dcmipp_par_enum_mbus_code,
+	.enum_frame_size	= dcmipp_par_enum_frame_size,
+	.get_fmt		= v4l2_subdev_get_fmt,
+	.set_fmt		= dcmipp_par_set_fmt,
+	.enable_streams		= dcmipp_par_enable_streams,
+	.disable_streams	= dcmipp_par_disable_streams,
+};
+
 static const struct v4l2_subdev_video_ops dcmipp_par_video_ops = {
-	.s_stream = dcmipp_par_s_stream,
+	.s_stream = v4l2_subdev_s_stream_helper,
 };
 
 static const struct v4l2_subdev_ops dcmipp_par_ops = {
-- 
2.53.0



