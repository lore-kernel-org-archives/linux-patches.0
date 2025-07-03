Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76832EE97A;
	Thu,  3 Jul 2025 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555477; cv=none; b=OfaeYPRyziQGzDfmmseHBNGy6OLUa2dG9ff6cwWnxNM8GJH1EkeQ7SXPXqjZyhsjWD1TO8yDtN0esl0jsagLagxhXu/GQJZ2hTs1/X4epKSVLAviDVN+9AFgzFzATRBykrWkH7s+AbXJE5EDYHDux7qFX/xCyrFnPMxnflWvWMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555477; c=relaxed/simple;
	bh=wmGI/6aKRfDhGJmEJc6yRuNawFyXL1nnKr9zRTHKkTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Igi6+Xz3WK0QV4ua3ZlhgspyXmMUb7HYsn8mKl8GsVj8yulcTZJwzDqXz1n1E1UuxzBvEmG8CUMoBg6ASNaI7g8fUj6QPRdJbrc9jWUhhUdm6KIy6pI1/K0jupNjFhvIF88P24PsOW9R0sGLtHnb+wJHc6UnVEwCLYPlP5Rf11k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGosTgtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGosTgtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE95EC4CEE3;
	Thu,  3 Jul 2025 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555476;
	bh=wmGI/6aKRfDhGJmEJc6yRuNawFyXL1nnKr9zRTHKkTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGosTgtSf7OuUkbGh1gKSpoaJWdeB6Ry+kTjiEDt2TRMTr6hHNyZTTtUhjTZs4ozv
	 QK9UU8E2WghD5DtNYeUM73hlZVd/SYWruvzYlpzpdHOgYDekDn80uMT/wdG3j94qUy
	 ugvuYv9lC8aMSRwFO2KdfV9dJvbZDz248xXtZo88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/139] drm/scheduler: signal scheduled fence when kill job
Date: Thu,  3 Jul 2025 16:41:28 +0200
Message-ID: <20250703143942.166041037@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 53130a50584ca..eed3b8bed9e40 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -167,6 +167,7 @@ static void drm_sched_entity_kill_jobs_work(struct work_struct *wrk)
 {
 	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
 
+	drm_sched_fence_scheduled(job->s_fence, NULL);
 	drm_sched_fence_finished(job->s_fence, -ESRCH);
 	WARN_ON(job->s_fence->parent);
 	job->sched->ops->free_job(job);
-- 
2.39.5



