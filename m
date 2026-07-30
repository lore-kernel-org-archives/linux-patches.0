Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5798A375AC3;
	Thu, 30 Jul 2026 14:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422727; cv=none; b=M3InFWnhzKjkUY0A7tkogeO+frPqGXmgSIIvdGG7K6m56TiOgxdUM5/1gC9yhp9/RKQuP99lPSyP8jCUwYgZv18I7zUtMQ/p6r3SMnKHrM7EN3S6ut5YvFSLahkt9GpphYQGJf+CQrg3gxP/k8JbkE4UykVhxB3oejZJWfyJpsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422727; c=relaxed/simple;
	bh=DgCwc0Swr+cXmOTmG8Gl3zmZJ/Oysg0v3qJPrZVtMDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA0J/u3oK+dWiBD6FFeTlhbsendixNNx/s5uc3DoK9kT3+fVW56KTTKICz3JKlm8FxEirae2Oj3OiLCJNPgpw5FWO9zMITtgweAs1OpeWZEAjg4gpTDL+JGjoRky2F5jinvMs3WjwZrVK2v6dfnc0DhqhIguroP3ZVmJacdfyV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1Qoy8pk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1Qoy8pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF001F000E9;
	Thu, 30 Jul 2026 14:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422726;
	bh=nOT1GI90MGRQUf+uyj0rxNyBvA2juXx9spI/BN7q5X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1Qoy8pkRtZNbS1EpB9rLc4LpsZpNUuN4BDDcofgqLusVKK/eMF7tEDFLXUgq0zgk
	 i9fTSsKPl8eBVHxf3PqjR8BMt+qkGXQCsl8Fsh1ie3FZna05fttUrv3Qw3Op7LyHf/
	 e/3TzYRjUjyJ32QmH8uwGpcO6lZbUg0oAHHXLY5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	syzbot+dac8f5eaa46837e97b89@syzkaller.appspotmail.com,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 535/744] media: vivid: check for vb2_is_busy() when toggling caps
Date: Thu, 30 Jul 2026 16:13:28 +0200
Message-ID: <20260730141455.645113208@linuxfoundation.org>
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

commit c2d1a2130c93f6d758af58590b86b2254c7a1dec upstream.

The vivid_update_format_cap/out() functions must only be called if the
capture/output queue are not busy. But for the controls that select
the CROP/COMPOSE/SCALE capability that is not checked.

Only when streaming starts will they be set to 'grabbed' and it is
impossible to change the control, but between REQBUFS and STREAMON you
are still allowed to set these controls. Since vivid_update_format_cap/out
will change the format, this can cause unexpected results.

Besides adding these checks, also add a WARN_ON in
vivid_update_format_cap/out() if the queue is busy.

I'm 90% certain that this is the cause of this syzbot bug:

https://syzkaller.appspot.com/bug?extid=dac8f5eaa46837e97b89

But since we never have reproducers, it is hard to be certain. In any case,
these checks are needed regardless.

Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: 73c3f48230cd ("[media] vivid: add the control handling code")
Cc: stable@vger.kernel.org
Reported-by: syzbot+dac8f5eaa46837e97b89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dac8f5eaa46837e97b89
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-ctrls.c   |   12 ++++++++++++
 drivers/media/test-drivers/vivid/vivid-vid-cap.c |    6 ++++++
 drivers/media/test-drivers/vivid/vivid-vid-out.c |    6 ++++++
 3 files changed, 24 insertions(+)

--- a/drivers/media/test-drivers/vivid/vivid-ctrls.c
+++ b/drivers/media/test-drivers/vivid/vivid-ctrls.c
@@ -613,14 +613,20 @@ static int vivid_vid_cap_s_ctrl(struct v
 			vivid_update_reduced_fps(dev);
 		break;
 	case VIVID_CID_HAS_CROP_CAP:
+		if (vb2_is_busy(&dev->vb_vid_cap_q))
+			return -EBUSY;
 		dev->has_crop_cap = ctrl->val;
 		vivid_update_format_cap(dev, true);
 		break;
 	case VIVID_CID_HAS_COMPOSE_CAP:
+		if (vb2_is_busy(&dev->vb_vid_cap_q))
+			return -EBUSY;
 		dev->has_compose_cap = ctrl->val;
 		vivid_update_format_cap(dev, true);
 		break;
 	case VIVID_CID_HAS_SCALER_CAP:
+		if (vb2_is_busy(&dev->vb_vid_cap_q))
+			return -EBUSY;
 		dev->has_scaler_cap = ctrl->val;
 		vivid_update_format_cap(dev, true);
 		break;
@@ -1117,14 +1123,20 @@ static int vivid_vid_out_s_ctrl(struct v
 
 	switch (ctrl->id) {
 	case VIVID_CID_HAS_CROP_OUT:
+		if (vb2_is_busy(&dev->vb_vid_out_q))
+			return -EBUSY;
 		dev->has_crop_out = ctrl->val;
 		vivid_update_format_out(dev);
 		break;
 	case VIVID_CID_HAS_COMPOSE_OUT:
+		if (vb2_is_busy(&dev->vb_vid_out_q))
+			return -EBUSY;
 		dev->has_compose_out = ctrl->val;
 		vivid_update_format_out(dev);
 		break;
 	case VIVID_CID_HAS_SCALER_OUT:
+		if (vb2_is_busy(&dev->vb_vid_out_q))
+			return -EBUSY;
 		dev->has_scaler_out = ctrl->val;
 		vivid_update_format_out(dev);
 		break;
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -391,6 +391,12 @@ void vivid_update_format_cap(struct vivi
 	struct v4l2_bt_timings *bt = &dev->dv_timings_cap[dev->input].bt;
 	u32 dims[V4L2_CTRL_MAX_DIMS] = {};
 
+	/*
+	 * This resets the format, so must never be called while vb2_is_busy().
+	 */
+	if (WARN_ON(vb2_is_busy(&dev->vb_vid_cap_q)))
+		return;
+
 	switch (dev->input_type[dev->input]) {
 	case WEBCAM:
 	default:
--- a/drivers/media/test-drivers/vivid/vivid-vid-out.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-out.c
@@ -214,6 +214,12 @@ void vivid_update_format_out(struct vivi
 	unsigned size, p;
 	u64 pixelclock;
 
+	/*
+	 * This resets the format, so must never be called while vb2_is_busy().
+	 */
+	if (WARN_ON(vb2_is_busy(&dev->vb_vid_out_q)))
+		return;
+
 	switch (dev->output_type[dev->output]) {
 	case SVID:
 	default:


