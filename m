Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461B543E06E;
	Thu, 30 Jul 2026 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422480; cv=none; b=KAa72xAEVJMtoWJL0tMO0hdflvi3YB0Wvmg24K8xhfHkInc5cEQeqSxkziQoLbLXALuPb7hhiokD25gEaYf9tmXYsrGn3k+gJpyQhxH1xsSnmLVR0c3gmBFHw2t1+aplVrrhPOpUj8wJQK1Qy6VeI+w2oMGN02jk8oAF7BaVfsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422480; c=relaxed/simple;
	bh=QZZ9TThs+HZUBE/k0JQyJF9CUnvSabMcqkYIjCsUcpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IRDRc5SO0pVvHcjeuBxIet49fkHHp5Sel8MZjn7wFdPt/49vDNotfrWpEyB41J2RKcqfd3c6fl5/MjcTQxWgbY/2CLTa3VaIQjXOTflekjTjj/2GtCFOXDRnTuZEjn0p7hrhYpK1/xxRtiFk6wOhZG4S0ee5ZY3gVlEuhTxPYKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qym/DAB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qym/DAB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A208B1F000E9;
	Thu, 30 Jul 2026 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422479;
	bh=hFe5cENAsCZLGURU5IHC2U5jAYF3a38gRakYR+XVHwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qym/DAB9733lcNl98sXYorP8jT6dS2KW95m6RArQYneWje/MRpxZpw8hmlDNFN191
	 UA7tPA0Nud4jNKTjdjAHBxVqv64BXkW6+EuQrLaFXIak1nEeIr+1THxB9dVdJmJN5B
	 qUR41BWXnM8Gl2CnE1ZZSIUYd6QdXX0lIj0Ur4eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 451/744] drm/amdgpu/userq: fix indefinite fence wait during GPU reset
Date: Thu, 30 Jul 2026 16:12:04 +0200
Message-ID: <20260730141453.883383038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 5d75ec2e5f1736c2f10c7d6f4565bf1bf29f29a7 upstream.

pre_reset only force-completes fences of MAPPED queues. A queue in any
other state (e.g. mid-eviction) keeps its last_fence pending; after a
GPU reset that fence never signals, so the eviction/suspend worker and
process teardown (amdgpu_evf_mgr_flush_suspend) wait on it forever and
wedge the machine:

  INFO: task kworker/6:28 blocked for more than 120 seconds.
  Workqueue: events amdgpu_eviction_fence_suspend_worker [amdgpu]
  Call Trace:
   dma_fence_wait_timeout+0x7e/0x130
   amdgpu_userq_evict+0x67/0x140 [amdgpu]
   amdgpu_eviction_fence_suspend_worker+0xd8/0x160 [amdgpu]
   process_scheduled_works+0xa6/0x420

Force-complete every queue's fence regardless of state. The unmap and
mark-hung step stays gated on MAPPED, since unmapping a queue that is
not mapped is invalid.

Fixes: 290f46cf5726 ("drm/amdgpu: Implement user queue reset functionality")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9102b39fa924dcc3dc75a3137bfa9633c40b88c0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -1376,16 +1376,19 @@ void amdgpu_userq_pre_reset(struct amdgp
 
 	/* TODO: We probably need a new lock for the queue state */
 	xa_for_each(&adev->userq_doorbell_xa, queue_id, queue) {
-		if (queue->state != AMDGPU_USERQ_STATE_MAPPED)
-			continue;
-
-		userq_funcs = adev->userq_funcs[queue->queue_type];
-		userq_funcs->unmap(queue);
-		/* just mark all queues as hung at this point.
-		 * if unmap succeeds, we could map again
-		 * in amdgpu_userq_post_reset() if vram is not lost
+		if (queue->state == AMDGPU_USERQ_STATE_MAPPED) {
+			userq_funcs = adev->userq_funcs[queue->queue_type];
+			userq_funcs->unmap(queue);
+			/* just mark all queues as hung at this point.
+			 * if unmap succeeds, we could map again
+			 * in amdgpu_userq_post_reset() if vram is not lost
+			 */
+			queue->state = AMDGPU_USERQ_STATE_HUNG;
+		}
+		/* Force-complete any pending fence regardless of queue state so
+		 * that eviction/suspend and queue teardown waiters don't block
+		 * forever on a fence that will never signal after the reset.
 		 */
-		queue->state = AMDGPU_USERQ_STATE_HUNG;
 		amdgpu_userq_fence_driver_force_completion(queue);
 	}
 }


