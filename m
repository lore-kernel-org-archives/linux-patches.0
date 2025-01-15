Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66A31E98E0;
	Wed, 15 Jan 2025 10:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938449; cv=none; b=rjHv98H+gvgxsbEM60nf728lcMN1MvaLarsWB+gu/wnGMx7f5PV23vSoAdwCcBfs40jbaDVmVMkOz99GUgVR2Svgkvn96JT8dhjCAD7GdZueDa0GunSD75YUn+L8I/rcPMX1xl15ziWyYSv0p3CfW7BVv1IK0byAhl993gcXvXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938449; c=relaxed/simple;
	bh=2Et2Tborz7qTFKW09X8cbVdZm+JuV4egOwjyQgq3xCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPwKdUUQpZCKg1/VreajWGyBYWjxO9AZ269n5AI6qZyR8WV5HjmC3byE8sQfUBHH2mcxhOcB4RwpmVir7UBsBYbfb41os8gpRYgwJHLlDR/us7sEINqO8K6OjWbtZnr6itipHdgPb77vmqHA/Dzcdp1esBCzj2/xyifNpKaauT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmQnmzy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmQnmzy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD583C4CEE4;
	Wed, 15 Jan 2025 10:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938447;
	bh=2Et2Tborz7qTFKW09X8cbVdZm+JuV4egOwjyQgq3xCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmQnmzy8IGkf2+gIRbH9yBrpczDF6k50eYb2fUxmkeNQAyRApVK6Mkp8b8Fkb0FXm
	 b7ISOLFAsTn4eyaeKhyGRSu0r9ZnZ/pKkY40a6BzNcasEO8r7joKlToVaQjvD0caYr
	 KDkKS6xkG1p9qmmjo+hvpy7nnHyd1AQvjeIhQqR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.12 185/189] xe/oa: Fix query mode of operation for OAR/OAC
Date: Wed, 15 Jan 2025 11:38:01 +0100
Message-ID: <20250115103613.788765277@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit f0ed39830e6064d62f9c5393505677a26569bb56 ]

This is a set of squashed commits to facilitate smooth applying to
stable. Each commit message is retained for reference.

1) Allow a GGTT mapped batch to be submitted to user exec queue

For a OA use case, one of the HW registers needs to be modified by
submitting an MI_LOAD_REGISTER_IMM command to the users exec queue, so
that the register is modified in the user's hardware context. In order
to do this a batch that is mapped in GGTT, needs to be submitted to the
user exec queue. Since all user submissions use q->vm and hence PPGTT,
add some plumbing to enable submission of batches mapped in GGTT.

v2: ggtt is zero-initialized, so no need to set it false (Matt Brost)

2) xe/oa: Use MI_LOAD_REGISTER_IMMEDIATE to enable OAR/OAC

To enable OAR/OAC, a bit in RING_CONTEXT_CONTROL needs to be set.
Setting this bit cause the context image size to change and if not done
correct, can cause undesired hangs.

Current code uses a separate exec_queue to modify this bit and is
error-prone. As per HW recommendation, submit MI_LOAD_REGISTER_IMM to
the target hardware context to modify the relevant bit.

In v2 version, an attempt to submit everything to the user-queue was
made, but it failed the unprivileged-single-ctx-counters test. It
appears that the OACTXCONTROL must be modified from a remote context.

In v3 version, all context specific register configurations were moved
to use LOAD_REGISTER_IMMEDIATE and that seems to work well. This is a
cleaner way, since we can now submit all configuration to user
exec_queue and the fence handling is simplified.

v2:
(Matt)
- set job->ggtt to true if create job is successful
- unlock vm on job error

(Ashutosh)
- don't wait on job submission
- use kernel exec queue where possible

v3:
(Ashutosh)
- Fix checkpatch issues
- Remove extra spaces/new-lines
- Add Fixes: and Cc: tags
- Reset context control bit when OA stream is closed
- Submit all config via MI_LOAD_REGISTER_IMMEDIATE

(Umesh)
- Update commit message for v3 experiment
- Squash patches for easier port to stable

v4:
(Ashutosh)
- No need to pass q to xe_oa_submit_bb
- Do not support exec queues with width > 1
- Fix disabling of CTX_CTRL_OAC_CONTEXT_ENABLE

v5:
(Ashutosh)
- Drop reg_lri related comments
- Use XE_OA_SUBMIT_NO_DEPS in xe_oa_load_with_lri

Fixes: 8135f1c09dd2 ("drm/xe/oa: Don't reset OAC_CONTEXT_ENABLE on OA stream close")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com> # commit 1
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241220171919.571528-2-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 55039832f98c7e05f1cf9e0d8c12b2490abd0f16)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c              | 134 ++++++++----------------
 drivers/gpu/drm/xe/xe_ring_ops.c        |   5 +-
 drivers/gpu/drm/xe/xe_sched_job_types.h |   2 +
 3 files changed, 51 insertions(+), 90 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index fd14d62bfb54..d81f0b05b2df 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -69,12 +69,6 @@ struct xe_oa_config {
 	struct rcu_head rcu;
 };
 
-struct flex {
-	struct xe_reg reg;
-	u32 offset;
-	u32 value;
-};
-
 struct xe_oa_open_param {
 	struct xe_file *xef;
 	u32 oa_unit_id;
@@ -577,19 +571,38 @@ static __poll_t xe_oa_poll(struct file *file, poll_table *wait)
 	return ret;
 }
 
+static void xe_oa_lock_vma(struct xe_exec_queue *q)
+{
+	if (q->vm) {
+		down_read(&q->vm->lock);
+		xe_vm_lock(q->vm, false);
+	}
+}
+
+static void xe_oa_unlock_vma(struct xe_exec_queue *q)
+{
+	if (q->vm) {
+		xe_vm_unlock(q->vm);
+		up_read(&q->vm->lock);
+	}
+}
+
 static struct dma_fence *xe_oa_submit_bb(struct xe_oa_stream *stream, enum xe_oa_submit_deps deps,
 					 struct xe_bb *bb)
 {
+	struct xe_exec_queue *q = stream->exec_q ?: stream->k_exec_q;
 	struct xe_sched_job *job;
 	struct dma_fence *fence;
 	int err = 0;
 
-	/* Kernel configuration is issued on stream->k_exec_q, not stream->exec_q */
-	job = xe_bb_create_job(stream->k_exec_q, bb);
+	xe_oa_lock_vma(q);
+
+	job = xe_bb_create_job(q, bb);
 	if (IS_ERR(job)) {
 		err = PTR_ERR(job);
 		goto exit;
 	}
+	job->ggtt = true;
 
 	if (deps == XE_OA_SUBMIT_ADD_DEPS) {
 		for (int i = 0; i < stream->num_syncs && !err; i++)
@@ -604,10 +617,13 @@ static struct dma_fence *xe_oa_submit_bb(struct xe_oa_stream *stream, enum xe_oa
 	fence = dma_fence_get(&job->drm.s_fence->finished);
 	xe_sched_job_push(job);
 
+	xe_oa_unlock_vma(q);
+
 	return fence;
 err_put_job:
 	xe_sched_job_put(job);
 exit:
+	xe_oa_unlock_vma(q);
 	return ERR_PTR(err);
 }
 
@@ -655,63 +671,19 @@ static void xe_oa_free_configs(struct xe_oa_stream *stream)
 		free_oa_config_bo(oa_bo);
 }
 
-static void xe_oa_store_flex(struct xe_oa_stream *stream, struct xe_lrc *lrc,
-			     struct xe_bb *bb, const struct flex *flex, u32 count)
-{
-	u32 offset = xe_bo_ggtt_addr(lrc->bo);
-
-	do {
-		bb->cs[bb->len++] = MI_STORE_DATA_IMM | MI_SDI_GGTT | MI_SDI_NUM_DW(1);
-		bb->cs[bb->len++] = offset + flex->offset * sizeof(u32);
-		bb->cs[bb->len++] = 0;
-		bb->cs[bb->len++] = flex->value;
-
-	} while (flex++, --count);
-}
-
-static int xe_oa_modify_ctx_image(struct xe_oa_stream *stream, struct xe_lrc *lrc,
-				  const struct flex *flex, u32 count)
-{
-	struct dma_fence *fence;
-	struct xe_bb *bb;
-	int err;
-
-	bb = xe_bb_new(stream->gt, 4 * count, false);
-	if (IS_ERR(bb)) {
-		err = PTR_ERR(bb);
-		goto exit;
-	}
-
-	xe_oa_store_flex(stream, lrc, bb, flex, count);
-
-	fence = xe_oa_submit_bb(stream, XE_OA_SUBMIT_NO_DEPS, bb);
-	if (IS_ERR(fence)) {
-		err = PTR_ERR(fence);
-		goto free_bb;
-	}
-	xe_bb_free(bb, fence);
-	dma_fence_put(fence);
-
-	return 0;
-free_bb:
-	xe_bb_free(bb, NULL);
-exit:
-	return err;
-}
-
-static int xe_oa_load_with_lri(struct xe_oa_stream *stream, struct xe_oa_reg *reg_lri)
+static int xe_oa_load_with_lri(struct xe_oa_stream *stream, struct xe_oa_reg *reg_lri, u32 count)
 {
 	struct dma_fence *fence;
 	struct xe_bb *bb;
 	int err;
 
-	bb = xe_bb_new(stream->gt, 3, false);
+	bb = xe_bb_new(stream->gt, 2 * count + 1, false);
 	if (IS_ERR(bb)) {
 		err = PTR_ERR(bb);
 		goto exit;
 	}
 
-	write_cs_mi_lri(bb, reg_lri, 1);
+	write_cs_mi_lri(bb, reg_lri, count);
 
 	fence = xe_oa_submit_bb(stream, XE_OA_SUBMIT_NO_DEPS, bb);
 	if (IS_ERR(fence)) {
@@ -731,70 +703,54 @@ static int xe_oa_load_with_lri(struct xe_oa_stream *stream, struct xe_oa_reg *re
 static int xe_oa_configure_oar_context(struct xe_oa_stream *stream, bool enable)
 {
 	const struct xe_oa_format *format = stream->oa_buffer.format;
-	struct xe_lrc *lrc = stream->exec_q->lrc[0];
-	u32 regs_offset = xe_lrc_regs_offset(lrc) / sizeof(u32);
 	u32 oacontrol = __format_to_oactrl(format, OAR_OACONTROL_COUNTER_SEL_MASK) |
 		(enable ? OAR_OACONTROL_COUNTER_ENABLE : 0);
 
-	struct flex regs_context[] = {
+	struct xe_oa_reg reg_lri[] = {
 		{
 			OACTXCONTROL(stream->hwe->mmio_base),
-			stream->oa->ctx_oactxctrl_offset[stream->hwe->class] + 1,
 			enable ? OA_COUNTER_RESUME : 0,
 		},
+		{
+			OAR_OACONTROL,
+			oacontrol,
+		},
 		{
 			RING_CONTEXT_CONTROL(stream->hwe->mmio_base),
-			regs_offset + CTX_CONTEXT_CONTROL,
-			_MASKED_BIT_ENABLE(CTX_CTRL_OAC_CONTEXT_ENABLE),
+			_MASKED_FIELD(CTX_CTRL_OAC_CONTEXT_ENABLE,
+				      enable ? CTX_CTRL_OAC_CONTEXT_ENABLE : 0)
 		},
 	};
-	struct xe_oa_reg reg_lri = { OAR_OACONTROL, oacontrol };
-	int err;
-
-	/* Modify stream hwe context image with regs_context */
-	err = xe_oa_modify_ctx_image(stream, stream->exec_q->lrc[0],
-				     regs_context, ARRAY_SIZE(regs_context));
-	if (err)
-		return err;
 
-	/* Apply reg_lri using LRI */
-	return xe_oa_load_with_lri(stream, &reg_lri);
+	return xe_oa_load_with_lri(stream, reg_lri, ARRAY_SIZE(reg_lri));
 }
 
 static int xe_oa_configure_oac_context(struct xe_oa_stream *stream, bool enable)
 {
 	const struct xe_oa_format *format = stream->oa_buffer.format;
-	struct xe_lrc *lrc = stream->exec_q->lrc[0];
-	u32 regs_offset = xe_lrc_regs_offset(lrc) / sizeof(u32);
 	u32 oacontrol = __format_to_oactrl(format, OAR_OACONTROL_COUNTER_SEL_MASK) |
 		(enable ? OAR_OACONTROL_COUNTER_ENABLE : 0);
-	struct flex regs_context[] = {
+	struct xe_oa_reg reg_lri[] = {
 		{
 			OACTXCONTROL(stream->hwe->mmio_base),
-			stream->oa->ctx_oactxctrl_offset[stream->hwe->class] + 1,
 			enable ? OA_COUNTER_RESUME : 0,
 		},
+		{
+			OAC_OACONTROL,
+			oacontrol
+		},
 		{
 			RING_CONTEXT_CONTROL(stream->hwe->mmio_base),
-			regs_offset + CTX_CONTEXT_CONTROL,
-			_MASKED_BIT_ENABLE(CTX_CTRL_OAC_CONTEXT_ENABLE) |
+			_MASKED_FIELD(CTX_CTRL_OAC_CONTEXT_ENABLE,
+				      enable ? CTX_CTRL_OAC_CONTEXT_ENABLE : 0) |
 			_MASKED_FIELD(CTX_CTRL_RUN_ALONE, enable ? CTX_CTRL_RUN_ALONE : 0),
 		},
 	};
-	struct xe_oa_reg reg_lri = { OAC_OACONTROL, oacontrol };
-	int err;
 
 	/* Set ccs select to enable programming of OAC_OACONTROL */
 	xe_mmio_write32(stream->gt, __oa_regs(stream)->oa_ctrl, __oa_ccs_select(stream));
 
-	/* Modify stream hwe context image with regs_context */
-	err = xe_oa_modify_ctx_image(stream, stream->exec_q->lrc[0],
-				     regs_context, ARRAY_SIZE(regs_context));
-	if (err)
-		return err;
-
-	/* Apply reg_lri using LRI */
-	return xe_oa_load_with_lri(stream, &reg_lri);
+	return xe_oa_load_with_lri(stream, reg_lri, ARRAY_SIZE(reg_lri));
 }
 
 static int xe_oa_configure_oa_context(struct xe_oa_stream *stream, bool enable)
@@ -1933,8 +1889,8 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 		if (XE_IOCTL_DBG(oa->xe, !param.exec_q))
 			return -ENOENT;
 
-		if (param.exec_q->width > 1)
-			drm_dbg(&oa->xe->drm, "exec_q->width > 1, programming only exec_q->lrc[0]\n");
+		if (XE_IOCTL_DBG(oa->xe, param.exec_q->width > 1))
+			return -EOPNOTSUPP;
 	}
 
 	/*
diff --git a/drivers/gpu/drm/xe/xe_ring_ops.c b/drivers/gpu/drm/xe/xe_ring_ops.c
index 0be4f489d3e1..9f327f27c072 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -221,7 +221,10 @@ static int emit_pipe_imm_ggtt(u32 addr, u32 value, bool stall_only, u32 *dw,
 
 static u32 get_ppgtt_flag(struct xe_sched_job *job)
 {
-	return job->q->vm ? BIT(8) : 0;
+	if (job->q->vm && !job->ggtt)
+		return BIT(8);
+
+	return 0;
 }
 
 static int emit_copy_timestamp(struct xe_lrc *lrc, u32 *dw, int i)
diff --git a/drivers/gpu/drm/xe/xe_sched_job_types.h b/drivers/gpu/drm/xe/xe_sched_job_types.h
index 0d3f76fb05ce..c207361bf43e 100644
--- a/drivers/gpu/drm/xe/xe_sched_job_types.h
+++ b/drivers/gpu/drm/xe/xe_sched_job_types.h
@@ -57,6 +57,8 @@ struct xe_sched_job {
 	u32 migrate_flush_flags;
 	/** @ring_ops_flush_tlb: The ring ops need to flush TLB before payload. */
 	bool ring_ops_flush_tlb;
+	/** @ggtt: mapped in ggtt. */
+	bool ggtt;
 	/** @ptrs: per instance pointers. */
 	struct xe_job_ptrs ptrs[];
 };
-- 
2.39.5



