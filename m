Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE96387363;
	Tue, 10 Mar 2026 11:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140800; cv=none; b=X/CcWIdJjpFjaUzV1mZrr3gEfr64ld8HIzSrJdgTLD48zvZtgGGfgmBcvjbpiyW8q/FXDObRAQUnYwnvfmp5nPGByRQ7Vpzx0s38dAaaJ4PdPgGQ2Ufkq8ApMh2nJ5SqDvkB6BhFrL/+jdZficPVBIvMSd9GOBvnCvV0ZuZ95xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140800; c=relaxed/simple;
	bh=M9XVX5zSpDoN9UTpquCCh+/ChqHXFIsUe0/zh7tESck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhYCE6W+KyrvmDpXUrt1BeYEXAmWjrDwEM/7LBgzmHqRewpedkmJ2pANg8Diplw9dCp1nzSjzLTK2ViY+phKdDliDo0+guvbeiHaKBhMi0RCVAslFaB1A1Z+anqLIP0EsO9KFPBgcRkkzyWbfx68BfJgkRfksuUZsYugvEqyezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/tiRr2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/tiRr2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C910C19423;
	Tue, 10 Mar 2026 11:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140800;
	bh=M9XVX5zSpDoN9UTpquCCh+/ChqHXFIsUe0/zh7tESck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/tiRr2l0prKJPy72dw9fHGpLh6Q8iwzIhKASSLo/i/ZVDqMzR1emKtrsYhZJ8F1M
	 OwO0H3oL+elZrPTOhFFkhMdQ4EG2XQ0CKZpIvfo80BXbRyanOPSsLvGeLCbdd3eKYo
	 YBggjHNcRtNqWEFQGBB5vm5LY0D7Uivw1rNMixn/xKpileEaygDruKEamLhgw1Ktu/
	 ZGyYP8caw0MfzQJM6iaRDYTZ9yMs9XB5igJMp0FY4w1tnrDdnPet+bIAGvegToLYBU
	 EaAwr5nxuzhzD4iTBWrLrbePIphUwBWOWF3LSxrmK9usIY1wzH0o6yuf7LWzbNAYXu
	 g8rqh6+2b9lnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 038/311] accel/amdxdna: Fix command hang on suspended hardware context
Date: Tue, 10 Mar 2026 07:01:25 -0400
Message-ID: <a2ed7ae25c182327f08095c1256082da8ee8b515.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 07efce5a6611af6714ea3ef65694e0c8dd7e44f5 ]

When a hardware context is suspended, the job scheduler is stopped. If a
command is submitted while the context is suspended, the job is queued in
the scheduler but aie2_sched_job_run() is never invoked to restart the
hardware context. As a result, the command hangs.

Fix this by modifying the hardware context suspend routine to keep the job
scheduler running so that queued jobs can trigger context restart properly.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260211205341.722982-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 1dcf6e862656d..01a02f4c3a98d 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -53,6 +53,7 @@ static void aie2_hwctx_stop(struct amdxdna_dev *xdna, struct amdxdna_hwctx *hwct
 {
 	drm_sched_stop(&hwctx->priv->sched, bad_job);
 	aie2_destroy_context(xdna->dev_handle, hwctx);
+	drm_sched_start(&hwctx->priv->sched, 0);
 }
 
 static int aie2_hwctx_restart(struct amdxdna_dev *xdna, struct amdxdna_hwctx *hwctx)
@@ -80,7 +81,6 @@ static int aie2_hwctx_restart(struct amdxdna_dev *xdna, struct amdxdna_hwctx *hw
 	}
 
 out:
-	drm_sched_start(&hwctx->priv->sched, 0);
 	XDNA_DBG(xdna, "%s restarted, ret %d", hwctx->name, ret);
 	return ret;
 }
@@ -297,19 +297,23 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 	struct dma_fence *fence;
 	int ret;
 
-	if (!hwctx->priv->mbox_chann)
+	ret = amdxdna_pm_resume_get(hwctx->client->xdna);
+	if (ret)
+		return NULL;
+
+	if (!hwctx->priv->mbox_chann) {
+		amdxdna_pm_suspend_put(hwctx->client->xdna);
 		return NULL;
+	}
 
-	if (!mmget_not_zero(job->mm))
+	if (!mmget_not_zero(job->mm)) {
+		amdxdna_pm_suspend_put(hwctx->client->xdna);
 		return ERR_PTR(-ESRCH);
+	}
 
 	kref_get(&job->refcnt);
 	fence = dma_fence_get(job->fence);
 
-	ret = amdxdna_pm_resume_get(hwctx->client->xdna);
-	if (ret)
-		goto out;
-
 	if (job->drv_cmd) {
 		switch (job->drv_cmd->opcode) {
 		case SYNC_DEBUG_BO:
-- 
2.51.0

