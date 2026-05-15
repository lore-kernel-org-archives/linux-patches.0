Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A63E0092;
	Fri, 15 May 2026 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862524; cv=none; b=DGVoZj2V3erYoBfKqZsUQ46wIvykbxvvm+FayVtW2/xqRltytgJABVJKIbglbRkOK/t3IEJ1geDCzmRVQ1UfQczkm/JSox+8mcnhV0ajNX6i7jM+NZ6n9BBuj9/q5GsXmnVzl6cfypaLFNJc3RSe8X4Dj2maTU88srf21rM3g1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862524; c=relaxed/simple;
	bh=5Ydec4jVfZflJ9BMnefuWdvBDNKx6ZJKfjKbj3dC8Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeMFiNatblfWwB9DpiQgQ6uQjvqRnCacGAx3X0Qb5YPj7wRXZb1vHkMXES7qAm4/kB63C9CYLk8S8W9DToluUbu3LFQlgNZlkMNA2TTmY31I/nD0zmmfs4hYkVsVERi+w0jqISQDgwc6t7cqX3hMVg8YuL1jACfh+yuhuJePzVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVT93bpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVT93bpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D720C2BCB0;
	Fri, 15 May 2026 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862523;
	bh=5Ydec4jVfZflJ9BMnefuWdvBDNKx6ZJKfjKbj3dC8Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVT93bpjBKlHjn0gR24fbcLTv7svGHmV6/f2hwlHVbJBwHbUgRPkm/2f+jHfPlYib
	 pmd4DqQktJi4dmZA77hgiu/ADRgzkobtsjvYs5orWg5XJca0pltHPdXlmB5AJLi2E1
	 1oUl6s/IAu0YObmNRhJlnh2HWZU58EWSAenUeZ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 079/201] media: iris: fix use-after-free of fmt_src during MBPF check
Date: Fri, 15 May 2026 17:48:17 +0200
Message-ID: <20260515154700.243844154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

commit 3d9593ad1a58c5acc3e5fa2a48222bb7632e6812 upstream.

During concurrency testing, multiple instances can run in parallel, and
each instance uses its own inst->lock while the core->lock protects the
list of active instances. The race happens because these locks cover
different scopes, inst->lock protects only the internals of a single
instance, while the Macro Blocks Per Frame (MBPF) checker walks the
core list under core->lock and reads fields like fmt_src->width and
fmt_src->height. At the same time, iris_close() may free fmt_src and
fmt_dst under inst->lock while the instance is still present in the core
list. This allows a situation where the MBPF checker, still iterating
through the core list, reaches an instance whose fmt_src was already
freed by another thread and ends up dereferencing a dangling pointer,
resulting in a use-after-free. This happens because the MBPF checker
assumes that any instance in the core list is fully valid, but the
freeing of fmt_src and fmt_dst without removing the instance from the
core list is not correct.

The correct ordering is to defer freeing fmt_src and fmt_dst until after
the instance has been removed from the core list and all teardown under
the core lock has completed, ensuring that no dangling pointers are ever
exposed during MBPF checks.

Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Fixes: 5ad964ad5656 ("media: iris: Initialize and deinitialize encoder instance structure")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vdec.c |    6 ------
 drivers/media/platform/qcom/iris/iris_vdec.h |    1 -
 drivers/media/platform/qcom/iris/iris_venc.c |    6 ------
 drivers/media/platform/qcom/iris/iris_venc.h |    1 -
 drivers/media/platform/qcom/iris/iris_vidc.c |    6 ++----
 5 files changed, 2 insertions(+), 18 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_vdec.c
+++ b/drivers/media/platform/qcom/iris/iris_vdec.c
@@ -61,12 +61,6 @@ int iris_vdec_inst_init(struct iris_inst
 	return iris_ctrls_init(inst);
 }
 
-void iris_vdec_inst_deinit(struct iris_inst *inst)
-{
-	kfree(inst->fmt_dst);
-	kfree(inst->fmt_src);
-}
-
 static const struct iris_fmt iris_vdec_formats_cap[] = {
 	[IRIS_FMT_NV12] = {
 		.pixfmt = V4L2_PIX_FMT_NV12,
--- a/drivers/media/platform/qcom/iris/iris_vdec.h
+++ b/drivers/media/platform/qcom/iris/iris_vdec.h
@@ -9,7 +9,6 @@
 struct iris_inst;
 
 int iris_vdec_inst_init(struct iris_inst *inst);
-void iris_vdec_inst_deinit(struct iris_inst *inst);
 int iris_vdec_enum_fmt(struct iris_inst *inst, struct v4l2_fmtdesc *f);
 int iris_vdec_try_fmt(struct iris_inst *inst, struct v4l2_format *f);
 int iris_vdec_s_fmt(struct iris_inst *inst, struct v4l2_format *f);
--- a/drivers/media/platform/qcom/iris/iris_venc.c
+++ b/drivers/media/platform/qcom/iris/iris_venc.c
@@ -79,12 +79,6 @@ int iris_venc_inst_init(struct iris_inst
 	return iris_ctrls_init(inst);
 }
 
-void iris_venc_inst_deinit(struct iris_inst *inst)
-{
-	kfree(inst->fmt_dst);
-	kfree(inst->fmt_src);
-}
-
 static const struct iris_fmt iris_venc_formats_cap[] = {
 	[IRIS_FMT_H264] = {
 		.pixfmt = V4L2_PIX_FMT_H264,
--- a/drivers/media/platform/qcom/iris/iris_venc.h
+++ b/drivers/media/platform/qcom/iris/iris_venc.h
@@ -9,7 +9,6 @@
 struct iris_inst;
 
 int iris_venc_inst_init(struct iris_inst *inst);
-void iris_venc_inst_deinit(struct iris_inst *inst);
 int iris_venc_enum_fmt(struct iris_inst *inst, struct v4l2_fmtdesc *f);
 int iris_venc_try_fmt(struct iris_inst *inst, struct v4l2_format *f);
 int iris_venc_s_fmt(struct iris_inst *inst, struct v4l2_format *f);
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -289,10 +289,6 @@ int iris_close(struct file *filp)
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	mutex_lock(&inst->lock);
-	if (inst->domain == DECODER)
-		iris_vdec_inst_deinit(inst);
-	else if (inst->domain == ENCODER)
-		iris_venc_inst_deinit(inst);
 	iris_session_close(inst);
 	iris_inst_change_state(inst, IRIS_INST_DEINIT);
 	iris_v4l2_fh_deinit(inst, filp);
@@ -304,6 +300,8 @@ int iris_close(struct file *filp)
 	mutex_unlock(&inst->lock);
 	mutex_destroy(&inst->ctx_q_lock);
 	mutex_destroy(&inst->lock);
+	kfree(inst->fmt_src);
+	kfree(inst->fmt_dst);
 	kfree(inst);
 
 	return 0;


