Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951F3239573;
	Tue, 26 Aug 2025 11:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207397; cv=none; b=qVdJ/BK79FowukKD5U+G3H53dJcyjktpGGqPb/h2mjYwq94Lq7ealpyOE6xauIFE+OKTkMblb9+KouLykV5z0i7FtWh3VzB3o/qIIFNWrccxWZ2HPqphPttRoDLq8x4G9xNJTGsBf/cPDoloZMrAAYVPYbpsIplMYsX8DyejhyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207397; c=relaxed/simple;
	bh=QJTmusnJu8EPeJwqW+ocCrFxjiVVJ6OXyTur0KJKXFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOnQ03cGhbN5tFGQqKOjJ2lI6/LgPF4czLPJsdQiAWHQiEidTr9POSrQ8iAO/TRCixM0Tn3n1WKE04HAwreRWDkV718KRtP5yGlFFEGu/6U5CfJ/SLMVSPWz804O9G+rZlbzEgRsEQtRL+G3AH4iEtnK2BiRej/L3EGRkKmo10U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMujx+Nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMujx+Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0D1C4CEF1;
	Tue, 26 Aug 2025 11:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207397;
	bh=QJTmusnJu8EPeJwqW+ocCrFxjiVVJ6OXyTur0KJKXFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMujx+Nx7DBmiPDEEpLReRQM0khtlzhLphUq1bjJ/mhD5DG4EnorL3gNhp6JSsD8Y
	 zMp4h5FHMoSLDzVbWynK5yDIZg9hML7iC7mcTBk8JgFk7m0ckmYBAE1vzQAB1AL7CB
	 ZipESIi9vBnzk0lpbL3kgjTdBis3aCGr1g452ceU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>
Subject: [PATCH 6.16 166/457] media: iris: Verify internal buffer release on close
Date: Tue, 26 Aug 2025 13:07:30 +0200
Message-ID: <20250826110941.479425374@linuxfoundation.org>
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

commit d2abb1ff5a3c13321d407ee19865d0d8d834c7c6 upstream.

Validate all internal buffers queued to firmware are released back to
driver on close. This helps ensure buffer lifecycle correctness and aids
in debugging any resporce leaks.

Cc: stable@vger.kernel.org
Fixes: 73702f45db81 ("media: iris: allocate, initialize and queue internal buffers")
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
 drivers/media/platform/qcom/iris/iris_vidc.c | 29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index 663f5602b5ad..a8144595cc78 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -221,6 +221,33 @@ static void iris_session_close(struct iris_inst *inst)
 		iris_wait_for_session_response(inst, false);
 }
 
+static void iris_check_num_queued_internal_buffers(struct iris_inst *inst, u32 plane)
+{
+	const struct iris_platform_data *platform_data = inst->core->iris_platform_data;
+	struct iris_buffer *buf, *next;
+	struct iris_buffers *buffers;
+	const u32 *internal_buf_type;
+	u32 internal_buffer_count, i;
+	u32 count = 0;
+
+	if (V4L2_TYPE_IS_OUTPUT(plane)) {
+		internal_buf_type = platform_data->dec_ip_int_buf_tbl;
+		internal_buffer_count = platform_data->dec_ip_int_buf_tbl_size;
+	} else {
+		internal_buf_type = platform_data->dec_op_int_buf_tbl;
+		internal_buffer_count = platform_data->dec_op_int_buf_tbl_size;
+	}
+
+	for (i = 0; i < internal_buffer_count; i++) {
+		buffers = &inst->buffers[internal_buf_type[i]];
+		list_for_each_entry_safe(buf, next, &buffers->list, list)
+			count++;
+		if (count)
+			dev_err(inst->core->dev, "%d buffer of type %d not released",
+				count, internal_buf_type[i]);
+	}
+}
+
 int iris_close(struct file *filp)
 {
 	struct iris_inst *inst = iris_get_inst(filp, NULL);
@@ -235,6 +262,8 @@ int iris_close(struct file *filp)
 	iris_v4l2_fh_deinit(inst);
 	iris_destroy_all_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
 	iris_destroy_all_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	iris_check_num_queued_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	iris_check_num_queued_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	iris_remove_session(inst);
 	mutex_unlock(&inst->lock);
 	mutex_destroy(&inst->ctx_q_lock);
-- 
2.50.1



