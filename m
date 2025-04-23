Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B8127FD4F;
	Wed, 23 Apr 2025 15:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420680; cv=none; b=WHt6wASAIXTIDlH4GYWHhpQSQQgWiH+jd0b6Z07tbHHTAaYT3vMCqnq23HRd6km5nPZkSi6qnrgnufoTbqK1X5NdosXYH0ubHylPYoFIHEe2xvp3/kK/mIy6DLuB+9AoLXJKOHeLhJ71euE4lv5OzNSKo7KkTBH8wWpDZLdWwd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420680; c=relaxed/simple;
	bh=RoICGuCjCBcJnSLtZccIKa7Sn/APJSb3DRGPA3hEI7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/CkHBl0+LXbPvalf2DsBGHXvQqpnuClX5R+2kDAvy38isylHGnTQCQ/6kaoy72MNmYadEluZ5NShTEIzDUUfLOMhGfDQrV5gmPW+upfAGAieCXLDt3vigRpgNojoSZLMV6hBt6ZvKnVgFfwYzBOZAy1sXhm6TNQuC6mYXo7HBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkCms9wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkCms9wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5353DC4CEE2;
	Wed, 23 Apr 2025 15:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420679;
	bh=RoICGuCjCBcJnSLtZccIKa7Sn/APJSb3DRGPA3hEI7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkCms9wjOCVpqY0bS3qmTauSsQ/7K3QKDYT++oKunWGNMVELd8s7sPEneKXBJx8Ey
	 5K83nibEy7R4QM7EbrYsqD9Q2BJ4ZCO6Dm2yiyElCrr/pIP86xO3ZGMlHIRqO8OtFf
	 GtpfAd/WR1EQXG4EysHLxjgMjy2mhgL/Y/deggJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 113/241] drm/v3d: Fix Indirect Dispatch configuration for V3D 7.1.6 and later
Date: Wed, 23 Apr 2025 16:42:57 +0200
Message-ID: <20250423142625.192185789@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit dcdae6e92d4e062da29235fe88980604595e3f0f ]

This commit is a resubmission of commit 1fe1c66274fb ("drm/v3d: Fix
Indirect Dispatch configuration for V3D 7.1.6 and later"), which was
accidentally reverted by commit 91dae758bdb8 ("Merge tag
'drm-misc-next-2024-08-01' of https://gitlab.freedesktop.org/drm/misc/kernel
into drm-next"), likely due to an unfortunate conflict resolution.

>From the original commit message:

```
`args->cfg[4]` is configured in Indirect Dispatch using the number of
batches. Currently, for all V3D tech versions, `args->cfg[4]` equals the
number of batches subtracted by 1. But, for V3D 7.1.6 and later, we must not
subtract 1 from the number of batches.

Implement the fix by checking the V3D tech version and revision.

Fixes several `dEQP-VK.synchronization*` CTS tests related to Indirect Dispatch.
```

Fixes: 91dae758bdb8 ("Merge tag 'drm-misc-next-2024-08-01' of https://gitlab.freedesktop.org/drm/misc/kernel into drm-next")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://lore.kernel.org/r/20250409205051.9639-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 05608c894ed93..6db503a569180 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -428,7 +428,8 @@ v3d_rewrite_csd_job_wg_counts_from_indirect(struct v3d_cpu_job *job)
 	struct v3d_bo *bo = to_v3d_bo(job->base.bo[0]);
 	struct v3d_bo *indirect = to_v3d_bo(indirect_csd->indirect);
 	struct drm_v3d_submit_csd *args = &indirect_csd->job->args;
-	u32 *wg_counts;
+	struct v3d_dev *v3d = job->base.v3d;
+	u32 num_batches, *wg_counts;
 
 	v3d_get_bo_vaddr(bo);
 	v3d_get_bo_vaddr(indirect);
@@ -441,8 +442,17 @@ v3d_rewrite_csd_job_wg_counts_from_indirect(struct v3d_cpu_job *job)
 	args->cfg[0] = wg_counts[0] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 	args->cfg[1] = wg_counts[1] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 	args->cfg[2] = wg_counts[2] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
-	args->cfg[4] = DIV_ROUND_UP(indirect_csd->wg_size, 16) *
-		       (wg_counts[0] * wg_counts[1] * wg_counts[2]) - 1;
+
+	num_batches = DIV_ROUND_UP(indirect_csd->wg_size, 16) *
+		      (wg_counts[0] * wg_counts[1] * wg_counts[2]);
+
+	/* V3D 7.1.6 and later don't subtract 1 from the number of batches */
+	if (v3d->ver < 71 || (v3d->ver == 71 && v3d->rev < 6))
+		args->cfg[4] = num_batches - 1;
+	else
+		args->cfg[4] = num_batches;
+
+	WARN_ON(args->cfg[4] == ~0);
 
 	for (int i = 0; i < 3; i++) {
 		/* 0xffffffff indicates that the uniform rewrite is not needed */
-- 
2.39.5



