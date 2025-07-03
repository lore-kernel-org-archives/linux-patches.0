Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4F62BDC1B;
	Thu,  3 Jul 2025 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555191; cv=none; b=d2ZQ2+7eJU2rqs3dQpdbV0P1/vNT8Jv9C/XZsK857QWqb4YOYf+r9cwhIvgw7HPuNVD+tPgG+ayGAVwmY8xTho8XDN5JNJdoPbGYKRQ6tdW3Nu3ixCtn1EarHaZGGwgyc6UyzdpeCvaqkdgogatle6GKNJLZD4kYNTcDL4AocLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555191; c=relaxed/simple;
	bh=Q4VwwCArSNQ2z88emNWD3h3KM5cP2K3AGtJwljRrFC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ksCRpKSneGcC0xK2ukjiqx0YelmF2ZSw+/YoqhS1Mbo9ZtDSlKk27DUp48hmKNqrCnThfJlwU191V6pAFz1OBTOLEE19/v+iKYPZLTmrBAqRBUevNeUCGae5Xe5Gem+fSKAGTI8S54N59DuPEWw5p32OLxljGEPORexRVfQg3QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFm+/wLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFm+/wLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF073C4CEEE;
	Thu,  3 Jul 2025 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555191;
	bh=Q4VwwCArSNQ2z88emNWD3h3KM5cP2K3AGtJwljRrFC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFm+/wLVeAHe+vNSHjTVdbvPezAs0vcVc38Wpw0WRMhb/a9GDNBhb0clDepwdARQA
	 sRAP99+qjuV4IplbTPVXmydQXPQujDVY7kJS3h3eOhUgSJa7/5tKsxigtb2+YxFS/U
	 s0mKd0DBe4fEEmWeQyipBGRcDImTQjMX+Bq1vFdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.15 204/263] drm/etnaviv: Protect the schedulers pending list with its lock
Date: Thu,  3 Jul 2025 16:42:04 +0200
Message-ID: <20250703144012.549865576@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 61ee19dedb8d753249e20308782bf4e9e2fb7344 upstream.

Commit 704d3d60fec4 ("drm/etnaviv: don't block scheduler when GPU is still
active") ensured that active jobs are returned to the pending list when
extending the timeout. However, it didn't use the pending list's lock to
manipulate the list, which causes a race condition as the scheduler's
workqueues are running.

Hold the lock while manipulating the scheduler's pending list to prevent
a race.

Cc: stable@vger.kernel.org
Fixes: 704d3d60fec4 ("drm/etnaviv: don't block scheduler when GPU is still active")
Reported-by: Philipp Stanner <phasta@kernel.org>
Closes: https://lore.kernel.org/dri-devel/964e59ba1539083ef29b06d3c78f5e2e9b138ab8.camel@mailbox.org/
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20250602132240.93314-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_sched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_sched.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
@@ -35,6 +35,7 @@ static enum drm_gpu_sched_stat etnaviv_s
 							  *sched_job)
 {
 	struct etnaviv_gem_submit *submit = to_etnaviv_submit(sched_job);
+	struct drm_gpu_scheduler *sched = sched_job->sched;
 	struct etnaviv_gpu *gpu = submit->gpu;
 	u32 dma_addr, primid = 0;
 	int change;
@@ -89,7 +90,9 @@ static enum drm_gpu_sched_stat etnaviv_s
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 
 out_no_timeout:
-	list_add(&sched_job->list, &sched_job->sched->pending_list);
+	spin_lock(&sched->job_list_lock);
+	list_add(&sched_job->list, &sched->pending_list);
+	spin_unlock(&sched->job_list_lock);
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 }
 


