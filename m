Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6C930AD1B;
	Sat, 25 Oct 2025 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409027; cv=none; b=WZK7yymgoxQ/kdfolbpmeJsiBoVR+P5gfJKZaVOHKaf/ynfvhkjB8z8wEDTxZzN7URF4ugCwqG7/ywfpcAcBiUYemOYnwmSuxBidLwkKVjeadN64UTQv1hhcwmVR+NE3/w3g0Kpatn/kANivPdie0vI9i4i4U8n5kH41iU/cLRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409027; c=relaxed/simple;
	bh=MoH9ZlRMO15EnPBy7/XmWAPMoa9PryAQgktoC1TqlJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIK/Is1+3Ajj6ZIXuFMEgPbGrMBWGr0fMSkRRPPxuxzrliGeTRc2E1l1LfV0VOM4Iw8Ez42hikp5lHMuOsIpZdxyOeBCHTNoLJ9VgqfGzzr/fES5v1v4Jil/m732a2/dL99wcGz6bD3exV8tWD2rvtdOg73mhgAFDHlPcw13Qac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mz3r5xtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mz3r5xtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4107FC4CEFF;
	Sat, 25 Oct 2025 16:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409026;
	bh=MoH9ZlRMO15EnPBy7/XmWAPMoa9PryAQgktoC1TqlJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mz3r5xtUlcUw9loTUCqqeGTuJAbfsJMbpzlCbDOzWaY17T6+lkpOBH34CP9sr5zUx
	 l5j9I40sA0oGzbhZwhB/dT05qMisMjRM0ZUfm2FCkDVrSFTT7CNdzEacruZWgfh47l
	 8Il82iLCRDCj8DpyZmAOg4aOqiLaLF4HfIZGs09fkJgouJkvs/Y90w2FwP9UphsIC9
	 j1PvWb/kXygZY5Ga5P5j4aGiOuTn6EmmJz5Uvg1l5GdResRkq9YF2Fukrypn0B4pGH
	 IxFnMph2zlXWpnptc1tnEI1HAnamLIoU81S7VDM/ARw0iRp7BWmRmD0S1PYSnjtVQI
	 2y1GWPj5Y9S+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xi Ruoyao <xry111@xry111.site>,
	Asiacn <710187964@qq.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Austin.Zheng@amd.com,
	aurabindo.pillai@amd.com,
	ray.wu@amd.com,
	chenhuacai@kernel.org,
	dillon.varone@amd.com,
	rostrows@amd.com,
	alexandre.f.demers@gmail.com,
	karthi.kandasamy@amd.com,
	wenjing.liu@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display/dml2: Guard dml21_map_dc_state_into_dml_display_cfg with DC_FP_START
Date: Sat, 25 Oct 2025 11:56:45 -0400
Message-ID: <20251025160905.3857885-174-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit c97a7dccb3ed680031011cfc1457506e6de49c9a ]

dml21_map_dc_state_into_dml_display_cfg calls (the call is usually
inlined by the compiler) populate_dml21_surface_config_from_plane_state
and populate_dml21_plane_config_from_plane_state which may use FPU.  In
a x86-64 build:

    $ objdump --disassemble=dml21_map_dc_state_into_dml_display_cfg \
    > drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.o |
    > grep %xmm -c
    63

Thus it needs to be guarded with DC_FP_START.  But we must note that the
current code quality of the in-kernel FPU use in AMD dml2 is very much
problematic: we are actually calling DC_FP_START in dml21_wrapper.c
here, and this translation unit is built with CC_FLAGS_FPU.  Strictly
speaking this does not make any sense: with CC_FLAGS_FPU the compiler is
allowed to generate FPU uses anywhere in the translated code, perhaps
out of the DC_FP_START guard.  This problematic pattern also occurs in
at least dml2_wrapper.c, dcn35_fpu.c, and dcn351_fpu.c.  Thus we really
need a careful audit and refactor for the in-kernel FPU uses, and this
patch is simply whacking a mole.  However per the reporter, whacking
this mole is enough to make a 9060XT "just work."

Reported-by: Asiacn <710187964@qq.com>
Closes: https://github.com/loongson-community/discussions/issues/102
Tested-by: Asiacn <710187964@qq.com>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit, I can now provide my
backporting recommendation.

## **BACKPORT DECISION: YES**

This commit **SHOULD be backported** to stable kernel trees.

---

## **DETAILED ANALYSIS AND JUSTIFICATION**

### **1. NATURE OF THE BUG**

The commit fixes **unprotected FPU (Floating Point Unit) usage** in the
AMD display driver. The function
`dml21_map_dc_state_into_dml_display_cfg()` contains floating-point
operations but was being called without proper kernel FPU protection
guards.

**Evidence from the code:**
- The commit message shows `objdump` analysis revealing **63 uses of
  %xmm registers** (SSE/FPU instructions) in the compiled function
- In the source code at `drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21
  _translation_helper.c:779-987`, I found the actual FPU operations:
  ```c
  surface->dcc.informative.dcc_rate_plane0 = 1.0;  // Line 791
  surface->dcc.informative.dcc_rate_plane1 = 1.0;  // Line 792

  plane->composition.scaler_info.plane0.h_ratio =
  (double)scaler_data->ratios.horz.value / (1ULL << 32);  // Line 903
  plane->composition.scaler_info.plane0.v_ratio =
  (double)scaler_data->ratios.vert.value / (1ULL << 32);  // Line 904
  plane->composition.scaler_info.plane1.h_ratio =
  (double)scaler_data->ratios.horz_c.value / (1ULL << 32);  // Line 905
  plane->composition.scaler_info.plane1.v_ratio =
  (double)scaler_data->ratios.vert_c.value / (1ULL << 32);  // Line 906
  ```

### **2. ROOT CAUSE AND REGRESSION TIMELINE**

Through my investigation, I discovered this is a **regression fix**:

- **v6.15**: Commit `366e77cd4923c` ("Protect FPU in
  dml2_validate()/dml21_validate()") added DC_FP_START/END around the
  entire `dml21_validate()` function - **WORKING**
  - This commit had `Cc: stable@vger.kernel.org` tag
  - It fixed "do_fpu invoked from kernel context" crashes on LoongArch

- **v6.16**: Commit `fe3250f10819b` ("Call FP Protect Before Mode
  Programming/Mode Support") refactored the code and moved FP protection
  to individual calls
  - It protected `dml2_build_mode_programming()` and
    `dml2_check_mode_supported()`
  - **BUT IT MISSED `dml21_map_dc_state_into_dml_display_cfg()`** -
    **BROKEN**

- **v6.18-rc1**: Current commit `c97a7dccb3ed6` adds the missing
  protection - **FIXED**

**Affected kernel versions:** v6.16 and v6.17 (including all stable
releases) have the regression.

### **3. THE FIX**

The fix is **minimal and surgical**:

```diff
@@ -224,7 +224,9 @@ static bool dml21_mode_check_and_programming(...)
        /* Populate stream, plane mappings and other fields in display
config. */
+       DC_FP_START();
        result = dml21_map_dc_state_into_dml_display_cfg(in_dc, context,
dml_ctx);
+       DC_FP_END();
        if (!result)
                return false;

@@ -279,7 +281,9 @@ static bool dml21_check_mode_support(...)
        mode_support->dml2_instance = dml_init->dml2_instance;
+       DC_FP_START();
        dml21_map_dc_state_into_dml_display_cfg(in_dc, context,
dml_ctx);
+       DC_FP_END();
```

**Total change: 4 lines added** (2 × DC_FP_START, 2 × DC_FP_END)

The `DC_FP_START()` and `DC_FP_END()` macros call `kernel_fpu_begin()`
and `kernel_fpu_end()` which:
1. Disable preemption
2. Save current FPU state
3. Allow safe FPU usage in kernel context
4. Restore FPU state afterward

### **4. USER-VISIBLE IMPACT**

**Severity:** Hardware doesn't work or kernel crashes

**Affected users:**
- AMD Radeon GPU users on LoongArch systems (confirmed: makes 9060XT
  "just work")
- Potentially affects other architectures with strict FPU handling

**Evidence:**
- `Reported-by: Asiacn <710187964@qq.com>`
- `Closes: https://github.com/loongson-community/discussions/issues/102`
- `Tested-by: Asiacn <710187964@qq.com>` - Confirms it works
- Similar to commit 366e77cd4923c which showed kernel crashes with stack
  traces

### **5. BACKPORTING CRITERIA ASSESSMENT**

| Criterion | Status | Evidence |
|-----------|--------|----------|
| **Fixes important bug** | ✅ YES | Kernel crashes, hardware not working
|
| **Small and contained** | ✅ YES | Only 4 lines, 1 file changed |
| **Minimal regression risk** | ✅ YES | Only adds protection guards
around existing code |
| **Confined to subsystem** | ✅ YES | AMD display driver only |
| **Tested** | ✅ YES | Has Tested-by tag |
| **Reviewed** | ✅ YES | Reviewed by Loongson and AMD engineers |
| **Clear root cause** | ✅ YES | Detailed commit message with objdump
evidence |

### **6. CODE QUALITY OBSERVATIONS**

The commit message honestly acknowledges broader architectural issues:
> "the current code quality of the in-kernel FPU use in AMD dml2 is very
much problematic... this patch is simply whacking a mole"

However, it also states:
> "whacking this mole is enough to make a 9060XT 'just work.'"

This pragmatic fix is **necessary and correct** even if larger
refactoring is needed long-term.

### **7. MISSING STABLE TAGS (Should Have)**

❌ No `Fixes:` tag (should be: `Fixes: fe3250f10819b`)
❌ No `Cc: stable@vger.kernel.org`

**This appears to be an oversight**, not a deliberate exclusion,
because:
- The earlier related commit 366e77cd4923c had `Cc:
  stable@vger.kernel.org`
- This is part of the same ongoing FPU protection effort
- It fixes a clear regression with user-visible impact

### **8. RISK ANALYSIS**

**Risk of backporting:** **VERY LOW**
- Change is minimal (only adds guards)
- Guards are well-established pattern used throughout the codebase
- No logic changes, no new features
- Matches pattern of already-backported commit 366e77cd4923c

**Risk of NOT backporting:** **HIGH**
- Users with AMD GPUs on LoongArch cannot use their hardware
- Potential kernel crashes and FPU state corruption
- v6.16 and v6.17 remain broken

---

## **CONCLUSION**

This is a **clear-cut backport candidate** that fixes a regression
introduced in v6.16, has been tested, is minimal in scope, and has very
low risk. The lack of stable tags appears to be an oversight rather than
intentional exclusion.

**Recommended for backport to:**
- v6.17.x stable (actively maintained)
- v6.16.x stable (if still maintained)

 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index 03de3cf06ae59..059ede6ff2561 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -224,7 +224,9 @@ static bool dml21_mode_check_and_programming(const struct dc *in_dc, struct dc_s
 	dml_ctx->config.svp_pstate.callbacks.release_phantom_streams_and_planes(in_dc, context);
 
 	/* Populate stream, plane mappings and other fields in display config. */
+	DC_FP_START();
 	result = dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
+	DC_FP_END();
 	if (!result)
 		return false;
 
@@ -279,7 +281,9 @@ static bool dml21_check_mode_support(const struct dc *in_dc, struct dc_state *co
 	dml_ctx->config.svp_pstate.callbacks.release_phantom_streams_and_planes(in_dc, context);
 
 	mode_support->dml2_instance = dml_init->dml2_instance;
+	DC_FP_START();
 	dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
+	DC_FP_END();
 	dml_ctx->v21.mode_programming.dml2_instance->scratch.build_mode_programming_locals.mode_programming_params.programming = dml_ctx->v21.mode_programming.programming;
 	DC_FP_START();
 	is_supported = dml2_check_mode_supported(mode_support);
-- 
2.51.0

