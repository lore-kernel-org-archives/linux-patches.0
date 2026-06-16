Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5384B44CAF9;
	Tue, 16 Jun 2026 15:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624653; cv=none; b=M2D2OiLEMHpgxXzAmll/Aj+Xg2BHhWKX6/ty/wvTxUBKnPKsJMKt39vPv5oC47JFDDOvE8CdokB7sz2ZRyIjULzdjWEBIsFh6vgjWRDImt0wYR1ZEcJgfmqE5pTKCGA3MPlhnm8AveYAFLm5qccwK+nSC5dihwT/FHXwbWo57fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624653; c=relaxed/simple;
	bh=z8jDmDk77hqEPI7bs1v0govlB8/qi38dmpCgHaZCj/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i0oaBHZCfQyM/qykuV0pPXhKVIIgInyQwhDqigxEIBPUVth/LUABRQ/Ouoeyw7ltrAVg8ycEioQlH4kpt59JbVgMtXjJNjMU5SI0Hn7fE29dhkcLjNMf5nMN4Ktx/yLWcgOCISxtmHMJ+qwWpmEi1J43mFTbG8ZGN1pDP6zOiGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abkOjNAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abkOjNAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE741F000E9;
	Tue, 16 Jun 2026 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624652;
	bh=7kJgmWnMAA5I5s+AgLgp1eArJu5Hb52L1gbL0mnhYUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abkOjNAymCLrVXQKKhSqAWkQ+H6jZY71f73eNSPqd3S8S7NDebkT++ZpcwiEHjdcw
	 hm3fo7cdGaO6/alsMIbojr5suV5toCAYmmAeofl2r+ulovN+ZhpvLgUnKtDDcWKGER
	 mUtjJaf8pNZe/nARvddh/JVkoQ245hM5GGU73z0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 7.0 342/378] drm/v3d: Fix vaddr leak when indirect CSD has zeroed workgroups
Date: Tue, 16 Jun 2026 20:29:33 +0530
Message-ID: <20260616145128.189617449@linuxfoundation.org>
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

commit ae7676952790f421c40918e2586a2c9f12a682b6 upstream.

v3d_rewrite_csd_job_wg_counts_from_indirect() maps both the indirect
buffer and the workgroup buffer and is expected to release them before
returning. When any of the workgroup counts read from the buffer is zero,
the function bailed out early and skipped the cleanup, leaking the vaddr
mappings of both BOs.

Jump to the cleanup path instead of returning directly, so the mappings
are always dropped.

Cc: stable@vger.kernel.org
Fixes: 18b8413b25b7 ("drm/v3d: Create a CPU job extension for a indirect CSD job")
Suggested-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260602-v3d-fix-indirect-csd-v4-1-654309e32bc0@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -429,7 +429,7 @@ v3d_rewrite_csd_job_wg_counts_from_indir
 	wg_counts = (uint32_t *)(bo->vaddr + indirect_csd->offset);
 
 	if (wg_counts[0] == 0 || wg_counts[1] == 0 || wg_counts[2] == 0)
-		return;
+		goto unmap_bo;
 
 	args->cfg[0] = wg_counts[0] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 	args->cfg[1] = wg_counts[1] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
@@ -454,6 +454,7 @@ v3d_rewrite_csd_job_wg_counts_from_indir
 		}
 	}
 
+unmap_bo:
 	v3d_put_bo_vaddr(indirect);
 	v3d_put_bo_vaddr(bo);
 }


