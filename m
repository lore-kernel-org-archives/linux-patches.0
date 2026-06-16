Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B2244CAF9;
	Tue, 16 Jun 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624658; cv=none; b=aTSBDcXEXnBjWw+DsR7qYwz7W/wIt80LUr7uOPqEtEQt94yFW1vShXVQwchYqDYiaBgBHGPYs/0sy1LedrMqvFExT1As8sfvrd6t+1ujA0jp9OcRsmbGGlxjifpsNC6+uV364KuibY8bk/sCKXe7StV9aJN0JTLEfxRuwAvOVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624658; c=relaxed/simple;
	bh=9YhiUTzNabBq38bqVCdPLxmsnG/fbT9eGKQqnH/f2lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pu54/+mFEdPiRADYK+WBF01KGPeMCC08kg0FpSuFBg8kVgU/VOTsVrLlCRC98kEWGfHgkcv63bCGPycd4ZPC/a4praPIM3ZE/QsTu3T5+5z3N0AbncF+N+xWCBTelMKImof1AmTnE6wUWhcnuWyHBjgaGiogg44sprSIYsk63EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz/uxdxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz/uxdxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079831F00A3A;
	Tue, 16 Jun 2026 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624657;
	bh=1eOwyxhXxzXYj9tZORPAN9u9VJ0Uz8h73HxhojrwEME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tz/uxdxRNZPAr1SHoVBgDjCmST3LZrmOJQBA8BFo3jUkrW90HAe9eRabPZJWUFYsp
	 BxZUbRQzhDVXET5mo8THGayJ5oN1BjZOiTVGm61L28BmsEaebixKcFV/L82h1n1NP5
	 ioPoU61AXTBUO8wJme0C+Df69prlYch6Wmn1Pjd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 7.0 343/378] drm/v3d: Skip CSD when it has zeroed workgroups
Date: Tue, 16 Jun 2026 20:29:34 +0530
Message-ID: <20260616145128.238600770@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 7f93fad5ea0affc9e1505dd0f7596c0fdb496213 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -378,6 +378,16 @@ v3d_csd_job_run(struct drm_sched_job *sc
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
@@ -428,13 +438,13 @@ v3d_rewrite_csd_job_wg_counts_from_indir
 
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
 


