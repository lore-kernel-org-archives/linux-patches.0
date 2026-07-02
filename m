Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B512733A9FC;
	Thu,  2 Jul 2026 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010178; cv=none; b=kP7jqV10+qQ+Df6Zwbhe5y3wXfOLafM4AAN3Wubq1zI+3Ozvch4FYr64mRHXoa8ERQjlZu7YJe/A1j148ELvzl2FzftJ3tPZjiKBGFxhONjzYRMWop5OEjWxrwxi3F8ah6UeGZxVIqYrqJPtGJGc87eJWkk4gJOl5Ji5M8BG2Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010178; c=relaxed/simple;
	bh=OnLsqJVBA4nVw7WCYDs6YHk5B8wPxAkX7Gbj21OChd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HojULpXUApYEpdR3Rg3+b33Y3+QDQoQ6lS5SEKPIoNVKQLvcZkOAAH0GZexsCQltG4XyJQeOQMxFKXFwCxub9P4AFPIFw25+htB+16rNL/bgcNaqp7+mOQngNrOTggPaCJbb4RtYFY8KxjNPU6pBJs5RWi+CuEVllitPWYFQBbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srXB5mZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srXB5mZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E6A1F000E9;
	Thu,  2 Jul 2026 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010177;
	bh=QE9dtO6AdOwZyxSfbAQRZ2YEiZqlyIgwTl0HATJbIr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srXB5mZzzT23/qVwEbrnBsKpZUuz3/h+lGh+Epdh8hpVqxsrQ3/OlhZhkWFYgJniN
	 ONsLZqqhRTFkQlOW/44wkGjNOXZuR54k2/zCbhQpmcmBJZWk9Y4OUpDWjAN5Dk/JUC
	 tTG19LZ7CqC6mTSguuj3iCe3WtQSUaStEiZHdawo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/204] drm/v3d: Skip CSD when it has zeroed workgroups
Date: Thu,  2 Jul 2026 18:17:48 +0200
Message-ID: <20260702155118.906199046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 7f93fad5ea0affc9e1505dd0f7596c0fdb496213 ]

A compute shader dispatch encodes its workgroup counts in the CFG0..CFG2
registers. Kicking off a dispatch with a zero count in any of the three
dimensions is invalid. First, the hardware will process 0 as 65536,
while the user-space driver exposes a maximum of 65535. Over that, a
submission with a zeroed workgroup dimension should be a no-op.

These zeroed counts can reach the dispatch path through an indirect CSD
job, whose workgroup counts are only known once the indirect buffer is
read and may legitimately be zero, but such scenario should only result in
a no-op.

Overwrite the indirect CSD job workgroup counts with the indirect BO
ones, even if they are zeroed, and don't submit the job to the hardware
when any of the workgroup counts is zero, so the job completes immediately
instead of running the shader.

Cc: stable@vger.kernel.org
Fixes: d223f98f0209 ("drm/v3d: Add support for compute shader dispatch.")
Suggested-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260602-v3d-fix-indirect-csd-v4-2-654309e32bc0@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index f2a2c17a58c687..f2bac920af899d 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -368,6 +368,16 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 		return NULL;
 	}
 
+	/* The HW interprets a workgroup size of 0 as 65536; however, the
+	 * user-space driver exposes a maximum of 65535. Therefore, a 0 in
+	 * any dimension means that we have no workgroups and the compute
+	 * shader should not be dispatched.
+	 */
+	if (!V3D_GET_FIELD(job->args.cfg[0], V3D_CSD_QUEUED_CFG0_NUM_WGS_X) ||
+	    !V3D_GET_FIELD(job->args.cfg[1], V3D_CSD_QUEUED_CFG1_NUM_WGS_Y) ||
+	    !V3D_GET_FIELD(job->args.cfg[2], V3D_CSD_QUEUED_CFG2_NUM_WGS_Z))
+		return NULL;
+
 	v3d->queue[V3D_CSD].active_job = &job->base;
 
 	v3d_invalidate_caches(v3d);
@@ -418,13 +428,13 @@ v3d_rewrite_csd_job_wg_counts_from_indirect(struct v3d_cpu_job *job)
 
 	wg_counts = (uint32_t *)(bo->vaddr + indirect_csd->offset);
 
-	if (wg_counts[0] == 0 || wg_counts[1] == 0 || wg_counts[2] == 0)
-		goto unmap_bo;
-
 	args->cfg[0] = wg_counts[0] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 	args->cfg[1] = wg_counts[1] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 	args->cfg[2] = wg_counts[2] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 
+	if (wg_counts[0] == 0 || wg_counts[1] == 0 || wg_counts[2] == 0)
+		goto unmap_bo;
+
 	num_batches = DIV_ROUND_UP(indirect_csd->wg_size, 16) *
 		      (wg_counts[0] * wg_counts[1] * wg_counts[2]);
 
-- 
2.53.0



