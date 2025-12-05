Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9D7081E;
	Fri,  5 Dec 2025 03:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764906768; cv=none; b=cscctUroS+AmFuCrHHn16mAOtlZUV+k+gH4y772iRaXVtSVSYv4ZrWhxh7yI8Y8gZEb/MooTtE54U831GvSbOni2dOZ6mSrZicYjRo/i25bzwAldvNWm6i9+XY6SZSfeXvCuB266QqvtgQS7ISFuH/LF/0fnm+cruT26uAKCHjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764906768; c=relaxed/simple;
	bh=MV/23AP5FsZ8LOx9H2Lc0pIfQ6DWxX91Yu2pkRk5kGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTXBjcUQRN9OVm7j55cXilLoaHwfE0Q7aZygJMoa3NCBBbNPerTQF1ee46jlb6KzSScOwp/AxVAFuj/e2jX7wb4I9FAMI/8M/wvkBvvlwTllQ8hM87l7hf6N1ovHBTAlF/gGZSgJcvS2v45cxWUznqVly6mxuvCszz5c2lt+Tlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asbtEe6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asbtEe6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9D6C4CEF1;
	Fri,  5 Dec 2025 03:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764906768;
	bh=MV/23AP5FsZ8LOx9H2Lc0pIfQ6DWxX91Yu2pkRk5kGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asbtEe6F/XfGCYWkqoHaZZw1SI8cq9GllwfDX80OJNAaDoTqYUcJaAhMfXeQHdzaY
	 /danIh39QBmMuXGdabDyamlf5IEfiIIWRASLGsW5kW2Pin2wFTMu1v5Bedd201Bbiq
	 whZ4mg0X3xAnNQ0NSmdCeN+kLI5KPSF9cyeHjF2EAWbGiVU3ilqzCiptSAiaoQ5nn0
	 G0a0wQAje7NLOPyW7zEhJsNZRkG2c7OlBKlQuoKQQJ3tvK0DP4lafP9MPrbTOzAE/O
	 M8FHv3c4Qel1GfcnzX9QL6rYoUocCmIfTHwTI6fFMoQ9Fpd+HxGvXVrYtD0SMHFUV1
	 1trNaRfJsh3Rg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Peng <pengyu@kylinos.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.18] x86/microcode: Mark early_parse_cmdline() as __init
Date: Thu,  4 Dec 2025 22:52:32 -0500
Message-ID: <20251205035239.341989-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205035239.341989-1-sashal@kernel.org>
References: <20251205035239.341989-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit ca8313fd83399ea1d18e695c2ae9b259985c9e1f ]

Fix section mismatch warning reported by modpost:

  .text:early_parse_cmdline() -> .init.data:boot_command_line

The function early_parse_cmdline() is only called during init and accesses
init data, so mark it __init to match its usage.

  [ bp: This happens only when the toolchain fails to inline the function and
    I haven't been able to reproduce it with any toolchain I'm using. Patch is
    obviously correct regardless. ]

Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/all/20251030123757.1410904-1-pengyu@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: `x86/microcode: Mark early_parse_cmdline() as __init`

**Problem**: Fixes a modpost section mismatch warning:
```
.text:early_parse_cmdline() -> .init.data:boot_command_line
```

**Context**: The function is only called during init (from
`load_ucode_bsp()` which is `__init`) and accesses `boot_command_line`
(declared as `__initdata` in `.init.data`). The maintainer notes this
occurs when the toolchain fails to inline the function, but the fix is
correct regardless.

**Signals**:
- No "Cc: stable@vger.kernel.org" tag
- No "Fixes:" tag
- Signed-off by maintainer (Borislav Petkov)

### 2. CODE CHANGE ANALYSIS

**Change**: Adds `__init` attribute to `early_parse_cmdline()`:
```c
-static void early_parse_cmdline(void)
+static void __init early_parse_cmdline(void)
```

**Technical details**:
- `__init` places the function in `.init.text` (discarded after boot)
- `boot_command_line` is `__initdata` (in `.init.data`)
- A function in `.text` accessing `.init.data` triggers a section
  mismatch
- Marking the function `__init` aligns it with its usage

**Root cause**: Missing `__init` annotation on a function only used
during initialization.

**Correctness**: Correct. The function is only called from
`load_ucode_bsp()` (line 172), which is `__init`, so marking it `__init`
matches its usage.

### 3. CLASSIFICATION

**Type**: Build fix (section mismatch)

**Not**:
- A new feature
- A runtime bug fix
- A security fix
- A performance optimization

**Is**:
- A build error fix (modpost can fail builds)
- A code organization fix (correct section placement)

### 4. BUILD IMPACT ANALYSIS

From `scripts/mod/modpost.c` (lines 2373-2375):
```c
if (sec_mismatch_count && !sec_mismatch_warn_only)
    error("Section mismatches detected.\n"
          "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
```

And `scripts/Makefile.modpost` (line 49):
```makefile
$(if $(CONFIG_SECTION_MISMATCH_WARN_ONLY),,-E)
```

**Impact**:
- Section mismatches cause build failures unless
  `CONFIG_SECTION_MISMATCH_WARN_ONLY=y`
- This is a build error fix, which stable rules allow
- Similar fixes have been backported (e.g., `b452d2c97eecc` for
  clocksource driver)

### 5. SCOPE AND RISK ASSESSMENT

**Lines changed**: 1 line (attribute addition)

**Files touched**: 1 file (`arch/x86/kernel/cpu/microcode/core.c`)

**Complexity**: Trivial — attribute addition only

**Risk**: Very low
- No logic change
- No runtime behavior change
- Only affects section placement
- Function already only used during init

**Subsystem**: x86 microcode (mature, critical)

### 6. USER IMPACT

**Who is affected**:
- Users building kernels without `CONFIG_SECTION_MISMATCH_WARN_ONLY=y`
- Distribution kernel builders
- Anyone building with strict modpost checks

**Severity**: Build failure (prevents compilation)

**Frequency**: Depends on toolchain inlining behavior; can be
intermittent

### 7. STABILITY INDICATORS

**Tested-by**: None
**Reviewed-by**: None (maintainer signed off)
**Age**: Very recent (Oct 30, 2025) — not yet in a released kernel

### 8. DEPENDENCY CHECK

**Parent commit**: `632ff61706473` ("x86/microcode: Add microcode=
cmdline parsing") introduced `early_parse_cmdline()` on Aug 20, 2025,
and is in v6.18.

**Dependency analysis**:
- This fix only applies if the parent commit exists in the target stable
  tree
- If the function doesn't exist in stable, this fix isn't needed
- If the feature is backported, this fix should be included

**Backport considerations**:
- Applies cleanly if the parent commit is present
- No API changes or complex dependencies
- Self-contained

### 9. STABLE KERNEL RULES EVALUATION

From `Documentation/process/stable-kernel-rules.rst`:

1. "It must be obviously correct and tested" — Yes, correct and
   maintainer-approved
2. "It must fix a real bug" — Yes, fixes a build error
3. "It fixes a problem like... a build error" — Yes, explicitly allowed
4. "It must be small and contained" — Yes, 1-line change
5. "It must NOT introduce new features" — Correct, no new functionality
6. "It must apply cleanly" — Yes, if parent commit exists

**Conclusion**: Meets all criteria for stable inclusion.

### 10. COMPARISON WITH SIMILAR COMMITS

Similar section mismatch fixes have been backported:
- `b452d2c97eecc` ("clocksource/drivers/nxp-stm: Fix section
  mismatches") includes `Cc: stable@vger.kernel.org # 6.16`

This commit follows the same pattern and should be treated similarly.

### 11. FINAL ASSESSMENT

**Should this be backported?** Yes, with a caveat.

**Rationale**:
1. Fixes a build error (not just a warning)
2. Obviously correct
3. Minimal risk (attribute addition)
4. Small and self-contained
5. Meets stable kernel criteria

**Caveat**:
- Only applicable if commit `632ff61706473` exists in the target stable
  tree
- If backporting the feature, include this fix
- If the feature isn't in stable, this fix isn't needed

**Recommendation**: Backport to stable trees that include the
`early_parse_cmdline()` function (v6.18+ or if the feature was
backported to older trees).

**YES**

 arch/x86/kernel/cpu/microcode/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index f75c140906d00..539edd6d6dc8c 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -136,7 +136,7 @@ bool __init microcode_loader_disabled(void)
 	return dis_ucode_ldr;
 }
 
-static void early_parse_cmdline(void)
+static void __init early_parse_cmdline(void)
 {
 	char cmd_buf[64] = {};
 	char *s, *p = cmd_buf;
-- 
2.51.0

