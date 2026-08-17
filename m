Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF0441037;
	Mon, 17 Aug 2026 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977004; cv=none; b=t6CFBQO5N2jYlWnx4iOaG/c8L4gxBrfX+x5twShKbiHukVsvqcWM8E9R1WipjGTMLfydPWBdLoadntrTiuboVfKfe1i7OaM7BC6knbVPw4xYYB+tw30WMvDrEROcgqu/oJgD9ZqMLoSXHNRw4lZAS3FZUO6rSjQthu95QfdZtJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977004; c=relaxed/simple;
	bh=wY+ojlhADvj6QA1CoogGWFebWLkHz6GYVqX5/zqfMc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLYHMuOow87Cx8VVaiG3Eb58iNNk1D4yyonu8o8Qc6ftAXRh8JaJ72XzntkpHGr+Xk6nFua/6SB0pHEiwDquBfULlQlkD4rtN0nvEro9++Z+lLVLAUq5hSoPiSELOEHjVjvS++uTFTRlc3PTi7eNuvyKIwZbJoq0QuW3Q3DCmmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHb+cj6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHb+cj6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A2B1F000E9;
	Mon, 17 Aug 2026 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977000;
	bh=6QdgwyqtaQz8BR+MX9U+mIWP/NmD83sKDnsbNvZGnHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHb+cj6ap+ubGPDV3+IehAMTE2SdL7HGqKJnSOsLOIBHC/fQitbI8hsWxqzuiva7i
	 Kc0KAb6bswXBrYToi+REbfbeH4sAwHG/2xhqV/EqzaFY3PSKorFmkKvq5u5B4aV1bB
	 /u5zbKZTIGictL0RHvBDILqP60HNTmaIFz3bY/Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	syzbot+dac8f5eaa46837e97b89@syzkaller.appspotmail.com,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 177/456] media: vivid: check for vb2_is_busy() when toggling caps
Date: Mon, 17 Aug 2026 15:29:27 +0200
Message-ID: <20260817132547.046207764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -487,14 +487,20 @@ static int vivid_vid_cap_s_ctrl(struct v
 		vivid_update_format_cap(dev, true);
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
@@ -970,14 +976,20 @@ static int vivid_vid_out_s_ctrl(struct v
 
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
@@ -385,6 +385,12 @@ void vivid_update_format_cap(struct vivi
 	unsigned size;
 	u64 pixelclock;
 
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
@@ -222,6 +222,12 @@ void vivid_update_format_out(struct vivi
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


