Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F99F259CB3;
	Sun,  1 Jun 2025 23:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820587; cv=none; b=KPHiqMhUDRTiL95pcGz1Sa2tSIlJT37QrceP26IQYZ7B4DHA6KJ5CI0QzCsrE64TSJgo/Oy8pVde34EXbeQMAH4ilksZSOdQODfqbN+pMR5n25+taRU8n1OAQ/ebmOzW3F9lsWJqEsrTJl3mr45zi9/TNRgzNKERRN87c0bHYg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820587; c=relaxed/simple;
	bh=FIWt5jbaOyjdfg06fWdHAm4ewMsW/2Ts1PRGTSaLuB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EKrHFycBEQjRptO6n6vDkEH4PTD6pvCzSqhQGhbzjTwIl+EBNH10LgcxWBZrrtUkfiFXbyWbtM8LD18oHB0s6M1zWf1An5hQ6QnULiuWALzlU0SZKvPXTdVDpnsVMmDFXo1gG7hjv63XwgQKx9o0QhMD3YhRMEnw6fVrTP33yRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UO8ZHrg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UO8ZHrg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB35C4CEE7;
	Sun,  1 Jun 2025 23:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820586;
	bh=FIWt5jbaOyjdfg06fWdHAm4ewMsW/2Ts1PRGTSaLuB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UO8ZHrg2n1MIW+tB0fbibxQMX2vFptkCce1UydCLvTm3QRmjUT3JYvIoe1Xn8BWR1
	 vytibHboP9wt1s68oND/W0b4JSRrTjOF3t0of2WjT8DTVxDVd88kmrmg2QkqvAMTvr
	 1G42wrkm3xaI2ry55rTwzzp0P9nzGSpmXmRrHbXFR931i8DPY6lNHMqH9dTB02YRNt
	 tdqiuy7uVnIqQML6u6KnmXtA+NstEoDPukvks7BrsZNS77slQ3f1/whBrjNoUdFeTr
	 Rw2XxBeAs6ITQSXH/KYf+c397oLoUsciad3tIZsJxkbyN+DVw6BBFIXvtE2haSeTzJ
	 UNTR+QP+VbvaA==
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
Subject: [PATCH AUTOSEL 6.14 003/102] drm/amdgpu/gfx6: fix CSIB handling
Date: Sun,  1 Jun 2025 19:27:55 -0400
Message-Id: <20250601232937.3510379-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index f26e2cdec07a2..e181efd97fa74 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2863,8 +2863,6 @@ static void gfx_v6_0_get_csb_buffer(struct amdgpu_device *adev,
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

