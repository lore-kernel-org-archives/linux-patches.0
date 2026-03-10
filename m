Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039D436D512;
	Tue, 10 Mar 2026 11:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141301; cv=none; b=jJwa3KKcYFiONOop0c7CZSDaDKSpA+fAGJjAzpXAIBb+EDaNqQ7gNJpuv1BLHZbs4tVrhBLk0J+cqXltevCZyBCbrMTm47xVNSMWlUVBlQkRWAHb6S4yLKhaX4o/3b09hrtxq+TKKtPBgmt65HDai8xgDvMHjpEtgfPyh6iFRhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141301; c=relaxed/simple;
	bh=aogNz42p1VMmJ64LMEJQ0szYoO7UioMB9kjZskY88fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta9OFdyvOCPq+pyuTcE0PYb30dTWxUdrQy4BiDgF6HB9O8FqoMPnKeihS3eL7ZfzMn1mn2/VbEr3XYfcLMWvGxOWcm2XPZMU4gFTeRuKHN05ETuYN57g0bv+3ODIO16Q6oc7QZ6Zs7rpaWWLlvOYmwpgUVrPlO8jixxjEDdOOHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAA9ZPEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAA9ZPEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F042C2BC86;
	Tue, 10 Mar 2026 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141300;
	bh=aogNz42p1VMmJ64LMEJQ0szYoO7UioMB9kjZskY88fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAA9ZPEV8K/Y8js5s5DJsP9tTNJ6nFk2UZ4MaVZxk6Kmf1NKz5uvFaZk8dnV+SDWr
	 WXl0wrk+vZqiPp460pjJWX+RmtinTxF7cGapBS8/aQzlpCea5syIX1RCicG4tDJ8tj
	 YWUlqI/SW/cneHCDT2KZ1gsKUO0pTaw8wwtYCF279Chxcvf0fHe81tDT3Srktu+XMp
	 +2ZEOjAR7FqMQMzNuevAJ2bOWGGKcp4xmy8zhJQ8L/jn77PhLaCl/zCeMK/XRj625U
	 HFTCtYmoRHINFN3HgApeu8ODx4DoOK4lOWs8R+Q+xzFuwRVJLpVCP1C4Ib5C5Y8PtW
	 nA7fn3osNfDYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Rob Herring (Arm)" <robh@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 305/311] accel: ethosu: Fix job submit error clean-up refcount underflows
Date: Tue, 10 Mar 2026 07:05:52 -0400
Message-ID: <1d78ed3eab56c71f2778fa3ff50f991a307faccf.1773140656.git.sashal@kernel.org>
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

From: "Rob Herring (Arm)" <robh@kernel.org>

[ Upstream commit 150bceb3e0a4a30950279d91ea0e8cc69a736742 ]

If the job submit fails before adding the job to the scheduler queue
such as when the GEM buffer bounds checks fail, then doing a
ethosu_job_put() results in a pm_runtime_put_autosuspend() without the
corresponding pm_runtime_resume_and_get(). The dma_fence_put()'s are
also unnecessary, but seem to be harmless.

Split the ethosu_job_cleanup() function into 2 parts for the before
and after the job is queued.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Reviewed-and-Tested-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://patch.msgid.link/20260218-ethos-fixes-v1-1-be3fa3ea9a30@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ethosu/ethosu_job.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/accel/ethosu/ethosu_job.c b/drivers/accel/ethosu/ethosu_job.c
index 26e7a2f64d71a..70a144803b096 100644
--- a/drivers/accel/ethosu/ethosu_job.c
+++ b/drivers/accel/ethosu/ethosu_job.c
@@ -143,23 +143,29 @@ static int ethosu_job_push(struct ethosu_job *job)
 	return ret;
 }
 
+static void ethosu_job_err_cleanup(struct ethosu_job *job)
+{
+	unsigned int i;
+
+	for (i = 0; i < job->region_cnt; i++)
+		drm_gem_object_put(job->region_bo[i]);
+
+	drm_gem_object_put(job->cmd_bo);
+
+	kfree(job);
+}
+
 static void ethosu_job_cleanup(struct kref *ref)
 {
 	struct ethosu_job *job = container_of(ref, struct ethosu_job,
 						refcount);
-	unsigned int i;
 
 	pm_runtime_put_autosuspend(job->dev->base.dev);
 
 	dma_fence_put(job->done_fence);
 	dma_fence_put(job->inference_done_fence);
 
-	for (i = 0; i < job->region_cnt; i++)
-		drm_gem_object_put(job->region_bo[i]);
-
-	drm_gem_object_put(job->cmd_bo);
-
-	kfree(job);
+	ethosu_job_err_cleanup(job);
 }
 
 static void ethosu_job_put(struct ethosu_job *job)
@@ -454,12 +460,16 @@ static int ethosu_ioctl_submit_job(struct drm_device *dev, struct drm_file *file
 		}
 	}
 	ret = ethosu_job_push(ejob);
+	if (!ret) {
+		ethosu_job_put(ejob);
+		return 0;
+	}
 
 out_cleanup_job:
 	if (ret)
 		drm_sched_job_cleanup(&ejob->base);
 out_put_job:
-	ethosu_job_put(ejob);
+	ethosu_job_err_cleanup(ejob);
 
 	return ret;
 }
-- 
2.51.0

