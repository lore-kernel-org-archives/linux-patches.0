Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9E933BDBD;
	Sun,  1 Jun 2025 23:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821549; cv=none; b=lbNTLW/YjodBbWriXgb8kQMpY/b3gIfgUpKddlTjFWKr8UOXQBwE2QtgI+FjRYM+SqlFU0Gc4jseSYxc7vDfHOehoCeK58PSn5BV2UpLsnEh/xPNWQtMEEzs1akzX8AQbXMWegYX2WQraUlu2T4kxTJu7dsradml9i5cKUd3tpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821549; c=relaxed/simple;
	bh=kaRS+thfbWsbHgKDlRuu7IgElG+Mlu450mcUwAr6iKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aerr3PLs4R9Dq+XrH1Q5e/nzIK8nn48SlFfJSWHr7uzNT7UTXk6u8jFT9aAkgQapFniJIEN+1dTCc18tLM5G6QiKFCH4yQmLXrcLo26nOhYNU9SFq2TnYR263ngIQug6dDSkBIlw+KurEAzICijAFIF7hla7z40By/+y4Ako1VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGdO2AJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGdO2AJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE99C4CEEE;
	Sun,  1 Jun 2025 23:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821548;
	bh=kaRS+thfbWsbHgKDlRuu7IgElG+Mlu450mcUwAr6iKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGdO2AJgxrB0t/jM7LyBN9WiQNYQA4mYRXzj4Y+6YA2Ef9Nd699MszvVYuSyiMDiX
	 gbDezrqtnB9M/O5Kj5N7Mxtgdyp40CMmcCxsoxaakxUwpsXEw5YO6WyuhS8/XfCEqR
	 kWjLqVHDMJikMjyjhSuh3X+MCoAxZveFPuVqbNqGILHSI1mfom+/bXFbUvG2P5VVQs
	 LEi1wQhvF/ppOP26+5xrKVcUmRcWV07InzQzl3KZwk30mSm8InhiGd+2X7Eavi7L6u
	 /oqmjvb6xOVutF3/Fm7Jq3KzMtYhBXr2/9eTCWpPBWcphmx0Loqjq5xm3cLqZ8obJy
	 FUVmjN1KzmHUA==
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
	vitaly.prosyak@amd.com,
	srinivasan.shanmugam@amd.com,
	Jiadong.Zhu@amd.com,
	kevinyang.wang@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/22] drm/amdgpu/gfx9: fix CSIB handling
Date: Sun,  1 Jun 2025 19:45:03 -0400
Message-Id: <20250601234515.3519309-12-sashal@kernel.org>
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

[ Upstream commit a4a4c0ae6742ec7d6bf1548d2c6828de440814a0 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now I'll analyze the specific code changes and provide my backport
recommendation: **YES** This commit should be backported to stable
kernel trees. Here's my detailed analysis: ## Code Analysis The commit
fixes a logic bug in the `gfx_v9_0_get_csb_buffer()` function that
builds GPU command buffers for AMD GFX9 hardware. Looking at the code
change: **Before:** ```c if (sect->id == SECT_CONTEXT) { buffer[count++]
= cpu_to_le32(PACKET3(PACKET3_SET_CONTEXT_REG, ext->reg_count));
buffer[count++] = cpu_to_le32(ext->reg_index -
PACKET3_SET_CONTEXT_REG_START); for (i = 0; i < ext->reg_count; i++)
buffer[count++] = cpu_to_le32(ext->extent[i]); } else { return; // ←
BUGGY early return } ``` **After:** ```c if (sect->id == SECT_CONTEXT) {
buffer[count++] = cpu_to_le32(PACKET3(PACKET3_SET_CONTEXT_REG,
ext->reg_count)); buffer[count++] = cpu_to_le32(ext->reg_index -
PACKET3_SET_CONTEXT_REG_START); for (i = 0; i < ext->reg_count; i++)
buffer[count++] = cpu_to_le32(ext->extent[i]); } // ← Early return
removed, execution continues ``` ## Why This Should Be Backported ### 1.
**Fixes a Clear Logic Bug** The early return prevents the function from
completing its work. After the loop, the function needs to write
critical termination packets: ```c buffer[count++] =
cpu_to_le32(PACKET3(PACKET3_PREAMBLE_CNTL, 0)); buffer[count++] =
cpu_to_le32(PACKET3_PREAMBLE_END_CLEAR_STATE); buffer[count++] =
cpu_to_le32(PACKET3(PACKET3_CLEAR_STATE, 0)); buffer[count++] =
cpu_to_le32(0); ``` ### 2. **Meets Stable Tree Criteria** - **Small and
contained**: Simple one-line removal with clear intent - **Low
regression risk**: Removing early return allows proper completion -
**Important bug fix**: Prevents GPU command buffer corruption - **No
architectural changes**: Pure bug fix without new features ### 3.
**Comparison with Historical Examples** Looking at the provided
historical commits, this fix is similar to commit #3 (marked YES) which
also fixed preamble handling. Both commits: - Fix logic bugs in AMD GPU
driver - Have minimal code changes - Address proper command/state
handling - Are critical for correct driver operation ### 4. **Stability
Impact** While currently masked because all existing clear state data
only uses `SECT_CONTEXT` sections, this bug creates: - **Buffer
corruption risk**: Incomplete command buffers sent to GPU - **Forward
compatibility issues**: Future hardware might use other section types -
**Inconsistent state**: Size calculation function has same bug pattern
### 5. **Hardware Criticality** This affects the GFX9 generation which
includes widely deployed GPUs like: - Vega series (RX Vega 56/64) -
Raven Ridge APUs (Ryzen 2000G/3000G series) - Renoir APUs (Ryzen 4000
series) ### 6. **Clear Commit Message** The commit message explicitly
states "We need to update the rest of the CSIB" - indicating this fixes
incomplete processing, exactly what stable backports target.
**Conclusion**: This is a textbook stable backport candidate - a small,
contained fix for a clear logic bug in a critical GPU initialization
path that could lead to hardware instability. The risk/reward ratio
strongly favors backporting.

 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 4eba6b2d9cdec..3e2fe8f2ccae3 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1472,8 +1472,6 @@ static void gfx_v9_0_get_csb_buffer(struct amdgpu_device *adev,
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

