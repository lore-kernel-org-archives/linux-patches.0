Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A77189522;
	Tue, 30 Jul 2024 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359550; cv=none; b=BsuItyrpVin4X74lMfNQvWW3RjS+aht4WMLxxf0z31VUTGenLL3DlbLsLOCBHc7+Tkv1OSHkvX0PzENLOIFkcFJZGFaATne8KerIlf8NuMvD9ODlVKpuLI1NLa0MCeqtFA0iLnS77AmXFENQK+N4ZRjuERWM3PWUiyRRB4VlOiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359550; c=relaxed/simple;
	bh=FnQZ0johRZ5uUntPPn7Bs9ufV0JKehBeVukCaZVl4QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu9rtOV00j4bWy9dssaAcPSWe4elynYMskDqFWC3P1rsr5MAcRazGdIbDI7lwB5ieDVWpjCTj5mCmp/nDJ8q+qMk3df5v73QWJI9RwD+u+21lxpBPExtFjsSQEPFxE92GhRnrxnNFjmHde/sL47PrHey/6tlRt48Gj7Ad9AZ1Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUvyj8xb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUvyj8xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94CCC32782;
	Tue, 30 Jul 2024 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359550;
	bh=FnQZ0johRZ5uUntPPn7Bs9ufV0JKehBeVukCaZVl4QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUvyj8xbljXKm4rVMJaH0Mfspy7BQ0kEPuRCdvdqqqxzBAkbnr0200a7KDQ2dYxjB
	 4yfVDcBbMgfTVrGwMrbSIRG3jZfCyjLKNP+Zwf9yLSjEZ6fHolJx+s7ajMfYtQ4LJ/
	 DZ1QK+8ziE/9iZFVWJwFw7WlC+JtSvwSVsJfg8Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>
Subject: [PATCH 6.6 500/568] drm/etnaviv: dont block scheduler when GPU is still active
Date: Tue, 30 Jul 2024 17:50:07 +0200
Message-ID: <20240730151659.569640556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

commit 704d3d60fec451f37706368d9d3e320322978986 upstream.

Since 45ecaea73883 ("drm/sched: Partial revert of 'drm/sched: Keep
s_fence->parent pointer'") still active jobs aren't put back in the
pending list on drm_sched_start(), as they don't have a active
parent fence anymore, so if the GPU is still working and the timeout
is extended, all currently active jobs will be freed.

To avoid prematurely freeing jobs that are still active on the GPU,
don't block the scheduler until we are fully committed to actually
reset the GPU.

As the current job is already removed from the pending list and
will not be put back when drm_sched_start() isn't called, we must
make sure to put the job back on the pending list when extending
the timeout.

Cc: stable@vger.kernel.org #6.0
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_sched.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_sched.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
@@ -38,9 +38,6 @@ static enum drm_gpu_sched_stat etnaviv_s
 	u32 dma_addr;
 	int change;
 
-	/* block scheduler */
-	drm_sched_stop(&gpu->sched, sched_job);
-
 	/*
 	 * If the GPU managed to complete this jobs fence, the timout is
 	 * spurious. Bail out.
@@ -63,6 +60,9 @@ static enum drm_gpu_sched_stat etnaviv_s
 		goto out_no_timeout;
 	}
 
+	/* block scheduler */
+	drm_sched_stop(&gpu->sched, sched_job);
+
 	if(sched_job)
 		drm_sched_increase_karma(sched_job);
 
@@ -76,8 +76,7 @@ static enum drm_gpu_sched_stat etnaviv_s
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 
 out_no_timeout:
-	/* restart scheduler after GPU is usable again */
-	drm_sched_start(&gpu->sched, true);
+	list_add(&sched_job->list, &sched_job->sched->pending_list);
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 }
 


