Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B9A1E22E9;
	Wed,  7 May 2025 19:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644738; cv=none; b=FDl7ffaevrT2zFs59xaystXFZQHRs/xInzXgJphzEtcFODQ2UcnuMJP9O5eGOtL7/HivLk54h5HcfBUFHrkpDLTxbiFuPDk130YaQ/iv+xYXSYw0xI8FAdG2IB0Jic03Dg0tLFpiGEMVrXrKliWC+RcC5oIXCLkq2T6CGswtxMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644738; c=relaxed/simple;
	bh=XfyawWXnYHYlb7ZbI6cPmTj1ijn2G1Fw2HLl9L+wdzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWk4snADPjsIXDm0bmVwaUWBki0tBk+CEKb80fektwkBGafs/54XJK45XReSYHFKMPzZ2XRJndnz7QoxnxRq0as4QGAgySOfYgRHXbx6TM1iOHkH5bUL0gwmN/RJue2VV0m3tAYVwiv60VRtLyOeP1orAJwjcCMOzK2ms04mMYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzJni0JB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzJni0JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2D9C4CEE2;
	Wed,  7 May 2025 19:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644738;
	bh=XfyawWXnYHYlb7ZbI6cPmTj1ijn2G1Fw2HLl9L+wdzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzJni0JBT8t8gJ/WXE+kd/Q1TDDt6bayX2SjtGgEzzNQJtRFvbwPaArBGWqum0Q3I
	 /DDWBw4+EynK57qSPfnHN+sAB0YhgRSOx7eeWnalZLO5/P0AgH11x+rL3o9UUlrMwR
	 ld8fkvjfn3zviKeeVMdj1Kr9iCRlj2QwocnhNWOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.12 140/164] accel/ivpu: Make DB_ID and JOB_ID allocations incremental
Date: Wed,  7 May 2025 20:40:25 +0200
Message-ID: <20250507183826.641014242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>

commit c3b0ec0fe0c7ebc4eb42ba60f7340ecdb7aae1a2 upstream.

Save last used ID and use it to limit the possible values
for the ID. This should decrease the rate at which the IDs
are reused, which will make debugging easier.

Signed-off-by: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-19-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |    9 +++++++++
 drivers/accel/ivpu/ivpu_drv.h |    7 +++++++
 drivers/accel/ivpu/ivpu_job.c |   37 +++++++++++++++++++++++++++----------
 3 files changed, 43 insertions(+), 10 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -260,6 +260,11 @@ static int ivpu_open(struct drm_device *
 	if (ret)
 		goto err_xa_erase;
 
+	file_priv->default_job_limit.min = FIELD_PREP(IVPU_JOB_ID_CONTEXT_MASK,
+						      (file_priv->ctx.id - 1));
+	file_priv->default_job_limit.max = file_priv->default_job_limit.min | IVPU_JOB_ID_JOB_MASK;
+	file_priv->job_limit = file_priv->default_job_limit;
+
 	mutex_unlock(&vdev->context_list_lock);
 	drm_dev_exit(idx);
 
@@ -607,6 +612,10 @@ static int ivpu_dev_init(struct ivpu_dev
 	lockdep_set_class(&vdev->submitted_jobs_xa.xa_lock, &submitted_jobs_xa_lock_class_key);
 	INIT_LIST_HEAD(&vdev->bo_list);
 
+	vdev->default_db_limit.min = IVPU_MIN_DB;
+	vdev->default_db_limit.max = IVPU_MAX_DB;
+	vdev->db_limit = vdev->default_db_limit;
+
 	ret = drmm_mutex_init(&vdev->drm, &vdev->context_list_lock);
 	if (ret)
 		goto err_xa_destroy;
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -46,6 +46,9 @@
 #define IVPU_MIN_DB 1
 #define IVPU_MAX_DB 255
 
+#define IVPU_JOB_ID_JOB_MASK		GENMASK(7, 0)
+#define IVPU_JOB_ID_CONTEXT_MASK	GENMASK(31, 8)
+
 #define IVPU_NUM_ENGINES       2
 #define IVPU_NUM_PRIORITIES    4
 #define IVPU_NUM_CMDQS_PER_CTX (IVPU_NUM_ENGINES * IVPU_NUM_PRIORITIES)
@@ -136,6 +139,8 @@ struct ivpu_device {
 	struct xa_limit context_xa_limit;
 
 	struct xarray db_xa;
+	struct xa_limit db_limit;
+	struct xa_limit default_db_limit;
 
 	struct mutex bo_list_lock; /* Protects bo_list */
 	struct list_head bo_list;
@@ -171,6 +176,8 @@ struct ivpu_file_priv {
 	struct mutex ms_lock; /* Protects ms_instance_list, ms_info_bo */
 	struct list_head ms_instance_list;
 	struct ivpu_bo *ms_info_bo;
+	struct xa_limit job_limit;
+	struct xa_limit default_job_limit;
 	bool has_mmu_faults;
 	bool bound;
 	bool aborted;
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -21,8 +21,6 @@
 #include "vpu_boot_api.h"
 
 #define CMD_BUF_IDX	     0
-#define JOB_ID_JOB_MASK	     GENMASK(7, 0)
-#define JOB_ID_CONTEXT_MASK  GENMASK(31, 8)
 #define JOB_MAX_BUFFER_COUNT 65535
 
 static void ivpu_cmdq_ring_db(struct ivpu_device *vdev, struct ivpu_cmdq *cmdq)
@@ -77,9 +75,28 @@ static void ivpu_preemption_buffers_free
 	ivpu_bo_free(cmdq->secondary_preempt_buf);
 }
 
+static int ivpu_id_alloc(struct xarray *xa, u32 *id, void *entry, struct xa_limit *limit,
+			 const struct xa_limit default_limit)
+{
+	int ret;
+
+	ret = __xa_alloc(xa, id, entry, *limit, GFP_KERNEL);
+	if (ret) {
+		limit->min = default_limit.min;
+		ret = __xa_alloc(xa, id, entry, *limit, GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
+
+	limit->min = *id + 1;
+	if (limit->min > limit->max)
+		limit->min = default_limit.min;
+
+	return ret;
+}
+
 static struct ivpu_cmdq *ivpu_cmdq_alloc(struct ivpu_file_priv *file_priv)
 {
-	struct xa_limit db_xa_limit = {.max = IVPU_MAX_DB, .min = IVPU_MIN_DB};
 	struct ivpu_device *vdev = file_priv->vdev;
 	struct ivpu_cmdq *cmdq;
 	int ret;
@@ -88,7 +105,10 @@ static struct ivpu_cmdq *ivpu_cmdq_alloc
 	if (!cmdq)
 		return NULL;
 
-	ret = xa_alloc(&vdev->db_xa, &cmdq->db_id, NULL, db_xa_limit, GFP_KERNEL);
+	xa_lock(&vdev->db_xa); /* lock here to protect db_limit */
+	ret = ivpu_id_alloc(&vdev->db_xa, &cmdq->db_id, NULL, &vdev->db_limit,
+			    vdev->default_db_limit);
+	xa_unlock(&vdev->db_xa);
 	if (ret) {
 		ivpu_err(vdev, "Failed to allocate doorbell id: %d\n", ret);
 		goto err_free_cmdq;
@@ -519,7 +539,6 @@ static int ivpu_job_submit(struct ivpu_j
 {
 	struct ivpu_file_priv *file_priv = job->file_priv;
 	struct ivpu_device *vdev = job->vdev;
-	struct xa_limit job_id_range;
 	struct ivpu_cmdq *cmdq;
 	bool is_first_job;
 	int ret;
@@ -530,7 +549,7 @@ static int ivpu_job_submit(struct ivpu_j
 
 	mutex_lock(&file_priv->lock);
 
-	cmdq = ivpu_cmdq_acquire(job->file_priv, job->engine_idx, priority);
+	cmdq = ivpu_cmdq_acquire(file_priv, job->engine_idx, priority);
 	if (!cmdq) {
 		ivpu_warn_ratelimited(vdev, "Failed to get job queue, ctx %d engine %d prio %d\n",
 				      file_priv->ctx.id, job->engine_idx, priority);
@@ -538,12 +557,10 @@ static int ivpu_job_submit(struct ivpu_j
 		goto err_unlock_file_priv;
 	}
 
-	job_id_range.min = FIELD_PREP(JOB_ID_CONTEXT_MASK, (file_priv->ctx.id - 1));
-	job_id_range.max = job_id_range.min | JOB_ID_JOB_MASK;
-
 	xa_lock(&vdev->submitted_jobs_xa);
 	is_first_job = xa_empty(&vdev->submitted_jobs_xa);
-	ret = __xa_alloc(&vdev->submitted_jobs_xa, &job->job_id, job, job_id_range, GFP_KERNEL);
+	ret = ivpu_id_alloc(&vdev->submitted_jobs_xa, &job->job_id, job, &file_priv->job_limit,
+			    file_priv->default_job_limit);
 	if (ret) {
 		ivpu_dbg(vdev, JOB, "Too many active jobs in ctx %d\n",
 			 file_priv->ctx.id);


