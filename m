Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A256233BDA2;
	Sun,  1 Jun 2025 23:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821545; cv=none; b=P880Gbvu1MAGrQ2v8tCxE2OKfyaw8FDuOLj/VdO9yO1mh8Qa6AEeXsRX9jfZLwEYnzWvqcHpogQOqEzmcha4ancTVdn2/vraTR/HZ1MAtd6sb3mUnK+lqbp4SGJkZKhEAV6mM0SB2gacWVciDYRrrBazZilPWNzEBXYlbSupGIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821545; c=relaxed/simple;
	bh=JYXwUulkZ0bX9p/Ea6mB6iXnAeNyjfRskRSSI04G1LM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lf7Mo6h9mbedqs2LXhsrRypnFtS+gBIoMTfllZFJQGQ8DTF8HayUV38XquV5cEMvAZtD2xK/swtlhI7PI3dIgsRkM9X04be59Y5B8LZZFZUZV/4+8LOIAwbw8F9p7O2Us3S+sfoYHw11u8IZCw9mDLPZoO5xm6SDWzvd1mUnDeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hg7avQxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hg7avQxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBF0C4CEEE;
	Sun,  1 Jun 2025 23:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821545;
	bh=JYXwUulkZ0bX9p/Ea6mB6iXnAeNyjfRskRSSI04G1LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hg7avQxib0lXxgR8ghn4tFie6nnkBkO/9Te7shCy827NCEY/7/t4XCme7cGofYbnr
	 N2pednwTIksxKNyN+xmBoQMYjD+OR+QBFHx+AmD6hUvMVSFX1ma/vw7bSdgcfzKEqb
	 G9Sr1Bf854CJahD1yEwpspMPGUbIJgV+4F9X63jbSjiJg02ARd9J4ijMYVDCcNiVsx
	 rF4YCVoAOV5CH9HFP8ld8KQw54LIQJyh50SeqOuVvyYeicK/gkV/P+L08UoVO8qhdG
	 d/esgCF2fLLm/UE3G+4Fx6qbGcHQZEVypUcnzF1qz7M4GkwbGSNcsdk5E5RqURw7Lu
	 VwNUDDRUZJSfw==
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
	boyuan.zhang@amd.com,
	Prike.Liang@amd.com,
	kevinyang.wang@amd.com,
	mario.limonciello@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/22] drm/amdgpu/gfx8: fix CSIB handling
Date: Sun,  1 Jun 2025 19:45:02 -0400
Message-Id: <20250601234515.3519309-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234515.3519309-1-sashal@kernel.org>
References: <20250601234515.3519309-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c8b8d7a4f1c5cdfbd61d75302fb3e3cdefb1a7ab ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Extensive Analysis:** **1. Critical Bug Nature:** The code changes fix
a serious logic error in the CSIB (Clear State Indirect Buffer) handling
for AMD GFX8 hardware. The bug occurs in `gfx_v8_0_get_csb_buffer()`
where there's an early `return` statement in the `else` branch at line
1252: ```c if (sect->id == SECT_CONTEXT) { // Handle SECT_CONTEXT
sections... } else { return; // BUG: Early exit prevents rest of buffer
setup! } ``` **2. Impact and Severity:** This bug has significant
functional impact because: - The function is responsible for setting up
the Clear State Buffer, which is critical for GPU state initialization -
When encountering any section that isn't `SECT_CONTEXT` (such as
`SECT_CLEAR`, `SECT_CTRLCONST`, or `SECT_NONE` as defined in
`clearstate_defs.h`), the function exits early - This prevents the
essential final buffer setup steps from executing: - PA_SC_RASTER_CONFIG
register setup (lines 1257-1261) - PACKET3_PREAMBLE_END_CLEAR_STATE
packet (lines 1263-1264) - PACKET3_CLEAR_STATE packet (lines 1266-1267)
**3. Real-World Consequences:** An incomplete CSB buffer can lead to: -
GPU initialization failures - Rendering corruption - System instability
- Potential hangs during graphics operations **4. Code Quality
Assessment:** - **Small and contained:** The fix removes only 2 lines of
problematic code - **No architectural changes:** Pure bug fix with no
design modifications - **Clear intent:** The commit message explicitly
states the problem and solution - **Low regression risk:** Removing an
early return cannot introduce new failures **5. Comparison with
Historical Examples:** This commit aligns perfectly with the "Backport
Status: YES" example (#4) which also fixed a critical handling issue in
AMD GPU code. Like that commit, this: - Fixes a clear functional bug -
Has immediate user impact - Is small and low-risk - Affects critical GPU
subsystem functionality **6. Stable Tree Compliance:** ✓ Fixes important
user-affecting bug ✓ Small, contained change ✓ No new features
introduced ✓ Critical hardware subsystem affected ✓ Clear regression
prevention The fix ensures that all necessary GPU state initialization
packets are properly written to the buffer, which is essential for
correct hardware operation on GFX8 hardware generations.

 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 467ed7fca884d..79347df0620d0 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1267,8 +1267,6 @@ static void gfx_v8_0_get_csb_buffer(struct amdgpu_device *adev,
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

