Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9A8330B0E;
	Fri, 17 Oct 2025 15:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715762; cv=none; b=RhjqpRZa3ElqtXzfmaZcdSFPGdpoU/rCPM/tSzj1IeEEqt05XNGEkzX2BOr4UhlAbv5+KIOyrazf57K4Fvk0Ib3O62nNVWZ2+3sa79Vod+kG9hNznDVaC+z58YxnHGO0KhIWCFvlM+vj5fuhSGHzjUUeE4TN81HR2P2MvLPlcC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715762; c=relaxed/simple;
	bh=0gFjynVkANbqffwsNWVueQfPpgwDkUAcdgXMyq/Sxzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYCAABJPmYSXvMLJeFSl+WCV4QCFL2SeE+ecVcxrq8LzY9muSlAgG8tmVNL7+jlIgec99y1YMyAK2rkQ+Qb/2u3KIijPhLg9mYqGVqNIvQBv5tfXYI8lgP5z3Hk7h+FWVb2aGY9Lv/QwlK4SeYTD2bElmv3DgTZQ36j+DNkM3tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4bcAul6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4bcAul6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BCEC4CEE7;
	Fri, 17 Oct 2025 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715762;
	bh=0gFjynVkANbqffwsNWVueQfPpgwDkUAcdgXMyq/Sxzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4bcAul6bt/N62q6LTakZOHwGiyCRcCNi0wa9AT5ifoPssmp42GRSQ5k9RgahFIVp
	 jrNfaNFPbcPP95lk8yUKprTj0UN6kpia6V25OsUMgxP4PFSzCkSTIZpyFk4TPbQiwi
	 hlYoNRZ02qK6f2tWLPmns55X7ihj54g2hfhgwDIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 328/371] media: iris: Fix port streaming handling
Date: Fri, 17 Oct 2025 16:55:03 +0200
Message-ID: <20251017145213.943987645@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 4b67ef9b333ed645879b4b1a11e35e019ff4cfea upstream.

The previous check to block capture port streaming before output port
was incorrect and caused some valid usecase to fail. While removing that
check allows capture port to enter streaming independently, it also
introduced firmware errors due to premature queuing of DPB buffers
before the firmware session was fully started which happens only when
streamon is called on output port.

Fix this by deferring DPB buffer queuing to the firmware until both
capture and output are streaming and state is 'STREAMING'.

Fixes: 11712ce70f8e ("media: iris: implement vb2 streaming ops")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../media/platform/qcom/iris/iris_buffer.c    | 27 +++++++++++++++++++
 .../media/platform/qcom/iris/iris_buffer.h    |  1 +
 drivers/media/platform/qcom/iris/iris_vb2.c   |  8 +++---
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_buffer.c b/drivers/media/platform/qcom/iris/iris_buffer.c
index 9f664c241149..23cac5d13129 100644
--- a/drivers/media/platform/qcom/iris/iris_buffer.c
+++ b/drivers/media/platform/qcom/iris/iris_buffer.c
@@ -334,6 +334,29 @@ int iris_queue_buffer(struct iris_inst *inst, struct iris_buffer *buf)
 	return 0;
 }
 
+int iris_queue_internal_deferred_buffers(struct iris_inst *inst, enum iris_buffer_type buffer_type)
+{
+	struct iris_buffer *buffer, *next;
+	struct iris_buffers *buffers;
+	int ret = 0;
+
+	buffers = &inst->buffers[buffer_type];
+	list_for_each_entry_safe(buffer, next, &buffers->list, list) {
+		if (buffer->attr & BUF_ATTR_PENDING_RELEASE)
+			continue;
+		if (buffer->attr & BUF_ATTR_QUEUED)
+			continue;
+
+		if (buffer->attr & BUF_ATTR_DEFERRED) {
+			ret = iris_queue_buffer(inst, buffer);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
 int iris_queue_internal_buffers(struct iris_inst *inst, u32 plane)
 {
 	const struct iris_platform_data *platform_data = inst->core->iris_platform_data;
@@ -358,6 +381,10 @@ int iris_queue_internal_buffers(struct iris_inst *inst, u32 plane)
 				continue;
 			if (buffer->attr & BUF_ATTR_QUEUED)
 				continue;
+			if (buffer->type == BUF_DPB && inst->state != IRIS_INST_STREAMING) {
+				buffer->attr |= BUF_ATTR_DEFERRED;
+				continue;
+			}
 			ret = iris_queue_buffer(inst, buffer);
 			if (ret)
 				return ret;
diff --git a/drivers/media/platform/qcom/iris/iris_buffer.h b/drivers/media/platform/qcom/iris/iris_buffer.h
index 00825ad2dc3a..b9b011faa13a 100644
--- a/drivers/media/platform/qcom/iris/iris_buffer.h
+++ b/drivers/media/platform/qcom/iris/iris_buffer.h
@@ -105,6 +105,7 @@ int iris_get_buffer_size(struct iris_inst *inst, enum iris_buffer_type buffer_ty
 void iris_get_internal_buffers(struct iris_inst *inst, u32 plane);
 int iris_create_internal_buffers(struct iris_inst *inst, u32 plane);
 int iris_queue_internal_buffers(struct iris_inst *inst, u32 plane);
+int iris_queue_internal_deferred_buffers(struct iris_inst *inst, enum iris_buffer_type buffer_type);
 int iris_destroy_internal_buffer(struct iris_inst *inst, struct iris_buffer *buffer);
 int iris_destroy_all_internal_buffers(struct iris_inst *inst, u32 plane);
 int iris_destroy_dequeued_internal_buffers(struct iris_inst *inst, u32 plane);
diff --git a/drivers/media/platform/qcom/iris/iris_vb2.c b/drivers/media/platform/qcom/iris/iris_vb2.c
index 8b17c7c39487..e62ed7a57df2 100644
--- a/drivers/media/platform/qcom/iris/iris_vb2.c
+++ b/drivers/media/platform/qcom/iris/iris_vb2.c
@@ -173,9 +173,6 @@ int iris_vb2_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	inst = vb2_get_drv_priv(q);
 
-	if (V4L2_TYPE_IS_CAPTURE(q->type) && inst->state == IRIS_INST_INIT)
-		return 0;
-
 	mutex_lock(&inst->lock);
 	if (inst->state == IRIS_INST_ERROR) {
 		ret = -EBUSY;
@@ -203,7 +200,10 @@ int iris_vb2_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	buf_type = iris_v4l2_type_to_driver(q->type);
 
-	ret = iris_queue_deferred_buffers(inst, buf_type);
+	if (inst->state == IRIS_INST_STREAMING)
+		ret = iris_queue_internal_deferred_buffers(inst, BUF_DPB);
+	if (!ret)
+		ret = iris_queue_deferred_buffers(inst, buf_type);
 	if (ret)
 		goto error;
 
-- 
2.51.0



