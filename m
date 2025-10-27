Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94431D389;
	Mon, 27 Oct 2025 19:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592481; cv=none; b=sb8vce18WOoulw2lObQtOihthLPa+Mawmc4WJLDAU32IvAWZnpMYLSSKCKw+68Dlc8ndptDM1noYHok51DpJHw4GG5LUA6BJs+Y96MF8mFnj9cJskstvGd2TR8SqCzVr+ke88Motg8oDkNNJzhl+L+vbsWNXxRsmcKAxt3+pXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592481; c=relaxed/simple;
	bh=8kPq4ezmVeb+vKZ4PBFDQcxsaatCAWqQTzErdi8Rwnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5UFDMO8ab5zS9LM1X1EpOsfVoK4to41bp+2ujqX20iZSfjymlOdz7AFGtOlbENtICSEMRjxgUzg66fhJpkl5x0kAUUPR5niks/VDLeyej7lkAyTixjdldLz6HdX0Ttv2dnUY56PKrX6dZbS51EZB9QnzHlRLp+K0yN2rep65ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwM89np/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwM89np/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC86C4CEF1;
	Mon, 27 Oct 2025 19:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592481;
	bh=8kPq4ezmVeb+vKZ4PBFDQcxsaatCAWqQTzErdi8Rwnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwM89np/jYGIv4TzAmQbXiG8tQ0MLYJFUYQdxVRa6fqq+o5Vl4BHe7wUTTyrCqCRG
	 30PtjgQjcLebjyfrwMaj5inTVr2PyCNkvYyY+RTeYEI///7AlAHheZfzqPTxX9DyEy
	 +iVawo6RYVQQLO+YM0YrUFPn7U/jD5HKQrT9/PTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/157] drm/sched: Fix potential double free in drm_sched_job_add_resv_dependencies
Date: Mon, 27 Oct 2025 19:36:38 +0100
Message-ID: <20251027183504.935157690@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 5801e65206b065b0b2af032f7f1eef222aa2fd83 ]

When adding dependencies with drm_sched_job_add_dependency(), that
function consumes the fence reference both on success and failure, so in
the latter case the dma_fence_put() on the error path (xarray failed to
expand) is a double free.

Interestingly this bug appears to have been present ever since
commit ebd5f74255b9 ("drm/sched: Add dependency tracking"), since the code
back then looked like this:

drm_sched_job_add_implicit_dependencies():
...
       for (i = 0; i < fence_count; i++) {
               ret = drm_sched_job_add_dependency(job, fences[i]);
               if (ret)
                       break;
       }

       for (; i < fence_count; i++)
               dma_fence_put(fences[i]);

Which means for the failing 'i' the dma_fence_put was already a double
free. Possibly there were no users at that time, or the test cases were
insufficient to hit it.

The bug was then only noticed and fixed after
commit 9c2ba265352a ("drm/scheduler: use new iterator in drm_sched_job_add_implicit_dependencies v2")
landed, with its fixup of
commit 4eaf02d6076c ("drm/scheduler: fix drm_sched_job_add_implicit_dependencies").

At that point it was a slightly different flavour of a double free, which
commit 963d0b356935 ("drm/scheduler: fix drm_sched_job_add_implicit_dependencies harder")
noticed and attempted to fix.

But it only moved the double free from happening inside the
drm_sched_job_add_dependency(), when releasing the reference not yet
obtained, to the caller, when releasing the reference already released by
the former in the failure case.

As such it is not easy to identify the right target for the fixes tag so
lets keep it simple and just continue the chain.

While fixing we also improve the comment and explain the reason for taking
the reference and not dropping it.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 963d0b356935 ("drm/scheduler: fix drm_sched_job_add_implicit_dependencies harder")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/dri-devel/aNFbXq8OeYl3QSdm@stanley.mountain/
Cc: Christian König <christian.koenig@amd.com>
Cc: Rob Clark <robdclark@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: Christian König <ckoenig.leichtzumerken@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20251015084015.6273-1-tvrtko.ursulin@igalia.com
[ applied to drm_sched_job_add_implicit_dependencies instead of drm_sched_job_add_resv_dependencies ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_main.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -719,13 +719,14 @@ int drm_sched_job_add_implicit_dependenc
 
 	dma_resv_for_each_fence(&cursor, obj->resv, dma_resv_usage_rw(write),
 				fence) {
-		/* Make sure to grab an additional ref on the added fence */
-		dma_fence_get(fence);
-		ret = drm_sched_job_add_dependency(job, fence);
-		if (ret) {
-			dma_fence_put(fence);
+		/*
+		 * As drm_sched_job_add_dependency always consumes the fence
+		 * reference (even when it fails), and dma_resv_for_each_fence
+		 * is not obtaining one, we need to grab one before calling.
+		 */
+		ret = drm_sched_job_add_dependency(job, dma_fence_get(fence));
+		if (ret)
 			return ret;
-		}
 	}
 	return 0;
 }


