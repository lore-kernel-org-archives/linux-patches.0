Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7901C9B99;
	Tue,  8 Oct 2024 13:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392793; cv=none; b=bGetJaLboZQVn+IARdu2l7W+xqGrskwx0HH1bayNXVDRD+DmxcnZUZ8IucNnvaJ9YC8HZ/WX0hKvXTH1QiIiARJCNBGBk5PU2wqv9lp3z0KFixhSrgozch4fec34/hT2gwqO6Kd8oeLpyrNdxI0+HFWCoGwyGFuAfz2lmFNmtcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392793; c=relaxed/simple;
	bh=2TfEhMx5EioFduMCRmWMMeuHl/gVEQlr/ZEjFpQdiuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EQNnE0gejy6K5y2Rh/Gdg6sEGs3Nq3TFq0cGKXFHO1XQYHoV6kMYnveUm2ayX4M2b87gF2x0aoNZ4JuL6i7vcY7KyvilOLwWfk6j1ynSB3hExYuACmLlA2ZtOCHKAwOuHxDIxQ7EBtwDtsJbWyuQ4Fb6/KiDC2XTu31kba8mvdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4L5dUxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4L5dUxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB7C4CECE;
	Tue,  8 Oct 2024 13:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392793;
	bh=2TfEhMx5EioFduMCRmWMMeuHl/gVEQlr/ZEjFpQdiuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4L5dUxzxXeS65aG5QIyZss+a5fnEA9RUNPPs21wm9EWOLoon3Qal5GSIHwLZjjwc
	 wziH3YzyYCNt05D1TWd3dF9tuRLwzy3bu4ruCN3wmHQ5lcAGzpAj4A1MkMJfk4FMfI
	 2cFhDgdahEb6IM2j4ZSyLYmqlxe8bj73P/nPn2Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Luben Tuikov <ltuikov89@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Philipp Stanner <pstanner@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.11 522/558] drm/sched: Always wake up correct scheduler in drm_sched_entity_push_job
Date: Tue,  8 Oct 2024 14:09:12 +0200
Message-ID: <20241008115722.770801147@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit cbc8764e29c2318229261a679b2aafd0f9072885 upstream.

Since drm_sched_entity_modify_sched() can modify the entities run queue,
lets make sure to only dereference the pointer once so both adding and
waking up are guaranteed to be consistent.

Alternative of moving the spin_unlock to after the wake up would for now
be more problematic since the same lock is taken inside
drm_sched_rq_update_fifo().

v2:
 * Improve commit message. (Philipp)
 * Cache the scheduler pointer directly. (Christian)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: b37aced31eb0 ("drm/scheduler: implement a function to modify sched list")
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Luben Tuikov <ltuikov89@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Philipp Stanner <pstanner@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924101914.2713-3-tursulin@igalia.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -599,6 +599,9 @@ void drm_sched_entity_push_job(struct dr
 
 	/* first job wakes up scheduler */
 	if (first) {
+		struct drm_gpu_scheduler *sched;
+		struct drm_sched_rq *rq;
+
 		/* Add the entity to the run queue */
 		spin_lock(&entity->rq_lock);
 		if (entity->stopped) {
@@ -608,13 +611,16 @@ void drm_sched_entity_push_job(struct dr
 			return;
 		}
 
-		drm_sched_rq_add_entity(entity->rq, entity);
+		rq = entity->rq;
+		sched = rq->sched;
+
+		drm_sched_rq_add_entity(rq, entity);
 		spin_unlock(&entity->rq_lock);
 
 		if (drm_sched_policy == DRM_SCHED_POLICY_FIFO)
 			drm_sched_rq_update_fifo(entity, submit_ts);
 
-		drm_sched_wakeup(entity->rq->sched);
+		drm_sched_wakeup(sched);
 	}
 }
 EXPORT_SYMBOL(drm_sched_entity_push_job);


