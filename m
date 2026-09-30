Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E978751A747;
	Wed, 30 Sep 2026 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788031; cv=none; b=ZNYqY1Fi1fuMkaiaK2OkblhTxe8FtD27gZ6D4XICC0lZAl6Z1Sleu9pqdv6K0T+5Tjm5nmApNxgRCx25qfC9L3gspdl43qkJP6uckDeQAXlA7lGAb+86Vd5c0VOR/2VKeEYbH68Lk8QpCQJP5Ck4YAA7itjNqg/ys8EG7OgyyKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788031; c=relaxed/simple;
	bh=RTnShCk/f2MNHFscAGdgj7XgrOG53EdrU8+kGNcn+KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG3/kQpWzIBCqhMVCdP2sw9dyoZ75npvHtW8D6pKmE33MZYHhIML02HClHsTYoD6PCNXwe/uAvnli2Ih8p8zue/32+PBvlurE/vkytWQeJHG/v1qQGt9x4H8LYPU6MgSdMo5XnPccJhLKp+2bQ/9DshXrnSavAWonp/sKZGYyB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5B3gy6W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5B3gy6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0831F000FF;
	Wed, 30 Sep 2026 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788029;
	bh=eGo/gHOXFWIiyWK30YIPXBQBqnrRCDAkDAAIPAJX4Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5B3gy6WLoabrgMCFsYJ8R8n8QeBrY5dyEuqM1uY4zdUokDcdmY0yEC8ZjAgtZzsS
	 WrjXwOWLRJeMSeKsn7/uVW6SouF6ASSZeI371Ol47Ob/Qaut69mpsjAgBTkdoVssMU
	 eGEilp6Iz3gWKV/sxNNnIfKB2Zo0cMYc1DfynRAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Pawlak <jakub.pawlak@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 437/457] accel/ivpu: Use separate flag for job timeout
Date: Wed, 30 Sep 2026 17:29:02 +0200
Message-ID: <20260930152355.429424596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Pawlak <jakub.pawlak@intel.com>

[ Upstream commit 72b782097e534ab48152dd25aaba40dda5f25f9e ]

Use separate flag to mark a job timeout as a reason
of starting context_abort_work. This allows to distinguish
engine reset reason and clearly adjust reset procedure flow.

The flag is cleared in ivpu_prepare_for_reset(), which every
recovery and suspend path already funnels through, so that the
state is clean after recovery.

Cc: stable@vger.kernel.org # v7.1+
Fixes: ade00a6c903f ("accel/ivpu: Perform engine reset instead of device recovery on TDR")
Signed-off-by: Jakub Pawlak <jakub.pawlak@intel.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260914084301.894028-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |    3 ++-
 drivers/accel/ivpu/ivpu_drv.h |    2 +-
 drivers/accel/ivpu/ivpu_job.c |    7 +++----
 drivers/accel/ivpu/ivpu_mmu.c |    1 -
 drivers/accel/ivpu/ivpu_pm.c  |    1 +
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -515,6 +515,7 @@ void ivpu_prepare_for_reset(struct ivpu_
 {
 	ivpu_hw_irq_disable(vdev);
 	disable_irq(vdev->irq);
+	atomic_set(&vdev->job_timeout_detected, 0);
 	flush_work(&vdev->irq_dct_work);
 	flush_work(&vdev->context_abort_work);
 	flush_work(&vdev->job_destroy_work);
@@ -710,7 +711,7 @@ static int ivpu_dev_init(struct ivpu_dev
 	vdev->context_xa_limit.max = IVPU_USER_CONTEXT_MAX_SSID;
 	atomic64_set(&vdev->unique_id_counter, 0);
 	atomic_set(&vdev->job_timeout_counter, 0);
-	atomic_set(&vdev->faults_detected, 0);
+	atomic_set(&vdev->job_timeout_detected, 0);
 	xa_init_flags(&vdev->context_xa, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	xa_init_flags(&vdev->submitted_jobs_xa, XA_FLAGS_ALLOC1);
 	xa_init_flags(&vdev->db_xa, XA_FLAGS_ALLOC1);
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -171,7 +171,7 @@ struct ivpu_device {
 	struct xarray submitted_jobs_xa;
 	struct ivpu_ipc_consumer job_done_consumer;
 	atomic_t job_timeout_counter;
-	atomic_t faults_detected;
+	atomic_t job_timeout_detected;
 
 	atomic64_t unique_id_counter;
 
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -621,7 +621,6 @@ bool ivpu_job_handle_engine_error(struct
 		 * status and ensure both are handled in the same way
 		 */
 		job->file_priv->has_mmu_faults = true;
-		atomic_set(&vdev->faults_detected, 1);
 		queue_work(system_percpu_wq, &vdev->context_abort_work);
 		return true;
 	}
@@ -1175,10 +1174,10 @@ static int reset_engine_and_mark_faulty_
 		return ret;
 
 	/*
-	 * If faults are detected, ignore guilty contexts from engine reset as NPU may not be stuck
-	 * and could return currently running good context and faulty contexts are already marked
+	 * If job timeout is detected, read guilty context from engine reset, for other reasons
+	 * faulty context is already known
 	 */
-	if (atomic_cmpxchg(&vdev->faults_detected, 1, 0) == 1)
+	if (atomic_cmpxchg(&vdev->job_timeout_detected, 1, 0) == 0)
 		return 0;
 
 	num_impacted_contexts = resp.payload.engine_reset_done.num_impacted_contexts;
--- a/drivers/accel/ivpu/ivpu_mmu.c
+++ b/drivers/accel/ivpu/ivpu_mmu.c
@@ -964,7 +964,6 @@ void ivpu_mmu_irq_evtq_handler(struct iv
 		file_priv = xa_load(&vdev->context_xa, ssid);
 		if (file_priv) {
 			if (!READ_ONCE(file_priv->has_mmu_faults)) {
-				atomic_set(&vdev->faults_detected, 1);
 				ivpu_mmu_dump_event(vdev, event);
 				WRITE_ONCE(file_priv->has_mmu_faults, true);
 			}
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -229,6 +229,7 @@ abort:
 
 	ivpu_jsm_state_dump(vdev);
 	ivpu_dev_coredump(vdev);
+	atomic_set(&vdev->job_timeout_detected, 1);
 	queue_work(system_percpu_wq, &vdev->context_abort_work);
 }
 


