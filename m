Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A10C53A38B;
	Wed, 30 Sep 2026 17:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790060; cv=none; b=iACqPQzvlAZitBdBcU5neskw2jB2Gy8TtnMAGKJRDy20SJmpbl8rQuYEY4QYPja5OihYTN334KT2cde96DZhrxei7aXqdm4URTMVapJ4VQqrsz6e5RXW3PcHzvEIIjJ8vMFUZoWtklqJMkJCqhLc51LjW7cP/3MYx0nAKYU329Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790060; c=relaxed/simple;
	bh=1KflMD5plShFIoeIMvuuK3roVoVSk/MdG1/yhXtqETE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRCBTf+0PNqiYh7KmiVfjFxfOIdia+NZBj45224DNZtR1w4DKGMzSVLyEKeE/51LHLq9B2J8cqhRsdOMZIn+SpgFW6nmSQuwZbUMey3yYaNKD5wrQUt5rGY6X1VCZm2bONcqxHYeE3sAaemyh/CVMB25TOO+RyBY3gM5NaW0k98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWs01I/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWs01I/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841E71F000FF;
	Wed, 30 Sep 2026 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790059;
	bh=cA3TiFddi/hZ/NDzJRQMLaV+wghIKYSLMVHDgiBFTKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWs01I/zi60vqfwE/nQ+yXWlbL1rhFwH/o4PiOegkHqlPEFjwyoz+NApC+uBapQsj
	 lOEDDbjFPcrrvVw7sspRVHEagl2x3hwTHLd+fuVIcpL9XzLHVVob/LzROi4+QoTZGR
	 8j/DGcYWCRqS5a2I8+bpyqofJLoZdYKEztnQcoLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 697/877] drm/amdgpu: Fix missing unwind in amdgpu_ib_schedule() error path
Date: Wed, 30 Sep 2026 17:26:48 +0200
Message-ID: <20260930152429.719450412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit ba038065655c45728be346d0b174a6da08d8a5c5 ]

amdgpu_ib_schedule() returns early after calling amdgpu_ring_undo().
This skips the common free_fence cleanup path.  Other error paths were
already changed to use goto free_fence, but this one was missed.

Change the early return to goto free_fence so all error paths clean up
the same way.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c:232 amdgpu_ib_schedule()
warn: missing unwind goto?

drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
    124 int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned int num_ibs,
    125                        struct amdgpu_ib *ibs, struct amdgpu_job *job,
    126                        struct dma_fence **f)
    127 {

    ...

    224
    225         if (ring->funcs->insert_start)
    226                 ring->funcs->insert_start(ring);
    227
    228         if (job) {
    229                 r = amdgpu_vm_flush(ring, job, need_pipe_sync);
    230                 if (r) {
    231                         amdgpu_ring_undo(ring);
--> 232                         return r;

	The patch changed the other error paths to goto free_fence but
	this one was accidentally skipped.

    233                 }
    234         }
    235
    236         amdgpu_ring_ib_begin(ring);

    ...

    338
    339 free_fence:
    340         if (!job)
    341                 kfree(af);
    342         return r;
    343 }

Fixes: f903b85ed0f1 ("drm/amdgpu: fix possible fence leaks from job structure")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6760f5cb12d2 ("drm/amdgpu: avoid force-completing uninitialized UVD rings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -217,7 +217,7 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 		r = amdgpu_vm_flush(ring, job, need_pipe_sync);
 		if (r) {
 			amdgpu_ring_undo(ring);
-			return r;
+			goto free_fence;
 		}
 	}
 


