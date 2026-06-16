Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648E9379EFC;
	Tue, 16 Jun 2026 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626444; cv=none; b=KftwsZ2kCzHH3WMg+FjCA2prAzwt8Myjx3txXBQzKM6aeviC1qgR8nu6cZQ7wfZvp88Hpr9HOJiOzLd99cOh/o+RZecjGJHDP+LOxvHNSXC+2shuUcZ+nyGcrIyUafWdB2zxc8ARoLX+dfHTvVv3nKFj3rN4okPPx1Kg9qX5vRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626444; c=relaxed/simple;
	bh=PWcIGTvnBbfu0fLKDidZqvdHeqxEN2h6tPqifH/zHBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=afrmkfDAQWyVk2TUICEIhT6h3hEbyAWfxWlovjQyMdM7+aC5BIZLJFNnnv6VKgivHOqc/YoOpwT389CaX+1aCtEwME03HW3X9tp6zU9KL8Wo6KB3ObiITX/Rg7Y1gan8qPNNCcPZC3fF9cwTvtjgynFKO07LzjEvRAmUY+96XWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJQymApL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJQymApL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE061F000E9;
	Tue, 16 Jun 2026 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626443;
	bh=1S+7yP/jElnvEgPwAAwZtn90HzjbpoB2K6mK9T1oOZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJQymApLRCY2f1OyivVN7GgoOBwdX6trmL8lhyTtkH1ocui4yCkRpqCyBdM75eHb6
	 +kiVB8pJ9EVp1P+jQEcfgFf0PCHoTdF1Ng6oo6X7NLpSh7s3f6pq7/sYKcie9Py7oZ
	 G5tQWPeczkQZf84BDugRUDbrXp6Gy+rftdZguE3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.18 289/325] drm/v3d: Fix vaddr leak when indirect CSD has zeroed workgroups
Date: Tue, 16 Jun 2026 20:31:25 +0530
Message-ID: <20260616145113.178543767@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,7 +428,7 @@ v3d_rewrite_csd_job_wg_counts_from_indir
 	wg_counts = (uint32_t *)(bo->vaddr + indirect_csd->offset);
 
 	if (wg_counts[0] == 0 || wg_counts[1] == 0 || wg_counts[2] == 0)
-		return;
+		goto unmap_bo;
 
 	args->cfg[0] = wg_counts[0] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 	args->cfg[1] = wg_counts[1] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
@@ -453,6 +453,7 @@ v3d_rewrite_csd_job_wg_counts_from_indir
 		}
 	}
 
+unmap_bo:
 	v3d_put_bo_vaddr(indirect);
 	v3d_put_bo_vaddr(bo);
 }


