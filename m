Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6EF365A02;
	Mon, 23 Feb 2026 12:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850268; cv=none; b=p7H4fChwE8y22hzDjiVtHSOFGxdjs/ORLKK44KqFP42hDSuZP+lYWaXZjLuDIAcl1/au+hQfl/oISA8yoNcm92ObGozOXNogtzhpw01os6+/G3Zx4QKboJ9KOAk1MnsIysMzNu+5Vl3SAEY+RkMvfcpnvYCnF4N1jKzJRMk+pKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850268; c=relaxed/simple;
	bh=ieO3IDaCxW655UojJOwVdh3Cqjs3Mef/DOUYYLZgQfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mj5P7aUaWneaFMd5AVJCtk0QuVBoEhgGynK0EaYA5ms2RjAfvMEVDY0DzDTNPV//W4Sv26h2LNLRRqvQdZYcZPb27WevDMuKeJ5K/kw/GS/BkltuvXpu2KI0BgEj7rwt2GRhFLTeR2g/YqfJhqZbMYDbdcQNHknAjLXhf2W+QAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGqkAMqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGqkAMqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C854C116D0;
	Mon, 23 Feb 2026 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850268;
	bh=ieO3IDaCxW655UojJOwVdh3Cqjs3Mef/DOUYYLZgQfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGqkAMqOuiB6v5WERJJ25jDW7mmx+7GSfSp3/2YybdIlEzVUW5V6AIRqtwMRxWcqO
	 YlJLSN+bO8LvxKT+NQ8RP4NXBUyr/NpwFjg0zqOWUs/UdTxW2B7a/7f/0UgYgdWIh8
	 XyUNEgcHe1AYzazA5aBIxIFzYem20IITCKLrQzXK7OIEoWorLp7rpJ5xoPfBbkY0p9
	 jSiLKVtsk/tKbLfR/xf4BoiHg1Yufh7vymI59xPV9FEz5N47hnn//JHAJFJXEFZgdo
	 84MQxiaiIjEkDTZ12dkfzCf65iCAMLKx/bpQqAfR/1fYz+fn/Y2f4jqNr28UyHAqC+
	 MRSYZu76UkpGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tom Chung <chiahsuan.chung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: Fix system resume lag issue
Date: Mon, 23 Feb 2026 07:37:11 -0500
Message-ID: <20260223123738.1532940-6-sashal@kernel.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit 64c94cd9be2e188ed07efeafa6a109bce638c967 ]

[Why]
System will try to apply idle power optimizations setting during
system resume. But system power state is still in D3 state, and
it will cause the idle power optimizations command not actually
to be sent to DMUB and cause some platforms to go into IPS.

[How]
Set power state to D0 first before calling the
dc_dmub_srv_apply_idle_power_optimizations(dm->dc, false)

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. Now I have all the information needed for my analysis.

---

## Analysis

### 1. Commit Message Analysis

The commit clearly describes a **system resume lag issue** on AMD
display platforms with IPS (Idle Power States) support. The commit is
structured with `[Why]` and `[How]` sections explaining the root cause
and fix:

- **Root Cause**: During system resume,
  `dc_dmub_srv_apply_idle_power_optimizations(dm->dc, false)` is called
  to disable idle power optimizations, but at that point the DMUB power
  state is still D3 (suspended). The DMUB firmware won't execute
  commands when in D3 state, so the idle power optimization disable
  command silently fails, causing some platforms to incorrectly enter
  IPS during resume.
- **Fix**: Set DMUB power state to D0 *before* calling the idle power
  optimizations command.

### 2. Code Change Analysis

The change is **+10 lines** in a single file. It adds:
1. `dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv,
   DC_ACPI_CM_POWER_STATE_D0)` — sets DMUB to active power state before
   sending commands
2. Mutex locking around the operation (`dm->dc_lock`) for the non-reset
   resume path
3. The `amdgpu_in_reset()` check for mutex matches the existing pattern
   in the reset path (which already holds the lock)

The fix is clearly correct: looking at line 3559 of the current code,
the normal (non-IPS-early) resume path already calls
`dc_dmub_srv_set_power_state(D0)` before other operations. The early IPS
block was simply missing this prerequisite call.

### 3. Bug Severity

This is a **real user-visible bug** — system resume lag/hang on AMD
platforms with IPS support (DCN35+ hardware, e.g., AMD Ryzen mobile
APUs). This affects:
- Laptop users doing S3/S4 suspend/resume
- The fix prevents displays from being stuck/lagging after system resume
- Tested-by Daniel Wheeler (AMD) confirms hardware validation

### 4. Scope and Risk

- **Very small**: Only 10 lines added to a single file
- **Surgically targeted**: Only affects the early IPS power optimization
  block in `dm_resume()`
- **Pattern consistent**: The fix follows the exact same pattern used in
  the GPU-reset resume path (line 3500) and the normal resume path (line
  3559), both of which already call `dc_dmub_srv_set_power_state(D0)`
  first
- **Well-reviewed**: Reviewed by Nicholas Kazlauskas (AMD display
  expert), Tested by Daniel Wheeler (AMD QA), Signed-off by Wayne Lin
  and Alex Deucher (AMD display maintainer)
- **Low regression risk**: Adding D0 power state before a command is
  purely correctional — the command already expected D0 state

### 5. Dependencies

- `dc_dmub_srv_set_power_state()` was introduced in commit
  `0f657938e4345` (v6.8)
- The buggy `dc_dmub_srv_apply_idle_power_optimizations()` call in
  `dm_resume` was added around v6.9
- The `dm->dc_lock` mutex has existed since the display manager was
  created
- **No missing dependencies** — all required functions exist in v6.9+
  stable trees

### 6. Stable Tree Applicability

The fix applies to kernels **v6.9+** where the IPS check in `dm_resume`
exists. The code is self-contained and should apply cleanly to recent
stable trees (6.12.y, 6.6.y may need checking for ips_support code).

### Verification

- Verified the exact diff via `git diff 64c94cd9be2e1^..64c94cd9be2e1`:
  confirms +10 line change, single file
- Verified `dc_dmub_srv_set_power_state()` implementation at
  `dc_dmub_srv.c:1572-1585`: simple power state setter, calls
  `dmub_srv_set_power_state()`
- Verified the function was introduced in commit `0f657938e4345` (first
  in v6.8-rc1) via `git tag --contains`
- Verified the buggy IPS check (`ips_support` +
  `apply_idle_power_optimizations` in `dm_resume`) was added around v6.9
  via `git tag --contains 60818ed76577c`
- Verified `dm->dc_lock` mutex exists at `amdgpu_dm.h:446`
- Verified the normal resume path already calls
  `dc_dmub_srv_set_power_state(D0)` at line 3559, confirming the fix
  follows the established pattern
- Verified the GPU-reset resume path also calls
  `dc_dmub_srv_set_power_state(D0)` at line 3500, same pattern
- Could NOT verify via lore.kernel.org whether there are known
  regressions from this fix (unverified, but low concern given AMD
  testing)

### Conclusion

This is a clear, well-tested bug fix for a real user-visible issue
(system resume lag/hang on AMD IPS-capable platforms). The fix is small
(+10 lines), surgical, follows established patterns in the same
function, has been reviewed and tested by AMD engineers, and has no
feature additions. It meets all stable kernel criteria.

**YES**

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a72394b05ab02..e004fc3893edf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3468,7 +3468,17 @@ static int dm_resume(struct amdgpu_ip_block *ip_block)
 	struct dc_commit_streams_params commit_params = {};
 
 	if (dm->dc->caps.ips_support) {
+		if (!amdgpu_in_reset(adev))
+			mutex_lock(&dm->dc_lock);
+
+		/* Need to set POWER_STATE_D0 first or it will not execute
+		 * idle_power_optimizations command to DMUB.
+		 */
+		dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D0);
 		dc_dmub_srv_apply_idle_power_optimizations(dm->dc, false);
+
+		if (!amdgpu_in_reset(adev))
+			mutex_unlock(&dm->dc_lock);
 	}
 
 	if (amdgpu_in_reset(adev)) {
-- 
2.51.0

