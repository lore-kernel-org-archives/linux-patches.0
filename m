Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DB937B3F7;
	Sat, 12 Sep 2026 07:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199105; cv=none; b=pT5SaIraNRPPa621JlJ0kQ6dnfUH5Tib7RGEgretYDojP3l/JajUnqlUOOE4RewmTsag/RmRpry8ZKv/PVq12AO2JbU15Oj9do1CVjSK6/CSrVQxQUkl7fbE3aMZOreTU65VJCF17qyXBFb6KLy1vxkZ5g4/iOvZM3t+zdbhrk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199105; c=relaxed/simple;
	bh=GRti9J56Tg3ZipjFYnyVICzh7mVm7rIO2CuMmUca5G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oon7XROLrony0WHTpGvjN1jE1bdz72GdvzHfAJ/YYSJklFgk/LTtCUrBX9hiWocA560I69xIvnzZO/lxUBCR9LNW4xvLaUVegOVhTb1KHik2KWVOX5eouJDCwJ2eGc+h6aaGtZ8kvd9gDsqne0t8TvpgfZXS3qLuOMQRBwVanp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndRerkId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndRerkId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724EE1F000FF;
	Sat, 12 Sep 2026 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199104;
	bh=rOZq4uEm9vtHUOV5R9oV+pDuFj6KL+TiRTNWX2n1Ydg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndRerkIdek/PTAp7kCiT+cK4pwKU9rJkHfI9qWEwtN1dLtHMLQjFWP49wPGO9QyRd
	 N5EFtwvK3Az2mK5h5DQpsfDuHoBnXCTqYGewNkpSxRT6/V/XG/YLF5WjuntAy2Cr2L
	 nF9LhbErNmNLk1yGgM2cYiuA538SE1lFabSFyvAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0518/1815] drm/v3d: Make v3d_get_cpu_indirect_csd_params() a pure parser
Date: Sat, 12 Sep 2026 08:37:48 +0200
Message-ID: <20260912065701.050530845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 719ea1f03984f959700326aaec04b5bcdf3ca982 ]

v3d_get_cpu_indirect_csd_params() currently does double duty: it parses
the indirect CSD extension and, while still inside the extension parser,
also creates the CSD/clean jobs and locks their BOs through a separate
DRM exec context. This nested submission deviates from the standard flow
and makes it hard to fold the indirect CSD path into the unified submit
chain.

Stash the parsed drm_v3d_submit_csd args in struct v3d_indirect_csd_info
and have the parser only fill in the parameters. Then, move job creation
(v3d_setup_csd_jobs_and_bos()) into v3d_submit_cpu_ioctl(), where is the
proper place to create jobs.

No functional change, but prepares to move the CPU ioctl into the
unified submission chain.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://patch.msgid.link/20260604-v3d-sched-misc-fixes-v4-7-c068f5bf5ccf@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: fa98563ab00d ("drm/v3d: Associate BOs with every job that accesses them")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h    |  5 +++++
 drivers/gpu/drm/v3d/v3d_submit.c | 16 +++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index 36415d8da92a7..bfa24b2c55922 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -435,6 +435,11 @@ struct v3d_indirect_csd_info {
 	/* Clean cache job associated to the Indirect CSD job */
 	struct v3d_job *clean_job;
 
+	/* Indirect CSD args, stashed by the extension parser and later used
+	 * to create the CSD job from them.
+	 */
+	struct drm_v3d_submit_csd args;
+
 	/* Offset within the BO where the workgroup counts are stored */
 	u32 offset;
 
diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 5d711594dbe7f..636f52881a0c9 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -631,6 +631,7 @@ v3d_get_cpu_indirect_csd_params(struct drm_file *file_priv,
 	}
 
 	job->job_type = V3D_CPU_JOB_TYPE_INDIRECT_CSD;
+	info->args = indirect_csd.submit;
 	info->offset = indirect_csd.offset;
 	info->wg_size = indirect_csd.wg_size;
 	memcpy(&info->wg_uniform_offsets, &indirect_csd.wg_uniform_offsets,
@@ -640,9 +641,7 @@ v3d_get_cpu_indirect_csd_params(struct drm_file *file_priv,
 	if (!info->indirect)
 		return -ENOENT;
 
-	return v3d_setup_csd_jobs_and_bos(file_priv, v3d, &indirect_csd.submit,
-					  &info->job, &info->clean_job,
-					  NULL, &info->exec);
+	return 0;
 }
 
 /* Get data for the query timestamp job submission. */
@@ -1405,6 +1404,17 @@ v3d_submit_cpu_ioctl(struct drm_device *dev, void *data,
 		goto fail;
 	}
 
+	if (cpu_job->job_type == V3D_CPU_JOB_TYPE_INDIRECT_CSD) {
+		ret = v3d_setup_csd_jobs_and_bos(file_priv, v3d,
+						 &cpu_job->indirect_csd.args,
+						 &cpu_job->indirect_csd.job,
+						 &cpu_job->indirect_csd.clean_job,
+						 NULL,
+						 &cpu_job->indirect_csd.exec);
+		if (ret)
+			goto fail;
+	}
+
 	clean_job = cpu_job->indirect_csd.clean_job;
 	csd_job = cpu_job->indirect_csd.job;
 
-- 
2.53.0



