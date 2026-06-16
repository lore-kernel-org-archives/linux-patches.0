Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7660331EAB;
	Tue, 16 Jun 2026 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627913; cv=none; b=YSIJ60hb014/m1xKp2/NUTLC6RSMYr1ZdnkhKrBNxymiYcdxGSP3z2AxFBcRAtIRhVHLsKGSCexXKiseSsikFBRzeSUpLyMlRSEKrzmVylBhi+i1mlJjK+mqCarWj9VlRpts0+IQipY1wfspQUIR1tHHbJVDKlQwDYq0LqoulRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627913; c=relaxed/simple;
	bh=5yhpUsaVMacZHeQ3wXkD7xaVadNj5ZppyAURhQnhKCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YLFWRnr2j4RViPIa+x4DGzHBglcSjqTRUnq5BXT2Qzc5HSrFTmRay4SzQSVKmSYK5P+eg1Tp09IWVcrY5hJ4I2Bb9z7C1FF+aSC+AKfvE7u4ZbZD/vK+6iKOFPQEAx1lm6n/XAEPDNhkyAql0gH6lezFJaJf023198CNPO6i8fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvyMqNYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvyMqNYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3911F000E9;
	Tue, 16 Jun 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627912;
	bh=+d8IOscpRYH3fh+sjaBv/TXFNTetS+OaSCcmOk+CC4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvyMqNYPbNASnBeND6Mz0IaCTFHQYB+eNUOwaogfKtUtaTn+RX0WrKoGQ9bX04AGX
	 /iK4dA4CCEW7dd9/R/NJmOkWSKaBz2PCNvNh6s61eK8JbqV0i+zAq5+NhpYFbmszgN
	 DvsR+TL5T5c7guOl6ySkm25Yxd7/LD52Uxpmb9QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.12 218/261] drm/v3d: Fix vaddr leak when indirect CSD has zeroed workgroups
Date: Tue, 16 Jun 2026 20:30:56 +0530
Message-ID: <20260616145055.132755338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
@@ -409,7 +409,7 @@ v3d_rewrite_csd_job_wg_counts_from_indir
 	wg_counts = (uint32_t *)(bo->vaddr + indirect_csd->offset);
 
 	if (wg_counts[0] == 0 || wg_counts[1] == 0 || wg_counts[2] == 0)
-		return;
+		goto unmap_bo;
 
 	args->cfg[0] = wg_counts[0] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
 	args->cfg[1] = wg_counts[1] << V3D_CSD_CFG012_WG_COUNT_SHIFT;
@@ -434,6 +434,7 @@ v3d_rewrite_csd_job_wg_counts_from_indir
 		}
 	}
 
+unmap_bo:
 	v3d_put_bo_vaddr(indirect);
 	v3d_put_bo_vaddr(bo);
 }


