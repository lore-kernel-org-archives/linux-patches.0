Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1022969B;
	Thu, 12 Dec 2024 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022061; cv=none; b=jBk0cTxWg6lIi3XrZKo1x/J1aCFryARev6cK2QYNMPVsxyElb7OQ19BGYC3WPDSLqLt0G3+m5iF/N2un02Z+Fx4fsQPW1Jr1oFBv0N53jLpso2/eWRIQfdGxzrZp6Py/h+YYqfSaeJbu1qc+8vAgfbBYsEf4FV42XaJ53LpD/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022061; c=relaxed/simple;
	bh=k5NFRkgLkWfsVD3HFAXd0+ZRDnpxMMhh907C8yd16X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6LLHoyaQYKavsvDwJxvsFqb/1w1xT20LyeeAj/AjnJR/AdTu9UeYtiDdxN0YU1UrFY6d7H/8ccaEsp+JTf7tjZkw66ZqyNi9vD3RARDcmjqsSY2fXlJ5y5qJ0dzv57y+sfmrdPzljFMX+Dcz8V2sziP4Eu7TMmHxRKUmLvZynE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0TQUNdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0TQUNdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1941AC4CED0;
	Thu, 12 Dec 2024 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022061;
	bh=k5NFRkgLkWfsVD3HFAXd0+ZRDnpxMMhh907C8yd16X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0TQUNdYdY6dc2Jc72nIv3FM2jyd/VLfPQmPjjaAVnbkIHMpnAaFN3sM1kkw0wN61
	 3v65TCTkLoaVwSjMLZwlN1hpwDA58xwxHvMZJenTGKgDcSK3JfQoKcyo0R2GfBt7Rj
	 QUB+5Vh8+PsnnJTsMAaoTtPwH0cU7hmrVBt8y+j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mansur Alisha Shaik <mansur@codeaurora.org>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/565] media: venus: vdec: decoded picture buffer handling during reconfig sequence
Date: Thu, 12 Dec 2024 15:55:32 +0100
Message-ID: <20241212144316.895099901@linuxfoundation.org>
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

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit 40d87aafee29fb01ce1e1868502fb2059a6a7f34 ]

In existing implementation, driver is freeing and un-mapping all the
decoded picture buffers(DPB) as part of dynamic resolution change(DRC)
handling. As a result, when firmware try to access the DPB buffer, from
previous sequence, SMMU context fault is seen due to the buffer being
already unmapped.

With this change, driver defines ownership of each DPB buffer. If a buffer
is owned by firmware, driver would skip from un-mapping the same.

Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 6c9934c5a00a ("media: venus: fix enc/dec destruction order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.h    |  1 +
 drivers/media/platform/qcom/venus/helpers.c | 51 ++++++++++++++++++++-
 drivers/media/platform/qcom/venus/helpers.h |  3 ++
 drivers/media/platform/qcom/venus/vdec.c    |  7 ++-
 4 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 5ec851115eca8..6869f0d06b774 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -452,6 +452,7 @@ struct venus_inst {
 	bool next_buf_last;
 	bool drain_active;
 	enum venus_inst_modes flags;
+	struct ida dpb_ids;
 };
 
 #define IS_V1(core)	((core)->res->hfi_version == HFI_VERSION_1XX)
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index ff705d513aae4..9d43d4dbfc60c 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
  * Copyright (C) 2017 Linaro Ltd.
  */
+#include <linux/idr.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -21,6 +22,11 @@
 #define NUM_MBS_720P	(((1280 + 15) >> 4) * ((720 + 15) >> 4))
 #define NUM_MBS_4K	(((4096 + 15) >> 4) * ((2304 + 15) >> 4))
 
+enum dpb_buf_owner {
+	DRIVER,
+	FIRMWARE,
+};
+
 struct intbuf {
 	struct list_head list;
 	u32 type;
@@ -28,6 +34,8 @@ struct intbuf {
 	void *va;
 	dma_addr_t da;
 	unsigned long attrs;
+	enum dpb_buf_owner owned_by;
+	u32 dpb_out_tag;
 };
 
 bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
@@ -95,9 +103,16 @@ int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
 		fdata.device_addr = buf->da;
 		fdata.buffer_type = buf->type;
 
+		if (buf->owned_by == FIRMWARE)
+			continue;
+
+		fdata.clnt_data = buf->dpb_out_tag;
+
 		ret = hfi_session_process_buf(inst, &fdata);
 		if (ret)
 			goto fail;
+
+		buf->owned_by = FIRMWARE;
 	}
 
 fail:
@@ -110,13 +125,19 @@ int venus_helper_free_dpb_bufs(struct venus_inst *inst)
 	struct intbuf *buf, *n;
 
 	list_for_each_entry_safe(buf, n, &inst->dpbbufs, list) {
+		if (buf->owned_by == FIRMWARE)
+			continue;
+
+		ida_free(&inst->dpb_ids, buf->dpb_out_tag);
+
 		list_del_init(&buf->list);
 		dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
 			       buf->attrs);
 		kfree(buf);
 	}
 
-	INIT_LIST_HEAD(&inst->dpbbufs);
+	if (list_empty(&inst->dpbbufs))
+		INIT_LIST_HEAD(&inst->dpbbufs);
 
 	return 0;
 }
@@ -134,6 +155,7 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
 	unsigned int i;
 	u32 count;
 	int ret;
+	int id;
 
 	/* no need to allocate dpb buffers */
 	if (!inst->dpb_fmt)
@@ -171,6 +193,15 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
 			ret = -ENOMEM;
 			goto fail;
 		}
+		buf->owned_by = DRIVER;
+
+		id = ida_alloc_min(&inst->dpb_ids, VB2_MAX_FRAME, GFP_KERNEL);
+		if (id < 0) {
+			ret = id;
+			goto fail;
+		}
+
+		buf->dpb_out_tag = id;
 
 		list_add_tail(&buf->list, &inst->dpbbufs);
 	}
@@ -1365,6 +1396,24 @@ venus_helper_find_buf(struct venus_inst *inst, unsigned int type, u32 idx)
 }
 EXPORT_SYMBOL_GPL(venus_helper_find_buf);
 
+void venus_helper_change_dpb_owner(struct venus_inst *inst,
+				   struct vb2_v4l2_buffer *vbuf, unsigned int type,
+				   unsigned int buf_type, u32 tag)
+{
+	struct intbuf *dpb_buf;
+
+	if (!V4L2_TYPE_IS_CAPTURE(type) ||
+	    buf_type != inst->dpb_buftype)
+		return;
+
+	list_for_each_entry(dpb_buf, &inst->dpbbufs, list)
+		if (dpb_buf->dpb_out_tag == tag) {
+			dpb_buf->owned_by = DRIVER;
+			break;
+		}
+}
+EXPORT_SYMBOL_GPL(venus_helper_change_dpb_owner);
+
 int venus_helper_vb2_buf_init(struct vb2_buffer *vb)
 {
 	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index e6269b4be3afb..ff8889795b433 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -14,6 +14,9 @@ struct venus_core;
 bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt);
 struct vb2_v4l2_buffer *venus_helper_find_buf(struct venus_inst *inst,
 					      unsigned int type, u32 idx);
+void venus_helper_change_dpb_owner(struct venus_inst *inst,
+				   struct vb2_v4l2_buffer *vbuf, unsigned int type,
+				   unsigned int buf_type, u32 idx);
 void venus_helper_buffers_done(struct venus_inst *inst, unsigned int type,
 			       enum vb2_buffer_state state);
 int venus_helper_vb2_buf_init(struct vb2_buffer *vb);
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 42134cde120db..fef414f624069 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1316,8 +1316,10 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 		type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 
 	vbuf = venus_helper_find_buf(inst, type, tag);
-	if (!vbuf)
+	if (!vbuf) {
+		venus_helper_change_dpb_owner(inst, vbuf, type, buf_type, tag);
 		return;
+	}
 
 	vbuf->flags = flags;
 	vbuf->field = V4L2_FIELD_NONE;
@@ -1590,6 +1592,8 @@ static int vdec_open(struct file *file)
 
 	vdec_inst_init(inst);
 
+	ida_init(&inst->dpb_ids);
+
 	/*
 	 * create m2m device for every instance, the m2m context scheduling
 	 * is made by firmware side so we do not need to care about.
@@ -1636,6 +1640,7 @@ static int vdec_close(struct file *file)
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	vdec_ctrl_deinit(inst);
+	ida_destroy(&inst->dpb_ids);
 	hfi_session_destroy(inst);
 	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
-- 
2.43.0



