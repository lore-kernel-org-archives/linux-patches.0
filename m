Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220422BE653;
	Tue, 26 Aug 2025 11:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207385; cv=none; b=Cgf53SLPpXdNwnRBiNnsR8MyN7AFimkJ9YaFz5G4wfzrSbn8+rMwAePnBOnDwe12m0xaAFc+MhkbvGZ1UTSueZYYkSlHsTAK38+pQLvThoh+JVj5DKX1mNsMqh6rZpT7Pu9wfVpd3nsukb9lzQUk/lwhpeqGwPGJZNJY3242hK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207385; c=relaxed/simple;
	bh=XC8FVLDepV9pB3oZGWlOUTpeW2aGS+pCJc9EHIme/aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNYntqS/mK1xodpczGmbNuxy4Bkd4UBZ/MyXBvVr6F1+pKJkJxC4xPoUzup8G8AxM+K5kNSB4JDuuLJg3aGAn9iBYxrY/JzPOPAoA9jRLvmIeRA9w6s9/6ZzQTIhIGkyfyjv88P5Bu2c4vr1GxulxE4dthqjCFE4Uzyyh5G9LC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jov2dOSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jov2dOSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD73EC4CEF1;
	Tue, 26 Aug 2025 11:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207385;
	bh=XC8FVLDepV9pB3oZGWlOUTpeW2aGS+pCJc9EHIme/aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jov2dOSVNzJWU0tNOP7k712sTtvDhdqLagaAUymshrlF+rC893kqWVjjEV6wATjbP
	 MMyI7udjAHcFRzvH6QM7R3z2rqaR8WTRljw5EC1GiBy/oOki6pf2MU8M/9fMbJ2edV
	 R2BF8nYKYY5W5M8nJ7wfPJCiDE8COygB8PPqBJcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 162/457] media: iris: Skip destroying internal buffer if not dequeued
Date: Tue, 26 Aug 2025 13:07:26 +0200
Message-ID: <20250826110941.378846283@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 7c452ffda30c0460c568273993a3d3c611486467 upstream.

Firmware might hold the DPB buffers for reference in case of sequence
change, so skip destroying buffers for which QUEUED flag is not removed.

Cc: stable@vger.kernel.org
Fixes: 73702f45db81 ("media: iris: allocate, initialize and queue internal buffers")
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_buffer.c |   20 +++++++++++++++++++-
 drivers/media/platform/qcom/iris/iris_buffer.h |    3 ++-
 drivers/media/platform/qcom/iris/iris_vdec.c   |    4 ++--
 drivers/media/platform/qcom/iris/iris_vidc.c   |    4 ++--
 4 files changed, 25 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_buffer.c
+++ b/drivers/media/platform/qcom/iris/iris_buffer.c
@@ -376,7 +376,7 @@ int iris_destroy_internal_buffer(struct
 	return 0;
 }
 
-int iris_destroy_internal_buffers(struct iris_inst *inst, u32 plane)
+static int iris_destroy_internal_buffers(struct iris_inst *inst, u32 plane, bool force)
 {
 	const struct iris_platform_data *platform_data = inst->core->iris_platform_data;
 	struct iris_buffer *buf, *next;
@@ -396,6 +396,14 @@ int iris_destroy_internal_buffers(struct
 	for (i = 0; i < len; i++) {
 		buffers = &inst->buffers[internal_buf_type[i]];
 		list_for_each_entry_safe(buf, next, &buffers->list, list) {
+			/*
+			 * during stream on, skip destroying internal(DPB) buffer
+			 * if firmware did not return it.
+			 * during close, destroy all buffers irrespectively.
+			 */
+			if (!force && buf->attr & BUF_ATTR_QUEUED)
+				continue;
+
 			ret = iris_destroy_internal_buffer(inst, buf);
 			if (ret)
 				return ret;
@@ -405,6 +413,16 @@ int iris_destroy_internal_buffers(struct
 	return 0;
 }
 
+int iris_destroy_all_internal_buffers(struct iris_inst *inst, u32 plane)
+{
+	return iris_destroy_internal_buffers(inst, plane, true);
+}
+
+int iris_destroy_dequeued_internal_buffers(struct iris_inst *inst, u32 plane)
+{
+	return iris_destroy_internal_buffers(inst, plane, false);
+}
+
 static int iris_release_internal_buffers(struct iris_inst *inst,
 					 enum iris_buffer_type buffer_type)
 {
--- a/drivers/media/platform/qcom/iris/iris_buffer.h
+++ b/drivers/media/platform/qcom/iris/iris_buffer.h
@@ -106,7 +106,8 @@ void iris_get_internal_buffers(struct ir
 int iris_create_internal_buffers(struct iris_inst *inst, u32 plane);
 int iris_queue_internal_buffers(struct iris_inst *inst, u32 plane);
 int iris_destroy_internal_buffer(struct iris_inst *inst, struct iris_buffer *buffer);
-int iris_destroy_internal_buffers(struct iris_inst *inst, u32 plane);
+int iris_destroy_all_internal_buffers(struct iris_inst *inst, u32 plane);
+int iris_destroy_dequeued_internal_buffers(struct iris_inst *inst, u32 plane);
 int iris_alloc_and_queue_persist_bufs(struct iris_inst *inst);
 int iris_alloc_and_queue_input_int_bufs(struct iris_inst *inst);
 int iris_queue_buffer(struct iris_inst *inst, struct iris_buffer *buf);
--- a/drivers/media/platform/qcom/iris/iris_vdec.c
+++ b/drivers/media/platform/qcom/iris/iris_vdec.c
@@ -408,7 +408,7 @@ int iris_vdec_streamon_input(struct iris
 
 	iris_get_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
 
-	ret = iris_destroy_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	ret = iris_destroy_dequeued_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
 	if (ret)
 		return ret;
 
@@ -496,7 +496,7 @@ int iris_vdec_streamon_output(struct iri
 
 	iris_get_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 
-	ret = iris_destroy_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	ret = iris_destroy_dequeued_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	if (ret)
 		return ret;
 
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -233,8 +233,8 @@ int iris_close(struct file *filp)
 	iris_session_close(inst);
 	iris_inst_change_state(inst, IRIS_INST_DEINIT);
 	iris_v4l2_fh_deinit(inst);
-	iris_destroy_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
-	iris_destroy_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	iris_destroy_all_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	iris_destroy_all_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	iris_remove_session(inst);
 	mutex_unlock(&inst->lock);
 	mutex_destroy(&inst->ctx_q_lock);


