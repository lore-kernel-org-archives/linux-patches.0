Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB238304BAB;
	Sat, 25 Oct 2025 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409710; cv=none; b=iiIhKVc7xL+56f09DbjuqTtX2eJIXpZlO4QAHS79Ip4skfIxNIsrhR13liE9pLqQupdMnACt2lnjoXItyEGq3I2K3T0mRZ4hvxfqP2R7V/APODY/K+m0sKtNefMCVqzWSMTH/8GdZdI5JKpj2AUXJb37xz1GW4s52D/2pQNLlVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409710; c=relaxed/simple;
	bh=6yyoayz76+vub9Ry6D2Hj4pA7N4fZJy3mCuoP6iyEqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcygd5COh2P53sPXnWadRKOu/uziMgsWrT0nmbkBwF9ACVa38Toc3ok6mNecWbQ723I+yPfNc1VswUqBTazLFwAYSx1WNVuTX8crKYmpNX9mn1HZR+yuUnD31vU4DUdbunTL7sp4LEDYgyhYoMDYT0EbSAmKbQcM07bbL4cZ5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qhedthyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qhedthyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8873AC4CEF5;
	Sat, 25 Oct 2025 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409710;
	bh=6yyoayz76+vub9Ry6D2Hj4pA7N4fZJy3mCuoP6iyEqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhedthygoXzGG7BmBbiHIlYnnhD0xiXBVltQ/xs1QWFNFFxoQySbsatbE1k3Bo9tP
	 kCL4CpxysZvAR/v0AUsSuP8HN9ol+VrLk6TPqcdU0FVlYPwwd+J8NmhXXrfjOFX1gG
	 DKYyQx94sAc91tUr70kmWpDrvuwC+12u4Jogy4tpkiQm59ncqebNxKSRulcUESrjON
	 UrtPHjT2v0GxBdyvKzBS0GDT8lMqvuQFsQKAxCCbbQc7Ap59oVSrPP/Pa5zOp5gqyE
	 v/sjGqKOYmiTrIVQHf4Oa/D+BwenVz6LijSqwdaU51oRPQIUbkIO2uWgWvR3Fuf6Em
	 +w9I8z4q9Zphw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Jesse.Zhang" <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Arunpravin.PaneerSelvam@amd.com,
	Arvind.Yadav@amd.com,
	dan.carpenter@linaro.org,
	shashank.sharma@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Fix fence signaling race condition in userqueue
Date: Sat, 25 Oct 2025 12:01:01 -0400
Message-ID: <20251025160905.3857885-430-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit b8ae2640f9acd4f411c9227d2493755d03fe440a ]

This commit fixes a potential race condition in the userqueue fence
signaling mechanism by replacing dma_fence_is_signaled_locked() with
dma_fence_is_signaled().

The issue occurred because:
1. dma_fence_is_signaled_locked() should only be used when holding
   the fence's individual lock, not just the fence list lock
2. Using the locked variant without the proper fence lock could lead
   to double-signaling scenarios:
   - Hardware completion signals the fence
   - Software path also tries to signal the same fence

By using dma_fence_is_signaled() instead, we properly handle the
locking hierarchy and avoid the race condition while still maintaining
the necessary synchronization through the fence_list_lock.

v2: drop the comment (Christian)

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `amdgpu_userq_fence_create()` only holds the queue-wide
  `fence_list_lock` when it checks completion, so calling
  `dma_fence_is_signaled_locked()` there violated the documented
  precondition that the per-fence spinlock be held (`include/linux/dma-
  fence.h:414-425`). That allowed the helper to run
  `dma_fence_signal_locked()` without proper serialization, so hardware
  completion and the software fast path could both signal the same
  fence, corrupting the callback list and triggering the “double signal”
  race the author observed.
- Switching to `dma_fence_is_signaled()` at
  `drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c:286-290` makes the
  same completion check but lets the helper take the per-fence lock
  itself before signaling, matching the lock ordering already used by
  the runtime completion path (`amdgpu_userq_fence_driver_process()`
  calls `dma_fence_signal()` under the same `fence_list_lock`; see
  `drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c:162-175`). That
  closes the race without functional side effects—the fence still ends
  up signaled or enqueued exactly as before.
- The regression comes from 2e65ea1ab2f6f (“drm/amdgpu: screen freeze
  and userq driver crash”), so every stable kernel that picked up
  userqueue support since that change is exposed. This fix is a single-
  line change, introduces no new APIs, and aligns with existing locking
  patterns, so the backport risk is very low.
- Residual risk: other userqueue helpers still call `_locked` variants
  while holding only the driver lock, so additional audits may be
  warranted, but this patch addresses the high-risk race in the job
  creation fast path and should land in stable promptly.

Suggested next step: cherry-pick into all stable trees that contain
2e65ea1ab2f6f.

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index c2a983ff23c95..b372baae39797 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -276,7 +276,7 @@ static int amdgpu_userq_fence_create(struct amdgpu_usermode_queue *userq,
 
 	/* Check if hardware has already processed the job */
 	spin_lock_irqsave(&fence_drv->fence_list_lock, flags);
-	if (!dma_fence_is_signaled_locked(fence))
+	if (!dma_fence_is_signaled(fence))
 		list_add_tail(&userq_fence->link, &fence_drv->fences);
 	else
 		dma_fence_put(fence);
-- 
2.51.0

