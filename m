Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7EC27280A;
	Mon, 13 Apr 2026 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097026; cv=none; b=IkJCFBQz4NqzjLD2Z7Y/MlJITJQNGbDayMDtgihCJYKL8UtSPpf9HsI+pdWFJ/apRP4Bvbavl80i7uJs2jurgAQYcyyEMtuiRVnnzIRcTQ2HnPLQGi0lnMaSlRuXfa4LjIIvYnYF51ta3vd14B+Ckaw9xJV3uLJ0/K/g96K8inM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097026; c=relaxed/simple;
	bh=YLSM1IDeCktIfNYrFmSJEmgc40N32VKog5uVHkVphCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qjd15lP9Hkw2xJiEDA4gsKTN75Z3RA5z80IJFNtIfhQ7HcmoYMiuSWU/pZbQZvbOpYvpwMUyOXGzcyTeY5givD9FCH2D/Au79oCt8ExdMmZ5RhMl0bnjXyxeWimu2QI8mfMR0/HR3+1/sysMW5A/5ctJG0TR6mScg+X0dUDOmnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AS69IQOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AS69IQOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1219FC2BCAF;
	Mon, 13 Apr 2026 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097026;
	bh=YLSM1IDeCktIfNYrFmSJEmgc40N32VKog5uVHkVphCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS69IQOqICjPgKqb4Cf4KZ4nwb5htXTA3yUlzeDtVe9dgzG8KqOyHSSESw6+Qf+HS
	 YmVCgj6Ora64zJwXp3m+GM58mmf4g2/DjnheoVL6ijIqXvvYntAu1Uc5vE6ftI8aTs
	 E4HmkC9ycQVvudooPy+i6DeYni+tPKj8y5nXWv9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Leon Chen <leonchen.oss@139.com>
Subject: [PATCH 6.1 34/55] drm/scheduler: signal scheduled fence when kill job
Date: Mon, 13 Apr 2026 18:01:08 +0200
Message-ID: <20260413155726.110922418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin.Cao <lincao12@amd.com>

commit 471db2c2d4f80ee94225a1ef246e4f5011733e50 upstream.

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
[ Modified drm_sched_fence_scheduled(job->s_fence, NULL) to
  drm_sched_fence_scheduled(job->s_fence) for kernel 6.1.y ]
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -196,6 +196,7 @@ static void drm_sched_entity_kill_jobs_w
 {
 	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
 
+	drm_sched_fence_scheduled(job->s_fence);
 	drm_sched_fence_finished(job->s_fence);
 	WARN_ON(job->s_fence->parent);
 	job->sched->ops->free_job(job);


