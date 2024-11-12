Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8577A212F1D;
	Tue, 12 Nov 2024 10:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408173; cv=none; b=pn8Krjl1JOn1XaoYA0zLOf8q7VSCWzD5ijcjaFPAtqC7oe2E7vgylqlRt83xjoYzgLXV4yNSNYdVjSUpdzf+ZLaWp5jNwYgeWJ5MMQlkoGtXXg3M4IpDU05ER6rpbahYJNYd0nNh/PzbxNXEI2ZPtuH+b87F0XgHFpK5Oie9G9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408173; c=relaxed/simple;
	bh=Q3W+0UTuJUo2wrRaV2/bvHsQH/lbgQj3o+aelbrbohE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIuOpdjTTrTWrVkiswMQ2Bnj1PaU+/DRxY/yv52fV3ZsQMUOu2N4FbwFR4xCIQdLfoGQGXiGRTorSSw6ax3IUKz6ildZQ1UyGmcdsiAsvsFNIls8AwJdTrSJP/pjVV+DwOsq9XFzqSoXcbSv8lhjS3nWd7gGdutHHiPDO5UFXOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olt6vzgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olt6vzgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBE2C4CECD;
	Tue, 12 Nov 2024 10:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408173;
	bh=Q3W+0UTuJUo2wrRaV2/bvHsQH/lbgQj3o+aelbrbohE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olt6vzgRrzwsBTcjK8w+6BOThDs+qgDynHdRPaQcGB8F5GhEV7pUB1KWdgEp7jrjZ
	 fT8pYHjs+2d2abstFGW2VVUmBzYAvKGFP9sY2DQKotB+pp4FjIsohkBQEOBIumckt6
	 AuwV0B9KJ+C3eTtAwxvg2j3Khx8YZwiOYEoUsMtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.11 082/184] media: vivid: fix buffer overwrite when using > 32 buffers
Date: Tue, 12 Nov 2024 11:20:40 +0100
Message-ID: <20241112101904.006993933@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 96d8569563916fe2f8fe17317e20e43f54f9ba4b upstream.

The maximum number of buffers that can be requested was increased to
64 for the video capture queue. But video capture used a must_blank
array that was still sized for 32 (VIDEO_MAX_FRAME). This caused an
out-of-bounds write when using buffer indices >= 32.

Create a new define MAX_VID_CAP_BUFFERS that is used to access the
must_blank array and set max_num_buffers for the video capture queue.

This solves a crash reported by:

	https://bugzilla.kernel.org/show_bug.cgi?id=219258

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Fixes: cea70ed416b4 ("media: test-drivers: vivid: Increase max supported buffers for capture queues")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-core.c    |    2 +-
 drivers/media/test-drivers/vivid/vivid-core.h    |    4 +++-
 drivers/media/test-drivers/vivid/vivid-ctrls.c   |    2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c |    2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -910,7 +910,7 @@ static int vivid_create_queue(struct viv
 	 * videobuf2-core.c to MAX_BUFFER_INDEX.
 	 */
 	if (buf_type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		q->max_num_buffers = 64;
+		q->max_num_buffers = MAX_VID_CAP_BUFFERS;
 	if (buf_type == V4L2_BUF_TYPE_SDR_CAPTURE)
 		q->max_num_buffers = 1024;
 	if (buf_type == V4L2_BUF_TYPE_VBI_CAPTURE)
--- a/drivers/media/test-drivers/vivid/vivid-core.h
+++ b/drivers/media/test-drivers/vivid/vivid-core.h
@@ -26,6 +26,8 @@
 #define MAX_INPUTS 16
 /* The maximum number of outputs */
 #define MAX_OUTPUTS 16
+/* The maximum number of video capture buffers */
+#define MAX_VID_CAP_BUFFERS 64
 /* The maximum up or down scaling factor is 4 */
 #define MAX_ZOOM  4
 /* The maximum image width/height are set to 4K DMT */
@@ -481,7 +483,7 @@ struct vivid_dev {
 	/* video capture */
 	struct tpg_data			tpg;
 	unsigned			ms_vid_cap;
-	bool				must_blank[VIDEO_MAX_FRAME];
+	bool				must_blank[MAX_VID_CAP_BUFFERS];
 
 	const struct vivid_fmt		*fmt_cap;
 	struct v4l2_fract		timeperframe_vid_cap;
--- a/drivers/media/test-drivers/vivid/vivid-ctrls.c
+++ b/drivers/media/test-drivers/vivid/vivid-ctrls.c
@@ -553,7 +553,7 @@ static int vivid_vid_cap_s_ctrl(struct v
 		break;
 	case VIVID_CID_PERCENTAGE_FILL:
 		tpg_s_perc_fill(&dev->tpg, ctrl->val);
-		for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		for (i = 0; i < MAX_VID_CAP_BUFFERS; i++)
 			dev->must_blank[i] = ctrl->val < 100;
 		break;
 	case VIVID_CID_INSERT_SAV:
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -213,7 +213,7 @@ static int vid_cap_start_streaming(struc
 
 	dev->vid_cap_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
-	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+	for (i = 0; i < MAX_VID_CAP_BUFFERS; i++)
 		dev->must_blank[i] = tpg_g_perc_fill(&dev->tpg) < 100;
 	if (dev->start_streaming_error) {
 		dev->start_streaming_error = false;


