Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D412E62DE;
	Sun,  1 Jun 2025 23:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820988; cv=none; b=llkRyIJuuSH6nDCOGGzAAuoiQODOVQXAGIpDOTYNtXz0VlOpXphiUtRiHUCFnhAwRINpoKHIni3FbPTFZOrqBc1jYMRU5oPl8bKhTuG1v92Upv55L/mOa4o1eDvFu2JBQ3/+YYqwD2MfXxUxgJKhD5lLvSnQqYhdLA1VPLP13aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820988; c=relaxed/simple;
	bh=XdHPcloIJz9lRR4gMtP7+fMmnRlyGZpOB26JKWZkGZU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MNs3PgZtvAQCt+zIuTi4aNIVDvg6vYtvdLkJZvT6Avu4dr+povt4/kl8xug00VXsZptRe15eVtPrDI5Bk3lDAi8AcAbymFHg/FPkBCMBG1bByC8OJvF+l2vL/ustibodS0TCotV0Bpi5Ju8mT9rvpHB60BDXC2NJioGCliF2vUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fN9BDpdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fN9BDpdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770D9C4CEEE;
	Sun,  1 Jun 2025 23:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820988;
	bh=XdHPcloIJz9lRR4gMtP7+fMmnRlyGZpOB26JKWZkGZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fN9BDpdvBud4gfEwmXggEaMnsP+6N89AoTfLjjXOY5KcOcPEthodqfSTC6G0WCAMl
	 k7oGrxp9hRTOrD71uHM/bKgTloElEi257L6xbiccGS2TRvuVEn+hKx+vOaSe86DIvM
	 X8kjoXJ/hQl1BU2vjAEBYRXlpDqQF4r0CB1IJefNW+5ZLrU000JZfx0Niy3NFPi2pL
	 M/F5n6eK6BA1iGTU7WsC8IIkHdOAMyRVghPx4sYTpmbQzaEc089CciKIvzPFMH/Ivj
	 0eIFjewdbp3ssXe0Sx/Rg8ZBoAvqcpMp57xfNeph6tNEpK70stK3CRgTWOSzn5l/hD
	 j2+gFmHUzCWzg==
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
Subject: [PATCH AUTOSEL 6.12 54/93] drm/amdgpu/gfx9: fix CSIB handling
Date: Sun,  1 Jun 2025 19:33:21 -0400
Message-Id: <20250601233402.3512823-54-sashal@kernel.org>
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
index 114653a0b5701..2589ae021cba6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1639,8 +1639,6 @@ static void gfx_v9_0_get_csb_buffer(struct amdgpu_device *adev,
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

