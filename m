Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23E729B794;
	Sun,  1 Jun 2025 23:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820852; cv=none; b=OzqujiI4i2YNwNgui2F7hbyXGBudCnL8jbjIwoLxlOYTsdNJqa1KfpQeRdwRIAtmXC4c8/n8svjZ9di1ka+1XqQjnvEYIK4aR5wFATkEYQV6s75S3vJL2VGBYuMslZpylKGN5Z4cikh8Ecp2bJhquLw1xPoBt0FtS3kHSyy0Buo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820852; c=relaxed/simple;
	bh=WBtWz338729X7c73XQLl33q8B9TDmNRhC+XpdvsV1D8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lRpDrdWEbN32CZT+JVe7qlmarlocPjBLTuvoBvEDLFccpHuOzxJpyzRdM0n4CTfH7sgymVSjGHd9Gun/SysxOaeYb+OaYW2RmFqqpZdL+AleMHoLCNdULgPBbZu/5qfYbXaOETCbW40ljuZh9PoJCXes4N2Im79ngOwddfKaYvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVlSpc7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVlSpc7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00227C4CEF1;
	Sun,  1 Jun 2025 23:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820852;
	bh=WBtWz338729X7c73XQLl33q8B9TDmNRhC+XpdvsV1D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVlSpc7ySgM7k4FeelWr42GztV4OmWkBAo2PlU+vVnoMYfVi2BW5GxnaMiePWjjZ2
	 beD+xsqeBPHAbfA2kX4HH5qa+oF8Z+A4Fw9N4kQLdabQMZNe6n3IlTeMDaL4ErN+BH
	 CXhkH8UXl4B1GARkjcKC+lwgZVtVQDUrGw4RkoefJCo1aM6sSojOh5EGJaYEJhYSC0
	 fa/nrlS7ZR2r/nkVBSx3Vw7+Pbft3eJgCU9CFsckFLavPaMMgWTARqjX6LTSw0ta2R
	 l7XRTUQNK1i1aNSNfykjR9faGXDZJvcOP5PUB++PDdc1DQw4PaUsacN7KSucbTA+1Q
	 /Wc/n8pFwR3IQ==
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
	alexandre.f.demers@gmail.com,
	boyuan.zhang@amd.com,
	kevinyang.wang@amd.com,
	mario.limonciello@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 03/93] drm/amdgpu/gfx6: fix CSIB handling
Date: Sun,  1 Jun 2025 19:32:30 -0400
Message-Id: <20250601233402.3512823-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 8307ebc15c1ea98a8a0b7837af1faa6c01514577 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me understand what the bug is. Looking at the original code:
```c for (sect = adev->gfx.rlc.cs_data; sect->section != NULL; ++sect) {
for (ext = sect->section; ext->extent != NULL; ++ext) { if (sect->id ==
SECT_CONTEXT) { // process SECT_CONTEXT sections } else { return; //
BUG: This returns early, skipping remaining code } } } // Important code
that should always run: buffer[count++] =
cpu_to_le32(PACKET3(PACKET3_SET_CONTEXT_REG, 1)); buffer[count++] =
cpu_to_le32(mmPA_SC_RASTER_CONFIG - PACKET3_SET_CONTEXT_REG_START); //
... more important buffer initialization ``` The fix removes the early
return so that all sections are processed and the important buffer
initialization at the end always runs. **YES** This commit should be
backported to stable kernel trees for the following reasons: 1. **Clear
Bug Fix**: The commit fixes a clear logic error where an early return
statement prevents critical buffer initialization code from executing.
The original code would return immediately when encountering a non-
SECT_CONTEXT section, skipping the important packet commands that should
always be written to the buffer (PACKET3_SET_CONTEXT_REG,
PACKET3_PREAMBLE_END_CLEAR_STATE, PACKET3_CLEAR_STATE). 2. **Functional
Impact**: This bug affects the Clear State Indirect Buffer (CSIB)
handling in AMD GPU driver for GFX6 hardware. The incomplete buffer
initialization could lead to: - Incorrect GPU state during graphics
operations - Potential rendering issues or GPU hangs - Inconsistent
hardware behavior 3. **Small and Contained Fix**: The fix is minimal -
it simply removes two lines (the else block with return statement). This
is a low-risk change that doesn't introduce new functionality or alter
the architecture. 4. **Hardware-Specific Bug**: This affects real users
with GFX6 AMD GPUs. The bug prevents proper initialization of the GPU's
clear state buffer, which is essential for correct GPU operation. 5.
**Similar to Historical Backports**: Looking at commit 4 in the similar
commits (marked as YES for backporting), which also fixed preamble
handling issues in the AMD GPU driver, this follows a similar pattern of
fixing command buffer handling bugs. The commit message clearly
indicates this is a bug fix ("We shouldn't return after the last
section. We need to update the rest of the CSIB"), and the code change
confirms that critical buffer initialization was being skipped due to
the premature return.

 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 564f0b9336b6a..00d3ce5a6eda6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2859,8 +2859,6 @@ static void gfx_v6_0_get_csb_buffer(struct amdgpu_device *adev,
 				buffer[count++] = cpu_to_le32(ext->reg_index - 0xa000);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5

