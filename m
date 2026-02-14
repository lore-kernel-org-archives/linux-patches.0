Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64752556E;
	Sat, 14 Feb 2026 01:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031186; cv=none; b=E6M2z+ZO7yhqJZFUzgG8yoY+YnmLgJIs4ZAatsomznyquh3dUtFkT07kOOp+Il/w8/EXnjcmusfmUlO/jDxUw2lDWO8yzTZD8MhhU46P88a3uhzNd2kUw0TlyNFszv80axep8ZaCo/8jujteuGpczUamy2UQL2u1TBFQTH56S+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031186; c=relaxed/simple;
	bh=0/dUukDbcasXbbwNQEi+L+H01WipmI+LdZZN9UXXPZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqS6TLZLaSyxGR7BiGBmc4q+2BzziGwm8YIEgcAHgtS17I9fWteuaaRbQ/GpJ+xsrfpGFAxXKklckB67njgeLbIOUQ2pcedILjLTVVjPjreJ6U4Imn6lJ49D/GfPsOLtpF2D6w6VSR9x1NKr7HRJi7qKIdiA929rBpYmAScEpZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aky3pi53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aky3pi53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D84BC16AAE;
	Sat, 14 Feb 2026 01:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031186;
	bh=0/dUukDbcasXbbwNQEi+L+H01WipmI+LdZZN9UXXPZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aky3pi53iK4ZOP8yl8HFs/33BIJc18Wf2+TdUM1DI1tIPHUFEdcblJkjywE0+OZIb
	 UHXqI7/R15mfCfC5UiVwaOsPSu7Ilhz0lHToGJVP/asMp61Dd/4mPrhSKXJjrcx5yQ
	 cSR97JXQvKU6vZb0r2imKRmcC/MNQ57f3t3zFYDluBaoTWX6vCPh35myGFao8PZNUa
	 3Yp7o6tsvYJrU5dBmV7CM3xNj+uHWyDhPxHqpJqGPXYIIWuKK/6O9EFFPUUcacXZ0f
	 Rgst4ZqJLtxkE9diEQumsUuZBBXGi5UWdENpAr/Wfx+nNkKdtOY6k6Hp6TKhlPhIAD
	 k7hXdRsofdeGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Jesse.Zhang" <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunil.khatri@amd.com,
	Prike.Liang@amd.com,
	shashank.sharma@amd.com
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amdgpu: validate user queue size constraints
Date: Fri, 13 Feb 2026 19:59:33 -0500
Message-ID: <20260214010245.3671907-93-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit 8079b87c02e531cc91601f72ea8336dd2262fdf1 ]

Add validation to ensure user queue sizes meet hardware requirements:
- Size must be a power of two for efficient ring buffer wrapping
- Size must be at least AMDGPU_GPU_PAGE_SIZE to prevent undersized allocations

This prevents invalid configurations that could lead to GPU faults or
unexpected behavior.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So the user queue file was first introduced in v6.16. The current
mainline is v6.19. This means:

- **Stable trees v6.16.y, v6.17.y, v6.18.y** would have this code and
  could benefit from the fix
- **Older stable trees (v6.12.y, v6.6.y, v6.1.y, 5.15.y)** do NOT have
  user queues at all - the fix is irrelevant there

### 5. Classification

This is **input validation on a userspace-facing ioctl**. The
`amdgpu_userq_input_args_validate` function validates parameters from a
DRM ioctl (`AMDGPU_USERQ_OP_CREATE`). Without these checks:

- A user (even unprivileged with GPU access) could pass a non-power-of-2
  queue size, leading to GPU faults or misbehavior
- A user could pass a too-small queue size, leading to undersized
  allocations

This is a **security/robustness fix at a system boundary** (userspace →
kernel).

### 6. Risk Assessment

**Risk: Very Low**
- The change adds two simple, early-return validation checks
- It only rejects invalid input earlier (with -EINVAL)
- No existing valid usage is affected (any sane userspace already passes
  power-of-2, page-aligned sizes)
- The fix is small (10 lines of added code), self-contained, and
  obviously correct
- Reviewed by Christian König (key AMD DRM maintainer)

**Benefit: Medium**
- Prevents GPU faults from invalid configurations
- Prevents potential memory corruption or undefined hardware behavior
- Hardens the userspace-to-kernel boundary

### 7. Concerns

1. **Limited stable tree applicability**: Only applies to v6.16+ stable
   trees (newest stable branches). Older LTS trees don't have user
   queues.
2. **The `amdgpu_userq_input_args_validate` function may have evolved**
   between kernel versions, so the patch may not apply cleanly to 6.16.y
   or 6.17.y without adjustment.
3. **Dependency check**: The function `is_power_of_2()` is a standard
   kernel utility (from `<linux/log2.h>`), available in all kernel
   versions. `AMDGPU_GPU_PAGE_SIZE` is defined in amdgpu headers. No
   dependency issues.

### 8. Decision

**For:**
- Validates user input at a system boundary - this is the definition of
  a good stable fix
- Prevents GPU faults and undefined behavior from malformed userspace
  requests
- Small, surgical, obviously correct change
- Reviewed by subsystem maintainer
- Zero risk of regression (only rejects previously-invalid input)

**Against:**
- Only applicable to very recent stable trees (v6.16+)
- The commit message describes it somewhat as "adding validation" rather
  than "fixing a bug" - but this IS a bug fix (missing input validation
  on a userspace interface)
- The user queue feature itself is quite new, so the number of affected
  users is limited
- No reported real-world incidents (no "Reported-by:" tag, no syzbot
  report)

This is a borderline case. It's a legitimate input validation fix at a
userspace boundary that prevents GPU faults. However, the user queue
feature is very new (v6.16+), limiting the stable trees it applies to.
The fix is obviously correct and zero-risk, but there's no evidence of
real-world impact. The fact that it prevents potential GPU faults from
user-controllable input (security hardening) tips it slightly toward
YES, but the newness of the feature and the purely preventive nature (no
demonstrated real-world bug) is a concern.

On balance, this is a valid input validation fix that prevents potential
GPU faults from invalid userspace input. It's small, safe, reviewed by
the subsystem maintainer, and fixes a real missing-validation bug at a
trust boundary.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 58b26c78b6425..ab934723579c9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -860,6 +860,17 @@ static int amdgpu_userq_input_args_validate(struct drm_device *dev,
 			drm_file_err(filp, "invalidate userq queue va or size\n");
 			return -EINVAL;
 		}
+
+		if (!is_power_of_2(args->in.queue_size)) {
+			drm_file_err(filp, "Queue size must be a power of 2\n");
+			return -EINVAL;
+		}
+
+		if (args->in.queue_size < AMDGPU_GPU_PAGE_SIZE) {
+			drm_file_err(filp, "Queue size smaller than AMDGPU_GPU_PAGE_SIZE\n");
+			return -EINVAL;
+		}
+
 		if (!args->in.wptr_va || !args->in.rptr_va) {
 			drm_file_err(filp, "invalidate userq queue rptr or wptr\n");
 			return -EINVAL;
-- 
2.51.0

