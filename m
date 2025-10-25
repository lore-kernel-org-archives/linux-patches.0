Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D1305E2D;
	Sat, 25 Oct 2025 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409245; cv=none; b=SVcGuI8WOdB7CCUuruCXoOjJ9RAG9gKD5N5ULsUirn9NYfhzMPUTQgu1MQVuwKonpQixRSYXlvcBRZA/d/sNSvUbS2bnI1QXnUN7okjvbjhvnRI6Iqnl4JfIw29fSPW6szM6VNPrOw5irc5eKBBp4AFxle7DkJP6ZM5gqlGRsyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409245; c=relaxed/simple;
	bh=q1Sj6z6gPXann/sR4cPaaJGBRDjpjxQSHuADIOQv6tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YsEexVykRv63yb2fLwnFuobg2EL6Pjzu4HJLjLep+KAB25yfPXiV+aL8wq+wX16kVnlMX3m+Sbz382trbgXDYcZvIZO9Jp36PJvdJLvNCyqzyJoj2LSHSt9XdH5P0e9W1ujbgkXKK4t5to+g9HT59QXCODq1GWGh+Qgmud7mzzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IovbZWRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IovbZWRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE6EC4CEF5;
	Sat, 25 Oct 2025 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409244;
	bh=q1Sj6z6gPXann/sR4cPaaJGBRDjpjxQSHuADIOQv6tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IovbZWRZp4kgVGPMaFrMCAI9j8XPBr1h6xeHGxDCMIsrboM90OMd3GbaawmoxYDbM
	 hYGcADFp4y1SZcORwdUJ9y+EMIQ0l0j4r5lsb2NoUnuhWYIjfNyfK93vA//3iAASuW
	 2B7NYKS9ozCVrtToVhtOsRku1sIIcgYm1oXnkz7KPotgOG+RN6qnB0pQg0qT/bG8uU
	 dtMx3H+6OMJ1UAuWotORuRuypbj4BNwJS19ewDBWHv7VNBqXiFrIUazkpvB6IJfCf6
	 X3v+Lhfo2xbZeqbY04enEJxH0vGZeqPh1HqPIxY/kHcHU6a53UtubosZ9XO5xLLqyW
	 WGo/+YfO9VMMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Jesse.Zhang@amd.com,
	lijo.lazar@amd.com,
	alexandre.f.demers@gmail.com,
	pierre-eric.pelloux-prayer@amd.com,
	advaitdhamorikar@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.10] drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff
Date: Sat, 25 Oct 2025 11:58:06 -0400
Message-ID: <20251025160905.3857885-255-sashal@kernel.org>
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

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit 0e7581eda8c76d1ca4cf519631a4d4eb9f82b94c ]

Acquire jpeg_pg_lock before changes to jpeg power state
and release it after power off from idle work handler.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The idle path gated JPEG power without holding the JPEG power-gating
    mutex, while the active path already ungated under that mutex. This
    asymmetry creates a race between idle gating and new work starting,
    risking incorrect hardware state.
  - In `drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c:121`, the idle worker
    currently gates power via
    `amdgpu_device_ip_set_powergating_state(..., AMD_PG_STATE_GATE)`
    without any lock. The commit wraps this call with
    `mutex_lock(&adev->jpeg.jpeg_pg_lock)`/`mutex_unlock(...)`, making
    it consistent with the active path.
  - The active path already uses the same lock when ungating:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c:134` (lock),
    `amdgpu_jpeg.c:135-136` (UNGATE), `amdgpu_jpeg.c:137` (unlock). The
    commit brings the idle gating path to the same locking discipline.

- Why the race matters
  - JPEG IP set_powergating handlers update a shared state
    (`adev->jpeg.cur_state`) without internal locking and short-circuit
    based on it:
    - See `drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c:661` (return early if
      desired state equals `cur_state`) and `jpeg_v4_0.c:670` (write
      `cur_state` after a successful transition). Other JPEG versions
      follow the same pattern.
  - Without synchronization, idle gating and active ungating can
    interleave such that:
    - One thread may read an outdated `cur_state` and skip a necessary
      transition.
    - Another may update `cur_state` last, leaving the software view
      mismatched with actual hardware state.
  - Practical impact includes power-gating the JPEG block while it’s
    about to be used or is in use, leading to decode failures, ring
    stalls/timeouts, or sporadic hangs when work arrives near idle
    transitions.

- Scope and risk
  - Small, contained change in a single file (`amdgpu_jpeg.c`) affecting
    only the JPEG idle work handler and using an already-present mutex
    (`amdgpu_jpeg.c:42` initializes `jpeg_pg_lock`).
  - No API or architectural changes; just adds the missing lock/unlock
    in the idle gating path.
  - Workqueue context is safe for `mutex_lock`. The active path cancels
    the idle work (`cancel_delayed_work_sync`) before taking the same
    mutex, minimizing contention and avoiding deadlocks.

- Stable/backport criteria
  - Fixes a real race condition that can affect end users (sporadic JPEG
    decode malfunctions when idle gating collides with new submissions).
  - Minimal and low risk; aligns two code paths to the same locking
    policy.
  - No feature additions or broad refactoring.
  - Although the commit message lacks Fixes/Cc stable tags, it is a
    clear correctness fix in a driver subsystem and fits stable policy.

Conclusion: This is an important, low-risk race fix in the AMDGPU JPEG
power management path. It should be backported to stable.

 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
index 82d58ac7afb01..5d5e9ee83a5d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
@@ -121,10 +121,12 @@ static void amdgpu_jpeg_idle_work_handler(struct work_struct *work)
 			fences += amdgpu_fence_count_emitted(&adev->jpeg.inst[i].ring_dec[j]);
 	}
 
-	if (!fences && !atomic_read(&adev->jpeg.total_submission_cnt))
+	if (!fences && !atomic_read(&adev->jpeg.total_submission_cnt)) {
+		mutex_lock(&adev->jpeg.jpeg_pg_lock);
 		amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_JPEG,
 						       AMD_PG_STATE_GATE);
-	else
+		mutex_unlock(&adev->jpeg.jpeg_pg_lock);
+	} else
 		schedule_delayed_work(&adev->jpeg.idle_work, JPEG_IDLE_TIMEOUT);
 }
 
-- 
2.51.0

