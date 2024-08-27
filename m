Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC101B4C4E;
	Tue, 27 Aug 2024 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771224; cv=none; b=pfOGxAQZgQN3Q4MTCBPKifQvPsb/ouKBNqT0gWFgmInpcQNvK6mTQZu7nogqGOdycn14poyZoFEYiRuKqc/mtXC+S4Bp2IiRdFBYyUooTj4N5FxifMe2FkWC+BO5BdAMuH8WARedDa/5Y2EEzjSky9VAqGcPQJ7gfazntE891gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771224; c=relaxed/simple;
	bh=bGwoVH8zt3kh0xmHDa+5mdWN0WLZqRimL6hkJJiP+eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VI3V7Jwpd+fxcNYzTZ+jtTQ2a9jfiIm/n1X2BHJnwbcA8MAGeHAUS3uQ2t8N/HKF3UAMuQv+C3P5U1n4VhHESnA6sJMH7Szcu+0DRD+smzTQF1nyknZe7Etncl3vyI0ywsmNpNpW5un5EXJ+FCVvJzXHkC/lQNB77PXjOw9MaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+aLqfQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+aLqfQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E47C4AF55;
	Tue, 27 Aug 2024 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771224;
	bh=bGwoVH8zt3kh0xmHDa+5mdWN0WLZqRimL6hkJJiP+eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+aLqfQbozNW/TVi87ysMDnzY4WF2CBCN08P00Lf+WtlVtrcufM6Zzlg5scS47GDS
	 pkMtWbRiLNsBgOlQOg0BWUG8y1doWHzP250aaWAAocHbNJud6OuxBunL14AGf+AlZO
	 dGgbSSIYmViDSgce4BF7G6V8MB+jnyLHMsDrh1XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 124/273] drm/v3d: Fix out-of-bounds read in `v3d_csd_job_run()`
Date: Tue, 27 Aug 2024 16:37:28 +0200
Message-ID: <20240827143838.125279989@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 497d370a644d95a9f04271aa92cb96d32e84c770 ]

When enabling UBSAN on Raspberry Pi 5, we get the following warning:

[  387.894977] UBSAN: array-index-out-of-bounds in drivers/gpu/drm/v3d/v3d_sched.c:320:3
[  387.903868] index 7 is out of range for type '__u32 [7]'
[  387.909692] CPU: 0 PID: 1207 Comm: kworker/u16:2 Tainted: G        WC         6.10.3-v8-16k-numa #151
[  387.919166] Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
[  387.925961] Workqueue: v3d_csd drm_sched_run_job_work [gpu_sched]
[  387.932525] Call trace:
[  387.935296]  dump_backtrace+0x170/0x1b8
[  387.939403]  show_stack+0x20/0x38
[  387.942907]  dump_stack_lvl+0x90/0xd0
[  387.946785]  dump_stack+0x18/0x28
[  387.950301]  __ubsan_handle_out_of_bounds+0x98/0xd0
[  387.955383]  v3d_csd_job_run+0x3a8/0x438 [v3d]
[  387.960707]  drm_sched_run_job_work+0x520/0x6d0 [gpu_sched]
[  387.966862]  process_one_work+0x62c/0xb48
[  387.971296]  worker_thread+0x468/0x5b0
[  387.975317]  kthread+0x1c4/0x1e0
[  387.978818]  ret_from_fork+0x10/0x20
[  387.983014] ---[ end trace ]---

This happens because the UAPI provides only seven configuration
registers and we are reading the eighth position of this u32 array.

Therefore, fix the out-of-bounds read in `v3d_csd_job_run()` by
accessing only seven positions on the '__u32 [7]' array. The eighth
register exists indeed on V3D 7.1, but it isn't currently used. That
being so, let's guarantee that it remains unused and add a note that it
could be set in a future patch.

Fixes: 0ad5bc1ce463 ("drm/v3d: fix up register addresses for V3D 7.x")
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240809152001.668314-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 30d5366d62883..0132403b8159f 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -315,7 +315,7 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
 	struct dma_fence *fence;
-	int i, csd_cfg0_reg, csd_cfg_reg_count;
+	int i, csd_cfg0_reg;
 
 	v3d->csd_job = job;
 
@@ -335,9 +335,17 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	v3d_switch_perfmon(v3d, &job->base);
 
 	csd_cfg0_reg = V3D_CSD_QUEUED_CFG0(v3d->ver);
-	csd_cfg_reg_count = v3d->ver < 71 ? 6 : 7;
-	for (i = 1; i <= csd_cfg_reg_count; i++)
+	for (i = 1; i <= 6; i++)
 		V3D_CORE_WRITE(0, csd_cfg0_reg + 4 * i, job->args.cfg[i]);
+
+	/* Although V3D 7.1 has an eighth configuration register, we are not
+	 * using it. Therefore, make sure it remains unused.
+	 *
+	 * XXX: Set the CFG7 register
+	 */
+	if (v3d->ver >= 71)
+		V3D_CORE_WRITE(0, V3D_V7_CSD_QUEUED_CFG7, 0);
+
 	/* CFG0 write kicks off the job. */
 	V3D_CORE_WRITE(0, csd_cfg0_reg, job->args.cfg[0]);
 
-- 
2.43.0



