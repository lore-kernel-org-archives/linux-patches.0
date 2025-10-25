Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7D0301022;
	Sat, 25 Oct 2025 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409121; cv=none; b=niKoDwduThjofhXuAukj+1fJY19ipxU+D3H4ZOYkXLIL9IzSFRWEzsxQUon5m6ZuLCL+bduHMWpMkbiv0LHtzGVvE7wz4RxUcZ4Z5Z6JM+5U7XsNBqHiC+WidEH1MEMPW2G5Oqrm4kINir3Cu1hOTqkNOeUVKyMHF08gYRGho/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409121; c=relaxed/simple;
	bh=QAgLSewJZFccX3NcwGtj/VLiSP21lCVfi8MekQCS2i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b7kYk+DE7HoJHVVUrwsafxs3TdTkOXUVHSE4r4eiHUBbP/1EcyJV/Fy+7Xwz92+qgU2kKxP9J7CJLlIl68GrDkS6OGYto4qtNh/mq29HmJsKIeKMOZuycQENqbooOZqJ6w+0+rHIg/uajnAj3jz/3l2u60qRd8ddmF27J8O2ssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0tcKLIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0tcKLIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4F0C4CEF5;
	Sat, 25 Oct 2025 16:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409120;
	bh=QAgLSewJZFccX3NcwGtj/VLiSP21lCVfi8MekQCS2i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0tcKLIbmzxjjupKCqAgTOK+iF/GKjReoXuLfgzFmXrbKgV+AGHmaa9ZirSQnbbYA
	 gGpbHPJhuM6XPjp7BhOFSNRX0MruFuS7jE6NbqBWi/IROzooabOHsFvD6zaE8vYfkO
	 inOZXgbA9Hy1rJQfMTKvaJAJ1peLpwAG4GyelwliIwnsGeA3pb64D5JLqLrzRPESUy
	 mFGraOgFNsm8mFGwsyL5b42bG2tQaY08jMMUDbz+z11feDg/3fzsIjPxDkLc8F/Agg
	 gpb5nYljDjKwGqxO0HHdJB7tgSjN8FDPzlntWejJT94JB+YAij7m4TpU448XnWgYmK
	 cycF3Y4MD2bZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Jesse.zhang@amd.com,
	christian.koenig@amd.com,
	boyuan.zhang@amd.com,
	sunil.khatri@amd.com,
	mario.limonciello@amd.com,
	pierre-eric.pelloux-prayer@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu/vpe: cancel delayed work in hw_fini
Date: Sat, 25 Oct 2025 11:57:17 -0400
Message-ID: <20251025160905.3857885-206-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ec813f384b1a9df332e86ff46c422e5d2d00217f ]

We need to cancel any outstanding work at both suspend
and driver teardown. Move the cancel to hw_fini which
gets called in both cases.

Reviewed-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: Prevents a race/UAF by ensuring the VPE idle delayed
  work is canceled during both suspend and full driver teardown. The
  idle work is initialized and used for power-gating idling
  (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:355) and is scheduled in
  normal operation (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:873) and can
  reschedule itself (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:336).
  Without canceling it on teardown, it may run after the ring is stopped
  or while/after resources are being freed.

- Change details:
  - Added cancellation in teardown path:
    `cancel_delayed_work_sync(&adev->vpe.idle_work);` in `vpe_hw_fini()`
    so it runs on both suspend and teardown
    (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:439).
  - Simplified suspend path to delegate to `vpe_hw_fini()`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:449–451), ensuring the same
    cancel happens on suspend.
  - The IP block ops confirm suspend and hw_fini are the hooks used by
    both flows (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:978–981).

- Why it matters: The idle work handler toggles power gating
  (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:333–336). If it remains
  queued while the ring is being stopped
  (drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:441) or while memory is being
  torn down in `sw_fini()`, it can touch freed objects or hardware in an
  invalid state. Moving the cancel to `hw_fini()` guarantees it runs
  before ring stop and power gating, and before subsequent teardown.

- Scope and risk:
  - Small, contained change in a single driver file; no API or
    architectural change.
  - Uses standard `cancel_delayed_work_sync`, which safely flushes and
    prevents requeue.
  - Consistent with existing practice elsewhere in amdgpu (e.g.,
    cancellation when starting to use the ring:
    drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c:849).
  - Low regression risk; only affects teardown/suspend sequencing of a
    driver-local delayed work.

- Stable backport fit:
  - Fixes a real race that can cause crashes during suspend/unload
    (user-visible reliability issue).
  - Minimal and targeted; no new features.
  - Touches a non-core subsystem (amdgpu VPE), keeping risk bounded.

Conclusion: This is a clear, low-risk bug fix that aligns with stable
rules and should be backported.

 drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
index 121ee17b522bd..dcdb2654ceb4a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
@@ -435,6 +435,8 @@ static int vpe_hw_fini(struct amdgpu_ip_block *ip_block)
 	struct amdgpu_device *adev = ip_block->adev;
 	struct amdgpu_vpe *vpe = &adev->vpe;
 
+	cancel_delayed_work_sync(&adev->vpe.idle_work);
+
 	vpe_ring_stop(vpe);
 
 	/* Power off VPE */
@@ -445,10 +447,6 @@ static int vpe_hw_fini(struct amdgpu_ip_block *ip_block)
 
 static int vpe_suspend(struct amdgpu_ip_block *ip_block)
 {
-	struct amdgpu_device *adev = ip_block->adev;
-
-	cancel_delayed_work_sync(&adev->vpe.idle_work);
-
 	return vpe_hw_fini(ip_block);
 }
 
-- 
2.51.0

