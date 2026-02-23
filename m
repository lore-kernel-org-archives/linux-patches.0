Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187B36923C;
	Mon, 23 Feb 2026 12:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850294; cv=none; b=k6sWT5rQLVUIUB/oXHvCKcy2+E0lBjJKJeviyjkz5M25CUdoERQUiTVS2hS9Wb+odrTMUu2HekXL9LwbJsAA1s8JxnyD6bAqnT3uVU0liYEaVcV16VvQdEO/YRJv3rBQM9ilp802Rgoauh8Uh/AGTTv0cDQ3dYDTzHT0kuIssIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850294; c=relaxed/simple;
	bh=xcY3l/8COfPuaTeSpHCsQ4ZAHRp7isNRAnvmtk1jgYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bCBfXbQWGqH0rKtVCm++u5uPWKZNrjJRa+M7wHpsOElOFktFYJPikuibshBCEMBT8ybTf/M+x78fUB4mmjqh/9J7ZuaQHSb1suIDuoET9GW36PJY535w1MGEwyXBMCaf98uqFF1fWknVoAEMmJ8B96Fs0Z9ShATcLL6liOs6Exc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/A9Vi6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/A9Vi6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029CDC19424;
	Mon, 23 Feb 2026 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850294;
	bh=xcY3l/8COfPuaTeSpHCsQ4ZAHRp7isNRAnvmtk1jgYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/A9Vi6Ec/X/9SVwamVz3wZGv3pxdxI42K4iek1SpF6QJYwfUlQn9uSDhDSU458vH
	 9OedVfBrQKMAemFudfXVlHCaEB+Ma5QYQApjkNHsiI904cQ/2doZvzclFI0FgOjlmM
	 vuJRKsgI3PLP8L0J8M/SMsnuDX+kq7iUhgPVyK7qcVqtRzBizv9P5JoWr5ekHKOGiW
	 R2eQkEOSSTGPOiS7aCQHpsjTdWz1D5g2NDmA+sPwypnrzPeSNFGRw9o61R0s2py2R2
	 OJXM2ZlMkqyLrcryqCzRsta0+wHNq/Q6hSeEqgKiBX4OWaE23bM2UjbyT/YMq6rztJ
	 Yb2rENPbmJi+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wayne Lin <Wayne.Lin@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] drm/amd/display: Avoid updating surface with the same surface under MPO
Date: Mon, 23 Feb 2026 07:37:28 -0500
Message-ID: <20260223123738.1532940-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 1a38ded4bc8ac09fd029ec656b1e2c98cc0d238c ]

[Why & How]
Although it's dummy updates of surface update for committing stream
updates, we should not have dummy_updates[j].surface all indicating
to the same surface under multiple surfaces case. Otherwise,
copy_surface_update_to_plane() in update_planes_and_stream_state()
will update to the same surface only.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit fixes

This is a clear **indexing bug** in `amdgpu_dm_atomic_commit_tail()`. In
a loop iterating over `status->plane_count` planes:

```c
for (j = 0; j < status->plane_count; j++)
    dummy_updates[j].surface = status->plane_states[0];  // BUG: always
[0]
```

The fix changes `plane_states[0]` to `plane_states[j]`, so each dummy
update references its correct corresponding plane state instead of all
pointing to the first one.

### Bug impact

This bug affects **Multi-Plane Overlay (MPO)** scenarios where
`status->plane_count > 1`. When multiple planes are active:

1. **All dummy updates point to the same surface** -
   `copy_surface_update_to_plane()` processes the same plane repeatedly,
   ignoring other planes in the composition
2. **The sort by `layer_index` becomes meaningless** - all entries have
   the same layer_index since they reference the same plane
3. **`dc_update_planes_and_stream()` operates on incorrect data** -
   stream updates that should touch all planes only affect one

This causes incorrect display behavior under MPO, which is used for
hardware-accelerated video overlay, cursor planes, and compositing.

### Meets stable criteria

- **Obviously correct**: Classic `[0]` vs `[j]` indexing bug in a loop -
  the fix is a single character change
- **Fixes a real bug**: MPO plane updates are broken when multiple
  planes are active
- **Small and contained**: Single line change, zero risk of regression
- **No new features**: Pure bug fix
- **Reviewed and tested**: Has `Reviewed-by: Harry Wentland`, `Tested-
  by: Daniel Wheeler`

### Bug origin

The bug was introduced in commit `efc8278eecfd5` (Feb 2021) which was a
revert that restored older code containing this indexing error. The bug
has been present for ~5 years, affecting all stable trees that contain
this code path.

### Risk assessment

**Extremely low risk.** This is a one-character fix (`0` → `j`) that
corrects an obvious loop indexing mistake. There is no conceivable way
this change could cause a regression - the previous behavior (all
pointing to `plane_states[0]`) was simply wrong.

### Verification

- **Verified the buggy line exists** at `amdgpu_dm.c:10954` via Read
  tool - confirmed `plane_states[0]` in loop
- **Verified bug introduction**: `git log --no-walk efc8278eecfd5`
  confirmed it was a revert from Feb 2021 that restored the buggy code
- **Verified the fix commit**: `git show 1a38ded4bc8ac` confirmed Wayne
  Lin authored the fix, merged to master
- **Verified code flow**: The agent traced
  `dc_update_planes_and_stream()` → `update_planes_and_stream_state()` →
  `copy_surface_update_to_plane()` which iterates over each surface
  update, confirming that having all dummy_updates point to the same
  surface causes only one plane to be updated
- **Verified `dm_plane_layer_index_cmp()`** sorts by
  `surface->layer_index` - with all surfaces the same, sorting is a no-
  op (broken)
- **Verified the fix is in master** via `git branch -a --contains
  1a38ded4bc8ac`
- **Could not independently verify** user-reported display issues under
  MPO, but the code analysis clearly shows the bug mechanism

**YES**

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e004fc3893edf..7fae54e47292b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10961,7 +10961,7 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			continue;
 		}
 		for (j = 0; j < status->plane_count; j++)
-			dummy_updates[j].surface = status->plane_states[0];
+			dummy_updates[j].surface = status->plane_states[j];
 
 		sort(dummy_updates, status->plane_count,
 		     sizeof(*dummy_updates), dm_plane_layer_index_cmp, NULL);
-- 
2.51.0

