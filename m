Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B336C32277F;
	Mon, 18 Aug 2025 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526062; cv=none; b=qQHo4pYCRZOmzUqJ3XMIx6JaMrg6DtH1tL/neDO6TIp/RNdK9e4h0rGbqRe+69rtPBrjo2EL9Qv3rqo1pvCA4/aU2I+HHyJJrfZVXLQiNBjay6aHZxs2ENGHOXb1OJ6y6KbsEo5pytu0Iu2HT9bWk4dgq+CL2Onv4vBqDEsqJPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526062; c=relaxed/simple;
	bh=79dIWiionT3C/rJ7N8YLGgGk/ltdkSZBZ6sodAwq02U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVd3pG7Aum9N0COdCqHfoKTVYM9MEpIKYRQsFmXdg1WfWb8/D97A/JAgJpgZJCL40M+j5C3yMvM/1odFOzArMSSjtNGn0ckYP48spXWSiCrfZiVs13WddTLxdWt4T2jVxGgdQnGxjnRw5lngEcmTMs63i4BFhtjWZ1PhTWLDhgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhTNoWIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhTNoWIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6A6C116D0;
	Mon, 18 Aug 2025 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526062;
	bh=79dIWiionT3C/rJ7N8YLGgGk/ltdkSZBZ6sodAwq02U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhTNoWIyOISjSCbPMM5xOw3q6wCqubhe+MNa9j2KXXSU4p1NbuvhrfK75fZ1SBiig
	 TY6coELxZfTnSMkhhjBk8CnXKTvbamSTIaw35GdrWjGCp2oRxUi5c8Kueh3WozU0uR
	 Hj7f31Ea2TMLy3qcElZof7BAMHEj7hIrnb17GLzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hansg@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 415/570] media: uvcvideo: Set V4L2_CTRL_FLAG_DISABLED during queryctrl errors
Date: Mon, 18 Aug 2025 14:46:42 +0200
Message-ID: <20250818124521.832385467@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 649c033711d7fd6e1d5d69e4cfc3fceca7de2867 ]

To implement VIDIOC_QUERYCTRL, we need to know the minimum, maximum,
step and flags of the control. For some of the controls, this involves
querying the actual hardware.

Some non-compliant cameras produce errors when we query them. These
error can be triggered every time, sometimes, or when other controls do
not have the "right value". Right now, we populate that error to userspace.
When an error happens, the v4l2 framework does not copy the v4l2_queryctrl
struct to userspace. Also, userspace apps are not ready to handle any
other error than -EINVAL.

One of the main usecases of VIDIOC_QUERYCTRL is enumerating the controls
of a device. This is done using the V4L2_CTRL_FLAG_NEXT_CTRL flag. In
that usecase, a non-compliant control will make it almost impossible to
enumerate all controls of the device.

A control with an invalid max/min/step/flags is better than non being
able to enumerate the rest of the controls.

This patch:
- Retries for an extra attempt to read the control, to avoid spurious
  errors. More attempts do not seem to produce better results in the
  tested hardware.
- Makes VIDIOC_QUERYCTRL return 0 for -EIO errors.
- Introduces a warning in dmesg so we can have a trace of what has happened
  and sets the V4L2_CTRL_FLAG_DISABLED.
- Makes sure we keep returning V4L2_CTRL_FLAG_DISABLED for all the next
  attempts to query that control (other operations have the same
  functionality as now).

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20250502-uvc-eaccess-v8-1-0b8b58ac1142@chromium.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 55 +++++++++++++++++++++++++++-----
 drivers/media/usb/uvc/uvcvideo.h |  2 ++
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 44b6513c5264..f24272d483a2 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1483,14 +1483,28 @@ static u32 uvc_get_ctrl_bitmap(struct uvc_control *ctrl,
 	return ~0;
 }
 
+/*
+ * Maximum retry count to avoid spurious errors with controls. Increasing this
+ * value does no seem to produce better results in the tested hardware.
+ */
+#define MAX_QUERY_RETRIES 2
+
 static int __uvc_queryctrl_boundaries(struct uvc_video_chain *chain,
 				      struct uvc_control *ctrl,
 				      struct uvc_control_mapping *mapping,
 				      struct v4l2_query_ext_ctrl *v4l2_ctrl)
 {
 	if (!ctrl->cached) {
-		int ret = uvc_ctrl_populate_cache(chain, ctrl);
-		if (ret < 0)
+		unsigned int retries;
+		int ret;
+
+		for (retries = 0; retries < MAX_QUERY_RETRIES; retries++) {
+			ret = uvc_ctrl_populate_cache(chain, ctrl);
+			if (ret != -EIO)
+				break;
+		}
+
+		if (ret)
 			return ret;
 	}
 
@@ -1567,6 +1581,7 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 {
 	struct uvc_control_mapping *master_map = NULL;
 	struct uvc_control *master_ctrl = NULL;
+	int ret;
 
 	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
 	v4l2_ctrl->id = mapping->id;
@@ -1587,18 +1602,31 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		__uvc_find_control(ctrl->entity, mapping->master_id,
 				   &master_map, &master_ctrl, 0, 0);
 	if (master_ctrl && (master_ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR)) {
+		unsigned int retries;
 		s32 val;
 		int ret;
 
 		if (WARN_ON(uvc_ctrl_mapping_is_compound(master_map)))
 			return -EIO;
 
-		ret = __uvc_ctrl_get(chain, master_ctrl, master_map, &val);
-		if (ret < 0)
-			return ret;
+		for (retries = 0; retries < MAX_QUERY_RETRIES; retries++) {
+			ret = __uvc_ctrl_get(chain, master_ctrl, master_map,
+					     &val);
+			if (!ret)
+				break;
+			if (ret < 0 && ret != -EIO)
+				return ret;
+		}
 
-		if (val != mapping->master_manual)
-			v4l2_ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+		if (ret == -EIO) {
+			dev_warn_ratelimited(&chain->dev->udev->dev,
+					     "UVC non compliance: Error %d querying master control %x (%s)\n",
+					     ret, master_map->id,
+					     uvc_map_get_name(master_map));
+		} else {
+			if (val != mapping->master_manual)
+				v4l2_ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+		}
 	}
 
 	v4l2_ctrl->elem_size = uvc_mapping_v4l2_size(mapping);
@@ -1613,7 +1641,18 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		return 0;
 	}
 
-	return __uvc_queryctrl_boundaries(chain, ctrl, mapping, v4l2_ctrl);
+	ret = __uvc_queryctrl_boundaries(chain, ctrl, mapping, v4l2_ctrl);
+	if (ret && !mapping->disabled) {
+		dev_warn(&chain->dev->udev->dev,
+			 "UVC non compliance: permanently disabling control %x (%s), due to error %d\n",
+			 mapping->id, uvc_map_get_name(mapping), ret);
+		mapping->disabled = true;
+	}
+
+	if (mapping->disabled)
+		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
+
+	return 0;
 }
 
 int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index b9f8eb62ba1d..11d6e3c2ebdf 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -134,6 +134,8 @@ struct uvc_control_mapping {
 	s32 master_manual;
 	u32 slave_ids[2];
 
+	bool disabled;
+
 	const struct uvc_control_mapping *(*filter_mapping)
 				(struct uvc_video_chain *chain,
 				struct uvc_control *ctrl);
-- 
2.39.5



