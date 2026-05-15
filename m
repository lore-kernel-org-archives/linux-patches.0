Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B643F660B;
	Fri, 15 May 2026 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862490; cv=none; b=UW5q9DWeUKOP1w9fwzX24UqwH9LbN/M/pEUrzbFsDNMCBJ1GQM43MNOcHpqU78ENMV+bprFyWZfeBcHHkBkzNyNz3TVFbe/lpWEFGfDNtTwLLWR1PYhw/evSrZ4wviTI1kCLxmkRU8p/p3st4we+/pFaEr/1+ROKD49rl0r/CIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862490; c=relaxed/simple;
	bh=nHtO+HOR7Bv56PZOVtyB1FWQ0e5X8j4riF2hAPQJbMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKiWwZSrQZrExQGyHs30jdx4fhyxGsCKzyGZvOhJFxcfa2uaBSND+7OXiiLVZXkd2fPN1271cygK+29hW4bjOolBnpsWMQ1t/OM6lbfsa/kOIC8/V/Vq9t4BDn05GkrD9gz+yEZyZoCygNv+PLND43oTP1LqZzhm67Riuq0V44Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQaayzrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQaayzrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C43AC2BCB0;
	Fri, 15 May 2026 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862490;
	bh=nHtO+HOR7Bv56PZOVtyB1FWQ0e5X8j4riF2hAPQJbMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQaayzrEzZndOACCPjw8bAr33cbfPxRb27EdWXivRj4emvqRivDBq7LQnu9lgVnwO
	 JByDjxOqa9TiEuThCvcYan5NtlWt+khELOTxyQ7GN1buk8VHnZLV+Gd6+0WxFtThvJ
	 FHp5TLT0HlDkbGP/R5HMWBxjdUM2M5Jx/rbp7R6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 068/201] media: staging: imx: request mbus_config in csi_start
Date: Fri, 15 May 2026 17:48:06 +0200
Message-ID: <20260515154700.007364693@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

commit 9df2aaa64890c0b6226057eb6fcb6352bd2df432 upstream.

Request the upstream mbus_config in csi_start, which starts the stream,
instead of caching it in link_validate.

This allows to get rid of the mbus_cfg field in the struct csi_priv and
avoids state in the driver.

Fixes: 4a34ec8e470c ("[media] media: imx: Add CSI subdev driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/imx/imx-media-csi.c |   40 ++++++++++++++++++------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -97,9 +97,6 @@ struct csi_priv {
 	/* the mipi virtual channel number at link validate */
 	int vc_num;
 
-	/* media bus config of the upstream subdevice CSI is receiving from */
-	struct v4l2_mbus_config mbus_cfg;
-
 	spinlock_t irqlock; /* protect eof_irq handler */
 	struct timer_list eof_timeout_timer;
 	int eof_irq;
@@ -403,7 +400,8 @@ static void csi_idmac_unsetup_vb2_buf(st
 }
 
 /* init the SMFC IDMAC channel */
-static int csi_idmac_setup_channel(struct csi_priv *priv)
+static int csi_idmac_setup_channel(struct csi_priv *priv,
+				   struct v4l2_mbus_config *mbus_cfg)
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
 	const struct imx_media_pixfmt *incc;
@@ -432,7 +430,7 @@ static int csi_idmac_setup_channel(struc
 	image.phys0 = phys[0];
 	image.phys1 = phys[1];
 
-	passthrough = requires_passthrough(&priv->mbus_cfg, infmt, incc);
+	passthrough = requires_passthrough(mbus_cfg, infmt, incc);
 	passthrough_cycles = 1;
 
 	/*
@@ -572,11 +570,12 @@ static void csi_idmac_unsetup(struct csi
 	csi_idmac_unsetup_vb2_buf(priv, state);
 }
 
-static int csi_idmac_setup(struct csi_priv *priv)
+static int csi_idmac_setup(struct csi_priv *priv,
+			   struct v4l2_mbus_config *mbus_cfg)
 {
 	int ret;
 
-	ret = csi_idmac_setup_channel(priv);
+	ret = csi_idmac_setup_channel(priv, mbus_cfg);
 	if (ret)
 		return ret;
 
@@ -595,7 +594,8 @@ static int csi_idmac_setup(struct csi_pr
 	return 0;
 }
 
-static int csi_idmac_start(struct csi_priv *priv)
+static int csi_idmac_start(struct csi_priv *priv,
+			   struct v4l2_mbus_config *mbus_cfg)
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
 	int ret;
@@ -619,7 +619,7 @@ static int csi_idmac_start(struct csi_pr
 	priv->last_eof = false;
 	priv->nfb4eof = false;
 
-	ret = csi_idmac_setup(priv);
+	ret = csi_idmac_setup(priv, mbus_cfg);
 	if (ret) {
 		v4l2_err(&priv->sd, "csi_idmac_setup failed: %d\n", ret);
 		goto out_free_dma_buf;
@@ -701,7 +701,8 @@ static void csi_idmac_stop(struct csi_pr
 }
 
 /* Update the CSI whole sensor and active windows */
-static int csi_setup(struct csi_priv *priv)
+static int csi_setup(struct csi_priv *priv,
+		     struct v4l2_mbus_config *mbus_cfg)
 {
 	struct v4l2_mbus_framefmt *infmt, *outfmt;
 	const struct imx_media_pixfmt *incc;
@@ -719,7 +720,7 @@ static int csi_setup(struct csi_priv *pr
 	 * if cycles is set, we need to handle this over multiple cycles as
 	 * generic/bayer data
 	 */
-	if (is_parallel_bus(&priv->mbus_cfg) && incc->cycles) {
+	if (is_parallel_bus(mbus_cfg) && incc->cycles) {
 		if_fmt.width *= incc->cycles;
 		crop.width *= incc->cycles;
 	}
@@ -730,7 +731,7 @@ static int csi_setup(struct csi_priv *pr
 			     priv->crop.width == 2 * priv->compose.width,
 			     priv->crop.height == 2 * priv->compose.height);
 
-	ipu_csi_init_interface(priv->csi, &priv->mbus_cfg, &if_fmt, outfmt);
+	ipu_csi_init_interface(priv->csi, mbus_cfg, &if_fmt, outfmt);
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
@@ -745,9 +746,17 @@ static int csi_setup(struct csi_priv *pr
 
 static int csi_start(struct csi_priv *priv)
 {
+	struct v4l2_mbus_config mbus_cfg = { .type = 0 };
 	struct v4l2_fract *input_fi, *output_fi;
 	int ret;
 
+	ret = csi_get_upstream_mbus_config(priv, &mbus_cfg);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "failed to get upstream media bus configuration\n");
+		return ret;
+	}
+
 	input_fi = &priv->frame_interval[CSI_SINK_PAD];
 	output_fi = &priv->frame_interval[priv->active_output_pad];
 
@@ -758,7 +767,7 @@ static int csi_start(struct csi_priv *pr
 		return ret;
 
 	/* Skip first few frames from a BT.656 source */
-	if (priv->mbus_cfg.type == V4L2_MBUS_BT656) {
+	if (mbus_cfg.type == V4L2_MBUS_BT656) {
 		u32 delay_usec, bad_frames = 20;
 
 		delay_usec = DIV_ROUND_UP_ULL((u64)USEC_PER_SEC *
@@ -769,12 +778,12 @@ static int csi_start(struct csi_priv *pr
 	}
 
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
-		ret = csi_idmac_start(priv);
+		ret = csi_idmac_start(priv, &mbus_cfg);
 		if (ret)
 			goto stop_upstream;
 	}
 
-	ret = csi_setup(priv);
+	ret = csi_setup(priv, &mbus_cfg);
 	if (ret)
 		goto idmac_stop;
 
@@ -1138,7 +1147,6 @@ static int csi_link_validate(struct v4l2
 
 	mutex_lock(&priv->lock);
 
-	priv->mbus_cfg = mbus_cfg;
 	is_csi2 = !is_parallel_bus(&mbus_cfg);
 	if (is_csi2) {
 		/*


