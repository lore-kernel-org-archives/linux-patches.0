Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E543F22969D;
	Thu, 12 Dec 2024 16:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022058; cv=none; b=iWmb1kDMR8UWdyvy4WEHlrKqG9U6pmbB/lKaVCSnnUgDaeTVdm8YKAwsN9IYQKF4ZXICL8qKmA55uTAGRh5b2/nf7yEweY27gVqSEG5h9SK0K+zMIAMWZzd3wQ240UT22VBctLqTJM74CgUsGFGBB+hlNUkYfI+KAAK0go42EM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022058; c=relaxed/simple;
	bh=hu3sRxOmd4znzHRCUkJblEiR57Dl/7NwyjIDp4TF5SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEr4KwhBGeu4SMLNKYMFlvy8xQiRxf+cjianSYHQUSKkU6o0GszEjESWp7yx3yQWC2XsNqr1y/VN31i2Zoq7b45zfxGiBHrCCdB79MCKDfAzKtdPN8WRp0dNDcN7s8l2GPOnCN4/TCN7yv7yKOPt+xz7OgyqLqSGjiEf6ctO8YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mm14N9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mm14N9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667A8C4CECE;
	Thu, 12 Dec 2024 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022057;
	bh=hu3sRxOmd4znzHRCUkJblEiR57Dl/7NwyjIDp4TF5SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mm14N9dvT5K+PbnAX6LN0TIjafTBLG6vhxhzPV2jz3Rdf88a//D5orO0A1McTabA
	 i5WHTFK4dXb5V43D/nDloJrXPDPiRHO2ecN2JVEWXp6N2gA0ty22pozRrdAcLJzKzS
	 DsnCugb0IP7NOJTssVExIKvXOWMEgX4iHXGidrwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Vikash Garodia <vgarodia@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/565] media: venus: venc: Use pmruntime autosuspend
Date: Thu, 12 Dec 2024 15:55:31 +0100
Message-ID: <20241212144316.854677557@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit 3f3e877ce8efabe44ddc8e13885f99cdc770e198 ]

Migrate encoder to pm-runtime autosuspend.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Vikash Garodia <vgarodia@codeaurora.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 6c9934c5a00a ("media: venus: fix enc/dec destruction order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/venc.c | 103 +++++++++++++++++++++--
 1 file changed, 95 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index c4e0fe14c058d..8720606cdd95a 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -538,6 +538,64 @@ static const struct v4l2_ioctl_ops venc_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
+static int venc_pm_get(struct venus_inst *inst)
+{
+	struct venus_core *core = inst->core;
+	struct device *dev = core->dev_enc;
+	int ret;
+
+	mutex_lock(&core->pm_lock);
+	ret = pm_runtime_resume_and_get(dev);
+	mutex_unlock(&core->pm_lock);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int venc_pm_put(struct venus_inst *inst, bool autosuspend)
+{
+	struct venus_core *core = inst->core;
+	struct device *dev = core->dev_enc;
+	int ret;
+
+	mutex_lock(&core->pm_lock);
+
+	if (autosuspend)
+		ret = pm_runtime_put_autosuspend(dev);
+	else
+		ret = pm_runtime_put_sync(dev);
+
+	mutex_unlock(&core->pm_lock);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int venc_pm_get_put(struct venus_inst *inst)
+{
+	struct venus_core *core = inst->core;
+	struct device *dev = core->dev_enc;
+	int ret = 0;
+
+	mutex_lock(&core->pm_lock);
+
+	if (pm_runtime_suspended(dev)) {
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret < 0)
+			goto error;
+
+		ret = pm_runtime_put_autosuspend(dev);
+	}
+
+error:
+	mutex_unlock(&core->pm_lock);
+
+	return ret < 0 ? ret : 0;
+}
+
+static void venc_pm_touch(struct venus_inst *inst)
+{
+	pm_runtime_mark_last_busy(inst->core->dev_enc);
+}
+
 static int venc_set_properties(struct venus_inst *inst)
 {
 	struct venc_controls *ctr = &inst->controls.enc;
@@ -931,10 +989,18 @@ static int venc_queue_setup(struct vb2_queue *q,
 		return 0;
 	}
 
+	ret = venc_pm_get(inst);
+	if (ret)
+		return ret;
+
 	mutex_lock(&inst->lock);
 	ret = venc_init_session(inst);
 	mutex_unlock(&inst->lock);
 
+	if (ret)
+		goto put_power;
+
+	ret = venc_pm_put(inst, false);
 	if (ret)
 		return ret;
 
@@ -970,6 +1036,9 @@ static int venc_queue_setup(struct vb2_queue *q,
 		break;
 	}
 
+	return ret;
+put_power:
+	venc_pm_put(inst, false);
 	return ret;
 }
 
@@ -986,6 +1055,8 @@ static void venc_release_session(struct venus_inst *inst)
 {
 	int ret;
 
+	venc_pm_get(inst);
+
 	mutex_lock(&inst->lock);
 
 	ret = hfi_session_deinit(inst);
@@ -997,6 +1068,8 @@ static void venc_release_session(struct venus_inst *inst)
 	venus_pm_load_scale(inst);
 	INIT_LIST_HEAD(&inst->registeredbufs);
 	venus_pm_release_core(inst);
+
+	venc_pm_put(inst, false);
 }
 
 static void venc_buf_cleanup(struct vb2_buffer *vb)
@@ -1066,7 +1139,15 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 	inst->sequence_cap = 0;
 	inst->sequence_out = 0;
 
+	ret = venc_pm_get(inst);
+	if (ret)
+		goto error;
+
 	ret = venus_pm_acquire_core(inst);
+	if (ret)
+		goto put_power;
+
+	ret = venc_pm_put(inst, true);
 	if (ret)
 		goto error;
 
@@ -1091,6 +1172,8 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	return 0;
 
+put_power:
+	venc_pm_put(inst, false);
 error:
 	venus_helper_buffers_done(inst, q->type, VB2_BUF_STATE_QUEUED);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
@@ -1105,6 +1188,8 @@ static void venc_vb2_buf_queue(struct vb2_buffer *vb)
 {
 	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
 
+	venc_pm_get_put(inst);
+
 	mutex_lock(&inst->lock);
 	venus_helper_vb2_buf_queue(vb);
 	mutex_unlock(&inst->lock);
@@ -1128,6 +1213,8 @@ static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
 	struct vb2_buffer *vb;
 	unsigned int type;
 
+	venc_pm_touch(inst);
+
 	if (buf_type == HFI_BUFFER_INPUT)
 		type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	else
@@ -1157,6 +1244,8 @@ static void venc_event_notify(struct venus_inst *inst, u32 event,
 {
 	struct device *dev = inst->core->dev_enc;
 
+	venc_pm_touch(inst);
+
 	if (event == EVT_SESSION_ERROR) {
 		inst->session_error = true;
 		dev_err(dev, "enc: event session error %x\n", inst->error);
@@ -1245,13 +1334,9 @@ static int venc_open(struct file *file)
 
 	venus_helper_init_instance(inst);
 
-	ret = pm_runtime_resume_and_get(core->dev_enc);
-	if (ret < 0)
-		goto err_free;
-
 	ret = venc_ctrl_init(inst);
 	if (ret)
-		goto err_put_sync;
+		goto err_free;
 
 	ret = hfi_session_create(inst, &venc_hfi_ops);
 	if (ret)
@@ -1290,8 +1375,6 @@ static int venc_open(struct file *file)
 	hfi_session_destroy(inst);
 err_ctrl_deinit:
 	venc_ctrl_deinit(inst);
-err_put_sync:
-	pm_runtime_put_sync(core->dev_enc);
 err_free:
 	kfree(inst);
 	return ret;
@@ -1301,6 +1384,8 @@ static int venc_close(struct file *file)
 {
 	struct venus_inst *inst = to_inst(file);
 
+	venc_pm_get(inst);
+
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	venc_ctrl_deinit(inst);
@@ -1309,7 +1394,7 @@ static int venc_close(struct file *file)
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
-	pm_runtime_put_sync(inst->core->dev_enc);
+	venc_pm_put(inst, false);
 
 	kfree(inst);
 	return 0;
@@ -1366,6 +1451,8 @@ static int venc_probe(struct platform_device *pdev)
 	core->dev_enc = dev;
 
 	video_set_drvdata(vdev, core);
+	pm_runtime_set_autosuspend_delay(dev, 2000);
+	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
 	return 0;
-- 
2.43.0



