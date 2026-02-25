Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF33B1E2834;
	Wed, 25 Feb 2026 01:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983202; cv=none; b=m7YohcUiR8egJp/9MUB4J5TO+OB0H8tEmyghmvYeVUMC12/qstyJsHnWoGbqQKpVRdMksRI06PfHfFHx/LUN8XrwrgM0tKSbb5XBMx/HdW9I9aJN1YtxQhxhu4Wj/b+1jgw29Qt2ER3Pm1FtPc/esIDHi8Al7BXJ9Z9syEwwrSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983202; c=relaxed/simple;
	bh=JpEGT4mqFM4+eC7JTo0VMksDIGQTMzVkqAXo0clyNgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEZ/CcXVIKaRHrxUHcj1Grv4MCUypDNdAs7yzcwAlj91oe+H8OtcSfu1fJApkRB5wsif/H6o4bTTMRaG8v7nsXKBaM9+il7W41Xlq4rIdXNW8WmzO9BGElIw0UItLdZQ2LAgWXPsJKbaHI8E9jtR2jcVVuFpMM2DKCIDx3KWvmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTeF+FTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTeF+FTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99315C19423;
	Wed, 25 Feb 2026 01:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983202;
	bh=JpEGT4mqFM4+eC7JTo0VMksDIGQTMzVkqAXo0clyNgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTeF+FTQ7Dh3CKEfiq+Wuz6nSF0p7cdG9gUD/kkEXgaXbuN1QpjyerlpAu9dzp/TX
	 9qgSSp4UunMvKwNIQAnY63ZjCM9kC3fWlSz86W1E3tnj1OT+F3I40uKUsnTep4MISb
	 tPSaPTmois2kuoOn/UCu/ogT4jZDl7cpc+27zedg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 308/781] accel/amdxdna: Move RPM resume into job run function
Date: Tue, 24 Feb 2026 17:16:57 -0800
Message-ID: <20260225012407.262439284@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

[ Upstream commit 69674c1c704c0199ca7a3947f3cdcd575973175d ]

Currently, amdxdna_pm_resume_get() is called during job creation, and
amdxdna_pm_suspend_put() is called when the hardware notifies job
completion. If a job is canceled before it is run, no hardware
completion notification is generated, resulting in an unbalanced
runtime PM resume/suspend pair.

Fix this by moving amdxdna_pm_resume_get() to the job run path, ensuring
runtime PM is only resumed for jobs that are actually executed.

Fixes: 063db451832b ("accel/amdxdna: Enhance runtime power management")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260204171118.3165607-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index fe8f9783a73c7..37d05f2e986f9 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -306,6 +306,10 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 	kref_get(&job->refcnt);
 	fence = dma_fence_get(job->fence);
 
+	ret = amdxdna_pm_resume_get(hwctx->client->xdna);
+	if (ret)
+		goto out;
+
 	if (job->drv_cmd) {
 		switch (job->drv_cmd->opcode) {
 		case SYNC_DEBUG_BO:
@@ -332,6 +336,7 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 
 out:
 	if (ret) {
+		amdxdna_pm_suspend_put(hwctx->client->xdna);
 		dma_fence_put(job->fence);
 		aie2_job_put(job);
 		mmput(job->mm);
@@ -988,15 +993,11 @@ int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job,
 		goto free_chain;
 	}
 
-	ret = amdxdna_pm_resume_get(xdna);
-	if (ret)
-		goto cleanup_job;
-
 retry:
 	ret = drm_gem_lock_reservations(job->bos, job->bo_cnt, &acquire_ctx);
 	if (ret) {
 		XDNA_WARN(xdna, "Failed to lock BOs, ret %d", ret);
-		goto suspend_put;
+		goto cleanup_job;
 	}
 
 	for (i = 0; i < job->bo_cnt; i++) {
@@ -1004,7 +1005,7 @@ int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job,
 		if (ret) {
 			XDNA_WARN(xdna, "Failed to reserve fences %d", ret);
 			drm_gem_unlock_reservations(job->bos, job->bo_cnt, &acquire_ctx);
-			goto suspend_put;
+			goto cleanup_job;
 		}
 	}
 
@@ -1019,12 +1020,12 @@ int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job,
 					msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 			} else if (time_after(jiffies, timeout)) {
 				ret = -ETIME;
-				goto suspend_put;
+				goto cleanup_job;
 			}
 
 			ret = aie2_populate_range(abo);
 			if (ret)
-				goto suspend_put;
+				goto cleanup_job;
 			goto retry;
 		}
 	}
@@ -1050,8 +1051,6 @@ int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job,
 
 	return 0;
 
-suspend_put:
-	amdxdna_pm_suspend_put(xdna);
 cleanup_job:
 	drm_sched_job_cleanup(&job->base);
 free_chain:
-- 
2.51.0



