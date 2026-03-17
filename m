Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26832DF132;
	Tue, 17 Mar 2026 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765948; cv=none; b=BYJRggDLI4Sjrsg6C96bcmERcpiPsVFMp4bouGh35gH/uFhvFoCUSZIYLfGyuoGh3dxvty7LHLzNypmELbLlSKjUAwSGLli8E0yeh0Yr9qL5OHPodc66ujCG7W5kaSLzoai4NKEsfBgpdHfNSw0K4wZL12ICT1RCeEtsbIuVcZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765948; c=relaxed/simple;
	bh=PAPXa7pnKhs66AeQZETzrPz4RaMxOxo8rLLJUJBtL9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB0OKRrlnH5GUet+cfgCFs2X7MjWm0kqggNuUeXc0R4R5/6k69unRS0dnb4ej+F8U6K+S2rXsUNmXThWBRPnUA1deTb9Fynw1U9Yd8t/DME9TriqxJtXuhbZ5Ca3MOw3sPAUGyBSpCjBGclpjLL1rKXnrr05yn1/uYZXG2J7McU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QORLResI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QORLResI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EFDC4CEF7;
	Tue, 17 Mar 2026 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765947;
	bh=PAPXa7pnKhs66AeQZETzrPz4RaMxOxo8rLLJUJBtL9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QORLResIZi6HUXvHgAOP/1nj5q58MF8Y+6rgzlFvUofnuK8yTfYJAn8Hcn4JVcaN7
	 P3J29pWCGPl6s9ajcs8D6TJ3xI8uFYYblLO87TD7GKqmTiHRmkHMRIZixMHMrzh+HV
	 ZrBkLC4puFwpjVE+039FzGEe5MMec5A6mxNVTJr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 091/378] accel/amdxdna: Fix runtime suspend deadlock when there is pending job
Date: Tue, 17 Mar 2026 17:30:48 +0100
Message-ID: <20260317163010.366589852@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 6b13cb8f48a42ddf6dd98865b673a82e37ff238b ]

The runtime suspend callback drains the running job workqueue before
suspending the device. If a job is still executing and calls
pm_runtime_resume_and_get(), it can deadlock with the runtime suspend
path.

Fix this by moving pm_runtime_resume_and_get() from the job execution
routine to the job submission routine, ensuring the device is resumed
before the job is queued and avoiding the deadlock during runtime
suspend.

Fixes: 063db451832b ("accel/amdxdna: Enhance runtime power management")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260310180058.336348-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    | 14 ++------------
 drivers/accel/amdxdna/amdxdna_ctx.c | 10 ++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 9fc33b4298f23..9284c35aacfbf 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -165,7 +165,6 @@ aie2_sched_notify(struct amdxdna_sched_job *job)
 
 	trace_xdna_job(&job->base, job->hwctx->name, "signaled fence", job->seq);
 
-	amdxdna_pm_suspend_put(job->hwctx->client->xdna);
 	job->hwctx->priv->completed++;
 	dma_fence_signal(fence);
 
@@ -290,19 +289,11 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 	struct dma_fence *fence;
 	int ret;
 
-	ret = amdxdna_pm_resume_get(hwctx->client->xdna);
-	if (ret)
+	if (!hwctx->priv->mbox_chann)
 		return NULL;
 
-	if (!hwctx->priv->mbox_chann) {
-		amdxdna_pm_suspend_put(hwctx->client->xdna);
-		return NULL;
-	}
-
-	if (!mmget_not_zero(job->mm)) {
-		amdxdna_pm_suspend_put(hwctx->client->xdna);
+	if (!mmget_not_zero(job->mm))
 		return ERR_PTR(-ESRCH);
-	}
 
 	kref_get(&job->refcnt);
 	fence = dma_fence_get(job->fence);
@@ -333,7 +324,6 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 
 out:
 	if (ret) {
-		amdxdna_pm_suspend_put(hwctx->client->xdna);
 		dma_fence_put(job->fence);
 		aie2_job_put(job);
 		mmput(job->mm);
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index 4e48519b699ac..f678ae4c682d1 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -17,6 +17,7 @@
 #include "amdxdna_ctx.h"
 #include "amdxdna_gem.h"
 #include "amdxdna_pci_drv.h"
+#include "amdxdna_pm.h"
 
 #define MAX_HWCTX_ID		255
 #define MAX_ARG_COUNT		4095
@@ -445,6 +446,7 @@ amdxdna_arg_bos_lookup(struct amdxdna_client *client,
 void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job)
 {
 	trace_amdxdna_debug_point(job->hwctx->name, job->seq, "job release");
+	amdxdna_pm_suspend_put(job->hwctx->client->xdna);
 	amdxdna_arg_bos_put(job);
 	amdxdna_gem_put_obj(job->cmd_bo);
 	dma_fence_put(job->fence);
@@ -482,6 +484,12 @@ int amdxdna_cmd_submit(struct amdxdna_client *client,
 		goto cmd_put;
 	}
 
+	ret = amdxdna_pm_resume_get(xdna);
+	if (ret) {
+		XDNA_ERR(xdna, "Resume failed, ret %d", ret);
+		goto put_bos;
+	}
+
 	idx = srcu_read_lock(&client->hwctx_srcu);
 	hwctx = xa_load(&client->hwctx_xa, hwctx_hdl);
 	if (!hwctx) {
@@ -522,6 +530,8 @@ int amdxdna_cmd_submit(struct amdxdna_client *client,
 	dma_fence_put(job->fence);
 unlock_srcu:
 	srcu_read_unlock(&client->hwctx_srcu, idx);
+	amdxdna_pm_suspend_put(xdna);
+put_bos:
 	amdxdna_arg_bos_put(job);
 cmd_put:
 	amdxdna_gem_put_obj(job->cmd_bo);
-- 
2.51.0



