Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C5028DC4;
	Wed, 20 May 2026 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297147; cv=none; b=OjEgijKIDUhsiRmM0V1NsFATv05myLjXVix0HyzFb0hbtqlmK7BB5WPdQlTgtIwNc9HdfeujCt2fUgVkwZg8n8dusmQ4mVe0Un3s+FUt9z151LXf+Xp6dnezvbDZ80d6dlsFeT8xawwcyy1tuuN7N38UfujWH1YmxV29hQb/Nn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297147; c=relaxed/simple;
	bh=rde69B2c8cslsi3Q4FJW8dmH3+tcL01qhNKxRqzs4TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6SGJrEhRMVeNUPMor3peMftcFUiQIQQ2OEfQGBzmTE49s/DZ9KTv8+4FlT9sJDNluMmRpGgjdrbTv6Xjn+whAiC1Pr/Mbn6ZLNsQwJCPsKGvgH1DhIV8flWLeQSERzelSsikxThx75PBZ4wgZnoXsnxaAykKUwXG+AgfhBQ3sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f81DRM5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f81DRM5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FB01F000E9;
	Wed, 20 May 2026 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297146;
	bh=K34Kw7b5k5bxXhPXF2Pm3Ou36KoLNIcv/jv2fdwW84I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f81DRM5ztJDQi1K3p4JAmqzi42g4MxWV7TlGboclrYEM2o29YfM/GJ1E/pYIeAI6h
	 KmAswPKKkCWTDl134LVQri5+cuhcvm2ERgp+0NIVyb1sEAhBw566jJtGYKyLsgVNQ4
	 WNO+RepkurVpE3XZnZIUXvVTXWcmPhsokMPT2C8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Tretter <m.tretter@pengutronix.de>,
	Frank Li <Frank.Li@nxp.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1068/1146] media: staging: imx: configure src_mux in csi_start
Date: Wed, 20 May 2026 18:21:58 +0200
Message-ID: <20260520162212.401925482@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit ebeec2b000a90cd8aae86d1931ff5ef23af8284e ]

After media_pipeline_start() was called, the media graph is assumed to
be validated. It won't be validated again if a second stream starts.

The imx-media-csi driver, however, changes hardware configuration in the
link_validate() callback. This can result in started streams with
misconfigured hardware.

In the concrete example, the ipu2_csi1 is driven by a parallel video
input. After the media pipeline has been started with this
configuration, a second stream is configured to use ipu1_csi0 with
MIPI-CSI input from imx6-mipi-csi2. This may require the reconfiguration
of ipu1_csi0 with ipu_set_csi_src_mux(). Since the media pipeline is
already running, link_validate won't be called, and the ipu1_csi0 won't
be reconfigured. The resulting video is broken, because the ipu1_csi0 is
misconfigured, but no error is reported.

Move ipu_set_csi_src_mux from csi_link_validate to csi_start to ensure
that input to ipu1_csi0 is configured correctly when starting the
stream. This is a local reconfiguration in ipu1_csi0 and is possible
while the media pipeline is running.

Since csi_start() is called with priv->lock already locked,
csi_set_src() must not lock priv->lock again. Thus, the mutex_lock() is
dropped.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Fixes: 4a34ec8e470c ("[media] media: imx: Add CSI subdev driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-csi.c | 44 ++++++++++++-----------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 55a7d8f38465b..1bc644f73a9d1 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -744,6 +744,28 @@ static int csi_setup(struct csi_priv *priv,
 	return 0;
 }
 
+static void csi_set_src(struct csi_priv *priv,
+			struct v4l2_mbus_config *mbus_cfg)
+{
+	bool is_csi2;
+
+	is_csi2 = !is_parallel_bus(mbus_cfg);
+	if (is_csi2) {
+		/*
+		 * NOTE! It seems the virtual channels from the mipi csi-2
+		 * receiver are used only for routing by the video mux's,
+		 * or for hard-wired routing to the CSI's. Once the stream
+		 * enters the CSI's however, they are treated internally
+		 * in the IPU as virtual channel 0.
+		 */
+		ipu_csi_set_mipi_datatype(priv->csi, 0,
+					  &priv->format_mbus[CSI_SINK_PAD]);
+	}
+
+	/* select either parallel or MIPI-CSI2 as input to CSI */
+	ipu_set_csi_src_mux(priv->ipu, priv->csi_id, is_csi2);
+}
+
 static int csi_start(struct csi_priv *priv)
 {
 	struct v4l2_mbus_config mbus_cfg = { .type = 0 };
@@ -760,6 +782,8 @@ static int csi_start(struct csi_priv *priv)
 	input_fi = &priv->frame_interval[CSI_SINK_PAD];
 	output_fi = &priv->frame_interval[priv->active_output_pad];
 
+	csi_set_src(priv, &mbus_cfg);
+
 	/* start upstream */
 	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 1);
 	ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
@@ -1130,7 +1154,6 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_config mbus_cfg = { .type = 0 };
-	bool is_csi2;
 	int ret;
 
 	ret = v4l2_subdev_link_validate_default(sd, link,
@@ -1145,25 +1168,6 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 		return ret;
 	}
 
-	mutex_lock(&priv->lock);
-
-	is_csi2 = !is_parallel_bus(&mbus_cfg);
-	if (is_csi2) {
-		/*
-		 * NOTE! It seems the virtual channels from the mipi csi-2
-		 * receiver are used only for routing by the video mux's,
-		 * or for hard-wired routing to the CSI's. Once the stream
-		 * enters the CSI's however, they are treated internally
-		 * in the IPU as virtual channel 0.
-		 */
-		ipu_csi_set_mipi_datatype(priv->csi, 0,
-					  &priv->format_mbus[CSI_SINK_PAD]);
-	}
-
-	/* select either parallel or MIPI-CSI2 as input to CSI */
-	ipu_set_csi_src_mux(priv->ipu, priv->csi_id, is_csi2);
-
-	mutex_unlock(&priv->lock);
 	return ret;
 }
 
-- 
2.53.0



