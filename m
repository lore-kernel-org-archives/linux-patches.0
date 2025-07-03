Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231E42E62CD;
	Thu,  3 Jul 2025 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554667; cv=none; b=jUIMX7Izd5rtkiIcfkmJJY9PavJqknigfIxjneNOsPEX/wB6QG4o829jnJ3ZX6oSQFGvnGLT3EQJ3mJmuERzSWtO2IGUT5ncL9Jzcmm7Hc50jry2FPojRkGakS55Z3xS0+XkgG2HZypc4vUXA4gVIEdRAdgnohX6Su9E1mFWOzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554667; c=relaxed/simple;
	bh=1Z8M5JJReOoGgDwiM+kc6jT2DPoZHry5ItJH2j4zUAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XbGvhYTih9szEfH/vilmHKMk7WHEZPvV1QUL3keLyJ+yGrgk6isADjKLEcXW+DvQ/kiPUTuDk6RVqllQycLJjPyw27xlsv60blz8K6fcadtvQD5yVEQgTKMC5S45f1M9cvawSr+Zu55yRcRnlb5u2YXW69eK5jgcpya648eGrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhcwODox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhcwODox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8389C4CEE3;
	Thu,  3 Jul 2025 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554667;
	bh=1Z8M5JJReOoGgDwiM+kc6jT2DPoZHry5ItJH2j4zUAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhcwODoxJ9G+VUUFLzeSEuzg7G2EAUz+g0eFffo17PP/9CvvFGc6mlkvoyVhXDucz
	 ZZqsQG4nhb+Wb5c2A9eH0X/VYYWhVDuQ1hbNAN6lroyVknlrob6yAVJ0oQUUTCSVBZ
	 MLAEsn1OA/Pozxr9IHW30vzIR/JoQ6wOY/Y7uGtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 043/263] drm/scheduler: signal scheduled fence when kill job
Date: Thu,  3 Jul 2025 16:39:23 +0200
Message-ID: <20250703144006.034794120@linuxfoundation.org>
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

From: Lin.Cao <lincao12@amd.com>

[ Upstream commit 471db2c2d4f80ee94225a1ef246e4f5011733e50 ]

When an entity from application B is killed, drm_sched_entity_kill()
removes all jobs belonging to that entity through
drm_sched_entity_kill_jobs_work(). If application A's job depends on a
scheduled fence from application B's job, and that fence is not properly
signaled during the killing process, application A's dependency cannot be
cleared.

This leads to application A hanging indefinitely while waiting for a
dependency that will never be resolved. Fix this issue by ensuring that
scheduled fences are properly signaled when an entity is killed, allowing
dependent applications to continue execution.

Signed-off-by: Lin.Cao <lincao12@amd.com>
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250515020713.1110476-1-lincao12@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index bd39db7bb2408..e671aa2417206 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -176,6 +176,7 @@ static void drm_sched_entity_kill_jobs_work(struct work_struct *wrk)
 {
 	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
 
+	drm_sched_fence_scheduled(job->s_fence, NULL);
 	drm_sched_fence_finished(job->s_fence, -ESRCH);
 	WARN_ON(job->s_fence->parent);
 	job->sched->ops->free_job(job);
-- 
2.39.5



