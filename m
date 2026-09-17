Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2654D4871;
	Thu, 17 Sep 2026 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660990; cv=none; b=ZHsi4JyvKxLcJ2KgMKQBtyJSJn9gANmF7FZXS0bP532QbOO5h4mMc7g93JiS4FwUbq6MEJbeitMYciXtbSrY4cy4hCFBt/fKZQCvEPKouvRicLz/o+zZmVcpUS2rfvk1tY+6FeMwLk7cKJ149BPB1eG5QwTmgM357mTaA7S2akI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660990; c=relaxed/simple;
	bh=KlYREc6ppCtKpQpO+oh3JRIVGWVgQ5FMU5xe4Qg7sKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJSOJzU5TPHTxXR/4JAxfy7J54gyZmeQKPgNKPVyOjvkbMsyj+tfTAfiNCeqoPHzjngs/OScM1jSYfR77AgB4nxV7aseeQSOjnCZUgA9lUWPLUNKfUo48DnW7+fVLSELgUvDFTJmvvqGsaZ0dERJLThnlN35vUeG7rFr/bgUzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiJ1BwIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiJ1BwIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F5F1F00898;
	Thu, 17 Sep 2026 16:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660989;
	bh=9ishzob+VLzzPPl3lby/UaJX2gd8zjFQiKjCWT+957s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iiJ1BwIw4JbOLv1eKyA6NzEc2EYDjtJpkdcnXpjbXqn61Cf6GjUi9OMTdT81rbGY4
	 v5g+zRF39tf88Prl9SRiwHBLZpp/PI0P6onqhNP0/IuOT/1sRFMvV03O1Ir2jVhTU1
	 esSxpbWfLn7jZRJ1enjRTQVCt9p/Gw9ovvOwDORY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Brnich <b-brnich@ti.com>,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0046/1250] media: chips-media: wave5: Fix Reports from Kernel Lock Validator
Date: Thu, 17 Sep 2026 15:57:21 +0100
Message-ID: <20260917151553.184843822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Brandon Brnich <b-brnich@ti.com>

[ Upstream commit 7d5d364f8b2dcc9b6b92456fb55632fde4a4d96f ]

handle_dynamic_resolution change requires that the state_lock be acquired
based on the lockdep_assert_held. However, the
handle_dynamic_resolution_change call in initialize_sequence does not
properly obtain the lock before calling.

Since the v4l2_ctrl_find and s_ctrl can sleep, they should not be called
while a lock is already held. Store off the fbc_buf_count then properly
update control once lock has been freed.

Signed-off-by: Brandon Brnich <b-brnich@ti.com>
Tested-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../chips-media/wave5/wave5-vpu-dec.c         | 47 +++++++++++++------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index 13f09bb42cb2d..db3f5bed7119f 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -270,10 +270,23 @@ static void send_eos_event(struct vpu_instance *inst)
 	inst->eos = false;
 }
 
+static void wave5_update_min_bufs_ctrl(struct vpu_instance *inst, u32 fbc_buf_count)
+{
+	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
+	struct v4l2_ctrl *ctrl;
+
+	if (!fbc_buf_count || fbc_buf_count == v4l2_m2m_num_dst_bufs_ready(m2m_ctx))
+		return;
+
+	ctrl = v4l2_ctrl_find(&inst->v4l2_ctrl_hdl,
+			      V4L2_CID_MIN_BUFFERS_FOR_CAPTURE);
+	if (ctrl)
+		v4l2_ctrl_s_ctrl(ctrl, fbc_buf_count);
+}
+
 static int handle_dynamic_resolution_change(struct vpu_instance *inst)
 {
 	struct v4l2_fh *fh = &inst->v4l2_fh;
-	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
 
 	static const struct v4l2_event vpu_event_src_ch = {
 		.type = V4L2_EVENT_SOURCE_CHANGE,
@@ -292,14 +305,6 @@ static int handle_dynamic_resolution_change(struct vpu_instance *inst)
 
 	inst->needs_reallocation = true;
 	inst->fbc_buf_count = initial_info->min_frame_buffer_count + 1;
-	if (inst->fbc_buf_count != v4l2_m2m_num_dst_bufs_ready(m2m_ctx)) {
-		struct v4l2_ctrl *ctrl;
-
-		ctrl = v4l2_ctrl_find(&inst->v4l2_ctrl_hdl,
-				      V4L2_CID_MIN_BUFFERS_FOR_CAPTURE);
-		if (ctrl)
-			v4l2_ctrl_s_ctrl(ctrl, inst->fbc_buf_count);
-	}
 
 	if (p_dec_info->initial_info_obtained) {
 		const struct vpu_format *vpu_fmt;
@@ -427,19 +432,24 @@ static void wave5_vpu_dec_finish_decode(struct vpu_instance *inst)
 	if ((dec_info.index_frame_display == DISPLAY_IDX_FLAG_SEQ_END ||
 	     dec_info.sequence_changed)) {
 		unsigned long flags;
+		u32 fbc_buf_count = 0;
 
 		spin_lock_irqsave(&inst->state_spinlock, flags);
 		if (!v4l2_m2m_has_stopped(m2m_ctx)) {
 			switch_state(inst, VPU_INST_STATE_STOP);
 
-			if (dec_info.sequence_changed)
+			if (dec_info.sequence_changed) {
 				handle_dynamic_resolution_change(inst);
-			else
+				fbc_buf_count = inst->fbc_buf_count;
+			} else {
 				send_eos_event(inst);
+			}
 
 			flag_last_buffer_done(inst);
 		}
 		spin_unlock_irqrestore(&inst->state_spinlock, flags);
+
+		wave5_update_min_bufs_ctrl(inst, fbc_buf_count);
 	}
 
 	/*
@@ -1544,8 +1554,9 @@ static const struct vpu_instance_ops wave5_vpu_dec_inst_ops = {
 static int initialize_sequence(struct vpu_instance *inst)
 {
 	struct dec_initial_info initial_info;
-	int ret = 0;
 	unsigned long flags;
+	u32 fbc_buf_count;
+	int ret = 0;
 
 	memset(&initial_info, 0, sizeof(struct dec_initial_info));
 
@@ -1569,8 +1580,11 @@ static int initialize_sequence(struct vpu_instance *inst)
 
 	spin_lock_irqsave(&inst->state_spinlock, flags);
 	handle_dynamic_resolution_change(inst);
+	fbc_buf_count = inst->fbc_buf_count;
 	spin_unlock_irqrestore(&inst->state_spinlock, flags);
 
+	wave5_update_min_bufs_ctrl(inst, fbc_buf_count);
+
 	return 0;
 }
 
@@ -1603,6 +1617,7 @@ static void wave5_vpu_dec_device_run(void *priv)
 		ret = initialize_sequence(inst);
 		if (ret) {
 			unsigned long flags;
+			u32 fbc_buf_count = 0;
 
 			spin_lock_irqsave(&inst->state_spinlock, flags);
 			if (wave5_is_draining_or_eos(inst) &&
@@ -1611,14 +1626,18 @@ static void wave5_vpu_dec_device_run(void *priv)
 
 				switch_state(inst, VPU_INST_STATE_STOP);
 
-				if (vb2_is_streaming(dst_vq))
+				if (vb2_is_streaming(dst_vq)) {
 					send_eos_event(inst);
-				else
+				} else {
 					handle_dynamic_resolution_change(inst);
+					fbc_buf_count = inst->fbc_buf_count;
+				}
 
 				flag_last_buffer_done(inst);
 			}
 			spin_unlock_irqrestore(&inst->state_spinlock, flags);
+
+			wave5_update_min_bufs_ctrl(inst, fbc_buf_count);
 		} else {
 			switch_state(inst, VPU_INST_STATE_INIT_SEQ);
 		}
-- 
2.53.0



