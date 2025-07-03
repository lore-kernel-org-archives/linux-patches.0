Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF5722B8AB;
	Thu,  3 Jul 2025 15:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556187; cv=none; b=dREv41fkRPeMS2iWN97fwC/H88KHDKcGoIIGEEWa52Y+yzI+7D9whxAVQ6V5rDNsSJ7cpvB/dnwR8woV0mIyKDxbI8HUmrek111d3lSMHHpGJUIKwXC9X+DP6twwH5vGWzuF9gg6T2B32qvOO12QM7vG1w7pidOxde/yA6gyf2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556187; c=relaxed/simple;
	bh=5afH0e2oAIZJ9LXAuyeZNaa+Pkv0OhP7TLrbnMy4sUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ErPSHNp5WrYBapdjA4Ml2u4TYdLjcftSz25fCN8rYUSAys8o0ihwV6nuJPg9XZgkgbX6cD9gFo2tHNt3TXSjIhj2joRw7bVUtBATm826sBRsNH7InxcWgb6Kqbr1sLXeMVfOl+LMmb/w+3ad4m6xrQk1RcY1zZtH3Gsg/9/YqIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BlBgFOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BlBgFOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505E0C4CEE3;
	Thu,  3 Jul 2025 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556186;
	bh=5afH0e2oAIZJ9LXAuyeZNaa+Pkv0OhP7TLrbnMy4sUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BlBgFOpiMymTil71I+yFur2gZmfCcVSCc67jz0JEkY+VGl7xJvgzoe14HZIO508h
	 exRY7uaV3q4yJF//qRac97/IUUVz97NsRQ4s2emLft9jddkJkp0Qqb+AMmtwExJmha
	 lkxCmlBme+pZrzPbjhCh35bH1JFjHGqZzF/11gBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.1 102/132] drm/etnaviv: Protect the schedulers pending list with its lock
Date: Thu,  3 Jul 2025 16:43:11 +0200
Message-ID: <20250703143943.398227884@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -34,6 +34,7 @@ static enum drm_gpu_sched_stat etnaviv_s
 							  *sched_job)
 {
 	struct etnaviv_gem_submit *submit = to_etnaviv_submit(sched_job);
+	struct drm_gpu_scheduler *sched = sched_job->sched;
 	struct etnaviv_gpu *gpu = submit->gpu;
 	u32 dma_addr;
 	int change;
@@ -75,7 +76,9 @@ static enum drm_gpu_sched_stat etnaviv_s
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 
 out_no_timeout:
-	list_add(&sched_job->list, &sched_job->sched->pending_list);
+	spin_lock(&sched->job_list_lock);
+	list_add(&sched_job->list, &sched->pending_list);
+	spin_unlock(&sched->job_list_lock);
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 }
 


