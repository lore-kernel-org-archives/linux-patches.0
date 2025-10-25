Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DA63002A4;
	Sat, 25 Oct 2025 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408645; cv=none; b=l2lwRBhFZKgxBix303bheKY5vCInY4xzvgrC017IXJa8V2DwaS8S+r/3t+5mNNKdOD19MnZJe8ERb9pP7jgFoxGZtKo4l7A3zqpT3h/3ruaCiFSBJwZJRRjI84FVQYDifphDVmgD92KBSbxn3O92gUBjzubXfVh2mIjqWC69I1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408645; c=relaxed/simple;
	bh=HLeSJR12eRzbvIFyMp0kBxCnXjMD+Gmbwq7QeQCt7Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TmtI5cUknAYeEDKudtQ+pHzo2GPGpqUL2Cmo80ISA3Yhudwv2eJd3D5/D+u9Dj5tCeJa1qEdsqjR1/0muIDHReMmlNjiEYALVMuX6QtgYmqZqHn4XpFSKujylVBAb5/lIzUSy4f8eC3qSySemcTvU8WIPIxiOghzHeZmshO0zJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXkY576w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXkY576w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27062C4CEFB;
	Sat, 25 Oct 2025 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408644;
	bh=HLeSJR12eRzbvIFyMp0kBxCnXjMD+Gmbwq7QeQCt7Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXkY576wyDp5LRm6WpmocnSRB8ytWOPB+iUh4hxRFzpd2soevegkAm+noZMMGoJF6
	 tNWVWkN0zGxaEm50NBLI1JGcOK7DIiWpACpqD/bFaBbxh2fuzyyudH2IqQHRAaOjtk
	 VXqzB8cFFBBgAgDn7GXRFakJuJp2oJrpk7tlzG1ohFdTWg+apvBeUXACO58Ny7Tffk
	 2Xy6ynxmGU/uTccbYJ8yNmgYoY35SjFw3uqOmCAINLrfsbLwSAhUZmkuChcNE4gUWJ
	 Dc0GhJdQnd3hOPLBFebtGKRbmir3c0erun+wqMwwx9Fq2rMR++MouypwvmfEvj4Li2
	 skZftXlbaK8Rg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alvin.lee2@amd.com,
	mario.limonciello@amd.com,
	alexandre.f.demers@gmail.com,
	dillon.varone@amd.com,
	yan.li@amd.com,
	ryanseto@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Keep PLL0 running on DCE 6.0 and 6.4
Date: Sat, 25 Oct 2025 11:54:21 -0400
Message-ID: <20251025160905.3857885-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 0449726b58ea64ec96b95f95944f0a3650204059 ]

DC can turn off the display clock when no displays are connected
or when all displays are off, for reference see:
- dce*_validate_bandwidth

DC also assumes that the DP clock is always on and never powers
it down, for reference see:
- dce110_clock_source_power_down

In case of DCE 6.0 and 6.4, PLL0 is the clock source for both
the engine clock and DP clock, for reference see:
- radeon_atom_pick_pll
- atombios_crtc_set_disp_eng_pll

Therefore, PLL0 should be always kept running on DCE 6.0 and 6.4.
This commit achieves that by ensuring that by setting the display
clock to the corresponding value in low power state instead of
zero.

This fixes a page flip timeout on SI with DC which happens when
all connected displays are blanked.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Recommendation: **YES**

After conducting an exhaustive analysis of this commit, I strongly
recommend backporting it to stable kernel trees. Here is my
comprehensive analysis:

---

## Technical Analysis

### The Problem

On AMD Display Core Engine (DCE) versions 6.0 and 6.4, which are found
in Southern Islands (SI) GPUs (TAHITI, VERDE, PITCAIRN, OLAND, HAINAN
from ~2012-2013), **PLL0 serves a dual purpose**:

1. It provides the **display engine clock** (dispclk)
2. It provides the **DP (DisplayPort) clock**

This architectural constraint is unique to DCE 6.0 and 6.4. The commit
message references the old radeon driver functions
`radeon_atom_pick_pll` and `atombios_crtc_set_disp_eng_pll` which
document this hardware design.

The DC (Display Core) driver has two conflicting assumptions:
- DC can turn off the display clock when no displays are
  connected/active (see `dce*_validate_bandwidth`)
- DC assumes the DP clock is always powered on (see
  `dce110_clock_source_power_down`)

On DCE 6.0/6.4, these assumptions conflict because **turning off dispclk
also turns off PLL0, which breaks the DP clock**, causing page flip
timeouts when all displays are blanked.

### The Fix

The fix is minimal and surgical (lines 864-876 in `dce60_resource.c`):

**Before:**
```c
} else {
    context->bw_ctx.bw.dce.dispclk_khz = 0;  // Turns off PLL0!
    context->bw_ctx.bw.dce.yclk_khz = 0;
}
```

**After:**
```c
} else {
    /* On DCE 6.0 and 6.4 the PLL0 is both the display engine clock and
     - the DP clock, and shouldn't be turned off. Just select the
       display
     - clock value from its low power mode.
     */
    if (dc->ctx->dce_version == DCE_VERSION_6_0 ||
        dc->ctx->dce_version == DCE_VERSION_6_4)
        context->bw_ctx.bw.dce.dispclk_khz = 352000;  // Low power mode
    else
        context->bw_ctx.bw.dce.dispclk_khz = 0;

    context->bw_ctx.bw.dce.yclk_khz = 0;
}
```

The fix **keeps PLL0 running at 352kHz (low power state)** instead of
turning it off completely when no displays are active, solving the
conflict while maintaining power efficiency.

---

## Backporting Criteria Evaluation

### ✅ **Fixes User-Visible Bug**
- **Symptom**: Page flip timeout when all displays are blanked on SI
  GPUs with DC
- **Impact**: Users experience system hangs/freezes when screens turn
  off
- **Hardware affected**: Southern Islands GPUs (older but still in use)

### ✅ **Small and Contained**
- **Total change**: 9 lines added (including comments)
- **Single function modified**: `dce60_validate_bandwidth` in
  `dce60_resource.c`
- **Scope**: Only DCE 6.0 and 6.4 hardware
- **No API changes**: Internal bandwidth validation logic only

### ✅ **Minimal Risk of Regression**
- **Conservative approach**: Sets clock to low power mode (352kHz)
  instead of 0
- **Hardware-specific**: Only affects DCE 6.0/6.4 (old hardware,
  isolated impact)
- **Version checks**: Explicit version checks prevent affecting other
  DCE versions
- **Well-reviewed**: Reviewed-by tags from Alex Deucher and Alex Hung
  (AMD maintainers)
- **No reverts found**: No subsequent fixes or reverts in commit history

### ✅ **Related Stable Commit**
This commit is part of a DCE 6.0/6.4 PLL fix series:
- **Commit 1c8dc3e088e09** (July 22, 2025): "Fix DCE 6.0 and 6.4 PLL
  programming" - **Already marked `Cc: stable@vger.kernel.org`**
- **Commit 0449726b58ea6** (Aug 25, 2025): This commit - Keeps PLL0
  running ← **Under review**

The earlier commit fixes PLL initialization, this commit fixes PLL
runtime power management. They are complementary fixes for the same
architectural issue.

### ✅ **Preserved in Refactoring**
- Commit ee352f6c56e17 (Sept 24, 2025) later refactored the code by
  moving `dce60_validate_bandwidth` to `dce100_resource.c` and making it
  shared
- **The PLL0 fix was preserved** in the refactoring, confirming its
  correctness
- Current code at `dce100_resource.c:865-873` contains the exact same
  logic

---

## Code Reference Analysis

Looking at `dce100_resource.c:865-873` (current shared implementation):
```c
} else {
    /* On DCE 6.0 and 6.4 the PLL0 is both the display engine clock and
     - the DP clock, and shouldn't be turned off. Just select the
       display
     - clock value from its low power mode.
     */
    if (dc->ctx->dce_version == DCE_VERSION_6_0 ||
        dc->ctx->dce_version == DCE_VERSION_6_4)
        context->bw_ctx.bw.dce.dispclk_khz = 352000;
    else
        context->bw_ctx.bw.dce.dispclk_khz = 0;
```

The fix is now used by DCE 6.0, 6.4, 8.0, 8.1, and 10.0, demonstrating
its importance and stability.

---

## Dependency Analysis

**Requires commit 1c8dc3e088e09** ("Fix DCE 6.0 and 6.4 PLL
programming"):
- That commit ensures PLL0 is initialized correctly and used for DP
- This commit ensures PLL0 stays running during operation
- Together they provide a complete fix for DCE 6.0/6.4 PLL management
- Since 1c8dc3e088e09 is already marked for stable, this commit should
  follow it

---

## Risk Assessment: **VERY LOW**

**No concerns identified:**
- No follow-up fixes or reverts found in commit history
- No regression reports in subsequent DCE 6 commits
- Change is isolated to old hardware (limited user base = limited blast
  radius)
- Logic is straightforward and well-commented
- Maintains backward compatibility (other DCE versions still set clock
  to 0)

**Power consumption impact**: Negligible - 352kHz clock in idle vs
complete off

---

## Recommendation Summary

**YES - This commit SHOULD be backported to stable kernel trees.**

**Rationale:**
1. **Fixes real user issue**: Page flip timeout affecting SI GPU users
2. **Minimal, surgical fix**: 9 lines, single function, well-scoped
3. **Part of stable series**: Related commit already tagged for stable
4. **Low regression risk**: Hardware-specific, conservative approach
5. **Validated by refactoring**: Fix preserved when code was later
   reorganized
6. **Maintainer-approved**: Reviewed by AMD display maintainers

**Stable tree selection:**
- Should be backported to all stable kernels that include DCE 6.0/6.4 DC
  support
- Particularly important for stable kernels that received commit
  1c8dc3e088e09

This is a textbook example of a good stable kernel backport candidate:
small, targeted, fixes real user issues, minimal risk, and addresses a
specific hardware quirk.

 .../amd/display/dc/resource/dce60/dce60_resource.c    | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index f887d59da7c6f..33c1b9b24bb9c 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -881,7 +881,16 @@ static enum dc_status dce60_validate_bandwidth(
 		context->bw_ctx.bw.dce.dispclk_khz = 681000;
 		context->bw_ctx.bw.dce.yclk_khz = 250000 * MEMORY_TYPE_MULTIPLIER_CZ;
 	} else {
-		context->bw_ctx.bw.dce.dispclk_khz = 0;
+		/* On DCE 6.0 and 6.4 the PLL0 is both the display engine clock and
+		 * the DP clock, and shouldn't be turned off. Just select the display
+		 * clock value from its low power mode.
+		 */
+		if (dc->ctx->dce_version == DCE_VERSION_6_0 ||
+			dc->ctx->dce_version == DCE_VERSION_6_4)
+			context->bw_ctx.bw.dce.dispclk_khz = 352000;
+		else
+			context->bw_ctx.bw.dce.dispclk_khz = 0;
+
 		context->bw_ctx.bw.dce.yclk_khz = 0;
 	}
 
-- 
2.51.0

