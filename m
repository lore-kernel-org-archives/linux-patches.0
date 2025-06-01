Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7195F281375;
	Sun,  1 Jun 2025 23:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821540; cv=none; b=NbIu/q3C0et+aClWmFdKVsZU5CJluF1wn9LWduIdBDml8uv2jhl9ENV4sGE5h7HuxWvUrpMJe7LPl0LT6YArm58vzv9Xjo39r6MJYY+jb9EkKty4U5wMKCYiwjuZBUltT/3P5xWhwhpW+L3ep2g+4R10k4HiL+5Zy3+W62QEuV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821540; c=relaxed/simple;
	bh=doljhQgNhfgNj44yPwB/qX7bRCOnF268hObvaGCt7eo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hs/blfI3K8OwRRPyT5JbgZLZmK/I/xQ1uzgsqAgIJHmRV2UKWYo3I72TBRgvAo7n2eeX+ODx+Z0f6pdauTlH/vHbABr3U9oQWXtcky6+OKEV46zkShKpWZcq8+MPHC9jECYsmJphk0tISYx/pnA5zpyrTGTq6T2rjpraE0lQ7x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARGmssAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARGmssAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB8AC4CEE7;
	Sun,  1 Jun 2025 23:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821540;
	bh=doljhQgNhfgNj44yPwB/qX7bRCOnF268hObvaGCt7eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARGmssAvDNGxRkGZ8vy7iKBlrP+oI0/RF1avLKHWmu6232XfLn2kDfzWPwIiI+mDT
	 Zzkp5A93HVm7BIOjqGazZi2oT+P6Zf+cwOLQRX1m/3HtQGKQe7HP2TTgacKgQ3F97z
	 xQVv7E3bER5K91jHtfjmFOeyEQSX3sREtoDIAwp4KZfPW9aploWTTYhfTv159LBv/2
	 Xewg94RlWTyJcA5NlJk0smTca/dwusS1s9EdrQhyqF/+r14FT+IMLV2ao0H8w3pFk2
	 FbKT2B6nruAql9fKzqfElG2AannxI8vYVxR+ntED3yBKvoUpag3+tjKSi/r+Hq07BK
	 xUVn8ApekLXMw==
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
	kevinyang.wang@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/22] drm/amdgpu/gfx7: fix CSIB handling
Date: Sun,  1 Jun 2025 19:45:00 -0400
Message-Id: <20250601234515.3519309-9-sashal@kernel.org>
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

[ Upstream commit be7652c23d833d1ab2c67b16e173b1a4e69d1ae6 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Bug Analysis The commit fixes a critical bug in
the `gfx_v7_0_get_csb_buffer()` function in
`/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c`. The bug is on lines 3909-3911
where the function has: ```c } else { return; // BUG: Early return
prevents completion of CSB buffer } ``` The fix removes the early
`return` statement, changing it to: ```c } ``` ## What the Bug Does 1.
**CSB (Clear State Buffer)** is a critical GPU initialization buffer
that contains register programming sequences needed to properly
initialize the graphics hardware on GFX7 generation AMD GPUs (Bonaire,
Kaveri, Kabini, Mullins, Hawaii). 2. **The Bug**: When iterating through
clear state sections, if the function encounters any section that is NOT
`SECT_CONTEXT`, it immediately returns, **preventing the completion of
the CSB buffer initialization**. 3. **Missing Critical Code**: After the
early return, the function skips: - Setting `PA_SC_RASTER_CONFIG`
register (lines 3915-3939) - critical for rasterization configuration -
Adding `PACKET3_PREAMBLE_END_CLEAR_STATE` (lines 3941-3942) - proper
command stream termination - Adding `PACKET3_CLEAR_STATE` command (lines
3944-3945) - final clear state execution ## Impact Assessment This is a
**hardware initialization bug** that affects: - **Affected Hardware**:
All GFX7 AMD GPUs (Bonaire, Kaveri, Kabini, Mullins, Hawaii chips) -
**Scope**: Fundamental GPU initialization during driver load -
**Symptoms**: Incomplete GPU state initialization, potential rendering
issues, GPU hangs, or system instability ## Why This Should Be
Backported 1. **Fixes Important Hardware Bug**: This addresses a
fundamental hardware initialization issue that can cause GPU
malfunction. 2. **Small, Contained Fix**: The change is minimal
(removing 2 lines) with no architectural implications. 3. **Clear Bug
with Clear Fix**: The commit message explains exactly what's wrong ("We
shouldn't return after the last section. We need to update the rest of
the CSIB"). 4. **Critical Subsystem**: GPU initialization is a critical
path that must work correctly for stable system operation. 5. **Matches
Stable Criteria**: - Important bugfix ✓ - Minimal risk ✓ - Small change
✓ - No new features ✓ - Confined to one subsystem ✓ 6. **Historical
Pattern**: Looking at the provided similar commits, the fix pattern
matches "Similar Commit #4" which was marked as "Backport Status: YES" -
it fixes a functional bug in AMDGPU command submission handling. 7.
**User Impact**: Users with GFX7 AMD hardware could experience graphics
instability or initialization failures due to incomplete CSB
programming. The fix ensures that the CSB buffer is properly completed
with all necessary register programming and command stream termination,
which is essential for stable GPU operation.

 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
index d92e92e5d50b7..c1c3fb4d283d7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -3992,8 +3992,6 @@ static void gfx_v7_0_get_csb_buffer(struct amdgpu_device *adev,
 				buffer[count++] = cpu_to_le32(ext->reg_index - PACKET3_SET_CONTEXT_REG_START);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5

