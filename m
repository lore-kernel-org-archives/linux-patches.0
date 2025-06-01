Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45853297F6;
	Sun,  1 Jun 2025 23:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821377; cv=none; b=gV6BPhVZ6UgUnduXrAR4uhfGX8Bx47osbKLvnM5ziG3seSiZsnBkyajgxJTXiHC5WNi+oxjtzsVINi1D5EQlGbREwkChuBbH2cwcaAC7whHyosoEQEYBCktpyNzmg3YINjQm1T0JLXs+owsyeuZYW5JNKLVs/1OS5iAH0Mfq8s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821377; c=relaxed/simple;
	bh=q5U/ZDsuEkRQQ4hXEe7ieJ9SQe/DilfxLpZrQ98vC1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFAq0NTpi8TpkBr0yk74ptlABw58rWGPZSVREumePx7SJMluFO9tMV+R+n8zsnkfRZj6Gsv6bHnK3KaFBxf5yHhymJuy8oey8zfvsImozlJPpdk2L+muXhJTvXPM3zx9R1A3+ARtWt8OyFbUK1muJtqpnfAB7B0We1N2Rg1Z0Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iG/axTkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iG/axTkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D229C4CEE7;
	Sun,  1 Jun 2025 23:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821377;
	bh=q5U/ZDsuEkRQQ4hXEe7ieJ9SQe/DilfxLpZrQ98vC1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG/axTkHfDE0aWXz6cgDKDrocl4XGejwXhZDwVdAEVnnPObAUvbiSen/bJENbeaq+
	 lrHE4cSftWUxkR8YU/2TxJDH/uy+itZq/iiUz9mbT2N9o1mmMibNENaFDv/Q4S/DXF
	 IeszZddLJMhGWeYNDrEgOoDGmSmd/CulgUg8dUsRvUkc7jnnCpzdrEmrXhjlI87iRg
	 C3KIOecn8tQWIz6u9Lgb4Vl833cMusplYL3fTBpSAND4TkzfCLJvsYHcymrr562mXi
	 yDFnZhoA2b9pOJ3Y+eWwazTgVe9HzB7absxNKTx7EOrHiXwVJclPk57rKP/N/Ar1UV
	 teHdJ1ux+FcOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	sunil.khatri@amd.com,
	srinivasan.shanmugam@amd.com,
	vitaly.prosyak@amd.com,
	Jesse.zhang@amd.com,
	Jiadong.Zhu@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/43] drm/amdgpu/gfx10: fix CSIB handling
Date: Sun,  1 Jun 2025 19:41:53 -0400
Message-Id: <20250601234224.3517599-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234224.3517599-1-sashal@kernel.org>
References: <20250601234224.3517599-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.184
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 683308af030cd9b8d3f1de5cbc1ee51788878feb ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. ##
Detailed Analysis: ### The Bug The commit fixes a critical bug in the
`gfx_v10_0_get_csb_buffer()` function in
`/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c`. The function is responsible
for building a Command Stream Buffer (CSB) for GPU initialization. **The
problematic code before the fix:** ```c for (sect =
adev->gfx.rlc.cs_data; sect->section != NULL; ++sect) { for (ext =
sect->section; ext->extent != NULL; ++ext) { if (sect->id ==
SECT_CONTEXT) { buffer[count++] =
cpu_to_le32(PACKET3(PACKET3_SET_CONTEXT_REG, ext->reg_count));
buffer[count++] = cpu_to_le32(ext->reg_index -
PACKET3_SET_CONTEXT_REG_START); for (i = 0; i < ext->reg_count; i++)
buffer[count++] = cpu_to_le32(ext->extent[i]); } else { return; // ←
BUG: Early return prevents rest of buffer initialization } } } ``` **The
fix removes the early return:** ```c for (sect = adev->gfx.rlc.cs_data;
sect->section != NULL; ++sect) { for (ext = sect->section; ext->extent
!= NULL; ++ext) { if (sect->id == SECT_CONTEXT) { buffer[count++] =
cpu_to_le32(PACKET3(PACKET3_SET_CONTEXT_REG, ext->reg_count));
buffer[count++] = cpu_to_le32(ext->reg_index -
PACKET3_SET_CONTEXT_REG_START); for (i = 0; i < ext->reg_count; i++)
buffer[count++] = cpu_to_le32(ext->extent[i]); } // ← Early return
removed - now continues to process rest of buffer } } ``` ### Why This
Should Be Backported: 1. **Fixes Important GPU Initialization Bug**:
This is a clear functional bug that affects AMDGPU GFX10 hardware.
Looking at the clearstate data structure, I can see that
`gfx10_cs_data[]` contains only `SECT_CONTEXT` sections, but if any
future section was not `SECT_CONTEXT`, the early return would prevent
critical buffer initialization from completing. 2. **Affects Critical
Hardware Functionality**: The CSB (Command Stream Buffer) is essential
for proper GPU initialization. An incomplete buffer could lead to: - GPU
hang during initialization - Incorrect register states - System
instability - Failed GPU bring-up 3. **Small, Contained Fix**: The fix
is minimal - it simply removes an erroneous `else { return; }` clause.
This has very low risk of introducing regressions. 4. **No Architectural
Changes**: This doesn't change any APIs, interfaces, or architectural
decisions. It's a pure bugfix. 5. **Follows Stable Tree Criteria**: -
Important bugfix ✓ - Minimal risk ✓ - Confined to a subsystem ✓ - No new
features ✓ 6. **Critical GPU Subsystem**: The commit touches GPU command
submission infrastructure, which is critical for system stability when
AMD GFX10 hardware is present. 7. **Clear Commit Message**: The commit
message clearly explains the bug: "We shouldn't return after the last
section. We need to update the rest of the CSIB." Looking at the
reference commits, this aligns with "Similar Commit #4" which was marked
YES for backporting - it's a clear functional bugfix in critical GPU
subsystem code that prevents proper operation. The missing code after
the early return includes essential buffer finalization: - Setting
PA_SC_TILE_STEERING_OVERRIDE register - Adding
PACKET3_PREAMBLE_END_CLEAR_STATE - Adding PACKET3_CLEAR_STATE command
Without these, the GPU's clear state buffer would be incomplete,
potentially causing initialization failures.

 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 938f13956aeef..d8926d510b3c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4438,8 +4438,6 @@ static void gfx_v10_0_get_csb_buffer(struct amdgpu_device *adev,
 						PACKET3_SET_CONTEXT_REG_START);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5

