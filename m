Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EFD28E584;
	Wed,  7 May 2025 19:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644741; cv=none; b=P28TWzhBPuL7FSdG0zveSjNQt2IOdpvjfqfqu5qfjxf2VrOT/jrU6GUN9Kxa1RdyJOBknnhiqCHKQtqubhvdFDlAA7hdUmUigXjKQ5hMXynDLvqeN4pH+Yz6/ylysQEyLJTcDBB365pTgf8aAb6EbKzqL8KAHqflKqIWboWTTGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644741; c=relaxed/simple;
	bh=5Q9h27ciXyg3bCX4cRQBKJbyvmLL99k1X126JYPFZ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS+v8/0dboVY0Ojaxy3+VdbGBTcM2As6JsFne+mfFshuj2MuBaDF7XMkDfeFt6+k6/d6pMnMJK/3PF8u7IyHaCPtKfrE4rp3mECTtmjqWiIfWJ05P2kfXeJggHFYj7croBMamb1a5QAOCuZ2sdWjWOx1grCLFU9hVwh5VQjZZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po9b1J37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po9b1J37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2484EC4CEE2;
	Wed,  7 May 2025 19:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644741;
	bh=5Q9h27ciXyg3bCX4cRQBKJbyvmLL99k1X126JYPFZ5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po9b1J37pFyb8OAJGzZZ4JNdCjGbVOSa4WKfU0VFFbwY2iFG4L65/+MAy0Rk8M84C
	 Odl2iNtaxakslXDT99Ng6ITEo8urh61L1+29bzuxiGZbbruFUJ4ckT5gEYv5HX/jsN
	 BewtB0SDMnYUBqj911dsp0Na2oYMDB2eLcQN5zP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.12 141/164] accel/ivpu: Use xa_alloc_cyclic() instead of custom function
Date: Wed,  7 May 2025 20:40:26 +0200
Message-ID: <20250507183826.680121483@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@intel.com>

commit ae7af7d8dc2a13a427aa90d003fe4fb2c168342a upstream.

Remove custom ivpu_id_alloc() wrapper used for ID allocations
and replace it with standard xa_alloc_cyclic() API.

The idea behind ivpu_id_alloc() was to have monotonic IDs, so the driver
is easier to debug because same IDs are not reused all over. The same
can be achieved just by using appropriate Linux API.

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241017145817.121590-7-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |   11 ++++-------
 drivers/accel/ivpu/ivpu_drv.h |    4 ++--
 drivers/accel/ivpu/ivpu_job.c |   34 ++++++----------------------------
 3 files changed, 12 insertions(+), 37 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -260,10 +260,8 @@ static int ivpu_open(struct drm_device *
 	if (ret)
 		goto err_xa_erase;
 
-	file_priv->default_job_limit.min = FIELD_PREP(IVPU_JOB_ID_CONTEXT_MASK,
-						      (file_priv->ctx.id - 1));
-	file_priv->default_job_limit.max = file_priv->default_job_limit.min | IVPU_JOB_ID_JOB_MASK;
-	file_priv->job_limit = file_priv->default_job_limit;
+	file_priv->job_limit.min = FIELD_PREP(IVPU_JOB_ID_CONTEXT_MASK, (file_priv->ctx.id - 1));
+	file_priv->job_limit.max = file_priv->job_limit.min | IVPU_JOB_ID_JOB_MASK;
 
 	mutex_unlock(&vdev->context_list_lock);
 	drm_dev_exit(idx);
@@ -612,9 +610,8 @@ static int ivpu_dev_init(struct ivpu_dev
 	lockdep_set_class(&vdev->submitted_jobs_xa.xa_lock, &submitted_jobs_xa_lock_class_key);
 	INIT_LIST_HEAD(&vdev->bo_list);
 
-	vdev->default_db_limit.min = IVPU_MIN_DB;
-	vdev->default_db_limit.max = IVPU_MAX_DB;
-	vdev->db_limit = vdev->default_db_limit;
+	vdev->db_limit.min = IVPU_MIN_DB;
+	vdev->db_limit.max = IVPU_MAX_DB;
 
 	ret = drmm_mutex_init(&vdev->drm, &vdev->context_list_lock);
 	if (ret)
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -140,7 +140,7 @@ struct ivpu_device {
 
 	struct xarray db_xa;
 	struct xa_limit db_limit;
-	struct xa_limit default_db_limit;
+	u32 db_next;
 
 	struct mutex bo_list_lock; /* Protects bo_list */
 	struct list_head bo_list;
@@ -177,7 +177,7 @@ struct ivpu_file_priv {
 	struct list_head ms_instance_list;
 	struct ivpu_bo *ms_info_bo;
 	struct xa_limit job_limit;
-	struct xa_limit default_job_limit;
+	u32 job_id_next;
 	bool has_mmu_faults;
 	bool bound;
 	bool aborted;
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -75,26 +75,6 @@ static void ivpu_preemption_buffers_free
 	ivpu_bo_free(cmdq->secondary_preempt_buf);
 }
 
-static int ivpu_id_alloc(struct xarray *xa, u32 *id, void *entry, struct xa_limit *limit,
-			 const struct xa_limit default_limit)
-{
-	int ret;
-
-	ret = __xa_alloc(xa, id, entry, *limit, GFP_KERNEL);
-	if (ret) {
-		limit->min = default_limit.min;
-		ret = __xa_alloc(xa, id, entry, *limit, GFP_KERNEL);
-		if (ret)
-			return ret;
-	}
-
-	limit->min = *id + 1;
-	if (limit->min > limit->max)
-		limit->min = default_limit.min;
-
-	return ret;
-}
-
 static struct ivpu_cmdq *ivpu_cmdq_alloc(struct ivpu_file_priv *file_priv)
 {
 	struct ivpu_device *vdev = file_priv->vdev;
@@ -105,11 +85,9 @@ static struct ivpu_cmdq *ivpu_cmdq_alloc
 	if (!cmdq)
 		return NULL;
 
-	xa_lock(&vdev->db_xa); /* lock here to protect db_limit */
-	ret = ivpu_id_alloc(&vdev->db_xa, &cmdq->db_id, NULL, &vdev->db_limit,
-			    vdev->default_db_limit);
-	xa_unlock(&vdev->db_xa);
-	if (ret) {
+	ret = xa_alloc_cyclic(&vdev->db_xa, &cmdq->db_id, NULL, vdev->db_limit, &vdev->db_next,
+			      GFP_KERNEL);
+	if (ret < 0) {
 		ivpu_err(vdev, "Failed to allocate doorbell id: %d\n", ret);
 		goto err_free_cmdq;
 	}
@@ -559,9 +537,9 @@ static int ivpu_job_submit(struct ivpu_j
 
 	xa_lock(&vdev->submitted_jobs_xa);
 	is_first_job = xa_empty(&vdev->submitted_jobs_xa);
-	ret = ivpu_id_alloc(&vdev->submitted_jobs_xa, &job->job_id, job, &file_priv->job_limit,
-			    file_priv->default_job_limit);
-	if (ret) {
+	ret = __xa_alloc_cyclic(&vdev->submitted_jobs_xa, &job->job_id, job, file_priv->job_limit,
+				&file_priv->job_id_next, GFP_KERNEL);
+	if (ret < 0) {
 		ivpu_dbg(vdev, JOB, "Too many active jobs in ctx %d\n",
 			 file_priv->ctx.id);
 		ret = -EBUSY;


